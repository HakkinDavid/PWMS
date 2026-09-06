import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import 'package:platinum_world_management_system/src/core/constants/app_technical_strings.dart';
import 'numismatic_dictionary.dart';
import 'numismatic_parser.dart';

/// Domain engine providing matrix-driven numismatic inferences and option filtering (Coins and Banknotes).
class NumismaticMatrix {
  NumismaticMatrix._();

  static List<NumismaticEmissionRuleData> get _emissionRules => AppTechnicalNumismatics.emissionRules;

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

    final trimmedCountry = country.trim();
    return _emissionRules
        .where((rule) => rule.matches(trimmedCountry, year, isBanknote: isBanknote))
        .toList();
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

    // 1. If currencyCode is provided, prioritize matching rule containing this currency
    if (currencyCode != null && currencyCode.trim().isNotEmpty) {
      final iso = NumismaticParser.resolveCurrencyIsoCode(currencyCode);
      for (final rule in rules) {
        if (rule.validCurrencies.contains(iso)) {
          // If denomination is also provided, verify if denomination matches
          if (denomination != null && denomination.trim().isNotEmpty && denomination != AppStrings.otherSpecifyOption) {
            final cleanDenom = denomination.trim();
            if (rule.hasDenomination(cleanDenom)) {
              return rule;
            }
          }
          return rule;
        }
      }
    }

    // 2. If denomination is provided without currency, find rule matching this denomination
    if (denomination != null && denomination.trim().isNotEmpty && denomination != AppStrings.otherSpecifyOption) {
      final cleanDenom = denomination.trim();
      for (final rule in rules) {
        if (rule.hasDenomination(cleanDenom)) {
          return rule;
        }
      }
    }

    return rules.first;
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

  /// Returns valid denominations for a given (country, year, currency, isBanknote).
  static List<String> getDenominations({
    String? country,
    int? year,
    String? currencyCode,
    bool isBanknote = false,
  }) {
    if (country != null && year != null) {
      if (currencyCode != null && currencyCode.trim().isNotEmpty) {
        final rule = findRule(country, year, currencyCode: currencyCode, isBanknote: isBanknote);
        if (rule != null) {
          return [...rule.denominations, AppStrings.otherSpecifyOption];
        }
      }
      final rules = findRules(country, year, isBanknote: isBanknote);
      if (rules.isNotEmpty) {
        final allDenoms = <String>[];
        for (final r in rules) {
          for (final d in r.denominations) {
            if (!allDenoms.contains(d)) allDenoms.add(d);
          }
        }
        return [...allDenoms, AppStrings.otherSpecifyOption];
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
    return rule.getMaterialForDenomination(cleanDenom);
  }

  /// Checks if (country, year, currency, denomination, isBanknote) is a known commemorative or special edition emission.
  static ({bool isSpecial, String? reason})? checkSpecialEdition({
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
    if (rule.isCommemorativeDenomination(cleanDenom)) {
      return (
        isSpecial: true,
        reason: rule.defaultCommemorativeReason ?? AppTechnicalNumismatics.specialEditionReasons.first,
      );
    }

    return null;
  }
}
