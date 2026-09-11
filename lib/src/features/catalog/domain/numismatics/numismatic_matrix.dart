import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import 'models/numismatic_models.dart';
import 'numismatic_dictionary.dart';
import 'numismatic_parser.dart';

/// Domain engine providing matrix-driven numismatic inferences and option filtering (Coins and Banknotes).
class NumismaticMatrix {
  NumismaticMatrix._();

  /// Exposes numeric and fractional denomination comparator.
  static bool matchesDenomination(String d1, String d2) =>
      NumismaticEmissionRuleData.matchesDenomination(d1, d2);

  /// Finds all matching emission rules for given country, year, and piece type (coin vs banknote).
  static List<NumismaticEmissionRuleData> findRules(
    String? country,
    int? year, {
    bool isBanknote = false,
  }) {
    if (country == null || country.trim().isEmpty || country == AppStrings.otherSpecifyOption) {
      return const [];
    }
    if (year == null) return const [];

    return NumismaticRulesRegistry.findRules(country, year, isBanknote: isBanknote);
  }

  /// Finds the best matching emission rule for given country, year, and optional currency/denomination/isBanknote.
  static NumismaticEmissionRuleData? findRule(
    String? country,
    int? year, {
    String? currencyCode,
    String? denomination,
    bool isBanknote = false,
  }) {
    final rules = findRules(country, year, isBanknote: isBanknote);
    if (rules.isEmpty) return null;
    if (rules.length == 1) return rules.first;

    // 1. If currencyCode is provided, prioritize matching rule containing this currency (and denomination if present)
    if (currencyCode != null && currencyCode.trim().isNotEmpty) {
      final iso = NumismaticParser.resolveCurrencyIsoCode(currencyCode);
      if (denomination != null && denomination.trim().isNotEmpty && denomination != AppStrings.otherSpecifyOption) {
        final cleanDenom = denomination.trim();
        for (final rule in rules) {
          if (rule.validCurrencies.contains(iso) && rule.hasDenomination(cleanDenom, year: year)) {
            return rule;
          }
        }
      }
      for (final rule in rules) {
        if (rule.validCurrencies.contains(iso)) {
          return rule;
        }
      }
    }

    // 2. If denomination is provided without currency, find rule matching this denomination
    if (denomination != null && denomination.trim().isNotEmpty && denomination != AppStrings.otherSpecifyOption) {
      final cleanDenom = denomination.trim();
      for (final rule in rules) {
        if (rule.hasDenomination(cleanDenom, year: year)) {
          return rule;
        }
      }
    }

    return rules.first;
  }

