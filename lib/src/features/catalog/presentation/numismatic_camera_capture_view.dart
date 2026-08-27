import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;
import '../../../core/storage/app_settings_repository.dart';
import 'camera_capture_helper.dart';

class NumismaticCameraCaptureView extends ConsumerStatefulWidget {
  final bool isCoin;
  final String targetSide; // 'anverso' or 'reverso'
  final File? existingObverseFile;
  final File? existingReverseFile;
  final bool hideSideSelector;
  final ValueChanged<File>? onCaptured;

  const NumismaticCameraCaptureView({
    super.key,
    required this.isCoin,
    this.targetSide = 'anverso',
    this.existingObverseFile,
    this.existingReverseFile,
    this.hideSideSelector = false,
    this.onCaptured,
  });

  static Future<File?> show(
    BuildContext context, {
    required bool isCoin,
    String targetSide = 'anverso',
    File? existingObverseFile,
    File? existingReverseFile,
    bool hideSideSelector = false,
  }) {
    return showModalBottomSheet<File?>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.black,
      builder: (ctx) => Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          title: Text(
            isCoin
                ? 'Captura de Moneda (${targetSide.toUpperCase()})'
                : 'Captura de Billete (${targetSide.toUpperCase()})',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.pop(ctx, null),
          ),
        ),
        body: NumismaticCameraCaptureView(
          isCoin: isCoin,
          targetSide: targetSide,
          existingObverseFile: existingObverseFile,
          existingReverseFile: existingReverseFile,
          hideSideSelector: hideSideSelector,
          onCaptured: (file) {
            Navigator.pop(ctx, file);
          },
        ),
      ),
    );
  }

  @override
  ConsumerState<NumismaticCameraCaptureView> createState() => _NumismaticCameraCaptureViewState();
}

class _NumismaticCameraCaptureViewState extends ConsumerState<NumismaticCameraCaptureView> {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  bool _isProcessing = false;
  bool _isDisposed = false;
  String? _statusMessage;

  bool _isTorchOn = false;
  double _exposureOffset = -1.5;
  Offset? _tapFocusPoint;

  double _currentZoom = 1.0;
  double _maxZoom = 4.0;
  double _minZoom = 1.0;

  late String _activeSide;

  @override
  void initState() {
    super.initState();
    _activeSide = widget.targetSide.toLowerCase();
    _loadSettingsAndInitCamera();
  }

