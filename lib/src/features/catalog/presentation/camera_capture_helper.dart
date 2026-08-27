import 'dart:ui';
import 'package:camera/camera.dart';

/// Helper auxiliar para gestionar la inicialización y configuración de cámara numismática.
class CameraCaptureHelper {
  static List<CameraDescription>? _cachedCameras;

  /// Retorna la lista en caché de cámaras disponibles o las consulta al sistema.
  static Future<List<CameraDescription>> getAvailableCameras() async {
    _cachedCameras ??= await availableCameras();
    return _cachedCameras!;
  }

  /// Descubre la cámara trasera (o la primera disponible) e intenta inicializarla
  /// iterando por los presets de resolución provistos con fallback (veryHigh -> high -> max).
  static Future<CameraController> initializeBackCamera({
    bool Function()? isDisposed,
    List<ResolutionPreset> presetsToTry = const [
      ResolutionPreset.veryHigh,
      ResolutionPreset.high,
      ResolutionPreset.max,
    ],
  }) async {
    final cameras = await getAvailableCameras();
    if (cameras.isEmpty) {
      throw Exception('No se encontraron cámaras disponibles en el dispositivo.');
    }

    final backCam = cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.back,
      orElse: () => cameras.first,
    );

    if (isDisposed != null && isDisposed()) {
      throw Exception('Inicialización cancelada: el widget ya fue descartado.');
    }

    CameraController? controller;
    for (final preset in presetsToTry) {
      if (isDisposed != null && isDisposed()) break;
      try {
        final c = CameraController(
          backCam,
          preset,
          enableAudio: false,
          imageFormatGroup: ImageFormatGroup.jpeg,
        );
        await c.initialize();
        if (isDisposed != null && isDisposed()) {
          c.dispose().catchError((_) {});
          throw Exception('Inicialización cancelada: el widget ya fue descartado.');
        }
        controller = c;
        break;
      } catch (_) {}
    }

    if (isDisposed != null && isDisposed()) {
      controller?.dispose().catchError((_) {});
      throw Exception('Inicialización cancelada: el widget ya fue descartado.');
    }

    if (controller == null) {
      throw Exception('No se pudo inicializar la cámara trasera.');
    }

    return controller;
  }

  /// Configuración concurrente en segundo plano de zoom, auto-focus, spot de auto-exposición, EV offset y linterna.
  static Future<void> configureCameraSettings({
    required CameraController controller,
    required double exposureOffset,
    required double currentZoom,
    required bool isTorchOn,
    void Function(double minZoom)? onMinZoomCalculated,
    void Function(double maxZoom)? onMaxZoomCalculated,
    bool Function()? isDisposed,
  }) async {
    await Future.wait([
      controller.getMaxZoomLevel().then((v) {
        if (isDisposed != null && isDisposed()) return;
        onMaxZoomCalculated?.call(v);
      }).catchError((_) => 4.0),
      controller.getMinZoomLevel().then((v) {
        if (isDisposed != null && isDisposed()) return;
        onMinZoomCalculated?.call(v);
      }).catchError((_) => 1.0),
      controller.setFocusMode(FocusMode.auto).catchError((_) {}),
      controller.setExposureMode(ExposureMode.auto).catchError((_) {}),
      controller.setFocusPoint(const Offset(0.5, 0.5)).catchError((_) {}),
      controller.setExposurePoint(const Offset(0.5, 0.5)).catchError((_) {}),
      controller.setExposureOffset(exposureOffset).catchError((_) {}),
      if (currentZoom > 1.0) controller.setZoomLevel(currentZoom).catchError((_) {}),
      if (isTorchOn) controller.setFlashMode(FlashMode.torch).catchError((_) {}),
    ]).catchError((_) => <dynamic>[]);
  }
}
