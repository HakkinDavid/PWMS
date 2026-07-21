import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:platinum_world_management_system/src/core/database/app_database.dart';
import 'package:platinum_world_management_system/src/core/domain/domain_rules.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/species_magnitude.dart';
import 'package:platinum_world_management_system/src/features/catalog/infrastructure/catalog_repository.dart';
import 'package:platinum_world_management_system/src/features/entities/domain/instance_magnitude.dart';
import 'package:platinum_world_management_system/src/features/entities/infrastructure/entity_repository.dart';
import 'package:platinum_world_management_system/src/features/financial/infrastructure/financial_repository.dart';
import 'package:platinum_world_management_system/src/features/locations/domain/location_node.dart';
import 'package:platinum_world_management_system/src/features/locations/infrastructure/location_repository.dart';

void main() {
  late AppDatabase db;
  late EntityRepository entityRepo;
  late CatalogRepository catalogRepo;
  late LocationRepository locationRepo;
  late FinancialRepository financialRepo;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    db = AppDatabase(NativeDatabase.memory());
    entityRepo = EntityRepository(db);
    catalogRepo = CatalogRepository(db);
    locationRepo = LocationRepository(db);
    financialRepo = FinancialRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('PWMS 4NF Database & Single Source of Truth Rules Tests', () {
    test('1. DomainRules Single Source of Truth Enforcement', () {
      expect(DomainRules.isIntegerUnit('pieza'), isTrue);
      expect(DomainRules.isIntegerUnit('kg'), isFalse);

      // Rule #8: Unique species CANNOT be associated with "pieza"
      expect(DomainRules.isUnitAllowedForSpecies(unitSymbol: 'pieza', isUnique: true), isFalse);
      expect(DomainRules.isUnitAllowedForSpecies(unitSymbol: 'kg', isUnique: true), isTrue);
    });

    test('2. 4NF Species & Instance Magnitudes Normalization Persistence', () async {
      final node = LocationNode(id: 'node-1', name: 'Almacén', createdAt: DateTime.now());
      await locationRepo.saveNode(node);

      final species = await catalogRepo.getOrCreateSpecies('Cable Eléctrico Cobre', type: 'Objeto', defaultUnit: 'm');
      final updatedSpecies = species.copyWith(
        magnitudes: [
          SpeciesMagnitude(
            id: 'mag-1',
            speciesId: species.id,
            propertyName: 'Longitud Carrete',
            magnitudeValue: 100.0,
            unitSymbol: 'm',
            createdAt: DateTime.now(),
          ),
          SpeciesMagnitude(
            id: 'mag-2',
            speciesId: species.id,
            propertyName: 'Masa Total',
            magnitudeValue: 12.5,
            unitSymbol: 'kg',
            createdAt: DateTime.now(),
          ),
        ],
      );

      await catalogRepo.saveCatalogItem(updatedSpecies);

      final fetchedSpecies = await catalogRepo.getCatalogItemById(species.id);
      expect(fetchedSpecies, isNotNull);
      expect(fetchedSpecies!.magnitudes.length, equals(2));
      expect(fetchedSpecies.magnitudes.first.propertyName, equals('Longitud Carrete'));

      final instance = await entityRepo.instantiateOrMerge(species.id, 'node-1', 1);
      final updatedInstance = instance.copyWith(
        magnitudes: [
          InstanceMagnitude(
            id: 'imag-1',
            instanceId: instance.id,
            propertyName: 'Masa Real',
            magnitudeValue: 12.4,
            unitSymbol: 'kg',
          ),
        ],
      );
      await entityRepo.saveEntity(updatedInstance);

      final fetchedInstance = await entityRepo.getEntityById(instance.id);
      expect(fetchedInstance, isNotNull);
      expect(fetchedInstance!.magnitudes.length, equals(1));
      expect(fetchedInstance.magnitudes.first.propertyName, equals('Masa Real'));
    });

    test('3. Acquisition & Sale Financial Ledger Recording', () async {
      final species = await catalogRepo.getOrCreateSpecies('Monitor 4K', type: 'Objeto');

      // Acquisition transaction
      await financialRepo.recordTransaction(
        speciesId: species.id,
        transactionType: 'acquisition',
        magnitudeDelta: 2,
        amount: 14000.0,
        currency: 'MXN',
        isSale: false,
      );

      // Sale transaction
      await financialRepo.recordTransaction(
        speciesId: species.id,
        transactionType: 'sale',
        magnitudeDelta: -1,
        amount: 8000.0,
        currency: 'MXN',
        isSale: true,
      );

      final txs = await financialRepo.getTransactionsForSpecies(species.id);
      expect(txs.length, equals(2));
      expect(txs.any((t) => t.isSale), isTrue);
      expect(txs.any((t) => t.amount == 14000.0), isTrue);
    });
  });
}
