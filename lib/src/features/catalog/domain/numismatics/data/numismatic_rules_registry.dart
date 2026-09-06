import '../models/numismatic_emission_rule_data.dart';
import 'banknote_emission_rules.dart';
import 'mexico_emission_rules.dart';
import 'spain_emission_rules.dart';
import 'usa_emission_rules.dart';
import 'world_coins_emission_rules.dart';

/// Central registry indexing and providing fast O(1) partitioned lookups for numismatic emission rules.
class NumismaticRulesRegistry {
  NumismaticRulesRegistry._();

  /// Flat list of all rules across all domains, geography partitions, and eras.
  static final List<NumismaticEmissionRuleData> allRules = [
    ...mexicoEmissionRules,
    ...usaEmissionRules,
    ...spainEmissionRules,
    ...worldCoinsEmissionRules,
    ...banknoteEmissionRules,
  ];

  /// Fast index map keyed by normalized `"$countryKey|$isBanknote"`.
  static final Map<String, List<NumismaticEmissionRuleData>> _indexedRules = () {
    final map = <String, List<NumismaticEmissionRuleData>>{};
    for (final rule in allRules) {
      final key = _buildKey(rule.country, rule.isBanknote);
      (map[key] ??= []).add(rule);
    }
    return map;
  }();

  static String _buildKey(String country, bool isBanknote) =>
      '${country.trim().toLowerCase()}|$isBanknote';

  /// Returns all rules matching the normalized country and isBanknote partition.
  static List<NumismaticEmissionRuleData> getRulesForCountry(String country, {bool isBanknote = false}) {
    return _indexedRules[_buildKey(country, isBanknote)] ?? const [];
  }

  /// Finds all matching emission rules for given country, year, and piece type (coin vs banknote).
  static List<NumismaticEmissionRuleData> findRules(
    String? country,
    int? year, {
    bool isBanknote = false,
  }) {
    if (country == null || country.trim().isEmpty) {
      return const [];
    }
    if (year == null) return const [];

    final candidateRules = getRulesForCountry(country, isBanknote: isBanknote);
    return candidateRules.where((rule) => year >= rule.minYear && year <= rule.maxYear).toList();
  }
}
