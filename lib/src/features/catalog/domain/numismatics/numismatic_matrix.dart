import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import 'package:platinum_world_management_system/src/core/constants/app_technical_strings.dart';
import 'numismatic_dictionary.dart';

/// Domain engine providing matrix-driven numismatic inferences and option filtering.
class NumismaticMatrix {
  NumismaticMatrix._();

  static List<NumismaticEmissionRuleData> get _emissionRules => AppTechnicalNumismatics.emissionRules;

  /// Finds matching emission rule for given country and year.
  static NumismaticEmissionRuleData? findRule(String? country, int? year) {
    if (country == null || country.trim().isEmpty || country == AppStrings.otherSpecifyOption) {
      return null;
    }
    if (year == null) return null;

    final trimmedCountry = country.trim();
    for (final rule in _emissionRules) {
      if (rule.matches(trimmedCountry, year)) {
        return rule;
      }
    }
    return null;
  }

  /// Returns valid currency ISO codes for a given country and optional year.
  static List<String> getCurrencies({String? country, int? year}) {
    if (country == null || country.trim().isEmpty || country == AppStrings.otherSpecifyOption) {
      return NumismaticDictionary.currencyMap.keys.toList();
    }

    if (year != null) {
      final rule = findRule(country, year);
      if (rule != null) {
        return rule.validCurrencies;
      }
    }

    return NumismaticDictionary.getCurrenciesForCountry(country);
  }

  /// Incurs a deterministic currency ISO code if (country, year) strictly maps to exactly 1 currency or default.
  static String? inferCurrency({String? country, int? year}) {
    if (country == null || country.trim().isEmpty || year == null) return null;

    final rule = findRule(country, year);
    if (rule != null) {
      if (rule.validCurrencies.length == 1) {
        return rule.validCurrencies.first;
      }
      return rule.defaultCurrency;
    }
    return null;
  }

  /// Returns valid denominations for a given (country, year, currency).
  static List<String> getDenominations({String? country, int? year, String? currencyCode}) {
    if (country != null && year != null) {
      final rule = findRule(country, year);
      if (rule != null) {
        return [...rule.denominations, AppStrings.otherSpecifyOption];
      }
    }
    return [...NumismaticDictionary.denominations];
  }

  /// Incurs coin material / composition from (country, year, currency, denomination).
  static String? inferMaterial({
    String? country,
    int? year,
    String? currencyCode,
    String? denomination,
  }) {
    if (country == null || year == null || denomination == null) return null;
    if (denomination == AppStrings.otherSpecifyOption) return null;

    final rule = findRule(country, year);
    if (rule == null) return null;

    // Direct denomination match
    final cleanDenom = denomination.trim();
    if (rule.denominationMaterials.containsKey(cleanDenom)) {
      return rule.denominationMaterials[cleanDenom];
    }

    // Normalized decimal matching (e.g. "0.5" vs "0.50" vs "1/2")
    final numVal = double.tryParse(cleanDenom);
    if (numVal != null) {
      for (final entry in rule.denominationMaterials.entries) {
        final entryNum = double.tryParse(entry.key);
        if (entryNum != null && entryNum == numVal) {
          return entry.value;
        }
      }
    }

    return null;
  }

  /// Checks if (country, year, currency, denomination) is a known commemorative or special edition emission.
  static ({bool isSpecial, String? reason})? checkSpecialEdition({
    String? country,
    int? year,
    String? currencyCode,
    String? denomination,
  }) {
    if (country == null || year == null || denomination == null) return null;
    if (denomination == AppStrings.otherSpecifyOption) return null;

    final rule = findRule(country, year);
    if (rule == null) return null;

    final cleanDenom = denomination.trim();
    if (rule.commemorativeDenominations.contains(cleanDenom)) {
      return (
        isSpecial: true,
        reason: rule.defaultCommemorativeReason ?? AppTechnicalNumismatics.specialEditionReasons.first,
      );
    }

    final numVal = double.tryParse(cleanDenom);
    if (numVal != null) {
      for (final commDenom in rule.commemorativeDenominations) {
        final commNum = double.tryParse(commDenom);
        if (commNum != null && commNum == numVal) {
          return (
            isSpecial: true,
            reason: rule.defaultCommemorativeReason ?? AppTechnicalNumismatics.specialEditionReasons.first,
          );
        }
      }
    }

    return null;
  }
}
