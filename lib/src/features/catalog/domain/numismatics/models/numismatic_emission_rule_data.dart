import '../../../../../core/constants/app_technical_strings.dart';

/// Metadata record representing a country's currency epoch emission rules (Coins or Banknotes).
class NumismaticEmissionRuleData {
  final String country;
  final List<NumismaticPieceDefinition> pieces;
  final bool isBanknote;

  const NumismaticEmissionRuleData({
    required this.country,
    this.pieces = const [],
    this.isBanknote = false,
  });

  /// Dynamic lower bound year derived from pieces.
  int get minYear {
    if (pieces.isEmpty) return 0;
    final validMinYears = pieces.map((p) => p.minYear).whereType<int>();
    return validMinYears.isEmpty ? 0 : validMinYears.reduce((a, b) => a < b ? a : b);
  }

  /// Dynamic upper bound year derived from pieces.
  int get maxYear {
    if (pieces.isEmpty) return 9999;
    final validMaxYears = pieces.map((p) => p.maxYear).whereType<int>();
    return validMaxYears.isEmpty ? 9999 : validMaxYears.reduce((a, b) => a > b ? a : b);
  }

  /// List of distinct ISO currency codes supported in this epoch, derived dynamically from pieces.
  List<String> get validCurrencies {
    final seen = <String>{};
    final list = <String>[];
    for (final p in pieces) {
      final c = p.currency.trim().toUpperCase();
      if (c.isNotEmpty && seen.add(c)) {
        list.add(c);
      }
    }
    return list;
  }

