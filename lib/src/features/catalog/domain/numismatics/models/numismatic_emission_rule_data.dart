import 'package:platinum_world_management_system/src/core/constants/app_technical_strings.dart';
import 'numismatic_motif_rule.dart';
import 'numismatic_material_rule.dart';

/// Metadata record representing a country's currency epoch emission rules (Coins or Banknotes).
class NumismaticEmissionRuleData {
  final String country;
  final int minYear;
  final int maxYear;
  final List<String> validCurrencies;
  final String? defaultCurrency;
  final List<String> denominations;
  final Map<String, String> denominationMaterials;
  final Map<String, List<String>> denominationAllowedMaterials;
  final Set<String> commemorativeDenominations;
  final List<String> commemorativeReasons;
  final Map<String, List<NumismaticMotifRule>> commemorativeMotifsByDenomination;
  final String? defaultCommemorativeReason;
  final bool isBanknote;

  const NumismaticEmissionRuleData({
    required this.country,
    required this.minYear,
    required this.maxYear,
    required this.validCurrencies,
    this.defaultCurrency,
    required this.denominations,
    this.denominationMaterials = const {},
    this.denominationAllowedMaterials = const {},
    this.commemorativeDenominations = const {},
    this.commemorativeReasons = const [],
    this.commemorativeMotifsByDenomination = const {},
    this.defaultCommemorativeReason,
    this.isBanknote = false,
  });

  bool matches(String targetCountry, int year, {bool isBanknote = false}) {
    if (country.toLowerCase() != targetCountry.trim().toLowerCase()) return false;
    if (this.isBanknote != isBanknote) return false;
    return year >= minYear && year <= maxYear;
  }

  bool hasDenomination(String targetDenom) {
    return denominations.any((d) => matchesDenomination(d, targetDenom));
  }

  List<String> getAllowedMaterialsForDenomination(String targetDenom) {
    for (final entry in denominationAllowedMaterials.entries) {
      if (matchesDenomination(entry.key, targetDenom)) {
        return entry.value;
      }
    }
    final singleMat = getMaterialForDenomination(targetDenom);
    if (singleMat != null) {
      return [singleMat];
    }
    return const [];
  }

  String? getMaterialForDenomination(String targetDenom) {
    if (denominationMaterials.containsKey(targetDenom)) {
      return denominationMaterials[targetDenom];
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

  bool isMaterialValidForDenomination(String targetDenom, String targetMaterial) {
    final allowed = getAllowedMaterialsForDenomination(targetDenom);
    if (allowed.isEmpty) return true;
    final cleanTarget = targetMaterial.trim().toLowerCase();
    return allowed.any((mat) => mat.trim().toLowerCase() == cleanTarget);
  }

  bool isCommemorativeDenomination(String targetDenom) {
    if (commemorativeDenominations.isNotEmpty) {
      return commemorativeDenominations.any((d) => matchesDenomination(d, targetDenom));
    }
    return false;
  }

  List<String> getCommemorativeMotifsForDenomination(String targetDenom, {int? year}) {
    for (final entry in commemorativeMotifsByDenomination.entries) {
      if (matchesDenomination(entry.key, targetDenom)) {
        final matching = entry.value
            .where((m) => m.matchesYear(year))
            .map((m) => m.name)
            .toList();
        return matching;
      }
    }
    if (commemorativeReasons.isNotEmpty) {
      if (commemorativeDenominations.isEmpty || isCommemorativeDenomination(targetDenom)) {
        return commemorativeReasons;
      }
    }
    if (defaultCommemorativeReason != null && defaultCommemorativeReason!.trim().isNotEmpty) {
      if (commemorativeDenominations.isEmpty || isCommemorativeDenomination(targetDenom)) {
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
    final num1 = _parseDenominationNumber(s1);
    final num2 = _parseDenominationNumber(s2);
    if (num1 != null && num2 != null) {
      return (num1 - num2).abs() < 0.0001;
    }
    return false;
  }

  static double? _parseDenominationNumber(String val) {
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
