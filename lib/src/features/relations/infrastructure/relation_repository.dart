import 'package:drift/drift.dart';
import '../../../core/database/app_database.dart';
import '../../locations/domain/location_resolver.dart';
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
    final allRelRows = await _db.select(_db.relationsTable).get();
    final allRels = allRelRows.map(_mapToDomain).toList();

    if (LocationResolver.locationInheritingTypes.contains(relation.relationType)) {
      // 1. Cycle Prevention
      final isCircular = LocationResolver.detectCircularContainment(
        sourceId: relation.sourceEntityId,
        targetId: relation.targetEntityId,
        relations: allRels,
      );
      if (isCircular) {
        throw Exception('No se puede crear un vínculo circular: el elemento ya forma parte o contiene la entidad destino.');
      }

      // 2. Single Active Container Rule (a)
      // Delete any existing location-inheriting relation where this entity is the source
      final existingInheriting = allRelRows.where((r) =>
        r.sourceEntityId == relation.sourceEntityId &&
        LocationResolver.locationInheritingTypes.contains(r.relationType)
      ).toList();

      for (final oldRel in existingInheriting) {
        await (_db.delete(_db.relationsTable)..where((t) => t.id.equals(oldRel.id))).go();
      }

      // 3. Remove direct location from InstanceLocationsTable as location is now derived
      await (_db.delete(_db.instanceLocationsTable)..where((t) => t.instanceId.equals(relation.sourceEntityId))).go();
    }

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
    final relRow = await (_db.select(_db.relationsTable)..where((t) => t.id.equals(relationId))).getSingleOrNull();

    if (relRow != null && LocationResolver.locationInheritingTypes.contains(relRow.relationType)) {
      // Resolve target container's current effective location
      final locRows = await _db.select(_db.instanceLocationsTable).get();
      final directLocs = {for (var r in locRows) r.instanceId: r.locationId};

      final allRelRows = await _db.select(_db.relationsTable).get();
      final allRels = allRelRows.map(_mapToDomain).toList();

      final containerEffectiveLoc = LocationResolver.getEffectiveLocationId(
        entityId: relRow.targetEntityId,
        directLocations: directLocs,
        relations: allRels,
      );

      // On unlink: stamp container's current effective location into instance_locations
      if (containerEffectiveLoc != null) {
        await _db.into(_db.instanceLocationsTable).insertOnConflictUpdate(
          InstanceLocationsTableCompanion(
            instanceId: Value(relRow.sourceEntityId),
            locationId: Value(containerEffectiveLoc),
            createdAt: Value(DateTime.now()),
          ),
        );
      }
    }

    await (_db.delete(_db.relationsTable)..where((t) => t.id.equals(relationId))).go();
  }
}

