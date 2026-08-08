class NumismaticScanResult {
  final String speciesType; // 'Moneda' or 'Billete'
  final String generalSpeciesName; // 'Moneda' or 'Billete'
  final String subspeciesName; // e.g. '5 Pesetas (Juan Carlos I - 1982)'
  final String? brandOrMint; // e.g. 'FNMT - Real Casa de la Moneda (M)'
  final String? country; // e.g. 'España'
  final String? year; // e.g. '1982'
  final double? faceValueNumber; // e.g. 5.0
  final String? currencyCode; // e.g. 'ESP', 'EUR', 'USD', 'MXN'
  final String? currencyName; // e.g. 'Pesetas', 'Euros'
  final String? composition; // e.g. 'Cuproníquel', 'Plata .925'
  final double? massGrams; // e.g. 5.75
  final double? diameterMm; // e.g. 23.0
  final double? thicknessMm; // e.g. 1.8
  final double? lengthMm; // e.g. 140.0
  final double? widthMm; // e.g. 75.0
  final String? grade; // e.g. 'MBC / VF'
  final String? serialNumber; // for banknotes
  final String? catalogCode; // e.g. 'KM# 821' / 'Pick# 142'
  final String? notes; // Description/historical summary
  final String obversePhotoPath;
  final String? reversePhotoPath;
  final String sourceEngine; // 'Gemini Vision', 'Numista API', 'Modo Local'

  NumismaticScanResult({
    required this.speciesType,
    required this.generalSpeciesName,
    required this.subspeciesName,
    this.brandOrMint,
    this.country,
    this.year,
    this.faceValueNumber,
    this.currencyCode,
    this.currencyName,
    this.composition,
    this.massGrams,
    this.diameterMm,
    this.thicknessMm,
    this.lengthMm,
    this.widthMm,
    this.grade,
    this.serialNumber,
    this.catalogCode,
    this.notes,
    required this.obversePhotoPath,
    this.reversePhotoPath,
    required this.sourceEngine,
  });

  Map<String, double> toMagnitudeValues() {
    final map = <String, double>{};
    if (massGrams != null && massGrams! > 0) {
      map['Masa'] = massGrams!;
    }
    if (diameterMm != null && diameterMm! > 0) {
      map['Diámetro'] = diameterMm!;
    }
    if (thicknessMm != null && thicknessMm! > 0) {
      map['Espesor'] = thicknessMm!;
    }
    if (lengthMm != null && lengthMm! > 0) {
      map['Longitud'] = lengthMm!;
    }
    if (widthMm != null && widthMm! > 0) {
      map['Ancho'] = widthMm!;
    }
    if (faceValueNumber != null && faceValueNumber! > 0) {
      map['Unidad Monetaria'] = faceValueNumber!;
    }
    if (year != null) {
      final y = double.tryParse(year!);
      if (y != null && y > 0) {
        map['Año'] = y;
      }
    }
    return map;
  }
}
