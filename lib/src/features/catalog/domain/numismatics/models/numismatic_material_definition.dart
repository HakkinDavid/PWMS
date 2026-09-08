/// Classification of the physical structure and manufacturing configuration of a numismatic material.
enum NumismaticMaterialStructure {
  monometallic,
  plated,
  clad,
  bimetallic,
  trimetallic,
  nonMetallic,
}

/// High-level metallurgical or base family category for a numismatic material.
enum NumismaticMaterialFamily {
  silver,
  gold,
  platinum,
  palladium,
  copper,
  cupronickel,
  bronze,
  brass,
  steel,
  zinc,
  aluminum,
  nickel,
  bimetallic,
  trimetallic,
  paper,
  polymer,
  other,
}

/// Canonical metadata definition representing a specific numismatic alloy, composition, or material structure.
class NumismaticMaterialDefinition {
  /// Unique and immutable technical key (e.g. 'silver_720', 'bimetallic_al_bronze_stainless_steel').
  final String key;

  /// Full standard Spanish display name (e.g. 'Plata .720', 'Bimetálica (Centro Bronce de Aluminio, Anillo Acero Inoxidable)').
  final String displayName;

  /// Short category or primary component name (e.g. 'Plata', 'Bimetálica', 'Oro').
  final String shortName;

  /// High-level metallurgical / base family category.
  final NumismaticMaterialFamily family;

  /// Physical structure and manufacturing configuration.
  final NumismaticMaterialStructure structure;

  /// Standard purity / fineness expressed as a fraction of 1.0 (e.g. 0.925, 0.720, 0.900, 0.999).
  final double? fineness;

  /// Core / center material for bimetallic or clad pieces.
  final String? coreMaterial;

  /// Outer ring material for bimetallic or trimetallic pieces.
  final String? ringMaterial;

  /// Surface plating / coating material for electroplated pieces.
  final String? platingMaterial;

  /// Quantitative or descriptive alloy composition (e.g. '92% Cu, 6% Al, 2% Ni').
  final String? alloyComposition;

  /// Equivalent synonyms, abbreviations, legacy terms, and international denominations.
  final List<String> aliases;

  const NumismaticMaterialDefinition({
    required this.key,
    required this.displayName,
    required this.shortName,
    required this.family,
    required this.structure,
    this.fineness,
    this.coreMaterial,
    this.ringMaterial,
    this.platingMaterial,
    this.alloyComposition,
    this.aliases = const [],
  });

  /// Evaluates whether this definition matches a search query or legacy string.
  bool matches(String query) {
    final clean = query.trim().toLowerCase();
    if (clean.isEmpty) return false;
    if (key.toLowerCase() == clean) return true;
    if (displayName.toLowerCase() == clean) return true;
    if (shortName.toLowerCase() == clean) return true;
    return aliases.any((alias) => alias.trim().toLowerCase() == clean);
  }
}
