import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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

class _GuidedDualScanWidgetState extends ConsumerState<GuidedDualScanWidget> {
  static List<CameraDescription>? _cachedCameras;
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  bool _isCameraInitialized = false;
  bool _isProcessing = false;
  bool _showQuickFillForm = false;
  bool _isDisposed = false;
  String? _statusMessage;

  // Cached Settings & Preferences
  bool _isTorchOn = false;
  double _exposureOffset = -1.5; // -1.5 EV por defecto para evitar quemados en metal
  bool _isCoinMode = true; // True for Coin (Circle), False for Banknote (Rectangle)

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
      final torch = await settings.getNumismaticTorchEnabled(defaultValue: false);
      final ev = await settings.getNumismaticExposureOffset(defaultValue: -1.5);
      final zoom = await settings.getNumismaticZoomLevel(defaultValue: 1.0);
      final defaultMode = await settings.getNumismaticDefaultMode();

      if (mounted && !_isDisposed) {
        setState(() {
          _isTorchOn = torch;
          _exposureOffset = ev;
          _currentZoom = zoom;
          if (defaultMode != null) {
            _isCoinMode = defaultMode == 'coin';
          } else {
            _isCoinMode = true; // Por defecto moneda
          }
        });
      }
    } catch (_) {}

    await _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    if (!mounted || _isDisposed) return;
    try {
      _cameras = _cachedCameras ?? await availableCameras();
      _cachedCameras = _cameras;

      if (_cameras.isNotEmpty) {
        final backCam = _cameras.firstWhere(
          (c) => c.lensDirection == CameraLensDirection.back,
          orElse: () => _cameras.first,
        );

        if (_isDisposed || !mounted) return;

        // Previsualización fluida en 1080p con arranque instantáneo y captura en alta definición
        final presetsToTry = [
          ResolutionPreset.veryHigh,
          ResolutionPreset.high,
          ResolutionPreset.max,
        ];

        CameraController? controller;
        for (final preset in presetsToTry) {
          if (_isDisposed || !mounted) break;
          try {
            final c = CameraController(
              backCam,
              preset,
              enableAudio: false,
              imageFormatGroup: ImageFormatGroup.jpeg,
            );
            await c.initialize();
            if (_isDisposed || !mounted) {
              c.dispose().catchError((_) {});
              return;
            }
            controller = c;
            break;
          } catch (_) {}
        }

        if (_isDisposed || !mounted) {
          controller?.dispose().catchError((_) {});
          return;
        }

        if (controller == null) {
          throw Exception('No se pudo inicializar la cámara trasera.');
        }

        _cameraController = controller;

        _maxZoom = await _cameraController!.getMaxZoomLevel().catchError((_) => 4.0);
        _minZoom = await _cameraController!.getMinZoomLevel().catchError((_) => 1.0);

        // Configuración de 3A, Spot Metering, Compensación EV (-1.5 EV), Zoom y Linterna cacheados
        try {
          await _cameraController!.setFocusMode(FocusMode.auto);
          await _cameraController!.setExposureMode(ExposureMode.auto);
          await _cameraController!.setFocusPoint(const Offset(0.5, 0.5));
          await _cameraController!.setExposurePoint(const Offset(0.5, 0.5));

          final minEv = await _cameraController!.getMinExposureOffset().catchError((_) => -2.0);
          final maxEv = await _cameraController!.getMaxExposureOffset().catchError((_) => 2.0);
          final targetEv = _exposureOffset.clamp(minEv, maxEv);
          await _cameraController!.setExposureOffset(targetEv).catchError((_) {});

          if (_currentZoom > 1.0) {
            final targetZoom = _currentZoom.clamp(_minZoom, _maxZoom);
            await _cameraController!.setZoomLevel(targetZoom).catchError((_) {});
          }

          if (_isTorchOn) {
            await _cameraController!.setFlashMode(FlashMode.torch).catchError((_) {});
          }
        } catch (_) {}

        if (mounted && !_isDisposed) {
          setState(() {
            _isCameraInitialized = true;
            _statusMessage = null;
          });
        }
      }
    } catch (e) {
      if (mounted && !_isDisposed) {
        setState(() {
          _statusMessage = 'Error al inicializar cámara: $e';
        });
      }
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    final controller = _cameraController;
    _cameraController = null;
    _isCameraInitialized = false;

    if (controller != null) {
      () async {
        try {
          if (controller.value.isInitialized && _isTorchOn) {
            await controller.setFlashMode(FlashMode.off).catchError((_) {});
          }
          await controller.dispose().catchError((_) {});
        } catch (_) {}
      }();
    }

    super.dispose();
  }

  Future<void> _toggleTorch() async {
    if (_cameraController == null || !_isCameraInitialized || _isDisposed) return;
    try {
      final newTorch = !_isTorchOn;
      await _cameraController!.setFlashMode(newTorch ? FlashMode.torch : FlashMode.off);
      if (mounted && !_isDisposed) {
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
    });
    try {
      final settings = ref.read(appSettingsRepositoryProvider);
      settings.setNumismaticDefaultMode(isCoin ? 'coin' : 'banknote').catchError((_) {});
    } catch (_) {}
  }

  Future<void> _handleTapToFocus(TapDownDetails details, BoxConstraints constraints) async {
    if (_cameraController == null || !_isCameraInitialized || _isDisposed) return;
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
      if (mounted && !_isDisposed) {
        setState(() {
          _tapFocusPoint = null;
        });
      }
    });
  }

  Future<void> _adjustZoom(double value) async {
    if (_cameraController == null || !_isCameraInitialized || !mounted || _isDisposed) return;
    try {
      final zoom = value.clamp(_minZoom, _maxZoom);
      await _cameraController!.setZoomLevel(zoom);
      if (mounted && !_isDisposed) {
        setState(() {
          _currentZoom = zoom;
        });
      }
      final settings = ref.read(appSettingsRepositoryProvider);
      settings.setNumismaticZoomLevel(zoom).catchError((_) {});
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
    final isBothCaptured = _obverseFile != null && _reverseFile != null;
    if (_cameraController == null ||
        !_cameraController!.value.isInitialized ||
        _isProcessing ||
        _isDisposed ||
        isBothCaptured) {
      return;
    }

    setState(() {
      _isProcessing = true;
      _statusMessage = 'Capturando en alta definición...';
    });

    try {
      final XFile photo = await _cameraController!.takePicture();
      final File rawFile = File(photo.path);

      final File croppedFile = await _cropImageCenter(rawFile);

      if (_currentStep == 1) {
        _obverseFile = croppedFile;
        if (mounted && !_isDisposed) {
          setState(() {
            _currentStep = 2;
            _isProcessing = false;
            _statusMessage = null;
          });
        }
      } else {
        _reverseFile = croppedFile;
        if (mounted && !_isDisposed) {
          setState(() {
            _isProcessing = false;
            _statusMessage = null;
          });
        }
      }
    } catch (e) {
      if (mounted && !_isDisposed) {
        setState(() {
          _isProcessing = false;
          _statusMessage = 'Error en captura: $e';
        });
      }
    }
  }

  Future<void> _processRecognition() async {
    final primaryPhoto = _obverseFile ?? _reverseFile;
    if (primaryPhoto == null) return;

    try {
      if (_cameraController != null && _cameraController!.value.isInitialized) {
        await _cameraController?.pausePreview();
      }
    } catch (_) {}

    if (mounted && !_isDisposed) {
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
          } else if (mounted && !_isDisposed) {
            setState(() {
              _showQuickFillForm = false;
            });
            try {
              if (_cameraController != null && _cameraController!.value.isInitialized) {
                await _cameraController?.resumePreview();
              }
            } catch (_) {}
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

    final isBothCaptured = _obverseFile != null && _reverseFile != null;
    final activeGuideColor = isBothCaptured ? Colors.greenAccent.shade400 : Colors.amber;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          // Mode Selector: Moneda vs Billete
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
                const SizedBox(width: 12),
                FilterChip(
                  label: const Text(AppStrings.banknoteRectangleLabel, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  selected: !_isCoinMode,
                  onSelected: (val) => _switchMode(false),
                  avatar: const Icon(Icons.crop_landscape, size: 16),
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
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isBothCaptured
                            ? Colors.greenAccent.withAlpha(200)
                            : theme.colorScheme.primary.withAlpha(120),
                        width: isBothCaptured ? 3 : 2,
                      ),
                    ),
                  ),
                ),
              ),

              // Target Overlay (Circle for Coin, Rectangle for Banknote)
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
                    color: isBothCaptured ? Colors.green.shade900.withAlpha(220) : Colors.black87,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isBothCaptured
                            ? Icons.check_circle
                            : (_currentStep == 1 ? Icons.looks_one : Icons.looks_two),
                        color: isBothCaptured ? Colors.greenAccent : Colors.amber,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        isBothCaptured
                            ? 'CAPTURA COMPLETA (2/2)'
                            : (_currentStep == 1 ? 'PASO 1: ANVERSO' : 'PASO 2: REVERSO'),
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
                  color: _isTorchOn ? Colors.amber.shade700 : Colors.black54,
                  shape: const CircleBorder(),
                  child: IconButton(
                    iconSize: 20,
                    tooltip: _isTorchOn ? 'Desactivar linterna' : 'Activar linterna (evita barrido)',
                    icon: Icon(
                      _isTorchOn ? Icons.flash_on : Icons.flash_off,
                      color: _isTorchOn ? Colors.white : Colors.white70,
                    ),
                    onPressed: _toggleTorch,
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
              else if (!isBothCaptured)
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
                onDelete: () {
                  setState(() {
                    _obverseFile = null;
                    _currentStep = 1;
                  });
                },
                theme: theme,
              ),
              const SizedBox(width: 12),
              // Reverso Thumbnail
              _buildThumbnailCard(
                title: 'Reverso',
                file: _reverseFile,
                isSelected: _currentStep == 2,
                onTapSelect: () => setState(() => _currentStep = 2),
                onDelete: () {
                  setState(() {
                    _reverseFile = null;
                    _currentStep = 2;
                  });
                },
                theme: theme,
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Tip / Guidance banner
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isBothCaptured ? Icons.check_circle : Icons.lightbulb_outline,
                size: 14,
                color: isBothCaptured ? Colors.green : Colors.amber.shade700,
              ),
              const SizedBox(width: 4),
              Text(
                isBothCaptured
                    ? '¡Ambos lados listos! Pulsa "Continuar a Datos Numismáticos".'
                    : 'Tip: Activa la linterna y ajusta el zoom para encuadrar la pieza.',
                style: TextStyle(
                  fontSize: 10,
                  color: isBothCaptured ? Colors.green.shade800 : theme.colorScheme.onSurfaceVariant,
                  fontWeight: isBothCaptured ? FontWeight.bold : FontWeight.normal,
                ),
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
                onTap: (_isProcessing || isBothCaptured) ? null : _capturePhoto,
                child: Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isBothCaptured ? Colors.grey.shade400 : theme.colorScheme.primary,
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
                          : (isBothCaptured ? Colors.grey.shade400 : theme.colorScheme.primary),
                    ),
                    child: _isProcessing
                        ? const Center(child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                        : Icon(
                            isBothCaptured
                                ? Icons.check
                                : (_isCoinMode ? Icons.camera_alt : Icons.crop_free),
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
          // Marco circular para monedas
          final double radius = width * 0.35;
          return Stack(
            key: const ValueKey('coin_targeting_stack'),
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
                child: Container(
                  key: const ValueKey('coin_reticle_container'),
                  width: radius * 2,
                  height: radius * 2,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: guideColor, width: 2.5),
                  ),
                ),
              ),
            ],
          );
        } else {
          // Marco rectangular para billetes
          final double rectWidth = width * 0.8;
          final double rectHeight = rectWidth * 0.55;
          return Stack(
            key: const ValueKey('banknote_targeting_stack'),
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
                child: Container(
                  key: const ValueKey('banknote_reticle_container'),
                  width: rectWidth,
                  height: rectHeight,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: guideColor, width: 2.5),
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

