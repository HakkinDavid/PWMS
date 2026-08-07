import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/storage/app_settings_repository.dart';
import '../domain/numismatic_recognition_models.dart';
import 'gemini_numismatic_service.dart';
import 'numista_api_service.dart';

class NumismaticRecognitionEngine {
  final AppSettingsRepository _settingsRepo;
  final GeminiNumismaticService _geminiService = GeminiNumismaticService();
  final NumistaApiService _numistaService = NumistaApiService();

  NumismaticRecognitionEngine(this._settingsRepo);

  Future<NumismaticScanResult> processDualPhotos({
    required File obversePhoto,
    File? reversePhoto,
  }) async {
    // 1. Intento con Gemini Vision API
    final geminiKey = await _settingsRepo.getGeminiApiKey();
    if (geminiKey != null && geminiKey.trim().isNotEmpty) {
      final geminiResult = await _geminiService.analyzeNumismaticItem(
        obversePhoto: obversePhoto,
        reversePhoto: reversePhoto,
        apiKey: geminiKey,
      );
      if (geminiResult != null) {
        return geminiResult;
      }
    }

    // 2. Intento de fallback con Numista API
    final numistaKey = await _settingsRepo.getNumistaApiKey();
    final numistaData = await _numistaService.searchNumistaCatalog(
      query: 'Coin Banknote',
      apiKey: numistaKey,
    );

    if (numistaData != null) {
      final title = numistaData['title'] as String? ?? 'Moneda / Billete Numismático';
      final isBanknote = title.toLowerCase().contains('banknote') || title.toLowerCase().contains('billete');

      return NumismaticScanResult(
        speciesType: isBanknote ? 'Billete' : 'Moneda',
        generalSpeciesName: isBanknote ? 'Billete' : 'Moneda',
        subspeciesName: title,
        country: numistaData['issuer'] as String?,
        year: numistaData['year'] as String?,
        composition: numistaData['composition'] as String?,
        massGrams: numistaData['weight'] as double?,
        diameterMm: numistaData['diameter'] as double?,
        obversePhotoPath: obversePhoto.path,
        reversePhotoPath: reversePhoto?.path,
        sourceEngine: 'Numista API',
      );
    }

    // 3. Fallback en Modo Degradado Local (Sin interrupciones para el usuario)
    return NumismaticScanResult(
      speciesType: 'Moneda',
      generalSpeciesName: 'Moneda',
      subspeciesName: 'Pieza Numismática (Escaneo Manual)',
      notes: 'Captura registrada con fotos de Anverso y Reverso. Completa los detalles numismáticos.',
      obversePhotoPath: obversePhoto.path,
      reversePhotoPath: reversePhoto?.path,
      sourceEngine: 'Modo Local',
    );
  }
}

final numismaticRecognitionEngineProvider = Provider<NumismaticRecognitionEngine>((ref) {
  final settingsRepo = ref.watch(appSettingsRepositoryProvider);
  return NumismaticRecognitionEngine(settingsRepo);
});
