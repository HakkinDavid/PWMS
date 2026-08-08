import '../constants/units_registry.dart';

class DomainRules {
  DomainRules._();

  /// Format magnitude value: Display whole numbers as clean integers without `.0`
  static String formatMagnitude(double value, String? unitSymbol) {
    if (isIntegerUnit(unitSymbol) || value == value.roundToDouble()) {
      return value.toInt().toString();
    }
    return value.toString();
  }

  /// Check if a unit is strictly an integer unit
  static bool isIntegerUnit(String? unitSymbol) {
    if (unitSymbol == null || unitSymbol.isEmpty) return false;
    return !UnitsRegistry.allowsDecimals(unitSymbol);
  }

  /// Check if a unit symbol is allowed for species
  static bool isUnitAllowedForSpecies({required String unitSymbol, required bool isUnique}) {
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

  /// Suggest a default prepopulated property name for SI units
  static String suggestPropertyNameForUnit(String unitSymbol) {
    final clean = unitSymbol.trim();
    switch (clean) {
      case 'kg':
      case 'g':
      case 'mg':
      case 't':
        return 'Masa';
      case 'L':
      case 'mL':
      case 'm³':
      case 'cm³':
        return 'Volumen';
      case 'm':
      case 'cm':
      case 'mm':
      case 'km':
        return 'Longitud';
      case 'm²':
      case 'cm²':
      case 'km²':
        return 'Superficie';
      case 's':
      case 'min':
      case 'h':
        return 'Tiempo';
      case 'A':
      case 'mA':
        return 'Corriente eléctrica';
      case 'K':
      case '°C':
      case '°F':
        return 'Temperatura';
      case 'mol':
        return 'Cantidad de sustancia';
      case 'cd':
        return 'Intensidad luminosa';
      case 'N':
      case 'kN':
        return 'Fuerza';
      case 'Pa':
      case 'kPa':
      case 'bar':
        return 'Presión';
      case 'J':
      case 'kJ':
      case 'cal':
        return 'Energía';
      case 'W':
      case 'kW':
      case 'MW':
        return 'Potencia';
      case 'Hz':
      case 'kHz':
      case 'MHz':
      case 'GHz':
        return 'Frecuencia';
      case 'V':
      case 'mV':
      case 'kV':
        return 'Voltaje';
      case 'Ω':
        return 'Resistencia';
      case 'B':
      case 'KB':
      case 'MB':
      case 'GB':
      case 'TB':
        return 'Almacenamiento';
      case 'año':
        return 'Año';
      case 'unidad':
      case 'piezas':
        return 'Cantidad';
      case '\$':
      case 'USD':
      case 'MXN':
      case 'EUR':
        return 'Precio';
      case 'ESP':
        return 'Valor Facial';
      default:
        return 'Propiedad';
    }
  }
}
