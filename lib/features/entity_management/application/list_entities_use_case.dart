import '../../../core/domain/entities/entity.dart';
import '../../../core/domain/repositories/entity_repository.dart';

/// Caso de uso para consultar todas las entidades registradas.
class ListEntitiesUseCase {
  final EntityRepository _repository;

  ListEntitiesUseCase(this._repository);

  Future<List<Entity>> execute() async {
    return await _repository.findAll();
  }
}
