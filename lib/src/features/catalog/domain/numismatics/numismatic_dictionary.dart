import 'package:platinum_world_management_system/src/core/constants/app_technical_strings.dart';

class NumismaticDictionary {
  NumismaticDictionary._();

  static const List<String> numismaticSpeciesNames = AppTechnicalNumismatics.numismaticSpeciesNames;

  /// Map of ISO currency codes to standard full Spanish currency names (plural).
  static const Map<String, String> currencyMap = AppTechnicalNumismatics.currencyMap;

  /// List of sovereign countries / territories for Numismatics.
  static const List<String> countries = AppTechnicalNumismatics.countries;

  /// Maps sovereign country names to their primary ISO currency codes.
  static const Map<String, List<String>> countryToCurrenciesMap = AppTechnicalNumismatics.countryToCurrenciesMap;

  static List<String> getCurrenciesForCountry(String? country) {
    if (country == null || country.trim().isEmpty || country == AppTechnicalNumismatics.countryOther) {
      return currencyMap.keys.toList();
    }
    final mapped = countryToCurrenciesMap[country.trim()];
    if (mapped != null && mapped.isNotEmpty) {
      return mapped;
    }
    return currencyMap.keys.toList();
  }

  static Map<String, String> getCurrencyMapForCountry(String? country) {
    final codes = getCurrenciesForCountry(country);
    final result = <String, String>{};
    for (final code in codes) {
      if (currencyMap.containsKey(code)) {
        result[code] = currencyMap[code]!;
      }
    }
    return result;
  }

  static const List<String> denominations = AppTechnicalNumismatics.denominations;

  static const List<String> grades = AppTechnicalNumismatics.grades;

  static const List<String> coinMaterials = AppTechnicalNumismatics.coinMaterials;

  static const List<String> specialEditionReasons = AppTechnicalNumismatics.specialEditionReasons;
}
