import '../../../../../core/constants/app_technical_strings.dart';
import 'numismatic_motif_rule.dart';

/// Represents a specific numismatic piece or banknote denomination definition within an epoch.
class NumismaticPieceDefinition {
  final String denomination;
  final List<NumismaticMotifRule> motifs;
  final double? weightGrams;
  final double? diameterMm;
  final bool isBanknote;
  final String? currencyCode;
  final int? _minYearOverride;
  final int? _maxYearOverride;

  const NumismaticPieceDefinition({
    required this.denomination,
    required this.motifs,
    int? minYear,
    int? maxYear,
    this.weightGrams,
    this.diameterMm,
    this.isBanknote = false,
    this.currencyCode,
  })  : _minYearOverride = minYear,
        _maxYearOverride = maxYear;

  /// Dynamic lower bound year derived from motifs (or explicit override if motifs is empty).
  int? get minYear {
    if (motifs.isEmpty) return _minYearOverride;
    var min = motifs.first.minYear;
    for (final m in motifs) {
      if (m.minYear < min) min = m.minYear;
    }
    return min;
  }

  /// Dynamic upper bound year derived from motifs (or explicit override if motifs is empty).
  int? get maxYear {
    if (motifs.isEmpty) return _maxYearOverride;
    var max = motifs.first.maxYear;
    for (final m in motifs) {
      if (m.maxYear > max) max = m.maxYear;
    }
    return max;
  }

  /// Evaluates whether this specific piece was active/minted in the given [year].
  bool matchesYear(int? year) {
    if (year == null) return true;
    if (motifs.isEmpty) {
      if (_minYearOverride != null && year < _minYearOverride!) return false;
      if (_maxYearOverride != null && year > _maxYearOverride!) return false;
      return true;
    }
    return motifs.any((m) => m.matchesYear(year));
  }

  /// Evaluates whether this piece matches the given [targetDenom] string or fractional representation.
  bool matchesDenomination(String targetDenom) {
    final s1 = denomination.trim().toLowerCase();
    final s2 = targetDenom.trim().toLowerCase();
    if (s1 == s2) return true;

    final num1 = parseDenominationNumber(s1);
    final num2 = parseDenominationNumber(s2);
    if (num1 != null && num2 != null) {
      return (num1 - num2).abs() < 0.0001;
    }
    return false;
  }

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

  /// Returns commemorative motif names matching the specified [year].
  List<String> getMotifsForYear(int? year) {
    if (motifs.isEmpty) return const [];
    return motifs
        .where((m) => m.matchesYear(year))
        .map((m) => m.name)
        .toList();
  }

  /// Static numeric parser supporting fractions (e.g. '1/4' -> 0.25, '1/8' -> 0.125) and decimals.
  static double? parseDenominationNumber(String val) {
    final direct = double.tryParse(val);
    if (direct != null) return direct;
    if (val.contains(AppTechnicalStrings.slash)) {
      final parts = val.split(AppTechnicalStrings.slash);
      if (parts.length == 2) {
        final numerator = double.tryParse(parts[0].trim());
        final denominator = double.tryParse(parts[1].trim());
        if (numerator != null && denominator != null && denominator != 0) {
          return numerator / denominator;
        }
      }
    }
    return null;
  }
}