  /// Primary / default currency ISO code (first registered currency).
  String? get defaultCurrency => validCurrencies.isNotEmpty ? validCurrencies.first : null;

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
        final current = map[p.denomination] ?? <String>[];
        for (final mat in p.effectiveAllowedMaterials) {
          if (!current.contains(mat)) {
            current.add(mat);
          }
        }
        map[p.denomination] = current;
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
        (map[p.denomination] ??= []).addAll(p.motifs);
      }
    }
    return map;
  }

  /// Returns piece definitions that were actively minted in [year], optionally filtered by [currencyCode].
  List<NumismaticPieceDefinition> getPiecesForYear(int? year, {String? currencyCode}) {
    var active = pieces.where((p) => p.matchesYear(year));
    if (currencyCode != null && currencyCode.trim().isNotEmpty) {
      final cleanCurr = currencyCode.trim().toUpperCase();
      active = active.where((p) => p.currency.toUpperCase() == cleanCurr);
    }
    return active.toList();
  }

  /// Returns denomination strings that were actively minted in [year], optionally filtered by [currencyCode].
  List<String> getDenominationsForYear(int? year, {String? currencyCode}) {
    if (year == null && currencyCode == null) return denominations;
    final activePieces = getPiecesForYear(year, currencyCode: currencyCode);
    if (activePieces.isEmpty) return denominations;
    final list = <String>[];
    for (final p in activePieces) {
      if (!list.contains(p.denomination)) list.add(p.denomination);
    }
    return list;
  }

  /// Returns the piece definition matching [targetDenom], [year], and optional [currencyCode].
  NumismaticPieceDefinition? getPieceForDenomination(
    String targetDenom, {
    int? year,
    String? currencyCode,
  }) {
    final candidatePieces = getPiecesForYear(year);
    if (currencyCode != null && currencyCode.trim().isNotEmpty) {
      final cleanCurr = currencyCode.trim().toUpperCase();
      for (final p in candidatePieces) {
        if (p.matchesDenomination(targetDenom) && p.currency.toUpperCase() == cleanCurr) {
          return p;
        }
      }
    }
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

  bool hasDenomination(String targetDenom, {int? year, String? currencyCode}) {
    if (year != null || currencyCode != null) {
      return getPiecesForYear(year, currencyCode: currencyCode).any((p) => p.matchesDenomination(targetDenom));
    }
    return denominations.any((d) => matchesDenomination(d, targetDenom));
  }

  String? getMaterialForDenomination(String targetDenom, {int? year, String? currencyCode}) {
    final matchedPiece = getPieceForDenomination(targetDenom, year: year, currencyCode: currencyCode);
    if (matchedPiece != null) {
      final mat = matchedPiece.getPrimaryMaterialForYear(year);
      if (mat != null) return mat;
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

  List<String> getAllowedMaterialsForDenomination(String targetDenom, {int? year, String? currencyCode}) {
    final matchedPiece = getPieceForDenomination(targetDenom, year: year, currencyCode: currencyCode);
    if (matchedPiece != null) {
      final mats = matchedPiece.getMaterialsForYear(year);
      if (mats.isNotEmpty) return mats;
    }
    // If a year was supplied, only return materials from pieces active for that year —
    // never fall through to unfiltered maps or getMaterialForDenomination.
    if (year != null) {
      final activePieces = getPiecesForYear(year, currencyCode: currencyCode);
      final result = <String>[];
      for (final piece in activePieces) {
        if (piece.matchesDenomination(targetDenom)) {
          for (final mat in piece.getMaterialsForYear(year)) {
            if (!result.contains(mat)) result.add(mat);
          }
        }
      }
      // Return whatever was found (may be empty if denomination has no active piece this year).
      return result;
    }
    // No year filter: use legacy unfiltered maps for backward-compatibility.
    for (final entry in denominationAllowedMaterials.entries) {
      if (matchesDenomination(entry.key, targetDenom)) {
        return entry.value;
      }
    }
    final primary = getMaterialForDenomination(targetDenom, year: year, currencyCode: currencyCode);
    if (primary != null && primary.isNotEmpty) {
      return [primary];
    }
    return const [];
  }

  String? getDefaultMaterialForDenomination(String targetDenom, {int? year, String? currencyCode}) {
    final matchedPiece = getPieceForDenomination(targetDenom, year: year, currencyCode: currencyCode);
    if (matchedPiece != null) {
      final mat = matchedPiece.getPrimaryMaterialForYear(year);
      if (mat != null) return mat;
    }
    for (final entry in denominationMaterials.entries) {
      if (matchesDenomination(entry.key, targetDenom)) {
        return entry.value;
      }
    }
    return null;
  }



  bool isMaterialValidForDenomination(String targetDenom, String targetMaterial, {int? year, String? currencyCode}) {
    final allowed = getAllowedMaterialsForDenomination(targetDenom, year: year, currencyCode: currencyCode);
    if (allowed.isEmpty) return true;
    final cleanTarget = targetMaterial.trim().toLowerCase();
    final resolvedTarget = NumismaticMaterialsRegistry.resolve(targetMaterial);
    return allowed.any((mat) {
      if (mat.trim().toLowerCase() == cleanTarget) return true;
      if (resolvedTarget != null && mat == resolvedTarget.displayName) return true;
      return NumismaticMaterialsRegistry.areCompatible(mat, targetMaterial);
    });
  }

  List<String> getCommemorativeMotifsForDenomination(String targetDenom, {int? year, String? currencyCode, String? material}) {
    final matchedPiece = getPieceForDenomination(targetDenom, year: year, currencyCode: currencyCode);
    if (matchedPiece != null && matchedPiece.motifs.isNotEmpty) {
      final matching = matchedPiece.getMotifsForYear(year, material: material);
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

  static final _yearRegex = RegExp(AppTechnicalStrings.regexFourDigitYearParentheses);

  static bool matchesMotif(String motif1, String motif2) {
    final c1 = motif1.trim().toLowerCase();
    final c2 = motif2.trim().toLowerCase();
    if (c1 == c2) return true;
    return false;
  }

  static bool matchesDenomination(String d1, String d2) =>
      NumismaticDenominationsRegistry.matches(d1, d2);
}
