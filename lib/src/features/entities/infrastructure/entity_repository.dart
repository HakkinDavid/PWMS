import 'dart:convert';
import 'package:drift/drift.dart';
import '../../../core/database/app_database.dart';
import '../domain/attachment.dart';
import '../domain/custom_template.dart';
import '../domain/entity_template.dart';
import '../domain/i_entity_repository.dart';
import '../domain/world_entity.dart';

class EntityRepository implements IEntityRepository {
  final AppDatabase _db;

  EntityRepository(this._db);

  WorldEntity _mapToDomain(EntitiesTableData row) {
    List<String> tagsList = [];
    if (row.tags.isNotEmpty) {
      try {
        tagsList = List<String>.from(jsonDecode(row.tags));
      } catch (_) {
        tagsList = row.tags.split(',').where((t) => t.trim().isNotEmpty).toList();
      }
    }

    Map<String, dynamic> customAttrs = {};
    if (row.customAttributes.isNotEmpty) {
      try {
        customAttrs = Map<String, dynamic>.from(jsonDecode(row.customAttributes));
      } catch (_) {}
    }

    final isContainer = EntityTemplateRegistry.isContainer(row.type);
    final isPlace = EntityTemplateRegistry.isPlace(row.type);

    return WorldEntity(
      id: row.id,
      speciesId: row.speciesId,
      name: row.name,
      alias: row.alias,
      type: row.type,
      mainPhotoPath: row.mainPhotoPath,
      notes: row.notes,
      placeId: row.placeId,
      parentEntityId: row.parentEntityId,
      quantity: row.quantity,
      unit: row.unit,
      barcode: row.barcode,
      customAttributes: customAttrs,
      isArchived: row.isArchived,
      isContainer: isContainer,
      isPlace: isPlace,
      tags: tagsList,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  Attachment _mapAttachmentToDomain(AttachmentsTableData row) {
    return Attachment(
      id: row.id,
      entityId: row.entityId,
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
    return rows.map(_mapToDomain).toList();
  }

  @override
  Future<WorldEntity?> getEntityById(String id) async {
    final query = _db.select(_db.entitiesTable)..where((t) => t.id.equals(id));
    final row = await query.getSingleOrNull();
    return row != null ? _mapToDomain(row) : null;
  }

  @override
  Future<List<WorldEntity>> getRecentEntities({int limit = 10}) async {
    final query = _db.select(_db.entitiesTable)
      ..where((t) => t.isArchived.equals(false))
      ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)])
      ..limit(limit);
    final rows = await query.get();
    return rows.map(_mapToDomain).toList();
  }

  @override
  Future<List<WorldEntity>> getEntitiesByPlace(String placeId) async {
    final query = _db.select(_db.entitiesTable)..where((t) => t.placeId.equals(placeId) | t.parentEntityId.equals(placeId));
    final rows = await query.get();
    return rows.map(_mapToDomain).toList();
  }

  @override
  Future<List<WorldEntity>> getEntitiesByParent(String? parentId) async {
    final query = _db.select(_db.entitiesTable);
    if (parentId == null) {
      query.where((t) => t.parentEntityId.isNull() & t.placeId.isNull());
    } else {
      query.where((t) => t.parentEntityId.equals(parentId) | t.placeId.equals(parentId));
    }
    final rows = await query.get();
    return rows.map(_mapToDomain).toList();
  }

  @override
  Future<List<WorldEntity>> searchEntities(String queryStr) async {
    final cleanQuery = queryStr.toLowerCase().trim();
    if (cleanQuery.isEmpty) return getAllEntities();

    final relationsRows = await _db.select(_db.relationsTable).get();
    final allEntities = await getAllEntities();

    return allEntities.where((e) {
      final nameMatch = e.name.toLowerCase().contains(cleanQuery);
      final aliasMatch = e.alias?.toLowerCase().contains(cleanQuery) ?? false;
      final typeMatch = e.type.toLowerCase().contains(cleanQuery);
      final notesMatch = e.notes?.toLowerCase().contains(cleanQuery) ?? false;
      final barcodeMatch = e.barcode?.toLowerCase().contains(cleanQuery) ?? false;
      final tagsMatch = e.tags.any((t) => t.toLowerCase().contains(cleanQuery));

      final attrMatch = e.customAttributes.entries.any(
        (entry) => entry.key.toLowerCase().contains(cleanQuery) || entry.value.toString().toLowerCase().contains(cleanQuery),
      );

      final relationMatch = relationsRows.any((r) {
        if (r.sourceEntityId == e.id || r.targetEntityId == e.id) {
          if (r.relationType.toLowerCase().contains(cleanQuery)) return true;
          final otherId = r.sourceEntityId == e.id ? r.targetEntityId : r.sourceEntityId;
          final other = allEntities.where((x) => x.id == otherId).firstOrNull;
          return other?.name.toLowerCase().contains(cleanQuery) ?? false;
        }
        return false;
      });

      return nameMatch || aliasMatch || typeMatch || notesMatch || barcodeMatch || tagsMatch || attrMatch || relationMatch;
    }).toList();
  }

