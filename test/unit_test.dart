import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:platinum_world_management_system/src/core/database/app_database.dart';
import 'package:platinum_world_management_system/src/core/domain/domain_rules.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/species_magnitude.dart';
import 'package:platinum_world_management_system/src/features/catalog/infrastructure/catalog_repository.dart';
import 'package:platinum_world_management_system/src/features/entities/domain/instance_magnitude.dart';
import 'package:platinum_world_management_system/src/features/entities/infrastructure/entity_repository.dart';
import 'package:platinum_world_management_system/src/features/locations/domain/location_node.dart';
import 'package:platinum_world_management_system/src/features/locations/infrastructure/location_repository.dart';
import 'package:platinum_world_management_system/src/features/relations/domain/entity_relation.dart';
import 'package:platinum_world_management_system/src/features/relations/infrastructure/relation_repository.dart';
import 'package:platinum_world_management_system/src/features/locations/domain/location_path_helper.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/catalog_item.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/subspecies.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/species_requirement.dart';
import 'package:platinum_world_management_system/src/features/entities/domain/effective_entity_group.dart';
import 'package:platinum_world_management_system/src/features/entities/domain/entity_display_helper.dart';
import 'package:platinum_world_management_system/src/features/entities/presentation/quantity_operation_helper.dart';

