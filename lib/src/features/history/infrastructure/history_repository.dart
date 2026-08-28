import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:platinum_world_management_system/src/core/constants/app_technical_strings.dart';
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
  Future<List<ActivityEvent>> getAllEvents() async {
    final query = _db.select(_db.historyEventsTable)
      ..orderBy([(t) => OrderingTerm.desc(t.timestamp)]);
    final rows = await query.get();
    return rows.map(_mapToDomain).toList();
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
  Stream<List<ActivityEvent>> watchRecentEvents({int limit = 50}) {
    final query = _db.select(_db.historyEventsTable)
      ..orderBy([(t) => OrderingTerm.desc(t.timestamp)])
      ..limit(limit);
    return query.watch().map((rows) => rows.map(_mapToDomain).toList());
  }

  @override
  Stream<List<ActivityEvent>> watchAllEvents() {
    final query = _db.select(_db.historyEventsTable)
      ..orderBy([(t) => OrderingTerm.desc(t.timestamp)]);
    return query.watch().map((rows) => rows.map(_mapToDomain).toList());
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
  Future<List<ActivityEvent>> getEventsFiltered({
    String? category,
    String? query,
    int limit = 50,
    int offset = 0,
  }) async {
    final all = await getAllEvents();
    var filtered = all;

    if (category != null && category.isNotEmpty && category != AppTechnicalStrings.categoryAll) {
      filtered = filtered.where((e) => e.category == category).toList();
    }

    if (query != null && query.trim().isNotEmpty) {
      final clean = query.trim().toLowerCase();
      filtered = filtered.where((e) {
        if (e.description.toLowerCase().contains(clean)) return true;
        if (e.entityId?.toLowerCase().contains(clean) ?? false) return true;
        if (e.resolvedTargetId?.toLowerCase().contains(clean) ?? false) return true;
        if (e.metadata != null) {
          final metaStr = e.metadata.toString().toLowerCase();
          if (metaStr.contains(clean)) return true;
        }
        return false;
      }).toList();
    }

    if (offset >= filtered.length) return [];
    return filtered.skip(offset).take(limit).toList();
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

  @override
  Future<void> logEventsBatch(List<ActivityEvent> events) async {
    if (events.isEmpty) return;
    await _db.batch((batch) {
      for (final event in events) {
        batch.insert(
          _db.historyEventsTable,
          HistoryEventsTableCompanion(
            id: Value(event.id),
            entityId: Value(event.entityId),
            eventType: Value(event.eventType),
            description: Value(event.description),
            metadata: Value(event.metadata != null ? jsonEncode(event.metadata) : null),
            timestamp: Value(event.timestamp),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }

  @override
  Future<void> clearHistory() async {
    await _db.delete(_db.historyEventsTable).go();
  }
}

