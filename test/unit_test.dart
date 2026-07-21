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

  group('PWMS Recursive Counting & Species Inheritance Tests', () {
    test('1. Recursive Location Node Item Counting', () async {
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

      final species1 = await catalogRepo.getOrCreateSpecies('Martillo', type: 'Objeto');
      final species2 = await catalogRepo.getOrCreateSpecies('Llave Inglesa', type: 'Objeto');

      // Instantiations: 1 stored in rootNode (Garaje), 1 stored in childNode (Estante #1)
      await entityRepo.instantiateOrMerge(species1.id, 'node-garage', 1);
      await entityRepo.instantiateOrMerge(species2.id, 'node-shelf', 1);

      final garajeItemsDirect = await entityRepo.getEntitiesByLocation('node-garage');
      expect(garajeItemsDirect.length, equals(1));

      final shelfItemsDirect = await entityRepo.getEntitiesByLocation('node-shelf');
      expect(shelfItemsDirect.length, equals(1));
    });

    test('3. SI Units Registry catalog', () {
      expect(UnitsRegistry.allSiUnits, contains('kg'));
      expect(UnitsRegistry.allSiUnits, contains('pieza'));
    });
  });
}
