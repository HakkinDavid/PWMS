import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import 'package:platinum_world_management_system/src/core/storage/app_settings_repository.dart';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;
import '../domain/numismatic_recognition_models.dart';
import 'numismatic_quick_fill_sheet.dart';

class GuidedDualScanWidget extends ConsumerStatefulWidget {
  final String? initialLocationId;
  final Function(NumismaticScanResult result)? onScannedResult;

  const GuidedDualScanWidget({
    super.key,
    this.initialLocationId,
    this.onScannedResult,
  });

  @override
  ConsumerState<GuidedDualScanWidget> createState() => _GuidedDualScanWidgetState();
}

class _GuidedDualScanWidgetState extends ConsumerState<GuidedDualScanWidget> with SingleTickerProviderStateMixin {
  static List<CameraDescription>? _cachedCameras;
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  bool _isCameraInitialized = false;
  bool _isProcessing = false;
  bool _showQuickFillForm = false;
  String? _statusMessage;

  // Cached Settings & Preferences
  bool _isTorchOn = false;
  bool _isAutoCaptureEnabled = false;
  double _exposureOffset = -1.5; // -1.5 EV por defecto para evitar quemados en metal
  bool _isCoinMode = true; // True for Coin (Circle), False for Banknote (Rectangle)

  // Auto-detection & Locking State
  bool _isTargetLocked = false;
  int _stableFrameCount = 0;
  DateTime _lastFrameAnalysisTime = DateTime.now();

  // Tap-to-focus coordinates
  Offset? _tapFocusPoint;

  // 1: Obverse, 2: Reverse
  int _currentStep = 1;
  File? _obverseFile;
  File? _reverseFile;

  // Zoom
  double _currentZoom = 1.0;
  double _maxZoom = 4.0;
  double _minZoom = 1.0;

  @override
  void initState() {
    super.initState();
    _loadCachedSettingsAndInitCamera();
  }

