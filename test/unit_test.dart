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

  group('PWMS Unified Registration Tests', () {
    test('1. Catalog Species Creation & Immediate Instantiation', () async {
      final nodeA = LocationNode(id: 'node-A', name: 'Garaje', createdAt: DateTime.now());
      await locationRepo.saveNode(nodeA);

      final species = await catalogRepo.getOrCreateSpecies('Multímetro Fluke 87V', type: 'Objeto');
      final instance = await entityRepo.instantiateOrMerge(species.id, 'node-A', 1);

      expect(instance.speciesId, equals(species.id));
      expect(instance.locationId, equals('node-A'));

      final allNodes = await locationRepo.getAllNodes();
      final breadcrumb = LocationPathHelper.buildBreadcrumbPath('node-A', allNodes);
      expect(breadcrumb.targetName, equals('Garaje'));
    });
  });
}
