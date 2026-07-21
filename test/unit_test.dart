import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:platinum_world_management_system/src/core/constants/units_registry.dart';
import 'package:platinum_world_management_system/src/core/database/app_database.dart';
import 'package:platinum_world_management_system/src/features/catalog/infrastructure/catalog_repository.dart';
import 'package:platinum_world_management_system/src/features/entities/infrastructure/entity_repository.dart';
import 'package:platinum_world_management_system/src/features/locations/domain/location_node.dart';
import 'package:platinum_world_management_system/src/features/locations/infrastructure/location_repository.dart';

void main() {
  late AppDatabase db;
  late EntityRepository entityRepo;
  late CatalogRepository catalogRepo;
  late LocationRepository locationRepo;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    db = AppDatabase(NativeDatabase.memory());
    entityRepo = EntityRepository(db);
    catalogRepo = CatalogRepository(db);
    locationRepo = LocationRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('PWMS Pure Instantiation & SI Units Tests', () {
    test('1 & 5. Pure Instantiation & Quantity Auto-merging at same location', () async {
      final species = await catalogRepo.getOrCreateSpecies(
        'Tornillo M6',
        type: 'Objeto',
      );

      // First instantiation at loc-taller (quantity: 50)
      final inst1 = await entityRepo.instantiateOrMerge(
        species.id,
        'loc-taller',
        50,
        unit: 'pieza',
      );

      expect(inst1.quantity, equals(50));

      // Second instantiation of SAME species at SAME location (quantity: 25)
      final inst2 = await entityRepo.instantiateOrMerge(
        species.id,
        'loc-taller',
        25,
        unit: 'pieza',
      );

      // Auto-merged into single record with quantity 75!
      expect(inst2.id, equals(inst1.id));
      expect(inst2.quantity, equals(75));

      final allEntities = await entityRepo.getAllEntities();
      expect(allEntities.length, equals(1));
    });

    test('2. Free Location Node Re-parenting', () async {
      final rootNode = LocationNode(
        id: 'node-garage',
        name: 'Garaje',
        createdAt: DateTime.now(),
      );

      final childNode = LocationNode(
        id: 'node-shelf',
        name: 'Estante #1',
        parentLocationId: 'node-garage',
        createdAt: DateTime.now(),
      );

      await locationRepo.saveNode(rootNode);
      await locationRepo.saveNode(childNode);

      // Re-parent childNode to root (null parentLocationId)
      await locationRepo.moveNode('node-shelf', null);

      final moved = await locationRepo.getNodeById('node-shelf');
      expect(moved!.parentLocationId, isNull);
    });

    test('3. SI Units Registry catalog', () {
      expect(UnitsRegistry.allSiUnits, contains('kg'));
      expect(UnitsRegistry.allSiUnits, contains('m'));
      expect(UnitsRegistry.allSiUnits, contains('L'));
      expect(UnitsRegistry.allSiUnits, contains('pieza'));
    });
  });
}
