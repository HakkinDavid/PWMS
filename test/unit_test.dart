import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:platinum_world_management_system/src/core/database/app_database.dart';
import 'package:platinum_world_management_system/src/features/catalog/infrastructure/catalog_repository.dart';
import 'package:platinum_world_management_system/src/features/entities/domain/entity_template.dart';
import 'package:platinum_world_management_system/src/features/entities/domain/world_entity.dart';
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

  group('PWMS Location Graph & Catalog Architecture Tests', () {
    test('Location Graph Node Creation & Hierarchy', () async {
      final nodeGarage = LocationNode(
        id: 'loc-garaje',
        name: 'Garaje Principal',
        createdAt: DateTime.now(),
      );

      final nodeShelf = LocationNode(
        id: 'loc-estante',
        name: 'Estante #1',
        parentLocationId: 'loc-garaje',
        createdAt: DateTime.now(),
      );

      await locationRepo.saveNode(nodeGarage);
      await locationRepo.saveNode(nodeShelf);

      final allNodes = await locationRepo.getAllNodes();
      expect(allNodes.length, equals(2));

      final subNodes = await locationRepo.getSubNodes('loc-garaje');
      expect(subNodes.length, equals(1));
      expect(subNodes.first.name, equals('Estante #1'));
    });

    test('Catalog Auto-Species Registration & Instance Linking', () async {
      final species = await catalogRepo.getOrCreateSpecies(
        'Multímetro Fluke 87V',
        type: 'Objeto / Herramienta',
        brand: 'Fluke',
        barcode: '750998877',
      );

      expect(species.name, equals('Multímetro Fluke 87V'));
      expect(species.brand, equals('Fluke'));

      // Create Instance stored at location node
      final instance = WorldEntity(
        id: 'inst-1',
        speciesId: species.id,
        locationId: 'loc-estante',
        quantity: 1,
        unit: 'pieza',
        notes: 'Serie: #998877-A',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await entityRepo.saveEntity(instance);
      final retrieved = await entityRepo.getEntityById('inst-1');

      expect(retrieved, isNotNull);
      expect(retrieved!.speciesId, equals(species.id));
      expect(retrieved.locationId, equals('loc-estante'));
      expect(retrieved.quantity, equals(1));
    });

    test('Template Streamlining & HasQuantity rule', () async {
      final objectTpl = EntityTemplateRegistry.getTemplate('Objeto / Herramienta');
      expect(objectTpl.hasQuantity, isTrue);

      final docTpl = EntityTemplateRegistry.getTemplate('Documento');
      expect(docTpl.hasQuantity, isFalse);
    });
  });
}
