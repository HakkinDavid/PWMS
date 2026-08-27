import 'dart:io';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import 'package:platinum_world_management_system/src/core/constants/app_technical_strings.dart';
import '../domain/app_update_info.dart';
import '../../utils/app_logger.dart';

/// Servicio de infraestructura para gestionar la comunicación nativa de autoactualización.
class AppUpdateService {
  static const MethodChannel _channel = MethodChannel(AppTechnicalStrings.channelUpdater);

  /// Obtiene la versión actual de la aplicación instalada.
  Future<String> getCurrentAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      return packageInfo.version;
    } catch (e) {
      AppLogger.error(AppStrings.errorGettingPackageVersion, caller: AppTechnicalStrings.callerAppUpdateService, error: e);
      return AppTechnicalStrings.defaultInitialAppVersion;
    }
  }

  /// Compara dos versiones semánticas (ej. "1.2.0" > "1.1.9"). Retorna true si latest > current.
  bool isNewerVersion(String latest, String current) {
    try {
      final cleanLatest = latest.replaceAll(RegExp(AppTechnicalStrings.regexNonVersionChars), AppTechnicalStrings.empty);
      final cleanCurrent = current.replaceAll(RegExp(AppTechnicalStrings.regexNonVersionChars), AppTechnicalStrings.empty);

      final latestParts = cleanLatest.split(AppTechnicalDelimiters.dot).map((e) => int.tryParse(e) ?? 0).toList();
      final currentParts = cleanCurrent.split(AppTechnicalDelimiters.dot).map((e) => int.tryParse(e) ?? 0).toList();

      final maxLength = latestParts.length > currentParts.length ? latestParts.length : currentParts.length;

      for (var i = 0; i < maxLength; i++) {
        final latestVal = i < latestParts.length ? latestParts[i] : 0;
        final currentVal = i < currentParts.length ? currentParts[i] : 0;

        if (latestVal > currentVal) return true;
        if (latestVal < currentVal) return false;
      }
      return false;
    } catch (e) {
      AppLogger.error(AppStrings.errorComparingVersions(latest, current), caller: AppTechnicalStrings.callerAppUpdateService, error: e);
      return false;
    }
  }

  /// Consulta si existe una versión más reciente disponible en el repositorio.
  Future<AppUpdateInfo> checkForUpdate() async {
    final currentVer = await getCurrentAppVersion();

    if (!Platform.isAndroid) {
      AppLogger.log(
        AppStrings.autoUpdatesOnlyOnAndroid(Platform.operatingSystem),
        caller: AppTechnicalStrings.callerAppUpdateService,
      );
      return AppUpdateInfo(
        isAvailable: false,
        currentVersion: currentVer,
      );
    }

    try {
      AppLogger.log(AppStrings.checkingUpdateInNativeChannel, caller: AppTechnicalStrings.callerAppUpdateService);
      final dynamic rawResult = await _channel.invokeMethod(AppTechnicalStrings.methodIsUpdateAvailable);

      if (rawResult is Map) {
        final resultMap = Map<String, dynamic>.from(rawResult);
        final bool rawAvailable = resultMap[AppTechnicalStrings.keyAvailable] == true;
        final String? latestVer = resultMap[AppTechnicalStrings.keyLatestVersion]?.toString();
        final String? changelog = resultMap[AppTechnicalStrings.keyChangelog]?.toString();
        final String? apkUrl = resultMap[AppTechnicalStrings.keyApkUrl]?.toString();

        final hasNewer = rawAvailable &&
            latestVer != null &&
            latestVer.isNotEmpty &&
            isNewerVersion(latestVer, currentVer);

        AppLogger.log(
          AppStrings.updateCheckResult(hasNewer, latestVer, currentVer),
          caller: AppTechnicalStrings.callerAppUpdateService,
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
      AppLogger.error(AppStrings.platformExceptionCheckingUpdate, caller: AppTechnicalStrings.callerAppUpdateService, error: e);
      return AppUpdateInfo(
        isAvailable: false,
        currentVersion: currentVer,
      );
    } catch (e, st) {
      AppLogger.error(AppStrings.unexpectedErrorCheckingUpdate, caller: AppTechnicalStrings.callerAppUpdateService, error: e, stackTrace: st);
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
      AppLogger.log(AppStrings.invokingUpdateAppNative, caller: AppTechnicalStrings.callerAppUpdateService, attentionLevel: 3);
      final result = await _channel.invokeMethod(AppTechnicalStrings.methodUpdateApp);
      return result == true;
    } on PlatformException catch (e) {
      AppLogger.error(AppStrings.errorExecutingUpdateApp, caller: AppTechnicalStrings.callerAppUpdateService, error: e);
      rethrow;
    } catch (e, st) {
      AppLogger.error(AppStrings.errorTriggeringUpdate, caller: AppTechnicalStrings.callerAppUpdateService, error: e, stackTrace: st);
      rethrow;
    }
  }
}
