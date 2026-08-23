import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';
import '../providers/providers.dart';

class AppSettingsRepository {
  final AppDatabase _db;

  AppSettingsRepository(this._db);

  static const String keyGeminiApiKey = 'gemini_api_key';
  static const String keyNumistaApiKey = 'numista_api_key';

  Future<String?> getGeminiApiKey() async {
    return await _db.getSetting(keyGeminiApiKey);
  }

  Future<void> setGeminiApiKey(String value) async {
    await _db.setSetting(keyGeminiApiKey, value.trim());
  }

  Future<String?> getNumistaApiKey() async {
    return await _db.getSetting(keyNumistaApiKey);
  }

  Future<void> setNumistaApiKey(String value) async {
    await _db.setSetting(keyNumistaApiKey, value.trim());
  }

  static const String keyLastNumismaticLocationMode = 'last_numismatic_location_mode';
  static const String keyLastNumismaticLocationId = 'last_numismatic_location_id';
  static const String keyLastNumismaticContainerEntityId = 'last_numismatic_container_entity_id';

  Future<String?> getLastNumismaticLocationMode() async {
    return await _db.getSetting(keyLastNumismaticLocationMode);
  }

  Future<void> setLastNumismaticLocationMode(String value) async {
    await _db.setSetting(keyLastNumismaticLocationMode, value.trim());
  }

  Future<String?> getLastNumismaticLocationId() async {
    return await _db.getSetting(keyLastNumismaticLocationId);
  }

  Future<void> setLastNumismaticLocationId(String value) async {
    await _db.setSetting(keyLastNumismaticLocationId, value.trim());
  }

  Future<String?> getLastNumismaticContainerEntityId() async {
    return await _db.getSetting(keyLastNumismaticContainerEntityId);
  }

  Future<void> setLastNumismaticContainerEntityId(String value) async {
    await _db.setSetting(keyLastNumismaticContainerEntityId, value.trim());
  }

  // Numismatic Camera Settings & Preferences
  static const String keyNumismaticTorchEnabled = 'numismatic_torch_enabled';
  static const String keyNumismaticExposureOffset = 'numismatic_exposure_offset';
  static const String keyNumismaticDefaultMode = 'numismatic_default_mode';
  static const String keyNumismaticZoomLevel = 'numismatic_zoom_level';

  Future<bool> getNumismaticTorchEnabled({bool defaultValue = false}) async {
    final val = await _db.getSetting(keyNumismaticTorchEnabled);
    if (val == null) return defaultValue;
    return val.toLowerCase() == 'true';
  }

  Future<void> setNumismaticTorchEnabled(bool value) async {
    await _db.setSetting(keyNumismaticTorchEnabled, value.toString());
  }

  Future<double> getNumismaticExposureOffset({double defaultValue = -1.5}) async {
    final val = await _db.getSetting(keyNumismaticExposureOffset);
    if (val == null) return defaultValue;
    return double.tryParse(val) ?? defaultValue;
  }

  Future<void> setNumismaticExposureOffset(double value) async {
    await _db.setSetting(keyNumismaticExposureOffset, value.toString());
  }

  Future<String?> getNumismaticDefaultMode() async {
    return await _db.getSetting(keyNumismaticDefaultMode);
  }

  Future<void> setNumismaticDefaultMode(String mode) async {
    await _db.setSetting(keyNumismaticDefaultMode, mode.trim());
  }

  Future<double> getNumismaticZoomLevel({double defaultValue = 1.0}) async {
    final val = await _db.getSetting(keyNumismaticZoomLevel);
    if (val == null) return defaultValue;
    return double.tryParse(val) ?? defaultValue;
  }

  Future<void> setNumismaticZoomLevel(double value) async {
    await _db.setSetting(keyNumismaticZoomLevel, value.toString());
  }
}

final appSettingsRepositoryProvider = Provider<AppSettingsRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return AppSettingsRepository(db);
});

final geminiApiKeyProvider = FutureProvider<String?>((ref) async {
  final repo = ref.watch(appSettingsRepositoryProvider);
  return repo.getGeminiApiKey();
});

final numistaApiKeyProvider = FutureProvider<String?>((ref) async {
  final repo = ref.watch(appSettingsRepositoryProvider);
  return repo.getNumistaApiKey();
});