  @override
  Future<void> saveEntity(WorldEntity entity) async {
    String? resolvedPlaceId = entity.placeId;

    // Rule #3: Container location inheritance ("Seguirlo").
    // If entity has a parent container assigned, force its location to match the parent container's location!
    if (entity.parentEntityId != null) {
      final parent = await getEntityById(entity.parentEntityId!);
      if (parent != null && parent.placeId != null) {
        resolvedPlaceId = parent.placeId;
      }
    }

    final companion = EntitiesTableCompanion(
      id: Value(entity.id),
      speciesId: Value(entity.speciesId),
      name: Value(entity.name),
      alias: Value(entity.alias),
      type: Value(entity.type),
      mainPhotoPath: Value(entity.mainPhotoPath),
      notes: Value(entity.notes),
      placeId: Value(resolvedPlaceId),
      parentEntityId: Value(entity.parentEntityId),
      quantity: Value(entity.quantity),
      unit: Value(entity.unit),
      barcode: Value(entity.barcode),
      customAttributes: Value(jsonEncode(entity.customAttributes)),
      isArchived: Value(entity.isArchived),
      tags: Value(jsonEncode(entity.tags)),
      createdAt: Value(entity.createdAt),
      updatedAt: Value(entity.updatedAt),
    );

    await _db.into(_db.entitiesTable).insertOnConflictUpdate(companion);
  }

  @override
  Future<void> moveEntity(String entityId, {String? newPlaceId, String? newParentId}) async {
    final entity = await getEntityById(entityId);
    if (entity == null) return;

    String? resolvedPlaceId = newPlaceId;
    if (newParentId != null) {
      final parent = await getEntityById(newParentId);
      if (parent != null && parent.placeId != null) {
        resolvedPlaceId = parent.placeId;
      }
    }

    final updated = entity.copyWith(
      placeId: resolvedPlaceId,
      parentEntityId: newParentId,
      updatedAt: DateTime.now(),
    );
    await saveEntity(updated);

    if (entity.isContainer || entity.isPlace) {
      final children = await getEntitiesByParent(entityId);
      for (final child in children) {
        if (resolvedPlaceId != child.placeId) {
          await moveEntity(child.id, newPlaceId: resolvedPlaceId, newParentId: child.parentEntityId);
        }
      }
    }
  }

  @override
  Future<void> deleteEntity(String id) async {
    await (_db.delete(_db.attachmentsTable)..where((t) => t.entityId.equals(id))).go();
    await (_db.delete(_db.relationsTable)..where((t) => t.sourceEntityId.equals(id) | t.targetEntityId.equals(id))).go();
    await (_db.delete(_db.entitiesTable)..where((t) => t.id.equals(id))).go();
  }

  @override
  Future<List<Attachment>> getAttachments(String entityId) async {
    final query = _db.select(_db.attachmentsTable)..where((t) => t.entityId.equals(entityId));
    final rows = await query.get();
    return rows.map(_mapAttachmentToDomain).toList();
  }

  @override
  Future<void> addAttachment(Attachment attachment) async {
    final companion = AttachmentsTableCompanion(
      id: Value(attachment.id),
      entityId: Value(attachment.entityId),
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

  // Custom Templates DAOs
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
        isContainer: r.isContainer,
        isPlace: r.isPlace,
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
      isContainer: Value(template.isContainer),
      isPlace: Value(template.isPlace),
      commonUnits: Value(jsonEncode(template.commonUnits)),
      createdAt: Value(template.createdAt),
    );
    await _db.into(_db.customTemplatesTable).insertOnConflictUpdate(companion);
  }
}
