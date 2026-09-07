/// Encapsulates the complete context of a numismatic query or entity evaluation.
class NumismaticQueryContext {
  final String? country;
  final int? year;
  final String? currencyCode;
  final String? denomination;
  final String? material;
  final String? motif;
  final bool isBanknote;

  const NumismaticQueryContext({
    this.country,
    this.year,
    this.currencyCode,
    this.denomination,
    this.material,
    this.motif,
    this.isBanknote = false,
  });

  NumismaticQueryContext copyWith({
    String? country,
    int? year,
    String? currencyCode,
    String? denomination,
    String? material,
    String? motif,
    bool? isBanknote,
  }) {
    return NumismaticQueryContext(
      country: country ?? this.country,
      year: year ?? this.year,
      currencyCode: currencyCode ?? this.currencyCode,
      denomination: denomination ?? this.denomination,
      material: material ?? this.material,
      motif: motif ?? this.motif,
      isBanknote: isBanknote ?? this.isBanknote,
    );
  }
}
