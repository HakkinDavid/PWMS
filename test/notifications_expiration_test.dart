import 'dart:io';
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import 'package:platinum_world_management_system/src/core/constants/app_technical_strings.dart';
import 'package:platinum_world_management_system/src/core/database/app_database.dart';
import 'package:platinum_world_management_system/src/core/providers/providers.dart';
import 'package:platinum_world_management_system/src/features/catalog/presentation/species_tile.dart';
import 'package:platinum_world_management_system/src/features/entities/domain/effective_entity_group.dart';
import 'package:platinum_world_management_system/src/features/entities/domain/world_entity.dart';
import 'package:platinum_world_management_system/src/features/entities/presentation/instance_preview_card.dart';
import 'package:go_router/go_router.dart';
import 'package:platinum_world_management_system/src/features/control_center/presentation/control_center_screen.dart';
import 'package:platinum_world_management_system/src/features/notifications/domain/app_notification.dart';
import 'package:platinum_world_management_system/src/features/notifications/presentation/notifications_screen.dart';

class FakePathProviderPlatform extends PathProviderPlatform with MockPlatformInterfaceMixin {
  final String tempPath;
  final String docsPath;

  FakePathProviderPlatform({required this.tempPath, required this.docsPath});

  @override
  Future<String?> getTemporaryPath() async => tempPath;

  @override
  Future<String?> getApplicationDocumentsPath() async => docsPath;
}

