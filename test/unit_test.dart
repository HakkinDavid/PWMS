import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:platinum_world_management_system/src/core/database/app_database.dart';
import 'package:platinum_world_management_system/src/features/entities/domain/world_entity.dart';
import 'package:platinum_world_management_system/src/features/entities/infrastructure/entity_repository.dart';
import 'package:platinum_world_management_system/src/features/places/domain/place.dart';
import 'package:platinum_world_management_system/src/features/places/infrastructure/place_repository.dart';
import 'package:platinum_world_management_system/src/features/relations/domain/entity_relation.dart';
import 'package:platinum_world_management_system/src/features/relations/infrastructure/relation_repository.dart';
import 'package:platinum_world_management_system/src/features/history/domain/activity_event.dart';
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

  group('PWMS Core Unit Tests', () {
    test('Create and retrieve Place', () async {
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
    });

    test('Create entity and perform instant search', () async {
      final entity = WorldEntity(
        id: 'entity-1',
        name: 'Multímetro Fluke 87V',
        type: 'Herramienta',
        tags: ['electrónica', 'medición'],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await entityRepo.saveEntity(entity);
      await loggerService.logEntityCreated(entity.id, entity.name, entity.type);

      final searchResults = await entityRepo.searchEntities('multímetro');
      expect(searchResults.length, equals(1));
      expect(searchResults.first.name, contains('Multímetro'));

      final tagResults = await entityRepo.searchEntities('electrónica');
      expect(tagResults.length, equals(1));

      final history = await historyRepo.getRecentEvents();
      expect(history.length, equals(1));
      expect(history.first.description, contains('Multímetro Fluke 87V'));
    });

    test('Entity movement logs automatic activity event', () async {
      final entity = WorldEntity(
        id: 'entity-2',
        name: 'Taladro Bosch',
        type: 'Herramienta',
        placeId: 'place-1',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await entityRepo.saveEntity(entity);

      await loggerService.logEntityMoved('entity-2', 'Taladro Bosch', 'Taller', 'Garaje');

      final events = await historyRepo.getEventsForEntity('entity-2');
      expect(events.length, equals(1));
      expect(events.first.eventType, equals('movement'));
      expect(events.first.description, contains('Trasladado "Taladro Bosch"'));
    });

    test('Relate two entities', () async {
      final relation = EntityRelation(
        id: 'rel-1',
        sourceEntityId: 'entity-1',
        targetEntityId: 'entity-2',
        relationType: 'asociado a',
        createdAt: DateTime.now(),
      );

      await relationRepo.addRelation(relation);
      final relations = await relationRepo.getRelationsForEntity('entity-1');

      expect(relations.length, equals(1));
      expect(relations.first.relationType, equals('asociado a'));
    });
  });
}
