import 'dart:convert';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../../../../core/domain/entities/entity_id.dart';
import '../../../../core/domain/events/domain_event.dart';
import '../../../../core/domain/events/event_id.dart';
import '../../../../core/domain/repositories/event_repository.dart';
import '../../../../core/infrastructure/database/app_database.dart';

/// Implementación SQLite de la tabla de auditoría e historial de eventos [EventRepository].
class SqfliteEventRepository implements EventRepository {
  final Future<Database> Function() _dbProvider;

  SqfliteEventRepository({Future<Database> Function()? dbProvider})
      : _dbProvider = dbProvider ?? (() => AppDatabase.instance);

  @override
  Future<void> record(DomainEvent event) async {
    final db = await _dbProvider();
    await db.insert(
      'events',
      {
        'id': event.id.value,
        'type': event.type,
        'entity_id': event.entityId.value,
        'payload_json': jsonEncode(event.payload),
        'timestamp': event.timestamp.toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<List<DomainEvent>> findByEntityId(EntityId entityId) async {
    final db = await _dbProvider();
    final maps = await db.query(
      'events',
      where: 'entity_id = ?',
      whereArgs: [entityId.value],
      orderBy: 'timestamp DESC',
    );

    return maps.map((row) => _mapRowToEvent(row)).toList();
  }

  @override
  Future<List<DomainEvent>> findAll() async {
    final db = await _dbProvider();
    final maps = await db.query(
      'events',
      orderBy: 'timestamp DESC',
    );

    return maps.map((row) => _mapRowToEvent(row)).toList();
  }

  DomainEvent _mapRowToEvent(Map<String, dynamic> row) {
    return DomainEvent(
      id: EventId(row['id'] as String),
      type: row['type'] as String,
      entityId: EntityId(row['entity_id'] as String),
      payload: jsonDecode(row['payload_json'] as String),
      timestamp: DateTime.parse(row['timestamp'] as String),
    );
  }
}
