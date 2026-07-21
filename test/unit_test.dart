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

  group('PWMS Navigation & Streamlined State Tests', () {
    test('1. Location Node Item Aggregation', () async {
      final rootNode = LocationNode(
        id: 'node-garage',
        name: 'Garaje',
        createdAt: DateTime.now(),
      );

      await locationRepo.saveNode(rootNode);
      final species1 = await catalogRepo.getOrCreateSpecies('Martillo', type: 'Objeto');

      await entityRepo.instantiateOrMerge(species1.id, 'node-garage', 1);

      final garajeItemsDirect = await entityRepo.getEntitiesByLocation('node-garage');
      expect(garajeItemsDirect.length, equals(1));
    });

    test('2. SI Units Registry catalog', () {
      expect(UnitsRegistry.allSiUnits, contains('kg'));
      expect(UnitsRegistry.allSiUnits, contains('pieza'));
    });
  });
}
