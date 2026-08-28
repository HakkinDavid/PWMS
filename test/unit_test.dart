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
import 'package:platinum_world_management_system/src/features/control_center/domain/audit_rule_strategy.dart';
import 'package:platinum_world_management_system/src/features/control_center/domain/strategies/governance_audit_rules.dart';

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
      expect(DomainRules.isIntegerUnit('unidad'), isTrue);

      // Integer Formatting without .0 for whole numbers
      expect(DomainRules.formatMagnitude(5.0, 'kg'), equals('5'));
      expect(DomainRules.formatMagnitude(0.0, 'kg'), equals('0'));
      expect(DomainRules.formatMagnitude(2.5, 'kg'), equals('2.5'));
      expect(DomainRules.formatMagnitude(10.0, 'unidad'), equals('10'));
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

    test('5. Homogeneous Group Rules & Batch Operations', () async {
      final species = await catalogRepo.getOrCreateSpecies('Pila AA', type: 'Objeto');

      // Create 3 identical instances
      final e1 = await entityRepo.instantiateOrMerge(species.id, null, 1, notes: 'Serie A');
      final e2 = await entityRepo.instantiateOrMerge(species.id, null, 1, notes: 'Serie A');
      final e3 = await entityRepo.instantiateOrMerge(species.id, null, 1, notes: 'Serie A');

      // Create 1 instance with different note
      final e4 = await entityRepo.instantiateOrMerge(species.id, null, 1, notes: 'Serie B');

      final allEntities = await entityRepo.getAllEntities();
      final groups = EffectiveEntityGroup.groupEntities(
        entities: allEntities,
        effectiveLocationMap: {for (var e in allEntities) e.id: e.locationId},
      ).where((g) => g.speciesId == species.id).toList();

      expect(groups.length, equals(2));
      final serieAGroup = groups.firstWhere((g) => g.primaryEntity.notes == 'Serie A');
      expect(serieAGroup.population, equals(3));
      expect(serieAGroup.isHomogeneous, isTrue);

      final idsToRemove = [e1.id, e2.id, e3.id];
      await entityRepo.deleteEntitiesBatch(idsToRemove);

      final remaining = await entityRepo.getAllEntities();
      final remainingSpecies = remaining.where((e) => e.speciesId == species.id).toList();
      expect(remainingSpecies.length, equals(1));
      expect(remainingSpecies.first.id, equals(e4.id));
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
      expect(fetchedSubs.length, equals(1)); // "Inverter Dual Door" (no automatic "Genérica")
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

    test('9. Subspecies Deletion and Non-Object Brand/Barcode Handling', () async {
      final plantSpecies = await catalogRepo.getOrCreateSpecies('Planta Rosada', type: 'Ser Vivo', isUnique: false);
      final sub1 = Subspecies(
        id: 'sub-plant-1',
        speciesId: plantSpecies.id,
        subspeciesName: 'Orquídea',
        brand: 'SpecialBrand',
        barcode: '123456',
        createdAt: DateTime.now(),
      );
      final sub2 = Subspecies(
        id: 'sub-plant-2',
        speciesId: plantSpecies.id,
        subspeciesName: 'Rosa',
        createdAt: DateTime.now(),
      );
      await catalogRepo.saveSubspecies(sub1);
      await catalogRepo.saveSubspecies(sub2);

      // Verify Brand and Barcode are preserved
      final savedSub1 = await catalogRepo.getSubspeciesById(sub1.id);
      expect(savedSub1?.brand, equals('SpecialBrand'));
      expect(savedSub1?.barcode, equals('123456'));

      // Verify deletion
      final plantSubspecies = await catalogRepo.getSubspeciesForSpecies(plantSpecies.id);
      expect(plantSubspecies.length, equals(2)); // sub1 + sub2

      // Delete sub1 (allowed because length > 1)
      await catalogRepo.deleteSubspecies(sub1.id);
      expect((await catalogRepo.getSubspeciesForSpecies(plantSpecies.id)).length, equals(1));

      // Attempt deleting the last remaining subspecies when allowOnlySubspecies is false (should throw)
      final lastSub = (await catalogRepo.getSubspeciesForSpecies(plantSpecies.id)).first;
      expect(
        () async => await catalogRepo.deleteSubspecies(lastSub.id, allowOnlySubspecies: false),
        throwsA(isA<Exception>()),
      );

      // Deleting last remaining subspecies when allowOnlySubspecies is true succeeds
      await catalogRepo.deleteSubspecies(lastSub.id, allowOnlySubspecies: true);
      expect((await catalogRepo.getSubspeciesForSpecies(plantSpecies.id)), isEmpty);
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
      expect(DomainRules.suggestPropertyNameForUnit('unidad'), equals('Cantidad'));
    });

    test('11. EntityDisplayHelper Specific Subspecies Resolution Test', () async {
      final species = await catalogRepo.getOrCreateSpecies('Caja', type: 'Objeto');
      final subGeneric = Subspecies(
        id: 'sub-caja-gen',
        speciesId: species.id,
        subspeciesName: 'Genérica',
        createdAt: DateTime.now(),
      );
      final subSpecific = Subspecies(
        id: 'sub-caja-metal',
        speciesId: species.id,
        subspeciesName: 'Caja Metálica',
        brand: 'Stanley',
        createdAt: DateTime.now(),
      );
      await catalogRepo.saveSubspecies(subGeneric);
      await catalogRepo.saveSubspecies(subSpecific);

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

    test('12. Automatic Subspecies Resolution on Instantiation Test', () async {
      final species = await catalogRepo.getOrCreateSpecies('Mesa', type: 'Objeto');
      final sub = Subspecies(
        id: 'sub-mesa-madera',
        speciesId: species.id,
        subspeciesName: 'Mesa de Madera',
        createdAt: DateTime.now(),
      );
      await catalogRepo.saveSubspecies(sub);

      // Instantiate without explicitly supplying subspeciesId -> resolves automatically to an existing subspecies of the species
      final inst = await entityRepo.instantiateOrMerge(species.id, null, 1.0);
      expect(inst.subspeciesId, isNotNull);
      final speciesSubspecies = await catalogRepo.getSubspeciesForSpecies(species.id);
      expect(speciesSubspecies.any((s) => s.id == inst.subspeciesId), isTrue);
    });

    test('13. Subgroup Subspecies Preserves Brand and Barcode Data When Provided', () async {
      final docSpecies = await catalogRepo.getOrCreateSpecies('Manual de Usuario', type: 'Documento', isUnique: true);
      final docSub = Subspecies(
        id: 'sub-doc-manual-1',
        speciesId: docSpecies.id,
        subspeciesName: 'Versión 2026',
        brand: 'Editorial Tech',
        barcode: '9780123456789',
        createdAt: DateTime.now(),
      );
      await catalogRepo.saveSubspecies(docSub);

      final savedDocSub = await catalogRepo.getSubspeciesById(docSub.id);
      expect(savedDocSub, isNotNull);
      expect(savedDocSub?.brand, equals('Editorial Tech'));
      expect(savedDocSub?.barcode, equals('9780123456789'));

      final projectSpecies = await catalogRepo.getOrCreateSpecies('Plan Maestro', type: 'Proyecto', isUnique: true);
      final projectSub = Subspecies(
        id: 'sub-proj-1',
        speciesId: projectSpecies.id,
        subspeciesName: 'Fase 1',
        brand: 'CustomBrand',
        barcode: '999999',
        createdAt: DateTime.now(),
      );
      await catalogRepo.saveSubspecies(projectSub);

      final savedProjectSub = await catalogRepo.getSubspeciesById(projectSub.id);
      expect(savedProjectSub, isNotNull);
      expect(savedProjectSub?.brand, equals('CustomBrand'));
      expect(savedProjectSub?.barcode, equals('999999'));
    });

    test('14. DuplicateSpeciesStrategy Detects Homonymous Species', () async {
      final sp1 = CatalogItem(id: 'sp-dup-1', name: 'Tornillo M4', type: 'Objeto', createdAt: DateTime.now());
      final sp2 = CatalogItem(id: 'sp-dup-2', name: 'tornillo m4 ', type: 'Objeto', createdAt: DateTime.now());
      await catalogRepo.saveCatalogItem(sp1);
      await catalogRepo.saveCatalogItem(sp2);

      final allCatalog = await catalogRepo.getAllCatalogItems();
      final context = AuditEvaluationContext(
        db: db,
        allEntities: [],
        allCatalog: allCatalog,
        allSubspecies: [],
        allLocations: [],
        allRelations: [],
      );

      const strategy = DuplicateSpeciesStrategy();
      final cards = await strategy.evaluate(context);
      expect(cards.length, equals(1));
      expect(cards.first.species?.name.toLowerCase(), contains('tornillo m4'));
    });

    test('15. DuplicatePhotoStrategy Detects Shared Species Photos', () async {
      final sp1 = CatalogItem(id: 'sp-ph-1', name: 'Especie Foto 1', type: 'Objeto', mainPhotoPath: 'photos/shared.jpg', createdAt: DateTime.now());
      final sp2 = CatalogItem(id: 'sp-ph-2', name: 'Especie Foto 2', type: 'Objeto', mainPhotoPath: 'photos/shared.jpg', createdAt: DateTime.now());
      await catalogRepo.saveCatalogItem(sp1);
      await catalogRepo.saveCatalogItem(sp2);

      final allCatalog = await catalogRepo.getAllCatalogItems();
      final context = AuditEvaluationContext(
        db: db,
        allEntities: [],
        allCatalog: allCatalog,
        allSubspecies: [],
        allLocations: [],
        allRelations: [],
      );

      const strategy = DuplicatePhotoStrategy();
      final cards = await strategy.evaluate(context);
      expect(cards.length, equals(2));
    });

    test('16. SpeciesWithoutSubspeciesStrategy Detects Empty Species', () async {
      final spEmpty = CatalogItem(id: 'sp-empty-1', name: 'Plantilla Vacía', type: 'Objeto', createdAt: DateTime.now());
      await catalogRepo.saveCatalogItem(spEmpty);

      final allCatalog = await catalogRepo.getAllCatalogItems();
      final allSubs = await catalogRepo.getAllSubspecies();
      final context = AuditEvaluationContext(
        db: db,
        allEntities: [],
        allCatalog: allCatalog,
        allSubspecies: allSubs,
        allLocations: [],
        allRelations: [],
      );

      const strategy = SpeciesWithoutSubspeciesStrategy();
      final cards = await strategy.evaluate(context);
      expect(cards.any((c) => c.species?.id == spEmpty.id), isTrue);
    });

    test('17. UnlinkedInstancesStrategy Detects Instances Missing Valid Subspecies', () async {
      final sp = await catalogRepo.getOrCreateSpecies('Laptop', type: 'Objeto');
      final node = LocationNode(id: 'node-link-1', name: 'Oficina', createdAt: DateTime.now());
      await locationRepo.saveNode(node);

      final entity = await entityRepo.instantiateOrMerge(sp.id, node.id, 1);
      // Update entity to have invalid subspeciesId
      final invalidEntity = entity.copyWith(subspeciesId: 'invalid-sub-id');
      await entityRepo.saveEntity(invalidEntity);

      final allEntities = await entityRepo.getAllEntities();
      final allCatalog = await catalogRepo.getAllCatalogItems();
      final allSubs = await catalogRepo.getAllSubspecies();
      final context = AuditEvaluationContext(
        db: db,
        allEntities: allEntities,
        allCatalog: allCatalog,
        allSubspecies: allSubs,
        allLocations: [node],
        allRelations: [],
      );

      const strategy = UnlinkedInstancesStrategy();
      final cards = await strategy.evaluate(context);
      expect(cards.any((c) => c.entity?.id == entity.id), isTrue);
    });

    test('18. AnomalousExpirationStrategy Detects Incongruous Expiration Dates', () async {
      final sp = await catalogRepo.getOrCreateSpecies('Leche Fresca', type: 'Objeto');
      final node = LocationNode(id: 'node-exp-1', name: 'Cocina', createdAt: DateTime.now());
      await locationRepo.saveNode(node);

      final entityPast = (await entityRepo.instantiateOrMerge(sp.id, node.id, 1)).copyWith(
        expirationDate: DateTime.now().subtract(const Duration(days: 365 * 3)),
      );
      await entityRepo.saveEntity(entityPast);

      final entityFuture = (await entityRepo.instantiateOrMerge(sp.id, node.id, 1)).copyWith(
        id: 'ent-future-exp',
        expirationDate: DateTime.now().add(const Duration(days: 365 * 25)),
      );
      await entityRepo.saveEntity(entityFuture);

      final allEntities = await entityRepo.getAllEntities();
      final allCatalog = await catalogRepo.getAllCatalogItems();
      final allSubs = await catalogRepo.getAllSubspecies();
      final context = AuditEvaluationContext(
        db: db,
        allEntities: allEntities,
        allCatalog: allCatalog,
        allSubspecies: allSubs,
        allLocations: [node],
        allRelations: [],
      );

      const strategy = AnomalousExpirationStrategy();
      final cards = await strategy.evaluate(context);
      expect(cards.length, equals(2));
    });

    test('19. Cascade Deletion of Species and Subspecies with Instances', () async {
      final sp = await catalogRepo.getOrCreateSpecies('Monitor Gaming', type: 'Objeto');
      final sub = Subspecies(id: 'sub-mon-1', speciesId: sp.id, subspeciesName: '240Hz', createdAt: DateTime.now());
      await catalogRepo.saveSubspecies(sub);
      final node = LocationNode(id: 'node-del-1', name: 'Escritorio', createdAt: DateTime.now());
      await locationRepo.saveNode(node);
      await entityRepo.instantiateOrMerge(sp.id, node.id, 2, subspeciesId: sub.id);

      // Attempting delete without cascade throws exception
      expect(() => catalogRepo.deleteCatalogItem(sp.id, cascadeEntities: false), throwsException);
      expect(() => catalogRepo.deleteSubspecies(sub.id, cascadeEntities: false), throwsException);

      // Deleting subspecies with cascadeEntities: true succeeds and removes entities
      await catalogRepo.deleteSubspecies(sub.id, cascadeEntities: true, allowOnlySubspecies: true);
      final remainingEntitiesAfterSub = await entityRepo.getAllEntities();
      expect(remainingEntitiesAfterSub.where((e) => e.subspeciesId == sub.id), isEmpty);

      // Create new sub and entity under sp
      final sub2 = Subspecies(id: 'sub-mon-2', speciesId: sp.id, subspeciesName: '144Hz', createdAt: DateTime.now());
      await catalogRepo.saveSubspecies(sub2);
      await entityRepo.instantiateOrMerge(sp.id, node.id, 1, subspeciesId: sub2.id);

      // Deleting species with cascadeEntities: true succeeds
      await catalogRepo.deleteCatalogItem(sp.id, cascadeEntities: true);
      final remainingSpecies = await catalogRepo.getCatalogItemById(sp.id);
      expect(remainingSpecies, isNull);
      final remainingEntitiesAfterSpecies = await entityRepo.getAllEntities();
      expect(remainingEntitiesAfterSpecies.where((e) => e.speciesId == sp.id), isEmpty);
    });

    test('20. Separate and Move Subspecies Preserves Origin Species in Catalog', () async {
      final spOrigin = await catalogRepo.getOrCreateSpecies('Herramienta Multifunción', type: 'Objeto');
      final sub = Subspecies(id: 'sub-tool-1', speciesId: spOrigin.id, subspeciesName: 'Modelo A', createdAt: DateTime.now());
      await catalogRepo.saveSubspecies(sub);

      // Separate the only subspecies into a new species
      final separatedSpecies = await catalogRepo.separateSubspecies(sub.id, 'Herramienta Nueva');
      expect(separatedSpecies.name, equals('Herramienta Nueva'));

      // Verify origin species was NOT deleted and remains as catalog template
      final fetchedOrigin = await catalogRepo.getCatalogItemById(spOrigin.id);
      expect(fetchedOrigin, isNotNull);
      expect(fetchedOrigin?.name, equals('Herramienta Multifunción'));
    });
  });
}
