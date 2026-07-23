class SpeciesRequirement {
  final String id;
  final String sourceId; // speciesId or entityId
  final String sourceType; // 'species' or 'entity'
  final String requiredSpeciesId;
  final double requiredQuantity;
  final String? notes;
  final DateTime createdAt;

  const SpeciesRequirement({
    required this.id,
    required this.sourceId,
    this.sourceType = 'species',
    required this.requiredSpeciesId,
    required this.requiredQuantity,
    this.notes,
    required this.createdAt,
  });
}
