import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';

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
      throw Exception(AppStrings.errorNoCamerasFound);
    }

    final backCam = cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.back,
      orElse: () => cameras.first,
    );

    if (isDisposed != null && isDisposed()) {
      throw Exception(AppStrings.errorCameraInitCancelledWidgetDisposed);
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
          throw Exception(AppStrings.errorCameraInitCancelledWidgetDisposed);
        }
        controller = c;
        break;
      } catch (_) {}
    }

    if (isDisposed != null && isDisposed()) {
      controller?.dispose().catchError((_) {});
      throw Exception(AppStrings.errorCameraInitCancelledWidgetDisposed);
    }

    if (controller == null) {
      throw Exception(AppStrings.errorCouldNotInitBackCamera);
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
      controller.getMaxZoomLevel().catchError((_) => 4.0).then((v) {
        if (isDisposed != null && isDisposed()) return;
        onMaxZoomCalculated?.call(v);
      }),
      controller.getMinZoomLevel().catchError((_) => 1.0).then((v) {
        if (isDisposed != null && isDisposed()) return;
        onMinZoomCalculated?.call(v);
      }),
      controller.setFocusMode(FocusMode.auto).catchError((_) {}),
      controller.setExposureMode(ExposureMode.auto).catchError((_) {}),
      controller.setFocusPoint(const Offset(0.5, 0.5)).catchError((_) {}),
      controller.setExposurePoint(const Offset(0.5, 0.5)).catchError((_) {}),
      controller.setExposureOffset(exposureOffset).then((_) {}).catchError((_) {}),
      if (currentZoom > 1.0) controller.setZoomLevel(currentZoom).then((_) {}).catchError((_) {}),
      if (isTorchOn) controller.setFlashMode(FlashMode.torch).catchError((_) {}),
    ]).catchError((_) => <dynamic>[]);
  }
}
