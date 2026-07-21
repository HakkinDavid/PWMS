import 'package:platinum_world_management_system/core/domain/entities/entity.dart';
import 'package:platinum_world_management_system/core/domain/entities/entity_id.dart';
import 'package:platinum_world_management_system/core/domain/repositories/entity_repository.dart';

/// Fake In-Memory EntityRepository reservado exclusivamente para pruebas unitarias.
class InMemoryEntityRepository implements EntityRepository {
  final Map<EntityId, Entity> _storage = {};

  @override
  Future<void> save(Entity entity) async {
    _storage[entity.id] = entity;
  }

  @override
  Future<Entity?> findById(EntityId id) async {
    return _storage[id];
  }

  @override
  Future<List<Entity>> findByParentId(EntityId? parentId) async {
    return _storage.values.where((e) => e.parentId == parentId).toList();
  }

  @override
  Future<List<Entity>> findAll() async {
    return _storage.values.toList();
  }

  @override
  Future<void> delete(EntityId id) async {
    _storage.remove(id);
  }
}
