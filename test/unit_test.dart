import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:platinum_world_management_system/src/core/database/app_database.dart';
import 'package:platinum_world_management_system/src/features/catalog/infrastructure/catalog_repository.dart';
import 'package:platinum_world_management_system/src/features/entities/infrastructure/entity_repository.dart';
import 'package:platinum_world_management_system/src/features/locations/domain/location_node.dart';
import 'package:platinum_world_management_system/src/features/locations/domain/location_path_helper.dart';
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

  group('PWMS Location Breadcrumbs & Species Units Tests', () {
    test('1. Location Breadcrumbs Path Calculation', () async {
      final nodeA = LocationNode(id: 'node-A', name: 'Casa', createdAt: DateTime.now());
      final nodeB = LocationNode(id: 'node-B', name: 'Garaje', parentLocationId: 'node-A', createdAt: DateTime.now());
      final nodeC = LocationNode(id: 'node-C', name: 'Estante #1', parentLocationId: 'node-B', createdAt: DateTime.now());

      await locationRepo.saveNode(nodeA);
      await locationRepo.saveNode(nodeB);
      await locationRepo.saveNode(nodeC);

      final allNodes = await locationRepo.getAllNodes();
      final breadcrumb = LocationPathHelper.buildBreadcrumbPath('node-C', allNodes);

      expect(breadcrumb.ancestorPath, equals('Mundo > Casa > Garaje >'));
      expect(breadcrumb.targetName, equals('Estante #1'));

      final species = await catalogRepo.getOrCreateSpecies('Martillo', type: 'Objeto');
      final entity = await entityRepo.instantiateOrMerge(species.id, 'node-C', 1);
      expect(entity.speciesId, equals(species.id));
    });
  });
}
