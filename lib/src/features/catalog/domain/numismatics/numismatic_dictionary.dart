import 'package:platinum_world_management_system/src/core/constants/app_technical_strings.dart';
import 'data/numismatic_currencies_registry.dart';
import 'data/numismatic_denominations_registry.dart';
import 'data/numismatic_materials_registry.dart';
import 'models/numismatic_material_definition.dart';

export 'data/numismatic_currencies_registry.dart';
export 'data/numismatic_denominations_registry.dart';
export 'data/numismatic_materials_registry.dart';

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

  static const List<String> allStandardDenominations = NumismaticDenominationsRegistry.allDenominations;

  static const List<String> grades = AppTechnicalNumismatics.grades;

  static List<String> get coinMaterials => NumismaticMaterialsRegistry.allDisplayNames;

  static List<NumismaticMaterialDefinition> get materials => NumismaticMaterialsRegistry.allMaterials;

  static NumismaticMaterialDefinition? resolveMaterial(String raw) =>
      NumismaticMaterialsRegistry.resolve(raw);

  static bool areMaterialsCompatible(String mat1, String mat2) =>
      NumismaticMaterialsRegistry.areCompatible(mat1, mat2);

  static double? parseDenominationNumber(String raw) =>
      NumismaticDenominationsRegistry.parseNumber(raw);

  static bool matchesDenomination(String d1, String d2) =>
      NumismaticDenominationsRegistry.matches(d1, d2);
}
