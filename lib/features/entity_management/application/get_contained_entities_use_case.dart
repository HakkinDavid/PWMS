import '../../../core/domain/entities/entity.dart';
import '../../../core/domain/entities/entity_id.dart';
import '../../../core/domain/repositories/entity_repository.dart';

/// Caso de uso para obtener las entidades contenidas directamente en una ubicación dada.
class GetContainedEntitiesUseCase {
  final EntityRepository _repository;

  GetContainedEntitiesUseCase(this._repository);

  Future<List<Entity>> execute(EntityId? parentId) async {
    return await _repository.findByParentId(parentId);
  }
}
