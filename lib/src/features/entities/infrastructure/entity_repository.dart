import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../../../core/database/app_database.dart';
import '../domain/attachment.dart';
import '../domain/custom_template.dart';
import '../domain/i_entity_repository.dart';
import '../domain/instance_magnitude.dart';
import '../domain/world_entity.dart';

class EntityRepository implements IEntityRepository {
  final AppDatabase _db;

  EntityRepository(this._db);

  Future<WorldEntity> _mapToDomain(EntitiesTableData row) async {
    final magRows = await (_db.select(_db.instanceMagnitudesTable)..where((t) => t.instanceId.equals(row.id))).get();
    final magnitudes = magRows.map((m) => InstanceMagnitude(
      id: m.id,
      instanceId: m.instanceId,
      propertyName: m.propertyName,
      magnitudeValue: m.magnitudeValue,
      unitSymbol: m.unitSymbol,
    )).toList();

    return WorldEntity(
      id: row.id,
      speciesId: row.speciesId,
      locationId: row.locationId,
      magnitudes: magnitudes,
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

  @override
  Future<List<WorldEntity>> getAllEntities() async {
    final query = _db.select(_db.entitiesTable)
      ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]);
    final rows = await query.get();
    final List<WorldEntity> results = [];
    for (final row in rows) {
      results.add(await _mapToDomain(row));
    }
    return results;
  }

  @override
  Future<WorldEntity?> getEntityById(String id) async {
    final query = _db.select(_db.entitiesTable)..where((t) => t.id.equals(id));
    final row = await query.getSingleOrNull();
    return row != null ? await _mapToDomain(row) : null;
  }

  @override
  Future<List<WorldEntity>> getRecentEntities({int limit = 10}) async {
    final query = _db.select(_db.entitiesTable)
      ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)])
      ..limit(limit);
    final rows = await query.get();
    final List<WorldEntity> results = [];
    for (final row in rows) {
      results.add(await _mapToDomain(row));
    }
    return results;
  }

  @override
  Future<List<WorldEntity>> getEntitiesByLocation(String? locationId) async {
    final query = _db.select(_db.entitiesTable);
    if (locationId == null) {
      query.where((t) => t.locationId.isNull());
    } else {
      query.where((t) => t.locationId.equals(locationId));
    }
    final rows = await query.get();
    final List<WorldEntity> results = [];
    for (final row in rows) {
      results.add(await _mapToDomain(row));
    }
    return results;
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
      final brandMatch = species.brand?.toLowerCase().contains(cleanQuery) ?? false;
      final typeMatch = species.type.toLowerCase().contains(cleanQuery);
      final barcodeMatch = species.barcode?.toLowerCase().contains(cleanQuery) ?? false;
      final notesMatch = e.notes?.toLowerCase().contains(cleanQuery) ?? false;

      return nameMatch || brandMatch || typeMatch || barcodeMatch || notesMatch;
    }).toList();
  }

  @override
  Future<void> saveEntity(WorldEntity entity) async {
    final companion = EntitiesTableCompanion(
      id: Value(entity.id),
      speciesId: Value(entity.speciesId),
      locationId: Value(entity.locationId),
      notes: Value(entity.notes),
      createdAt: Value(entity.createdAt),
      updatedAt: Value(entity.updatedAt),
    );

    await _db.into(_db.entitiesTable).insertOnConflictUpdate(companion);

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
    String? notes,
    String? unit,
  }) async {
    final locationEntities = await getEntitiesByLocation(locationId);
    final existing = locationEntities.where((e) => e.speciesId == speciesId).firstOrNull;

    if (existing != null) {
      final updatedMags = List<InstanceMagnitude>.from(existing.magnitudes);
      if (updatedMags.isNotEmpty) {
        final firstMag = updatedMags.first;
        updatedMags[0] = firstMag.copyWith(magnitudeValue: firstMag.magnitudeValue + addQuantity);
      } else {
        updatedMags.add(InstanceMagnitude(
          id: const Uuid().v4(),
          instanceId: existing.id,
          propertyName: 'Cantidad',
          magnitudeValue: addQuantity,
          unitSymbol: unit ?? 'unidad',
        ));
      }

      final updated = existing.copyWith(
        magnitudes: updatedMags,
        notes: (notes != null && notes.isNotEmpty) ? notes : existing.notes,
        updatedAt: DateTime.now(),
      );
      await saveEntity(updated);
      return updated;
    } else {
      final newId = const Uuid().v4();
      final newEntity = WorldEntity(
        id: newId,
        speciesId: speciesId,
        locationId: locationId,
        magnitudes: [
          InstanceMagnitude(
            id: const Uuid().v4(),
            instanceId: newId,
            propertyName: 'Cantidad',
            magnitudeValue: addQuantity,
            unitSymbol: unit ?? 'unidad',
          ),
        ],
        notes: notes,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await saveEntity(newEntity);
      return newEntity;
    }
  }

  @override
  Future<void> moveEntity(String entityId, String? newLocationId) async {
    await moveOrMergeEntity(entityId, newLocationId);
  }

  @override
  Future<WorldEntity?> moveOrMergeEntity(String entityId, String? newLocationId) async {
    final entity = await getEntityById(entityId);
    if (entity == null) return null;
    if (entity.locationId == newLocationId) return entity;

    final targetLocationEntities = await getEntitiesByLocation(newLocationId);
    final existingAtTarget = targetLocationEntities.where((e) => e.speciesId == entity.speciesId && e.id != entityId).firstOrNull;

    if (existingAtTarget != null) {
      final mergedMags = List<InstanceMagnitude>.from(existingAtTarget.magnitudes);
      if (mergedMags.isNotEmpty && entity.magnitudes.isNotEmpty) {
        mergedMags[0] = mergedMags[0].copyWith(magnitudeValue: mergedMags[0].magnitudeValue + entity.magnitudes[0].magnitudeValue);
      }

      final merged = existingAtTarget.copyWith(
        magnitudes: mergedMags,
        notes: (entity.notes != null && entity.notes!.isNotEmpty)
            ? '${existingAtTarget.notes ?? ""}\n${entity.notes}'
            : existingAtTarget.notes,
        updatedAt: DateTime.now(),
      );
      await saveEntity(merged);
      await deleteEntity(entityId);
      return merged;
    } else {
      final updated = entity.copyWith(
        locationId: newLocationId,
        updatedAt: DateTime.now(),
      );
      await saveEntity(updated);
      return updated;
    }
  }

  @override
  Future<void> deleteEntity(String id) async {
    await (_db.delete(_db.relationsTable)..where((t) => t.sourceEntityId.equals(id) | t.targetEntityId.equals(id))).go();
    await (_db.delete(_db.instanceMagnitudesTable)..where((t) => t.instanceId.equals(id))).go();
    await (_db.delete(_db.entitiesTable)..where((t) => t.id.equals(id))).go();
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
      throw Exception('Este archivo adjunto ya existe en la especie');
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
