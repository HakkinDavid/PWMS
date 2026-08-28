import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../../../core/database/app_database.dart';
import '../../locations/domain/location_resolver.dart';
import '../../relations/domain/entity_relation.dart';
import '../domain/attachment.dart';
import '../domain/custom_template.dart';
import '../domain/i_entity_repository.dart';
import '../domain/instance_magnitude.dart';
import '../domain/world_entity.dart';

import '../../../core/storage/file_storage_service.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import 'package:platinum_world_management_system/src/features/history/application/activity_logger_service.dart';
import 'package:platinum_world_management_system/src/features/history/infrastructure/history_repository.dart';

class EntityRepository implements IEntityRepository {
  final AppDatabase _db;
  final FileStorageService _fileStorageService;
  final ActivityLoggerService _activityLogger;

  EntityRepository(
    this._db, [
    FileStorageService? fileStorageService,
    ActivityLoggerService? activityLogger,
  ])  : _fileStorageService = fileStorageService ?? FileStorageService(),
        _activityLogger = activityLogger ?? ActivityLoggerService(HistoryRepository(_db));

  Future<Map<String, List<InstanceMagnitude>>> _fetchMagnitudesForEntities(List<String> entityIds) async {
    if (entityIds.isEmpty) return {};
    final magRows = await (_db.select(_db.instanceMagnitudesTable)
      ..where((t) => t.instanceId.isIn(entityIds))).get();

    final Map<String, List<InstanceMagnitude>> magMap = {};
    for (final m in magRows) {
      magMap.putIfAbsent(m.instanceId, () => []).add(InstanceMagnitude(
        id: m.id,
        instanceId: m.instanceId,
        propertyName: m.propertyName,
        dataType: m.dataType,
        magnitudeValue: m.magnitudeValue,
        stringValue: m.stringValue,
        unitSymbol: m.unitSymbol,
      ));
    }
    return magMap;
  }

