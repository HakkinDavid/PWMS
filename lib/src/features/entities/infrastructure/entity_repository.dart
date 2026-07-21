import 'dart:convert';
import 'package:drift/drift.dart';
import '../../../core/database/app_database.dart';
import '../domain/attachment.dart';
import '../domain/custom_template.dart';
import '../domain/i_entity_repository.dart';
import '../domain/world_entity.dart';

class EntityRepository implements IEntityRepository {
  final AppDatabase _db;

  EntityRepository(this._db);

  WorldEntity _mapToDomain(EntitiesTableData row) {
    return WorldEntity(
      id: row.id,
      speciesId: row.speciesId,
      locationId: row.locationId,
      quantity: row.quantity,
      unit: row.unit,
      notes: row.notes,
      isArchived: row.isArchived,
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
  Future<List<WorldEntity>> getEntitiesByLocation(String? locationId) async {
    final query = _db.select(_db.entitiesTable);
    if (locationId == null) {
      query.where((t) => t.locationId.isNull());
    } else {
      query.where((t) => t.locationId.equals(locationId));
    }
    final rows = await query.get();
    return rows.map(_mapToDomain).toList();
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
      quantity: Value(entity.quantity),
      unit: Value(entity.unit),
      notes: Value(entity.notes),
      isArchived: Value(entity.isArchived),
      createdAt: Value(entity.createdAt),
      updatedAt: Value(entity.updatedAt),
    );

    await _db.into(_db.entitiesTable).insertOnConflictUpdate(companion);
  }

  @override
  Future<void> moveEntity(String entityId, String? newLocationId) async {
    final entity = await getEntityById(entityId);
    if (entity == null) return;

    final updated = entity.copyWith(
      locationId: newLocationId,
      updatedAt: DateTime.now(),
    );
    await saveEntity(updated);
  }

  @override
  Future<void> deleteEntity(String id) async {
    await (_db.delete(_db.relationsTable)..where((t) => t.sourceEntityId.equals(id) | t.targetEntityId.equals(id))).go();
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
