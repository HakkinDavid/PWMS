import 'package:drift/drift.dart';
import '../../../core/database/app_database.dart';
import '../domain/app_notification.dart';

class NotificationRepository {
  final AppDatabase _db;

  NotificationRepository(this._db);

  AppNotification _mapToDomain(NotificationsTableData row) {
    return AppNotification(
      id: row.id,
      type: row.type,
      title: row.title,
      message: row.message,
      targetId: row.targetId,
      targetType: row.targetType,
      status: row.status,
      snoozedUntil: row.snoozedUntil,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  Future<List<AppNotification>> getAllNotifications() async {
    final query = _db.select(_db.notificationsTable)
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]);
    final rows = await query.get();
    return rows.map(_mapToDomain).toList();
  }

  Future<List<AppNotification>> getActiveNotifications() async {
    final all = await getAllNotifications();
    return all.where((n) => n.isActive).toList();
  }

  Future<void> saveNotification(AppNotification notification) async {
    final companion = NotificationsTableCompanion(
      id: Value(notification.id),
      type: Value(notification.type),
      title: Value(notification.title),
      message: Value(notification.message),
      targetId: Value(notification.targetId),
      targetType: Value(notification.targetType),
      status: Value(notification.status),
      snoozedUntil: Value(notification.snoozedUntil),
      createdAt: Value(notification.createdAt),
      updatedAt: Value(notification.updatedAt),
    );
    await _db.into(_db.notificationsTable).insertOnConflictUpdate(companion);
  }

  Future<void> snoozeNotification(String id, Duration duration) async {
    final snoozedUntil = DateTime.now().add(duration);
    final query = _db.update(_db.notificationsTable)..where((t) => t.id.equals(id));
    await query.write(NotificationsTableCompanion(
      status: const Value('snoozed'),
      snoozedUntil: Value(snoozedUntil),
      updatedAt: Value(DateTime.now()),
    ));
  }

  Future<void> dismissNotification(String id) async {
    final query = _db.update(_db.notificationsTable)..where((t) => t.id.equals(id));
    await query.write(NotificationsTableCompanion(
      status: const Value('dismissed'),
      updatedAt: Value(DateTime.now()),
    ));
  }

  Future<void> clearNotificationsForTarget(String targetId) async {
    await (_db.delete(_db.notificationsTable)..where((t) => t.targetId.equals(targetId))).go();
  }
}
