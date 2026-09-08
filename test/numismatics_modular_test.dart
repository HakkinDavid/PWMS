import 'package:flutter_test/flutter_test.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/numismatic_data_helper.dart';
import 'package:platinum_world_management_system/src/features/entities/domain/world_entity.dart';
import 'package:platinum_world_management_system/src/features/entities/domain/instance_magnitude.dart';

import 'package:platinum_world_management_system/src/features/catalog/domain/catalog_item.dart';

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
      expect(realTitle, 'Real de a 8 de Reales Españoles - Virreinato de Nueva España (1735)');
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

    test('checkEmissionOutliers accepts valid Mexico 1992 MXN 2 Nuevos Pesos without currency or denomination outliers', () {
      final now = DateTime.now();
      final entity = WorldEntity(
        id: 'inst-mxn-1992',
        speciesId: 'sp-coin',
        createdAt: now,
        updatedAt: now,
        magnitudes: const [
          InstanceMagnitude(id: 'm1', instanceId: 'inst-mxn-1992', propertyName: 'País', dataType: 'string', stringValue: 'México'),
          InstanceMagnitude(id: 'm2', instanceId: 'inst-mxn-1992', propertyName: 'Acuñación', dataType: 'integer', magnitudeValue: 1992.0, unitSymbol: 'año'),
          InstanceMagnitude(id: 'm3', instanceId: 'inst-mxn-1992', propertyName: 'Divisa', dataType: 'string', stringValue: 'MXN'),
          InstanceMagnitude(id: 'm4', instanceId: 'inst-mxn-1992', propertyName: 'Valor nominal', dataType: 'real', magnitudeValue: 2.0),
          InstanceMagnitude(id: 'm5', instanceId: 'inst-mxn-1992', propertyName: 'Material', dataType: 'string', stringValue: 'Bimetálica'),
        ],
      );

      final outliers = NumismaticDomainRules.checkEmissionOutliers(instance: entity);
      expect(outliers, isEmpty);
    });

    test('checkEmissionOutliers accepts standard circulating Brasil 2017 1 Real without motif mismatch', () {
      final now = DateTime.now();
      final entity = WorldEntity(
        id: 'inst-brl-2017',
        speciesId: 'sp-coin',
        createdAt: now,
        updatedAt: now,
        magnitudes: const [
          InstanceMagnitude(id: 'm1', instanceId: 'inst-brl-2017', propertyName: 'País', dataType: 'string', stringValue: 'Brasil'),
          InstanceMagnitude(id: 'm2', instanceId: 'inst-brl-2017', propertyName: 'Acuñación', dataType: 'integer', magnitudeValue: 2017.0, unitSymbol: 'año'),
          InstanceMagnitude(id: 'm3', instanceId: 'inst-brl-2017', propertyName: 'Divisa', dataType: 'string', stringValue: 'BRL'),
          InstanceMagnitude(id: 'm4', instanceId: 'inst-brl-2017', propertyName: 'Valor nominal', dataType: 'real', magnitudeValue: 1.0),
          InstanceMagnitude(id: 'm5', instanceId: 'inst-brl-2017', propertyName: 'Material', dataType: 'string', stringValue: 'Bimetálica'),
        ],
      );

      final outliers = NumismaticDomainRules.checkEmissionOutliers(instance: entity);
      expect(outliers, isEmpty);
    });

    test('checkEmissionOutliers accepts 10c and 50c 1992 Mexico MXN coins without denomination or currency outliers', () {
      final now = DateTime.now();

      // 10 centavos 1992 N$ (stored as magnitudeValue: 0.1)
      final coin10c = WorldEntity(
        id: 'inst-mxn-10c-1992',
        speciesId: 'sp-coin',
        createdAt: now,
        updatedAt: now,
        magnitudes: const [
          InstanceMagnitude(id: 'm1', instanceId: 'inst-mxn-10c-1992', propertyName: 'País', dataType: 'string', stringValue: 'México'),
          InstanceMagnitude(id: 'm2', instanceId: 'inst-mxn-10c-1992', propertyName: 'Acuñación', dataType: 'integer', magnitudeValue: 1992.0, unitSymbol: 'año'),
          InstanceMagnitude(id: 'm3', instanceId: 'inst-mxn-10c-1992', propertyName: 'Divisa', dataType: 'string', stringValue: 'MXN'),
          InstanceMagnitude(id: 'm4', instanceId: 'inst-mxn-10c-1992', propertyName: 'Valor nominal', dataType: 'real', magnitudeValue: 0.1),
          InstanceMagnitude(id: 'm5', instanceId: 'inst-mxn-10c-1992', propertyName: 'Material', dataType: 'string', stringValue: 'Acero inoxidable'),
        ],
      );
      expect(NumismaticDomainRules.checkEmissionOutliers(instance: coin10c), isEmpty);

      // 50 centavos 1992 N$ (stored as magnitudeValue: 0.5)
      final coin50c = WorldEntity(
        id: 'inst-mxn-50c-1992',
        speciesId: 'sp-coin',
        createdAt: now,
        updatedAt: now,
        magnitudes: const [
          InstanceMagnitude(id: 'm1', instanceId: 'inst-mxn-50c-1992', propertyName: 'País', dataType: 'string', stringValue: 'México'),
          InstanceMagnitude(id: 'm2', instanceId: 'inst-mxn-50c-1992', propertyName: 'Acuñación', dataType: 'integer', magnitudeValue: 1992.0, unitSymbol: 'año'),
          InstanceMagnitude(id: 'm3', instanceId: 'inst-mxn-50c-1992', propertyName: 'Divisa', dataType: 'string', stringValue: 'MXN'),
          InstanceMagnitude(id: 'm4', instanceId: 'inst-mxn-50c-1992', propertyName: 'Valor nominal', dataType: 'real', magnitudeValue: 0.5),
          InstanceMagnitude(id: 'm5', instanceId: 'inst-mxn-50c-1992', propertyName: 'Material', dataType: 'string', stringValue: 'Bronce de aluminio'),
        ],
      );
      expect(NumismaticDomainRules.checkEmissionOutliers(instance: coin50c), isEmpty);
    });

    test('checkEmissionOutliers evaluates Banknotes (Notafilia) accurately without coin false positives', () {
      final now = DateTime.now();

      // Banknote species item (Billete)
      final banknoteSpecies = CatalogItem(
        id: 'sp-banknote',
        name: 'Billete',
        type: 'Objeto',
        createdAt: now,
      );

      // Mexico 2020 $100 Banknote (Sor Juana Inés de la Cruz - Polímero)
      final note100Mex2020 = WorldEntity(
        id: 'inst-note-100-2020',
        speciesId: 'sp-banknote',
        createdAt: now,
        updatedAt: now,
        magnitudes: const [
          InstanceMagnitude(id: 'm1', instanceId: 'inst-note-100-2020', propertyName: 'País', dataType: 'string', stringValue: 'México'),
          InstanceMagnitude(id: 'm2', instanceId: 'inst-note-100-2020', propertyName: 'Acuñación', dataType: 'integer', magnitudeValue: 2020.0, unitSymbol: 'año'),
          InstanceMagnitude(id: 'm3', instanceId: 'inst-note-100-2020', propertyName: 'Divisa', dataType: 'string', stringValue: 'MXN'),
          InstanceMagnitude(id: 'm4', instanceId: 'inst-note-100-2020', propertyName: 'Valor nominal', dataType: 'real', magnitudeValue: 100.0),
          InstanceMagnitude(id: 'm5', instanceId: 'inst-note-100-2020', propertyName: 'Material', dataType: 'string', stringValue: 'Polímero'),
        ],
      );
      expect(
        NumismaticDomainRules.checkEmissionOutliers(instance: note100Mex2020, species: banknoteSpecies),
        isEmpty,
      );

      // Mexico 2021 $20 Banknote (Bicentenario de la Independencia - Polímero)
      final note20Mex2021 = WorldEntity(
        id: 'inst-note-20-2021',
        speciesId: 'sp-banknote',
        createdAt: now,
        updatedAt: now,
        magnitudes: const [
          InstanceMagnitude(id: 'm1', instanceId: 'inst-note-20-2021', propertyName: 'País', dataType: 'string', stringValue: 'México'),
          InstanceMagnitude(id: 'm2', instanceId: 'inst-note-20-2021', propertyName: 'Acuñación', dataType: 'integer', magnitudeValue: 2021.0, unitSymbol: 'año'),
          InstanceMagnitude(id: 'm3', instanceId: 'inst-note-20-2021', propertyName: 'Divisa', dataType: 'string', stringValue: 'MXN'),
          InstanceMagnitude(id: 'm4', instanceId: 'inst-note-20-2021', propertyName: 'Valor nominal', dataType: 'real', magnitudeValue: 20.0),
          InstanceMagnitude(id: 'm5', instanceId: 'inst-note-20-2021', propertyName: 'Material', dataType: 'string', stringValue: 'Polímero'),
        ],
      );
      expect(
        NumismaticDomainRules.checkEmissionOutliers(instance: note20Mex2021, species: banknoteSpecies),
        isEmpty,
      );

      // Mexico 1978 $100 Banknote (Familia AA - Papel de algodón)
      final note100Mex1978 = WorldEntity(
        id: 'inst-note-100-1978',
        speciesId: 'sp-banknote',
        createdAt: now,
        updatedAt: now,
        magnitudes: const [
          InstanceMagnitude(id: 'm1', instanceId: 'inst-note-100-1978', propertyName: 'País', dataType: 'string', stringValue: 'México'),
          InstanceMagnitude(id: 'm2', instanceId: 'inst-note-100-1978', propertyName: 'Acuñación', dataType: 'integer', magnitudeValue: 1978.0, unitSymbol: 'año'),
          InstanceMagnitude(id: 'm3', instanceId: 'inst-note-100-1978', propertyName: 'Divisa', dataType: 'string', stringValue: 'MXP'),
          InstanceMagnitude(id: 'm4', instanceId: 'inst-note-100-1978', propertyName: 'Valor nominal', dataType: 'real', magnitudeValue: 100.0),
          InstanceMagnitude(id: 'm5', instanceId: 'inst-note-100-1978', propertyName: 'Material', dataType: 'string', stringValue: 'Papel de algodón'),
        ],
      );
      expect(
        NumismaticDomainRules.checkEmissionOutliers(instance: note100Mex1978, species: banknoteSpecies),
        isEmpty,
      );

      // US 2013 $100 Banknote (Federal Reserve Note - Papel de algodón)
      final note100Us2013 = WorldEntity(
        id: 'inst-note-100-us-2013',
        speciesId: 'sp-banknote',
        createdAt: now,
        updatedAt: now,
        magnitudes: const [
          InstanceMagnitude(id: 'm1', instanceId: 'inst-note-100-us-2013', propertyName: 'País', dataType: 'string', stringValue: 'Estados Unidos'),
          InstanceMagnitude(id: 'm2', instanceId: 'inst-note-100-us-2013', propertyName: 'Acuñación', dataType: 'integer', magnitudeValue: 2013.0, unitSymbol: 'año'),
          InstanceMagnitude(id: 'm3', instanceId: 'inst-note-100-us-2013', propertyName: 'Divisa', dataType: 'string', stringValue: 'USD'),
          InstanceMagnitude(id: 'm4', instanceId: 'inst-note-100-us-2013', propertyName: 'Valor nominal', dataType: 'real', magnitudeValue: 100.0),
          InstanceMagnitude(id: 'm5', instanceId: 'inst-note-100-us-2013', propertyName: 'Material', dataType: 'string', stringValue: 'Papel de algodón'),
        ],
      );
      expect(
        NumismaticDomainRules.checkEmissionOutliers(instance: note100Us2013, species: banknoteSpecies),
        isEmpty,
      );
    });

    test('NumismaticParser and DomainRules accurately identify piece type (isBanknotePiece vs isCoinPiece)', () {
      final now = DateTime.now();
      final coinSpecies = CatalogItem(id: 'sp1', name: 'Moneda', type: 'Objeto', createdAt: now);
      final banknoteSpecies = CatalogItem(id: 'sp2', name: 'Billete', type: 'Objeto', createdAt: now);

      expect(NumismaticParser.isCoinSpecies(coinSpecies), isTrue);
      expect(NumismaticParser.isCoinSpecies(banknoteSpecies), isFalse);

      expect(NumismaticParser.isBanknotePiece(species: banknoteSpecies), isTrue);
      expect(NumismaticParser.isBanknotePiece(species: coinSpecies), isFalse);

      expect(NumismaticParser.isBanknotePiece(material: 'Polímero'), isTrue);
      expect(NumismaticParser.isBanknotePiece(material: 'Papel de algodón'), isTrue);
      expect(NumismaticParser.isBanknotePiece(material: 'Plata'), isFalse);
    });
  });
}
