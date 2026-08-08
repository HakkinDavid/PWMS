class NumismaticScanResult {
  final String speciesType; // 'Moneda' or 'Billete'
  final String generalSpeciesName; // 'Moneda' or 'Billete'
  final String subspeciesName; // e.g. '5 Pesetas - España (1982)'
  final String? country; // e.g. 'México', 'España'
  final String? year; // e.g. '1982'
  final double? faceValueNumber; // e.g. 5.0
  final String? currencyCode; // e.g. 'MXN', 'ESP', 'EUR', 'USD'
  final String? currencyName; // e.g. 'Pesos Mexicanos', 'Pesetas'
  final String? composition; // e.g. 'Cuproníquel', 'Plata', 'Papel'
  final String? grade; // e.g. 'MBC / VF (Muy Buena)'
  final bool isSpecialEdition;
  final String? specialEditionReason; // e.g. 'Conmemorativa', 'Otro'
  final String? specialEditionNotes; // free text when 'Otro'
  final String obversePhotoPath;
  final String? reversePhotoPath;
  final String sourceEngine;

  NumismaticScanResult({
    required this.speciesType,
    required this.generalSpeciesName,
    required this.subspeciesName,
    this.country,
    this.year,
    this.faceValueNumber,
    this.currencyCode,
    this.currencyName,
    this.composition,
    this.grade,
    this.isSpecialEdition = false,
    this.specialEditionReason,
    this.specialEditionNotes,
    required this.obversePhotoPath,
    this.reversePhotoPath,
    required this.sourceEngine,
  });

  Map<String, double> toMagnitudeValues() {
    final map = <String, double>{};
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
