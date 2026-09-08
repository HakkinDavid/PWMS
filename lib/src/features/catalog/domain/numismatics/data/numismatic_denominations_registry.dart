/// Standardized dictionary and compile-time constants for numismatic denominations.
///
/// Precomputes numeric values and fractional representations to eliminate runtime string evaluation.
abstract final class NumismaticDenominationsRegistry {
  // ---------------------------------------------------------------------------
  // 1. Vulgar Fractional Denominations (Historical & Colonial)
  // ---------------------------------------------------------------------------
  static const d1_16 = '1/16';
  static const d1_12 = '1/12';
  static const d1_8 = '1/8';
  static const d1_6 = '1/6';
  static const d1_4 = '1/4';
  static const d1_2 = '1/2';

  // ---------------------------------------------------------------------------
  // 2. Decimal Fractional Denominations (Modern & Historical Cents/Centavos)
  // ---------------------------------------------------------------------------
  static const d0_005 = '0.005';
  static const d0_01 = '0.01';
  static const d0_02 = '0.02';
  static const d0_03 = '0.03';
  static const d0_04 = '0.04';
  static const d0_05 = '0.05';
  static const d0_10 = '0.10';
  static const d0_20 = '0.20';
  static const d0_25 = '0.25';
  static const d0_40 = '0.40';
  static const d0_50 = '0.50';
  static const d0_5 = '0.5';

  // ---------------------------------------------------------------------------
  // 3. Units & Small Integer / Decimal Denominations
  // ---------------------------------------------------------------------------
  static const d1 = '1';
  static const d1s = '1s';
  static const d2 = '2';
  static const d2s = '2s';
  static const d2_5 = '2.5';
  static const d2_5s = '2.5s';
  static const d2_1_2 = '2 1/2';
  static const d3 = '3';
  static const d4 = '4';
  static const d5 = '5';
  static const d5s = '5s';
  static const d6 = '6';
  static const d8 = '8';

  // ---------------------------------------------------------------------------
  // 4. Tens & Intermediate Denominations
  // ---------------------------------------------------------------------------
  static const d10 = '10';
  static const d12 = '12';
  static const d20 = '20';
  static const d24 = '24';
  static const d25 = '25';
  static const d30 = '30';
  static const d40 = '40';
  static const d50 = '50';
  static const d80 = '80';

  // ---------------------------------------------------------------------------
  // 5. Hundreds & Historical Reis Denominations
  // ---------------------------------------------------------------------------
  static const d100 = '100';
  static const d200 = '200';
  static const d300 = '300';
  static const d400 = '400';
  static const d500 = '500';
  static const d640 = '640';
  static const d960 = '960';

  // ---------------------------------------------------------------------------
  // 6. Thousands & Banknote High Denominations
  // ---------------------------------------------------------------------------
  static const d1000 = '1000';
  static const d2000 = '2000';
  static const d5000 = '5000';
  static const d10000 = '10000';
  static const d20000 = '20000';
  static const d50000 = '50000';
  static const d100000 = '100000';
  static const d500000 = '500000';

  /// Precomputed dictionary mapping standardized string representations to their exact numeric values.
  static const Map<String, double> numericValues = {
    d1_16: 0.0625,
    d1_12: 1.0 / 12.0,
    d1_8: 0.125,
    d1_6: 1.0 / 6.0,
    d1_4: 0.25,
    d1_2: 0.5,
    d0_005: 0.005,
    d0_01: 0.01,
    d0_02: 0.02,
    d0_03: 0.03,
    d0_04: 0.04,
    d0_05: 0.05,
    d0_10: 0.1,
    d0_20: 0.2,
    d0_25: 0.25,
    d0_40: 0.4,
    d0_50: 0.5,
    d0_5: 0.5,
    d1: 1.0,
    d1s: 1.0,
    d2: 2.0,
    d2s: 2.0,
    d2_5: 2.5,
    d2_5s: 2.5,
    d2_1_2: 2.5,
    d3: 3.0,
    d4: 4.0,
    d5: 5.0,
    d5s: 5.0,
    d6: 6.0,
    d8: 8.0,
    d10: 10.0,
    d12: 12.0,
    d20: 20.0,
    d24: 24.0,
    d25: 25.0,
    d30: 30.0,
    d40: 40.0,
    d50: 50.0,
    d80: 80.0,
    d100: 100.0,
    d200: 200.0,
    d300: 300.0,
    d400: 400.0,
    d500: 500.0,
    d640: 640.0,
    d960: 960.0,
    d1000: 1000.0,
    d2000: 2000.0,
    d5000: 5000.0,
    d10000: 10000.0,
    d20000: 20000.0,
    d50000: 50000.0,
    d100000: 100000.0,
    d500000: 500000.0,
  };

  /// Complete canonical list of all supported standardized denominations.
  static const List<String> allDenominations = [
    d1_16,
    d1_12,
    d1_8,
    d1_6,
    d1_4,
    d1_2,
    d0_005,
    d0_01,
    d0_02,
    d0_03,
    d0_04,
    d0_05,
    d0_10,
    d0_20,
    d0_25,
    d0_40,
    d0_50,
    d0_5,
    d1,
    d1s,
    d2,
    d2s,
    d2_5,
    d2_5s,
    d2_1_2,
    d3,
    d4,
    d5,
    d5s,
    d6,
    d8,
    d10,
    d12,
    d20,
    d24,
    d25,
    d30,
    d40,
    d50,
    d80,
    d100,
    d200,
    d300,
    d400,
    d500,
    d640,
    d960,
    d1000,
    d2000,
    d5000,
    d10000,
    d20000,
    d50000,
    d100000,
    d500000,
  ];

  /// Resolves the numeric value of [val] using fast O(1) dictionary lookup,
  /// falling back to runtime parsing only for unmapped user-input strings.
  static double? parseNumber(String val) {
    final clean = val.trim();
    if (clean.isEmpty) return null;

    final precomputed = numericValues[clean];
    if (precomputed != null) return precomputed;

    final direct = double.tryParse(clean);
    if (direct != null) return direct;

    if (clean.contains('/')) {
      final parts = clean.split('/');
      if (parts.length == 2) {
        final num = double.tryParse(parts[0].trim());
        final den = double.tryParse(parts[1].trim());
        if (num != null && den != null && den != 0) {
          return num / den;
        }
      }
    }
    return null;
  }

  /// Fast O(1) denomination comparator.
  static bool matches(String d1, String d2) {
    if (identical(d1, d2) || d1 == d2) return true;
    final s1 = d1.trim();
    final s2 = d2.trim();
    if (s1.toLowerCase() == s2.toLowerCase()) return true;

    final num1 = parseNumber(s1);
    final num2 = parseNumber(s2);
    if (num1 != null && num2 != null) {
      return (num1 - num2).abs() < 0.0001;
    }
    return false;
  }

  /// Standard ordered list of common denominations for wheel pickers and chips.
  static const List<String> standardDisplayDenominations = [
    '1/4', '1/2', '1', '2', '2 1/2', '4', '5', '8', '10', '20', '25', '50', '100', '200', '500', '1000', '2000', '5000', 'Otro',
  ];
}
