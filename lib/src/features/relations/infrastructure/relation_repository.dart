import 'package:drift/drift.dart';
import '../../../core/database/app_database.dart';
import '../domain/entity_relation.dart';
import '../domain/i_relation_repository.dart';

class RelationRepository implements IRelationRepository {
  final AppDatabase _db;

  RelationRepository(this._db);

  EntityRelation _mapToDomain(RelationsTableData row) {
    return EntityRelation(
      id: row.id,
      sourceEntityId: row.sourceEntityId,
      targetEntityId: row.targetEntityId,
      relationType: row.relationType,
      createdAt: row.createdAt,
    );
  }

  @override
  Future<List<EntityRelation>> getRelationsForEntity(String entityId) async {
    final query = _db.select(_db.relationsTable)
      ..where((t) => t.sourceEntityId.equals(entityId) | t.targetEntityId.equals(entityId));
    final rows = await query.get();
    return rows.map(_mapToDomain).toList();
  }

  @override
  Future<void> addRelation(EntityRelation relation) async {
    final companion = RelationsTableCompanion(
      id: Value(relation.id),
      sourceEntityId: Value(relation.sourceEntityId),
      targetEntityId: Value(relation.targetEntityId),
      relationType: Value(relation.relationType),
      createdAt: Value(relation.createdAt),
    );
    await _db.into(_db.relationsTable).insertOnConflictUpdate(companion);
  }

  @override
  Future<void> deleteRelation(String relationId) async {
    await (_db.delete(_db.relationsTable)..where((t) => t.id.equals(relationId))).go();
  }
}
