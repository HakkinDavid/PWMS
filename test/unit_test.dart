import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:platinum_world_management_system/src/core/database/app_database.dart';
import 'package:platinum_world_management_system/src/features/entities/domain/entity_template.dart';
import 'package:platinum_world_management_system/src/features/entities/domain/world_entity.dart';
import 'package:platinum_world_management_system/src/features/entities/infrastructure/entity_repository.dart';
import 'package:platinum_world_management_system/src/features/places/domain/place.dart';
import 'package:platinum_world_management_system/src/features/places/infrastructure/place_repository.dart';
import 'package:platinum_world_management_system/src/features/relations/domain/entity_relation.dart';
import 'package:platinum_world_management_system/src/features/relations/infrastructure/relation_repository.dart';
import 'package:platinum_world_management_system/src/features/history/infrastructure/history_repository.dart';
import 'package:platinum_world_management_system/src/features/history/application/activity_logger_service.dart';

void main() {
  late AppDatabase db;
  late EntityRepository entityRepo;
  late PlaceRepository placeRepo;
  late RelationRepository relationRepo;
  late HistoryRepository historyRepo;
  late ActivityLoggerService loggerService;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    db = AppDatabase(NativeDatabase.memory());
    entityRepo = EntityRepository(db);
    placeRepo = PlaceRepository(db);
    relationRepo = RelationRepository(db);
    historyRepo = HistoryRepository(db);
    loggerService = ActivityLoggerService(historyRepo);
  });

  tearDown(() async {
    await db.close();
  });

  group('PWMS Living Domain Model Tests', () {
    test('Create and retrieve Place & Container templates', () async {
      final place = Place(
        id: 'place-1',
        name: 'Taller Principal',
        description: 'Zona de herramientas',
        createdAt: DateTime.now(),
      );

      await placeRepo.savePlace(place);
      final retrieved = await placeRepo.getPlaceById('place-1');

      expect(retrieved, isNotNull);
      expect(retrieved!.name, equals('Taller Principal'));

      final boxTemplate = EntityTemplateRegistry.getTemplate('Caja / Contenedor');
      expect(boxTemplate.isContainer, isTrue);
      expect(boxTemplate.primaryView, equals(TemplateViewKind.contents));
    });

    test('Hierarchical containment and cascade movement', () async {
      // Create Place: Taller
      final place = Place(id: 'place-taller', name: 'Taller', createdAt: DateTime.now());
      await placeRepo.savePlace(place);

      // Create Container: Caja Roja inside Taller
      final containerBox = WorldEntity(
        id: 'box-1',
        name: 'Caja Roja',
        type: 'Caja / Contenedor',
        placeId: 'place-taller',
        isContainer: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await entityRepo.saveEntity(containerBox);

      // Create Item: Taladro inside Caja Roja
      final itemDrill = WorldEntity(
        id: 'drill-1',
        name: 'Taladro Bosch',
        type: 'Herramienta',
        parentEntityId: 'box-1',
        placeId: 'place-taller',
        quantity: 1,
        unit: 'pieza',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await entityRepo.saveEntity(itemDrill);

      // Verify drill is inside Caja Roja
      final contentsOfBox = await entityRepo.getEntitiesByParent('box-1');
      expect(contentsOfBox.length, equals(1));
      expect(contentsOfBox.first.name, equals('Taladro Bosch'));

      // Move Caja Roja to Estudio
      final newPlace = Place(id: 'place-estudio', name: 'Estudio', createdAt: DateTime.now());
      await placeRepo.savePlace(newPlace);

      await entityRepo.moveEntity('box-1', newPlaceId: 'place-estudio');

      // Verify cascade movement updated child Taladro Bosch placeId to Estudio automatically!
      final movedDrill = await entityRepo.getEntityById('drill-1');
      expect(movedDrill!.placeId, equals('place-estudio'));
    });

    test('Directed semantic relationships', () async {
      final docEntity = WorldEntity(
        id: 'doc-1',
        name: 'Manual PDF Taladro',
        type: 'Documento',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final toolEntity = WorldEntity(
        id: 'tool-1',
        name: 'Taladro Bosch',
        type: 'Herramienta',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await entityRepo.saveEntity(docEntity);
      await entityRepo.saveEntity(toolEntity);

      // Establish directed relation: Manual PDF DOCUMENTA Taladro Bosch
      final relation = EntityRelation(
        id: 'rel-1',
        sourceEntityId: 'doc-1',
        targetEntityId: 'tool-1',
        relationType: 'DOCUMENTA',
        createdAt: DateTime.now(),
      );

      await relationRepo.addRelation(relation);

      final relations = await relationRepo.getRelationsForEntity('doc-1');
      expect(relations.length, equals(1));
      expect(relations.first.sourceEntityId, equals('doc-1'));
      expect(relations.first.targetEntityId, equals('tool-1'));
      expect(relations.first.relationType, equals('DOCUMENTA'));
    });

    test('Complete event audit trail', () async {
      await loggerService.logEntityCreated('ent-1', 'Batería 18V', 'Herramienta');
      await loggerService.logPhotoChanged('ent-1', 'Batería 18V');
      await loggerService.logQuantityConsumed('ent-1', 'Batería 18V', 5, 'piezas');
      await loggerService.logEntityDeleted('ent-1', 'Batería 18V');

      final events = await historyRepo.getRecentEvents(limit: 10);
      expect(events.length, equals(4));
      expect(events.any((e) => e.eventType == 'creation'), isTrue);
      expect(events.any((e) => e.eventType == 'photo_changed'), isTrue);
      expect(events.any((e) => e.eventType == 'consumption'), isTrue);
      expect(events.any((e) => e.eventType == 'deletion'), isTrue);
    });
  });
}