  Future<void> _loadCachedSettingsAndInitCamera() async {
    try {
      final settings = ref.read(appSettingsRepositoryProvider);
      final autoCap = await settings.getNumismaticAutoCapture(defaultValue: false);
      final torch = await settings.getNumismaticTorchEnabled(defaultValue: false);
      final ev = await settings.getNumismaticExposureOffset(defaultValue: -1.5);
      final defaultMode = await settings.getNumismaticDefaultMode();

      if (mounted) {
        setState(() {
          _isAutoCaptureEnabled = autoCap;
          _isTorchOn = torch;
          _exposureOffset = ev;
          if (defaultMode != null) {
            _isCoinMode = defaultMode == 'coin';
          }
        });
      }
    } catch (_) {}

    await _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    if (!mounted) return;
    try {
      _cameras = _cachedCameras ?? await availableCameras();
      _cachedCameras = _cameras;

      if (_cameras.isNotEmpty) {
        final backCam = _cameras.firstWhere(
          (c) => c.lensDirection == CameraLensDirection.back,
          orElse: () => _cameras.first,
        );

        // Previsualización fluida en 1080p con arranque instantáneo y captura en alta definición
        final presetsToTry = [
          ResolutionPreset.veryHigh,
          ResolutionPreset.high,
          ResolutionPreset.max,
        ];

        CameraController? controller;
        for (final preset in presetsToTry) {
          try {
            final c = CameraController(
              backCam,
              preset,
              enableAudio: false,
              imageFormatGroup: ImageFormatGroup.jpeg,
            );
            await c.initialize();
            controller = c;
            break;
          } catch (_) {}
        }

        if (controller == null) {
          throw Exception('No se pudo inicializar la cámara trasera.');
        }

        _cameraController = controller;
        if (!mounted) return;

        _maxZoom = await _cameraController!.getMaxZoomLevel();
        _minZoom = await _cameraController!.getMinZoomLevel();

        // Configuración paralela de 3A, Spot Metering y Compensación EV
        try {
          await _cameraController!.setFocusMode(FocusMode.auto);
          await _cameraController!.setExposureMode(ExposureMode.auto);
          await _cameraController!.setFocusPoint(const Offset(0.5, 0.5));
          await _cameraController!.setExposurePoint(const Offset(0.5, 0.5));

          final minEv = await _cameraController!.getMinExposureOffset();
          final maxEv = await _cameraController!.getMaxExposureOffset();
          final targetEv = _exposureOffset.clamp(minEv, maxEv);
          await _cameraController!.setExposureOffset(targetEv);

          if (_isTorchOn) {
            await _cameraController!.setFlashMode(FlashMode.torch);
          }
        } catch (_) {}

        if (mounted) {
          setState(() {
            _isCameraInitialized = true;
            _statusMessage = null;
          });
          _syncImageStream();
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _statusMessage = 'Error al inicializar cámara: $e';
        });
      }
    }
  }

  @override
  void dispose() {
    _stopImageStreamSafe();
    if (_isTorchOn && _cameraController != null && _cameraController!.value.isInitialized) {
      _cameraController?.setFlashMode(FlashMode.off).catchError((_) {});
    }
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _stopImageStreamSafe() async {
    try {
      if (_cameraController != null &&
          _cameraController!.value.isInitialized &&
          _cameraController!.value.isStreamingImages) {
        await _cameraController!.stopImageStream();
      }
    } catch (_) {}
  }

  Future<void> _syncImageStream() async {
    if (!_isCameraInitialized || _cameraController == null || _isProcessing || _showQuickFillForm) {
      await _stopImageStreamSafe();
      return;
    }

    if (_isAutoCaptureEnabled) {
      if (!_cameraController!.value.isStreamingImages) {
        try {
          await _cameraController!.startImageStream(_handleCameraFrame);
        } catch (_) {}
      }
    } else {
      await _stopImageStreamSafe();
      if (mounted && _isTargetLocked) {
        setState(() => _isTargetLocked = false);
      }
    }
  }

  void _handleCameraFrame(CameraImage image) {
    if (!_isAutoCaptureEnabled || _isProcessing || !mounted) return;

    final now = DateTime.now();
    if (now.difference(_lastFrameAnalysisTime).inMilliseconds < 120) {
      return;
    }
    _lastFrameAnalysisTime = now;

    final isCandidate = _analyzeFrameCandidate(image);

    if (isCandidate) {
      _stableFrameCount++;
      if (_stableFrameCount >= 3) {
        if (!_isTargetLocked && mounted) {
          setState(() => _isTargetLocked = true);
        }
        if (_stableFrameCount >= 4) {
          _stableFrameCount = 0;
          _triggerAutoCapture();
        }
      }
    } else {
      if (_stableFrameCount > 0) {
        _stableFrameCount = 0;
      }
      if (_isTargetLocked && mounted) {
        setState(() => _isTargetLocked = false);
      }
    }
  }

  bool _analyzeFrameCandidate(CameraImage image) {
    try {
      if (image.planes.isEmpty) return false;
      final plane = image.planes[0];
      final bytes = plane.bytes;
      if (bytes.isEmpty) return false;

      final w = image.width;
      final h = image.height;
      final rowStride = plane.bytesPerRow;

      int getLum(double nx, double ny) {
        final px = (nx * (w - 1)).clamp(0, w - 1).toInt();
        final py = (ny * (h - 1)).clamp(0, h - 1).toInt();
        final idx = py * rowStride + px;
        return (idx >= 0 && idx < bytes.length) ? bytes[idx] : 128;
      }

      if (_isCoinMode) {
        // Flujo Moneda: Detección de contraste radial perimetral
        const int numAngles = 12;
        const double innerR = 0.28;
        const double outerR = 0.42;

        int edgeTransitions = 0;
        int totalDelta = 0;

        for (int i = 0; i < numAngles; i++) {
          final angle = (2 * math.pi * i) / numAngles;
          final inX = 0.5 + innerR * math.cos(angle);
          final inY = 0.5 + innerR * math.sin(angle);
          final outX = 0.5 + outerR * math.cos(angle);
          final outY = 0.5 + outerR * math.sin(angle);

          final delta = (getLum(inX, inY) - getLum(outX, outY)).abs();
          totalDelta += delta;
          if (delta > 14) {
            edgeTransitions++;
          }
        }

        final avgDelta = totalDelta / numAngles;
        return avgDelta >= 15 && edgeTransitions >= 7;
      } else {
        // Flujo Billete: Detección de contraste en 4 bordes rectangulares
        const double hw = 0.38;
        const double hh = 0.25;

        int borderHits = 0;
        // Top & Bottom edges
        for (double fx = 0.25; fx <= 0.75; fx += 0.25) {
          final topIn = getLum(fx, 0.5 - hh * 0.85);
          final topOut = getLum(fx, 0.5 - hh * 1.15);
          if ((topIn - topOut).abs() > 14) borderHits++;

          final botIn = getLum(fx, 0.5 + hh * 0.85);
          final botOut = getLum(fx, 0.5 + hh * 1.15);
          if ((botIn - botOut).abs() > 14) borderHits++;
        }
        // Left & Right edges
        for (double fy = 0.35; fy <= 0.65; fy += 0.3) {
          final leftIn = getLum(0.5 - hw * 0.85, fy);
          final leftOut = getLum(0.5 - hw * 1.15, fy);
          if ((leftIn - leftOut).abs() > 14) borderHits++;

          final rightIn = getLum(0.5 + hw * 0.85, fy);
          final rightOut = getLum(0.5 + hw * 1.15, fy);
          if ((rightIn - rightOut).abs() > 14) borderHits++;
        }

        return borderHits >= 5;
      }
    } catch (_) {
      return false;
    }
  }

  Future<void> _triggerAutoCapture() async {
    if (_isProcessing || !_isCameraInitialized) return;
    HapticFeedback.mediumImpact();
    await _stopImageStreamSafe();
    await _capturePhoto();
    if (_isAutoCaptureEnabled && mounted && !_showQuickFillForm) {
      _syncImageStream();
    }
  }

  Future<void> _toggleAutoCapture(bool val) async {
    setState(() {
      _isAutoCaptureEnabled = val;
      _isTargetLocked = false;
      _stableFrameCount = 0;
    });
    try {
      final settings = ref.read(appSettingsRepositoryProvider);
      settings.setNumismaticAutoCapture(val).catchError((_) {});
    } catch (_) {}
    await _syncImageStream();
  }

  Future<void> _toggleTorch() async {
    if (_cameraController == null || !_isCameraInitialized) return;
    try {
      final newTorch = !_isTorchOn;
      await _cameraController!.setFlashMode(newTorch ? FlashMode.torch : FlashMode.off);
      if (mounted) {
        setState(() {
          _isTorchOn = newTorch;
        });
      }
      final settings = ref.read(appSettingsRepositoryProvider);
      settings.setNumismaticTorchEnabled(newTorch).catchError((_) {});
    } catch (_) {}
  }

  Future<void> _switchMode(bool isCoin) async {
    setState(() {
      _isCoinMode = isCoin;
      _isTargetLocked = false;
      _stableFrameCount = 0;
    });
    try {
      final settings = ref.read(appSettingsRepositoryProvider);
      settings.setNumismaticDefaultMode(isCoin ? 'coin' : 'banknote').catchError((_) {});
    } catch (_) {}
  }

  Future<void> _handleTapToFocus(TapDownDetails details, BoxConstraints constraints) async {
    if (_cameraController == null || !_isCameraInitialized) return;
    final double dx = details.localPosition.dx / constraints.maxWidth;
    final double dy = details.localPosition.dy / constraints.maxHeight;
    final offset = Offset(dx.clamp(0.0, 1.0), dy.clamp(0.0, 1.0));

    try {
      setState(() {
        _tapFocusPoint = details.localPosition;
      });
      await _cameraController!.setFocusPoint(offset);
      await _cameraController!.setExposurePoint(offset);
    } catch (_) {}

    Future.delayed(const Duration(milliseconds: 1400), () {
      if (mounted) {
        setState(() {
          _tapFocusPoint = null;
        });
      }
    });
  }

  Future<void> _adjustZoom(double value) async {
    if (_cameraController == null || !_isCameraInitialized || !mounted) return;
    try {
      final zoom = value.clamp(_minZoom, _maxZoom);
      await _cameraController!.setZoomLevel(zoom);
      if (mounted) {
        setState(() {
          _currentZoom = zoom;
        });
      }
    } catch (_) {}
  }

  Future<File> _cropImageCenter(File originalFile) async {
    final bytes = await originalFile.readAsBytes();
    final isCoin = _isCoinMode;
    final originalPath = originalFile.path;
    final result = await compute(_processCropImageIsolate, _CropParams(
      bytes: bytes,
      isCoinMode: isCoin,
      originalPath: originalPath,
    ));

    final croppedFile = File(result.outputPath);
    await croppedFile.writeAsBytes(result.croppedBytes);
    return croppedFile;
  }

  Future<void> _capturePhoto() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized || _isProcessing) return;

    setState(() {
      _isProcessing = true;
      _statusMessage = 'Capturando en alta definición...';
    });

    try {
      await _stopImageStreamSafe();
      final XFile photo = await _cameraController!.takePicture();
      final File rawFile = File(photo.path);

      final File croppedFile = await _cropImageCenter(rawFile);

      if (_currentStep == 1) {
        _obverseFile = croppedFile;
        setState(() {
          _currentStep = 2;
          _isProcessing = false;
          _statusMessage = null;
          _isTargetLocked = false;
        });
      } else {
        _reverseFile = croppedFile;
        setState(() {
          _isProcessing = false;
          _statusMessage = null;
          _isTargetLocked = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isProcessing = false;
          _statusMessage = 'Error en captura: $e';
          _isTargetLocked = false;
        });
      }
    } finally {
      if (_isAutoCaptureEnabled && mounted && !_showQuickFillForm) {
        _syncImageStream();
      }
    }
  }

  Future<void> _processRecognition() async {
    final primaryPhoto = _obverseFile ?? _reverseFile;
    if (primaryPhoto == null) return;

    await _stopImageStreamSafe();
    try {
      await _cameraController?.pausePreview();
    } catch (_) {}

    if (mounted) {
      setState(() {
        _showQuickFillForm = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_showQuickFillForm) {
      final primaryPhoto = _obverseFile ?? _reverseFile!;
      return NumismaticQuickFillSheet(
        obversePhoto: primaryPhoto,
        reversePhoto: _obverseFile != null ? _reverseFile : null,
        isCoin: _isCoinMode,
        initialLocationId: widget.initialLocationId,
        onResultSubmitted: (result) async {
          if (result != null && mounted) {
            widget.onScannedResult?.call(result);
          } else if (mounted) {
            setState(() {
              _showQuickFillForm = false;
            });
            try {
              await _cameraController?.resumePreview();
            } catch (_) {}
            _syncImageStream();
          }
        },
      );
    }

    if (!_isCameraInitialized) {
      return SizedBox(
        height: 400,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                _statusMessage ?? 'Iniciando cámara trasera en máxima resolución...',
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    final activeGuideColor = _isTargetLocked ? Colors.greenAccent.shade400 : Colors.amber;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          // Mode Selector & AutoCapture Switch Row
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilterChip(
                  label: const Text(AppStrings.coinCircularLabel, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  selected: _isCoinMode,
                  onSelected: (val) => _switchMode(true),
                  avatar: const Icon(Icons.circle_outlined, size: 16),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text(AppStrings.banknoteRectangleLabel, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  selected: !_isCoinMode,
                  onSelected: (val) => _switchMode(false),
                  avatar: const Icon(Icons.crop_landscape, size: 16),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: Text(
                    _isAutoCaptureEnabled ? 'Autodisparo' : 'Manual',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: _isAutoCaptureEnabled ? Colors.green.shade800 : null,
                    ),
                  ),
                  selected: _isAutoCaptureEnabled,
                  selectedColor: Colors.green.withAlpha(45),
                  onSelected: _toggleAutoCapture,
                  avatar: Icon(
                    _isAutoCaptureEnabled ? Icons.auto_awesome : Icons.motion_photos_off,
                    size: 16,
                    color: _isAutoCaptureEnabled ? Colors.green.shade700 : Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          // Live Camera Preview with Custom Overlays
          Stack(
            alignment: Alignment.center,
            children: [
              AspectRatio(
                aspectRatio: 1.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return GestureDetector(
                        onTapDown: (details) => _handleTapToFocus(details, constraints),
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: SizedBox(
                            width: 1080,
                            height: 1080 * _cameraController!.value.aspectRatio,
                            child: CameraPreview(_cameraController!),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Frame overlay
              AspectRatio(
                aspectRatio: 1.0,
                child: IgnorePointer(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _isTargetLocked
                            ? Colors.greenAccent.withAlpha(200)
                            : theme.colorScheme.primary.withAlpha(120),
                        width: _isTargetLocked ? 3 : 2,
                      ),
                    ),
                  ),
                ),
              ),

              // Target Overlay
              Positioned.fill(
                child: IgnorePointer(
                  child: _buildTargetOverlay(theme, activeGuideColor),
                ),
              ),

              // Steps Indicator Banner
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _currentStep == 1 ? Icons.looks_one : Icons.looks_two,
                        color: Colors.amber,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _currentStep == 1
                            ? 'PASO 1: ANVERSO'
                            : 'PASO 2: REVERSO',
                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                      ),
                    ],
                  ),
                ),
              ),

              // Torch / Flash button (Macro Illumination)
              Positioned(
                top: 10,
                right: 12,
                child: Material(
                  color: Colors.black54,
                  shape: const CircleBorder(),
                  child: IconButton(
                    iconSize: 20,
                    tooltip: _isTorchOn ? 'Desactivar linterna' : 'Activar linterna (evita barrido)',
                    icon: Icon(
                      _isTorchOn ? Icons.flash_on : Icons.flash_off,
                      color: _isTorchOn ? Colors.amber : Colors.white70,
                    ),
                    onPressed: _toggleTorch,
                  ),
                ),
              ),

              // Lock Status Badge
              if (_isAutoCaptureEnabled)
                Positioned(
                  top: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _isTargetLocked ? Colors.green.shade900.withAlpha(220) : Colors.black54,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _isTargetLocked ? Icons.check_circle : Icons.center_focus_weak,
                          color: _isTargetLocked ? Colors.greenAccent : Colors.white70,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _isTargetLocked ? '¡CENTRADA! DISPARANDO...' : 'ENCUADRA EN LA GUÍA',
                          style: TextStyle(
                            color: _isTargetLocked ? Colors.greenAccent : Colors.white70,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Tap to Focus Reticle Animation
              if (_tapFocusPoint != null)
                Positioned(
                  left: _tapFocusPoint!.dx - 24,
                  top: _tapFocusPoint!.dy - 24,
                  child: IgnorePointer(
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.amber, width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Icon(Icons.center_focus_strong, color: Colors.amber, size: 20),
                      ),
                    ),
                  ),
                )
              else if (!_isAutoCaptureEnabled)
                // Center focus reference
                const IgnorePointer(
                  child: Icon(Icons.center_focus_weak, color: Colors.white54, size: 36),
                ),

              // Zoom Controller Slider Overlay
              Positioned(
                bottom: 12,
                left: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.zoom_out, color: Colors.white, size: 14),
                      Expanded(
                        child: Slider(
                          value: _currentZoom,
                          min: _minZoom,
                          max: _maxZoom,
                          onChanged: _adjustZoom,
                          activeColor: Colors.amber,
                          inactiveColor: Colors.white24,
                        ),
                      ),
                      const Icon(Icons.zoom_in, color: Colors.white, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        '${_currentZoom.toStringAsFixed(1)}x',
                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Preview Thumbnails of Captured Photos (Anverso & Reverso)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Anverso Thumbnail
              _buildThumbnailCard(
                title: 'Anverso',
                file: _obverseFile,
                isSelected: _currentStep == 1,
                onTapSelect: () => setState(() => _currentStep = 1),
                onDelete: () => setState(() {
                  _obverseFile = null;
                  _currentStep = 1;
                }),
                theme: theme,
              ),
              const SizedBox(width: 12),
              // Reverso Thumbnail
              _buildThumbnailCard(
                title: 'Reverso',
                file: _reverseFile,
                isSelected: _currentStep == 2,
                onTapSelect: () => setState(() => _currentStep = 2),
                onDelete: () => setState(() {
                  _reverseFile = null;
                  _currentStep = 2;
                }),
                theme: theme,
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Tip / Guidance banner
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lightbulb_outline, size: 14, color: Colors.amber.shade700),
              const SizedBox(width: 4),
              Text(
                _isAutoCaptureEnabled
                    ? 'Autocaptura activa: mantén quieto el teléfono sobre el objeto.'
                    : 'Tip: Activa la linterna y Spot Metering para resaltar relieves sin quemar.',
                style: TextStyle(fontSize: 10, color: theme.colorScheme.onSurfaceVariant),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // Status or guidance messages
          if (_statusMessage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                _statusMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),

          // Shutter Button Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _isProcessing ? null : _capturePhoto,
                child: Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _isTargetLocked ? Colors.greenAccent : theme.colorScheme.primary,
                      width: 3,
                    ),
                    color: Colors.transparent,
                  ),
                  padding: const EdgeInsets.all(3),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isProcessing
                          ? Colors.grey
                          : (_isTargetLocked ? Colors.green : theme.colorScheme.primary),
                    ),
                    child: _isProcessing
                        ? const Center(child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                        : Icon(
                            _isCoinMode ? Icons.camera_alt : Icons.crop_free,
                            color: Colors.white,
                            size: 26,
                          ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Send to API Button
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton.icon(
              onPressed: (_obverseFile != null && !_isProcessing) ? _processRecognition : null,
              icon: _isProcessing
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white))
                  : const Icon(Icons.arrow_forward_rounded, size: 20),
              label: const Text(
                'Continuar a Datos Numismáticos',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildThumbnailCard({
    required String title,
    required File? file,
    required bool isSelected,
    required VoidCallback onTapSelect,
    required VoidCallback onDelete,
    required ThemeData theme,
  }) {
    final hasFile = file != null && file.existsSync();

    return InkWell(
      onTap: onTapSelect,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 76,
        height: 76,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? theme.colorScheme.primary : (hasFile ? Colors.grey.shade400 : Colors.grey.shade300),
            width: isSelected ? 2.5 : 1,
          ),
          color: theme.colorScheme.surfaceContainerHighest.withAlpha(80),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (hasFile)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  file,
                  width: 76,
                  height: 76,
                  fit: BoxFit.cover,
                ),
              )
            else
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isSelected ? Icons.add_a_photo : Icons.photo_camera_outlined,
                    color: isSelected ? theme.colorScheme.primary : Colors.grey,
                    size: 26,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? theme.colorScheme.primary : Colors.grey.shade700,
                    ),
                  ),
                ],
              ),

            if (hasFile)
              Positioned(
                bottom: 4,
                left: 4,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

            if (hasFile)
              Positioned(
                top: 4,
                right: 4,
                child: GestureDetector(
                  onTap: onDelete,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, color: Colors.white, size: 12),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTargetOverlay(ThemeData theme, Color guideColor) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        final double height = constraints.maxHeight;

        if (_isCoinMode) {
          // Circle targeting frame
          final double radius = width * 0.35;
          return Stack(
            children: [
              CustomPaint(
                size: Size(width, height),
                painter: _OverlayShadingPainter(
                  isCircle: true,
                  center: Offset(width / 2, height / 2),
                  size: radius * 2,
                ),
              ),
              Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: radius * 2,
                  height: radius * 2,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: guideColor, width: _isTargetLocked ? 3.5 : 2.5),
                    boxShadow: _isTargetLocked
                        ? [BoxShadow(color: Colors.greenAccent.withAlpha(100), blurRadius: 12, spreadRadius: 2)]
                        : null,
                  ),
                ),
              ),
            ],
          );
        } else {
          // Rectangular targeting frame
          final double rectWidth = width * 0.8;
          final double rectHeight = rectWidth * 0.55;
          return Stack(
            children: [
              CustomPaint(
                size: Size(width, height),
                painter: _OverlayShadingPainter(
                  isCircle: false,
                  center: Offset(width / 2, height / 2),
                  size: rectWidth,
                  height: rectHeight,
                ),
              ),
              Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: rectWidth,
                  height: rectHeight,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: guideColor, width: _isTargetLocked ? 3.5 : 2.5),
                    boxShadow: _isTargetLocked
                        ? [BoxShadow(color: Colors.greenAccent.withAlpha(100), blurRadius: 12, spreadRadius: 2)]
                        : null,
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}

class _OverlayShadingPainter extends CustomPainter {
  final bool isCircle;
  final Offset center;
  final double size;
  final double? height;

  _OverlayShadingPainter({
    required this.isCircle,
    required this.center,
    required this.size,
    this.height,
  });

  @override
  void paint(Canvas canvas, Size sizeObj) {
    final backgroundPaint = Paint()..color = Colors.black45;

    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, sizeObj.width, sizeObj.height));

    Path holePath;
    if (isCircle) {
      holePath = Path()
        ..addOval(Rect.fromCircle(center: center, radius: size / 2));
    } else {
      final h = height ?? (size * 0.55);
      holePath = Path()
        ..addRRect(RRect.fromRectAndRadius(
          Rect.fromCenter(center: center, width: size, height: h),
          const Radius.circular(16),
        ));
    }

    final shadowPath = Path.combine(PathOperation.difference, path, holePath);
    canvas.drawPath(shadowPath, backgroundPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _CropParams {
  final Uint8List bytes;
  final bool isCoinMode;
  final String originalPath;

  const _CropParams({
    required this.bytes,
    required this.isCoinMode,
    required this.originalPath,
  });
}

class _CropResult {
  final Uint8List croppedBytes;
  final String outputPath;

  const _CropResult({
    required this.croppedBytes,
    required this.outputPath,
  });
}

_CropResult _processCropImageIsolate(_CropParams params) {
  final image = img.decodeImage(params.bytes);
  if (image == null) {
    return _CropResult(croppedBytes: params.bytes, outputPath: params.originalPath);
  }

  img.Image cropped;

  if (params.isCoinMode) {
    // Recorte cuadrado centrado correspondiente a la guía circular
    final size = (image.width < image.height ? image.width : image.height) * 3 ~/ 4;
    final x = (image.width - size) ~/ 2;
    final y = (image.height - size) ~/ 2;
    cropped = img.copyCrop(image, x: x, y: y, width: size, height: size);
  } else {
    // Recorte rectangular centrado para billetes (proporción ~16:9 / 1.8)
    final width = (image.width * 0.85).toInt();
    final height = (width * 0.55).toInt();
    final x = (image.width - width) ~/ 2;
    final y = (image.height - height) ~/ 2;
    cropped = img.copyCrop(image, x: x, y: y, width: width, height: height);
  }

  // Conservar ultra alta definición (hasta 2560px para nitidez insuperable en relieves y marcas)
  const int maxOutputDimension = 2560;
  if (cropped.width > maxOutputDimension || cropped.height > maxOutputDimension) {
    if (params.isCoinMode) {
      cropped = img.copyResize(cropped, width: maxOutputDimension, height: maxOutputDimension, interpolation: img.Interpolation.linear);
    } else {
      final double ratio = cropped.width / cropped.height;
      cropped = img.copyResize(cropped, width: maxOutputDimension, height: (maxOutputDimension / ratio).toInt(), interpolation: img.Interpolation.linear);
    }
  }

  // Codificación ultrarrápida JPEG calidad 95: nitidez fotográfica profesional sin pérdida perceptible y < 50ms de procesamiento
  final ext = '_cropped.jpg';
  final newPath = params.originalPath.replaceAll(RegExp(r'\.(jpg|jpeg|png)$', caseSensitive: false), '') + ext;
  final Uint8List encodedBytes = Uint8List.fromList(img.encodeJpg(cropped, quality: 95));

  return _CropResult(croppedBytes: encodedBytes, outputPath: newPath);
}

