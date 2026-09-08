import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import 'package:platinum_world_management_system/src/core/constants/app_technical_strings.dart';
import 'data/numismatic_currencies_registry.dart';
import 'data/numismatic_denominations_registry.dart';
import 'numismatic_parser.dart';

/// Centralized naming and denomination formatting engine for numismatic specimens and currencies.
/// Guarantees museum-grade case consistency and natural subunit hierarchy resolution.
abstract final class NumismaticNamingEngine {
  /// Formats a raw denomination string into a natural, brief label suitable for UI wheel pickers and chips.
  ///
  /// Examples:
  /// - ('0.20', 'MXP') -> '20 Centavos'
  /// - ('0.50', 'MXN') -> '50 Centavos'
  /// - ('0.25', 'USD') -> '25 Centavos'
  /// - ('0.50', 'EUR') -> '50 Céntimos de Euro'
  /// - ('1', 'MXN') -> '1 Peso'
  /// - ('5', 'MXN') -> '5 Pesos'
  /// - ('1/2', 'REAL') -> '1/2 Real'
  /// - ('8', 'MXR') -> '8 Reales'
  static String formatDenominationLabel({
    required String denomination,
    String? currencyCode,
    bool isBanknote = false,
  }) {
    final cleanDenom = denomination.trim();
    if (cleanDenom.isEmpty || cleanDenom == AppStrings.otherSpecifyOption) {
      return cleanDenom;
    }

    final currDef = NumismaticCurrenciesRegistry.resolve(currencyCode);
    final numVal = NumismaticDenominationsRegistry.parseNumber(cleanDenom);

    // 1. Check if currency defines a named colloquial override for this exact denomination
    if (currDef != null && currDef.namedDenominations.isNotEmpty) {
      if (currDef.namedDenominations.containsKey(cleanDenom)) {
        return currDef.namedDenominations[cleanDenom]!;
      }
      if (numVal != null) {
        for (final entry in currDef.namedDenominations.entries) {
          final keyNum = NumismaticDenominationsRegistry.parseNumber(entry.key);
          if (keyNum != null && (keyNum - numVal).abs() < 0.0001) {
            return entry.value;
          }
        }
      }
    }

    // 2. Fractional denominations (e.g. '1/2', '1/4', '1/8')
    if (cleanDenom.contains(AppTechnicalStrings.slash)) {
      if (currDef != null) {
        final shortBase = _getBriefCurrencyUnit(currDef.name, count: 1);
        return [cleanDenom, shortBase].join(AppTechnicalStrings.space);
      }
      return cleanDenom;
    }

    // 3. Numeric subunit resolution (< 1.0)
    if (numVal != null && numVal > 0 && numVal < 1.0 && currDef != null && currDef.hasSubunit && !isBanknote) {
      final subunitCount = (numVal * currDef.subunitRatio).round();
      final subName = subunitCount == 1 ? currDef.subunitName : currDef.subunitNamePlural;
      if (subName != null && subName.isNotEmpty) {
        return [subunitCount.toString(), subName].join(AppTechnicalStrings.space);
      }
    }

    // 4. Integer or >= 1.0 denominations
    if (numVal != null && currDef != null) {
      final formattedNum = numVal % 1 == 0 ? numVal.toInt().toString() : numVal.toString();
      final briefUnit = _getBriefCurrencyUnit(numVal == 1.0 ? currDef.name : currDef.namePlural, count: numVal);
      return [formattedNum, briefUnit].join(AppTechnicalStrings.space);
    }

    return cleanDenom;
  }

