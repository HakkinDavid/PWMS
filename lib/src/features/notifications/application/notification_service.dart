import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:uuid/uuid.dart';
import '../../../core/database/app_database.dart';
import '../../catalog/infrastructure/catalog_repository.dart';
import '../../entities/infrastructure/entity_repository.dart';
import '../domain/app_notification.dart';
import '../infrastructure/notification_repository.dart';

class NotificationService {
  final AppDatabase _db;
  final EntityRepository _entityRepo;
  final CatalogRepository _catalogRepo;
  final NotificationRepository _notificationRepo;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  NotificationService({
    required AppDatabase db,
    required EntityRepository entityRepo,
    required CatalogRepository catalogRepo,
    required NotificationRepository notificationRepo,
  })  : _db = db,
        _entityRepo = entityRepo,
        _catalogRepo = catalogRepo,
        _notificationRepo = notificationRepo;

  Future<void> initLocalNotifications() async {
    if (_initialized) return;
    try {
      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      const darwinSettings = DarwinInitializationSettings();
      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: darwinSettings,
        macOS: darwinSettings,
      );
      await _localNotifications.initialize(initSettings);
      _initialized = true;
    } catch (e) {
      debugPrint('Local notifications initialization skipped or failed: $e');
    }
  }

  /// Synchronize and evaluate all system state: Expirations + Unsatisfied Needs
  Future<void> evaluateAllNotifications() async {
    await initLocalNotifications();
    final now = DateTime.now();

    final allEntities = await _entityRepo.getAllEntities();
    final allCatalogItems = await _catalogRepo.getAllCatalogItems();
    final catalogMap = {for (var item in allCatalogItems) item.id: item};
    final existingNotifications = await _notificationRepo.getAllNotifications();
    final existingMap = {
      for (var n in existingNotifications) '${n.type}_${n.targetId}': n
    };

    // 1. Evaluate Entity Expirations & Warnings
    for (final entity in allEntities) {
      final species = catalogMap[entity.speciesId];
      final speciesName = species?.name ?? 'Elemento';
      final warningDays = species?.warningDaysBeforeExpiration ?? 7;

      if (entity.isExpired(now)) {
        final key = 'expired_${entity.id}';
        final existing = existingMap[key];

        if (existing == null || existing.status != 'dismissed') {
          final notif = AppNotification(
            id: existing?.id ?? const Uuid().v4(),
            type: 'expired',
            title: 'Ítem Caducado',
            message: '"$speciesName" ha caducado (${_formatDate(entity.expirationDate)}).',
            targetId: entity.id,
            targetType: 'entity',
            status: existing?.status ?? 'active',
            snoozedUntil: existing?.snoozedUntil,
            createdAt: existing?.createdAt ?? now,
            updatedAt: now,
          );
          await _notificationRepo.saveNotification(notif);
          if (notif.isActive) {
            _showOSNotification(100 + entity.id.hashCode.abs() % 10000, notif.title, notif.message);
          }
        }
      } else if (entity.isExpiringSoon(warningDays, now)) {
        final key = 'expiring_soon_${entity.id}';
        final existing = existingMap[key];

        if (existing == null || existing.status != 'dismissed') {
          final daysLeft = entity.expirationDate!.difference(now).inDays + 1;
          final notif = AppNotification(
            id: existing?.id ?? const Uuid().v4(),
            type: 'expiring_soon',
            title: 'Caducidad Próxima',
            message: '"$speciesName" caducará en $daysLeft día(s) (${_formatDate(entity.expirationDate)}).',
            targetId: entity.id,
            targetType: 'entity',
            status: existing?.status ?? 'active',
            snoozedUntil: existing?.snoozedUntil,
            createdAt: existing?.createdAt ?? now,
            updatedAt: now,
          );
          await _notificationRepo.saveNotification(notif);
          if (notif.isActive) {
            _showOSNotification(200 + entity.id.hashCode.abs() % 10000, notif.title, notif.message);
          }
        }
      }
    }

    // 2. Evaluate Unsatisfied Needs (SpeciesRequirements)
    final reqRows = await _db.select(_db.speciesRequirementsTable).get();
    final Map<String, double> requiredTotalsBySpecies = {};

    for (final req in reqRows) {
      requiredTotalsBySpecies[req.requiredSpeciesId] =
          (requiredTotalsBySpecies[req.requiredSpeciesId] ?? 0.0) + req.requiredQuantity;
    }

    for (final entry in requiredTotalsBySpecies.entries) {
      final reqSpeciesId = entry.key;
      final requiredQty = entry.value;

      final species = catalogMap[reqSpeciesId];
      final speciesName = species?.name ?? 'Especie';

      // Count valid non-expired stock
      final validEntities = allEntities.where((e) => e.speciesId == reqSpeciesId && e.isValid(now)).toList();
      final validStockCount = validEntities.length.toDouble();

      final key = 'unsatisfied_need_$reqSpeciesId';
      final existing = existingMap[key];

      if (validStockCount < requiredQty) {
        final deficit = requiredQty - validStockCount;
        final deficitStr = deficit == deficit.toInt() ? deficit.toInt().toString() : deficit.toStringAsFixed(1);
        final notif = AppNotification(
          id: existing?.id ?? const Uuid().v4(),
          type: 'unsatisfied_need',
          title: 'Necesidad Insatisfecha',
          message: 'Faltan $deficitStr unidad(es) de "$speciesName" para cubrir los requerimientos totales ($validStockCount/$requiredQty disponible).',
          targetId: reqSpeciesId,
          targetType: 'species',
          status: existing?.status ?? 'active',
          snoozedUntil: existing?.snoozedUntil,
          createdAt: existing?.createdAt ?? now,
          updatedAt: now,
        );
        await _notificationRepo.saveNotification(notif);
        if (notif.isActive) {
          _showOSNotification(300 + reqSpeciesId.hashCode.abs() % 10000, notif.title, notif.message);
        }
      } else {
        // Condition satisfied: dismiss/clear existing unsatisfied need notification if any
        if (existing != null && existing.status != 'dismissed') {
          await _notificationRepo.dismissNotification(existing.id);
        }
      }
    }
  }

  void _showOSNotification(int id, String title, String body) async {
    if (!_initialized) return;
    try {
      const androidDetails = AndroidNotificationDetails(
        'pwms_notifications',
        'PWMS Notifications',
        channelDescription: 'Notificaciones de caducidad y necesidades insatisfechas',
        importance: Importance.high,
        priority: Priority.high,
      );
      const osDetails = NotificationDetails(
        android: androidDetails,
        iOS: DarwinNotificationDetails(),
        macOS: DarwinNotificationDetails(),
      );
      await _localNotifications.show(id, title, body, osDetails);
    } catch (_) {}
  }

  String _formatDate(DateTime? dt) {
    if (dt == null) return '';
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
  }
}
