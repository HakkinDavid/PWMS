/// Metadata representation of a temporally bounded numismatic commemorative or standard motif.
class NumismaticMotifRule {
  final String name;
  final int minYear;
  final int maxYear;
  final String? kmNumber;
  final String? numistaUrl;
  final bool isStandard;

  const NumismaticMotifRule(
    this.name,
    int minYear, [
    int? maxYear,
    this.kmNumber,
    this.numistaUrl,
    this.isStandard = false,
  ])  : minYear = minYear,
        maxYear = maxYear ?? minYear;

  bool matchesYear(int? year) {
    if (year == null) return true;
    if (year < minYear) return false;
    if (year > maxYear) return false;
    return true;
  }
}