  /// Evaluates the complete numismatic query context in a single pass.
  static NumismaticInferenceResult evaluate(NumismaticQueryContext context) {
    final country = context.country;
    final year = context.year;
    final currencyCode = context.currencyCode;
    final denomination = context.denomination;
    final isBanknote = context.isBanknote;

    if (country == null || country.trim().isEmpty || country == AppStrings.otherSpecifyOption) {
      return NumismaticInferenceResult(
        availableCurrencies: NumismaticDictionary.currencyMap.keys.toList(),
        availableDenominations: [...NumismaticDictionary.denominations],
      );
    }

    final rules = findRules(country, year, isBanknote: isBanknote);
    if (rules.isEmpty) {
      return NumismaticInferenceResult(
        availableCurrencies: NumismaticDictionary.getCurrenciesForCountry(country),
        availableDenominations: [...NumismaticDictionary.denominations],
      );
    }

    final matchingEpoch = findRule(
      country,
      year,
      currencyCode: currencyCode,
      denomination: denomination,
      isBanknote: isBanknote,
    ) ?? rules.first;

    // 1. Currencies
    final availableCurrencies = <String>[];
    for (final r in rules) {
      for (final c in r.validCurrencies) {
        if (!availableCurrencies.contains(c)) availableCurrencies.add(c);
      }
    }
    final inferredCurrency = availableCurrencies.length == 1
        ? availableCurrencies.first
        : matchingEpoch.defaultCurrency;

    // 2. Pieces & Denominations
    final availablePieces = <NumismaticPieceDefinition>[];
    for (final r in rules) {
      for (final p in r.getPiecesForYear(year)) {
        if (!availablePieces.any((existing) => existing.matchesDenomination(p.denomination))) {
          availablePieces.add(p);
        }
      }
    }

    final availableDenoms = availablePieces.isNotEmpty
        ? availablePieces.map((p) => p.denomination).toList()
        : rules.expand((r) => r.getDenominationsForYear(year)).toSet().toList();

    // 3. Piece-level resolution if denomination provided
    NumismaticPieceDefinition? matchingPiece;
    List<String> validMaterials = const [];
    String? inferredMaterial;
    List<String> availableMotifs = const [];

    if (denomination != null && denomination.trim().isNotEmpty && denomination != AppStrings.otherSpecifyOption) {
      final cleanDenom = denomination.trim();
      matchingPiece = matchingEpoch.getPieceForDenomination(cleanDenom, year: year, currencyCode: currencyCode);
      validMaterials = matchingEpoch.getAllowedMaterialsForDenomination(cleanDenom, year: year, currencyCode: currencyCode);
      inferredMaterial = matchingEpoch.getMaterialForDenomination(cleanDenom, year: year, currencyCode: currencyCode);
      availableMotifs = matchingEpoch.getCommemorativeMotifsForDenomination(cleanDenom, year: year, currencyCode: currencyCode);
    }

    return NumismaticInferenceResult(
      matchingEpoch: matchingEpoch,
      matchingPiece: matchingPiece,
      availableCurrencies: availableCurrencies,
      inferredCurrency: inferredCurrency,
      availableDenominations: [...availableDenoms, AppStrings.otherSpecifyOption],
      availablePieces: availablePieces,
      validMaterials: validMaterials,
      inferredMaterial: inferredMaterial,
      availableMotifs: availableMotifs,
    );
  }

  /// Returns valid currency ISO codes for a given country, year, and piece type.
  static List<String> getCurrencies({
    String? country,
    int? year,
    bool isBanknote = false,
  }) {
    if (country == null || country.trim().isEmpty || country == AppStrings.otherSpecifyOption) {
      return NumismaticDictionary.currencyMap.keys.toList();
    }

    if (year != null) {
      final rules = findRules(country, year, isBanknote: isBanknote);
      if (rules.isNotEmpty) {
        final result = <String>[];
        for (final r in rules) {
          for (final c in r.validCurrencies) {
            if (!result.contains(c)) result.add(c);
          }
        }
        return result;
      }
    }

    return NumismaticDictionary.getCurrenciesForCountry(country);
  }

  /// Incurs a deterministic currency ISO code if (country, year, isBanknote) strictly maps to exactly 1 currency or default.
  static String? inferCurrency({
    String? country,
    int? year,
    bool isBanknote = false,
  }) {
    if (country == null || country.trim().isEmpty || year == null) return null;

    final rules = findRules(country, year, isBanknote: isBanknote);
    if (rules.isNotEmpty) {
      final allCurrencies = rules.expand((r) => r.validCurrencies).toSet();
      if (allCurrencies.length == 1) {
        return allCurrencies.first;
      }
      return rules.first.defaultCurrency;
    }
    return null;
  }

  /// Returns active piece definitions for a given (country, year, isBanknote).
  static List<NumismaticPieceDefinition> getAvailablePieces({
    String? country,
    int? year,
    bool isBanknote = false,
  }) {
    if (country == null || year == null) return const [];
    final rules = findRules(country, year, isBanknote: isBanknote);
    if (rules.isEmpty) return const [];

    final result = <NumismaticPieceDefinition>[];
    for (final r in rules) {
      for (final p in r.getPiecesForYear(year)) {
        if (!result.any((existing) => existing.matchesDenomination(p.denomination) && existing.currency == p.currency)) {
          result.add(p);
        }
      }
    }
    return result;
  }

