class UnitsRegistry {
  UnitsRegistry._();

  static const List<String> countingUnits = [
    'pieza',
    'unidad',
    'paquete',
    'juego',
    'caja',
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
}