  /// Formats the denomination paired with the full, case-consistent canonical currency name,
  /// or returns the named denomination if defined (e.g. 'Penny', 'Nickel', 'Dime').
  ///
  /// Examples:
  /// - ('0.01', 'USD') -> 'Penny de Dólares Estadounidenses'
  /// - ('0.50', 'MXP') -> 'Tostón de Pesos Mexicanos Antiguos'
  /// - ('0.20', 'MXP') -> '20 Centavos de Pesos Mexicanos Antiguos'
  /// - ('50', 'MXP') -> '50 Pesos Mexicanos Antiguos'
  /// - ('20', 'MXN') -> '20 Pesos Mexicanos'
  /// - ('1', 'USD') -> '1 Dólar Estadounidense'
  /// - ('0.50', 'EUR') -> '50 Céntimos de Euro'
  /// - ('8', 'MXR') -> 'Real de a 8 de Reales Mexicanos Coloniales e Imperiales'
  static String formatDenominationWithFullCurrency({
    required String denomination,
    String? currencyCode,
    double? faceValueNumber,
  }) {
    final cleanDenom = denomination.trim();
    final currDef = NumismaticCurrenciesRegistry.resolve(currencyCode);
    final numVal = faceValueNumber ?? NumismaticDenominationsRegistry.parseNumber(cleanDenom);

    // Fallback if currency definition is absent
    if (currDef == null) {
      final rawCurr = currencyCode?.trim() ?? AppTechnicalStrings.empty;
      final canonicalName = NumismaticParser.resolveCurrencyName(rawCurr, count: numVal);
      final countStr = cleanDenom.isNotEmpty
          ? cleanDenom
          : (numVal != null ? (numVal % 1 == 0 ? numVal.toInt().toString() : numVal.toString()) : AppTechnicalStrings.empty);
      return [countStr, canonicalName].where((s) => s.isNotEmpty).join(AppTechnicalStrings.space);
    }

    // 1. Check if currency defines a named denomination override (e.g. '0.01' USD -> 'Penny de Dólares Estadounidenses', '0.50' MXP -> 'Tostón de Pesos Mexicanos Antiguos')
    if (currDef.namedDenominations.isNotEmpty) {
      String? named;
      if (currDef.namedDenominations.containsKey(cleanDenom)) {
        named = currDef.namedDenominations[cleanDenom]!;
      } else if (numVal != null) {
        for (final entry in currDef.namedDenominations.entries) {
          final keyNum = NumismaticDenominationsRegistry.parseNumber(entry.key);
          if (keyNum != null && (keyNum - numVal).abs() < 0.0001) {
            named = entry.value;
            break;
          }
        }
      }
      if (named != null) {
        return [named, currDef.namePlural].join(AppTechnicalStrings.deWithSpaces);
      }
    }

    // 2. Fractional / Subunit case (< 1.0)
    if (numVal != null && numVal > 0 && numVal < 1.0 && currDef.hasSubunit && !cleanDenom.contains(AppTechnicalStrings.slash)) {
      final subunitCount = (numVal * currDef.subunitRatio).round();
      final subName = subunitCount == 1 ? currDef.subunitName : currDef.subunitNamePlural;
      final subunitTitle = subName ?? currDef.namePlural;
      if (subunitTitle.toLowerCase().contains(AppTechnicalStrings.deWithSpaces)) {
        return [subunitCount.toString(), subunitTitle].join(AppTechnicalStrings.space);
      }
      return [subunitCount.toString(), subunitTitle].join(AppTechnicalStrings.space) +
          AppTechnicalStrings.deWithSpaces +
          currDef.namePlural;
    }

    // 3. Fractional strings like '1/2', '1/4', '1/8'
    if (cleanDenom.contains(AppTechnicalStrings.slash)) {
      return [cleanDenom, currDef.name].join(AppTechnicalStrings.space);
    }

    // 4. Singular unit (= 1.0)
    if (numVal == 1.0 || cleanDenom == AppTechnicalStrings.strOne) {
      return [AppTechnicalStrings.strOne, currDef.name].join(AppTechnicalStrings.space);
    }

    // 5. Plural units (> 1.0)
    final formattedNum = numVal != null
        ? (numVal % 1 == 0 ? numVal.toInt().toString() : numVal.toString())
        : cleanDenom;

    return [formattedNum, currDef.namePlural].join(AppTechnicalStrings.space);
  }

