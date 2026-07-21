import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:platinum_world_management_system/src/core/database/app_database.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/catalog_item.dart';
import 'package:platinum_world_management_system/src/features/catalog/infrastructure/catalog_repository.dart';
import 'package:platinum_world_management_system/src/features/entities/domain/entity_template.dart';
import 'package:platinum_world_management_system/src/features/entities/domain/world_entity.dart';
import 'package:platinum_world_management_system/src/features/entities/infrastructure/entity_repository.dart';
import 'package:platinum_world_management_system/src/features/relations/domain/entity_relation.dart';
import 'package:platinum_world_management_system/src/features/relations/infrastructure/relation_repository.dart';

void main() {
  late AppDatabase db;
  late EntityRepository entityRepo;
  late CatalogRepository catalogRepo;
  late RelationRepository relationRepo;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    db = AppDatabase(NativeDatabase.memory());
    entityRepo = EntityRepository(db);
    catalogRepo = CatalogRepository(db);
    relationRepo = RelationRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('PWMS 12 Refinements Domain Tests', () {
    test('Rule #3: Container Location Inheritance (Seguirlo)', () async {
      // Create Place: Garaje
      final garaje = WorldEntity(
        id: 'place-garaje',
        name: 'Garaje Principal',
        type: 'Lugar',
        isPlace: true,
        isContainer: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await entityRepo.saveEntity(garaje);

      // Create Container: Caja de Herramientas inside Garaje Principal
      final box = WorldEntity(
        id: 'box-tools',
        name: 'Caja Metálica',
        type: 'Contenedor',
        placeId: 'place-garaje',
        isContainer: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await entityRepo.saveEntity(box);

      // Create Item: Llave Inglesa inside Caja Metálica without specifying placeId
      final wrench = WorldEntity(
        id: 'item-wrench',
        name: 'Llave Inglesa 12"',
        type: 'Objeto / Herramienta',
        parentEntityId: 'box-tools',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await entityRepo.saveEntity(wrench);

      // Verify item automatically inherited location place-garaje from container
      final savedWrench = await entityRepo.getEntityById('item-wrench');
      expect(savedWrench!.placeId, equals('place-garaje'));
    });

    test('Rule #4 & #5: Strict Template Rules for Quantities', () async {
      final placeTemplate = EntityTemplateRegistry.getTemplate('Lugar');
      expect(placeTemplate.hasQuantity, isFalse);
      expect(placeTemplate.canBeInContainer, isFalse);

      final containerTemplate = EntityTemplateRegistry.getTemplate('Contenedor');
      expect(containerTemplate.hasQuantity, isFalse);
      expect(containerTemplate.canBeInContainer, isTrue);

      final objectTemplate = EntityTemplateRegistry.getTemplate('Objeto / Herramienta');
      expect(objectTemplate.hasQuantity, isTrue);
      expect(objectTemplate.canBeInContainer, isTrue);
    });

    test('Rule #9: GUARDADO_EN Relation targets Places or Containers only', () async {
      final box = WorldEntity(
        id: 'caja-1',
        name: 'Caja Plástica',
        type: 'Contenedor',
        isContainer: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final item = WorldEntity(
        id: 'item-1',
        name: 'Multímetro',
        type: 'Objeto / Herramienta',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await entityRepo.saveEntity(box);
      await entityRepo.saveEntity(item);

      final relation = EntityRelation(
        id: 'rel-1',
        sourceEntityId: 'item-1',
        targetEntityId: 'caja-1',
        relationType: 'GUARDADO_EN',
        createdAt: DateTime.now(),
      );

      await relationRepo.addRelation(relation);

      final rels = await relationRepo.getRelationsForEntity('item-1');
      expect(rels.length, equals(1));
      expect(rels.first.relationType, equals('GUARDADO_EN'));
    });

    test('Rule #12: Universe Catalog (Species vs Instance Separation)', () async {
      final species = CatalogItem(
        id: 'species-fluke-87v',
        name: 'Multímetro Fluke 87V',
        brand: 'Fluke',
        description: 'Multímetro Industrial TRMS',
        defaultType: 'Objeto / Herramienta',
        barcode: '750998877',
        createdAt: DateTime.now(),
      );

      await catalogRepo.saveCatalogItem(species);
      final catalogList = await catalogRepo.getAllCatalogItems();
      expect(catalogList.length, equals(1));
      expect(catalogList.first.name, equals('Multímetro Fluke 87V'));

      // Instantiate species into user's world
      final instance1 = WorldEntity(
        id: 'instance-taller',
        speciesId: species.id,
        name: species.name,
        type: species.defaultType,
        barcode: species.barcode,
        quantity: 1,
        unit: 'pieza',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await entityRepo.saveEntity(instance1);
      final savedInstance = await entityRepo.getEntityById('instance-taller');
      expect(savedInstance!.speciesId, equals('species-fluke-87v'));
    });
  });
}
