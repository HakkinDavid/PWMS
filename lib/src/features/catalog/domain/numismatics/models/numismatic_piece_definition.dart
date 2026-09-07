import 'package:platinum_world_management_system/src/core/constants/app_technical_strings.dart';
import 'numismatic_motif_rule.dart';

/// Represents a specific numismatic piece or banknote denomination definition within an epoch.
class NumismaticPieceDefinition {
  final String denomination;
  final int? minYear;
  final int? maxYear;
  final String? material;
  final List<String> allowedMaterials;
  final List<NumismaticMotifRule> motifs;
  final String? commonName;
  final String? motifName;
  final double? weightGrams;
  final double? diameterMm;
  final bool isBanknote;
  final String? currencyCode;

  const NumismaticPieceDefinition({
    required this.denomination,
    this.minYear,
    this.maxYear,
    this.material,
    this.allowedMaterials = const [],
    this.motifs = const [],
    this.commonName,
    this.motifName,
    this.weightGrams,
    this.diameterMm,
    this.isBanknote = false,
    this.currencyCode,
  });

  /// Evaluates whether this specific piece was active/minted in the given [year].
  bool matchesYear(int? year) {
    if (year == null) return true;
    if (minYear != null && year < minYear!) return false;
    if (maxYear != null && year > maxYear!) return false;
    return true;
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

  /// Returns all valid materials for this piece.
  List<String> get effectiveAllowedMaterials {
    if (allowedMaterials.isNotEmpty) {
      return allowedMaterials;
    }
    if (material != null && material!.trim().isNotEmpty) {
      return [material!];
    }
    return const [];
  }

  /// Effective visual motif name representing this piece.
  String? get effectiveMotifName => motifName ?? commonName;

  /// Returns commemorative motif names matching the specified [year] (excluding standard circulation tokens).
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
