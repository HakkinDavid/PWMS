import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/database/app_database.dart';
import '../../locations/domain/location_resolver.dart';
import '../../relations/domain/entity_relation.dart';
import '../domain/attachment.dart';
import '../domain/custom_template.dart';
import '../domain/i_entity_repository.dart';
import '../domain/instance_magnitude.dart';
import '../domain/world_entity.dart';

class EntityRepository implements IEntityRepository {
  final AppDatabase _db;

  EntityRepository(this._db);

  Future<WorldEntity> _mapToDomain(
    EntitiesTableData row, {
    Map<String, String?>? resolvedLocations,
  }) async {
    final magRows = await (_db.select(_db.instanceMagnitudesTable)..where((t) => t.instanceId.equals(row.id))).get();
    final magnitudes = magRows.map((m) => InstanceMagnitude(
      id: m.id,
      instanceId: m.instanceId,
      propertyName: m.propertyName,
      magnitudeValue: m.magnitudeValue,
      unitSymbol: m.unitSymbol,
    )).toList();

    final effectiveLocation = resolvedLocations != null && resolvedLocations.containsKey(row.id)
        ? resolvedLocations[row.id]
        : row.locationId;

    return WorldEntity(
      id: row.id,
      speciesId: row.speciesId,
      subspeciesId: row.subspeciesId,
      locationId: effectiveLocation,
      magnitudes: magnitudes,
      expirationDate: row.expirationDate,
      notes: row.notes,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  Attachment _mapAttachmentToDomain(AttachmentsTableData row) {
    return Attachment(
      id: row.id,
      speciesId: row.speciesId,
      filePath: row.filePath,
      fileName: row.fileName,
      fileType: row.fileType,
      createdAt: row.createdAt,
    );
  }

  Future<Map<String, String?>> _getEffectiveLocationMap(List<EntitiesTableData> entityRows) async {
    final locRows = await _db.select(_db.instanceLocationsTable).get();
    final Map<String, String?> directLocs = {
      for (var r in locRows) r.instanceId: r.locationId
    };

    // Fallback to EntitiesTable.locationId if instanceLocationsTable doesn't have it yet
    for (final e in entityRows) {
      final loc = e.locationId;
      if (!directLocs.containsKey(e.id) && loc != null) {
        directLocs[e.id] = loc;
      }
    }

    final relRows = await _db.select(_db.relationsTable).get();
    final allRels = relRows.map((r) => EntityRelation(
      id: r.id,
      sourceEntityId: r.sourceEntityId,
      targetEntityId: r.targetEntityId,
      relationType: r.relationType,
      createdAt: r.createdAt,
    )).toList();

    final Map<String, String?> effectiveLocs = {};
    for (final e in entityRows) {
      effectiveLocs[e.id] = LocationResolver.getEffectiveLocationId(
        entityId: e.id,
        directLocations: directLocs,
        relations: allRels,
      );
    }

    return effectiveLocs;
  }

  @override
  Future<List<WorldEntity>> getAllEntities() async {
    final query = _db.select(_db.entitiesTable)
      ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]);
    final rows = await query.get();
    final effectiveLocs = await _getEffectiveLocationMap(rows);

    final List<WorldEntity> results = [];
    for (final row in rows) {
      results.add(await _mapToDomain(row, resolvedLocations: effectiveLocs));
    }
    return results;
  }

  @override
  Future<WorldEntity?> getEntityById(String id) async {
    final query = _db.select(_db.entitiesTable)..where((t) => t.id.equals(id));
    final row = await query.getSingleOrNull();
    if (row == null) return null;

    final allRows = await _db.select(_db.entitiesTable).get();
    final effectiveLocs = await _getEffectiveLocationMap(allRows);
    return await _mapToDomain(row, resolvedLocations: effectiveLocs);
  }

