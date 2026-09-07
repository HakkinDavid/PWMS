import 'numismatic_motif_rule.dart';
import 'numismatic_piece_definition.dart';

/// Metadata record representing a country's currency epoch emission rules (Coins or Banknotes).
class NumismaticEmissionRuleData {
  final String country;
  final int minYear;
  final int maxYear;
  final List<String> validCurrencies;
  final String? defaultCurrency;
  final List<NumismaticPieceDefinition> pieces;
  final bool isBanknote;

  const NumismaticEmissionRuleData({
    required this.country,
    required this.minYear,
    required this.maxYear,
    required this.validCurrencies,
    this.defaultCurrency,
    this.pieces = const [],
    this.isBanknote = false,
  });

  /// List of distinct denomination strings supported in this epoch.
  List<String> get denominations {
    final list = <String>[];
    for (final p in pieces) {
      if (!list.contains(p.denomination)) list.add(p.denomination);
    }
    return list;
  }

  /// Standard material map by denomination.
  Map<String, String> get denominationMaterials {
    final map = <String, String>{};
    for (final p in pieces) {
      if (p.material != null && p.material!.trim().isNotEmpty) {
        map[p.denomination] = p.material!;
      }
    }
    return map;
  }

  /// Allowed materials map by denomination.
  Map<String, List<String>> get denominationAllowedMaterials {
    final map = <String, List<String>>{};
    for (final p in pieces) {
      if (p.effectiveAllowedMaterials.isNotEmpty) {
        map[p.denomination] = p.effectiveAllowedMaterials;
      }
    }
    return map;
  }

  /// List of commemorative reasons / motif names in this epoch.
  List<String> get commemorativeReasons {
    final reasons = <String>{};
    for (final p in pieces) {
      for (final m in p.motifs) {
        if (m.name.trim().isNotEmpty) {
          reasons.add(m.name);
        }
      }
    }
    return reasons.toList();
  }

  /// Set of strictly commemorative denominations.
  Set<String> get commemorativeDenominations {
    return pieces
        .where((p) => p.motifs.isNotEmpty)
        .map((p) => p.denomination)
        .toSet();
  }

  /// Commemorative motifs grouped by denomination.
  Map<String, List<NumismaticMotifRule>> get commemorativeMotifsByDenomination {
    final map = <String, List<NumismaticMotifRule>>{};
    for (final p in pieces) {
      if (p.motifs.isNotEmpty) {
        map[p.denomination] = p.motifs;
      }
    }
    return map;
  }

  /// Returns piece definitions that were actively minted in [year].
  List<NumismaticPieceDefinition> getPiecesForYear(int? year) {
    return pieces.where((p) => p.matchesYear(year)).toList();
  }

  /// Returns denomination strings that were actively minted in [year].
  List<String> getDenominationsForYear(int? year) {
    if (year == null) return denominations;
    final activePieces = getPiecesForYear(year);
    if (activePieces.isEmpty) return denominations;
    final list = <String>[];
    for (final p in activePieces) {
      if (!list.contains(p.denomination)) list.add(p.denomination);
    }
    return list;
  }

  /// Returns the piece definition matching [targetDenom] and [year].
  NumismaticPieceDefinition? getPieceForDenomination(String targetDenom, {int? year}) {
    final candidatePieces = getPiecesForYear(year);
    for (final p in candidatePieces) {
      if (p.matchesDenomination(targetDenom)) {
        return p;
      }
    }
    return null;
  }

  bool matches(String targetCountry, int year, {bool isBanknote = false}) {
    if (country.toLowerCase() != targetCountry.trim().toLowerCase()) return false;
    if (this.isBanknote != isBanknote) return false;
    return year >= minYear && year <= maxYear;
  }

  bool hasDenomination(String targetDenom, {int? year}) {
    if (year != null) {
      return getPiecesForYear(year).any((p) => p.matchesDenomination(targetDenom));
    }
    return denominations.any((d) => matchesDenomination(d, targetDenom));
  }

