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
import 'package:platinum_world_management_system/src/features/entities/domain/world_entity.dart';
import 'package:platinum_world_management_system/src/features/entities/presentation/entity_detail_screen.dart';
import 'package:platinum_world_management_system/src/features/locations/presentation/location_or_container_selection_sheet.dart';

class FakePathProviderPlatform extends PathProviderPlatform
    with MockPlatformInterfaceMixin {
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

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('pwms_loc_flow_test_');
    PathProviderPlatform.instance = FakePathProviderPlatform(
      tempPath: p.join(tempDir.path, 'temp'),
      docsPath: p.join(tempDir.path, 'docs'),
    );
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('LocationOrContainerSelectionSheet & EntityDetailScreen Discard/Save flow', () {
    testWidgets('LocationOrContainerSelectionSheet returns LocationOrContainerSelection without mutating database', (WidgetTester tester) async {
      final now = DateTime.now();

      await db.into(db.catalogTable).insert(
            CatalogTableCompanion.insert(id: 'sp_item', name: 'Item Test', createdAt: now),
          );
      await db.into(db.catalogTable).insert(
            CatalogTableCompanion.insert(id: 'sp_box', name: 'Caja Test', type: const Value('Contenedor'), createdAt: now),
          );
      await db.into(db.locationsTable).insert(
            LocationsTableCompanion.insert(id: 'loc_room', name: 'Habitación', createdAt: now),
          );
      await db.into(db.entitiesTable).insert(
            EntitiesTableCompanion.insert(id: 'e_item', speciesId: 'sp_item', createdAt: now, updatedAt: now),
          );
      await db.into(db.entitiesTable).insert(
            EntitiesTableCompanion.insert(id: 'e_box', speciesId: 'sp_box', createdAt: now, updatedAt: now),
          );

      final itemEntity = WorldEntity(id: 'e_item', speciesId: 'sp_item', locationId: null, createdAt: now, updatedAt: now);

      dynamic returnedResult;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () async {
                    returnedResult = await LocationOrContainerSelectionSheet.show(
                      context,
                      initialSelection: const LocationOrContainerSelection.physicalNode(null),
                      excludedContainerIds: {itemEntity.id},
                    );
                  },
                  child: const Text('Open Sheet'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Open sheet
      await tester.tap(find.text('Open Sheet'));
      await tester.pumpAndSettle();

      // Switch to container mode
      await tester.tap(find.text(AppStrings.savedInContainer));
      await tester.pumpAndSettle();

      // Tap select container
      await tester.tap(find.text(AppStrings.selectContainerObject));
      await tester.pumpAndSettle();

      // Select 'Caja Test'
      expect(find.text('Caja Test'), findsWidgets);
      await tester.tap(find.text('Caja Test').first);
      await tester.pumpAndSettle();

      // Confirm selection
      await tester.tap(find.text(AppStrings.confirm));
      await tester.pumpAndSettle();

      // Check returned result
      expect(returnedResult, isA<LocationOrContainerSelection>());
      final correction = returnedResult as LocationOrContainerSelection;
      expect(correction.isContainerEntity, isTrue);
      expect(correction.containerEntityId, equals('e_box'));

      // Check database was NOT modified
      final relations = await db.select(db.relationsTable).get();
      expect(relations, isEmpty);

      final entityInDb = await (db.select(db.entitiesTable)..where((t) => t.id.equals('e_item'))).getSingle();
      expect(entityInDb.locationId, isNull);
    });

    testWidgets('EntityDetailScreen discarding location change keeps original entity location in DB', (WidgetTester tester) async {
      final now = DateTime.now();

      await db.into(db.catalogTable).insert(
            CatalogTableCompanion.insert(id: 'sp_gem', name: 'Rubí', createdAt: now),
          );
      await db.into(db.locationsTable).insert(
            LocationsTableCompanion.insert(id: 'loc_a', name: 'Estante A', createdAt: now),
          );
      await db.into(db.locationsTable).insert(
            LocationsTableCompanion.insert(id: 'loc_b', name: 'Estante B', createdAt: now),
          );
      await db.into(db.entitiesTable).insert(
            EntitiesTableCompanion.insert(id: 'e_gem', speciesId: 'sp_gem', locationId: const Value('loc_a'), createdAt: now, updatedAt: now),
          );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
          ],
          child: const MaterialApp(
            home: EntityDetailScreen(entityId: 'e_gem'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Original breadcrumb shows 'Estante A'
      expect(find.text('Estante A'), findsWidgets);

      // Enter edit mode
      await tester.tap(find.byTooltip(AppStrings.edit));
      await tester.pumpAndSettle();

      // Tap location card to open LocationOrContainerSelectionSheet
      await tester.tap(find.byIcon(Icons.edit_location));
      await tester.pumpAndSettle();

      // Pick location from tree
      await tester.tap(find.text('Mundo > Estante A'));
      await tester.pumpAndSettle();

      // Tap Estante B in tree
      expect(find.text('Estante B'), findsOneWidget);
      await tester.tap(find.text('Estante B'));
      await tester.pumpAndSettle();

      // Confirm in sheet
      await tester.tap(find.text(AppStrings.confirm));
      await tester.pumpAndSettle();

      // In EntityDetailScreen, working breadcrumb now shows 'Estante B'
      expect(find.text('Estante B'), findsWidgets);

      // Now cancel editing (Descartar)
      await tester.tap(find.byTooltip(AppStrings.cancel));
      await tester.pumpAndSettle();

      // Confirmation dialog should appear
      expect(find.text(AppStrings.unsavedChangesTitle), findsOneWidget);
      await tester.tap(find.text(AppStrings.discardChangesAction));
      await tester.pumpAndSettle();

      // EntityDetailScreen reverts back to viewing mode with 'Estante A'
      expect(find.text('Estante A'), findsWidgets);

      // Verify SQLite database was never changed
      final entityInDb = await (db.select(db.entitiesTable)..where((t) => t.id.equals('e_gem'))).getSingle();
      expect(entityInDb.locationId, equals('loc_a'));
    });

    testWidgets('EntityDetailScreen saving container change persists GUARDADO_EN relation and sets locationId to null in DB', (WidgetTester tester) async {
      final now = DateTime.now();

      await db.into(db.catalogTable).insert(
            CatalogTableCompanion.insert(id: 'sp_ring', name: 'Anillo', createdAt: now),
          );
      await db.into(db.catalogTable).insert(
            CatalogTableCompanion.insert(id: 'sp_chest', name: 'Cofre', type: const Value('Contenedor'), createdAt: now),
          );
      await db.into(db.locationsTable).insert(
            LocationsTableCompanion.insert(id: 'loc_safe', name: 'Bóveda', createdAt: now),
          );
      await db.into(db.entitiesTable).insert(
            EntitiesTableCompanion.insert(id: 'e_ring', speciesId: 'sp_ring', locationId: const Value('loc_safe'), createdAt: now, updatedAt: now),
          );
      await db.into(db.entitiesTable).insert(
            EntitiesTableCompanion.insert(id: 'e_chest', speciesId: 'sp_chest', locationId: const Value('loc_safe'), createdAt: now, updatedAt: now),
          );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
          ],
          child: const MaterialApp(
            home: EntityDetailScreen(entityId: 'e_ring'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Enter edit mode
      await tester.tap(find.byTooltip(AppStrings.edit));
      await tester.pumpAndSettle();

      // Tap location card
      await tester.tap(find.byIcon(Icons.edit_location));
      await tester.pumpAndSettle();

      // Switch to container
      await tester.tap(find.text(AppStrings.savedInContainer));
      await tester.pumpAndSettle();

      await tester.tap(find.text(AppStrings.selectContainerObject));
      await tester.pumpAndSettle();

      // Select 'Cofre'
      expect(find.text('Cofre'), findsWidgets);
      await tester.tap(find.text('Cofre').first);
      await tester.pumpAndSettle();

      // Confirm
      await tester.tap(find.text(AppStrings.confirm));
      await tester.pumpAndSettle();

      // Save changes in EntityDetailScreen
      await tester.tap(find.byTooltip(AppStrings.saveChangesAction));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 4));

      // Verify in DB
      final entityInDb = await (db.select(db.entitiesTable)..where((t) => t.id.equals('e_ring'))).getSingle();
      expect(entityInDb.locationId, isNull);

      final relations = await db.select(db.relationsTable).get();
      expect(relations.length, equals(1));
      expect(relations.first.sourceEntityId, equals('e_ring'));
      expect(relations.first.targetEntityId, equals('e_chest'));
      expect(relations.first.relationType, equals(AppTechnicalStrings.relGuardadoEn));
    });

    testWidgets('EntityDetailScreen saving change from container to physical location removes GUARDADO_EN and sets selected physical location in DB', (WidgetTester tester) async {
      final now = DateTime.now();

      await db.into(db.catalogTable).insert(
            CatalogTableCompanion.insert(id: 'sp_sword', name: 'Espada', createdAt: now),
          );
      await db.into(db.catalogTable).insert(
            CatalogTableCompanion.insert(id: 'sp_box', name: 'Caja Fuerte', type: const Value('Contenedor'), createdAt: now),
          );
      await db.into(db.locationsTable).insert(
            LocationsTableCompanion.insert(id: 'loc_vault', name: 'Bóveda Subterránea', createdAt: now),
          );
      await db.into(db.locationsTable).insert(
            LocationsTableCompanion.insert(id: 'loc_armory', name: 'Armería Principal', createdAt: now),
          );
      // Container e_box is placed in loc_vault
      await db.into(db.entitiesTable).insert(
            EntitiesTableCompanion.insert(id: 'e_box', speciesId: 'sp_box', locationId: const Value('loc_vault'), createdAt: now, updatedAt: now),
          );
      await db.into(db.instanceLocationsTable).insert(
            InstanceLocationsTableCompanion.insert(instanceId: 'e_box', locationId: 'loc_vault', createdAt: now),
          );
      // Item e_sword is contained in e_box (GUARDADO_EN)
      await db.into(db.entitiesTable).insert(
            EntitiesTableCompanion.insert(id: 'e_sword', speciesId: 'sp_sword', locationId: const Value(null), createdAt: now, updatedAt: now),
          );
      await db.into(db.relationsTable).insert(
            RelationsTableCompanion.insert(
              id: 'rel_sword_box',
              sourceEntityId: 'e_sword',
              targetEntityId: 'e_box',
              relationType: AppTechnicalStrings.relGuardadoEn,
              createdAt: now,
            ),
          );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
          ],
          child: const MaterialApp(
            home: EntityDetailScreen(entityId: 'e_sword'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Enter edit mode
      await tester.tap(find.byTooltip(AppStrings.edit));
      await tester.pumpAndSettle();

      // Tap location card to open LocationOrContainerSelectionSheet
      await tester.tap(find.byIcon(Icons.edit_location));
      await tester.pumpAndSettle();

      // Switch mode to physical node
      await tester.tap(find.text(AppStrings.physicalLocation));
      await tester.pumpAndSettle();

      // Open location tree picker
      await tester.tap(find.byIcon(Icons.account_tree_outlined).last);
      await tester.pumpAndSettle();

      // Select 'Armería Principal'
      expect(find.text('Armería Principal'), findsWidgets);
      await tester.tap(find.text('Armería Principal').first);
      await tester.pumpAndSettle();

      // Confirm in sheet
      await tester.tap(find.text(AppStrings.confirm));
      await tester.pumpAndSettle();

      // Save changes in EntityDetailScreen
      await tester.tap(find.byTooltip(AppStrings.saveChangesAction));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 4));

      // 1. Verify GUARDADO_EN relation was removed
      final relations = await (db.select(db.relationsTable)..where((t) => t.sourceEntityId.equals('e_sword'))).get();
      expect(relations, isEmpty);

      // 2. Verify entity has direct physical location 'loc_armory' (NOT container's 'loc_vault')
      final entityInDb = await (db.select(db.entitiesTable)..where((t) => t.id.equals('e_sword'))).getSingle();
      expect(entityInDb.locationId, equals('loc_armory'));

      // 3. Verify 4NF InstanceLocationsTable is updated with 'loc_armory'
      final locInDb = await (db.select(db.instanceLocationsTable)..where((t) => t.instanceId.equals('e_sword'))).getSingleOrNull();
      expect(locInDb, isNotNull);
      expect(locInDb!.locationId, equals('loc_armory'));
    });
  });
}
