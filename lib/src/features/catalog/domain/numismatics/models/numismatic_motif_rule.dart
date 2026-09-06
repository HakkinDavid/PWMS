/// Metadata representation of a temporally bounded numismatic commemorative motif.
class NumismaticMotifRule {
  final String name;
  final int minYear;
  final int maxYear;

  const NumismaticMotifRule(
    this.name,
    this.minYear, [
    int? maxYear,
  ]) : maxYear = maxYear ?? minYear;

  bool matchesYear(int? year) {
    if (year == null) return true;
    return year >= minYear && year <= maxYear;
  }
}