void main() {
  late AppDatabase db;
  late Directory tempDir;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    tempDir = Directory.systemTemp.createTempSync('notif_test_');
    PathProviderPlatform.instance = FakePathProviderPlatform(
      tempPath: p.join(tempDir.path, 'temp'),
      docsPath: p.join(tempDir.path, 'docs'),
    );

    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

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

      expect(validEntity.isExpired(now: now), false);
      expect(validEntity.isExpiringSoon(warningDays: 7, now: now), false);
      expect(validEntity.isValid(now: now), true);

      expect(expiringSoonEntity.isExpired(now: now), false);
      expect(expiringSoonEntity.isExpiringSoon(warningDays: 7, now: now), true);
      expect(expiringSoonEntity.isValid(now: now), true);

      expect(expiredEntity.isExpired(now: now), true);
      expect(expiredEntity.isExpiringSoon(warningDays: 7, now: now), false);
      expect(expiredEntity.isValid(now: now), false);
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
      expect(group.expiredCount(now: now), 1);
      expect(group.expiringSoonCount(warningDays: 7, now: now), 1);
      expect(group.validCount(now: now), 2);
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
        snoozedUntil: DateTime.now().add(const Duration(days: 3)),
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

    test('Notification message builders do not interpolate species name', () {
      final msgExpired = AppStrings.notifMessageExpired('28/08/2026');
      final msgExpiringSoon = AppStrings.notifMessageExpiringSoon(3, '28/08/2026');
      final msgUnsatisfied = AppStrings.notifMessageUnsatisfiedNeed('2', 1, 3);

      expect(msgExpired.contains('Fecha de caducidad: 28/08/2026'), isTrue);
      expect(msgExpiringSoon.contains('Caduca en 3 día(s) (28/08/2026)'), isTrue);
      expect(msgUnsatisfied.contains('Faltan 2 unidad(es) (1.0/3.0 en inventario)'), isTrue);
    });

    testWidgets('NotificationsScreen renders standardized tiles for entity and species notifications',
        (WidgetTester tester) async {
      final now = DateTime.now();

      // Insert catalog items and entity
      await db.into(db.catalogTable).insert(
            CatalogTableCompanion.insert(
              id: 'sp_milk',
              name: 'Leche Deslactosada',
              isNonPerishable: const Value(false),
              createdAt: now,
            ),
          );

      await db.into(db.entitiesTable).insert(
            EntitiesTableCompanion.insert(
              id: 'e_milk_1',
              speciesId: 'sp_milk',
              expirationDate: Value(now.subtract(const Duration(days: 2))),
              createdAt: now,
              updatedAt: now,
            ),
          );

      // Insert notifications into DB
      await db.into(db.notificationsTable).insert(
            NotificationsTableCompanion.insert(
              id: 'notif_expired',
              type: AppTechnicalNotifications.notifTypeExpired,
              title: AppStrings.expiredItemTitle,
              message: AppStrings.notifMessageExpired('26/08/2026'),
              targetId: 'e_milk_1',
              targetType: AppTechnicalNotifications.notifTargetTypeEntity,
              status: const Value(AppTechnicalNotifications.notifStatusActive),
              createdAt: now,
              updatedAt: now,
            ),
          );

      await db.into(db.notificationsTable).insert(
            NotificationsTableCompanion.insert(
              id: 'notif_unsatisfied',
              type: AppTechnicalNotifications.notifTypeUnsatisfiedNeed,
              title: AppStrings.unsatisfiedNeedTitle,
              message: AppStrings.notifMessageUnsatisfiedNeed('1', 0, 1),
              targetId: 'sp_milk',
              targetType: AppTechnicalNotifications.notifTargetTypeSpecies,
              status: const Value(AppTechnicalNotifications.notifStatusActive),
              createdAt: now,
              updatedAt: now,
            ),
          );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
          ],
          child: const MaterialApp(
            home: NotificationsScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Check event titles are rendered
      expect(find.text(AppStrings.expiredItemTitle), findsOneWidget);
      expect(find.text(AppStrings.unsatisfiedNeedTitle), findsOneWidget);

      // Check messages without species name are rendered
      expect(find.text(AppStrings.notifMessageExpired('26/08/2026')), findsOneWidget);
      expect(find.text(AppStrings.notifMessageUnsatisfiedNeed('1', 0, 1)), findsOneWidget);

      // Check standardized tiles are rendered
      expect(find.byType(InstancePreviewCard), findsOneWidget);
      expect(find.byType(SpeciesTile), findsOneWidget);
    });

    testWidgets('Tapping on standardized tiles in Notifications navigates to entity and species details',
        (WidgetTester tester) async {
      final now = DateTime.now();

      await db.into(db.catalogTable).insert(
            CatalogTableCompanion.insert(
              id: 'sp_camera',
              name: 'Cámara Réflex',
              isNonPerishable: const Value(true),
              createdAt: now,
            ),
          );

      await db.into(db.entitiesTable).insert(
            EntitiesTableCompanion.insert(
              id: 'e_cam_1',
              speciesId: 'sp_camera',
              expirationDate: Value(now.add(const Duration(days: 2))),
              createdAt: now,
              updatedAt: now,
            ),
          );

      await db.into(db.notificationsTable).insert(
            NotificationsTableCompanion.insert(
              id: 'notif_cam_exp',
              type: AppTechnicalNotifications.notifTypeExpiringSoon,
              title: AppStrings.expiringSoonTitle,
              message: AppStrings.notifMessageExpiringSoon(2, '30/08/2026'),
              targetId: 'e_cam_1',
              targetType: AppTechnicalNotifications.notifTargetTypeEntity,
              status: const Value(AppTechnicalNotifications.notifStatusActive),
              createdAt: now,
              updatedAt: now,
            ),
          );

      final router = GoRouter(
        initialLocation: '/notifications',
        routes: [
          GoRoute(
            path: '/notifications',
            builder: (context, state) => const NotificationsScreen(),
          ),
          GoRoute(
            path: '/entity/:id',
            builder: (context, state) => Scaffold(
              body: Text('ENTITY_DETAIL_${state.pathParameters['id']}'),
            ),
          ),
          GoRoute(
            path: '/catalog/:id',
            builder: (context, state) => Scaffold(
              body: Text('SPECIES_DETAIL_${state.pathParameters['id']}'),
            ),
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
          ],
          child: MaterialApp.router(
            routerConfig: router,
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap on the InstancePreviewCard tile
      expect(find.byType(InstancePreviewCard), findsOneWidget);
      await tester.tap(find.byType(InstancePreviewCard));
      await tester.pumpAndSettle();

      // Verify navigation to entity detail
      expect(find.text('ENTITY_DETAIL_e_cam_1'), findsOneWidget);
    });

    testWidgets('Tapping on standardized tile in Control Center Card navigates to entity detail',
        (WidgetTester tester) async {
      final now = DateTime.now();

      await db.into(db.catalogTable).insert(
            CatalogTableCompanion.insert(
              id: 'sp_milk_perishable',
              name: 'Leche Fresca',
              isNonPerishable: const Value(false),
              createdAt: now,
            ),
          );

      // Orphan entity without expiration (will trigger integrity card)
      await db.into(db.entitiesTable).insert(
            EntitiesTableCompanion.insert(
              id: 'e_milk_orphan_card',
              speciesId: 'sp_milk_perishable',
              locationId: const Value(null),
              expirationDate: const Value(null),
              createdAt: now,
              updatedAt: now,
            ),
          );

      final router = GoRouter(
        initialLocation: '/control-center',
        routes: [
          GoRoute(
            path: '/control-center',
            builder: (context, state) => const ControlCenterScreen(),
          ),
          GoRoute(
            path: '/entity/:id',
            builder: (context, state) => Scaffold(
              body: Text('ENTITY_DETAIL_${state.pathParameters['id']}'),
            ),
          ),
          GoRoute(
            path: '/catalog/:id',
            builder: (context, state) => Scaffold(
              body: Text('SPECIES_DETAIL_${state.pathParameters['id']}'),
            ),
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
          ],
          child: MaterialApp.router(
            routerConfig: router,
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find the InstancePreviewCard in Control Center Card stack
      expect(find.byType(InstancePreviewCard), findsWidgets);
      await tester.tap(find.byType(InstancePreviewCard).first);
      await tester.pumpAndSettle();

      // Verify navigation to entity detail occurred
      expect(find.text('ENTITY_DETAIL_e_milk_orphan_card'), findsOneWidget);
    });
  });
}
