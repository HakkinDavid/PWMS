import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:uuid/uuid.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import 'package:platinum_world_management_system/src/core/constants/app_technical_strings.dart';
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
      const androidSettings = AndroidInitializationSettings(AppTechnicalStrings.androidDefaultNotificationIcon);
      const darwinSettings = DarwinInitializationSettings();
      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: darwinSettings,
        macOS: darwinSettings,
      );
      await _localNotifications.initialize(initSettings);
      _initialized = true;
    } catch (e) {
      debugPrint(AppStrings.notificationInitErrorPrefix + e.toString());
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
      for (var n in existingNotifications)
        AppTechnicalStrings.notifKeyFromNotification(n.type, n.targetId): n
    };

    // 1. Evaluate Entity Expirations & Warnings
    for (final entity in allEntities) {
      final species = catalogMap[entity.speciesId];
      final canExpire = species?.canExpire ?? false;
      if (!canExpire) continue;

      final warningDays = species?.warningDaysBeforeExpiration ?? 7;

      if (entity.isExpired(canExpire: canExpire, now: now)) {
        final key = AppTechnicalStrings.notifKeyExpired(entity.id);
        final existing = existingMap[key];

        if (existing == null || existing.status != AppTechnicalStrings.notifStatusDismissed) {
          final formattedDate = AppStrings.formatDateDMY(entity.expirationDate);
          final notif = AppNotification(
            id: existing?.id ?? const Uuid().v4(),
            type: AppTechnicalStrings.notifTypeExpired,
            title: AppStrings.expiredItemTitle,
            message: AppStrings.notifMessageExpired(formattedDate),
            targetId: entity.id,
            targetType: AppTechnicalStrings.notifTargetTypeEntity,
            status: existing?.status ?? AppTechnicalStrings.notifStatusActive,
            snoozedUntil: existing?.snoozedUntil,
            createdAt: existing?.createdAt ?? now,
            updatedAt: now,
          );
          await _notificationRepo.saveNotification(notif);
          if (notif.isActive) {
            _showOSNotification(100 + entity.id.hashCode.abs() % 10000, notif.title, notif.message);
          }
        }
      } else if (entity.isExpiringSoon(warningDays: warningDays, canExpire: canExpire, now: now)) {
        final key = AppTechnicalStrings.notifKeyExpiringSoon(entity.id);
        final existing = existingMap[key];

        if (existing == null || existing.status != AppTechnicalStrings.notifStatusDismissed) {
          final daysLeft = entity.expirationDate!.difference(now).inDays + 1;
          final formattedDate = AppStrings.formatDateDMY(entity.expirationDate);
          final notif = AppNotification(
            id: existing?.id ?? const Uuid().v4(),
            type: AppTechnicalStrings.notifTypeExpiringSoon,
            title: AppStrings.expiringSoonTitle,
            message: AppStrings.notifMessageExpiringSoon(daysLeft, formattedDate),
            targetId: entity.id,
            targetType: AppTechnicalStrings.notifTargetTypeEntity,
            status: existing?.status ?? AppTechnicalStrings.notifStatusActive,
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
      final canExpire = species?.canExpire ?? false;

      // Count valid non-expired stock
      final validEntities = allEntities.where((e) {
        if (e.speciesId != reqSpeciesId) return false;
        return e.isValid(canExpire: canExpire, now: now);
      }).toList();
      final validStockCount = validEntities.length.toDouble();

      final key = AppTechnicalStrings.notifKeyUnsatisfiedNeed(reqSpeciesId);
      final existing = existingMap[key];

      if (validStockCount < requiredQty) {
        final deficit = requiredQty - validStockCount;
        final deficitStr = deficit == deficit.toInt() ? deficit.toInt().toString() : deficit.toStringAsFixed(1);
        final notif = AppNotification(
          id: existing?.id ?? const Uuid().v4(),
          type: AppTechnicalStrings.notifTypeUnsatisfiedNeed,
          title: AppStrings.unsatisfiedNeedTitle,
          message: AppStrings.notifMessageUnsatisfiedNeed(deficitStr, validStockCount, requiredQty),
          targetId: reqSpeciesId,
          targetType: AppTechnicalStrings.notifTargetTypeSpecies,
          status: existing?.status ?? AppTechnicalStrings.notifStatusActive,
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
        if (existing != null && existing.status != AppTechnicalStrings.notifStatusDismissed) {
          await _notificationRepo.dismissNotification(existing.id);
        }
      }
    }
  }

  void _showOSNotification(int id, String title, String body) async {
    if (!_initialized) return;
    try {
      const androidDetails = AndroidNotificationDetails(
        AppTechnicalStrings.notifChannelPwms,
        AppStrings.notificationChannelName,
        channelDescription: AppStrings.notificationChannelDescription,
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
}
