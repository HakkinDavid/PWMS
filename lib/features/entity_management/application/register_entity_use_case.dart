import '../../../core/domain/entities/entity.dart';
import '../../../core/domain/entities/entity_id.dart';
import '../../../core/domain/events/domain_event.dart';
import '../../../core/domain/repositories/entity_repository.dart';
import '../../../core/domain/repositories/event_repository.dart';
import '../../../core/domain/templates/template_id.dart';
import '../../../core/domain/value_objects/attribute_key.dart';
import '../../../core/domain/value_objects/attribute_value.dart';

/// Caso de uso para registrar una nueva entidad en el mundo del usuario.
///
/// Diseñado para ser ejecutado en menos de 30 segundos con información mínima.
class RegisterEntityUseCase {
  final EntityRepository _entityRepository;
  final EventRepository? _eventRepository;

  RegisterEntityUseCase(
    this._entityRepository, [
    this._eventRepository,
  ]);

  /// Ejecuta la acción de registrar una entidad.
  Future<Entity> execute({
    required String name,
    String? kind,
    EntityId? parentId,
    Map<AttributeKey, AttributeValue>? extraAttributes,
    TemplateId? templateId,
  }) async {
    final cleanName = name.trim();
    if (cleanName.isEmpty) {
      throw ArgumentError('El nombre de la entidad no puede estar vacío');
    }

    final entityId = EntityId.generate();
    final attributes = Map<AttributeKey, AttributeValue>.from(extraAttributes ?? {});
    attributes[AttributeKey.name] = AttributeValue.string(cleanName);
    attributes[AttributeKey.kind] = AttributeValue.string(kind ?? 'object');

    final entity = Entity(
      id: entityId,
      templateId: templateId,
      parentId: parentId,
      attributes: attributes,
    );

    await _entityRepository.save(entity);

    // Registro silencioso del evento auditable
    if (_eventRepository != null) {
      await _eventRepository.record(DomainEvent.create(
        type: 'entity_created',
        entityId: entityId,
        payload: {
          'name': cleanName,
          'parent_id': parentId?.value,
        },
      ));
    }

    return entity;
  }
}
