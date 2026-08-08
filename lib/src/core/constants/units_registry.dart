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

  static const Map<String, SIUnitDefinition> definitions = {
    // Masa
    't': SIUnitDefinition(symbol: 't', allowDecimals: true),
    'kg': SIUnitDefinition(symbol: 'kg', allowDecimals: true),
    'g': SIUnitDefinition(symbol: 'g', allowDecimals: true),
    'mg': SIUnitDefinition(symbol: 'mg', allowDecimals: true),

    // Longitud
    'km': SIUnitDefinition(symbol: 'km', allowDecimals: true),
    'm': SIUnitDefinition(symbol: 'm', allowDecimals: true),
    'cm': SIUnitDefinition(symbol: 'cm', allowDecimals: true),
    'mm': SIUnitDefinition(symbol: 'mm', allowDecimals: true),

    // Volumen
    'm³': SIUnitDefinition(symbol: 'm³', allowDecimals: true),
    'cm³': SIUnitDefinition(symbol: 'cm³', allowDecimals: true),
    'L': SIUnitDefinition(symbol: 'L', allowDecimals: true),
    'mL': SIUnitDefinition(symbol: 'mL', allowDecimals: true),

    // Superficie
    'km²': SIUnitDefinition(symbol: 'km²', allowDecimals: true),
    'm²': SIUnitDefinition(symbol: 'm²', allowDecimals: true),
    'cm²': SIUnitDefinition(symbol: 'cm²', allowDecimals: true),

    // Tiempo
    's': SIUnitDefinition(symbol: 's', allowDecimals: true),
    'min': SIUnitDefinition(symbol: 'min', allowDecimals: true),
    'h': SIUnitDefinition(symbol: 'h', allowDecimals: true),
    'año': SIUnitDefinition(symbol: 'año', allowDecimals: false),


    // Electricidad y Magnetismo
    'A': SIUnitDefinition(symbol: 'A', allowDecimals: true),
    'mA': SIUnitDefinition(symbol: 'mA', allowDecimals: true),
    'V': SIUnitDefinition(symbol: 'V', allowDecimals: true),
    'mV': SIUnitDefinition(symbol: 'mV', allowDecimals: true),
    'kV': SIUnitDefinition(symbol: 'kV', allowDecimals: true),
    'Ω': SIUnitDefinition(symbol: 'Ω', allowDecimals: true),

    // Temperatura
    'K': SIUnitDefinition(symbol: 'K', allowDecimals: true),
    '°C': SIUnitDefinition(symbol: '°C', allowDecimals: true),
    '°F': SIUnitDefinition(symbol: '°F', allowDecimals: true),

    // Cantidad de sustancia e Intensidad luminosa
    'mol': SIUnitDefinition(symbol: 'mol', allowDecimals: true),
    'cd': SIUnitDefinition(symbol: 'cd', allowDecimals: true),

    // Fuerza y Presión
    'N': SIUnitDefinition(symbol: 'N', allowDecimals: true),
    'kN': SIUnitDefinition(symbol: 'kN', allowDecimals: true),
    'Pa': SIUnitDefinition(symbol: 'Pa', allowDecimals: true),
    'kPa': SIUnitDefinition(symbol: 'kPa', allowDecimals: true),
    'bar': SIUnitDefinition(symbol: 'bar', allowDecimals: true),

    // Energía, Potencia y Frecuencia
    'J': SIUnitDefinition(symbol: 'J', allowDecimals: true),
    'kJ': SIUnitDefinition(symbol: 'kJ', allowDecimals: true),
    'cal': SIUnitDefinition(symbol: 'cal', allowDecimals: true),
    'W': SIUnitDefinition(symbol: 'W', allowDecimals: true),
    'kW': SIUnitDefinition(symbol: 'kW', allowDecimals: true),
    'MW': SIUnitDefinition(symbol: 'MW', allowDecimals: true),
    'Hz': SIUnitDefinition(symbol: 'Hz', allowDecimals: true),
    'kHz': SIUnitDefinition(symbol: 'kHz', allowDecimals: true),
    'MHz': SIUnitDefinition(symbol: 'MHz', allowDecimals: true),
    'GHz': SIUnitDefinition(symbol: 'GHz', allowDecimals: true),

    // Almacenamiento Digital
    'B': SIUnitDefinition(symbol: 'B', allowDecimals: true),
    'KB': SIUnitDefinition(symbol: 'KB', allowDecimals: true),
    'MB': SIUnitDefinition(symbol: 'MB', allowDecimals: true),
    'GB': SIUnitDefinition(symbol: 'GB', allowDecimals: true),
    'TB': SIUnitDefinition(symbol: 'TB', allowDecimals: true),

    // Financiero y Monetario
    '\$': SIUnitDefinition(symbol: '\$', allowDecimals: true),
    'USD': SIUnitDefinition(symbol: 'USD', allowDecimals: true),
    'MXN': SIUnitDefinition(symbol: 'MXN', allowDecimals: true),
    'EUR': SIUnitDefinition(symbol: 'EUR', allowDecimals: true),
    'ESP': SIUnitDefinition(symbol: 'ESP', allowDecimals: true),
  };

  static const List<String> massUnits = ['t', 'kg', 'g', 'mg'];
  static const List<String> lengthUnits = ['km', 'm', 'cm', 'mm'];
  static const List<String> volumeUnits = ['m³', 'cm³', 'L', 'mL'];
  static const List<String> areaUnits = ['km²', 'm²', 'cm²'];
  static const List<String> timeUnits = ['s', 'min', 'h', 'año'];
  static const List<String> electricalUnits = ['A', 'mA', 'V', 'mV', 'kV', 'Ω'];
  static const List<String> temperatureUnits = ['K', '°C', '°F'];
  static const List<String> substanceAndLightUnits = ['mol', 'cd'];
  static const List<String> forceAndPressureUnits = ['N', 'kN', 'Pa', 'kPa', 'bar'];
  static const List<String> energyAndPowerUnits = ['J', 'kJ', 'cal', 'W', 'kW', 'MW', 'Hz', 'kHz', 'MHz', 'GHz'];
  static const List<String> digitalUnits = ['B', 'KB', 'MB', 'GB', 'TB'];
  static const List<String> financialUnits = ['\$', 'USD', 'MXN', 'EUR', 'ESP'];

  static List<String> get allSiUnits => [
        ...massUnits,
        ...lengthUnits,
        ...volumeUnits,
        ...areaUnits,
        ...timeUnits,
        ...electricalUnits,
        ...temperatureUnits,
        ...substanceAndLightUnits,
        ...forceAndPressureUnits,
        ...energyAndPowerUnits,
        ...digitalUnits,
        ...financialUnits,
      ];

  static SIUnitDefinition getDefinition(String? unitSymbol) {
    if (unitSymbol == null || unitSymbol.isEmpty) {
      return const SIUnitDefinition(symbol: '', allowDecimals: true);
    }
    return definitions[unitSymbol] ?? const SIUnitDefinition(symbol: '', allowDecimals: true);
  }

  static bool allowsDecimals(String? unitSymbol) {
    return getDefinition(unitSymbol).allowDecimals;
  }
}
