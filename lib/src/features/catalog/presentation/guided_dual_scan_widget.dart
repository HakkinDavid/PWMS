import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/constants/app_strings.dart';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;
import '../domain/numismatic_recognition_models.dart';
import 'numismatic_quick_fill_sheet.dart';

class GuidedDualScanWidget extends ConsumerStatefulWidget {
  final Function(NumismaticScanResult result)? onScannedResult;

  const GuidedDualScanWidget({
    super.key,
    this.onScannedResult,
  });

  @override
  ConsumerState<GuidedDualScanWidget> createState() => _GuidedDualScanWidgetState();
}

class _GuidedDualScanWidgetState extends ConsumerState<GuidedDualScanWidget> {
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  bool _isCameraInitialized = false;
  bool _isProcessing = false;
  String? _statusMessage;

  // 1: Obverse, 2: Reverse
  int _currentStep = 1; 
  File? _obverseFile;
  File? _reverseFile;

  // Configuration
  bool _isCoinMode = true; // True for Coin (Circle), False for Banknote (Rectangle)
  double _currentZoom = 1.0;
  double _maxZoom = 4.0;
  double _minZoom = 1.0;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isNotEmpty) {
        // Prefer back camera
        final backCam = _cameras.firstWhere(
          (c) => c.lensDirection == CameraLensDirection.back,
          orElse: () => _cameras.first,
        );

        _cameraController = CameraController(
          backCam,
          ResolutionPreset.veryHigh,
          enableAudio: false,
        );

        await _cameraController!.initialize();
        _maxZoom = await _cameraController!.getMaxZoomLevel();
        _minZoom = await _cameraController!.getMinZoomLevel();

        // Configure macro/autofocus parameters
        try {
          await _cameraController!.setFocusMode(FocusMode.auto);
          await _cameraController!.setFocusPoint(const Offset(0.5, 0.5));
        } catch (_) {}

        if (mounted) {
          setState(() {
            _isCameraInitialized = true;
          });
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
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _adjustZoom(double value) async {
    if (_cameraController == null || !_isCameraInitialized) return;
    try {
      final zoom = value.clamp(_minZoom, _maxZoom);
      await _cameraController!.setZoomLevel(zoom);
      setState(() {
        _currentZoom = zoom;
      });
    } catch (_) {}
  }

  Future<File> _cropImageCenter(File originalFile) async {
    final bytes = await originalFile.readAsBytes();
    final image = img.decodeImage(bytes);
    if (image == null) return originalFile;

    // Determine crop dimensions
    int size;
    int x;
    int y;
    img.Image cropped;

    if (_isCoinMode) {
      // Circular crop helper (crop square from center, which Gemini interprets as the coin)
      size = (image.width < image.height ? image.width : image.height) * 3 ~/ 4;
      x = (image.width - size) ~/ 2;
      y = (image.height - size) ~/ 2;
      cropped = img.copyCrop(image, x: x, y: y, width: size, height: size);
    } else {
      // Rectangular crop for banknote (4:3 aspect ratio)
      final width = (image.width * 0.85).toInt();
      final height = (width * 0.55).toInt();
      x = (image.width - width) ~/ 2;
      y = (image.height - height) ~/ 2;
      cropped = img.copyCrop(image, x: x, y: y, width: width, height: height);
    }

    // Resize down if it exceeds 1080p (max 1080 in any dimension)
    if (cropped.width > 1080 || cropped.height > 1080) {
      if (_isCoinMode) {
        cropped = img.copyResize(cropped, width: 1080, height: 1080);
      } else {
        final double ratio = cropped.width / cropped.height;
        cropped = img.copyResize(cropped, width: 1080, height: (1080 / ratio).toInt());
      }
    }

    final newPath = originalFile.path.replaceAll('.jpg', '_cropped.jpg');
    final croppedFile = File(newPath);
    await croppedFile.writeAsBytes(img.encodeJpg(cropped, quality: 90));
    return croppedFile;
  }

  Future<void> _capturePhoto() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized || _isProcessing) return;

    setState(() {
      _isProcessing = true;
      _statusMessage = 'Capturando...';
    });

    try {
      final XFile photo = await _cameraController!.takePicture();
      final File rawFile = File(photo.path);

      // Programmatically crop to the center frame area
      final File croppedFile = await _cropImageCenter(rawFile);

      if (_obverseFile == null || _currentStep == 1) {
        _obverseFile = croppedFile;
        setState(() {
          _currentStep = 2;
          _isProcessing = false;
          _statusMessage = null;
        });
      } else {
        _reverseFile = croppedFile;
        setState(() {
          _isProcessing = false;
          _statusMessage = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isProcessing = false;
          _statusMessage = 'Error en captura: $e';
        });
      }
    }
  }

  Future<void> _processRecognition() async {
    if (_obverseFile == null) return;

    // Pausar preview de la cámara para liberar GPU/CPU mientras se llena el formulario
    try {
      await _cameraController?.pausePreview();
    } catch (_) {}

    final result = await NumismaticQuickFillSheet.show(
      context,
      obversePhoto: _obverseFile!,
      reversePhoto: _reverseFile,
      isCoin: _isCoinMode,
    );

    if (result == null) {
      try {
        await _cameraController?.resumePreview();
      } catch (_) {}
    }

    if (result != null && mounted) {
      widget.onScannedResult?.call(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                _statusMessage ?? 'Iniciando cámara trasera...',
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        // Mode Selector: Moneda vs Billete
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FilterChip(
                label: const Text(AppStrings.coinCircularLabel, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                selected: _isCoinMode,
                onSelected: (val) {
                  setState(() => _isCoinMode = val);
                },
                avatar: const Icon(Icons.circle_outlined, size: 16),
              ),
              const SizedBox(width: 12),
              FilterChip(
                label: const Text(AppStrings.banknoteRectangleLabel, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                selected: !_isCoinMode,
                onSelected: (val) {
                  setState(() => _isCoinMode = !val);
                },
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
                borderRadius: BorderRadius.circular(24),
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: 1080,
                    height: 1080 * _cameraController!.value.aspectRatio,
                    child: CameraPreview(_cameraController!),
                  ),
                ),
              ),
            ),

            // Frame overlay
            AspectRatio(
              aspectRatio: 1.0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: theme.colorScheme.primary.withAlpha(120), width: 2),
                ),
              ),
            ),

            // Target Overlay
            Positioned.fill(
              child: _buildTargetOverlay(theme),
            ),

            // Steps Indicator Banner
            Positioned(
              top: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _currentStep == 1
                          ? 'PASO 1: ENCUADRA EL ANVERSO'
                          : 'PASO 2: ENCUADRA EL REVERSO',
                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                    ),
                  ],
                ),
              ),
            ),

            // Focus Lock / Center indicator
            const Icon(Icons.center_focus_weak, color: Colors.white54, size: 40),

            // Zoom Controller Slider Overlay
            Positioned(
              bottom: 16,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.zoom_out, color: Colors.white, size: 16),
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
                    const Icon(Icons.zoom_in, color: Colors.white, size: 16),
                    const SizedBox(width: 6),
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

        const SizedBox(height: 12),

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
            const SizedBox(width: 16),
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

        const SizedBox(height: 12),

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
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: theme.colorScheme.primary, width: 3),
                  color: Colors.transparent,
                ),
                padding: const EdgeInsets.all(4),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isProcessing ? Colors.grey : theme.colorScheme.primary,
                  ),
                  child: _isProcessing
                      ? const Center(child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                      : Icon(
                          _isCoinMode ? Icons.camera_alt : Icons.crop_free,
                          color: Colors.white,
                          size: 28,
                        ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Send to API Button
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            onPressed: (_obverseFile != null && !_isProcessing) ? _processRecognition : null,
            icon: _isProcessing
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white))
                : const Icon(Icons.arrow_forward_rounded),
            label: const Text(
              'Continuar a Datos Numismáticos',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
        ),
      ],
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
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
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
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  file,
                  width: 100,
                  height: 100,
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

  Widget _buildTargetOverlay(ThemeData theme) {
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
                child: Container(
                  width: radius * 2,
                  height: radius * 2,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.amber, width: 2.5),
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
                child: Container(
                  width: rectWidth,
                  height: rectHeight,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.amber, width: 2.5),
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
