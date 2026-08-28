import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/drift.dart' as drift;
import 'package:uuid/uuid.dart';
import 'package:platinum_world_management_system/src/core/constants/app_technical_strings.dart';
import 'package:platinum_world_management_system/src/core/database/app_database.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/subspecies.dart';
import 'package:platinum_world_management_system/src/features/catalog/infrastructure/catalog_repository.dart';
import 'package:platinum_world_management_system/src/features/entities/infrastructure/entity_repository.dart';
import 'package:platinum_world_management_system/src/features/history/application/activity_logger_service.dart';
import 'package:platinum_world_management_system/src/features/history/application/history_migration_post_processor.dart';
import 'package:platinum_world_management_system/src/features/history/infrastructure/history_repository.dart';
import 'package:platinum_world_management_system/src/features/locations/domain/location_node.dart';
import 'package:platinum_world_management_system/src/features/locations/infrastructure/location_repository.dart';
import 'package:platinum_world_management_system/src/features/relations/domain/entity_relation.dart';
import 'package:platinum_world_management_system/src/features/relations/infrastructure/relation_repository.dart';

void main() {
  late AppDatabase db;
  late HistoryRepository historyRepo;
  late ActivityLoggerService loggerService;
  late CatalogRepository catalogRepo;
  late EntityRepository entityRepo;
  late LocationRepository locationRepo;
  late RelationRepository relationRepo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    historyRepo = HistoryRepository(db);
    loggerService = ActivityLoggerService(historyRepo);
    catalogRepo = CatalogRepository(db, null, loggerService);
    entityRepo = EntityRepository(db, null, loggerService);
    locationRepo = LocationRepository(db, loggerService);
    relationRepo = RelationRepository(db, loggerService);
  });

  tearDown(() async {
    await db.close();
  });

  group('HistoryMigrationPostProcessor (Retroactive Backfill)', () {
    test('retroactively backfills creation events preserving original createdAt', () async {
      final legacyDate = DateTime(2023, 5, 10, 14, 30);

      // Insert legacy records directly into DB without history events
      await db.into(db.catalogTable).insert(CatalogTableCompanion.insert(
        id: 'legacy-sp-1',
        name: 'Moneda Virreinato',
        type: const drift.Value('Numismática'),
        createdAt: legacyDate,
      ));

      await db.into(db.subspeciesTable).insert(SubspeciesTableCompanion.insert(
        id: 'legacy-sub-1',
        speciesId: 'legacy-sp-1',
        subspeciesName: '8 Reales 1790',
        createdAt: legacyDate,
      ));

      await db.into(db.locationsTable).insert(LocationsTableCompanion.insert(
        id: 'legacy-loc-1',
        name: 'Caja Fuerte',
        createdAt: legacyDate,
      ));

      await db.into(db.entitiesTable).insert(EntitiesTableCompanion.insert(
        id: 'legacy-ent-1',
        speciesId: 'legacy-sp-1',
        subspeciesId: const drift.Value('legacy-sub-1'),
        locationId: const drift.Value('legacy-loc-1'),
        createdAt: legacyDate,
        updatedAt: legacyDate,
      ));

      await db.into(db.relationsTable).insert(RelationsTableCompanion.insert(
        id: 'legacy-rel-1',
        sourceEntityId: 'legacy-ent-1',
        targetEntityId: 'legacy-ent-1',
        relationType: 'PARTE_DE',
        createdAt: legacyDate,
      ));

      // Verify history is empty before backfill
      final initialEvents = await historyRepo.getAllEvents();
      expect(initialEvents, isEmpty);

      // Run post-processor
      await const HistoryMigrationPostProcessor().processAfterImport(db);

      // Verify all records generated chronological events
      final events = await historyRepo.getAllEvents();
      expect(events.length, 5);

      // Verify original timestamps were preserved
      for (final evt in events) {
        expect(evt.timestamp, legacyDate);
      }

      // Verify category inference
      final speciesEvents = events.where((e) => e.category == AppTechnicalStrings.categorySpecies).toList();
      expect(speciesEvents.length, 2); // 1 species + 1 subspecies

      final locEvents = events.where((e) => e.category == AppTechnicalStrings.categoryLocation).toList();
      expect(locEvents.length, 1);

      final entEvents = events.where((e) => e.category == AppTechnicalStrings.categoryEntity).toList();
      expect(entEvents.length, 1);

      final relEvents = events.where((e) => e.category == AppTechnicalStrings.categoryRelation).toList();
      expect(relEvents.length, 1);

      // Running again should be idempotent (deduplicated)
      await const HistoryMigrationPostProcessor().processAfterImport(db);
      final eventsAfterSecondRun = await historyRepo.getAllEvents();
      expect(eventsAfterSecondRun.length, 5);
    });
  });

  group('Repository CRUD History Generation', () {
    test('LocationRepository logs creation, movement, edition and deletion', () async {
      final locNode = LocationNode(
        id: 'loc-1',
        name: 'Estantería A',
        createdAt: DateTime.now(),
      );

      await locationRepo.saveNode(locNode);
      var events = await historyRepo.getAllEvents();
      expect(events.length, 1);
      expect(events.first.eventType, AppTechnicalStrings.eventTypeLocationCreation);
      expect(events.first.category, AppTechnicalStrings.categoryLocation);
      expect(events.first.description, contains('Estantería A'));

      // Move node
      final parentNode = LocationNode(id: 'loc-parent', name: 'Bodega Principal', createdAt: DateTime.now());
      await locationRepo.saveNode(parentNode);

      await locationRepo.moveNode('loc-1', 'loc-parent');
      events = await historyRepo.getAllEvents();
      final moveEvt = events.firstWhere((e) => e.eventType == AppTechnicalStrings.eventTypeLocationMovement);
      expect(moveEvt.description, contains('Estantería A'));
      expect(moveEvt.description, contains('Bodega Principal'));

      // Delete node
      await locationRepo.deleteNode('loc-1');
      events = await historyRepo.getAllEvents();
      final delEvt = events.firstWhere((e) => e.eventType == AppTechnicalStrings.eventTypeLocationDeletion);
      expect(delEvt.description, contains('Estantería A'));
    });

    test('CatalogRepository logs species taxonomy lifecycle', () async {
      final sp = await catalogRepo.getOrCreateSpecies('Laptop Lenovo', type: 'Electrónica');
      var events = await historyRepo.getAllEvents();
      expect(events.any((e) => e.eventType == AppTechnicalStrings.eventTypeSpeciesCreation), isTrue);

      // Create 2 Subspecies so original species isn't auto-deleted when separating 1
      final sub1 = Subspecies(
        id: 'sub-test-1',
        speciesId: sp.id,
        subspeciesName: 'Lenovo Legion 5',
        createdAt: DateTime.now(),
      );
      final sub2 = Subspecies(
        id: 'sub-test-2',
        speciesId: sp.id,
        subspeciesName: 'Lenovo IdeaPad 3',
        createdAt: DateTime.now(),
      );
      await catalogRepo.saveSubspecies(sub1);
      await catalogRepo.saveSubspecies(sub2);

      // Separate Subspecies
      final newSp = await catalogRepo.separateSubspecies(sub1.id, 'ThinkPad X1');
      events = await historyRepo.getAllEvents();
      expect(events.any((e) => e.eventType == AppTechnicalStrings.eventTypeSubspeciesSeparation), isTrue);

      // Merge species
      await catalogRepo.mergeSpecies(newSp.id, sp.id);
      events = await historyRepo.getAllEvents();
      expect(events.any((e) => e.eventType == AppTechnicalStrings.eventTypeSpeciesMerge), isTrue);
    });

    test('EntityRepository logs instantiation, update, and batch deletion', () async {
      final sp = await catalogRepo.getOrCreateSpecies('Arroz Integral', type: 'Alimento');
      final entity = await entityRepo.instantiateOrMerge(sp.id, null, 1);

      var events = await historyRepo.getAllEvents();
      expect(events.any((e) => e.eventType == AppTechnicalStrings.eventTypeCreation && e.entityId == entity.id), isTrue);

      // Delete batch
      await entityRepo.deleteEntitiesBatch([entity.id]);
      events = await historyRepo.getAllEvents();
      expect(events.any((e) => e.eventType == AppTechnicalStrings.eventTypeBatchDeletion), isTrue);
    });

    test('RelationRepository logs link addition and removal', () async {
      final sp = await catalogRepo.getOrCreateSpecies('Caja', type: 'Contenedor');
      final box = await entityRepo.instantiateOrMerge(sp.id, null, 1);
      final item = await entityRepo.instantiateOrMerge(sp.id, null, 1);

      final rel = EntityRelation(
        id: const Uuid().v4(),
        sourceEntityId: item.id,
        targetEntityId: box.id,
        relationType: 'GUARDADO_EN',
        createdAt: DateTime.now(),
      );

      await relationRepo.addRelation(rel);
      var events = await historyRepo.getAllEvents();
      expect(events.any((e) => e.eventType == AppTechnicalStrings.eventTypeRelation), isTrue);

      await relationRepo.deleteRelation(rel.id);
      events = await historyRepo.getAllEvents();
      expect(events.any((e) => e.eventType == AppTechnicalStrings.eventTypeRelationRemoved), isTrue);
    });
  });

  group('History Filtering & Search Engine', () {
    test('filters by category and text search query correctly', () async {
      await loggerService.logEntityCreated('ent-1', 'Taladro Percutor', 'Herramienta');
      await loggerService.logSpeciesCreated('sp-1', 'Taladro Percutor', 'Herramienta');
      await loggerService.logLocationCreated('loc-1', 'Taller Mecánico');
      await loggerService.logBackupExported(150);

      // Filter by category: Ubicaciones
      final locEvents = await historyRepo.getEventsFiltered(category: AppTechnicalStrings.categoryLocation);
      expect(locEvents.length, 1);
      expect(locEvents.first.description, contains('Taller Mecánico'));

      // Filter by category: Respaldos
      final backupEvents = await historyRepo.getEventsFiltered(category: AppTechnicalStrings.categoryBackup);
      expect(backupEvents.length, 1);
      expect(backupEvents.first.eventType, AppTechnicalStrings.eventTypeBackupExport);

      // Filter by text search query: 'Taladro'
      final searchTaladro = await historyRepo.getEventsFiltered(query: 'taladro');
      expect(searchTaladro.length, 2);

      // Filter by both category & query
      final filteredSpecific = await historyRepo.getEventsFiltered(
        category: AppTechnicalStrings.categorySpecies,
        query: 'Taladro',
      );
      expect(filteredSpecific.length, 1);
    });
  });
}
