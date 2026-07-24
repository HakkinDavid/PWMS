import 'package:flutter_test/flutter_test.dart';
import 'package:platinum_world_management_system/src/features/entities/domain/world_entity.dart';
import 'package:platinum_world_management_system/src/features/entities/domain/effective_entity_group.dart';
import 'package:platinum_world_management_system/src/features/notifications/domain/app_notification.dart';

void main() {
  group('Expiration & Notification Domain Logic Tests', () {
    final now = DateTime(2026, 7, 24, 12, 0, 0);

    test('WorldEntity expiration status checks', () {
      final validEntity = WorldEntity(
        id: 'e1',
        speciesId: 's1',
        expirationDate: DateTime(2026, 8, 1),
        createdAt: now,
        updatedAt: now,
      );

      final expiringSoonEntity = WorldEntity(
        id: 'e2',
        speciesId: 's1',
        expirationDate: DateTime(2026, 7, 28),
        createdAt: now,
        updatedAt: now,
      );

      final expiredEntity = WorldEntity(
        id: 'e3',
        speciesId: 's1',
        expirationDate: DateTime(2026, 7, 20),
        createdAt: now,
        updatedAt: now,
      );

      expect(validEntity.isExpired(now), false);
      expect(validEntity.isExpiringSoon(7, now), false);
      expect(validEntity.isValid(now), true);

      expect(expiringSoonEntity.isExpired(now), false);
      expect(expiringSoonEntity.isExpiringSoon(7, now), true);
      expect(expiringSoonEntity.isValid(now), true);

      expect(expiredEntity.isExpired(now), true);
      expect(expiredEntity.isExpiringSoon(7, now), false);
      expect(expiredEntity.isValid(now), false);
    });

    test('EffectiveEntityGroup breakdown counts', () {
      final group = EffectiveEntityGroup(
        key: 's1_root',
        speciesId: 's1',
        effectiveLocationId: null,
        entities: [
          WorldEntity(id: 'e1', speciesId: 's1', expirationDate: DateTime(2026, 8, 1), createdAt: now, updatedAt: now),
          WorldEntity(id: 'e2', speciesId: 's1', expirationDate: DateTime(2026, 7, 28), createdAt: now, updatedAt: now),
          WorldEntity(id: 'e3', speciesId: 's1', expirationDate: DateTime(2026, 7, 20), createdAt: now, updatedAt: now),
        ],
      );

      expect(group.population, 3);
      expect(group.expiredCount(now), 1);
      expect(group.expiringSoonCount(7, now), 1);
      expect(group.validCount(now), 2);
    });

    test('AppNotification snooze and active logic', () {
      final activeNotif = AppNotification(
        id: 'n1',
        type: 'expired',
        title: 'Title',
        message: 'Message',
        targetId: 't1',
        targetType: 'entity',
        status: 'active',
        createdAt: now,
        updatedAt: now,
      );

      final snoozedFutureNotif = AppNotification(
        id: 'n2',
        type: 'expiring_soon',
        title: 'Title',
        message: 'Message',
        targetId: 't2',
        targetType: 'entity',
        status: 'snoozed',
        snoozedUntil: now.add(const Duration(days: 3)),
        createdAt: now,
        updatedAt: now,
      );

      final dismissedNotif = AppNotification(
        id: 'n3',
        type: 'unsatisfied_need',
        title: 'Title',
        message: 'Message',
        targetId: 't3',
        targetType: 'species',
        status: 'dismissed',
        createdAt: now,
        updatedAt: now,
      );

      expect(activeNotif.isActive, true);
      expect(snoozedFutureNotif.isActive, false);
      expect(dismissedNotif.isActive, false);
    });
  });
}
