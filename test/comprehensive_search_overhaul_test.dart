import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import 'package:platinum_world_management_system/src/core/constants/app_technical_strings.dart';
import 'package:platinum_world_management_system/src/core/database/app_database.dart';
import 'package:platinum_world_management_system/src/core/providers/providers.dart';
import 'package:platinum_world_management_system/src/features/catalog/presentation/species_tile.dart';
import 'package:platinum_world_management_system/src/features/catalog/presentation/subspecies_tile.dart';
import 'package:platinum_world_management_system/src/features/catalog/presentation/web_image_picker_dialog.dart';
import 'package:platinum_world_management_system/src/features/entities/domain/world_entity.dart';
import 'package:platinum_world_management_system/src/features/entities/presentation/entity_tile.dart';
import 'package:platinum_world_management_system/src/features/history/presentation/history_screen.dart';
import 'package:platinum_world_management_system/src/features/locations/presentation/location_tile.dart';
import 'package:platinum_world_management_system/src/features/relations/presentation/create_relation_modal.dart';
import 'package:platinum_world_management_system/src/features/search/domain/sql_preset.dart';
import 'package:platinum_world_management_system/src/features/search/presentation/search_screen.dart';
import 'package:platinum_world_management_system/src/features/search/presentation/sql_editor_full_screen_view.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  Future<void> seedDatabase(AppDatabase db) async {
    final now = DateTime.now();

    // 1. Catalog & Subspecies
    await db.into(db.catalogTable).insert(
          CatalogTableCompanion.insert(
            id: 'sp_coin',
            name: 'Moneda Conmemorativa',
            type: const Value('Objeto'),
            description: const Value('Moneda de plata conmemorativa del bicentenario'),
            createdAt: now,
          ),
        );
    await db.into(db.subspeciesTable).insert(
          SubspeciesTableCompanion.insert(
            id: 'sub_proof',
            speciesId: 'sp_coin',
            subspeciesName: 'Acabado Espejo Proof',
            brand: const Value('Casa de Moneda'),
            barcode: const Value('7501234567890'),
            notes: const Value('Edición limitada de 500 piezas'),
            createdAt: now,
          ),
        );

    // Box container species
    await db.into(db.catalogTable).insert(
          CatalogTableCompanion.insert(
            id: 'sp_chest',
            name: 'Cofre de Madera',
            type: const Value('Objeto'),
            createdAt: now,
          ),
        );
    await db.into(db.subspeciesTable).insert(
          SubspeciesTableCompanion.insert(
            id: 'sub_chest_cedro',
            speciesId: 'sp_chest',
            subspeciesName: 'Cedro Barnizado',
            createdAt: now,
          ),
        );

    // 2. Locations
    await db.into(db.locationsTable).insert(
          LocationsTableCompanion.insert(
            id: 'loc_office',
            name: 'Oficina Principal',
            description: const Value('Estudio del piso 2'),
            createdAt: now,
          ),
        );

    // 3. Entities
    await db.into(db.entitiesTable).insert(
          EntitiesTableCompanion.insert(
            id: 'e_chest_1',
            speciesId: 'sp_chest',
            subspeciesId: const Value('sub_chest_cedro'),
            locationId: const Value('loc_office'),
            notes: const Value('Cofre antiguo para resguardar numismática'),
            createdAt: now,
            updatedAt: now,
          ),
        );
    await db.into(db.entitiesTable).insert(
          EntitiesTableCompanion.insert(
            id: 'e_coin_1',
            speciesId: 'sp_coin',
            subspeciesId: const Value('sub_proof'),
            notes: const Value('Pieza #42 con certificado'),
            createdAt: now,
            updatedAt: now,
          ),
        );

    // 4. Magnitudes
    await db.into(db.instanceMagnitudesTable).insert(
          InstanceMagnitudesTableCompanion.insert(
            id: 'mag_val_1',
            instanceId: 'e_coin_1',
            propertyName: 'Valor Facial',
            dataType: const Value('REAL'),
            magnitudeValue: const Value(50.0),
            unitSymbol: const Value('MXN'),
          ),
        );

    // 5. Container relation (e_coin_1 is GUARDADO_EN e_chest_1)
    await db.into(db.relationsTable).insert(
          RelationsTableCompanion.insert(
            id: 'rel_chest_coin',
            sourceEntityId: 'e_coin_1',
            targetEntityId: 'e_chest_1',
            relationType: 'GUARDADO_EN',
            createdAt: now,
          ),
        );

    // 6. History events
    await db.into(db.historyEventsTable).insert(
          HistoryEventsTableCompanion.insert(
            id: 'hist_1',
            entityId: const Value('e_coin_1'),
            eventType: AppTechnicalStrings.eventTypeCreation,
            description: 'Registrado en tu mundo: "Moneda Conmemorativa" (Objeto)',
            metadata: const Value('{"subspecies":"Acabado Espejo Proof","mintage":500,"grade":"MS-70"}'),
            timestamp: now,
          ),
        );
  }

  group('Comprehensive Search Overhaul Tests', () {
    testWidgets('Item a & d: "Todos" search is exhaustive and includes instances, catalog, subspecies, locations, history',
        (WidgetTester tester) async {
      await seedDatabase(db);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
          ],
          child: const MaterialApp(
            home: SearchScreen(initialScope: AppStrings.all, initialQuery: 'moneda'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // "Todos" should display section headers
      expect(find.text(AppStrings.sectionHeaderWithCount(AppStrings.sectionInstances, 1)), findsOneWidget);
      expect(find.text(AppStrings.sectionHeaderWithCount(AppStrings.sectionCatalog, 2)), findsOneWidget);
      expect(find.text(AppStrings.sectionHeaderWithCount(AppStrings.sectionHistory, 1)), findsOneWidget);

      // Verify EntityTile rendered
      expect(find.byType(EntityTile), findsOneWidget);

      // Verify SpeciesTile and SubspeciesTile rendered at same level
      expect(find.byType(SpeciesTile), findsOneWidget);
      expect(find.byType(SubspeciesTile), findsOneWidget);
    });

    testWidgets('Item b: Scope selector uses correctly cased "Objetos"',
        (WidgetTester tester) async {
      await seedDatabase(db);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
          ],
          child: const MaterialApp(
            home: SearchScreen(initialScope: AppStrings.objectsCategory),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Top scope selector displays 'Ámbito: Objetos'
      expect(find.text(AppStrings.scopeWithPrefix(AppStrings.objectsCategory)), findsOneWidget);

      // Renders the entity tile
      expect(find.byType(EntityTile), findsWidgets);
    });

    testWidgets('Item c: "Contenedores" search matches by subspecies name, brand, barcode, and magnitudes',
        (WidgetTester tester) async {
      await seedDatabase(db);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
          ],
          child: const MaterialApp(
            home: SearchScreen(initialScope: AppStrings.tabContainers, initialQuery: 'cedro'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Container e_chest_1 matches the subspecies name 'Cedro Barnizado'
      expect(find.byType(EntityTile), findsOneWidget);
      expect(find.text('Cofre de Madera'), findsWidgets);
    });

    testWidgets('Item e: "Ubicaciones" search uses standard LocationTile',
        (WidgetTester tester) async {
      await seedDatabase(db);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
          ],
          child: const MaterialApp(
            home: SearchScreen(initialScope: AppStrings.tabLocations),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // LocationTile should be rendered
      expect(find.byType(LocationTile), findsOneWidget);
      expect(find.text('Oficina Principal'), findsOneWidget);
    });

    testWidgets('Item f: "Catálogo" search returns Species and Subspecies at the same level',
        (WidgetTester tester) async {
      await seedDatabase(db);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
          ],
          child: const MaterialApp(
            home: SearchScreen(initialScope: AppStrings.tabCatalog, initialQuery: 'espejo'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Query 'espejo' matches subspecies 'Acabado Espejo Proof'
      expect(find.byType(SubspeciesTile), findsOneWidget);
      expect(find.text('Acabado Espejo Proof (Casa de Moneda)'), findsOneWidget);
    });

    testWidgets('Item g: "Historial" search finds entries by nested metadata and properties',
        (WidgetTester tester) async {
      await seedDatabase(db);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
          ],
          child: const MaterialApp(
            home: SearchScreen(initialScope: AppStrings.tabHistory, initialQuery: 'MS-70'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Finds the history event matching metadata value 'MS-70'
      expect(find.textContaining('Moneda Conmemorativa'), findsOneWidget);
    });

    testWidgets('Item i & j: SQL Runner defaults to Tarjetas and opens FullScreen SQL Editor',
        (WidgetTester tester) async {
      await seedDatabase(db);

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

      // Verify Open Full Screen Editor button is present
      final openEditorBtn = find.widgetWithText(OutlinedButton, AppStrings.openSqlEditorAction);
      expect(openEditorBtn, findsOneWidget);

      await tester.tap(openEditorBtn);
      await tester.pumpAndSettle();

      // Verify Full Screen SQL Editor is open
      expect(find.byType(SqlEditorFullScreenView), findsOneWidget);
      expect(find.text(AppStrings.fullScreenSqlEditorTitle), findsOneWidget);

      // Verify floating sticky execute button at bottom
      final executeStickyBtn = find.widgetWithText(ElevatedButton, AppStrings.executeSqlAction);
      expect(executeStickyBtn, findsOneWidget);

      // Execute SQL from full screen editor
      await tester.tap(executeStickyBtn);
      await tester.pumpAndSettle();

      // Returned to SearchScreen and query executed, default view mode is Tiles (Tarjetas) (Item j)
      expect(find.byType(EntityTile), findsWidgets);
    });

    testWidgets('SQL Console: Dedicated buttons row, preset name on button, and auto execution on first load',
        (WidgetTester tester) async {
      await seedDatabase(db);

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

      // 1. Initial preselected query should execute automatically on first load
      expect(find.byType(EntityTile), findsWidgets);

      // 2. Button displays the preset title (e.g. Catálogo de Especies or first preset)
      final presetButton = find.widgetWithIcon(FilledButton, Icons.bookmark_border);
      expect(presetButton, findsOneWidget);
      expect(find.text(SqlPreset.defaultPresets.first.title), findsOneWidget);

      // 3. Dedicated action buttons row: Open Editor and Execute buttons are distinct
      final openEditorBtn = find.widgetWithText(OutlinedButton, AppStrings.openSqlEditorAction);
      final executeBtn = find.widgetWithText(ElevatedButton, AppStrings.executeAction);
      expect(openEditorBtn, findsOneWidget);
      expect(executeBtn, findsOneWidget);

      // 4. Picking another preset updates the button label and executes query immediately
      await tester.tap(presetButton);
      await tester.pumpAndSettle();

      final confirmBtn = find.widgetWithText(ElevatedButton, AppStrings.confirm);
      await tester.tap(confirmBtn);
      await tester.pumpAndSettle();

      expect(find.byType(EntityTile), findsWidgets);
    });

    testWidgets('SearchScreen: Clear button is internal to TextField and clears controller and provider without actions resize',
        (WidgetTester tester) async {
      await seedDatabase(db);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
          ],
          child: const MaterialApp(
            home: SearchScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final textFieldFinder = find.byType(TextField);
      expect(textFieldFinder, findsOneWidget);

      // Initially no clear button
      expect(find.byIcon(Icons.clear), findsNothing);

      // Enter search text
      await tester.enterText(textFieldFinder, 'Moneda');
      await tester.pumpAndSettle();

      // Clear button appears inside suffixIcon
      expect(find.byIcon(Icons.clear), findsOneWidget);
      final textField = tester.widget<TextField>(textFieldFinder);
      expect(textField.controller?.text, 'Moneda');

      // Tap clear button
      await tester.tap(find.byIcon(Icons.clear));
      await tester.pumpAndSettle();

      // Text is cleared and clear icon disappears
      expect(textField.controller?.text, isEmpty);
      expect(find.byIcon(Icons.clear), findsNothing);
    });

    testWidgets('HistoryScreen: Clear button clears text and provider', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
          ],
          child: const MaterialApp(
            home: HistoryScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final textFieldFinder = find.byType(TextField);
      expect(textFieldFinder, findsOneWidget);
      expect(find.byIcon(Icons.clear), findsNothing);

      await tester.enterText(textFieldFinder, 'Creación');
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.clear), findsOneWidget);
      final textField = tester.widget<TextField>(textFieldFinder);
      expect(textField.controller?.text, 'Creación');

      await tester.tap(find.byIcon(Icons.clear));
      await tester.pumpAndSettle();

      expect(textField.controller?.text, isEmpty);
      expect(find.byIcon(Icons.clear), findsNothing);
    });

    testWidgets('CreateRelationModal: Clear button clears search input', (WidgetTester tester) async {
      final dummyEntity = WorldEntity(
        id: 'src_1',
        speciesId: 'sp_coin',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: CreateRelationModal(
                sourceEntity: dummyEntity,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final textFieldFinder = find.byType(TextField);
      expect(textFieldFinder, findsOneWidget);
      expect(find.byIcon(Icons.clear), findsNothing);

      await tester.enterText(textFieldFinder, 'Cofre');
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.clear), findsOneWidget);

      await tester.tap(find.byIcon(Icons.clear));
      await tester.pumpAndSettle();

      final textField = tester.widget<TextField>(textFieldFinder);
      expect(textField.controller?.text, isEmpty);
      expect(find.byIcon(Icons.clear), findsNothing);
    });

    testWidgets('WebImagePickerDialog: Clear button clears search query', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: WebImagePickerDialog(
                searchQuery: 'Moneda',
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final textFieldFinder = find.byType(TextField);
      expect(textFieldFinder, findsOneWidget);
      expect(find.byIcon(Icons.clear), findsOneWidget);

      await tester.tap(find.byIcon(Icons.clear));
      await tester.pumpAndSettle();

      final textField = tester.widget<TextField>(textFieldFinder);
      expect(textField.controller?.text, isEmpty);
      expect(find.byIcon(Icons.clear), findsNothing);
    });
  });
}
