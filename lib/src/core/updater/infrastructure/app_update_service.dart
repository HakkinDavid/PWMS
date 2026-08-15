import 'dart:io';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../domain/app_update_info.dart';
import '../../utils/app_logger.dart';

/// Servicio de infraestructura para gestionar la comunicación nativa de autoactualización.
class AppUpdateService {
  static const MethodChannel _channel = MethodChannel('dev.bonsanbec.pwms/updater');

  /// Obtiene la versión actual de la aplicación instalada.
  Future<String> getCurrentAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      return packageInfo.version;
    } catch (e) {
      AppLogger.error('Error al obtener la versión del paquete', caller: 'AppUpdateService', error: e);
      return '1.0.0';
    }
  }

  /// Compara dos versiones semánticas (ej. "1.2.0" > "1.1.9"). Retorna true si latest > current.
  bool isNewerVersion(String latest, String current) {
    try {
      final cleanLatest = latest.replaceAll(RegExp(r'[^0-9.]'), '');
      final cleanCurrent = current.replaceAll(RegExp(r'[^0-9.]'), '');

      final latestParts = cleanLatest.split('.').map((e) => int.tryParse(e) ?? 0).toList();
      final currentParts = cleanCurrent.split('.').map((e) => int.tryParse(e) ?? 0).toList();

      final maxLength = latestParts.length > currentParts.length ? latestParts.length : currentParts.length;

      for (var i = 0; i < maxLength; i++) {
        final latestVal = i < latestParts.length ? latestParts[i] : 0;
        final currentVal = i < currentParts.length ? currentParts[i] : 0;

        if (latestVal > currentVal) return true;
        if (latestVal < currentVal) return false;
      }
      return false;
    } catch (e) {
      AppLogger.error('Error comparando versiones ($latest vs $current)', caller: 'AppUpdateService', error: e);
      return false;
    }
  }

  /// Consulta si existe una versión más reciente disponible en el repositorio.
  Future<AppUpdateInfo> checkForUpdate() async {
    final currentVer = await getCurrentAppVersion();

    if (!Platform.isAndroid) {
      AppLogger.log(
        'Las actualizaciones automáticas solo están disponibles en Android (Plataforma actual: ${Platform.operatingSystem}).',
        caller: 'AppUpdateService',
      );
      return AppUpdateInfo(
        isAvailable: false,
        currentVersion: currentVer,
      );
    }

    try {
      AppLogger.log('Consultando disponibilidad de actualización en canal nativo...', caller: 'AppUpdateService');
      final dynamic rawResult = await _channel.invokeMethod('isUpdateAvailable');

      if (rawResult is Map) {
        final resultMap = Map<String, dynamic>.from(rawResult);
        final bool rawAvailable = resultMap['available'] == true;
        final String? latestVer = resultMap['latest_version']?.toString();
        final String? changelog = resultMap['changelog']?.toString();
        final String? apkUrl = resultMap['apk_url']?.toString();

        final hasNewer = rawAvailable &&
            latestVer != null &&
            latestVer.isNotEmpty &&
            isNewerVersion(latestVer, currentVer);

        AppLogger.log(
          'Resultado de actualización: disponible=$hasNewer (remoto=$latestVer, actual=$currentVer)',
          caller: 'AppUpdateService',
          attentionLevel: hasNewer ? 3 : 1,
        );

        return AppUpdateInfo(
          isAvailable: hasNewer,
          currentVersion: currentVer,
          latestVersion: latestVer,
          changelog: changelog,
          apkUrl: apkUrl,
        );
      }

      return AppUpdateInfo(
        isAvailable: false,
        currentVersion: currentVer,
      );
    } on PlatformException catch (e) {
      AppLogger.error('PlatformException al verificar actualización', caller: 'AppUpdateService', error: e);
      return AppUpdateInfo(
        isAvailable: false,
        currentVersion: currentVer,
      );
    } catch (e, st) {
      AppLogger.error('Error inesperado verificando actualización', caller: 'AppUpdateService', error: e, stackTrace: st);
      return AppUpdateInfo(
        isAvailable: false,
        currentVersion: currentVer,
      );
    }
  }

  /// Inicia la descarga e instalación de la actualización en segundo plano.
  Future<bool> triggerUpdate() async {
    if (!Platform.isAndroid) return false;

    try {
      AppLogger.log('Invocando método updateApp en canal nativo...', caller: 'AppUpdateService', attentionLevel: 3);
      final result = await _channel.invokeMethod('updateApp');
      return result == true;
    } on PlatformException catch (e) {
      AppLogger.error('Error al ejecutar updateApp', caller: 'AppUpdateService', error: e);
      rethrow;
    } catch (e, st) {
      AppLogger.error('Error al disparar actualización', caller: 'AppUpdateService', error: e, stackTrace: st);
      rethrow;
    }
  }
}
