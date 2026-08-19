import 'package:flutter_test/flutter_test.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/numismatic_data_helper.dart';

void main() {
  group('Modular Numismatics (Dictionary, Parser, Domain Rules & Facade) Tests', () {
    test('NumismaticDictionary contains canonical currencies and country mappings', () {
      expect(NumismaticDictionary.currencyMap['MXN'], 'Pesos Mexicanos');
      expect(NumismaticDictionary.currencyMap['USD'], 'Dólares Estadounidenses');
      expect(NumismaticDictionary.currencyMap['EUR'], 'Euros');

      final mxCurrencies = NumismaticDictionary.getCurrenciesForCountry('México');
      expect(mxCurrencies, contains('MXN'));
      expect(mxCurrencies, contains('MXP'));
    });

    test('NumismaticParser resolves ISO codes and singular/plural names', () {
      expect(NumismaticParser.resolveCurrencyIsoCode('Pesos Mexicanos'), 'MXN');
      expect(NumismaticParser.resolveCurrencyIsoCode('dólares estadounidenses'), 'USD');
      expect(NumismaticParser.resolveCurrencyIsoCode('EUR'), 'EUR');

      expect(NumismaticParser.resolveCurrencyName('MXN', count: 1), 'Peso Mexicano');
      expect(NumismaticParser.resolveCurrencyName('MXN', count: 5), 'Pesos Mexicanos');
      expect(NumismaticParser.resolveCurrencyName('USD', count: 1), 'Dólar Estadounidense');
      expect(NumismaticParser.resolveCurrencyName('USD', count: 20), 'Dólares Estadounidenses');
    });

    test('NumismaticParser standardizes grades, materials, and builds titles', () {
      expect(NumismaticParser.resolveGrade('UNC / Sin Circular'), 'Sin circular');
      expect(NumismaticParser.resolveGrade('EBC'), 'Excelente');
      expect(NumismaticParser.resolveGrade('VF'), 'Muy buena');

      expect(NumismaticParser.resolveMaterial('cu-ni'), 'Cuproníquel');
      expect(NumismaticParser.resolveMaterial('Silver'), 'Plata');
      expect(NumismaticParser.resolveMaterial('Gold'), 'Oro');

      final title = NumismaticParser.buildSubspeciesName(
        faceValueNumber: 10,
        currencyCode: 'MXN',
        country: 'México',
        year: '2021',
      );
      expect(title, '10 Pesos Mexicanos - México (2021)');
    });

    test('NumismaticParser parses subspecies title accurately', () {
      final parsed = NumismaticParser.parseSubspeciesName('5 Pesos Mexicanos - México (1985)');
      expect(parsed.faceValueNumber, 5.0);
      expect(parsed.currencyName, 'Pesos Mexicanos');
      expect(parsed.country, 'México');
      expect(parsed.year, '1985');
    });

    test('NumismaticDataHelper Facade delegates transparently', () {
      expect(NumismaticDataHelper.resolveCurrencyIsoCode('MXN'), 'MXN');
      expect(NumismaticDataHelper.resolveGrade('FDC'), 'Sin circular');
      expect(NumismaticDataHelper.buildSubspeciesName(
        faceValueNumber: 1,
        currencyCode: 'USD',
        country: 'Estados Unidos',
        year: '1921',
      ), '1 Dólar Estadounidense - Estados Unidos (1921)');
    });
  });
}
