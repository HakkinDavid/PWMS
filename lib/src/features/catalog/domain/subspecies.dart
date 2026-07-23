class Subspecies {
  final String id;
  final String speciesId;
  final String subspeciesName;
  final String? brand;
  final String? barcode;
  final String? photoPath;
  final String? notes;
  final DateTime createdAt;

  const Subspecies({
    required this.id,
    required this.speciesId,
    required this.subspeciesName,
    this.brand,
    this.barcode,
    this.photoPath,
    this.notes,
    required this.createdAt,
  });

  Subspecies copyWith({
    String? id,
    String? speciesId,
    String? subspeciesName,
    String? brand,
    String? barcode,
    String? photoPath,
    String? notes,
    DateTime? createdAt,
  }) {
    return Subspecies(
      id: id ?? this.id,
      speciesId: speciesId ?? this.speciesId,
      subspeciesName: subspeciesName ?? this.subspeciesName,
      brand: brand ?? this.brand,
      barcode: barcode ?? this.barcode,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  String? resolvePhotoPath(String? fallbackSpeciesPhoto) {
    if (photoPath != null && photoPath!.trim().isNotEmpty) {
      return photoPath;
    }
    return fallbackSpeciesPhoto;
  }
}
