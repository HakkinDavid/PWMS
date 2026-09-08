/// Canonical model defining the complete monetary configuration, major unit, and subunit system
/// for a numismatic currency (modern or historical).
class NumismaticCurrencyDefinition {
  /// Unique ISO 4217 code or technical key (e.g. 'MXN', 'MXP', 'USD', 'REAL', 'EUR', 'GBP').
  final String code;

  /// Singular Spanish display name (e.g. 'Peso Mexicano', 'Dólar Estadounidense', 'Euro', 'Real Colonial').
  final String name;

  /// Plural Spanish display name (e.g. 'Pesos Mexicanos', 'Pesos Mexicanos Antiguos', 'Dólares Estadounidenses').
  final String namePlural;

  /// Primary monetary symbol (e.g. '$', '€', '£', '₹', '¥', 'R$').
  final String symbol;

  /// Whether this currency possesses a subunit / fractional subdivision.
  final bool hasSubunit;

  /// Singular subunit name (e.g. 'Centavo', 'Cent', 'Céntimo', 'Penique', 'Paisa', 'Maravedí').
  final String? subunitName;

  /// Plural subunit name (e.g. 'Centavos', 'Cents', 'Céntimos', 'Peniques', 'Paise', 'Maravedíes').
  final String? subunitNamePlural;

  /// Subunit symbol (e.g. '¢', 'c', 'p').
  final String? subunitSymbol;

  /// Subunit ratio against the major unit (e.g. 100 for 100 centavos = 1 peso, 1000 for dinars, 34 for maravedíes).
  final int subunitRatio;

  /// Map of specific numerical values (as strings, e.g. '0.25', '0.10', '0.5', '4', '8')
  /// to historical or colloquial denomination names (e.g. 'Cuarto de Dólar (Quarter)', 'Dime', 'Medio Real', 'Tostón', 'Real de a 8').
  final Map<String, String> namedDenominations;

  const NumismaticCurrencyDefinition({
    required this.code,
    required this.name,
    required this.namePlural,
    required this.symbol,
    this.hasSubunit = true,
    this.subunitName,
    this.subunitNamePlural,
    this.subunitSymbol,
    this.subunitRatio = 100,
    this.namedDenominations = const {},
  });
}
