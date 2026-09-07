/// Metadata representation of a specific numismatic type, commemorative or standard motif.
class NumismaticMotifRule {
  final String name;
  final int minYear;
  final int maxYear;
  final String material;
  final double? weightGrams;
  final double? diameterMm;
  final String? currencyCode;
  final bool isCommemorative;

  const NumismaticMotifRule(
    this.name, {
    required this.minYear,
    int? maxYear,
    required this.material,
    this.weightGrams,
    this.diameterMm,
    this.currencyCode,
    this.isCommemorative = false,
  }) : maxYear = maxYear ?? minYear;

  /// Evaluates whether this specific motif / type was active/minted in the given [year].
  bool matchesYear(int? year) {
    if (year == null) return true;
    if (year < minYear) return false;
    if (year > maxYear) return false;
    return true;
  }
}

