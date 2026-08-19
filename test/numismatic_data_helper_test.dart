import 'package:flutter_test/flutter_test.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/catalog_item.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/numismatic_data_helper.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/subspecies.dart';
import 'package:platinum_world_management_system/src/features/entities/domain/instance_magnitude.dart';
import 'package:platinum_world_management_system/src/features/entities/domain/world_entity.dart';

void main() {
  group('NumismaticDataHelper Unit Tests', () {
    test('isNumismaticSpecies identifies Moneda and Billete correctly', () {
      final moneda = CatalogItem(
        id: '1',
        name: 'Moneda',
        type: 'Objeto',
        createdAt: DateTime.now(),
      );
      final billete = CatalogItem(
        id: '2',
        name: 'Billete',
        type: 'Objeto',
        createdAt: DateTime.now(),
      );
      final laptop = CatalogItem(
        id: '3',
        name: 'Computadora',
        type: 'Objeto',
        createdAt: DateTime.now(),
      );

      expect(NumismaticDataHelper.isNumismaticSpecies(moneda), isTrue);
      expect(NumismaticDataHelper.isNumismaticSpecies(billete), isTrue);
      expect(NumismaticDataHelper.isNumismaticSpecies(laptop), isFalse);
    });

    test('buildSubspeciesName builds deterministic title with and without year', () {
      final titleWithYear = NumismaticDataHelper.buildSubspeciesName(
        faceValueNumber: 5,
        currencyName: 'Pesos Mexicanos',
        country: 'México',
        year: '2022',
      );
      expect(titleWithYear, equals('5 Pesos Mexicanos - México (2022)'));

      final titleWithoutYear = NumismaticDataHelper.buildSubspeciesName(
        faceValueNumber: 10,
        currencyName: 'Dólares US',
        country: 'Estados Unidos',
        year: null,
      );
      expect(titleWithoutYear, equals('10 Dólares US - Estados Unidos'));
    });

    test('buildSubspeciesNotes builds formatted notes string', () {
      final notes = NumismaticDataHelper.buildSubspeciesNotes(
        currencyName: 'Pesos Mexicanos',
        year: '2022',
        composition: 'Cuproníquel',
      );
      expect(notes, equals('Moneda: Pesos Mexicanos | Año: 2022 | Material: Cuproníquel'));
    });

    test('buildAttachmentFileName formats anverso and reverso names', () {
      final obverseName = NumismaticDataHelper.buildAttachmentFileName(
        subspeciesName: '5 Pesos Mexicanos - México (2022)',
        instanceId: 'inst-123',
        side: 'anverso',
        extension: 'png',
      );
      expect(obverseName, equals('5 Pesos Mexicanos - México (2022) (inst-123) (anverso).png'));
    });

    test('parseSubspeciesName extracts title components accurately', () {
      final parsed = NumismaticDataHelper.parseSubspeciesName('5 Pesos Mexicanos - México (2022)');
      expect(parsed.faceValueNumber, equals(5.0));
      expect(parsed.currencyName, equals('Pesos Mexicanos'));
      expect(parsed.country, equals('México'));
      expect(parsed.year, equals('2022'));
    });

    test('checkInstanceSubspeciesCongruence detects mismatches between subspecies and instance', () {
      final sub = Subspecies(
        id: 'sub-1',
        speciesId: 'sp-1',
        subspeciesName: '5 Pesos Mexicanos - México (2020)',
        createdAt: DateTime.now(),
      );

      final instanceConforming = WorldEntity(
        id: 'inst-1',
        speciesId: 'sp-1',
        subspeciesId: 'sub-1',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        magnitudes: const [
          InstanceMagnitude(id: 'm1', instanceId: 'inst-1', propertyName: 'Valor nominal', dataType: 'real', magnitudeValue: 5.0),
          InstanceMagnitude(id: 'm2', instanceId: 'inst-1', propertyName: 'Acuñación', dataType: 'integer', magnitudeValue: 2020.0, unitSymbol: 'año'),
          InstanceMagnitude(id: 'm3', instanceId: 'inst-1', propertyName: 'Divisa', dataType: 'string', stringValue: 'MXN'),
        ],
      );

      expect(NumismaticDataHelper.checkInstanceSubspeciesCongruence(subspecies: sub, instance: instanceConforming), isNull);

      final instanceMismatchYear = WorldEntity(
        id: 'inst-2',
        speciesId: 'sp-1',
        subspeciesId: 'sub-1',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        magnitudes: const [
          InstanceMagnitude(id: 'm1', instanceId: 'inst-2', propertyName: 'Valor nominal', dataType: 'real', magnitudeValue: 5.0),
          InstanceMagnitude(id: 'm2', instanceId: 'inst-2', propertyName: 'Acuñación', dataType: 'integer', magnitudeValue: 2024.0, unitSymbol: 'año'),
          InstanceMagnitude(id: 'm3', instanceId: 'inst-2', propertyName: 'Divisa', dataType: 'string', stringValue: 'MXN'),
        ],
      );

      final issue = NumismaticDataHelper.checkInstanceSubspeciesCongruence(subspecies: sub, instance: instanceMismatchYear);
      expect(issue, isNotNull);
      expect(issue, contains('Año'));
    });

    test('areCurrenciesEquivalent matches codes, full names, and plurals robustly', () {
      expect(NumismaticDataHelper.areCurrenciesEquivalent('MXN', 'Peso Mexicano'), isTrue);
      expect(NumismaticDataHelper.areCurrenciesEquivalent('Pesos Mexicanos', 'Peso Mexicano'), isTrue);
      expect(NumismaticDataHelper.areCurrenciesEquivalent('USD', 'Dólar Estadounidense'), isTrue);
      expect(NumismaticDataHelper.areCurrenciesEquivalent('Dólares Estadounidenses', 'Dólar Estadounidense'), isTrue);
      expect(NumismaticDataHelper.areCurrenciesEquivalent('MXN', 'USD'), isFalse);
    });

    test('checkInstanceSubspeciesCongruence requires ISO code for instance currency magnitude', () {
      final sub = Subspecies(
        id: 'sub-1',
        speciesId: 'sp-1',
        subspeciesName: '5 Pesos Mexicanos - México (2022)',
        createdAt: DateTime.now(),
      );

      final instanceWithIsoCode = WorldEntity(
        id: 'inst-1',
        speciesId: 'sp-1',
        subspeciesId: 'sub-1',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        magnitudes: const [
          InstanceMagnitude(id: 'm1', instanceId: 'inst-1', propertyName: 'Valor nominal', dataType: 'real', magnitudeValue: 5.0),
          InstanceMagnitude(id: 'm2', instanceId: 'inst-1', propertyName: 'Acuñación', dataType: 'integer', magnitudeValue: 2022.0, unitSymbol: 'año'),
          InstanceMagnitude(id: 'm3', instanceId: 'inst-1', propertyName: 'Divisa', dataType: 'string', stringValue: 'MXN'),
        ],
      );

      expect(NumismaticDataHelper.checkInstanceSubspeciesCongruence(subspecies: sub, instance: instanceWithIsoCode), isNull);

      final instanceWithFullName = WorldEntity(
        id: 'inst-2',
        speciesId: 'sp-1',
        subspeciesId: 'sub-1',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        magnitudes: const [
          InstanceMagnitude(id: 'm1', instanceId: 'inst-2', propertyName: 'Valor nominal', dataType: 'real', magnitudeValue: 5.0),
          InstanceMagnitude(id: 'm2', instanceId: 'inst-2', propertyName: 'Acuñación', dataType: 'integer', magnitudeValue: 2022.0, unitSymbol: 'año'),
          InstanceMagnitude(id: 'm3', instanceId: 'inst-2', propertyName: 'Divisa', dataType: 'string', stringValue: 'Pesos Mexicanos'),
        ],
      );

      final issue = NumismaticDataHelper.checkInstanceSubspeciesCongruence(subspecies: sub, instance: instanceWithFullName);
      expect(issue, isNotNull);
      expect(issue, contains('Divisa de instancia no es código ISO'));
    });

    test('resolveGrade, resolveMaterial, and resolveSpecialEditionReason map to canonical lists', () {
      expect(NumismaticDataHelper.resolveGrade('UNC'), equals('Sin circular'));
      expect(NumismaticDataHelper.resolveGrade('VF'), equals('Muy buena'));

      expect(NumismaticDataHelper.resolveMaterial('cu-ni'), equals('Cuproníquel'));
      expect(NumismaticDataHelper.resolveMaterial('silver'), equals('Plata'));

      expect(NumismaticDataHelper.resolveSpecialEditionReason('commemorative'), equals('Conmemorativa'));
      expect(NumismaticDataHelper.resolveSpecialEditionReason('proof'), equals('Prueba de acuñación'));
    });

    test('checkInstanceSubspeciesCongruence detects non-standard grade or material', () {
      final sub = Subspecies(
        id: 'sub-1',
        speciesId: 'sp-1',
        subspeciesName: '5 Pesos Mexicanos - México (2022)',
        createdAt: DateTime.now(),
      );

      final instanceNonStandardGrade = WorldEntity(
        id: 'inst-1',
        speciesId: 'sp-1',
        subspeciesId: 'sub-1',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        magnitudes: const [
          InstanceMagnitude(id: 'm1', instanceId: 'inst-1', propertyName: 'Valor nominal', dataType: 'real', magnitudeValue: 5.0),
          InstanceMagnitude(id: 'm2', instanceId: 'inst-1', propertyName: 'Acuñación', dataType: 'integer', magnitudeValue: 2022.0, unitSymbol: 'año'),
          InstanceMagnitude(id: 'm3', instanceId: 'inst-1', propertyName: 'Divisa', dataType: 'string', stringValue: 'Pesos Mexicanos'),
          InstanceMagnitude(id: 'm4', instanceId: 'inst-1', propertyName: 'Grado', dataType: 'string', stringValue: 'VF'),
        ],
      );

      final issue = NumismaticDataHelper.checkInstanceSubspeciesCongruence(subspecies: sub, instance: instanceNonStandardGrade);
      expect(issue, isNotNull);
      expect(issue, contains('Grado de conservación no estandarizado'));
    });

    test('findDuplicateSubspeciesGroups finds duplicate subspecies titles', () {
      final list = [
        Subspecies(id: 's1', speciesId: 'sp1', subspeciesName: '5 Pesos Mexicanos - México (2022)', createdAt: DateTime.now()),
        Subspecies(id: 's2', speciesId: 'sp1', subspeciesName: '5 Pesos Mexicanos - México (2022)', createdAt: DateTime.now()),
        Subspecies(id: 's3', speciesId: 'sp1', subspeciesName: '10 Pesos Mexicanos - México (2020)', createdAt: DateTime.now()),
      ];
      final dups = NumismaticDataHelper.findDuplicateSubspeciesGroups(list);
      expect(dups.length, equals(1));
      expect(dups.values.first.length, equals(2));
    });

    test('getCurrenciesForCountry filters currencies by country correctly', () {
      final mexicoCurrencies = NumismaticDataHelper.getCurrenciesForCountry('México');
      expect(mexicoCurrencies, containsAll(['MXN', 'MXP']));
      expect(mexicoCurrencies.length, equals(2));

      final usaCurrencies = NumismaticDataHelper.getCurrenciesForCountry('Estados Unidos');
      expect(usaCurrencies, equals(['USD']));

      final spainCurrencies = NumismaticDataHelper.getCurrenciesForCountry('España');
      expect(spainCurrencies, containsAll(['EUR', 'ESP']));

      // Null, empty, or 'Otro' should return all currencies
      final allCurrencies = NumismaticDataHelper.currencyMap.keys.toList();
      expect(NumismaticDataHelper.getCurrenciesForCountry(null), equals(allCurrencies));
      expect(NumismaticDataHelper.getCurrenciesForCountry(''), equals(allCurrencies));
      expect(NumismaticDataHelper.getCurrenciesForCountry('Otro'), equals(allCurrencies));
    });

    test('getCurrencyMapForCountry returns mapped dictionary for country', () {
      final mexicoMap = NumismaticDataHelper.getCurrencyMapForCountry('México');
      expect(mexicoMap.keys, containsAll(['MXN', 'MXP']));
      expect(mexicoMap['MXN'], equals('Pesos Mexicanos'));
      expect(mexicoMap['MXP'], equals('Pesos Mexicanos Antiguos'));

      final usaMap = NumismaticDataHelper.getCurrencyMapForCountry('Estados Unidos');
      expect(usaMap.keys, equals(['USD']));
      expect(usaMap['USD'], equals('Dólares Estadounidenses'));
    });
  });
}
