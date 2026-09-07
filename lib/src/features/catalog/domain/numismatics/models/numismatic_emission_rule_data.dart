import 'package:platinum_world_management_system/src/core/constants/app_technical_strings.dart';
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
  final List<String> _explicitDenominations;
  final Map<String, String> _explicitDenominationMaterials;
  final Map<String, List<String>> _explicitDenominationAllowedMaterials;
  final Set<String> _explicitCommemorativeDenominations;
  final List<String> _explicitCommemorativeReasons;
  final Map<String, List<NumismaticMotifRule>> _explicitCommemorativeMotifsByDenomination;
  final String? defaultCommemorativeReason;
  final bool isBanknote;

  const NumismaticEmissionRuleData({
    required this.country,
    required this.minYear,
    required this.maxYear,
    required this.validCurrencies,
    this.defaultCurrency,
    List<NumismaticPieceDefinition> pieces = const [],
    List<String> denominations = const [],
    Map<String, String> denominationMaterials = const {},
    Map<String, List<String>> denominationAllowedMaterials = const {},
    Set<String> commemorativeDenominations = const {},
    List<String> commemorativeReasons = const [],
    Map<String, List<NumismaticMotifRule>> commemorativeMotifsByDenomination = const {},
    this.defaultCommemorativeReason,
    this.isBanknote = false,
  })  : pieces = pieces,
        _explicitDenominations = denominations,
        _explicitDenominationMaterials = denominationMaterials,
        _explicitDenominationAllowedMaterials = denominationAllowedMaterials,
        _explicitCommemorativeDenominations = commemorativeDenominations,
        _explicitCommemorativeReasons = commemorativeReasons,
        _explicitCommemorativeMotifsByDenomination = commemorativeMotifsByDenomination;

  /// Returns effective piece definitions (either explicitly declared, or synthesized from legacy maps).
  List<NumismaticPieceDefinition> get effectivePieces {
    if (pieces.isNotEmpty) {
      return pieces;
    }
    final syn = <NumismaticPieceDefinition>[];
    for (final d in _explicitDenominations) {
      final mat = _explicitDenominationMaterials[d];
      final allowed = _explicitDenominationAllowedMaterials[d] ?? (mat != null ? [mat] : const []);
      final motifs = _explicitCommemorativeMotifsByDenomination[d] ?? const [];
      syn.add(NumismaticPieceDefinition(
        denomination: d,
        minYear: minYear,
        maxYear: maxYear,
        material: mat,
        allowedMaterials: allowed,
        motifs: motifs,
        isBanknote: isBanknote,
      ));
    }
    return syn;
  }

  /// List of distinct denomination strings supported in this epoch.
  List<String> get denominations {
    if (_explicitDenominations.isNotEmpty) {
      return _explicitDenominations;
    }
    final list = <String>[];
    for (final p in pieces) {
      if (!list.contains(p.denomination)) list.add(p.denomination);
    }
    return list;
  }

  /// Standard material map by denomination.
  Map<String, String> get denominationMaterials {
    if (_explicitDenominationMaterials.isNotEmpty) {
      return _explicitDenominationMaterials;
    }
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
    if (_explicitDenominationAllowedMaterials.isNotEmpty) {
      return _explicitDenominationAllowedMaterials;
    }
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
    if (_explicitCommemorativeReasons.isNotEmpty) {
      return _explicitCommemorativeReasons;
    }
    final reasons = <String>{};
    for (final p in effectivePieces) {
      for (final m in p.motifs) {
        if (!m.isStandard && m.name != null && m.name!.trim().isNotEmpty) {
          reasons.add(m.name!);
        }
      }
    }
    return reasons.toList();
  }

  /// Set of strictly commemorative denominations.
  Set<String> get commemorativeDenominations {
    if (_explicitCommemorativeDenominations.isNotEmpty) {
      return _explicitCommemorativeDenominations;
    }
    return effectivePieces
        .where((p) => p.motifs.any((m) => !m.isStandard))
        .map((p) => p.denomination)
        .toSet();
  }

  /// Commemorative motifs grouped by denomination.
  Map<String, List<NumismaticMotifRule>> get commemorativeMotifsByDenomination {
    if (_explicitCommemorativeMotifsByDenomination.isNotEmpty) {
      return _explicitCommemorativeMotifsByDenomination;
    }
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
    return effectivePieces.where((p) => p.matchesYear(year)).toList();
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

  bool isCommemorativeDenomination(String targetDenom, {int? year}) {
    final matchedPiece = getPieceForDenomination(targetDenom, year: year);
    if (matchedPiece != null && matchedPiece.motifs.isNotEmpty) {
      return !matchedPiece.allowsStandardForYear(year);
    }
    if (_explicitCommemorativeDenominations.isNotEmpty) {
      return _explicitCommemorativeDenominations.any((d) => matchesDenomination(d, targetDenom));
    }
    return false;
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
            .where((m) => !m.isStandard && m.matchesYear(year))
            .map((m) => m.name!)
            .toList();
        return matching;
      }
    }
    if (commemorativeReasons.isNotEmpty) {
      if (commemorativeDenominations.isEmpty || isCommemorativeDenomination(targetDenom, year: year)) {
        return commemorativeReasons;
      }
    }
    if (defaultCommemorativeReason != null && defaultCommemorativeReason!.trim().isNotEmpty) {
      if (commemorativeDenominations.isEmpty || isCommemorativeDenomination(targetDenom, year: year)) {
        return [defaultCommemorativeReason!];
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
    final b1 = c1.replaceAll(RegExp(AppTechnicalStrings.regexMotifParenthesizedYears), AppTechnicalStrings.empty).trim();
    final b2 = c2.replaceAll(RegExp(AppTechnicalStrings.regexMotifParenthesizedYears), AppTechnicalStrings.empty).trim();
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
