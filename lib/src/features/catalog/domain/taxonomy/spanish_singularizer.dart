import 'package:platinum_world_management_system/src/core/constants/app_technical_strings.dart';

class SpanishSingularizer {
  SpanishSingularizer._();

  /// Convierte sustantivos plurales en español e inglés a su forma singular estricta
  static String toSingular(String text) {
    var clean = text.trim();
    if (clean.isEmpty) return clean;

    final lower = clean.toLowerCase();

    // Mapeo directo de plurales comunes a singular
    const explicitPluralToSingular = AppTechnicalSpanishSingularizer.explicitPluralToSingular;

    if (explicitPluralToSingular.containsKey(lower)) {
      return explicitPluralToSingular[lower]!;
    }

    // Invariable nouns ending in 's'
    const invariableNouns = AppTechnicalSpanishSingularizer.invariableNouns;
    if (invariableNouns.contains(lower)) {
      return clean[0].toUpperCase() + clean.substring(1);
    }

    // Reglas lingüísticas gramaticales para español
    if (lower.endsWith(AppTechnicalStrings.suffixIones)) {
      clean = clean.substring(0, clean.length - 5) + AppTechnicalStrings.suffixIon;
    } else if (lower.endsWith(AppTechnicalStrings.suffixAnes)) {
      clean = clean.substring(0, clean.length - 4) + AppTechnicalStrings.suffixAn;
    } else if (lower.endsWith(AppTechnicalStrings.suffixEnes) && lower.length > 5) {
      clean = clean.substring(0, clean.length - 4) + AppTechnicalStrings.suffixEn;
    } else if (lower.endsWith(AppTechnicalStrings.suffixCes)) {
      clean = clean.substring(0, clean.length - 3) + AppTechnicalStrings.suffixZ;
    } else if (lower.endsWith(AppTechnicalStrings.suffixLes) ||
        lower.endsWith(AppTechnicalStrings.suffixRes) ||
        lower.endsWith(AppTechnicalStrings.suffixDes) ||
        lower.endsWith(AppTechnicalStrings.suffixNes)) {
      clean = clean.substring(0, clean.length - 2);
    } else if (lower.endsWith(AppTechnicalStrings.suffixEs) &&
        !lower.endsWith(AppTechnicalStrings.suffixTes) &&
        !lower.endsWith(AppTechnicalStrings.suffixQues) &&
        !lower.endsWith(AppTechnicalStrings.suffixGues) &&
        !lower.endsWith(AppTechnicalStrings.suffixSes)) {
      clean = clean.substring(0, clean.length - 2);
    } else if (lower.endsWith(AppTechnicalStrings.suffixS) &&
        !lower.endsWith(AppTechnicalStrings.suffixSs) &&
        !lower.endsWith(AppTechnicalStrings.suffixIs) &&
        !lower.endsWith(AppTechnicalStrings.suffixUs)) {
      // Regular plurals ending in -as, -os, -es (preceded by consonant like -tes), etc.
      clean = clean.substring(0, clean.length - 1);
    }

    if (clean.isEmpty) return text;
    return clean[0].toUpperCase() + clean.substring(1);
  }
}

