import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:platinum_world_management_system/src/core/database/app_database.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/catalog_item.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/species_magnitude.dart';
import 'package:platinum_world_management_system/src/features/catalog/infrastructure/catalog_repository.dart';
import 'package:platinum_world_management_system/src/features/entities/domain/instance_magnitude.dart';
import 'package:platinum_world_management_system/src/features/entities/domain/world_entity.dart';
import 'package:platinum_world_management_system/src/features/entities/infrastructure/entity_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;
  late EntityRepository entityRepo;
  late CatalogRepository catalogRepo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    entityRepo = EntityRepository(db);
    catalogRepo = CatalogRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('Batch Data Hydration Tests (N+1 Elimination)', () {
    test('CatalogRepository batch hydrates species magnitudes on getAllCatalogItems', () async {
      final item1 = CatalogItem(
        id: 'sp_1',
        name: 'Moneda de Oro',
        type: 'Objeto',
        magnitudes: [
          SpeciesMagnitude(
            id: 'sm_1',
            speciesId: 'sp_1',
            propertyName: 'Valor nominal',
            dataType: 'real',
            unitSymbol: 'MXN',
            createdAt: DateTime.now(),
          ),
          SpeciesMagnitude(
            id: 'sm_2',
            speciesId: 'sp_1',
            propertyName: 'Material',
            dataType: 'string',
            createdAt: DateTime.now(),
          ),
        ],
        createdAt: DateTime.now(),
      );

      final item2 = CatalogItem(
        id: 'sp_2',
        name: 'Billete Antiguo',
        type: 'Objeto',
        magnitudes: [
          SpeciesMagnitude(
            id: 'sm_3',
            speciesId: 'sp_2',
            propertyName: 'Acuñación',
            dataType: 'integer',
            unitSymbol: 'año',
            createdAt: DateTime.now(),
          ),
        ],
        createdAt: DateTime.now(),
      );

      await catalogRepo.saveCatalogItem(item1);
      await catalogRepo.saveCatalogItem(item2);

      final all = await catalogRepo.getAllCatalogItems();
      expect(all.length, 2);

      final retrieved1 = all.firstWhere((c) => c.id == 'sp_1');
      expect(retrieved1.magnitudes.length, 2);
      expect(retrieved1.magnitudes.any((m) => m.propertyName == 'Valor nominal'), isTrue);
      expect(retrieved1.magnitudes.any((m) => m.propertyName == 'Material'), isTrue);

      final retrieved2 = all.firstWhere((c) => c.id == 'sp_2');
      expect(retrieved2.magnitudes.length, 1);
      expect(retrieved2.magnitudes.first.propertyName, 'Acuñación');
    });

    test('EntityRepository batch hydrates instance magnitudes on getAllEntities', () async {
      final e1 = WorldEntity(
        id: 'e_1',
        speciesId: 'sp_1',
        magnitudes: [
          InstanceMagnitude(
            id: 'im_1',
            instanceId: 'e_1',
            propertyName: 'Peso',
            dataType: 'real',
            magnitudeValue: 15.5,
            unitSymbol: 'g',
          ),
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final e2 = WorldEntity(
        id: 'e_2',
        speciesId: 'sp_1',
        magnitudes: [
          InstanceMagnitude(
            id: 'im_2',
            instanceId: 'e_2',
            propertyName: 'Diámetro',
            dataType: 'real',
            magnitudeValue: 32.0,
            unitSymbol: 'mm',
          ),
          InstanceMagnitude(
            id: 'im_3',
            instanceId: 'e_2',
            propertyName: 'Grado',
            dataType: 'string',
            stringValue: 'Sin circular',
          ),
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await entityRepo.saveEntity(e1);
      await entityRepo.saveEntity(e2);

      final all = await entityRepo.getAllEntities();
      expect(all.length, 2);

      final retrievedE1 = all.firstWhere((e) => e.id == 'e_1');
      expect(retrievedE1.magnitudes.length, 1);
      expect(retrievedE1.magnitudes.first.propertyName, 'Peso');
      expect(retrievedE1.magnitudes.first.magnitudeValue, 15.5);

      final retrievedE2 = all.firstWhere((e) => e.id == 'e_2');
      expect(retrievedE2.magnitudes.length, 2);
      expect(retrievedE2.magnitudes.any((m) => m.propertyName == 'Diámetro'), isTrue);
      expect(retrievedE2.magnitudes.any((m) => m.stringValue == 'Sin circular'), isTrue);
    });
  });
}
