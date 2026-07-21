import 'entity_relation.dart';

abstract class IRelationRepository {
  Future<List<EntityRelation>> getRelationsForEntity(String entityId);
  Future<void> addRelation(EntityRelation relation);
  Future<void> deleteRelation(String relationId);
}
