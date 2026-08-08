import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../domain/numismatic_recognition_models.dart';

class GeminiNumismaticService {
  Future<NumismaticScanResult?> analyzeNumismaticItem({
    required File obversePhoto,
    File? reversePhoto,
    required String apiKey,
  }) async {
    final cleanKey = apiKey.trim();
    if (cleanKey.isEmpty) {
      throw Exception('La clave API de Gemini está vacía. Configúrala en la tuerca ⚙️ de ajustes.');
    }

    try {
      final obverseBytes = await obversePhoto.readAsBytes();
      final obverseBase64 = base64Encode(obverseBytes);

      final parts = <Map<String, dynamic>>[
        {
          'text': '''
Eres un experto numismático mundial. Analiza las imágenes adjuntas de la moneda o billete (Anverso y Reverso) e identifica la pieza con la mayor precisión técnica posible.
Responde ÚNICA Y EXCLUSIVAMENTE con un objeto JSON válido sin bloques de código markdown:
{
  "speciesType": "Moneda" o "Billete",
  "generalSpeciesName": "Moneda" o "Billete",
  "subspeciesName": "Nombre específico con denominación, año y personaje/emisor (ej: 5 Pesetas - Juan Carlos I - 1982)",
  "brandOrMint": "Marca de ceca o banco emisor (ej: Real Casa de la Moneda, FNMT, US Mint, Banco de España)",
  "country": "País emisor",
  "year": "Año de acuñación o emisión (ej: 1982)",
  "faceValueNumber": 5.0,
  "currencyCode": "Código ISO o abreviación de la moneda (ej: ESP, EUR, USD, MXN)",
  "currencyName": "Nombre de la moneda o unidad monetaria (ej: Pesetas, Euros, Dólares, Pesos)",
  "composition": "Composición metálica o material (ej: Plata .925, Cuproníquel, Bronce, Papel)",
  "massGrams": 5.75,
  "diameterMm": 23.0,
  "thicknessMm": 1.8,
  "lengthMm": 140.0,
  "widthMm": 75.0,
  "grade": "Estimación del estado de conservación (ej: BC, MBC, EBC, FDC / VF, XF, UNC)",
  "serialNumber": "Número de serie si es billete",
  "catalogCode": "Código de catálogo (ej: KM# 821, Pick# 142)",
  "notes": "Resumen histórico o descripción numismática resumida de la pieza"
}
Si un valor numérico no es deducible, coloca null para los campos numéricos (faceValueNumber, massGrams, diameterMm, thicknessMm, lengthMm, widthMm).
'''
        },
        {
          'inline_data': {
            'mime_type': 'image/jpeg',
            'data': obverseBase64,
          }
        }
      ];

      if (reversePhoto != null && await reversePhoto.exists()) {
        final reverseBytes = await reversePhoto.readAsBytes();
        parts.add({
          'inline_data': {
            'mime_type': 'image/jpeg',
            'data': base64Encode(reverseBytes),
          }
        });
      }

      print('🌐 [PWMS Gemini] Obteniendo lista de modelos disponibles para la API Key...');
      String targetModel = 'gemini-1.5-flash';

      try {
        final listUrl = Uri.parse('https://generativelanguage.googleapis.com/v1beta/models?key=$cleanKey');
        final listResponse = await http.get(listUrl).timeout(const Duration(seconds: 8));

        print('📋 [PWMS Gemini] Models Discovery Status: ${listResponse.statusCode}');
        if (listResponse.statusCode == 200) {
          final listDecoded = jsonDecode(listResponse.body);
          final modelsList = listDecoded['models'] as List?;
          if (modelsList != null && modelsList.isNotEmpty) {
            print('📋 [PWMS Gemini] Modelos disponibles en tu cuenta Google AI Studio:');
            for (final m in modelsList) {
              print('   - ${m['name']}');
            }
            final flashModel = modelsList.firstWhere(
              (m) => (m['name'] as String? ?? '').contains('flash') && (m['supportedGenerationMethods'] as List? ?? []).contains('generateContent'),
              orElse: () => modelsList.firstWhere(
                (m) => (m['supportedGenerationMethods'] as List? ?? []).contains('generateContent'),
                orElse: () => {'name': 'models/gemini-1.5-flash'},
              ),
            );
            final rawName = flashModel['name'] as String? ?? 'models/gemini-1.5-flash';
            targetModel = rawName.replaceFirst('models/', '');
          }
        }
      } catch (e) {
        print('⚠️ [PWMS Gemini] Fallo en la llamada a v1beta/models: $e');
      }

      print('🚀 [PWMS Gemini] Enviando fotos a modelo objetivo: $targetModel...');
      final url = Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/$targetModel:generateContent?key=$cleanKey');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {'parts': parts}
          ],
          'generationConfig': {
            'response_mime_type': 'application/json',
            'temperature': 0.1,
          }
        }),
      ).timeout(const Duration(seconds: 25));

      print('📥 [PWMS Gemini] Response Status Code: ${response.statusCode}');
      print('📦 [PWMS Gemini] RESPUESTA COMPLETA DE GEMINI:\n${response.body}\n----------------------------------');

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final candidates = decoded['candidates'] as List?;
        if (candidates != null && candidates.isNotEmpty) {
          final contentParts = candidates.first['content']['parts'] as List?;
          if (contentParts != null && contentParts.isNotEmpty) {
            final rawText = contentParts.first['text'] as String;
            print('✨ [PWMS Gemini] JSON de Gemini Parsedeado:\n$rawText');
            final cleanJsonText = rawText.replaceAll(RegExp(r'^```json\s*|\s*```$'), '').trim();
            final data = jsonDecode(cleanJsonText) as Map<String, dynamic>;

            return NumismaticScanResult(
              speciesType: (data['speciesType']?.toString() ?? 'Moneda').trim(),
              generalSpeciesName: (data['generalSpeciesName']?.toString() ?? 'Moneda').trim(),
              subspeciesName: (data['subspeciesName']?.toString() ?? 'Moneda / Billete Numismático').trim(),
              brandOrMint: data['brandOrMint']?.toString(),
              country: data['country']?.toString(),
              year: data['year']?.toString(),
              faceValueNumber: (data['faceValueNumber'] is num) ? (data['faceValueNumber'] as num).toDouble() : double.tryParse(data['faceValueNumber']?.toString() ?? ''),
              currencyCode: data['currencyCode']?.toString(),
              currencyName: data['currencyName']?.toString(),
              composition: data['composition']?.toString(),
              massGrams: (data['massGrams'] is num) ? (data['massGrams'] as num).toDouble() : double.tryParse(data['massGrams']?.toString() ?? ''),
              diameterMm: (data['diameterMm'] is num) ? (data['diameterMm'] as num).toDouble() : double.tryParse(data['diameterMm']?.toString() ?? ''),
              thicknessMm: (data['thicknessMm'] is num) ? (data['thicknessMm'] as num).toDouble() : double.tryParse(data['thicknessMm']?.toString() ?? ''),
              lengthMm: (data['lengthMm'] is num) ? (data['lengthMm'] as num).toDouble() : double.tryParse(data['lengthMm']?.toString() ?? ''),
              widthMm: (data['widthMm'] is num) ? (data['widthMm'] as num).toDouble() : double.tryParse(data['widthMm']?.toString() ?? ''),
              grade: data['grade']?.toString(),
              serialNumber: data['serialNumber']?.toString(),
              catalogCode: data['catalogCode']?.toString(),
              notes: data['notes']?.toString(),
              obversePhotoPath: obversePhoto.path,
              reversePhotoPath: reversePhoto?.path,
              sourceEngine: 'Gemini Vision ($targetModel)',
            );
          }
        }
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        throw Exception('Clave API de Gemini inválida o sin permisos (HTTP ${response.statusCode}). Revisa tu API Key en la tuerca ⚙️ de ajustes.');
      } else if (response.statusCode == 429) {
        throw Exception('Límite de solicitudes alcanzado en Gemini (HTTP 429). Espera unos segundos antes de intentar un nuevo escaneo.');
      } else {
        throw Exception('Error en Gemini (HTTP ${response.statusCode}): ${response.body}');
      }
    } catch (e) {
      print('❌ [PWMS Gemini Error]: $e');
      rethrow;
    }
    return null;
  }
}
