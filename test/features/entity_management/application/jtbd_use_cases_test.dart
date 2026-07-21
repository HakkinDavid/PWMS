import 'package:flutter_test/flutter_test.dart';
import 'package:platinum_world_management_system/core/domain/entities/entity.dart';
import 'package:platinum_world_management_system/core/domain/entities/entity_id.dart';
import 'package:platinum_world_management_system/core/domain/value_objects/attribute_key.dart';
import 'package:platinum_world_management_system/core/domain/value_objects/attribute_value.dart';
import 'package:platinum_world_management_system/features/entity_management/application/get_location_path_use_case.dart';
import 'package:platinum_world_management_system/features/entity_management/application/move_entity_use_case.dart';
import 'package:platinum_world_management_system/features/entity_management/application/search_entities_with_location_use_case.dart';
import '../../../fakes/in_memory_entity_repository.dart';
import '../../../fakes/in_memory_event_repository.dart';

void main() {
  late InMemoryEntityRepository entityRepository;
  late InMemoryEventRepository eventRepository;
  late GetLocationPathUseCase getLocationPathUseCase;
  late SearchEntitiesWithLocationUseCase searchUseCase;
  late MoveEntityUseCase moveEntityUseCase;

  setUp(() {
    entityRepository = InMemoryEntityRepository();
    eventRepository = InMemoryEventRepository();
    getLocationPathUseCase = GetLocationPathUseCase(entityRepository);
    searchUseCase = SearchEntitiesWithLocationUseCase(
      entityRepository: entityRepository,
      getLocationPathUseCase: getLocationPathUseCase,
    );
    moveEntityUseCase = MoveEntityUseCase(
      entityRepository: entityRepository,
      eventRepository: eventRepository,
      getLocationPathUseCase: getLocationPathUseCase,
    );
  });

  group('JTBD Use Cases Tests: Encontrar cualquier objeto en <10s', () {
    test('Calcula la miga de pan completa de ubicación (Raíz -> Casa -> Garaje -> Caja -> Taladro)',
        () async {
      final casa = Entity(
        id: EntityId.generate(),
        attributes: {AttributeKey.name: AttributeValue.string('Mi Casa')},
      );
      final garaje = Entity(
        id: EntityId.generate(),
        parentId: casa.id,
        attributes: {AttributeKey.name: AttributeValue.string('Garaje')},
      );
      final caja = Entity(
        id: EntityId.generate(),
        parentId: garaje.id,
        attributes: {AttributeKey.name: AttributeValue.string('Caja A1')},
      );
      final taladro = Entity(
        id: EntityId.generate(),
        parentId: caja.id,
        attributes: {AttributeKey.name: AttributeValue.string('Taladro Bosch')},
      );

      await entityRepository.save(casa);
      await entityRepository.save(garaje);
      await entityRepository.save(caja);
      await entityRepository.save(taladro);

      final path = await getLocationPathUseCase.execute(taladro.id);

      expect(path.length, 4);
      expect(path[0].name, 'Mi Casa');
      expect(path[1].name, 'Garaje');
      expect(path[2].name, 'Caja A1');
      expect(path[3].name, 'Taladro Bosch');
    });

    test('Búsqueda global ubica el objeto y muestra la ruta exacta legible', () async {
      final casa = Entity(
        id: EntityId.generate(),
        attributes: {AttributeKey.name: AttributeValue.string('Mi Casa')},
      );
      final taladro = Entity(
        id: EntityId.generate(),
        parentId: casa.id,
        attributes: {AttributeKey.name: AttributeValue.string('Taladro Bosch')},
      );

      await entityRepository.save(casa);
      await entityRepository.save(taladro);

      final results = await searchUseCase.execute('tala');

      expect(results.length, 1);
      expect(results.first.entity.name, 'Taladro Bosch');
      expect(results.first.locationDisplayPath, 'Mi Casa');
    });

    test('MoveEntityUseCase cambia la ubicación y registra evento auditable', () async {
      final casa = Entity(
        id: EntityId.generate(),
        attributes: {AttributeKey.name: AttributeValue.string('Casa')},
      );
      final taller = Entity(
        id: EntityId.generate(),
        attributes: {AttributeKey.name: AttributeValue.string('Taller')},
      );
      final taladro = Entity(
        id: EntityId.generate(),
        parentId: casa.id,
        attributes: {AttributeKey.name: AttributeValue.string('Taladro')},
      );

      await entityRepository.save(casa);
      await entityRepository.save(taller);
      await entityRepository.save(taladro);

      final moved = await moveEntityUseCase.execute(
        entityId: taladro.id,
        newParentId: taller.id,
      );

      expect(moved.parentId, taller.id);

      final events = await eventRepository.findByEntityId(taladro.id);
      expect(events.length, 1);
      expect(events.first.type, 'entity_moved');
      expect(events.first.payload['new_parent_id'], taller.id.value);
    });

    test('Mover valida contra ciclos (previene mover un contenedor a sí mismo)', () async {
      final caja = Entity(
        id: EntityId.generate(),
        attributes: {AttributeKey.name: AttributeValue.string('Caja')},
      );
      await entityRepository.save(caja);

      expect(
        () => moveEntityUseCase.execute(
          entityId: caja.id,
          newParentId: caja.id,
        ),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
