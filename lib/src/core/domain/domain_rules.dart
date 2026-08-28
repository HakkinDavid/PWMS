import '../constants/units_registry.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import 'package:platinum_world_management_system/src/core/constants/app_technical_strings.dart';
import 'property_data_type.dart';

class DomainRules {
  DomainRules._();

  /// Format magnitude value: Display whole numbers as clean integers without `.0`
  static String formatMagnitude(double? value, String? unitSymbol) {
    if (value == null) return AppStrings.unspecifiedPropertyPlaceholder;
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

  /// Suggest default primitive data type for a unit symbol
  static PropertyDataType suggestDataTypeForUnit(String unitSymbol) {
    if (isIntegerUnit(unitSymbol)) {
      return PropertyDataType.integer;
    }
    return PropertyDataType.real;
  }

  /// Check if a unit symbol is allowed for species
  static bool isUnitAllowedForSpecies({required String unitSymbol, required bool isUnique}) {
    return true;
  }

  /// Validate if a magnitude value is valid for a given unit symbol
  static bool isValidMagnitudeForUnit({required double? magnitude, required String? unitSymbol}) {
    if (magnitude == null) return true;
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
      case AppTechnicalStrings.unitKg:
      case AppTechnicalStrings.unitGram:
      case AppTechnicalStrings.unitMg:
      case AppTechnicalStrings.unitTonne:
        return AppStrings.propMass;
      case AppTechnicalStrings.unitLiter:
      case AppTechnicalStrings.unitMl:
      case AppTechnicalStrings.unitCubicMeter:
      case AppTechnicalStrings.unitCubicCm:
        return AppStrings.propVolume;
      case AppTechnicalStrings.unitMeter:
      case AppTechnicalStrings.unitCm:
      case AppTechnicalStrings.unitMm:
      case AppTechnicalStrings.unitKm:
        return AppStrings.propLength;
      case AppTechnicalStrings.unitSqMeter:
      case AppTechnicalStrings.unitSqCm:
      case AppTechnicalStrings.unitSqKm:
        return AppStrings.propSurface;
      case AppTechnicalStrings.unitSecond:
      case AppTechnicalStrings.unitMinute:
      case AppTechnicalStrings.unitHour:
        return AppStrings.propTime;
      case AppTechnicalStrings.unitAmpere:
      case AppTechnicalStrings.unitMilliampere:
        return AppStrings.propElectricCurrent;
      case AppTechnicalStrings.unitKelvin:
      case AppTechnicalStrings.unitCelsius:
      case AppTechnicalStrings.unitFahrenheit:
        return AppStrings.propTemperature;
      case AppTechnicalStrings.unitMole:
        return AppStrings.propSubstanceAmount;
      case AppTechnicalStrings.unitCandela:
        return AppStrings.propLuminousIntensity;
      case AppTechnicalStrings.unitNewton:
      case AppTechnicalStrings.unitKilonewton:
        return AppStrings.propForce;
      case AppTechnicalStrings.unitPascal:
      case AppTechnicalStrings.unitKilopascal:
      case AppTechnicalStrings.unitBar:
        return AppStrings.propPressure;
      case AppTechnicalStrings.unitJoule:
      case AppTechnicalStrings.unitKilojoule:
      case AppTechnicalStrings.unitCalorie:
        return AppStrings.propEnergy;
      case AppTechnicalStrings.unitWatt:
      case AppTechnicalStrings.unitKilowatt:
      case AppTechnicalStrings.unitMegawatt:
        return AppStrings.propPower;
      case AppTechnicalStrings.unitHertz:
      case AppTechnicalStrings.unitKilohertz:
      case AppTechnicalStrings.unitMegahertz:
      case AppTechnicalStrings.unitGigahertz:
        return AppStrings.propFrequency;
      case AppTechnicalStrings.unitVolt:
      case AppTechnicalStrings.unitMillivolt:
      case AppTechnicalStrings.unitKilovolt:
        return AppStrings.propVoltage;
      case AppTechnicalStrings.unitOhm:
        return AppStrings.propResistance;
      case AppTechnicalStrings.unitByte:
      case AppTechnicalStrings.unitKb:
      case AppTechnicalStrings.unitMb:
      case AppTechnicalStrings.unitGb:
      case AppTechnicalStrings.unitTb:
        return AppStrings.propStorage;
      case AppTechnicalStrings.unitYear:
        return AppStrings.propYear;
      case AppTechnicalStrings.unitUnidad:
      case AppTechnicalStrings.unitPiezas:
        return AppStrings.propQuantity;
      case AppTechnicalStrings.unitDollar:
      case AppTechnicalStrings.unitUsd:
      case AppTechnicalStrings.unitMxn:
      case AppTechnicalStrings.unitEur:
        return AppStrings.propPrice;
      case AppTechnicalStrings.unitEsp:
        return AppStrings.propFaceValue;
      default:
        return AppStrings.propDefault;
    }
  }
}