  WorldEntity _mapToDomainSync(
    EntitiesTableData row, {
    Map<String, String?>? resolvedLocations,
    List<InstanceMagnitude> magnitudes = const [],
  }) {
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

  Future<WorldEntity> _mapToDomain(
    EntitiesTableData row, {
    Map<String, String?>? resolvedLocations,
  }) async {
    final magMap = await _fetchMagnitudesForEntities([row.id]);
    return _mapToDomainSync(
      row,
      resolvedLocations: resolvedLocations,
      magnitudes: magMap[row.id] ?? const [],
    );
  }

  Attachment _mapAttachmentToDomain(AttachmentsTableData row) {
    return Attachment(
      id: row.id,
      speciesId: row.speciesId,
      instanceId: row.instanceId,
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
    final entityIds = rows.map((r) => r.id).toList();
    final magMap = await _fetchMagnitudesForEntities(entityIds);

    return rows.map((row) => _mapToDomainSync(
      row,
      resolvedLocations: effectiveLocs,
      magnitudes: magMap[row.id] ?? const [],
    )).toList();
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
    final entityIds = rows.map((r) => r.id).toList();
    final magMap = await _fetchMagnitudesForEntities(entityIds);

    return rows.map((row) => _mapToDomainSync(
      row,
      resolvedLocations: effectiveLocs,
      magnitudes: magMap[row.id] ?? const [],
    )).toList();
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
    final subspeciesRows = await _db.select(_db.subspeciesTable).get();
    final locationRows = await _db.select(_db.locationsTable).get();
    final allEntities = await getAllEntities();

    final catalogMap = {for (var c in catalogRows) c.id: c};
    final subspeciesMap = {for (var s in subspeciesRows) s.id: s};
    final locationMap = {for (var l in locationRows) l.id: l};

    return allEntities.where((e) {
      final species = catalogMap[e.speciesId];
      if (species != null) {
        if (species.name.toLowerCase().contains(cleanQuery) ||
            species.type.toLowerCase().contains(cleanQuery) ||
            (species.description?.toLowerCase().contains(cleanQuery) ?? false)) {
          return true;
        }
      }

      if (e.subspeciesId != null) {
        final sub = subspeciesMap[e.subspeciesId];
        if (sub != null) {
          if (sub.subspeciesName.toLowerCase().contains(cleanQuery) ||
              (sub.brand?.toLowerCase().contains(cleanQuery) ?? false) ||
              (sub.barcode?.toLowerCase().contains(cleanQuery) ?? false) ||
              (sub.notes?.toLowerCase().contains(cleanQuery) ?? false)) {
            return true;
          }
        }
      }

      if (e.locationId != null) {
        final loc = locationMap[e.locationId];
        if (loc != null) {
          if (loc.name.toLowerCase().contains(cleanQuery) ||
              (loc.description?.toLowerCase().contains(cleanQuery) ?? false)) {
            return true;
          }
        }
      }

      if (e.notes?.toLowerCase().contains(cleanQuery) ?? false) return true;

      for (final mag in e.magnitudes) {
        if (mag.propertyName.toLowerCase().contains(cleanQuery) ||
            (mag.unitSymbol?.toLowerCase().contains(cleanQuery) ?? false) ||
            (mag.stringValue?.toLowerCase().contains(cleanQuery) ?? false) ||
            mag.displayValue.toLowerCase().contains(cleanQuery)) {
          return true;
        }
      }

      return false;
    }).toList();
  }

  @override
  Future<void> saveEntity(WorldEntity entity) async {
    final existingEntity = await (_db.select(_db.entitiesTable)..where((t) => t.id.equals(entity.id))).getSingleOrNull();
    String? directLocId;

    await _db.transaction(() async {
      // Ensure that if the entity is contained in a container (GUARDADO_EN / PARTE_DE),
      // direct physical location in DB is null (as location is inherited from container).
      final isContained = (await (_db.select(_db.relationsTable)
        ..where((t) => t.sourceEntityId.equals(entity.id) & t.relationType.isIn(LocationResolver.locationInheritingTypes.toList()))
      ).get()).isNotEmpty;

      directLocId = isContained ? null : entity.locationId;

      final companion = EntitiesTableCompanion(
        id: Value(entity.id),
        speciesId: Value(entity.speciesId),
        subspeciesId: Value(entity.subspeciesId),
        locationId: Value(directLocId),
        expirationDate: Value(entity.expirationDate),
        notes: Value(entity.notes),
        createdAt: Value(entity.createdAt),
        updatedAt: Value(entity.updatedAt),
      );

      await _db.into(_db.entitiesTable).insertOnConflictUpdate(companion);

      // Manage 4NF InstanceLocationsTable (Direct Physical Location)
      if (directLocId != null) {
        await _db.into(_db.instanceLocationsTable).insertOnConflictUpdate(
          InstanceLocationsTableCompanion(
            instanceId: Value(entity.id),
            locationId: Value(directLocId!),
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
          dataType: Value(mag.dataType),
          magnitudeValue: Value(mag.magnitudeValue),
          stringValue: Value(mag.stringValue),
          unitSymbol: Value(mag.unitSymbol),
        ));
      }
    });

    final speciesRow = await (_db.select(_db.catalogTable)..where((t) => t.id.equals(entity.speciesId))).getSingleOrNull();
    final speciesName = speciesRow?.name ?? AppStrings.typeObject;
    final speciesType = speciesRow?.type ?? AppStrings.typeObject;

    if (existingEntity == null) {
      await _activityLogger.logEntityCreated(
        entity.id,
        speciesName,
        speciesType,
        speciesId: entity.speciesId,
        subspeciesId: entity.subspeciesId,
        locationId: directLocId,
        timestamp: entity.createdAt,
      );
    } else {
      String? detail;
      if (existingEntity.locationId != directLocId) {
        detail = AppStrings.historyLocationModified;
      } else if (existingEntity.notes != entity.notes) {
        detail = AppStrings.historyNotesUpdated;
      } else if (existingEntity.expirationDate != entity.expirationDate) {
        detail = AppStrings.historyExpirationUpdated;
      }
      await _activityLogger.logEntityEdited(
        entity.id,
        speciesName,
        details: detail,
      );
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
    Map<String, double>? customMagnitudeValues,
    DateTime? expirationDate,
  }) async {
    final count = addQuantity.toInt() > 0 ? addQuantity.toInt() : 1;

    String? resolvedSubspeciesId = subspeciesId;
    if (resolvedSubspeciesId == null || resolvedSubspeciesId.trim().isEmpty) {
      final subRows = await (_db.select(_db.subspeciesTable)..where((t) => t.speciesId.equals(speciesId))).get();
      if (subRows.isNotEmpty) {
        resolvedSubspeciesId = subRows.first.id;
      }
    }

    final speciesMagRows = await (_db.select(_db.speciesMagnitudesTable)..where((t) => t.speciesId.equals(speciesId))).get();

    // Si no se proveyeron magnitudes explícitas, copiar de una instancia existente de la misma subespecie (si existe)
    Map<String, double> effectiveMagnitudeValues = Map.from(customMagnitudeValues ?? {});
    if (customMagnitudeValues == null && resolvedSubspeciesId != null && resolvedSubspeciesId.isNotEmpty) {
      final subId = resolvedSubspeciesId;
      final existingEntities = await (_db.select(_db.entitiesTable)
        ..where((t) => t.speciesId.equals(speciesId) & t.subspeciesId.equals(subId))
        ..limit(1)).get();

      if (existingEntities.isNotEmpty) {
        final existingMags = await (_db.select(_db.instanceMagnitudesTable)
          ..where((t) => t.instanceId.equals(existingEntities.first.id))).get();

        for (final m in existingMags) {
          effectiveMagnitudeValues[m.propertyName] = m.magnitudeValue;
        }
      }
    }

    WorldEntity? primaryEntity;

    for (int i = 0; i < count; i++) {
      final newId = const Uuid().v4();
      final initialMags = speciesMagRows.map((sm) {
        final val = effectiveMagnitudeValues[sm.propertyName] ?? 1.0;
        return InstanceMagnitude(
          id: const Uuid().v4(),
          instanceId: newId,
          propertyName: sm.propertyName,
          magnitudeValue: val,
          unitSymbol: sm.unitSymbol,
        );
      }).toList();

      final newEntity = WorldEntity(
        id: newId,
        speciesId: speciesId,
        subspeciesId: resolvedSubspeciesId,
        locationId: locationId,
        magnitudes: initialMags,
        expirationDate: expirationDate,
        notes: notes,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await saveEntity(newEntity);
      primaryEntity ??= newEntity;
    }

    return primaryEntity!;
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
    final entityRow = await (_db.select(_db.entitiesTable)..where((t) => t.id.equals(id))).getSingleOrNull();
    String speciesName = AppStrings.typeObject;
    if (entityRow != null) {
      final speciesRow = await (_db.select(_db.catalogTable)..where((t) => t.id.equals(entityRow.speciesId))).getSingleOrNull();
      if (speciesRow != null) speciesName = speciesRow.name;
    }

    await (_db.delete(_db.instanceLocationsTable)..where((t) => t.instanceId.equals(id))).go();
    await (_db.delete(_db.relationsTable)..where((t) => t.sourceEntityId.equals(id) | t.targetEntityId.equals(id))).go();
    await (_db.delete(_db.instanceMagnitudesTable)..where((t) => t.instanceId.equals(id))).go();
    await (_db.delete(_db.entitiesTable)..where((t) => t.id.equals(id))).go();

    await _activityLogger.logEntityDeleted(id, speciesName);
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
    await _activityLogger.logEntitiesBatchDeleted(ids.length, entityIds: ids);
  }

  @override
  Future<List<Attachment>> getAttachmentsForSpecies(String speciesId) async {
    final query = _db.select(_db.attachmentsTable)
      ..where((t) => t.speciesId.equals(speciesId) & t.instanceId.isNull());
    final rows = await query.get();
    return rows.map(_mapAttachmentToDomain).toList();
  }

  @override
  Future<List<Attachment>> getAttachmentsForInstance(String instanceId) async {
    final query = _db.select(_db.attachmentsTable)..where((t) => t.instanceId.equals(instanceId));
    final rows = await query.get();
    return rows.map(_mapAttachmentToDomain).toList();
  }

  @override
  Future<void> addAttachment(Attachment attachment) async {
    final companion = AttachmentsTableCompanion(
      id: Value(attachment.id),
      speciesId: Value(attachment.speciesId),
      instanceId: Value(attachment.instanceId),
      filePath: Value(attachment.filePath),
      fileName: Value(attachment.fileName),
      fileType: Value(attachment.fileType),
      createdAt: Value(attachment.createdAt),
    );
    await _db.into(_db.attachmentsTable).insertOnConflictUpdate(companion);
  }

  @override
  Future<void> updateAttachment(Attachment attachment) async {
    final companion = AttachmentsTableCompanion(
      id: Value(attachment.id),
      speciesId: Value(attachment.speciesId),
      instanceId: Value(attachment.instanceId),
      filePath: Value(attachment.filePath),
      fileName: Value(attachment.fileName),
      fileType: Value(attachment.fileType),
      createdAt: Value(attachment.createdAt),
    );
    await _db.into(_db.attachmentsTable).insertOnConflictUpdate(companion);
  }

  @override
  Future<void> replaceAttachmentFile(
    String attachmentId,
    String newSourcePath, {
    String? newFileName,
    String? newFileType,
  }) async {
    final query = _db.select(_db.attachmentsTable)..where((t) => t.id.equals(attachmentId));
    final current = await query.getSingleOrNull();
    if (current == null) return;

    final oldRelativePath = current.filePath;
    final savedRelativePath = await _fileStorageService.saveFile(newSourcePath);

    final finalFileName = newFileName ?? current.fileName;
    final finalFileType = newFileType ?? current.fileType;

    final companion = AttachmentsTableCompanion(
      id: Value(current.id),
      speciesId: Value(current.speciesId),
      instanceId: Value(current.instanceId),
      filePath: Value(savedRelativePath),
      fileName: Value(finalFileName),
      fileType: Value(finalFileType),
      createdAt: Value(current.createdAt),
    );

    await _db.into(_db.attachmentsTable).insertOnConflictUpdate(companion);

    if (oldRelativePath != savedRelativePath) {
      await _fileStorageService.deleteFile(oldRelativePath);
    }
  }

  @override
  Future<void> deleteAttachment(String attachmentId) async {
    final query = _db.select(_db.attachmentsTable)..where((t) => t.id.equals(attachmentId));
    final row = await query.getSingleOrNull();
    if (row != null) {
      await (_db.delete(_db.attachmentsTable)..where((t) => t.id.equals(attachmentId))).go();
      await _fileStorageService.deleteFile(row.filePath);
      await _activityLogger.logAttachmentRemoved(row.instanceId, row.fileName, row.fileName);
    }
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
