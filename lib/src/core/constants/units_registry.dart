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
    'unidad': SIUnitDefinition(symbol: 'unidad', allowDecimals: false),
    'pieza': SIUnitDefinition(symbol: 'unidad', allowDecimals: false),
    'paquete': SIUnitDefinition(symbol: 'unidad', allowDecimals: false),
    'juego': SIUnitDefinition(symbol: 'unidad', allowDecimals: false),
    'caja': SIUnitDefinition(symbol: 'unidad', allowDecimals: false),
    'kg': SIUnitDefinition(symbol: 'kg', allowDecimals: true),
    'g': SIUnitDefinition(symbol: 'g', allowDecimals: true),
    'mg': SIUnitDefinition(symbol: 'mg', allowDecimals: true),
    'm': SIUnitDefinition(symbol: 'm', allowDecimals: true),
    'cm': SIUnitDefinition(symbol: 'cm', allowDecimals: true),
    'mm': SIUnitDefinition(symbol: 'mm', allowDecimals: true),
    'L': SIUnitDefinition(symbol: 'L', allowDecimals: true),
    'mL': SIUnitDefinition(symbol: 'mL', allowDecimals: true),
    'm³': SIUnitDefinition(symbol: 'm³', allowDecimals: true),
    'm²': SIUnitDefinition(symbol: 'm²', allowDecimals: true),
  };

  static const List<String> countingUnits = [
    'unidad',
  ];

  static const List<String> massUnits = [
    'kg',
    'g',
    'mg',
  ];

  static const List<String> lengthUnits = [
    'm',
    'cm',
    'mm',
  ];

  static const List<String> volumeUnits = [
    'L',
    'mL',
    'm³',
  ];

  static const List<String> areaUnits = [
    'm²',
  ];

  static List<String> get allSiUnits => [
        ...countingUnits,
        ...massUnits,
        ...lengthUnits,
        ...volumeUnits,
        ...areaUnits,
      ];

  static SIUnitDefinition getDefinition(String? unitSymbol) {
    if (unitSymbol == null) return const SIUnitDefinition(symbol: '', allowDecimals: true);
    return definitions[unitSymbol] ?? const SIUnitDefinition(symbol: '', allowDecimals: true);
  }

  static bool allowsDecimals(String? unitSymbol) {
    return getDefinition(unitSymbol).allowDecimals;
  }
}
