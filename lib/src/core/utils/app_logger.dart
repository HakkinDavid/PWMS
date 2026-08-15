import 'package:flutter/foundation.dart';

/// Utilidad estandarizada de registro para PWMS.
class AppLogger {
  AppLogger._();

  static DateTime _lastLogTimestamp = DateTime(0);

  static String _getAttentionPrefix(int attentionLevel) {
    switch (attentionLevel) {
      case 5:
        return '🚨 ';
      case 4:
        return '‼️ ';
      case 3:
        return '📌 ';
      case 2:
        return '⚠️ ';
      case 1:
        return 'ⓘ ';
      case 0:
      default:
        return '   ';
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
      debugPrint('—' * 70);
    }
    _lastLogTimestamp = now;

    final prefix = _getAttentionPrefix(attentionLevel);
    final callerInfo = caller != null ? '[$caller] ' : '';
    debugPrint('$prefix$callerInfo$message');
  }

  /// Registra un error con su traza.
  static void error(
    Object? message, {
    String? caller,
    Object? error,
    StackTrace? stackTrace,
  }) {
    log('ERROR: $message ${error != null ? "($error)" : ""}', caller: caller, attentionLevel: 5);
    if (kDebugMode && stackTrace != null) {
      debugPrint(stackTrace.toString());
    }
  }
}
