/// Metadata representation of a temporally bounded numismatic commemorative or standard motif.
class NumismaticMotifRule {
  final String? name;
  final int? minYear;
  final int? maxYear;
  final String? kmNumber;
  final String? numistaUrl;

  const NumismaticMotifRule(
    String name,
    int minYear, [
    int? maxYear,
    this.kmNumber,
    this.numistaUrl,
  ])  : name = name,
        minYear = minYear,
        maxYear = maxYear ?? minYear;

  /// Explicit constructor declaring standard circulation availability without a special commemorative motif.
  const NumismaticMotifRule.standard([
    this.minYear,
    this.maxYear,
    this.kmNumber,
    this.numistaUrl,
  ]) : name = null;

  /// Returns true if this rule represents the standard circulating edition.
  bool get isStandard => name == null;

  bool matchesYear(int? year) {
    if (year == null) return true;
    if (minYear != null && year < minYear!) return false;
    if (maxYear != null && year > maxYear!) return false;
    return true;
  }
}

