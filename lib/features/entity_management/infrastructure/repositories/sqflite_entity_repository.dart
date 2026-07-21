import 'dart:convert';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../../../../core/domain/entities/entity.dart';
import '../../../../core/domain/entities/entity_id.dart';
import '../../../../core/domain/repositories/entity_repository.dart';
import '../../../../core/domain/templates/template_id.dart';
import '../../../../core/domain/value_objects/attribute_key.dart';
import '../../../../core/domain/value_objects/attribute_value.dart';
import '../../../../core/infrastructure/database/app_database.dart';

/// Implementación real de persistencia basada en SQLite para [EntityRepository].
class SqfliteEntityRepository implements EntityRepository {
  final Future<Database> Function() _dbProvider;

  SqfliteEntityRepository({Future<Database> Function()? dbProvider})
      : _dbProvider = dbProvider ?? (() => AppDatabase.instance);

  @override
  Future<void> save(Entity entity) async {
    final db = await _dbProvider();

    final rawAttributes = <String, dynamic>{};
    for (final entry in entity.attributes.entries) {
      rawAttributes[entry.key.value] = entry.value.value;
    }

    await db.insert(
      'entities',
      {
        'id': entity.id.value,
        'template_id': entity.templateId?.value,
        'parent_id': entity.parentId?.value,
        'attributes_json': jsonEncode(rawAttributes),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<Entity?> findById(EntityId id) async {
    final db = await _dbProvider();
    final maps = await db.query(
      'entities',
      where: 'id = ?',
      whereArgs: [id.value],
    );

    if (maps.isEmpty) return null;

    return _mapRowToEntity(maps.first);
  }

  @override
  Future<List<Entity>> findByParentId(EntityId? parentId) async {
    final db = await _dbProvider();
    final List<Map<String, dynamic>> maps;

    if (parentId == null) {
      maps = await db.query(
        'entities',
        where: 'parent_id IS NULL',
      );
    } else {
      maps = await db.query(
        'entities',
        where: 'parent_id = ?',
        whereArgs: [parentId.value],
      );
    }

    return maps.map((row) => _mapRowToEntity(row)).toList();
  }

  @override
  Future<List<Entity>> findAll() async {
    final db = await _dbProvider();
    final maps = await db.query('entities');

    return maps.map((row) => _mapRowToEntity(row)).toList();
  }

  @override
  Future<void> delete(EntityId id) async {
    final db = await _dbProvider();
    await db.delete(
      'entities',
      where: 'id = ?',
      whereArgs: [id.value],
    );
  }

  Entity _mapRowToEntity(Map<String, dynamic> row) {
    final id = EntityId(row['id'] as String);
    final templateIdRaw = row['template_id'] as String?;
    final templateId = templateIdRaw != null ? TemplateId(templateIdRaw) : null;

    final parentIdRaw = row['parent_id'] as String?;
    final parentId = parentIdRaw != null ? EntityId(parentIdRaw) : null;

    final attributesJson = row['attributes_json'] as String;
    final Map<String, dynamic> rawAttributes = jsonDecode(attributesJson);

    final attributes = <AttributeKey, AttributeValue>{};
    rawAttributes.forEach((key, value) {
      if (value != null) {
        attributes[AttributeKey(key)] = AttributeValue(value);
      }
    });

    return Entity(
      id: id,
      templateId: templateId,
      parentId: parentId,
      attributes: attributes,
    );
  }
}