  String? getMaterialForDenomination(String targetDenom, {int? year}) {
    final matchedPiece = getPieceForDenomination(targetDenom, year: year);
    if (matchedPiece != null && matchedPiece.material != null) {
      return matchedPiece.material;
    }
    for (final entry in denominationMaterials.entries) {
      if (matchesDenomination(entry.key, targetDenom)) {
        return entry.value;
      }
    }
    for (final entry in denominationAllowedMaterials.entries) {
      if (matchesDenomination(entry.key, targetDenom) && entry.value.isNotEmpty) {
        return entry.value.first;
      }
    }
    return null;
  }

  List<String> getAllowedMaterialsForDenomination(String targetDenom, {int? year}) {
    final matchedPiece = getPieceForDenomination(targetDenom, year: year);
    if (matchedPiece != null && matchedPiece.effectiveAllowedMaterials.isNotEmpty) {
      return matchedPiece.effectiveAllowedMaterials;
    }
    for (final entry in denominationAllowedMaterials.entries) {
      if (matchesDenomination(entry.key, targetDenom)) {
        return entry.value;
      }
    }
    final primary = getMaterialForDenomination(targetDenom, year: year);
    if (primary != null && primary.isNotEmpty) {
      return [primary];
    }
    return const [];
  }

  String? getDefaultMaterialForDenomination(String targetDenom, {int? year}) {
    final matchedPiece = getPieceForDenomination(targetDenom, year: year);
    if (matchedPiece != null && matchedPiece.material != null) {
      return matchedPiece.material;
    }
    for (final entry in denominationMaterials.entries) {
      if (matchesDenomination(entry.key, targetDenom)) {
        return entry.value;
      }
    }
    return null;
  }

  bool isMaterialValidForDenomination(String targetDenom, String targetMaterial, {int? year}) {
    final allowed = getAllowedMaterialsForDenomination(targetDenom, year: year);
    if (allowed.isEmpty) return true;
    final cleanTarget = targetMaterial.trim().toLowerCase();
    return allowed.any((mat) => mat.trim().toLowerCase() == cleanTarget);
  }

  List<String> getCommemorativeMotifsForDenomination(String targetDenom, {int? year}) {
    final matchedPiece = getPieceForDenomination(targetDenom, year: year);
    if (matchedPiece != null && matchedPiece.motifs.isNotEmpty) {
      final matching = matchedPiece.getMotifsForYear(year);
      if (matching.isNotEmpty) return matching;
    }

    for (final entry in commemorativeMotifsByDenomination.entries) {
      if (matchesDenomination(entry.key, targetDenom)) {
        final matching = entry.value
            .where((m) => m.matchesYear(year))
            .map((m) => m.name)
            .toList();
        return matching;
      }
    }
    return const [];
  }

  bool isMotifValidForDenomination(String targetDenom, String targetMotif, {int? year}) {
    final motifs = getCommemorativeMotifsForDenomination(targetDenom, year: year);
    if (motifs.isEmpty) return true;
    return motifs.any((m) => matchesMotif(m, targetMotif));
  }

  static bool matchesMotif(String motif1, String motif2) {
    final c1 = motif1.trim().toLowerCase();
    final c2 = motif2.trim().toLowerCase();
    if (c1 == c2 || c1.contains(c2) || c2.contains(c1)) return true;
    final b1 = c1.replaceAll(RegExp(r'\(\d{4}[^\)]*\)'), '').trim();
    final b2 = c2.replaceAll(RegExp(r'\(\d{4}[^\)]*\)'), '').trim();
    if (b1.isNotEmpty && b2.isNotEmpty) {
      if (b1 == b2 || b1.contains(b2) || b2.contains(b1)) return true;
    }
    return false;
  }

  static bool matchesDenomination(String d1, String d2) {
    final s1 = d1.trim().toLowerCase();
    final s2 = d2.trim().toLowerCase();
    if (s1 == s2) return true;
    final num1 = NumismaticPieceDefinition.parseDenominationNumber(s1);
    final num2 = NumismaticPieceDefinition.parseDenominationNumber(s2);
    if (num1 != null && num2 != null) {
      return (num1 - num2).abs() < 0.0001;
    }
    return false;
  }
}
