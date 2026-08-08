import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
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
      File imageToSend = obversePhoto;
      if (reversePhoto != null && await reversePhoto.exists()) {
        try {
          imageToSend = await _stitchDualPhotos(obversePhoto, reversePhoto);
        } catch (e) {
          print('⚠️ [PWMS Gemini] Fallo al unir fotos: $e. Enviando anverso solamente.');
        }
      }

      final imageBytes = await imageToSend.readAsBytes();
      final imageBase64 = base64Encode(imageBytes);

      final parts = <Map<String, dynamic>>[
        {
          'text': '''
Eres un experto numismático mundial. Analiza la imagen adjunta que contiene el Anverso (izquierda) y Reverso (derecha, si aplica) de una moneda o billete e identifica la pieza con la mayor precisión técnica posible.
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
            'data': imageBase64,
          }
        }
      ];

      print('🌐 [PWMS Gemini] Consultando modelos disponibles en Google AI Studio...');
      List<String> validModelNames = [];

      try {
        final listUrl = Uri.parse('https://generativelanguage.googleapis.com/v1beta/models?key=$cleanKey');
        final listResponse = await http.get(listUrl).timeout(const Duration(seconds: 8));

        print('📋 [PWMS Gemini] Models Discovery Status: ${listResponse.statusCode}');
        if (listResponse.statusCode == 200) {
          final listDecoded = jsonDecode(listResponse.body);
          final modelsList = listDecoded['models'] as List?;
          if (modelsList != null && modelsList.isNotEmpty) {
            print('📋 [PWMS Gemini] Modelos disponibles en tu cuenta:');
            for (final m in modelsList) {
              final rawName = m['name'] as String? ?? '';
              final name = rawName.replaceFirst('models/', '');
              final methods = (m['supportedGenerationMethods'] as List? ?? []);

              // Descartar gemini-2.5-flash explícitamente ya que Google la marcó como no disponible para nuevas claves
              if (methods.contains('generateContent') && !name.startsWith('gemini-2.5-flash') && !name.contains('embedding') && !name.contains('imagen') && !name.contains('veo') && !name.contains('aqa')) {
                validModelNames.add(name);
              }
            }
          }
        }
      } catch (e) {
        print('⚠️ [PWMS Gemini] Fallo en la llamada de descubrimiento: $e');
      }

      // Priorizar modelos activos estándar
      final preferredOrder = [
        'gemini-2.0-flash',
        'gemini-3.5-flash',
        'gemini-3.6-flash',
        'gemini-flash-latest',
        'gemini-2.0-flash-001',
        'gemini-1.5-flash',
      ];

      validModelNames.sort((a, b) {
        int indexA = preferredOrder.indexOf(a);
        int indexB = preferredOrder.indexOf(b);
        if (indexA == -1) indexA = 999;
        if (indexB == -1) indexB = 999;
        return indexA.compareTo(indexB);
      });

      if (validModelNames.isEmpty) {
        validModelNames = ['gemini-2.0-flash', 'gemini-3.5-flash', 'gemini-flash-latest'];
      }

      print('🎯 [PWMS Gemini] Modelos candidatos ordenados por prioridad: $validModelNames');

      for (final targetModel in validModelNames) {
        print('🚀 [PWMS Gemini] Intentando análisis con imagen unificada en modelo: $targetModel...');
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

        print('📥 [PWMS Gemini ($targetModel)] Status Code: ${response.statusCode}');
        print('📦 [PWMS Gemini ($targetModel)] RESPUESTA COMPLETA:\n${response.body}\n----------------------------------');

        if (response.statusCode == 200) {
          final decoded = jsonDecode(response.body);
          final candidates = decoded['candidates'] as List?;
          if (candidates != null && candidates.isNotEmpty) {
            final contentParts = candidates.first['content']['parts'] as List?;
            if (contentParts != null && contentParts.isNotEmpty) {
              final rawText = contentParts.first['text'] as String;
              print('✨ [PWMS Gemini] JSON Extraído Exitosamente:\n$rawText');
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
        } else if (response.statusCode == 404) {
          print('⚠️ Modelo $targetModel retornó 404 (obsoleto/no disponible). Probando siguiente candidato...');
          continue;
        } else {
          throw Exception('Error en Gemini (HTTP ${response.statusCode}): ${response.body}');
        }
      }

      throw Exception('Ninguno de los modelos multimodales activos respondió con éxito. Revisa la consola para más detalles.');
    } catch (e) {
      print('❌ [PWMS Gemini Error]: $e');
      rethrow;
    }
  }

  Future<File> _stitchDualPhotos(File obversePhoto, File reversePhoto) async {
    final bytes1 = await obversePhoto.readAsBytes();
    final bytes2 = await reversePhoto.readAsBytes();

    final img1 = img.decodeImage(bytes1);
    final img2 = img.decodeImage(bytes2);

    if (img1 == null || img2 == null) return obversePhoto;

    // Escalar la segunda foto si su altura difiere de la primera
    final targetHeight = img1.height;
    final resizedImg2 = (img2.height != targetHeight)
        ? img.copyResize(img2, height: targetHeight)
        : img2;

    const margin = 20;
    final totalWidth = img1.width + resizedImg2.width + margin;
    final totalHeight = targetHeight;

    final combined = img.Image(width: totalWidth, height: totalHeight);

    // Fondo gris neutro/oscuro
    img.fill(combined, color: img.ColorRgb8(30, 30, 30));

    // Dibujar Anverso a la izquierda
    img.compositeImage(combined, img1, dstX: 0, dstY: 0);

    // Dibujar Reverso a la derecha
    img.compositeImage(combined, resizedImg2, dstX: img1.width + margin, dstY: 0);

    final combinedPath = obversePhoto.path.replaceAll('.jpg', '_combined.jpg');
    final combinedFile = File(combinedPath);
    await combinedFile.writeAsBytes(img.encodeJpg(combined, quality: 85));

    print('📸 [PWMS Gemini] Fotos de Anverso y Reverso unidas exitosamente en 1 sola imagen composite (${totalWidth}x${totalHeight}px).');
    return combinedFile;
  }
}