  /// Builds the complete specimen display name for a coin or banknote instance.
  /// Does not include redundant country in instance display name, and formats commemorative
  /// motif in square brackets `[Motivo]`.
  ///
  /// Formula: [Denominación con Divisa / NamedDenom] ([Año]) [[Motivo]]
  ///
  /// Examples:
  /// - '20 Centavos de Pesos Mexicanos Antiguos (1975) [Francisco I. Madero]'
  /// - '50 Pesos Mexicanos Antiguos (1982) [Coyolxauhqui]'
  /// - '20 Pesos Mexicanos (2021) [500 Años de Memoria Histórica de México-Tenochtitlan]'
  /// - '1 Dólar Estadounidense (1921) [Morgan]'
  /// - 'Penny de Dólares Estadounidenses (1943) [Lincoln Wheat]'
  /// - 'Real de a 8 de Reales Mexicanos Coloniales e Imperiales (1790) [Carlos IV]'
  /// - 'Tostón de Pesos Mexicanos Antiguos (1975)'
  static String buildSpecimenTitle({
    required NumismaticAttributes attrs,
    String? defaultSpeciesName,
  }) {
    final denomStr = attrs.faceValueStr ??
        (attrs.faceValueNumber != null
            ? (attrs.faceValueNumber! % 1 == 0
                ? attrs.faceValueNumber!.toInt().toString()
                : attrs.faceValueNumber!.toString())
            : AppTechnicalStrings.empty);

    final denomWithCurr = formatDenominationWithFullCurrency(
      denomination: denomStr,
      currencyCode: attrs.currencyCode ?? attrs.currencyName,
      faceValueNumber: attrs.faceValueNumber,
    );

    final year = attrs.year?.trim();
    final motif = attrs.motif?.trim();

    var baseTitle = denomWithCurr.trim();

    if (year != null && year.isNotEmpty) {
      final cleanYr = year
          .replaceAll(AppTechnicalStrings.openParen, AppTechnicalStrings.empty)
          .replaceAll(AppTechnicalStrings.closeParen, AppTechnicalStrings.empty)
          .trim();
      if (cleanYr.isNotEmpty) {
        final yearPart = [AppTechnicalStrings.openParen, cleanYr, AppTechnicalStrings.closeParen].join(AppTechnicalStrings.empty);
        baseTitle = baseTitle.isNotEmpty
            ? [baseTitle, yearPart].join(AppTechnicalStrings.space)
            : yearPart;
      }
    }

    if (motif != null && motif.isNotEmpty) {
      final cleanMotif = motif
          .replaceAll(AppTechnicalStrings.openBracket, AppTechnicalStrings.empty)
          .replaceAll(AppTechnicalStrings.closeBracket, AppTechnicalStrings.empty)
          .trim();
      if (cleanMotif.isNotEmpty) {
        final motifPart = [AppTechnicalStrings.openBracket, cleanMotif, AppTechnicalStrings.closeBracket].join(AppTechnicalStrings.empty);
        baseTitle = baseTitle.isNotEmpty
            ? [baseTitle, motifPart].join(AppTechnicalStrings.space)
            : motifPart;
      }
    }

    if (baseTitle.isEmpty) {
      return defaultSpeciesName ?? AppStrings.defaultNumismaticPiece;
    }

    return baseTitle;
  }

  /// Helper to extract brief category name from a full currency name.
  /// e.g. 'Pesos Mexicanos' -> 'Pesos', 'Dólar Estadounidense' -> 'Dólar', 'Reales Españoles' -> 'Reales'.
  static String _getBriefCurrencyUnit(String fullName, {required double count}) {
    final clean = fullName.trim();
    final firstWord = clean.split(AppTechnicalStrings.space).first;
    return firstWord;
  }
}
