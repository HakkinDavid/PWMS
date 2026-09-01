import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import 'package:platinum_world_management_system/src/core/database/app_database.dart';
import 'package:platinum_world_management_system/src/core/providers/providers.dart';
import 'package:platinum_world_management_system/src/features/entities/domain/world_entity.dart';
import 'package:platinum_world_management_system/src/features/entities/presentation/container_contents_view.dart';
import 'package:platinum_world_management_system/src/features/entities/presentation/entity_tile.dart';
import 'package:platinum_world_management_system/src/features/entities/presentation/instance_preview_card.dart';
import 'package:platinum_world_management_system/src/features/locations/domain/location_node.dart';
import 'package:platinum_world_management_system/src/features/search/presentation/search_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  group('Tile Integration & Badge Tests', () {
    testWidgets('InstancePreviewCard renders Container, Orphan, Conflict, and Expiration Badges',
        (WidgetTester tester) async {
      final now = DateTime.now();

      // 1. Perishable species with warning days
      await db.into(db.catalogTable).insert(
            CatalogTableCompanion.insert(
              id: 'sp_milk',
              name: 'Leche Deslactosada',
              isNonPerishable: const Value(false),
              defaultShelfLifeDays: const Value(7),
              warningDaysBeforeExpiration: const Value(3),
              createdAt: now,
            ),
          );

      // 2. Container species
      await db.into(db.catalogTable).insert(
            CatalogTableCompanion.insert(
              id: 'sp_fridge',
              name: 'Refrigerador',
              createdAt: now,
            ),
          );

      // Location node
      await db.into(db.locationsTable).insert(
            LocationsTableCompanion.insert(
              id: 'loc_kitchen',
              name: 'Cocina',
              createdAt: now,
            ),
          );

      // Entities:
      // - Container entity (in Cocina)
      await db.into(db.entitiesTable).insert(
            EntitiesTableCompanion.insert(
              id: 'e_fridge',
              speciesId: 'sp_fridge',
              locationId: const Value('loc_kitchen'),
              createdAt: now,
              updatedAt: now,
            ),
          );

      // - Contained item with location conflict (inside fridge AND has explicit location)
      await db.into(db.entitiesTable).insert(
            EntitiesTableCompanion.insert(
              id: 'e_milk_1',
              speciesId: 'sp_milk',
              locationId: const Value('loc_kitchen'), // Conflict because it's also inside fridge
              expirationDate: Value(now.subtract(const Duration(days: 1))), // Expired
              createdAt: now,
              updatedAt: now,
            ),
          );

      // - Orphan item (no location and not contained) + missing expiration (perishable but expirationDate is null)
      await db.into(db.entitiesTable).insert(
            EntitiesTableCompanion.insert(
              id: 'e_milk_orphan',
              speciesId: 'sp_milk',
              locationId: const Value(null),
              expirationDate: const Value(null), // Missing expiration
              createdAt: now,
              updatedAt: now,
            ),
          );

      // Relation: e_milk_1 is GUARDADO_EN e_fridge
      await db.into(db.relationsTable).insert(
            RelationsTableCompanion.insert(
              id: 'rel_fridge_milk',
              sourceEntityId: 'e_milk_1',
              targetEntityId: 'e_fridge',
              relationType: 'GUARDADO_EN',
              createdAt: now,
            ),
          );

      final containerEntity = WorldEntity(
        id: 'e_fridge',
        speciesId: 'sp_fridge',
        locationId: 'loc_kitchen',
        createdAt: now,
        updatedAt: now,
      );

      final conflictEntity = WorldEntity(
        id: 'e_milk_1',
        speciesId: 'sp_milk',
        locationId: 'loc_kitchen',
        expirationDate: now.subtract(const Duration(days: 1)),
        createdAt: now,
        updatedAt: now,
      );

      final orphanEntity = WorldEntity(
        id: 'e_milk_orphan',
        speciesId: 'sp_milk',
        locationId: null,
        expirationDate: null,
        createdAt: now,
        updatedAt: now,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: ListView(
                children: [
                  InstancePreviewCard(entity: containerEntity),
                  InstancePreviewCard(entity: conflictEntity),
                  InstancePreviewCard(entity: orphanEntity),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify Expired Status Badge: "Caducado"
      expect(find.text(AppStrings.statusExpired), findsOneWidget);

      // Verify Orphan Badge: "Sin ubicación"
      expect(find.text(AppStrings.badgeOrphan), findsOneWidget);

      // Verify Missing Expiration Badge: "Sin caducidad"
      expect(find.text(AppStrings.badgeMissingExpiration), findsOneWidget);
    });

    testWidgets('SearchScreen Contenedores scope tab renders container tiles',
        (WidgetTester tester) async {
      final now = DateTime.now();

      await db.into(db.catalogTable).insert(
            CatalogTableCompanion.insert(id: 'sp_box', name: 'Caja Fuerte', createdAt: now),
          );
      await db.into(db.catalogTable).insert(
            CatalogTableCompanion.insert(id: 'sp_gold', name: 'Moneda de Oro', createdAt: now),
          );

      await db.into(db.entitiesTable).insert(
            EntitiesTableCompanion.insert(id: 'e_vault', speciesId: 'sp_box', createdAt: now, updatedAt: now),
          );
      await db.into(db.entitiesTable).insert(
            EntitiesTableCompanion.insert(id: 'e_coin', speciesId: 'sp_gold', createdAt: now, updatedAt: now),
          );

      await db.into(db.relationsTable).insert(
            RelationsTableCompanion.insert(
              id: 'r_vault',
              sourceEntityId: 'e_coin',
              targetEntityId: 'e_vault',
              relationType: 'GUARDADO_EN',
              createdAt: now,
            ),
          );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
          ],
          child: const MaterialApp(
            home: SearchScreen(initialScope: AppStrings.tabContainers),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify container entity e_vault is rendered in an EntityTile
      expect(find.byType(EntityTile), findsOneWidget);
      expect(find.text('Caja Fuerte'), findsWidgets);
    });

    testWidgets('SQL Console View Mode switch toggles between Tiles and Table',
        (WidgetTester tester) async {
      final now = DateTime.now();

      await db.into(db.catalogTable).insert(
            CatalogTableCompanion.insert(id: 'sp_tool', name: 'Herramienta Rotativa', createdAt: now),
          );
      await db.into(db.entitiesTable).insert(
            EntitiesTableCompanion.insert(id: 'e_dremel', speciesId: 'sp_tool', createdAt: now, updatedAt: now),
          );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
          ],
          child: const MaterialApp(
            home: SearchScreen(initialScope: AppStrings.arbitrarySqlQueryLabel),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Open presets picker via AppWheelPicker and pick "Instancias"
      final presetButton = find.widgetWithIcon(FilledButton, Icons.bookmark_border);
      await tester.tap(presetButton);
      await tester.pumpAndSettle();

      final confirmBtn = find.widgetWithText(ElevatedButton, AppStrings.confirm);
      await tester.tap(confirmBtn);
      await tester.pumpAndSettle();

      // In default Tiles (Tarjetas) view mode (Item j), EntityTile is rendered
      expect(find.byType(EntityTile), findsOneWidget);
      expect(find.text('Herramienta Rotativa'), findsWidgets);

      // Switch to Table view mode via SegmentedButton
      final tableSegment = find.text(AppStrings.viewModeTable);
      expect(tableSegment, findsOneWidget);
      await tester.tap(tableSegment);
      await tester.pumpAndSettle();

      // In Table view mode, DataTable is rendered
      expect(find.byType(DataTable), findsOneWidget);
      expect(find.text('e_dremel'), findsOneWidget);
    });

    testWidgets('InstancePreviewCard with InstanceCardLayout.compactCard renders correctly',
        (WidgetTester tester) async {
      final now = DateTime.now();

      await db.into(db.catalogTable).insert(
            CatalogTableCompanion.insert(id: 'sp_camera', name: 'Cámara Réflex', createdAt: now),
          );
      await db.into(db.entitiesTable).insert(
            EntitiesTableCompanion.insert(id: 'e_camera_1', speciesId: 'sp_camera', createdAt: now, updatedAt: now),
          );

      final entity = WorldEntity(
        id: 'e_camera_1',
        speciesId: 'sp_camera',
        createdAt: now,
        updatedAt: now,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: InstancePreviewCard(
                entity: entity,
                layout: InstanceCardLayout.compactCard,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Cámara Réflex'), findsOneWidget);
    });

    testWidgets('ContainerContentsView renders EntityTile for child entities',
        (WidgetTester tester) async {
      final now = DateTime.now();

      await db.into(db.locationsTable).insert(
            LocationsTableCompanion.insert(id: 'loc_drawer', name: 'Cajón', createdAt: now),
          );
      await db.into(db.catalogTable).insert(
            CatalogTableCompanion.insert(id: 'sp_notebook', name: 'Cuaderno', createdAt: now),
          );
      await db.into(db.entitiesTable).insert(
            EntitiesTableCompanion.insert(id: 'e_note_1', speciesId: 'sp_notebook', locationId: const Value('loc_drawer'), createdAt: now, updatedAt: now),
          );

      final location = LocationNode(
        id: 'loc_drawer',
        name: 'Cajón',
        createdAt: now,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: ContainerContentsView(location: location),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(EntityTile), findsOneWidget);
      expect(find.text('Cuaderno'), findsOneWidget);
    });
  });
}
