import 'package:flutter_test/flutter_test.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/numismatic_data_helper.dart';

void main() {
  group('Modular Numismatics (Dictionary, Parser, Domain Rules & Facade) Tests', () {
    test('NumismaticDictionary contains canonical currencies and country mappings', () {
      expect(NumismaticDictionary.currencyMap['MXN'], 'Pesos Mexicanos');
      expect(NumismaticDictionary.currencyMap['USD'], 'Dólares Estadounidenses');
      expect(NumismaticDictionary.currencyMap['EUR'], 'Euros');
      expect(NumismaticDictionary.currencyMap['REAL'], 'Reales Españoles');
      expect(NumismaticDictionary.currencyMap['GTH'], 'Táleros Germánicos (Thaler)');
      expect(NumismaticDictionary.currencyMap['IND_MUG'], 'Mohurs y Rupias del Imperio Mogol');

      final mxCurrencies = NumismaticDictionary.getCurrenciesForCountry('México');
      expect(mxCurrencies, containsAll(['MXN', 'MXP', 'MXR', 'MXE']));

      final nuevaEspanaCurrencies = NumismaticDictionary.getCurrenciesForCountry('Virreinato de Nueva España');
      expect(nuevaEspanaCurrencies, containsAll(['REAL', 'ESC', 'MRV', 'MXR', 'MXE']));

      final sacroImperioCurrencies = NumismaticDictionary.getCurrenciesForCountry('Sacro Imperio Romano Germánico');
      expect(sacroImperioCurrencies, containsAll(['GTH', 'GGL', 'ATH', 'ATG']));
    });

    test('NumismaticParser resolves ISO codes and singular/plural names', () {
      expect(NumismaticParser.resolveCurrencyIsoCode('Pesos Mexicanos'), 'MXN');
      expect(NumismaticParser.resolveCurrencyIsoCode('dólares estadounidenses'), 'USD');
      expect(NumismaticParser.resolveCurrencyIsoCode('EUR'), 'EUR');
      expect(NumismaticParser.resolveCurrencyIsoCode('Reales Españoles'), 'REAL');
      expect(NumismaticParser.resolveCurrencyIsoCode('Táleros Germánicos (Thaler)'), 'GTH');
      expect(NumismaticParser.resolveCurrencyIsoCode('Francos Franceses'), 'FRF');
      expect(NumismaticParser.resolveCurrencyIsoCode('Franco Francés'), 'FRF');
      expect(NumismaticParser.resolveCurrencyIsoCode('franco frances'), 'FRF');
      expect(NumismaticParser.resolveCurrencyIsoCode('Libra Esterlina'), 'GBP');
      expect(NumismaticParser.resolveCurrencyIsoCode('Libras Esterlinas'), 'GBP');
      expect(NumismaticParser.resolveCurrencyIsoCode('Marco Alemán'), 'DEM');
      expect(NumismaticParser.resolveCurrencyIsoCode('Marcos Alemanes'), 'DEM');
      expect(NumismaticParser.resolveCurrencyIsoCode('Lira Italiana'), 'ITL');
      expect(NumismaticParser.resolveCurrencyIsoCode('Liras Italianas'), 'ITL');

      expect(NumismaticParser.resolveCurrencyName('MXN', count: 1), 'Peso Mexicano');
      expect(NumismaticParser.resolveCurrencyName('MXN', count: 5), 'Pesos Mexicanos');
      expect(NumismaticParser.resolveCurrencyName('USD', count: 1), 'Dólar Estadounidense');
      expect(NumismaticParser.resolveCurrencyName('USD', count: 20), 'Dólares Estadounidenses');
      expect(NumismaticParser.resolveCurrencyName('REAL', count: 1), 'Real Español');
      expect(NumismaticParser.resolveCurrencyName('REAL', count: 8), 'Reales Españoles');
      expect(NumismaticParser.resolveCurrencyName('GTH', count: 1), 'Tálero Germánico (Thaler)');
      expect(NumismaticParser.resolveCurrencyName('GTH', count: 2), 'Táleros Germánicos (Thaler)');
      expect(NumismaticParser.resolveCurrencyName('FRF', count: 1), 'Franco Francés');
      expect(NumismaticParser.resolveCurrencyName('FRF', count: 5), 'Francos Franceses');
      expect(NumismaticParser.resolveCurrencyName('Franco Francés'), 'Francos Franceses');
      expect(NumismaticParser.resolveCurrencyName('franco frances'), 'Francos Franceses');

      expect(NumismaticParser.areCurrenciesEquivalent('FRF', 'Franco Francés'), isTrue);
      expect(NumismaticParser.areCurrenciesEquivalent('FRF', 'Francos Franceses'), isTrue);
      expect(NumismaticParser.areCurrenciesEquivalent('FRF', 'franco frances'), isTrue);
      expect(NumismaticParser.areCurrenciesEquivalent('Franco Francés', 'Francos Franceses'), isTrue);
    });

    test('NumismaticParser standardizes grades, materials, and builds titles', () {
      expect(NumismaticParser.resolveGrade('UNC / Sin Circular'), 'Sin circular');
      expect(NumismaticParser.resolveGrade('EBC'), 'Excelente');
      expect(NumismaticParser.resolveGrade('VF'), 'Muy buena');

      expect(NumismaticParser.resolveMaterial('cu-ni'), 'Cuproníquel');
      expect(NumismaticParser.resolveMaterial('Silver'), 'Plata');
      expect(NumismaticParser.resolveMaterial('Gold'), 'Oro');
      expect(NumismaticParser.resolveMaterial('electrum'), 'Electro (Electrum)');
      expect(NumismaticParser.resolveMaterial('billon'), 'Billón (Vellón)');
      expect(NumismaticParser.resolveMaterial('german silver'), 'Alpaca (Plata alemana)');
      expect(NumismaticParser.resolveMaterial('nordic gold'), 'Oro nórdico');
      expect(NumismaticParser.resolveMaterial('porcelain'), 'Porcelana');

      final title = NumismaticParser.buildSubspeciesName(
        faceValueNumber: 10,
        currencyCode: 'MXN',
        country: 'México',
        year: '2021',
      );
      expect(title, '10 Pesos Mexicanos - México (2021)');

      final realTitle = NumismaticParser.buildSubspeciesName(
        faceValueNumber: 8,
        currencyCode: 'REAL',
        country: 'Virreinato de Nueva España',
        year: '1735',
      );
      expect(realTitle, '8 Reales Españoles - Virreinato de Nueva España (1735)');
    });

    test('NumismaticParser parses subspecies title accurately', () {
      final parsed = NumismaticParser.parseSubspeciesName('5 Pesos Mexicanos - México (1985)');
      expect(parsed.faceValueNumber, 5.0);
      expect(parsed.currencyName, 'Pesos Mexicanos');
      expect(parsed.country, 'México');
      expect(parsed.year, '1985');

      final parsedColonial = NumismaticParser.parseSubspeciesName('8 Reales Españoles - Virreinato de Nueva España (1780)');
      expect(parsedColonial.faceValueNumber, 8.0);
      expect(parsedColonial.currencyName, 'Reales Españoles');
      expect(parsedColonial.country, 'Virreinato de Nueva España');
      expect(parsedColonial.year, '1780');
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
      expect(NumismaticDataHelper.buildSubspeciesName(
        faceValueNumber: 1,
        currencyCode: 'REAL',
        country: 'Corona de Castilla',
        year: '1556',
      ), '1 Real Español - Corona de Castilla (1556)');
    });
  });
}