  @override
  Future<List<WorldEntity>> getRecentEntities({int limit = 10}) async {
    final query = _db.select(_db.entitiesTable)
      ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)])
      ..limit(limit);
    final rows = await query.get();
    final effectiveLocs = await _getEffectiveLocationMap(rows);

    final List<WorldEntity> results = [];
    for (final row in rows) {
      results.add(await _mapToDomain(row, resolvedLocations: effectiveLocs));
    }
    return results;
  }

  @override
  Future<List<WorldEntity>> getEntitiesByLocation(String? locationId) async {
    final allEntities = await getAllEntities();
    if (locationId == null) {
      return allEntities.where((e) => e.locationId == null).toList();
    } else {
      return allEntities.where((e) => e.locationId == locationId).toList();
    }
  }

  @override
  Future<List<WorldEntity>> searchEntities(String queryStr) async {
    final cleanQuery = queryStr.toLowerCase().trim();
    if (cleanQuery.isEmpty) return getAllEntities();

    final catalogRows = await _db.select(_db.catalogTable).get();
    final allEntities = await getAllEntities();

    return allEntities.where((e) {
      final species = catalogRows.where((c) => c.id == e.speciesId).firstOrNull;
      if (species == null) return false;

      final nameMatch = species.name.toLowerCase().contains(cleanQuery);
      final typeMatch = species.type.toLowerCase().contains(cleanQuery);
      final notesMatch = e.notes?.toLowerCase().contains(cleanQuery) ?? false;

      return nameMatch || typeMatch || notesMatch;
    }).toList();
  }

  @override
  Future<void> saveEntity(WorldEntity entity) async {
    final companion = EntitiesTableCompanion(
      id: Value(entity.id),
      speciesId: Value(entity.speciesId),
      subspeciesId: Value(entity.subspeciesId),
      locationId: Value(entity.locationId),
      expirationDate: Value(entity.expirationDate),
      notes: Value(entity.notes),
      createdAt: Value(entity.createdAt),
      updatedAt: Value(entity.updatedAt),
    );

    await _db.into(_db.entitiesTable).insertOnConflictUpdate(companion);

    // Manage 4NF InstanceLocationsTable (Direct Physical Location)
    if (entity.locationId != null) {
      await _db.into(_db.instanceLocationsTable).insertOnConflictUpdate(
        InstanceLocationsTableCompanion(
          instanceId: Value(entity.id),
          locationId: Value(entity.locationId!),
          createdAt: Value(DateTime.now()),
        ),
      );
    } else {
      await (_db.delete(_db.instanceLocationsTable)..where((t) => t.instanceId.equals(entity.id))).go();
    }

    // Persist 4NF Instance Magnitudes (1:N)
    await (_db.delete(_db.instanceMagnitudesTable)..where((t) => t.instanceId.equals(entity.id))).go();
    for (final mag in entity.magnitudes) {
      await _db.into(_db.instanceMagnitudesTable).insert(InstanceMagnitudesTableCompanion(
        id: Value(mag.id.isEmpty ? const Uuid().v4() : mag.id),
        instanceId: Value(entity.id),
        propertyName: Value(mag.propertyName),
        magnitudeValue: Value(mag.magnitudeValue),
        unitSymbol: Value(mag.unitSymbol),
      ));
    }
  }

  @override
  Future<WorldEntity> instantiateOrMerge(
    String speciesId,
    String? locationId,
    double addQuantity, {
    String? subspeciesId,
    String? notes,
    String? unit,
  }) async {
    // Decision (b, e): No DB scalar merging! Always instantiate individual WorldEntity
    final newId = const Uuid().v4();

    String? resolvedSubspeciesId = subspeciesId;
    if (resolvedSubspeciesId == null || resolvedSubspeciesId.trim().isEmpty) {
      final subRows = await (_db.select(_db.subspeciesTable)..where((t) => t.speciesId.equals(speciesId))).get();
      if (subRows.isNotEmpty) {
        resolvedSubspeciesId = subRows.first.id;
      }
    }

    final speciesMagRows = await (_db.select(_db.speciesMagnitudesTable)..where((t) => t.speciesId.equals(speciesId))).get();
    final initialMags = speciesMagRows.map((sm) => InstanceMagnitude(
      id: const Uuid().v4(),
      instanceId: newId,
      propertyName: sm.propertyName,
      magnitudeValue: addQuantity,
      unitSymbol: sm.unitSymbol,
    )).toList();

    final newEntity = WorldEntity(
      id: newId,
      speciesId: speciesId,
      subspeciesId: resolvedSubspeciesId,
      locationId: locationId,
      magnitudes: initialMags,
      notes: notes,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await saveEntity(newEntity);
    return newEntity;
  }

  @override
  Future<void> moveEntity(String entityId, String? newLocationId) async {
    await moveOrMergeEntity(entityId, newLocationId);
  }

  @override
  Future<WorldEntity?> moveOrMergeEntity(String entityId, String? newLocationId) async {
    final entity = await getEntityById(entityId);
    if (entity == null) return null;

    // Decision (b, e): Update location without merging/deleting rows
    final updated = entity.copyWith(
      locationId: newLocationId,
      updatedAt: DateTime.now(),
    );
    await saveEntity(updated);
    return updated;
  }

  @override
  Future<void> deleteEntity(String id) async {
    await (_db.delete(_db.instanceLocationsTable)..where((t) => t.instanceId.equals(id))).go();
    await (_db.delete(_db.relationsTable)..where((t) => t.sourceEntityId.equals(id) | t.targetEntityId.equals(id))).go();
    await (_db.delete(_db.instanceMagnitudesTable)..where((t) => t.instanceId.equals(id))).go();
    await (_db.delete(_db.entitiesTable)..where((t) => t.id.equals(id))).go();
  }

  @override
  Future<void> deleteEntitiesBatch(List<String> ids) async {
    if (ids.isEmpty) return;
    await _db.batch((batch) {
      batch.deleteWhere(_db.instanceLocationsTable, (t) => t.instanceId.isIn(ids));
      batch.deleteWhere(_db.relationsTable, (t) => t.sourceEntityId.isIn(ids) | t.targetEntityId.isIn(ids));
      batch.deleteWhere(_db.instanceMagnitudesTable, (t) => t.instanceId.isIn(ids));
      batch.deleteWhere(_db.entitiesTable, (t) => t.id.isIn(ids));
    });
  }

  @override
  Future<List<Attachment>> getAttachmentsForSpecies(String speciesId) async {
    final query = _db.select(_db.attachmentsTable)..where((t) => t.speciesId.equals(speciesId));
    final rows = await query.get();
    return rows.map(_mapAttachmentToDomain).toList();
  }

  @override
  Future<void> addAttachment(Attachment attachment) async {
    final existing = await getAttachmentsForSpecies(attachment.speciesId);
    final isDuplicate = existing.any((a) => a.filePath == attachment.filePath || a.fileName.toLowerCase() == attachment.fileName.toLowerCase());
    if (isDuplicate) {
      throw Exception(AppStrings.duplicateAttachmentError);
    }

    final companion = AttachmentsTableCompanion(
      id: Value(attachment.id),
      speciesId: Value(attachment.speciesId),
      filePath: Value(attachment.filePath),
      fileName: Value(attachment.fileName),
      fileType: Value(attachment.fileType),
      createdAt: Value(attachment.createdAt),
    );
    await _db.into(_db.attachmentsTable).insertOnConflictUpdate(companion);
  }

  @override
  Future<void> deleteAttachment(String attachmentId) async {
    await (_db.delete(_db.attachmentsTable)..where((t) => t.id.equals(attachmentId))).go();
  }

  @override
  Future<List<CustomTemplate>> getAllCustomTemplates() async {
    final rows = await _db.select(_db.customTemplatesTable).get();
    return rows.map((r) {
      List<String> units = [];
      try {
        units = List<String>.from(jsonDecode(r.commonUnits));
      } catch (_) {}
      return CustomTemplate(
        id: r.id,
        typeName: r.typeName,
        iconName: r.iconName,
        commonUnits: units,
        createdAt: r.createdAt,
      );
    }).toList();
  }

  @override
  Future<void> saveCustomTemplate(CustomTemplate template) async {
    final companion = CustomTemplatesTableCompanion(
      id: Value(template.id),
      typeName: Value(template.typeName),
      iconName: Value(template.iconName),
      commonUnits: Value(jsonEncode(template.commonUnits)),
      createdAt: Value(template.createdAt),
    );
    await _db.into(_db.customTemplatesTable).insertOnConflictUpdate(companion);
  }
}
