import 'package:platinum_world_management_system/src/core/constants/app_technical_strings.dart';

class BrandDictionary {
  BrandDictionary._();

  static const List<String> allBrands = AppTechnicalBrands.allBrands;

  /// Mapeo secundario de familias de productos icónicas (usado SOLO si no hay marca explícita en allBrands)
  static const Map<String, String> productFamilyToBrand = AppTechnicalBrands.productFamilyToBrand;

  /// Normalizar texto eliminando acentos
  static String _normalize(String s) {
    var result = s;
    for (final entry in AppTechnicalBrands.accentReplacements.entries) {
      result = result.replaceAll(entry.key, entry.value);
    }
    return result;
  }

  /// Inferir marca: Prioriza marcas explícitas en allBrands; si no encuentra, busca familias icónicas secundarias
  static String? inferBrand(String text) {
    if (text.trim().isEmpty) return null;
    final normalizedText = _normalize(text);

    // 1. Buscar primero marcas explícitas ordenadas por longitud descendente
    final sortedBrands = List<String>.from(allBrands)..sort((a, b) => b.length.compareTo(a.length));

    for (final brand in sortedBrands) {
      final normBrand = _normalize(brand);
      final pattern = RegExp(AppTechnicalStrings.wordBoundary + RegExp.escape(normBrand) + AppTechnicalStrings.wordBoundary, caseSensitive: false);
      if (pattern.hasMatch(normalizedText)) {
        return brand;
      }
    }

    // 2. Si no hay marca explícita, buscar familias icónicas secundarias
    for (final entry in productFamilyToBrand.entries) {
      final pattern = RegExp(AppTechnicalStrings.wordBoundary + entry.key + AppTechnicalStrings.wordBoundary, caseSensitive: false);
      if (pattern.hasMatch(normalizedText)) {
        return entry.value;
      }
    }

    return null;
  }
}
