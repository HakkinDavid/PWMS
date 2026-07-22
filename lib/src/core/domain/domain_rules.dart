import '../constants/units_registry.dart';

class DomainRules {
  DomainRules._();

  /// Format magnitude value: Display integer units or whole numbers as clean integers without `.0`
  static String formatMagnitude(double value, String? unitSymbol) {
    if (isIntegerUnit(unitSymbol) || value == value.roundToDouble()) {
      return value.toInt().toString();
    }
    return value.toString();
  }

  /// Check if a unit is strictly an integer unit (e.g. unidad)
  static bool isIntegerUnit(String? unitSymbol) {
    if (unitSymbol == null || unitSymbol.isEmpty) return true;
    return !UnitsRegistry.allowsDecimals(unitSymbol);
  }

  /// Rule #8: If a species is marked as unique (isUnique == true), "unidad" and counting units are FORBIDDEN!
  static bool isUnitAllowedForSpecies({required String unitSymbol, required bool isUnique}) {
    if (isUnique && isIntegerUnit(unitSymbol)) {
      return false;
    }
    return true;
  }

  /// Validate if a magnitude value is valid for a given unit symbol
  static bool isValidMagnitudeForUnit({required double magnitude, required String? unitSymbol}) {
    if (isIntegerUnit(unitSymbol)) {
      return magnitude == magnitude.roundToDouble() && magnitude >= 0;
    }
    return magnitude >= 0;
  }

  /// Get allowed SI unit choices for a species based on uniqueness
  static List<String> getAllowedUnitsForSpecies({required bool isUnique}) {
    if (isUnique) {
      return UnitsRegistry.allSiUnits.where((u) => !isIntegerUnit(u)).toList();
    }
    return UnitsRegistry.allSiUnits;
  }
}
