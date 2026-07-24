import 'brand_dictionary.dart';
import 'fast_lazy_taxonomy_registry.dart';
import 'product_taxonomy_dictionary.dart';
import 'spanish_singularizer.dart';

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

  /// Resolver la especie general atómica en SINGULAR ESTRICTO a partir de millones de datos compilados
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

    // 2. Consulta ultrarrápida O(1) en FastLazyTaxonomyRegistry (Catálogo Compilado Masivo)
    final lazyMatch = FastLazyTaxonomyRegistry.lookup(combinedText);
    if (lazyMatch != null) {
      final singularName = SpanishSingularizer.toSingular(lazyMatch.species);
      return TaxonomyResolution(
        generalSpeciesName: singularName,
        department: lazyMatch.department,
        inferredBrand: finalBrand,
        confidence: 0.95,
      );
    }

    // 3. Evaluar reglas de ProductTaxonomyDictionary
    CategoryDefinition? bestMatch;
    int highestScore = 0;

    for (final def in ProductTaxonomyDictionary.definitions) {
      int score = 0;

      if (def.regexPatterns != null) {
        for (final pattern in def.regexPatterns!) {
          if (RegExp(pattern, caseSensitive: false).hasMatch(combinedText)) {
            score += 50;
            break;
          }
        }
      }

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
      final singularSpeciesName = SpanishSingularizer.toSingular(bestMatch.generalSpeciesName);

      return TaxonomyResolution(
        generalSpeciesName: singularSpeciesName,
        department: bestMatch.department,
        inferredBrand: finalBrand,
        confidence: (highestScore / 50.0).clamp(0.5, 1.0),
      );
    }

    // 4. Fallback NLP + Singularizer: Extraer sustantivo principal en SINGULAR si no coincide en diccionarios
    final nlpSpeciesName = _extractNounFromTitle(cleanTitle, finalBrand);

    return TaxonomyResolution(
      generalSpeciesName: SpanishSingularizer.toSingular(nlpSpeciesName),
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

    cleaned = cleaned.replaceAll(RegExp(r'\b\d+(\.\d+)?\s*(ml|l|g|kg|gb|tb|mb|hz|v|w|in|mm|cm|m|k|p|fps)\b', caseSensitive: false), '');
    cleaned = cleaned.replaceAll(RegExp(r'\b\d{2,4}[a-z]*\b', caseSensitive: false), '');
    cleaned = cleaned.replaceAll(RegExp(r'[^\w\s\u00C0-\u017F]', unicode: true), ' ');

    final words = cleaned.trim().split(RegExp(r'\s+')).where((w) => w.length >= 3).toList();

    if (words.isNotEmpty) {
      final firstWord = words.first;
      return firstWord[0].toUpperCase() + firstWord.substring(1).toLowerCase();
    }

    return 'Objeto';
  }
}
