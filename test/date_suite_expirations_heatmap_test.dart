import 'package:flutter_test/flutter_test.dart';
import 'package:platinum_world_management_system/src/core/constants/app_technical_strings.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/catalog_item.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/subspecies.dart';
import 'package:platinum_world_management_system/src/features/entities/domain/world_entity.dart';
import 'package:platinum_world_management_system/src/features/expirations/domain/expiration_item.dart';
import 'package:platinum_world_management_system/src/features/expirations/domain/expiration_summary.dart';
import 'package:platinum_world_management_system/src/features/history/domain/activity_event.dart';
import 'package:platinum_world_management_system/src/features/history/domain/activity_heatmap_data.dart';
import 'package:platinum_world_management_system/src/features/locations/domain/location_node.dart';

void main() {
  group('Date Suite - ExpirationItem & ExpirationSummary Tests', () {
    final now = DateTime(2026, 8, 30, 12, 0);

    test('ExpirationItem.calculateUrgency correctly classifies dates', () {
      // Past date -> expired
      expect(
        ExpirationItem.calculateUrgency(
          expirationDate: DateTime(2026, 8, 25),
          now: now,
        ),
        ExpirationUrgency.expired,
      );

      // <= 3 days -> critical
      expect(
        ExpirationItem.calculateUrgency(
          expirationDate: DateTime(2026, 9, 1),
          now: now,
        ),
        ExpirationUrgency.critical,
      );

      // <= 7 days -> warning
      expect(
        ExpirationItem.calculateUrgency(
          expirationDate: DateTime(2026, 9, 5),
          now: now,
        ),
        ExpirationUrgency.warning,
      );

      // <= 30 days -> upcoming
      expect(
        ExpirationItem.calculateUrgency(
          expirationDate: DateTime(2026, 9, 20),
          now: now,
        ),
        ExpirationUrgency.upcoming,
      );

      // > 30 days -> safe
      expect(
        ExpirationItem.calculateUrgency(
          expirationDate: DateTime(2026, 11, 15),
          now: now,
        ),
        ExpirationUrgency.safe,
      );
    });

    test('ExpirationItem.calculateShelfLifeRatio calculates percentage accurately', () {
      final createdAt = DateTime(2026, 8, 1);
      final expirationDate = DateTime(2026, 8, 31);
      final midNow = DateTime(2026, 8, 16);

      final ratio = ExpirationItem.calculateShelfLifeRatio(
        createdAt: createdAt,
        expirationDate: expirationDate,
        now: midNow,
      );

      expect(ratio, isNotNull);
      expect(ratio!, closeTo(0.5, 0.05));
    });

    test('ExpirationSummary processes entities and partitions them by urgency', () {
      final catalog = {
        'spec-perishable': CatalogItem(
          id: 'spec-perishable',
          name: 'Leche Deslactosada',
          isNonPerishable: false,
          warningDaysBeforeExpiration: 7,
          createdAt: DateTime(2026, 1, 1),
        ),
        'spec-non-perishable': CatalogItem(
          id: 'spec-non-perishable',
          name: 'Tornillo Acero',
          isNonPerishable: true,
          createdAt: DateTime(2026, 1, 1),
        ),
      };

      final subspecies = {
        'sub-1': Subspecies(
          id: 'sub-1',
          speciesId: 'spec-perishable',
          subspeciesName: '1 Litro',
          brand: 'Alpura',
          createdAt: DateTime(2026, 1, 1),
        ),
      };

      final locations = [
        LocationNode(
          id: 'loc-1',
          name: 'Refrigerador',
          createdAt: DateTime(2026, 1, 1),
        ),
      ];

      final entities = [
        // 1. Expired
        WorldEntity(
          id: 'e1',
          speciesId: 'spec-perishable',
          subspeciesId: 'sub-1',
          locationId: 'loc-1',
          expirationDate: DateTime(2026, 8, 20),
          createdAt: DateTime(2026, 8, 1),
          updatedAt: DateTime(2026, 8, 1),
        ),
        // 2. Critical (2 days)
        WorldEntity(
          id: 'e2',
          speciesId: 'spec-perishable',
          subspeciesId: 'sub-1',
          locationId: 'loc-1',
          expirationDate: DateTime(2026, 9, 1),
          createdAt: DateTime(2026, 8, 1),
          updatedAt: DateTime(2026, 8, 1),
        ),
        // 3. Safe (60 days)
        WorldEntity(
          id: 'e3',
          speciesId: 'spec-perishable',
          subspeciesId: 'sub-1',
          locationId: 'loc-1',
          expirationDate: DateTime(2026, 11, 1),
          createdAt: DateTime(2026, 8, 1),
          updatedAt: DateTime(2026, 8, 1),
        ),
        // 4. Non-perishable (should be ignored even with expiration date)
        WorldEntity(
          id: 'e4',
          speciesId: 'spec-non-perishable',
          locationId: 'loc-1',
          expirationDate: DateTime(2026, 9, 1),
          createdAt: DateTime(2026, 8, 1),
          updatedAt: DateTime(2026, 8, 1),
        ),
      ];

      final summary = ExpirationSummary.fromEntities(
        entities: entities,
        catalogMap: catalog,
        subspeciesMap: subspecies,
        locations: locations,
        now: now,
      );

      expect(summary.totalCount, equals(3));
      expect(summary.expiredCount, equals(1));
      expect(summary.criticalCount, equals(1));
      expect(summary.warningCount, equals(0));
      expect(summary.futureItems.length, equals(1));
      final expItem = summary.expiredItems.first;
      expect(expItem.displayName, contains('1 Litro'));
      expect(expItem.displayName, contains('Alpura'));
      expect(expItem.locationName, equals('Refrigerador'));
    });

    test('ExpirationSummary.hasUrgentAlerts is false when only far future items exist', () {
      final catalog = {
        'spec-perishable': CatalogItem(
          id: 'spec-perishable',
          name: 'Arroz',
          isNonPerishable: false,
          warningDaysBeforeExpiration: 7,
          createdAt: DateTime(2026, 1, 1),
        ),
      };

      final entities = [
        WorldEntity(
          id: 'e1',
          speciesId: 'spec-perishable',
          expirationDate: DateTime(2026, 12, 1), // > 90 days
          createdAt: DateTime(2026, 8, 1),
          updatedAt: DateTime(2026, 8, 1),
        ),
      ];

      final summary = ExpirationSummary.fromEntities(
        entities: entities,
        catalogMap: catalog,
        subspeciesMap: const {},
        locations: const [],
        now: now,
      );

      expect(summary.totalCount, equals(1));
      expect(summary.expiredCount, equals(0));
      expect(summary.expiringSoonCount, equals(0));
      expect(summary.hasUrgentAlerts, isFalse);
    });

    test('ExpirationItem.isActiveOnDay correctly identifies active dates in day-spanning intervals', () {
      final catalogItem = CatalogItem(
        id: 'spec-1',
        name: 'Yogurt',
        warningDaysBeforeExpiration: 5,
        createdAt: DateTime(2026, 1, 1),
      );

      // 1. Expired item: expired on Aug 25, today is Aug 30 -> active from Aug 25 to Aug 30
      final expiredItem = ExpirationItem(
        entity: WorldEntity(
          id: 'e1',
          speciesId: 'spec-1',
          expirationDate: DateTime(2026, 8, 25),
          createdAt: DateTime(2026, 8, 1),
          updatedAt: DateTime(2026, 8, 1),
        ),
        species: catalogItem,
        expirationDate: DateTime(2026, 8, 25),
        daysUntilExpiration: -5,
        urgency: ExpirationUrgency.expired,
      );

      expect(expiredItem.isActiveOnDay(DateTime(2026, 8, 24), now), isFalse);
      expect(expiredItem.isActiveOnDay(DateTime(2026, 8, 25), now), isTrue); // Start of overdue span
      expect(expiredItem.isActiveOnDay(DateTime(2026, 8, 27), now), isTrue); // Middle of overdue span
      expect(expiredItem.isActiveOnDay(DateTime(2026, 8, 30), now), isTrue); // Today (end of overdue span)
      expect(expiredItem.isActiveOnDay(DateTime(2026, 8, 31), now), isFalse);

      // 2. Soon-to-expire item: expires Sep 3 (in 4 days <= 5 warning days)
      // Warning start = Sep 3 - 5 days = Aug 29. Effective start = max(today, Aug 29) = Aug 29 or Aug 30.
      final soonItem = ExpirationItem(
        entity: WorldEntity(
          id: 'e2',
          speciesId: 'spec-1',
          expirationDate: DateTime(2026, 9, 3),
          createdAt: DateTime(2026, 8, 1),
          updatedAt: DateTime(2026, 8, 1),
        ),
        species: catalogItem,
        expirationDate: DateTime(2026, 9, 3),
        daysUntilExpiration: 4,
        urgency: ExpirationUrgency.warning,
      );

      expect(soonItem.isActiveOnDay(DateTime(2026, 8, 28), now), isFalse);
      expect(soonItem.isActiveOnDay(DateTime(2026, 8, 30), now), isTrue); // Inside warning span
      expect(soonItem.isActiveOnDay(DateTime(2026, 9, 1), now), isTrue);  // Inside warning span
      expect(soonItem.isActiveOnDay(DateTime(2026, 9, 3), now), isTrue);  // Expiration day
      expect(soonItem.isActiveOnDay(DateTime(2026, 9, 4), now), isFalse);

      // 3. Far future safe item: expires Nov 10
      final safeItem = ExpirationItem(
        entity: WorldEntity(
          id: 'e3',
          speciesId: 'spec-1',
          expirationDate: DateTime(2026, 11, 10),
          createdAt: DateTime(2026, 8, 1),
          updatedAt: DateTime(2026, 8, 1),
        ),
        species: catalogItem,
        expirationDate: DateTime(2026, 11, 10),
        daysUntilExpiration: 72,
        urgency: ExpirationUrgency.safe,
      );

      expect(safeItem.isActiveOnDay(DateTime(2026, 11, 9), now), isFalse);
      expect(safeItem.isActiveOnDay(DateTime(2026, 11, 10), now), isTrue);
      expect(safeItem.isActiveOnDay(DateTime(2026, 11, 11), now), isFalse);
    });
  });

  group('Date Suite - ActivityHeatmapData & Streak Computation Tests', () {
    final refNow = DateTime(2026, 8, 30, 15, 0);

    test('ActivityHeatmapData computes streaks and daily counts accurately', () {
      final events = [
        // Today (2026-08-30) - 3 events
        ActivityEvent(
          id: '1',
          eventType: AppTechnicalStrings.eventTypeCreation,
          description: 'Creación de objeto 1',
          timestamp: DateTime(2026, 8, 30, 10, 0),
        ),
        ActivityEvent(
          id: '2',
          eventType: AppTechnicalStrings.eventTypeEdition,
          description: 'Edición de objeto 1',
          timestamp: DateTime(2026, 8, 30, 11, 0),
        ),
        ActivityEvent(
          id: '3',
          eventType: AppTechnicalStrings.eventTypeMovement,
          description: 'Movimiento de objeto 1',
          timestamp: DateTime(2026, 8, 30, 12, 0),
        ),
        // Yesterday (2026-08-29) - 1 event
        ActivityEvent(
          id: '4',
          eventType: AppTechnicalStrings.eventTypeCreation,
          description: 'Creación de objeto 2',
          timestamp: DateTime(2026, 8, 29, 9, 0),
        ),
        // 2 days ago (2026-08-28) - 2 events
        ActivityEvent(
          id: '5',
          eventType: AppTechnicalStrings.eventTypeRelation,
          description: 'Relación creada',
          timestamp: DateTime(2026, 8, 28, 14, 0),
        ),
        ActivityEvent(
          id: '6',
          eventType: AppTechnicalStrings.eventTypeBackupExport,
          description: 'Respaldo exportado',
          timestamp: DateTime(2026, 8, 28, 15, 0),
        ),
      ];

      final heatmap = ActivityHeatmapData.fromEvents(
        events,
        daysRange: 112,
        referenceNow: refNow,
      );

      expect(heatmap.totalEventsInPeriod, equals(6));
      expect(heatmap.currentStreak, equals(3));
      expect(heatmap.maxStreak, equals(3));
      expect(heatmap.dailyCounts[DateTime(2026, 8, 30)], equals(3));
      expect(heatmap.dailyCounts[DateTime(2026, 8, 29)], equals(1));
      expect(heatmap.dailyCounts[DateTime(2026, 8, 28)], equals(2));

      // Levels
      expect(heatmap.getLevel(0), equals(0));
      expect(heatmap.getLevel(1), equals(1));
      expect(heatmap.getLevel(3), equals(2));
      expect(heatmap.getLevel(7), equals(3));
      expect(heatmap.getLevel(12), equals(4));
    });
  });
}
