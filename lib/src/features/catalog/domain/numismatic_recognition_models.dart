class NumismaticScanResult {
  final String speciesType; // 'Moneda' or 'Billete'
  final String generalSpeciesName; // 'Moneda' or 'Billete'
  final String subspeciesName; // e.g. '5 Pesetas (Juan Carlos I - 1982)'
  final String? brandOrMint; // e.g. 'FNMT - Real Casa de la Moneda (M)'
  final String? country; // e.g. 'España'
  final String? year; // e.g. '1982'
  final String? faceValue; // e.g. '5 PESETAS'
  final String? composition; // e.g. 'Cuproníquel', 'Plata .925'
  final double? massGrams; // e.g. 5.75
  final double? diameterMm; // e.g. 23.0
  final String? grade; // e.g. 'MBC / VF'
  final String? serialNumber; // for banknotes
  final String? catalogCode; // e.g. 'KM# 821' / 'Pick# 142'
  final String? notes; // Description/historical summary
  final String obversePhotoPath;
  final String? reversePhotoPath;
  final String sourceEngine; // 'Gemini Vision', 'Numista API', 'OCR Local'

  NumismaticScanResult({
    required this.speciesType,
    required this.generalSpeciesName,
    required this.subspeciesName,
    this.brandOrMint,
    this.country,
    this.year,
    this.faceValue,
    this.composition,
    this.massGrams,
    this.diameterMm,
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
    return map;
  }
}
