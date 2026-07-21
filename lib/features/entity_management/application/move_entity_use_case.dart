import '../../../core/domain/entities/entity.dart';
import '../../../core/domain/entities/entity_id.dart';
import '../../../core/domain/events/domain_event.dart';
import '../../../core/domain/repositories/entity_repository.dart';
import '../../../core/domain/repositories/event_repository.dart';
import 'get_location_path_use_case.dart';

/// Caso de uso que ejecuta la acción "Mover Entidad" entre contenedores.
class MoveEntityUseCase {
  final EntityRepository _entityRepository;
  final EventRepository _eventRepository;
  final GetLocationPathUseCase _getLocationPathUseCase;

  MoveEntityUseCase({
    required EntityRepository entityRepository,
    required EventRepository eventRepository,
    required GetLocationPathUseCase getLocationPathUseCase,
  })  : _entityRepository = entityRepository,
        _eventRepository = eventRepository,
        _getLocationPathUseCase = getLocationPathUseCase;

  Future<Entity> execute({
    required EntityId entityId,
    required EntityId? newParentId,
  }) async {
    final entity = await _entityRepository.findById(entityId);
    if (entity == null) {
      throw StateError('La entidad con ID $entityId no existe.');
    }

    // Validación contra ciclo: No se puede mover una entidad dentro de sí misma
    if (newParentId != null) {
      if (newParentId == entityId) {
        throw ArgumentError('Una entidad no puede contenerse a sí misma.');
      }

      final targetPath = await _getLocationPathUseCase.execute(newParentId);
      final isDescendant = targetPath.any((e) => e.id == entityId);
      if (isDescendant) {
        throw ArgumentError('No se puede mover un contenedor dentro de uno de sus descendientes.');
      }
    }

    final previousParentId = entity.parentId;
    final updatedEntity = entity.copyWith(parentId: newParentId);

    await _entityRepository.save(updatedEntity);

    // Registro silencioso del evento auditable
    await _eventRepository.record(DomainEvent.create(
      type: 'entity_moved',
      entityId: entityId,
      payload: {
        'previous_parent_id': previousParentId?.value,
        'new_parent_id': newParentId?.value,
        'name': entity.name,
      },
    ));

    return updatedEntity;
  }
}
