import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
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

  group('PWMS Cycle Prevention, Move-Merge & Recursive Counts Tests', () {
    test('1. Cycle Prevention: Cannot move node into itself or its child', () async {
      final parentNode = LocationNode(id: 'node-A', name: 'Garaje', createdAt: DateTime.now());
      final childNode = LocationNode(id: 'node-B', name: 'Estante #1', parentLocationId: 'node-A', createdAt: DateTime.now());

      await locationRepo.saveNode(parentNode);
      await locationRepo.saveNode(childNode);

      final allNodes = await locationRepo.getAllNodes();

      expect(locationRepo.canMoveNode('node-A', 'node-A', allNodes), isFalse);
      expect(locationRepo.canMoveNode('node-A', 'node-B', allNodes), isFalse);
      expect(locationRepo.canMoveNode('node-B', 'node-A', allNodes), isTrue);
    });

    test('2. Global Recursive Item Counting', () async {
      final parentNode = LocationNode(id: 'node-A', name: 'Garaje', createdAt: DateTime.now());
      final childNode = LocationNode(id: 'node-B', name: 'Estante #1', parentLocationId: 'node-A', createdAt: DateTime.now());

      await locationRepo.saveNode(parentNode);
      await locationRepo.saveNode(childNode);

      final species = await catalogRepo.getOrCreateSpecies('Tornillo M6', type: 'Objeto');

      await entityRepo.instantiateOrMerge(species.id, 'node-A', 10);
      await entityRepo.instantiateOrMerge(species.id, 'node-B', 20);

      final allNodes = await locationRepo.getAllNodes();
      final allEntities = await entityRepo.getAllEntities();

      final countParent = LocationRepository.getRecursiveItemCount('node-A', allNodes, allEntities);
      expect(countParent, equals(2)); // 1 record at A + 1 record at B
    });

    test('3. Move & Merge Entity to Target Location', () async {
      final species = await catalogRepo.getOrCreateSpecies('Tuerca M6', type: 'Objeto');

      final inst1 = await entityRepo.instantiateOrMerge(species.id, 'loc-1', 10);
      final inst2 = await entityRepo.instantiateOrMerge(species.id, 'loc-2', 15);

      // Move inst1 from loc-1 to loc-2 -> Auto-merges with inst2!
      final merged = await entityRepo.moveOrMergeEntity(inst1.id, 'loc-2');

      expect(merged!.id, equals(inst2.id));
      expect(merged.quantity, equals(25));

      final loc1Items = await entityRepo.getEntitiesByLocation('loc-1');
      expect(loc1Items, isEmpty);
    });
  });
}
