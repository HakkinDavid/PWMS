import 'dart:convert';
import 'package:drift/drift.dart';
import '../../../core/database/app_database.dart';
import '../domain/attachment.dart';
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

    final isContainer = EntityTemplateRegistry.isContainer(row.type);
    final isPlace = EntityTemplateRegistry.isPlace(row.type);

    return WorldEntity(
      id: row.id,
      name: row.name,
      alias: row.alias,
      type: row.type,
      mainPhotoPath: row.mainPhotoPath,
      notes: row.notes,
      placeId: row.placeId,
      parentEntityId: row.parentEntityId,
      quantity: row.quantity,
      unit: row.unit,
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

    final all = await getAllEntities();
    return all.where((e) {
      final nameMatch = e.name.toLowerCase().contains(cleanQuery);
      final aliasMatch = e.alias?.toLowerCase().contains(cleanQuery) ?? false;
      final typeMatch = e.type.toLowerCase().contains(cleanQuery);
      final notesMatch = e.notes?.toLowerCase().contains(cleanQuery) ?? false;
      final tagsMatch = e.tags.any((t) => t.toLowerCase().contains(cleanQuery));
      return nameMatch || aliasMatch || typeMatch || notesMatch || tagsMatch;
    }).toList();
  }

  @override
  Future<void> saveEntity(WorldEntity entity) async {
    final companion = EntitiesTableCompanion(
      id: Value(entity.id),
      name: Value(entity.name),
      alias: Value(entity.alias),
      type: Value(entity.type),
      mainPhotoPath: Value(entity.mainPhotoPath),
      notes: Value(entity.notes),
      placeId: Value(entity.placeId),
      parentEntityId: Value(entity.parentEntityId),
      quantity: Value(entity.quantity),
      unit: Value(entity.unit),
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

    final updated = entity.copyWith(
      placeId: newPlaceId,
      parentEntityId: newParentId,
      updatedAt: DateTime.now(),
    );
    await saveEntity(updated);

    // If entity is a container or place, cascading location context to all contained children
    if (entity.isContainer || entity.isPlace) {
      final children = await getEntitiesByParent(entityId);
      for (final child in children) {
        // Cascade place update to children if container was assigned to a new place
        if (newPlaceId != child.placeId) {
          await moveEntity(child.id, newPlaceId: newPlaceId, newParentId: child.parentEntityId);
        }
      }
    }
  }

  @override
  Future<void> deleteEntity(String id) async {
    // Delete attachments & relations first
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
}
