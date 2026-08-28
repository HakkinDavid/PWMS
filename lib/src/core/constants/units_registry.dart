import 'package:platinum_world_management_system/src/core/constants/app_technical_strings.dart';

class SIUnitDefinition {
  final String symbol;
  final bool allowDecimals;
  final bool allowNegatives;

  const SIUnitDefinition({
    required this.symbol,
    this.allowDecimals = true,
    this.allowNegatives = false,
  });
}

class UnitsRegistry {
  UnitsRegistry._();

  static const Map<String, SIUnitDefinition> definitions = AppTechnicalUnits.definitions;

  static const List<String> discreteUnits = AppTechnicalUnits.discreteUnits;
  static const List<String> massUnits = AppTechnicalUnits.massUnits;
  static const List<String> lengthUnits = AppTechnicalUnits.lengthUnits;
  static const List<String> volumeUnits = AppTechnicalUnits.volumeUnits;
  static const List<String> areaUnits = AppTechnicalUnits.areaUnits;
  static const List<String> timeUnits = AppTechnicalUnits.timeUnits;
  static const List<String> electricalUnits = AppTechnicalUnits.electricalUnits;
  static const List<String> temperatureUnits = AppTechnicalUnits.temperatureUnits;
  static const List<String> substanceAndLightUnits = AppTechnicalUnits.substanceAndLightUnits;
  static const List<String> forceAndPressureUnits = AppTechnicalUnits.forceAndPressureUnits;
  static const List<String> energyAndPowerUnits = AppTechnicalUnits.energyAndPowerUnits;
  static const List<String> digitalUnits = AppTechnicalUnits.digitalUnits;
  static const List<String> financialUnits = AppTechnicalUnits.financialUnits;

  static List<String> get allSiUnits => AppTechnicalUnits.allSiUnits;

  static bool isKnownUnit(String? unitSymbol) {
    if (unitSymbol == null || unitSymbol.trim().isEmpty) return false;
    return definitions.containsKey(unitSymbol.trim());
  }

  static SIUnitDefinition getDefinition(String? unitSymbol) {
    if (unitSymbol == null || unitSymbol.isEmpty) {
      return const SIUnitDefinition(symbol: AppTechnicalStrings.empty, allowDecimals: true);
    }
    final trimmed = unitSymbol.trim();
    if (definitions.containsKey(trimmed)) {
      return definitions[trimmed]!;
    }
    return SIUnitDefinition(symbol: trimmed, allowDecimals: true);
  }

  static bool allowsDecimals(String? unitSymbol) {
    return getDefinition(unitSymbol).allowDecimals;
  }
}


