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
import 'package:platinum_world_management_system/src/core/database/app_database.dart';
import 'package:platinum_world_management_system/src/core/providers/providers.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/catalog_item.dart';
import 'package:platinum_world_management_system/src/features/entities/domain/entity_template.dart';
import 'package:platinum_world_management_system/src/features/entities/domain/world_entity.dart';
import 'package:platinum_world_management_system/src/features/home/presentation/inventory_finder_screen.dart';
import 'package:platinum_world_management_system/src/features/locations/domain/location_node.dart';
import 'package:platinum_world_management_system/src/features/locations/domain/location_path_helper.dart';
import 'package:platinum_world_management_system/src/features/locations/presentation/location_or_container_correction_sheet.dart';
import 'package:platinum_world_management_system/src/features/relations/domain/entity_relation.dart';
import 'package:platinum_world_management_system/src/features/relations/presentation/interactive_entity_graph_widget.dart';

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

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    tempDir = Directory.systemTemp.createTempSync('loc_rel_refresh_test_');
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

  group('Location & Relation Integrity Tests', () {
    test('EntityTemplateRegistry.directedRelationTypes does not contain GUARDADO_EN', () {
      expect(EntityTemplateRegistry.directedRelationTypes.contains('GUARDADO_EN'), isFalse);
      expect(EntityTemplateRegistry.directedRelationTypes, contains('PERTENECE_A'));
      expect(EntityTemplateRegistry.directedRelationTypes, contains('PARTE_DE'));
      expect(EntityTemplateRegistry.directedRelationTypes, contains('DOCUMENTA'));
      expect(EntityTemplateRegistry.directedRelationTypes, contains('USA'));
    });

    test('LocationPathHelper.buildEffectiveBreadcrumb resolves physical location of container', () {
      final now = DateTime.now();

      final List<LocationNode> nodes = [
        LocationNode(id: 'loc_house', name: 'Casa', createdAt: now),
        LocationNode(id: 'loc_kitchen', name: 'Cocina', parentLocationId: 'loc_house', createdAt: now),
      ];

      final List<CatalogItem> catalog = [
        CatalogItem(id: 'sp_backpack', name: 'Mochila', type: 'Objeto', createdAt: now),
        CatalogItem(id: 'sp_key', name: 'Llave', type: 'Objeto', createdAt: now),
      ];

      final List<WorldEntity> entities = [
        WorldEntity(id: 'e_backpack', speciesId: 'sp_backpack', locationId: 'loc_kitchen', createdAt: now, updatedAt: now),
        WorldEntity(id: 'e_key', speciesId: 'sp_key', locationId: null, createdAt: now, updatedAt: now),
      ];

      final List<EntityRelation> relations = [
        EntityRelation(
          id: 'rel_1',
          sourceEntityId: 'e_key',
          targetEntityId: 'e_backpack',
          relationType: 'GUARDADO_EN',
          createdAt: now,
        ),
      ];

      final breadcrumb = LocationPathHelper.buildEffectiveBreadcrumb(
        entityId: 'e_key',
        effectiveLocationId: null,
        allEntities: entities,
        allRelations: relations,
        allNodes: nodes,
        catalogItems: catalog,
      );

      // Should show Casa > Cocina @ Mochila instead of Raíz @ Mochila
      expect(breadcrumb.ancestorPath, contains('Casa > Cocina @'));
      expect(breadcrumb.targetName, equals('Mochila'));
      expect(breadcrumb.fullPath, contains('Casa > Cocina @ Mochila'));
    });

    testWidgets('InteractiveEntityGraphWidget hides outgoing GUARDADO_EN relations but keeps incoming', (WidgetTester tester) async {
      final now = DateTime.now();

      await db.into(db.catalogTable).insert(
            CatalogTableCompanion.insert(id: 'sp_box', name: 'Caja', createdAt: now),
          );
      await db.into(db.catalogTable).insert(
            CatalogTableCompanion.insert(id: 'sp_item', name: 'Objeto Actual', createdAt: now),
          );
      await db.into(db.catalogTable).insert(
            CatalogTableCompanion.insert(id: 'sp_inner', name: 'Objeto Interno', createdAt: now),
          );
      await db.into(db.catalogTable).insert(
            CatalogTableCompanion.insert(id: 'sp_doc', name: 'Manual', createdAt: now),
          );

      await db.into(db.entitiesTable).insert(
            EntitiesTableCompanion.insert(id: 'e_box', speciesId: 'sp_box', createdAt: now, updatedAt: now),
          );
      await db.into(db.entitiesTable).insert(
            EntitiesTableCompanion.insert(id: 'e_item', speciesId: 'sp_item', createdAt: now, updatedAt: now),
          );
      await db.into(db.entitiesTable).insert(
            EntitiesTableCompanion.insert(id: 'e_inner', speciesId: 'sp_inner', createdAt: now, updatedAt: now),
          );
      await db.into(db.entitiesTable).insert(
            EntitiesTableCompanion.insert(id: 'e_doc', speciesId: 'sp_doc', createdAt: now, updatedAt: now),
          );

      // Outgoing GUARDADO_EN (e_item is inside e_box) -> SHOULD BE HIDDEN in graph
      await db.into(db.relationsTable).insert(
            RelationsTableCompanion.insert(
              id: 'rel_outgoing_guardado',
              sourceEntityId: 'e_item',
              targetEntityId: 'e_box',
              relationType: 'GUARDADO_EN',
              createdAt: now,
            ),
          );

      // Incoming GUARDADO_EN (e_inner is inside e_item) -> SHOULD BE VISIBLE in graph
      await db.into(db.relationsTable).insert(
            RelationsTableCompanion.insert(
              id: 'rel_incoming_guardado',
              sourceEntityId: 'e_inner',
              targetEntityId: 'e_item',
              relationType: 'GUARDADO_EN',
              createdAt: now,
            ),
          );

      // Outgoing other relation (e_item DOCUMENTA e_doc) -> SHOULD BE VISIBLE in graph
      await db.into(db.relationsTable).insert(
            RelationsTableCompanion.insert(
              id: 'rel_outgoing_doc',
              sourceEntityId: 'e_item',
              targetEntityId: 'e_doc',
              relationType: 'DOCUMENTA',
              createdAt: now,
            ),
          );

      final currentEntity = WorldEntity(
        id: 'e_item',
        speciesId: 'sp_item',
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
              body: InteractiveEntityGraphWidget(
                currentEntity: currentEntity,
                isEditing: false,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Chip count should be 2 vínculos (not 3, because outgoing GUARDADO_EN is hidden)
      expect(find.text('2 vínculos'), findsOneWidget);

      // Should find DOCUMENTA and incoming GUARDADO_EN (Objeto Interno)
      expect(find.text('DOCUMENTA'), findsOneWidget);
      expect(find.text('Objeto Interno'), findsOneWidget);

      // Should NOT find Caja in the graph list (since e_box was the target of the outgoing GUARDADO_EN)
      expect(find.text('Caja'), findsNothing);
    });

    testWidgets('LocationOrContainerCorrectionSheet correctly switches to physical location', (WidgetTester tester) async {
      final now = DateTime.now();

      await db.into(db.catalogTable).insert(
            CatalogTableCompanion.insert(id: 'sp_wallet', name: 'Cartera', createdAt: now),
          );
      await db.into(db.locationsTable).insert(
            LocationsTableCompanion.insert(id: 'loc_desk', name: 'Escritorio', createdAt: now),
          );
      await db.into(db.entitiesTable).insert(
            EntitiesTableCompanion.insert(id: 'e_wallet', speciesId: 'sp_wallet', createdAt: now, updatedAt: now),
          );

      final entity = WorldEntity(id: 'e_wallet', speciesId: 'sp_wallet', locationId: null, createdAt: now, updatedAt: now);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: LocationOrContainerCorrectionSheet(entity: entity),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text(AppStrings.correctLocationTitlePrefix + 'Cartera' + AppStrings.correctLocationTitleSuffix), findsOneWidget);
      expect(find.text(AppStrings.physicalLocation), findsOneWidget);
      expect(find.text(AppStrings.savedInContainer), findsOneWidget);
    });

    testWidgets('InventoryFinderScreen with initialLocationId filters to that location and displays breadcrumb', (WidgetTester tester) async {
      final now = DateTime.now();

      await db.into(db.catalogTable).insert(
            CatalogTableCompanion.insert(id: 'sp_lamp', name: 'Lámpara', createdAt: now),
          );
      await db.into(db.catalogTable).insert(
            CatalogTableCompanion.insert(id: 'sp_bed', name: 'Cama', createdAt: now),
          );
      await db.into(db.locationsTable).insert(
            LocationsTableCompanion.insert(id: 'loc_house', name: 'Casa', createdAt: now),
          );
      await db.into(db.locationsTable).insert(
            LocationsTableCompanion.insert(id: 'loc_bedroom', name: 'Habitación', parentLocationId: const Value('loc_house'), createdAt: now),
          );

      await db.into(db.entitiesTable).insert(
            EntitiesTableCompanion.insert(id: 'e_lamp', speciesId: 'sp_lamp', locationId: const Value('loc_bedroom'), createdAt: now, updatedAt: now),
          );
      await db.into(db.entitiesTable).insert(
            EntitiesTableCompanion.insert(id: 'e_bed', speciesId: 'sp_bed', locationId: const Value('loc_house'), createdAt: now, updatedAt: now),
          );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
          ],
          child: const MaterialApp(
            home: InventoryFinderScreen(initialLocationId: 'loc_bedroom'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Breadcrumbs should show Casa and Habitación chips
      expect(find.text('Casa'), findsWidgets);
      expect(find.text('Habitación'), findsWidgets);

      // Should find Lámpara (which is in loc_bedroom, found in tile title and avatar fallback)
      expect(find.text('Lámpara'), findsNWidgets(2));
      // Should NOT find Cama in loc_bedroom list (since Cama is directly in loc_house, not loc_bedroom)
      expect(find.text('Cama'), findsNothing);
    });

    testWidgets('InventoryFinderScreen with startWithCurtainOpen opens the location curtain', (WidgetTester tester) async {
      final now = DateTime.now();

      await db.into(db.locationsTable).insert(
            LocationsTableCompanion.insert(id: 'loc_root1', name: 'Oficina Central', createdAt: now),
          );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
          ],
          child: const MaterialApp(
            home: InventoryFinderScreen(startWithCurtainOpen: true),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Because curtain started open, the root location 'Oficina Central' in the curtain list should be visible
      expect(find.text('Oficina Central'), findsOneWidget);
    });
  });
}
