import '../constants/units_registry.dart';

class DomainRules {
  DomainRules._();

  /// Check if a unit is strictly an integer unit (e.g. pieza, unidad, paquete, juego, caja)
  static bool isIntegerUnit(String? unitSymbol) {
    if (unitSymbol == null) return false;
    return !UnitsRegistry.allowsDecimals(unitSymbol);
  }

  /// Rule #8: If a species is marked as unique (isUnique == true), "pieza" and counting units are FORBIDDEN!
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
      // Filter out integer counting units for unique species
      return UnitsRegistry.allSiUnits.where((u) => !isIntegerUnit(u)).toList();
    }
    return UnitsRegistry.allSiUnits;
  }
}
