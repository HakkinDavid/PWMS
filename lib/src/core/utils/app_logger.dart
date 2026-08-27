import 'package:flutter/foundation.dart';
import '../constants/app_technical_strings.dart';

/// Utilidad estandarizada de registro para PWMS.
class AppLogger {
  AppLogger._();

  static DateTime _lastLogTimestamp = DateTime(0);

  static String _getAttentionPrefix(int attentionLevel) {
    switch (attentionLevel) {
      case 5:
        return AppTechnicalStrings.logPrefixLevel5;
      case 4:
        return AppTechnicalStrings.logPrefixLevel4;
      case 3:
        return AppTechnicalStrings.logPrefixLevel3;
      case 2:
        return AppTechnicalStrings.logPrefixLevel2;
      case 1:
        return AppTechnicalStrings.logPrefixLevel1;
      case 0:
      default:
        return AppTechnicalStrings.logPrefixLevel0;
    }
  }

  /// Registra un mensaje formateado en modo Debug.
  static void log(
    Object? message, {
    String? caller,
    int attentionLevel = 0,
  }) {
    if (!kDebugMode) return;

    final now = DateTime.now();
    if (now.difference(_lastLogTimestamp).inSeconds > 2) {
      debugPrint(AppTechnicalStrings.logDivider());
    }
    _lastLogTimestamp = now;

    final prefix = _getAttentionPrefix(attentionLevel);
    final callerInfo = caller != null ? AppTechnicalStrings.logCallerInfo(caller) : AppTechnicalStrings.empty;
    debugPrint(AppTechnicalStrings.formatLogEntry(prefix, callerInfo, message));
  }

  /// Registra un error con su traza.
  static void error(
    Object? message, {
    String? caller,
    Object? error,
    StackTrace? stackTrace,
  }) {
    log(AppTechnicalStrings.formatLogError(message, error), caller: caller, attentionLevel: 5);
    if (kDebugMode && stackTrace != null) {
      debugPrint(stackTrace.toString());
    }
  }
}