void main() {
  late AppDatabase db;
  late EntityRepository entityRepo;
  late CatalogRepository catalogRepo;
  late LocationRepository locationRepo;
  late RelationRepository relationRepo;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    db = AppDatabase(NativeDatabase.memory());
    entityRepo = EntityRepository(db);
    catalogRepo = CatalogRepository(db);
    locationRepo = LocationRepository(db);
    relationRepo = RelationRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('PWMS 4NF Database & Single Source of Truth Rules Tests', () {
    test('1. DomainRules Single Source of Truth & Integer Formatting Enforcement', () {
      expect(DomainRules.isIntegerUnit('kg'), isFalse);

      // Integer Formatting without .0 for whole numbers
      expect(DomainRules.formatMagnitude(5.0, 'kg'), equals('5'));
      expect(DomainRules.formatMagnitude(0.0, 'kg'), equals('0'));
      expect(DomainRules.formatMagnitude(2.5, 'kg'), equals('2.5'));
    });

    test('2. 4NF Species & Instance Magnitudes Normalization & Empty Default Test', () async {
      final node = LocationNode(id: 'node-1', name: 'Almacén', createdAt: DateTime.now());
      await locationRepo.saveNode(node);

      // Species created without explicit magnitudes has empty magnitudes: []
      final speciesNoMag = await catalogRepo.getOrCreateSpecies('Martillo Simple', type: 'Objeto');
      expect(speciesNoMag.magnitudes, isEmpty);

      final instanceNoMag = await entityRepo.instantiateOrMerge(speciesNoMag.id, 'node-1', 1);
      expect(instanceNoMag.magnitudes, isEmpty);

      // Species with explicit magnitudes
      final species = await catalogRepo.getOrCreateSpecies('Cable Eléctrico Cobre', type: 'Objeto');
      final updatedSpecies = species.copyWith(
        magnitudes: [
          SpeciesMagnitude(
            id: 'mag-1',
            speciesId: species.id,
            propertyName: 'Longitud Carrete',
            unitSymbol: 'm',
            createdAt: DateTime.now(),
          ),
          SpeciesMagnitude(
            id: 'mag-2',
            speciesId: species.id,
            propertyName: 'Masa Total',
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

    test('3. Directed Entity Relations Persistence and Traversal', () async {
      final docSpecies = await catalogRepo.getOrCreateSpecies('Manual de Usuario', type: 'Documento', isUnique: true);
      final objSpecies = await catalogRepo.getOrCreateSpecies('Lápiz Óptico', type: 'Objeto');

      final docInstance = await entityRepo.instantiateOrMerge(docSpecies.id, null, 1);
      final objInstance = await entityRepo.instantiateOrMerge(objSpecies.id, null, 1);

      final relation = EntityRelation(
        id: 'rel-1',
        sourceEntityId: docInstance.id,
        targetEntityId: objInstance.id,
        relationType: 'DOCUMENTA',
        createdAt: DateTime.now(),
      );

      await relationRepo.addRelation(relation);

      final docRelations = await relationRepo.getRelationsForEntity(docInstance.id);
      expect(docRelations.length, equals(1));
      expect(docRelations.first.relationType, equals('DOCUMENTA'));
      expect(docRelations.first.targetEntityId, equals(objInstance.id));
    });

    test('4. Effective Location Inheritance, Single Container Rule & Unlink Stamping', () async {
      final locNode = LocationNode(id: 'loc-workshop', name: 'Taller', createdAt: DateTime.now());
      await locationRepo.saveNode(locNode);

      final boxSpecies = await catalogRepo.getOrCreateSpecies('Caja Grande', type: 'Objeto');
      final toolSpecies = await catalogRepo.getOrCreateSpecies('Martillo', type: 'Objeto');

      final box = await entityRepo.instantiateOrMerge(boxSpecies.id, 'loc-workshop', 1);
      final tool = await entityRepo.instantiateOrMerge(toolSpecies.id, null, 1);

      // Tool initially has no direct location
      expect(tool.locationId, isNull);

      // Save relation: Tool GUARDADO_EN Box
      final rel1 = EntityRelation(
        id: 'rel-guardado-1',
        sourceEntityId: tool.id,
        targetEntityId: box.id,
        relationType: 'GUARDADO_EN',
        createdAt: DateTime.now(),
      );
      await relationRepo.addRelation(rel1);

      // Tool effective location should now inherit Box's location ('loc-workshop')
      final toolFetched = await entityRepo.getEntityById(tool.id);
      expect(toolFetched!.locationId, equals('loc-workshop'));

      // Move Box to new location 'loc-garage'
      final locGarage = LocationNode(id: 'loc-garage', name: 'Garaje', createdAt: DateTime.now());
      await locationRepo.saveNode(locGarage);
      await entityRepo.moveEntity(box.id, 'loc-garage');

      // Tool should automatically follow Box to 'loc-garage' without explicit DB update
      final toolAfterBoxMove = await entityRepo.getEntityById(tool.id);
      expect(toolAfterBoxMove!.locationId, equals('loc-garage'));

      // Test Single Active Container Rule: Put tool into another container Box 2
      final box2 = await entityRepo.instantiateOrMerge(boxSpecies.id, 'loc-workshop', 1);
      final rel2 = EntityRelation(
        id: 'rel-guardado-2',
        sourceEntityId: tool.id,
        targetEntityId: box2.id,
        relationType: 'GUARDADO_EN',
        createdAt: DateTime.now(),
      );
      await relationRepo.addRelation(rel2);

      // Previous relation rel1 should be automatically replaced
      final toolRels = await relationRepo.getRelationsForEntity(tool.id);
      final activeInheriting = toolRels.where((r) => r.sourceEntityId == tool.id && r.relationType == 'GUARDADO_EN');
      expect(activeInheriting.length, equals(1));
      expect(activeInheriting.first.targetEntityId, equals(box2.id));

      // Test Cycle Prevention: Try to put Box 2 inside Tool (Tool is in Box 2)
      final cycleRel = EntityRelation(
        id: 'rel-cycle',
        sourceEntityId: box2.id,
        targetEntityId: tool.id,
        relationType: 'GUARDADO_EN',
        createdAt: DateTime.now(),
      );
      expect(() async => await relationRepo.addRelation(cycleRel), throwsA(isA<Exception>()));

      // Test Unlink Stamping: Delete relation rel2
      await relationRepo.deleteRelation(rel2.id);

      // Tool should now retain Box 2's current location ('loc-workshop') in instance_locations
      final toolUnlinked = await entityRepo.getEntityById(tool.id);
      expect(toolUnlinked!.locationId, equals('loc-workshop'));
    });

    test('5. Cascading Demographic Removal & Batch Operations', () async {
      final species = await catalogRepo.getOrCreateSpecies('Pila AA', type: 'Objeto');

      // Create 3 instances with note "Batería Marca A"
      final e1 = await entityRepo.instantiateOrMerge(species.id, null, 1, notes: 'Batería Marca A');
      final e2 = await entityRepo.instantiateOrMerge(species.id, null, 1, notes: 'Batería Marca A');
      final e3 = await entityRepo.instantiateOrMerge(species.id, null, 1, notes: 'Batería Marca A');

      // Create 2 instances with note "Batería Marca B"
      await entityRepo.instantiateOrMerge(species.id, null, 1, notes: 'Batería Marca B');
      await entityRepo.instantiateOrMerge(species.id, null, 1, notes: 'Batería Marca B');

      final allEntities = await entityRepo.getAllEntities();
      final group = EffectiveEntityGroup.groupEntities(
        entities: allEntities,
        effectiveLocationMap: {for (var e in allEntities) e.id: e.locationId},
      ).firstWhere((g) => g.speciesId == species.id);

      expect(group.population, equals(5));
      expect(group.majorityInstances.length, equals(3));
      expect(group.majorityEntity.notes, equals('Batería Marca A'));

      // Test cascading removal of 4 instances (should exhaust all 3 Marca A + 1 Marca B)
      final idsToRemove = QuantityOperationHelper.getCascadingRemovalIds(group, 4);
      expect(idsToRemove.length, equals(4));
      expect(idsToRemove.contains(e1.id), isTrue);
      expect(idsToRemove.contains(e2.id), isTrue);
      expect(idsToRemove.contains(e3.id), isTrue);

      await entityRepo.deleteEntitiesBatch(idsToRemove);

      final remaining = await entityRepo.getAllEntities();
      final remainingSpecies = remaining.where((e) => e.speciesId == species.id).toList();
      expect(remainingSpecies.length, equals(1));
      expect(remainingSpecies.first.notes, equals('Batería Marca B'));
    });

    test('6. 4NF Subspecies, NECESITA Requirements & Effective Breadcrumbs with "@"', () async {
      // 1. Create Species & Subspecies
      final fridgeSpecies = await catalogRepo.getOrCreateSpecies('Refrigerador', type: 'Objeto');
      final eggSpecies = await catalogRepo.getOrCreateSpecies('Huevo', type: 'Objeto');

      final duracellSub = Subspecies(
        id: 'sub-duracell',
        speciesId: fridgeSpecies.id,
        subspeciesName: 'Inverter Dual Door',
        brand: 'LG',
        barcode: '750987654321',
        createdAt: DateTime.now(),
      );
      await catalogRepo.saveSubspecies(duracellSub);

      final fetchedSubs = await catalogRepo.getSubspeciesForSpecies(fridgeSpecies.id);
      expect(fetchedSubs.length, equals(2)); // Default "Genérica" + "Inverter Dual Door"
      expect(fetchedSubs.any((s) => s.brand == 'LG'), isTrue);

      // 2. NECESITA Requirement: Refrigerador NECESITA 6 Huevo (even with 0 egg instances!)
      final req = SpeciesRequirement(
        id: 'req-fridge-egg',
        sourceId: fridgeSpecies.id,
        sourceType: 'species',
        requiredSpeciesId: eggSpecies.id,
        requiredQuantity: 6,
        notes: 'Insumo alimenticio básico',
        createdAt: DateTime.now(),
      );
      await catalogRepo.saveRequirement(req);

      final fetchedReqs = await catalogRepo.getRequirementsForSource(fridgeSpecies.id);
      expect(fetchedReqs.length, equals(1));
      expect(fetchedReqs.first.requiredQuantity, equals(6));

      // 3. Effective Location Breadcrumb with "@"
      final houseNode = LocationNode(id: 'loc-house', name: 'Casa', createdAt: DateTime.now());
      final kitchenNode = LocationNode(id: 'loc-kitchen', name: 'Cocina', parentLocationId: 'loc-house', createdAt: DateTime.now());

      await locationRepo.saveNode(houseNode);
      await locationRepo.saveNode(kitchenNode);

      final fridgeInstance = await entityRepo.instantiateOrMerge(fridgeSpecies.id, 'loc-kitchen', 1, subspeciesId: duracellSub.id);
      expect(fridgeInstance.subspeciesId, equals('sub-duracell'));

      final eggInstance = await entityRepo.instantiateOrMerge(eggSpecies.id, null, 1);
      final guardadoRel = EntityRelation(
        id: 'rel-egg-fridge',
        sourceEntityId: eggInstance.id,
        targetEntityId: fridgeInstance.id,
        relationType: 'GUARDADO_EN',
        createdAt: DateTime.now(),
      );
      await relationRepo.addRelation(guardadoRel);

      final allEntities = await entityRepo.getAllEntities();
      final allNodes = await locationRepo.getAllNodes();

      final effectiveBreadcrumb = LocationPathHelper.buildEffectiveBreadcrumb(
        entityId: eggInstance.id,
        effectiveLocationId: fridgeInstance.locationId,
        allEntities: allEntities,
        allRelations: [guardadoRel],
        allNodes: allNodes,
        catalogItems: [fridgeSpecies, eggSpecies],
      );

      expect(effectiveBreadcrumb.ancestorPath, contains('Casa > Cocina @'));
      expect(effectiveBreadcrumb.targetName, contains('Refrigerador'));
    });

    test('7. Subspecies Photo Fallback to Species Photo', () {
      final species = CatalogItem(
        id: 'sp-1',
        name: 'Pila AA',
        type: 'Objeto',
        mainPhotoPath: 'species/default.jpg',
        createdAt: DateTime.now(),
      );

      final subWithoutPhoto = Subspecies(
        id: 'sub-1',
        speciesId: 'sp-1',
        subspeciesName: 'Duracell Ultra',
        photoPath: null,
        createdAt: DateTime.now(),
      );

      final subWithPhoto = Subspecies(
        id: 'sub-2',
        speciesId: 'sp-1',
        subspeciesName: 'PowerA Rechargeable',
        photoPath: 'subspecies/powera.jpg',
        createdAt: DateTime.now(),
      );

      expect(subWithoutPhoto.resolvePhotoPath(species.mainPhotoPath), equals('species/default.jpg'));
      expect(subWithPhoto.resolvePhotoPath(species.mainPhotoPath), equals('subspecies/powera.jpg'));
    });

    test('8. Unique Species evaluated per Subspecies', () async {
      final species = await catalogRepo.getOrCreateSpecies('Gato', type: 'Mascota', isUnique: true);

      final subPancho = Subspecies(
        id: 'sub-pancho',
        speciesId: species.id,
        subspeciesName: 'Pancho',
        createdAt: DateTime.now(),
      );
      final subMino = Subspecies(
        id: 'sub-mino',
        speciesId: species.id,
        subspeciesName: 'Mino',
        createdAt: DateTime.now(),
      );
      await catalogRepo.saveSubspecies(subPancho);
      await catalogRepo.saveSubspecies(subMino);

      // Instantiate Pancho (1st time -> allowed)
      final pancho = await entityRepo.instantiateOrMerge(species.id, null, 1, subspeciesId: subPancho.id);
      expect(pancho, isNotNull);

      // Instantiate Mino (1st time for Mino -> allowed even though Gato is unique species)
      final mino = await entityRepo.instantiateOrMerge(species.id, null, 1, subspeciesId: subMino.id);
      expect(mino, isNotNull);

      final allGatos = (await entityRepo.getAllEntities()).where((e) => e.speciesId == species.id).toList();
      expect(allGatos.length, equals(2));
    });

    test('9. Single Subspecies Deletion Protection and Non-Object Brand/Barcode Stripping', () async {
      final plantSpecies = await catalogRepo.getOrCreateSpecies('Planta Rosada', type: 'Ser Vivo', isUnique: false);
      final sub1 = Subspecies(
        id: 'sub-plant-1',
        speciesId: plantSpecies.id,
        subspeciesName: 'Orquídea',
        brand: 'IllegalBrand',
        barcode: '123456',
        createdAt: DateTime.now(),
      );
      await catalogRepo.saveSubspecies(sub1);

      // Verify Brand and Barcode were stripped for Ser Vivo
      final savedSub1 = await catalogRepo.getSubspeciesById(sub1.id);
      expect(savedSub1?.brand, isNull);
      expect(savedSub1?.barcode, isNull);

      // Verify deletion protection for single subspecies
      final plantSubspecies = await catalogRepo.getSubspeciesForSpecies(plantSpecies.id);
      expect(plantSubspecies.length, equals(2)); // "Genérica" + sub1

      // Delete sub1 (allowed because length > 1)
      await catalogRepo.deleteSubspecies(sub1.id);
      expect((await catalogRepo.getSubspeciesForSpecies(plantSpecies.id)).length, equals(1));

      // Attempt deleting the last remaining subspecies (should throw)
      final lastSub = (await catalogRepo.getSubspeciesForSpecies(plantSpecies.id)).first;
      expect(
        () async => await catalogRepo.deleteSubspecies(lastSub.id),
        throwsA(isA<Exception>()),
      );
    });

    test('10. Deletion Protection for Species/Subspecies with Active Instances & SI Unit Property Name Prepopulation', () async {
      final species = await catalogRepo.getOrCreateSpecies('Televisor', type: 'Objeto');
      final sub = Subspecies(
        id: 'sub-tv-sony',
        speciesId: species.id,
        subspeciesName: 'Bravia 4K',
        brand: 'Sony',
        createdAt: DateTime.now(),
      );
      await catalogRepo.saveSubspecies(sub);

      // Instantiate Televisor with sub
      final inst = await entityRepo.instantiateOrMerge(species.id, null, 1, subspeciesId: sub.id);
      expect(inst, isNotNull);

      // Deleting Subspecies with active instances should throw exception
      expect(
        () async => await catalogRepo.deleteSubspecies(sub.id),
        throwsA(isA<Exception>()),
      );

      // Deleting Species with active instances should throw exception
      expect(
        () async => await catalogRepo.deleteCatalogItem(species.id),
        throwsA(isA<Exception>()),
      );

      // SI Unit property name prepopulation suggestions
      expect(DomainRules.suggestPropertyNameForUnit('kg'), equals('Masa'));
      expect(DomainRules.suggestPropertyNameForUnit('L'), equals('Volumen'));
      expect(DomainRules.suggestPropertyNameForUnit('m'), equals('Longitud'));
      expect(DomainRules.suggestPropertyNameForUnit('s'), equals('Tiempo'));
      expect(DomainRules.suggestPropertyNameForUnit('A'), equals('Corriente eléctrica'));
      expect(DomainRules.suggestPropertyNameForUnit('V'), equals('Voltaje'));
      expect(DomainRules.suggestPropertyNameForUnit('\$'), equals('Precio'));
    });

    test('11. EntityDisplayHelper Specific Subspecies Resolution Test', () async {
      final species = await catalogRepo.getOrCreateSpecies('Caja', type: 'Objeto');
      final subSpecific = Subspecies(
        id: 'sub-caja-metal',
        speciesId: species.id,
        subspeciesName: 'Caja Metálica',
        brand: 'Stanley',
        createdAt: DateTime.now(),
      );
      final subGeneric = Subspecies(
        id: 'sub-caja-gen',
        speciesId: species.id,
        subspeciesName: 'Genérica',
        createdAt: DateTime.now(),
      );
      await catalogRepo.saveSubspecies(subSpecific);
      await catalogRepo.saveSubspecies(subGeneric);

      final specificEntity = await entityRepo.instantiateOrMerge(species.id, null, 1, subspeciesId: subSpecific.id);
      final genericEntity = await entityRepo.instantiateOrMerge(species.id, null, 1, subspeciesId: subGeneric.id);
      final noSubEntity = await entityRepo.instantiateOrMerge(species.id, null, 1);

      final allSubspecies = await catalogRepo.getAllSubspecies();
      final allCatalog = await catalogRepo.getAllCatalogItems();

      final specificName = EntityDisplayHelper.getDisplayName(
        entity: specificEntity,
        catalogItems: allCatalog,
        subspeciesList: allSubspecies,
      );
      final genericName = EntityDisplayHelper.getDisplayName(
        entity: genericEntity,
        catalogItems: allCatalog,
        subspeciesList: allSubspecies,
      );
      final noSubName = EntityDisplayHelper.getDisplayName(
        entity: noSubEntity,
        catalogItems: allCatalog,
        subspeciesList: allSubspecies,
      );

      expect(specificName, equals('Caja Metálica (Stanley)'));
      expect(genericName, equals('Caja'));
      expect(noSubName, equals('Caja'));
    });
  });
}
