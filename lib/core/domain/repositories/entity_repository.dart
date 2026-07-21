import '../entities/entity.dart';
import '../entities/entity_id.dart';

/// Contrato abstracto del repositorio de entidades.
abstract class EntityRepository {
  /// Guarda o actualiza una entidad.
  Future<void> save(Entity entity);

  /// Busca una entidad por su [EntityId]. Retorna null si no existe.
  Future<Entity?> findById(EntityId id);

  /// Retorna las entidades contenidas directamente dentro de un contenedor dado ([parentId]).
  /// Si [parentId] es null, retorna las entidades en la raíz del mundo.
  Future<List<Entity>> findByParentId(EntityId? parentId);

  /// Retorna la lista completa de entidades registradas.
  Future<List<Entity>> findAll();

  /// Elimina permanentemente una entidad por su [EntityId].
  Future<void> delete(EntityId id);
}