  Future<void> _loadSettingsAndInitCamera() async {
    try {
      final settings = ref.read(appSettingsRepositoryProvider);
      final torch = await settings.getNumismaticTorchEnabled(defaultValue: false);
      final ev = await settings.getNumismaticExposureOffset(defaultValue: -1.5);
      final zoom = await settings.getNumismaticZoomLevel(defaultValue: 1.0);

      if (mounted && !_isDisposed) {
        setState(() {
          _isTorchOn = torch;
          _exposureOffset = ev;
          _currentZoom = zoom;
        });
      }
    } catch (_) {}

    await _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    if (!mounted || _isDisposed) return;
    try {
      final controller = await CameraCaptureHelper.initializeBackCamera(
        isDisposed: () => !mounted || _isDisposed,
      );

      _cameraController = controller;

      if (mounted && !_isDisposed) {
        setState(() {
          _isCameraInitialized = true;
          _statusMessage = null;
        });
      }

      CameraCaptureHelper.configureCameraSettings(
        controller: _cameraController!,
        exposureOffset: _exposureOffset,
        currentZoom: _currentZoom,
        isTorchOn: _isTorchOn,
        onMaxZoomCalculated: (v) {
          if (mounted && !_isDisposed) setState(() => _maxZoom = v);
        },
        onMinZoomCalculated: (v) {
          if (mounted && !_isDisposed) setState(() => _minZoom = v);
        },
        isDisposed: () => !mounted || _isDisposed,
      );
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
    try {
      final bytes = await originalFile.readAsBytes();
      final isCoin = widget.isCoin;
      final originalPath = originalFile.path;
      final result = await compute(_numismaticCropImageIsolate, _NumismaticCropParams(
        bytes: bytes,
        isCoinMode: isCoin,
        originalPath: originalPath,
      )).timeout(const Duration(seconds: 4));

      final croppedFile = File(result.outputPath);
      await croppedFile.writeAsBytes(result.croppedBytes);
      return croppedFile;
    } catch (e) {
      debugPrint('Numismatic crop isolate failed or timed out: $e');
      return originalFile;
    }
  }

  Future<void> _capturePhoto() async {
    if (_cameraController == null ||
        !_cameraController!.value.isInitialized ||
        _isProcessing ||
        _isDisposed) {
      return;
    }

    setState(() {
      _isProcessing = true;
      _statusMessage = 'Capturando en alta definición...';
    });

    try {
      final XFile photo = await _cameraController!.takePicture().timeout(const Duration(seconds: 5));
      final File rawFile = File(photo.path);
      final File processedFile = await _cropImageCenter(rawFile);

      if (mounted && !_isDisposed) {
        setState(() {
          _statusMessage = null;
        });
        widget.onCaptured?.call(processedFile);
      }
    } catch (e) {
      if (mounted && !_isDisposed) {
        setState(() {
          _statusMessage = 'Error en captura: $e';
        });
      }
    } finally {
      if (mounted && !_isDisposed) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isObverseActive = _activeSide == 'anverso';
    const activeGuideColor = Colors.amber;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          // Live Camera Preview with Custom Overlays
          Stack(
            alignment: Alignment.center,
            children: [
              AspectRatio(
                aspectRatio: 1.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    color: Colors.black,
                    child: _isCameraInitialized && _cameraController != null
                        ? LayoutBuilder(
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
                          )
                        : const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.photo_camera, color: Colors.white38, size: 40),
                                SizedBox(height: 10),
                                SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.amber),
                                ),
                              ],
                            ),
                          ),
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
                        color: Colors.amber.withAlpha(120),
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),

              // Target Overlay (Circle for Coin, Rectangle for Banknote)
              Positioned.fill(
                child: IgnorePointer(
                  child: _buildTargetOverlay(activeGuideColor),
                ),
              ),

              // Active Side Indicator Banner
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
                      const Icon(
                        Icons.camera_alt,
                        color: Colors.amber,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'CAPTURA: ${_activeSide.toUpperCase()}',
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
                    tooltip: _isTorchOn ? 'Desactivar linterna' : 'Activar linterna',
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
              else
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

          if (!widget.hideSideSelector) ...[
            const SizedBox(height: 12),

            // Side selection / Greyed-out indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSideCard(
                  sideLabel: 'Anverso',
                  isActive: isObverseActive,
                  existingFile: widget.existingObverseFile,
                  onTap: isObverseActive ? null : () => setState(() => _activeSide = 'anverso'),
                ),
                const SizedBox(width: 14),
                _buildSideCard(
                  sideLabel: 'Reverso',
                  isActive: !isObverseActive,
                  existingFile: widget.existingReverseFile,
                  onTap: !isObverseActive ? null : () => setState(() => _activeSide = 'reverso'),
                ),
              ],
            ),
          ],

          const SizedBox(height: 8),

          // Tip banner
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lightbulb_outline, size: 14, color: Colors.amber.shade700),
                const SizedBox(width: 4),
                const Flexible(
                  child: Text(
                    'Tip: Activa la linterna y ajusta el zoom para encuadrar los relieves.',
                    style: TextStyle(fontSize: 11, color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),

          if (_statusMessage != null) ...[
            const SizedBox(height: 8),
            Text(
              _statusMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ],

          const SizedBox(height: 14),

          // Shutter Button
          GestureDetector(
            onTap: _isProcessing ? null : _capturePhoto,
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.amber, width: 3),
                color: Colors.transparent,
              ),
              padding: const EdgeInsets.all(3),
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.amber,
                ),
                child: _isProcessing
                    ? const Center(child: CircularProgressIndicator(color: Colors.black, strokeWidth: 3))
                    : Icon(
                        widget.isCoin ? Icons.camera_alt : Icons.crop_free,
                        color: Colors.black,
                        size: 30,
                      ),
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSideCard({
    required String sideLabel,
    required bool isActive,
    required File? existingFile,
    required VoidCallback? onTap,
  }) {
    final hasFile = existingFile != null && existingFile.existsSync();

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Opacity(
        opacity: isActive ? 1.0 : 0.45,
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isActive ? Colors.amber : Colors.white24,
              width: isActive ? 2.5 : 1,
            ),
            color: Colors.white.withAlpha(20),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (hasFile)
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    existingFile,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(Icons.broken_image_outlined, size: 28),
                  ),
                )
              else
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isActive ? Icons.camera_alt : Icons.lock_outline,
                      color: isActive ? Colors.amber : Colors.white54,
                      size: 24,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      sideLabel,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                        color: isActive ? Colors.amber : Colors.white60,
                      ),
                    ),
                  ],
                ),
              Positioned(
                bottom: 3,
                left: 3,
                right: 3,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 2),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    sideLabel,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isActive ? Colors.amber : Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTargetOverlay(Color guideColor) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        final double height = constraints.maxHeight;

        if (widget.isCoin) {
          final double radius = width * 0.35;
          return Stack(
            children: [
              CustomPaint(
                size: Size(width, height),
                painter: _NumismaticOverlayPainter(
                  isCircle: true,
                  center: Offset(width / 2, height / 2),
                  size: radius * 2,
                ),
              ),
              Center(
                child: Container(
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
          final double rectWidth = width * 0.8;
          final double rectHeight = rectWidth * 0.55;
          return Stack(
            children: [
              CustomPaint(
                size: Size(width, height),
                painter: _NumismaticOverlayPainter(
                  isCircle: false,
                  center: Offset(width / 2, height / 2),
                  size: rectWidth,
                  height: rectHeight,
                ),
              ),
              Center(
                child: Container(
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

class _NumismaticOverlayPainter extends CustomPainter {
  final bool isCircle;
  final Offset center;
  final double size;
  final double? height;

  _NumismaticOverlayPainter({
    required this.isCircle,
    required this.center,
    required this.size,
    this.height,
  });

  @override
  void paint(Canvas canvas, Size sizeObj) {
    final backgroundPaint = Paint()..color = Colors.black54;

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

class _NumismaticCropParams {
  final Uint8List bytes;
  final bool isCoinMode;
  final String originalPath;

  const _NumismaticCropParams({
    required this.bytes,
    required this.isCoinMode,
    required this.originalPath,
  });
}

class _NumismaticCropResult {
  final Uint8List croppedBytes;
  final String outputPath;

  const _NumismaticCropResult({
    required this.croppedBytes,
    required this.outputPath,
  });
}

_NumismaticCropResult _numismaticCropImageIsolate(_NumismaticCropParams params) {
  final image = img.decodeImage(params.bytes);
  if (image == null) {
    return _NumismaticCropResult(croppedBytes: params.bytes, outputPath: params.originalPath);
  }

  img.Image cropped;

  if (params.isCoinMode) {
    final size = (image.width < image.height ? image.width : image.height) * 3 ~/ 4;
    final x = (image.width - size) ~/ 2;
    final y = (image.height - size) ~/ 2;
    cropped = img.copyCrop(image, x: x, y: y, width: size, height: size);
  } else {
    final width = (image.width * 0.85).toInt();
    final height = (width * 0.55).toInt();
    final x = (image.width - width) ~/ 2;
    final y = (image.height - height) ~/ 2;
    cropped = img.copyCrop(image, x: x, y: y, width: width, height: height);
  }

  const int maxOutputDimension = 2560;
  if (cropped.width > maxOutputDimension || cropped.height > maxOutputDimension) {
    if (params.isCoinMode) {
      cropped = img.copyResize(cropped, width: maxOutputDimension, height: maxOutputDimension, interpolation: img.Interpolation.linear);
    } else {
      final double ratio = cropped.width / cropped.height;
      cropped = img.copyResize(cropped, width: maxOutputDimension, height: (maxOutputDimension / ratio).toInt(), interpolation: img.Interpolation.linear);
    }
  }

  final ext = '_cropped.jpg';
  final newPath = params.originalPath.replaceAll(RegExp(r'\.(jpg|jpeg|png)$', caseSensitive: false), '') + ext;
  final Uint8List encodedBytes = Uint8List.fromList(img.encodeJpg(cropped, quality: 95));

  return _NumismaticCropResult(croppedBytes: encodedBytes, outputPath: newPath);
}
