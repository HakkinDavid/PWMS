import 'package:flutter_test/flutter_test.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/numismatics/numismatic_naming_engine.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/numismatics/numismatic_parser.dart';

void main() {
  group('Numismatic Currencies Parser and Resolution Fix Tests', () {
    test('AED (Emiratos Árabes Unidos) resolves and parses with full official title without truncation', () {
      // 1. Parsing single coin with full canonical name
      final parsed1 = NumismaticParser.parseSubspeciesName(
        '1 Dírham de los Emiratos Árabes Unidos - Emiratos Árabes Unidos (2014)',
      );
      expect(parsed1.faceValueNumber, equals(1.0));
      expect(parsed1.country, equals('Emiratos Árabes Unidos'));
      expect(parsed1.year, equals('2014'));
      expect(parsed1.currencyName, equals('Dírham de los Emiratos Árabes Unidos'));

      // 2. Parsing plural coins with full canonical name
      final parsed5 = NumismaticParser.parseSubspeciesName(
        '5 Dírhams de los Emiratos Árabes Unidos - Emiratos Árabes Unidos (2014)',
      );
      expect(parsed5.faceValueNumber, equals(5.0));
      expect(parsed5.currencyName, equals('Dírhams de los Emiratos Árabes Unidos'));

      // 3. Subspecies title directly
      final parsedSub = NumismaticParser.parseSubspeciesName(
        'Dírhams de los Emiratos Árabes Unidos',
      );
      expect(parsedSub.currencyName, equals('Dírhams de los Emiratos Árabes Unidos'));

      // 4. Legacy mention with abbreviation "los EAU" or "Dírhams de los EAU" resolves to canonical AED
      final parsedLegacy = NumismaticParser.parseSubspeciesName(
        '1 Dírham de los EAU - Emiratos Árabes Unidos (2014)',
      );
      expect(parsedLegacy.faceValueNumber, equals(1.0));
      expect(parsedLegacy.currencyName, equals('Dírham de los Emiratos Árabes Unidos'));

      // 5. ISO code resolution for AED variants
      expect(NumismaticParser.resolveCurrencyIsoCode('AED'), equals('AED'));
      expect(NumismaticParser.resolveCurrencyIsoCode('Dírhams de los Emiratos Árabes Unidos'), equals('AED'));
      expect(NumismaticParser.resolveCurrencyIsoCode('Dírham de los Emiratos Árabes Unidos'), equals('AED'));
      expect(NumismaticParser.resolveCurrencyIsoCode('Dírhams de los EAU'), equals('AED'));
      expect(NumismaticParser.resolveCurrencyIsoCode('los EAU'), equals('AED'));
      expect(NumismaticParser.resolveCurrencyIsoCode('EAU'), equals('AED'));
    });

    test('All world currencies containing "de / del" are never truncated to orphan country fragments', () {
      final testCases = <String, String>{
        '1 Dólar de Barbados - Barbados (1975)': 'Dólar de Barbados',
        '1 Lira de San Marino - San Marino (1980)': 'Lira de San Marino',
        '1 Libra de Gibraltar - Gibraltar (1990)': 'Libra de Gibraltar',
        '1 Dólar de Hong Kong - Hong Kong (1998)': 'Dólar de Hong Kong',
        '1 Dólar de Singapur - Singapur (2010)': 'Dólar de Singapur',
        '1 Dólar Continental de EE.UU. - Estados Unidos (1776)': 'Dólar Continental de EE.UU.',
        '1 Escudo Mexicano de Oro - México (1822)': 'Escudo Mexicano de Oro',
        '1 Tálero de María Teresa - Austria (1780)': 'Tálero de María Teresa',
        '1 Franco de Katanga - Katanga (1961)': 'Franco de Katanga',
        '1 Libra de Biafra - Biafra (1968)': 'Libra de Biafra',
        '1 Rupia de Sri Lanka - Sri Lanka (2000)': 'Rupia de Sri Lanka',
        '1 Kina de Papúa Nueva Guinea - Papúa Nueva Guinea (1975)': 'Kina de Papúa Nueva Guinea',
        '1 Rublo de Transnistria - Transnistria (2014)': 'Rublo de Transnistria',
      };

      for (final entry in testCases.entries) {
        final parsed = NumismaticParser.parseSubspeciesName(entry.key);
        expect(parsed.faceValueNumber, equals(1.0), reason: 'Failed for ${entry.key}');
        expect(parsed.currencyName, equals(entry.value), reason: 'Truncation detected for ${entry.key}');
      }
    });

    test('Traditional fractional subunits ("Centavos de...", "Céntimos de...") continue parsing accurately', () {
      final parsedMxp = NumismaticParser.parseSubspeciesName(
        '20 Centavos de Pesos Mexicanos Antiguos - México (1975) - Francisco I. Madero',
      );
      expect(parsedMxp.faceValueNumber, equals(0.20));
      expect(parsedMxp.country, equals('México'));
      expect(parsedMxp.year, equals('1975'));
      expect(parsedMxp.motif, equals('Francisco I. Madero'));
      expect(parsedMxp.currencyName, equals('Pesos Mexicanos Antiguos'));

      final parsedEur = NumismaticParser.parseSubspeciesName(
        '50 Céntimos de Euro - España (2002)',
      );
      expect(parsedEur.faceValueNumber, equals(0.50));
      expect(parsedEur.currencyName, equals('Euros'));

      final parsedUsd = NumismaticParser.parseSubspeciesName(
        '25 Centavos de Dólares Estadounidenses - Estados Unidos (2020)',
      );
      expect(parsedUsd.faceValueNumber, equals(0.25));
      expect(parsedUsd.currencyName, equals('Dólares Estadounidenses'));
    });

    test('NumismaticNamingEngine formats AED and currencies consistently', () {
      final name1 = NumismaticNamingEngine.formatDenominationWithFullCurrency(
        denomination: '1',
        currencyCode: 'AED',
      );
      expect(name1, equals('1 Dírham de los Emiratos Árabes Unidos'));

      final name5 = NumismaticNamingEngine.formatDenominationWithFullCurrency(
        denomination: '5',
        currencyCode: 'AED',
      );
      expect(name5, equals('5 Dírhams de los Emiratos Árabes Unidos'));

      final label1 = NumismaticNamingEngine.formatDenominationLabel(
        denomination: '1',
        currencyCode: 'AED',
      );
      expect(label1, equals('1 Dírham'));

      final label5 = NumismaticNamingEngine.formatDenominationLabel(
        denomination: '5',
        currencyCode: 'AED',
      );
      expect(label5, equals('5 Dírhams'));
    });
  });
}
