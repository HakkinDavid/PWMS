import 'brand_dictionary.dart';
import 'product_taxonomy_dictionary.dart';

class TaxonomyResolution {
  final String generalSpeciesName;
  final String department;
  final String? inferredBrand;
  final double confidence; // 0.0 to 1.0

  const TaxonomyResolution({
    required this.generalSpeciesName,
    required this.department,
    this.inferredBrand,
    this.confidence = 1.0,
  });
}

class ProductTaxonomyService {
  const ProductTaxonomyService();

  /// Resolver la especie general, departamento y marca inferida con precisión Nivel Walmart
  TaxonomyResolution resolve({
    required String title,
    String? categoryHint,
    String? genericName,
    String? brandHint,
  }) {
    final cleanTitle = title.trim();
    if (cleanTitle.isEmpty) {
      return const TaxonomyResolution(
        generalSpeciesName: 'Objeto',
        department: 'General',
        confidence: 0.1,
      );
    }

    // 1. Inferir marca mediante BrandDictionary
    final finalBrand = brandHint?.trim().isNotEmpty == true
        ? brandHint!.trim()
        : BrandDictionary.inferBrand(cleanTitle);

    final combinedText = '${genericName ?? ""} ${categoryHint ?? ""} $cleanTitle'.toLowerCase();

    CategoryDefinition? bestMatch;
    int highestScore = 0;

    // 2. Evaluar reglas y palabras clave de ProductTaxonomyDictionary
    for (final def in ProductTaxonomyDictionary.definitions) {
      int score = 0;

      // Evaluación por patrones Regex prioritarios
      if (def.regexPatterns != null) {
        for (final pattern in def.regexPatterns!) {
          if (RegExp(pattern, caseSensitive: false).hasMatch(combinedText)) {
            score += 50;
            break;
          }
        }
      }

      // Evaluación por palabras clave
      for (final kw in def.keywords) {
        if (combinedText.contains(kw.toLowerCase())) {
          score += (kw.length >= 5) ? 15 : 10;
        }
      }

      if (score > highestScore) {
        highestScore = score;
        bestMatch = def;
      }
    }

    if (bestMatch != null && highestScore >= 10) {
      return TaxonomyResolution(
        generalSpeciesName: bestMatch.generalSpeciesName,
        department: bestMatch.department,
        inferredBrand: finalBrand,
        confidence: (highestScore / 50.0).clamp(0.5, 1.0),
      );
    }

    // 3. Fallback NLP: Extraer sustantivo principal si no coincide con el diccionario estático
    final nlpSpeciesName = _extractNounFromTitle(cleanTitle, finalBrand);

    return TaxonomyResolution(
      generalSpeciesName: nlpSpeciesName,
      department: 'General',
      inferredBrand: finalBrand,
      confidence: 0.4,
    );
  }

  /// Extractor NLP para obtener el sustantivo principal limpia sin marcas ni códigos
  String _extractNounFromTitle(String title, String? brand) {
    var cleaned = title;
    if (brand != null && brand.isNotEmpty) {
      cleaned = cleaned.replaceAll(RegExp(brand, caseSensitive: false), '');
    }

    // Eliminar especificaciones técnicas y unidades (ej. 600ml, 128GB, 4K, 8GB, 12V, 24")
    cleaned = cleaned.replaceAll(RegExp(r'\b\d+(\.\d+)?\s*(ml|l|g|kg|gb|tb|mb|hz|v|w|in|mm|cm|m|k|p|fps)\b', caseSensitive: false), '');
    cleaned = cleaned.replaceAll(RegExp(r'\b\d{2,4}[a-z]*\b', caseSensitive: false), '');
    cleaned = cleaned.replaceAll(RegExp(r'[^\w\s\u00C0-\u017F]', unicode: true), ' ');

    final words = cleaned.trim().split(RegExp(r'\s+')).where((w) => w.length >= 3).toList();

    if (words.isNotEmpty) {
      final firstWord = words.first;
      // Capitalizar primera palabra
      return firstWord[0].toUpperCase() + firstWord.substring(1).toLowerCase();
    }

    return 'Objeto';
  }
}
