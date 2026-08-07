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
    if (apiKey.isEmpty) return null;

    try {
      final obverseBytes = await obversePhoto.readAsBytes();
      final obverseBase64 = base64Encode(obverseBytes);

      final parts = <Map<String, dynamic>>[
        {
          'text': '''
Analiza numismáticamente este par de fotos (Anverso y opcionalmente Reverso) de una moneda o billete.
Responde ÚNICA Y EXCLUSIVAMENTE en JSON estricto con esta estructura:
{
  "speciesType": "Moneda" o "Billete",
  "generalSpeciesName": "Moneda" o "Billete",
  "subspeciesName": "Ej: 5 Pesetas (Juan Carlos I - 1982)",
  "brandOrMint": "Ej: Real Casa de la Moneda (M) o Banco de España",
  "country": "Ej: España",
  "year": "Ej: 1982",
  "faceValue": "Ej: 5 Pesetas",
  "composition": "Ej: Cuproníquel, Plata .925, Bronce, Papel",
  "massGrams": 5.75,
  "diameterMm": 23.0,
  "grade": "Ej: MBC / VF / EBC",
  "serialNumber": "Número de serie si es billete",
  "catalogCode": "Ej: KM# 821 o Pick# 142",
  "notes": "Resumen histórico o descripción numismática"
}
Si un valor numérico como massGrams o diameterMm no es deducible, usa null.
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

      // Probar modelos de Gemini en orden (2.5-flash -> 2.0-flash -> 1.5-flash)
      final models = ['gemini-2.5-flash', 'gemini-2.0-flash', 'gemini-1.5-flash'];

      for (final model in models) {
        final url = Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=$apiKey');

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
        ).timeout(const Duration(seconds: 18));

        if (response.statusCode == 200) {
          final decoded = jsonDecode(response.body);
          final candidates = decoded['candidates'] as List?;
          if (candidates != null && candidates.isNotEmpty) {
            final contentParts = candidates.first['content']['parts'] as List?;
            if (contentParts != null && contentParts.isNotEmpty) {
              final rawText = contentParts.first['text'] as String;
              final cleanJsonText = rawText.replaceAll(RegExp(r'^```json\s*|\s*```$'), '').trim();
              final data = jsonDecode(cleanJsonText) as Map<String, dynamic>;

              return NumismaticScanResult(
                speciesType: (data['speciesType']?.toString() ?? 'Moneda').trim(),
                generalSpeciesName: (data['generalSpeciesName']?.toString() ?? 'Moneda').trim(),
                subspeciesName: (data['subspeciesName']?.toString() ?? 'Moneda / Billete Numismático').trim(),
                brandOrMint: data['brandOrMint']?.toString(),
                country: data['country']?.toString(),
                year: data['year']?.toString(),
                faceValue: data['faceValue']?.toString(),
                composition: data['composition']?.toString(),
                massGrams: (data['massGrams'] is num) ? (data['massGrams'] as num).toDouble() : double.tryParse(data['massGrams']?.toString() ?? ''),
                diameterMm: (data['diameterMm'] is num) ? (data['diameterMm'] as num).toDouble() : double.tryParse(data['diameterMm']?.toString() ?? ''),
                grade: data['grade']?.toString(),
                serialNumber: data['serialNumber']?.toString(),
                catalogCode: data['catalogCode']?.toString(),
                notes: data['notes']?.toString(),
                obversePhotoPath: obversePhoto.path,
                reversePhotoPath: reversePhoto?.path,
                sourceEngine: 'Gemini Vision',
              );
            }
          }
        }
      }
    } catch (e) {
      // Ignorar excepción y permitir fallback en cascada
    }
    return null;
  }
}
