import '../data/numismatic_denominations_registry.dart';
import '../data/numismatic_materials_registry.dart';
import 'numismatic_motif_rule.dart';

/// Represents a specific numismatic piece or banknote denomination definition within an epoch.
class NumismaticPieceDefinition {
  final String denomination;
  final String currency;
  final List<NumismaticMotifRule> motifs;
  final double? weightGrams;
  final double? diameterMm;

  const NumismaticPieceDefinition({
    required this.denomination,
    required this.currency,
    required this.motifs,
    this.weightGrams,
    this.diameterMm,
  });

  /// Dynamic lower bound year derived from motifs.
  int? get minYear {
    if (motifs.isEmpty) return null;
    var min = motifs.first.minYear;
    for (final m in motifs) {
      if (m.minYear < min) min = m.minYear;
    }
    return min;
  }

  /// Dynamic upper bound year derived from motifs.
  int? get maxYear {
    if (motifs.isEmpty) return null;
    var max = motifs.first.maxYear;
    for (final m in motifs) {
      if (m.maxYear > max) max = m.maxYear;
    }
    return max;
  }

  /// Evaluates whether this specific piece was active/minted in the given [year].
  bool matchesYear(int? year) {
    if (year == null) return true;
    if (motifs.isEmpty) return true;
    return motifs.any((m) => m.matchesYear(year));
  }

  /// Evaluates whether this piece matches the given [targetDenom] string or fractional representation.
  bool matchesDenomination(String targetDenom) =>
      NumismaticDenominationsRegistry.matches(denomination, targetDenom);

  /// Returns active materials strictly for the specified [year] (or all materials if [year] is null).
  List<String> getMaterialsForYear(int? year) {
    final active = year == null ? motifs : motifs.where((m) => m.matchesYear(year));
    final seen = <String>{};
    final list = <String>[];
    for (final m in active) {
      if (m.material.trim().isNotEmpty && seen.add(m.material.trim())) {
        list.add(m.material.trim());
      }
    }
    return list;
  }

  /// Returns the primary material for the specified [year].
  String? getPrimaryMaterialForYear(int? year) {
    final mats = getMaterialsForYear(year);
    return mats.isNotEmpty ? mats.first : null;
  }

  /// Backward-compatibility accessor for primary material.
  String? get material => getPrimaryMaterialForYear(null);

  /// Backward-compatibility accessor for valid materials list.
  List<String> get effectiveAllowedMaterials => getMaterialsForYear(null);

  /// Backward-compatibility alias for effective allowed materials.
  List<String> get allowedMaterials => effectiveAllowedMaterials;

  /// Returns commemorative motif names matching the specified [year], optionally filtered by [material].
  List<String> getMotifsForYear(int? year, {String? material}) {
    if (motifs.isEmpty) return const [];
    var active = year == null ? motifs : motifs.where((m) => m.matchesYear(year));
    if (material != null && material.trim().isNotEmpty) {
      final cleanMat = material.trim().toLowerCase();
      final resolvedTarget = NumismaticMaterialsRegistry.resolve(material);
      active = active.where((m) {
        if (m.material.trim().toLowerCase() == cleanMat) return true;
        if (resolvedTarget != null && m.material == resolvedTarget.displayName) return true;
        return NumismaticMaterialsRegistry.areCompatible(m.material, material);
      });
    }
    return active.map((m) => m.name).toList();
  }

  /// Static numeric parser supporting fractions (e.g. '1/4' -> 0.25, '1/8' -> 0.125) and decimals.
  static double? parseDenominationNumber(String val) =>
      NumismaticDenominationsRegistry.parseNumber(val);
}


