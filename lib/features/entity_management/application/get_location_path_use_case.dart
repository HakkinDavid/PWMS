import '../../../core/domain/entities/entity.dart';
import '../../../core/domain/entities/entity_id.dart';
import '../../../core/domain/repositories/entity_repository.dart';

/// Caso de uso que reconstruye la ruta o miga de pan de ubicación de una entidad desde la raíz del mundo.
class GetLocationPathUseCase {
  final EntityRepository _entityRepository;

  GetLocationPathUseCase(this._entityRepository);

  /// Retorna la lista ordenada de entidades desde el contenedor raíz hasta la entidad dada.
  Future<List<Entity>> execute(EntityId entityId) async {
    final path = <Entity>[];
    final visited = <EntityId>{};

    EntityId? currentId = entityId;

    while (currentId != null && !visited.contains(currentId)) {
      visited.add(currentId);
      final entity = await _entityRepository.findById(currentId);
      if (entity == null) break;

      path.insert(0, entity);
      currentId = entity.parentId;
    }

    return path;
  }
}