  /// Returns valid denominations for a given (country, year, currency, isBanknote).
  static List<String> getDenominations({
    String? country,
    int? year,
    String? currencyCode,
    bool isBanknote = false,
  }) {
    if (country != null && year != null) {
      final rules = findRules(country, year, isBanknote: isBanknote);
      if (rules.isNotEmpty) {
        final allDenoms = <String>[];
        for (final r in rules) {
          for (final d in r.getDenominationsForYear(year, currencyCode: currencyCode)) {
            if (!allDenoms.contains(d)) allDenoms.add(d);
          }
        }
        if (allDenoms.isNotEmpty) {
          return [...allDenoms, AppStrings.otherSpecifyOption];
        }
      }
    }
    return [...NumismaticDictionary.denominations];
  }

  /// Incurs material / composition from (country, year, currency, denomination, isBanknote).
  static String? inferMaterial({
    String? country,
    int? year,
    String? currencyCode,
    String? denomination,
    bool isBanknote = false,
  }) {
    if (country == null || year == null || denomination == null) return null;
    if (denomination == AppStrings.otherSpecifyOption) return null;

    final rule = findRule(
      country,
      year,
      currencyCode: currencyCode,
      denomination: denomination,
      isBanknote: isBanknote,
    );
    if (rule == null) return null;

    final cleanDenom = denomination.trim();
    return rule.getMaterialForDenomination(cleanDenom, year: year, currencyCode: currencyCode);
  }

  /// Returns all valid/allowed materials for a piece (supporting transition years and concurrent alloys).
  static List<String> getValidMaterials({
    String? country,
    int? year,
    String? currencyCode,
    String? denomination,
    bool isBanknote = false,
  }) {
    if (country == null || year == null || denomination == null) return const [];
    if (denomination == AppStrings.otherSpecifyOption) return const [];

    final rules = findRules(country, year, isBanknote: isBanknote);
    if (rules.isEmpty) return const [];

    final cleanDenom = denomination.trim();
    final result = <String>[];
    for (final rule in rules) {
      for (final mat in rule.getAllowedMaterialsForDenomination(cleanDenom, year: year, currencyCode: currencyCode)) {
        if (!result.contains(mat)) result.add(mat);
      }
    }
    return result;
  }

  /// Returns individual atomic commemorative motifs for a piece.
  static List<String> getCommemorativeMotifs({
    String? country,
    int? year,
    String? currencyCode,
    String? denomination,
    String? material,
    bool isBanknote = false,
  }) {
    if (country == null || year == null) return const [];
    final rules = findRules(country, year, isBanknote: isBanknote);
    if (rules.isEmpty) return const [];

    final result = <String>[];
    for (final rule in rules) {
      if (material != null && material.trim().isNotEmpty && denomination != null) {
        if (!rule.isMaterialValidForDenomination(denomination, material, year: year, currencyCode: currencyCode)) {
          continue;
        }
      }
      if (denomination != null && denomination.trim().isNotEmpty && denomination != AppStrings.otherSpecifyOption) {
        final cleanDenom = denomination.trim();
        for (final motif in rule.getCommemorativeMotifsForDenomination(cleanDenom, year: year, currencyCode: currencyCode, material: material)) {
          if (!result.contains(motif)) result.add(motif);
        }
      } else {
        for (final entry in rule.commemorativeMotifsByDenomination.entries) {
          for (final motif in entry.value) {
            if (motif.matchesYear(year) && !result.contains(motif.name)) {
              result.add(motif.name);
            }
          }
        }
        if (result.isEmpty) {
          for (final motif in rule.commemorativeReasons) {
            if (!result.contains(motif)) result.add(motif);
          }
        }
      }
    }
    return result;
  }
}
