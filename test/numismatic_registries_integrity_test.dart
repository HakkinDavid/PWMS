import 'package:flutter_test/flutter_test.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/numismatic_data_helper.dart';

void main() {
  group('NumismaticCurrenciesRegistry Tests', () {
    test('Currency map contains all registry currencies', () {
      expect(NumismaticDictionary.currencyMap[NumismaticCurrenciesRegistry.mxn], isNotNull);
      expect(NumismaticDictionary.currencyMap[NumismaticCurrenciesRegistry.usd], isNotNull);
      expect(NumismaticDictionary.currencyMap[NumismaticCurrenciesRegistry.eur], isNotNull);
      expect(NumismaticDictionary.currencyMap[NumismaticCurrenciesRegistry.real], isNotNull);
      expect(NumismaticDictionary.currencyMap[NumismaticCurrenciesRegistry.gbp], isNotNull);
      expect(NumismaticDictionary.currencyMap[NumismaticCurrenciesRegistry.esp], isNotNull);
    });

    test('All emission rules use valid currencies registered in NumismaticDictionary.currencyMap', () {
      for (final rule in NumismaticRulesRegistry.allRules) {
        for (final piece in rule.pieces) {
          expect(
            NumismaticDictionary.currencyMap.containsKey(piece.currency),
            isTrue,
            reason: 'Unknown currency ${piece.currency} in ${rule.country}',
          );
        }
      }
    });
  });

  group('NumismaticDenominationsRegistry Tests', () {
    test('Precomputed numeric values match fractions and decimals accurately', () {
      expect(NumismaticDenominationsRegistry.numericValues[NumismaticDenominationsRegistry.d1_16], 0.0625);
      expect(NumismaticDenominationsRegistry.numericValues[NumismaticDenominationsRegistry.d1_8], 0.125);
      expect(NumismaticDenominationsRegistry.numericValues[NumismaticDenominationsRegistry.d1_4], 0.25);
      expect(NumismaticDenominationsRegistry.numericValues[NumismaticDenominationsRegistry.d1_2], 0.5);
      expect(NumismaticDenominationsRegistry.numericValues[NumismaticDenominationsRegistry.d0_005], 0.005);
      expect(NumismaticDenominationsRegistry.numericValues[NumismaticDenominationsRegistry.d0_50], 0.5);
      expect(NumismaticDenominationsRegistry.numericValues[NumismaticDenominationsRegistry.d0_5], 0.5);
      expect(NumismaticDenominationsRegistry.numericValues[NumismaticDenominationsRegistry.d1], 1.0);
      expect(NumismaticDenominationsRegistry.numericValues[NumismaticDenominationsRegistry.d2_5], 2.5);
      expect(NumismaticDenominationsRegistry.numericValues[NumismaticDenominationsRegistry.d2_1_2], 2.5);
      expect(NumismaticDenominationsRegistry.numericValues[NumismaticDenominationsRegistry.d1000], 1000.0);
    });

    test('parseNumber resolves standard and non-standard strings', () {
      expect(NumismaticDenominationsRegistry.parseNumber(NumismaticDenominationsRegistry.d1_4), 0.25);
      expect(NumismaticDenominationsRegistry.parseNumber(NumismaticDenominationsRegistry.d0_50), 0.5);
      expect(NumismaticDenominationsRegistry.parseNumber('3/4'), 0.75);
      expect(NumismaticDenominationsRegistry.parseNumber('invalid'), isNull);
      expect(NumismaticDenominationsRegistry.parseNumber(''), isNull);
    });

    test('matches correctly equates fractional and decimal equivalents', () {
      expect(NumismaticDenominationsRegistry.matches(NumismaticDenominationsRegistry.d1_2, '0.5'), isTrue);
      expect(NumismaticDenominationsRegistry.matches(NumismaticDenominationsRegistry.d1_2, '0.50'), isTrue);
      expect(NumismaticDenominationsRegistry.matches(NumismaticDenominationsRegistry.d1_4, '0.25'), isTrue);
      expect(NumismaticDenominationsRegistry.matches(NumismaticDenominationsRegistry.d2_5, '2 1/2'), isTrue);
      expect(NumismaticDenominationsRegistry.matches(NumismaticDenominationsRegistry.d1, '1.0'), isTrue);
      expect(NumismaticDenominationsRegistry.matches('1', '2'), isFalse);
    });

    test('All emission rules use valid denominations in NumismaticDenominationsRegistry', () {
      for (final rule in NumismaticRulesRegistry.allRules) {
        for (final piece in rule.pieces) {
          expect(
            NumismaticDenominationsRegistry.numericValues.containsKey(piece.denomination),
            isTrue,
            reason: 'Denomination ${piece.denomination} in ${rule.country} not precomputed',
          );
        }
      }
    });
  });

  group('NumismaticCountriesRegistry Tests', () {
    test('Countries list contains primary sovereign countries and historical entities', () {
      expect(NumismaticCountriesRegistry.allCountries, contains(NumismaticCountriesRegistry.mexico));
      expect(NumismaticCountriesRegistry.allCountries, contains(NumismaticCountriesRegistry.virreinatoDeNuevaEspana));
      expect(NumismaticCountriesRegistry.allCountries, contains(NumismaticCountriesRegistry.estadosUnidos));
      expect(NumismaticCountriesRegistry.allCountries, contains(NumismaticCountriesRegistry.espana));
      expect(NumismaticCountriesRegistry.allCountries, contains(NumismaticCountriesRegistry.unionEuropea));
      expect(NumismaticCountriesRegistry.allCountries, contains(NumismaticCountriesRegistry.reinoUnido));
      expect(NumismaticCountriesRegistry.allCountries, contains(NumismaticCountriesRegistry.alemania));
      expect(NumismaticCountriesRegistry.allCountries, contains(NumismaticCountriesRegistry.francia));
      expect(NumismaticCountriesRegistry.allCountries, contains(NumismaticCountriesRegistry.italia));
      expect(NumismaticCountriesRegistry.allCountries, contains(NumismaticCountriesRegistry.canada));
      expect(NumismaticCountriesRegistry.allCountries, contains(NumismaticCountriesRegistry.guatemala));
      expect(NumismaticCountriesRegistry.allCountries, contains(NumismaticCountriesRegistry.cuba));
      expect(NumismaticCountriesRegistry.allCountries, contains(NumismaticCountriesRegistry.colombia));
      expect(NumismaticCountriesRegistry.allCountries, contains(NumismaticCountriesRegistry.peru));
      expect(NumismaticCountriesRegistry.allCountries, contains(NumismaticCountriesRegistry.brasil));
      expect(NumismaticCountriesRegistry.allCountries, contains(NumismaticCountriesRegistry.chile));
      expect(NumismaticCountriesRegistry.allCountries, contains(NumismaticCountriesRegistry.argentina));
    });

    test('All emission rules use valid countries from NumismaticCountriesRegistry', () {
      final validCountries = NumismaticCountriesRegistry.allCountries.toSet();
      for (final rule in NumismaticRulesRegistry.allRules) {
        expect(
          validCountries.contains(rule.country),
          isTrue,
          reason: 'Unknown country "${rule.country}" in emission rule',
        );
      }
    });
  });

  group('Numismatic Subsystem Connection & Facade Tests', () {
    test('NumismaticDictionary delegates countries, grades, and currencies to domain registries', () {
      expect(NumismaticDictionary.countries, equals(NumismaticCountriesRegistry.allCountries));
      expect(NumismaticDictionary.grades, equals(NumismaticGradesRegistry.allGrades));
      expect(NumismaticDictionary.currencyMap, equals(NumismaticCurrenciesRegistry.currencyMap));
    });

    test('NumismaticDataHelper re-exports all 6 domain registries', () {
      // Accessing registries to guarantee exports exist in NumismaticDataHelper scope
      expect(NumismaticCountriesRegistry.mexico, equals('México'));
      expect(NumismaticCurrenciesRegistry.mxn, equals('MXN'));
      expect(NumismaticDenominationsRegistry.d1, equals('1'));
      expect(NumismaticGradesRegistry.sinCircular, equals('Sin circular'));
      expect(NumismaticMaterialsRegistry.allDisplayNames, contains('Plata'));
      expect(NumismaticRulesRegistry.allRules, isNotEmpty);
    });

    test('isBanknote parameter in NumismaticDataHelper correctly filters currencies and denominations', () {
      final coinCurrencies = NumismaticDataHelper.getCurrenciesForCountry('México', isBanknote: false);
      final noteCurrencies = NumismaticDataHelper.getCurrenciesForCountry('México', isBanknote: true);
      expect(coinCurrencies, contains('MXN'));
      expect(noteCurrencies, contains('MXN'));

      final coinDenoms = NumismaticDataHelper.getDenominationsForCountry(country: 'México', isBanknote: false);
      final noteDenoms = NumismaticDataHelper.getDenominationsForCountry(country: 'México', isBanknote: true);
      expect(coinDenoms, isNotEmpty);
      expect(noteDenoms, isNotEmpty);
    });
  });
}

