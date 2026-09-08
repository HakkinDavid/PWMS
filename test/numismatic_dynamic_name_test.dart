import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import 'package:platinum_world_management_system/src/core/constants/app_technical_strings.dart';
import 'package:platinum_world_management_system/src/core/database/app_database.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/catalog_item.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/numismatic_data_helper.dart';
import 'package:platinum_world_management_system/src/features/catalog/infrastructure/catalog_repository.dart';
import 'package:platinum_world_management_system/src/features/entities/domain/entity_display_helper.dart';
import 'package:platinum_world_management_system/src/features/entities/domain/instance_magnitude.dart';
import 'package:platinum_world_management_system/src/features/entities/domain/world_entity.dart';
import 'package:platinum_world_management_system/src/features/entities/infrastructure/entity_repository.dart';

void main() {
  late AppDatabase db;
  late CatalogRepository catalogRepo;
  late EntityRepository entityRepo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    catalogRepo = CatalogRepository(db);
    entityRepo = EntityRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('Dynamic Nombre Derivation for Moneda & Billete', () {
    final monedaSpecies = CatalogItem(
      id: 'sp_moneda',
      name: 'Moneda',
      type: AppStrings.typeObject,
      createdAt: DateTime.now(),
    );

    final billeteSpecies = CatalogItem(
      id: 'sp_billete',
      name: 'Billete',
      type: AppStrings.typeObject,
      createdAt: DateTime.now(),
    );

    final otherSpecies = CatalogItem(
      id: 'sp_laptop',
      name: 'Laptop',
      type: AppStrings.typeObject,
      createdAt: DateTime.now(),
    );

    test('derives full canonical name from nominal value, currency, country, and year', () async {
      await catalogRepo.saveCatalogItem(monedaSpecies);

      final coinEntity = WorldEntity(
        id: 'coin_1',
        speciesId: monedaSpecies.id,
        magnitudes: const [
          InstanceMagnitude(
            id: 'm1',
            instanceId: 'coin_1',
            propertyName: AppStrings.nominalValuePropertyName,
            dataType: AppTechnicalStrings.datatypeRealLower,
            magnitudeValue: 5.0,
          ),
          InstanceMagnitude(
            id: 'm2',
            instanceId: 'coin_1',
            propertyName: AppStrings.currencyPropertyName,
            dataType: AppTechnicalStrings.datatypeStringLower,
            stringValue: 'MXN',
          ),
          InstanceMagnitude(
            id: 'm3',
            instanceId: 'coin_1',
            propertyName: AppStrings.issuerPropertyName,
            dataType: AppTechnicalStrings.datatypeStringLower,
            stringValue: 'México',
          ),
          InstanceMagnitude(
            id: 'm4',
            instanceId: 'coin_1',
            propertyName: AppStrings.mintagePropertyName,
            dataType: AppTechnicalStrings.datatypeIntegerLower,
            magnitudeValue: 1985.0,
            unitSymbol: AppStrings.yearUnitSymbol,
          ),
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Direct derivation test
      final derivedName = NumismaticDataHelper.deriveInstanceName(coinEntity);
      expect(derivedName, equals('5 Pesos Mexicanos - México (1985)'));

      // Persisted test
      await entityRepo.saveEntity(coinEntity);
      final loaded = await entityRepo.getEntityById('coin_1');
      expect(loaded, isNotNull);

      final customName = EntityDisplayHelper.getInstanceCustomName(loaded!, monedaSpecies);
      expect(customName, equals('5 Pesos Mexicanos - México (1985)'));

      final displayName = EntityDisplayHelper.getDisplayName(
        entity: loaded,
        catalogItems: [monedaSpecies],
      );
      expect(displayName, equals('5 Pesos Mexicanos - México (1985)'));
    });

    test('handles singular vs plural correctly (1 Dólar vs 20 Dólares)', () {
      final singleDollar = WorldEntity(
        id: 'bill_1',
        speciesId: billeteSpecies.id,
        magnitudes: const [
          InstanceMagnitude(
            id: 'm1',
            instanceId: 'bill_1',
            propertyName: AppStrings.nominalValuePropertyName,
            dataType: AppTechnicalStrings.datatypeRealLower,
            magnitudeValue: 1.0,
          ),
          InstanceMagnitude(
            id: 'm2',
            instanceId: 'bill_1',
            propertyName: AppStrings.currencyPropertyName,
            dataType: AppTechnicalStrings.datatypeStringLower,
            stringValue: 'USD',
          ),
          InstanceMagnitude(
            id: 'm3',
            instanceId: 'bill_1',
            propertyName: AppStrings.issuerPropertyName,
            dataType: AppTechnicalStrings.datatypeStringLower,
            stringValue: 'Estados Unidos',
          ),
          InstanceMagnitude(
            id: 'm4',
            instanceId: 'bill_1',
            propertyName: AppStrings.mintagePropertyName,
            dataType: AppTechnicalStrings.datatypeIntegerLower,
            magnitudeValue: 2020.0,
          ),
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final twentyDollars = singleDollar.copyWith(
        id: 'bill_20',
        magnitudes: singleDollar.magnitudes.map((m) {
          if (m.propertyName == AppStrings.nominalValuePropertyName) {
            return m.copyWith(magnitudeValue: 20.0);
          }
          return m;
        }).toList(),
      );

      expect(
        NumismaticDataHelper.deriveInstanceName(singleDollar),
        equals('1 Dólar Estadounidense - Estados Unidos (2020)'),
      );
      expect(
        NumismaticDataHelper.deriveInstanceName(twentyDollars),
        equals('20 Dólares Estadounidenses - Estados Unidos (2020)'),
      );
    });

    test('derives partial names cleanly when country or year are omitted', () {
      final coinWithoutYear = WorldEntity(
        id: 'coin_2',
        speciesId: monedaSpecies.id,
        magnitudes: const [
          InstanceMagnitude(
            id: 'm1',
            instanceId: 'coin_2',
            propertyName: AppStrings.nominalValuePropertyName,
            dataType: AppTechnicalStrings.datatypeRealLower,
            magnitudeValue: 10.0,
          ),
          InstanceMagnitude(
            id: 'm2',
            instanceId: 'coin_2',
            propertyName: AppStrings.currencyPropertyName,
            dataType: AppTechnicalStrings.datatypeStringLower,
            stringValue: 'EUR',
          ),
          InstanceMagnitude(
            id: 'm3',
            instanceId: 'coin_2',
            propertyName: AppStrings.issuerPropertyName,
            dataType: AppTechnicalStrings.datatypeStringLower,
            stringValue: 'España',
          ),
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final coinOnlyDenom = WorldEntity(
        id: 'coin_3',
        speciesId: monedaSpecies.id,
        magnitudes: const [
          InstanceMagnitude(
            id: 'm1',
            instanceId: 'coin_3',
            propertyName: AppStrings.nominalValuePropertyName,
            dataType: AppTechnicalStrings.datatypeRealLower,
            magnitudeValue: 50.0,
          ),
          InstanceMagnitude(
            id: 'm2',
            instanceId: 'coin_3',
            propertyName: AppStrings.currencyPropertyName,
            dataType: AppTechnicalStrings.datatypeStringLower,
            stringValue: 'Centavos',
          ),
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(
        NumismaticDataHelper.deriveInstanceName(coinWithoutYear),
        equals('10 Euros - España'),
      );
      expect(
        NumismaticDataHelper.deriveInstanceName(coinOnlyDenom),
        equals('50 Centavos'),
      );
    });

    test('EntityRepository injects and persists dynamic Nombre property into entity.magnitudes and DB', () async {
      await catalogRepo.saveCatalogItem(monedaSpecies);

      final newCoin = WorldEntity(
        id: 'persisted_coin_1',
        speciesId: monedaSpecies.id,
        magnitudes: const [
          InstanceMagnitude(
            id: 'm1',
            instanceId: 'persisted_coin_1',
            propertyName: AppStrings.nominalValuePropertyName,
            dataType: AppTechnicalStrings.datatypeRealLower,
            magnitudeValue: 10.0,
          ),
          InstanceMagnitude(
            id: 'm2',
            instanceId: 'persisted_coin_1',
            propertyName: AppStrings.currencyPropertyName,
            dataType: AppTechnicalStrings.datatypeStringLower,
            stringValue: 'MXN',
          ),
          InstanceMagnitude(
            id: 'm3',
            instanceId: 'persisted_coin_1',
            propertyName: AppStrings.issuerPropertyName,
            dataType: AppTechnicalStrings.datatypeStringLower,
            stringValue: 'México',
          ),
          InstanceMagnitude(
            id: 'm4',
            instanceId: 'persisted_coin_1',
            propertyName: AppStrings.mintagePropertyName,
            dataType: AppTechnicalStrings.datatypeIntegerLower,
            magnitudeValue: 1990.0,
          ),
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await entityRepo.saveEntity(newCoin);

      // Verify loaded entity from DB has 'Nombre' magnitude
      final loaded = await entityRepo.getEntityById('persisted_coin_1');
      expect(loaded, isNotNull);

      final nombreMag = loaded!.magnitudes.firstWhere(
        (m) => m.propertyName.trim().toLowerCase() == AppTechnicalStrings.propNombreLower,
      );
      expect(nombreMag.dataType, equals(AppTechnicalStrings.datatypeStringLower));
      expect(nombreMag.stringValue, equals('10 Pesos Mexicanos - México (1990)'));
      expect(nombreMag.displayValue, equals('10 Pesos Mexicanos - México (1990)'));

      // Verify row exists directly in Drift DB instance_magnitudes_table
      final dbRows = await (db.select(db.instanceMagnitudesTable)
        ..where((t) => t.instanceId.equals('persisted_coin_1') & t.propertyName.equals(AppStrings.propertyNameNombre))).get();
      expect(dbRows.length, equals(1));
      expect(dbRows.first.stringValue, equals('10 Pesos Mexicanos - México (1990)'));
    });

    test('Updating other properties dynamically updates the Nombre magnitude upon save', () async {
      await catalogRepo.saveCatalogItem(monedaSpecies);

      final coin = WorldEntity(
        id: 'coin_dyn_update',
        speciesId: monedaSpecies.id,
        magnitudes: const [
          InstanceMagnitude(
            id: 'm1',
            instanceId: 'coin_dyn_update',
            propertyName: AppStrings.nominalValuePropertyName,
            dataType: AppTechnicalStrings.datatypeRealLower,
            magnitudeValue: 5.0,
          ),
          InstanceMagnitude(
            id: 'm2',
            instanceId: 'coin_dyn_update',
            propertyName: AppStrings.currencyPropertyName,
            dataType: AppTechnicalStrings.datatypeStringLower,
            stringValue: 'MXN',
          ),
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await entityRepo.saveEntity(coin);

      var loaded = await entityRepo.getEntityById('coin_dyn_update');
      var nombreMag = loaded!.magnitudes.firstWhere((m) => m.propertyName == AppStrings.propertyNameNombre);
      expect(nombreMag.stringValue, equals('5 Pesos Mexicanos'));

      // Update face value to 20 and add Year 1982
      final updatedCoin = loaded.copyWith(
        magnitudes: [
          ...loaded.magnitudes.where((m) => m.propertyName != AppStrings.propertyNameNombre).map((m) {
            if (m.propertyName == AppStrings.nominalValuePropertyName) {
              return m.copyWith(magnitudeValue: 20.0);
            }
            return m;
          }),
          const InstanceMagnitude(
            id: 'm_year',
            instanceId: 'coin_dyn_update',
            propertyName: AppStrings.mintagePropertyName,
            dataType: AppTechnicalStrings.datatypeIntegerLower,
            magnitudeValue: 1982.0,
          ),
        ],
      );

      await entityRepo.saveEntity(updatedCoin);

      loaded = await entityRepo.getEntityById('coin_dyn_update');
      nombreMag = loaded!.magnitudes.firstWhere((m) => m.propertyName == AppStrings.propertyNameNombre);
      expect(nombreMag.stringValue, equals('20 Pesos Mexicanos (1982)'));
    });

    test('Search engine matches entities by the dynamically derived Nombre', () async {
      await catalogRepo.saveCatalogItem(monedaSpecies);

      final coin = WorldEntity(
        id: 'searchable_coin',
        speciesId: monedaSpecies.id,
        magnitudes: const [
          InstanceMagnitude(
            id: 'm1',
            instanceId: 'searchable_coin',
            propertyName: AppStrings.nominalValuePropertyName,
            dataType: AppTechnicalStrings.datatypeRealLower,
            magnitudeValue: 100.0,
          ),
          InstanceMagnitude(
            id: 'm2',
            instanceId: 'searchable_coin',
            propertyName: AppStrings.currencyPropertyName,
            dataType: AppTechnicalStrings.datatypeStringLower,
            stringValue: 'Pesos Mexicanos',
          ),
          InstanceMagnitude(
            id: 'm3',
            instanceId: 'searchable_coin',
            propertyName: AppStrings.issuerPropertyName,
            dataType: AppTechnicalStrings.datatypeStringLower,
            stringValue: 'México',
          ),
          InstanceMagnitude(
            id: 'm4',
            instanceId: 'searchable_coin',
            propertyName: AppStrings.mintagePropertyName,
            dataType: AppTechnicalStrings.datatypeIntegerLower,
            magnitudeValue: 1977.0,
          ),
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await entityRepo.saveEntity(coin);

      // Search by exact phrase
      final results1 = await entityRepo.searchEntities('100 Pesos Mexicanos');
      expect(results1.map((e) => e.id), contains('searchable_coin'));

      // Search by country
      final results2 = await entityRepo.searchEntities('México');
      expect(results2.map((e) => e.id), contains('searchable_coin'));

      // Search by year
      final results3 = await entityRepo.searchEntities('1977');
      expect(results3.map((e) => e.id), contains('searchable_coin'));
    });

    test('Non-numismatic entities do not derive artificial Nombre', () async {
      await catalogRepo.saveCatalogItem(otherSpecies);

      final laptop = WorldEntity(
        id: 'laptop_1',
        speciesId: otherSpecies.id,
        magnitudes: const [
          InstanceMagnitude(
            id: 'm1',
            instanceId: 'laptop_1',
            propertyName: 'RAM',
            dataType: AppTechnicalStrings.datatypeIntegerLower,
            magnitudeValue: 16.0,
            unitSymbol: 'GB',
          ),
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await entityRepo.saveEntity(laptop);

      final loaded = await entityRepo.getEntityById('laptop_1');
      expect(loaded, isNotNull);
      expect(
        loaded!.magnitudes.any((m) => m.propertyName.toLowerCase() == AppTechnicalStrings.propNombreLower),
        isFalse,
      );
      expect(EntityDisplayHelper.getInstanceCustomName(loaded, otherSpecies), isNull);
    });
  });

  group('NumismaticNamingEngine Subunit and Canonical Motif Formatting Tests', () {
    test('formatDenominationLabel formats clean brief labels for wheel pickers', () {
      expect(NumismaticDataHelper.formatDenominationLabel(denomination: '0.20', currencyCode: 'MXP'), equals('20 Centavos'));
      expect(NumismaticDataHelper.formatDenominationLabel(denomination: '0.50', currencyCode: 'MXN'), equals('50 Centavos'));
      expect(NumismaticDataHelper.formatDenominationLabel(denomination: '1', currencyCode: 'MXN'), equals('1 Peso'));
      expect(NumismaticDataHelper.formatDenominationLabel(denomination: '5', currencyCode: 'MXN'), equals('5 Pesos'));
      expect(NumismaticDataHelper.formatDenominationLabel(denomination: '0.25', currencyCode: 'USD'), equals('Quarter Dollar (25 Cents)'));
      expect(NumismaticDataHelper.formatDenominationLabel(denomination: '0.50', currencyCode: 'EUR'), equals('50 Céntimos de Euro'));
      expect(NumismaticDataHelper.formatDenominationLabel(denomination: '1/2', currencyCode: 'REAL'), equals('Medio Real (1/2 Real)'));
      expect(NumismaticDataHelper.formatDenominationLabel(denomination: '8', currencyCode: 'REAL'), equals('8 Reales (Real de a 8)'));
    });

    test('formatDenominationWithFullCurrency resolves natural subunits and case-consistent plurals', () {
      expect(
        NumismaticDataHelper.formatDenominationWithFullCurrency(denomination: '0.20', currencyCode: 'MXP'),
        equals('20 Centavos de Pesos Mexicanos Antiguos'),
      );
      expect(
        NumismaticDataHelper.formatDenominationWithFullCurrency(denomination: '50', currencyCode: 'MXP'),
        equals('50 Pesos Mexicanos Antiguos'),
      );
      expect(
        NumismaticDataHelper.formatDenominationWithFullCurrency(denomination: '20', currencyCode: 'MXN'),
        equals('20 Pesos Mexicanos'),
      );
      expect(
        NumismaticDataHelper.formatDenominationWithFullCurrency(denomination: '1', currencyCode: 'USD'),
        equals('1 Dólar Estadounidense'),
      );
      expect(
        NumismaticDataHelper.formatDenominationWithFullCurrency(denomination: '0.25', currencyCode: 'USD'),
        equals('25 Cents de Dólares Estadounidenses'),
      );
      expect(
        NumismaticDataHelper.formatDenominationWithFullCurrency(denomination: '0.50', currencyCode: 'EUR'),
        equals('50 Céntimos de Euro'),
      );
      expect(
        NumismaticDataHelper.formatDenominationWithFullCurrency(denomination: '8', currencyCode: 'MXR'),
        equals('8 Reales Mexicanos Coloniales e Imperiales'),
      );
      expect(
        NumismaticDataHelper.formatDenominationWithFullCurrency(denomination: '1/2', currencyCode: 'REAL'),
        equals('1/2 Real Español'),
      );
    });

    test('buildSpecimenTitle formats museum-grade title with Country, Year, and Commemorative Motif', () {
      final specimen1 = NumismaticDataHelper.buildSpecimenTitle(
        attrs: const NumismaticAttributes(
          faceValueStr: '0.20',
          currencyCode: 'MXP',
          country: 'México',
          year: '1975',
          motif: 'Francisco I. Madero',
        ),
      );
      expect(specimen1, equals('20 Centavos de Pesos Mexicanos Antiguos - México (1975) - Francisco I. Madero'));

      final specimen2 = NumismaticDataHelper.buildSpecimenTitle(
        attrs: const NumismaticAttributes(
          faceValueStr: '50',
          currencyCode: 'MXP',
          country: 'México',
          year: '1982',
          motif: 'Coyolxauhqui',
        ),
      );
      expect(specimen2, equals('50 Pesos Mexicanos Antiguos - México (1982) - Coyolxauhqui'));

      final specimen3 = NumismaticDataHelper.buildSpecimenTitle(
        attrs: const NumismaticAttributes(
          faceValueStr: '20',
          currencyCode: 'MXN',
          country: 'México',
          year: '2021',
          motif: '500 Años de Memoria Histórica de México-Tenochtitlan',
        ),
      );
      expect(specimen3, equals('20 Pesos Mexicanos - México (2021) - 500 Años de Memoria Histórica de México-Tenochtitlan'));

      final specimen4 = NumismaticDataHelper.buildSpecimenTitle(
        attrs: const NumismaticAttributes(
          faceValueStr: '1',
          currencyCode: 'USD',
          country: 'Estados Unidos',
          year: '1921',
          motif: 'Morgan',
        ),
      );
      expect(specimen4, equals('1 Dólar Estadounidense - Estados Unidos (1921) - Morgan'));

      final specimen5 = NumismaticDataHelper.buildSpecimenTitle(
        attrs: const NumismaticAttributes(
          faceValueStr: '8',
          currencyCode: 'MXR',
          country: 'Virreinato de Nueva España',
          year: '1790',
          motif: 'Carlos IV',
        ),
      );
      expect(specimen5, equals('8 Reales Mexicanos Coloniales e Imperiales - Virreinato de Nueva España (1790) - Carlos IV'));
    });

    test('deriveInstanceName integrates motif from instance magnitudes into dynamic Nombre', () {
      final monedaSpecies = CatalogItem(
        id: 'sp_moneda_motif',
        name: 'Moneda',
        type: AppStrings.typeObject,
        createdAt: DateTime.now(),
      );

      final commemorativeCoin = WorldEntity(
        id: 'commem_coin_1',
        speciesId: monedaSpecies.id,
        magnitudes: const [
          InstanceMagnitude(
            id: 'm1',
            instanceId: 'commem_coin_1',
            propertyName: AppStrings.nominalValuePropertyName,
            dataType: AppTechnicalStrings.datatypeRealLower,
            magnitudeValue: 0.20,
          ),
          InstanceMagnitude(
            id: 'm2',
            instanceId: 'commem_coin_1',
            propertyName: AppStrings.currencyPropertyName,
            dataType: AppTechnicalStrings.datatypeStringLower,
            stringValue: 'MXP',
          ),
          InstanceMagnitude(
            id: 'm3',
            instanceId: 'commem_coin_1',
            propertyName: AppStrings.issuerPropertyName,
            dataType: AppTechnicalStrings.datatypeStringLower,
            stringValue: 'México',
          ),
          InstanceMagnitude(
            id: 'm4',
            instanceId: 'commem_coin_1',
            propertyName: AppStrings.mintagePropertyName,
            dataType: AppTechnicalStrings.datatypeIntegerLower,
            magnitudeValue: 1975.0,
          ),
          InstanceMagnitude(
            id: 'm5',
            instanceId: 'commem_coin_1',
            propertyName: AppStrings.motifPropertyName,
            dataType: AppTechnicalStrings.datatypeStringLower,
            stringValue: 'Francisco I. Madero',
          ),
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final derived = NumismaticDataHelper.deriveInstanceName(commemorativeCoin);
      expect(derived, equals('20 Centavos de Pesos Mexicanos Antiguos - México (1975) - Francisco I. Madero'));
    });
  });
}
