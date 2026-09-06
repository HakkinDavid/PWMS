/// Metadata representation of a temporally bounded numismatic material / alloy rule.
class NumismaticMaterialRule {
  final String material;
  final int minYear;
  final int maxYear;
  final bool isPrimary;

  const NumismaticMaterialRule(
    this.material,
    this.minYear, [
    int? maxYear,
    this.isPrimary = true,
  ]) : maxYear = maxYear ?? minYear;

  bool matchesYear(int? year) {
    if (year == null) return true;
    return year >= minYear && year <= maxYear;
  }
}
