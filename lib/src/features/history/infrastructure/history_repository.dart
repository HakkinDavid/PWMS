import 'dart:convert';
import 'package:drift/drift.dart';
import '../../../core/database/app_database.dart';
import '../domain/activity_event.dart';
import '../domain/i_history_repository.dart';

class HistoryRepository implements IHistoryRepository {
  final AppDatabase _db;

  HistoryRepository(this._db);

  ActivityEvent _mapToDomain(HistoryEventsTableData row) {
    Map<String, dynamic>? meta;
    if (row.metadata != null && row.metadata!.isNotEmpty) {
      try {
        meta = jsonDecode(row.metadata!) as Map<String, dynamic>;
      } catch (_) {}
    }

    return ActivityEvent(
      id: row.id,
      entityId: row.entityId,
      eventType: row.eventType,
      description: row.description,
      metadata: meta,
      timestamp: row.timestamp,
    );
  }

  @override
  Future<List<ActivityEvent>> getRecentEvents({int limit = 20}) async {
    final query = _db.select(_db.historyEventsTable)
      ..orderBy([(t) => OrderingTerm.desc(t.timestamp)])
      ..limit(limit);
    final rows = await query.get();
    return rows.map(_mapToDomain).toList();
  }

  @override
  Future<List<ActivityEvent>> getEventsForEntity(String entityId) async {
    final query = _db.select(_db.historyEventsTable)
      ..where((t) => t.entityId.equals(entityId))
      ..orderBy([(t) => OrderingTerm.desc(t.timestamp)]);
    final rows = await query.get();
    return rows.map(_mapToDomain).toList();
  }

  @override
  Future<void> logEvent(ActivityEvent event) async {
    final companion = HistoryEventsTableCompanion(
      id: Value(event.id),
      entityId: Value(event.entityId),
      eventType: Value(event.eventType),
      description: Value(event.description),
      metadata: Value(event.metadata != null ? jsonEncode(event.metadata) : null),
      timestamp: Value(event.timestamp),
    );
    await _db.into(_db.historyEventsTable).insertOnConflictUpdate(companion);
  }
}
