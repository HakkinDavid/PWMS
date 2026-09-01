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
import 'package:platinum_world_management_system/src/features/entities/domain/world_entity.dart';
import 'package:platinum_world_management_system/src/features/entities/presentation/instance_preview_card.dart';
import 'package:platinum_world_management_system/src/features/locations/presentation/container_entity_picker.dart';
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

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    tempDir = Directory.systemTemp.createTempSync('container_picker_test_');
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

  group('ContainerEntityPicker & LocationOrContainerSelectionSheet Tests', () {
    testWidgets('ContainerEntityPicker searches and filters entities by name and selects with tile tap', (WidgetTester tester) async {
      final now = DateTime.now();

      await db.into(db.catalogTable).insert(
            CatalogTableCompanion.insert(id: 'sp_backpack', name: 'Mochila Táctica', type: const Value('Contenedor'), createdAt: now),
          );
      await db.into(db.catalogTable).insert(
            CatalogTableCompanion.insert(id: 'sp_box', name: 'Caja Fuerte', type: const Value('Seguridad'), createdAt: now),
          );
      await db.into(db.catalogTable).insert(
            CatalogTableCompanion.insert(id: 'sp_key', name: 'Llave Dorada', type: const Value('Objeto'), createdAt: now),
          );

      await db.into(db.entitiesTable).insert(
            EntitiesTableCompanion.insert(id: 'e_backpack', speciesId: 'sp_backpack', createdAt: now, updatedAt: now),
          );
      await db.into(db.entitiesTable).insert(
            EntitiesTableCompanion.insert(id: 'e_box', speciesId: 'sp_box', createdAt: now, updatedAt: now),
          );
      await db.into(db.entitiesTable).insert(
            EntitiesTableCompanion.insert(id: 'e_key', speciesId: 'sp_key', createdAt: now, updatedAt: now),
          );

      WorldEntity? selectedResult;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: ContainerEntityPicker(
                excludeEntityId: 'e_key',
                onSelected: (entity) {
                  selectedResult = entity;
                },
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Initial view shows both Backpack and Box, excluding Key
      expect(find.text('Mochila Táctica'), findsWidgets);
      expect(find.text('Caja Fuerte'), findsWidgets);
      expect(find.text('Llave Dorada'), findsNothing);
      expect(find.byType(InstancePreviewCard), findsNWidgets(2));

      // Enter search text 'Mochila'
      await tester.enterText(find.byType(TextField), 'Mochila');
      await tester.pumpAndSettle();

      // Only Backpack should be visible now
      expect(find.text('Mochila Táctica'), findsWidgets);
      expect(find.text('Caja Fuerte'), findsNothing);

      // Tap on Mochila Táctica tile
      await tester.tap(find.text('Mochila Táctica').first);
      await tester.pumpAndSettle();

      expect(selectedResult, isNotNull);
      expect(selectedResult!.id, equals('e_backpack'));
    });

    testWidgets('LocationOrContainerSelectionSheet selects container and saves GUARDADO_EN relation', (WidgetTester tester) async {
      final now = DateTime.now();

      await db.into(db.catalogTable).insert(
            CatalogTableCompanion.insert(id: 'sp_chest', name: 'Cofre de Roble', type: const Value('Contenedor'), createdAt: now),
          );
      await db.into(db.catalogTable).insert(
            CatalogTableCompanion.insert(id: 'sp_gem', name: 'Diamante', type: const Value('Gema'), createdAt: now),
          );

      await db.into(db.entitiesTable).insert(
            EntitiesTableCompanion.insert(id: 'e_chest', speciesId: 'sp_chest', createdAt: now, updatedAt: now),
          );
      await db.into(db.entitiesTable).insert(
            EntitiesTableCompanion.insert(id: 'e_gem', speciesId: 'sp_gem', createdAt: now, updatedAt: now),
          );

      final gemEntity = WorldEntity(id: 'e_gem', speciesId: 'sp_gem', locationId: null, createdAt: now, updatedAt: now);
      LocationOrContainerSelection? selectedResult;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: Consumer(
                builder: (context, ref, _) => ElevatedButton(
                  onPressed: () async {
                    selectedResult = await LocationOrContainerSelectionSheet.show(
                      context,
                      excludedContainerIds: {gemEntity.id},
                    );
                    if (selectedResult != null) {
                      await LocationOrContainerSelectionSheet.applyRelocation(
                        ref: ref,
                        entityIds: [gemEntity.id],
                        selection: selectedResult!,
                      );
                    }
                  },
                  child: const Text('Open Sheet'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      await tester.tap(find.text('Open Sheet'));
      await tester.pumpAndSettle();

      // Switch to 'Guardado en contenedor' mode
      await tester.tap(find.text(AppStrings.savedInContainer));
      await tester.pumpAndSettle();

      // Should show 'Selecciona objeto contenedor' button
      expect(find.text(AppStrings.selectContainerObject), findsOneWidget);

      // Tap to open ContainerEntityPicker bottom sheet
      await tester.tap(find.text(AppStrings.selectContainerObject));
      await tester.pumpAndSettle();

      // Inside picker modal, find 'Cofre de Roble' and select it
      expect(find.text('Cofre de Roble'), findsWidgets);
      await tester.tap(find.text('Cofre de Roble').first);
      await tester.pumpAndSettle();

      // Now back in selection sheet, the InstancePreviewCard of 'Cofre de Roble' should be displayed
      expect(find.text('Cofre de Roble'), findsWidgets);
      expect(find.byTooltip(AppStrings.changeContainerAction), findsOneWidget);

      // Tap 'Confirmar'
      await tester.tap(find.text(AppStrings.confirm));
      await tester.pumpAndSettle();

      expect(selectedResult, isNotNull);
      expect(selectedResult!.isContainerEntity, isTrue);
      expect(selectedResult!.containerEntityId, equals('e_chest'));

      // Verify GUARDADO_EN relation exists in database
      final relations = await db.select(db.relationsTable).get();
      expect(relations.length, equals(1));
      expect(relations.first.sourceEntityId, equals('e_gem'));
      expect(relations.first.targetEntityId, equals('e_chest'));
      expect(relations.first.relationType, equals('GUARDADO_EN'));
    });

    testWidgets('LocationOrContainerSelectionSheet batch moves multiple entities to container', (WidgetTester tester) async {
      final now = DateTime.now();

      await db.into(db.catalogTable).insert(
            CatalogTableCompanion.insert(id: 'sp_box2', name: 'Caja Fuerte 2', type: const Value('Contenedor'), createdAt: now),
          );
      await db.into(db.catalogTable).insert(
            CatalogTableCompanion.insert(id: 'sp_item', name: 'Moneda Oro', type: const Value('Numismática'), createdAt: now),
          );
      await db.into(db.locationsTable).insert(
            LocationsTableCompanion.insert(id: 'loc_shelf', name: 'Estante A', createdAt: now),
          );

      await db.into(db.entitiesTable).insert(
            EntitiesTableCompanion.insert(id: 'e_box2', speciesId: 'sp_box2', createdAt: now, updatedAt: now),
          );
      await db.into(db.entitiesTable).insert(
            EntitiesTableCompanion.insert(id: 'e_coin1', speciesId: 'sp_item', createdAt: now, updatedAt: now),
          );
      await db.into(db.entitiesTable).insert(
            EntitiesTableCompanion.insert(id: 'e_coin2', speciesId: 'sp_item', createdAt: now, updatedAt: now),
          );

      final coin1 = WorldEntity(id: 'e_coin1', speciesId: 'sp_item', createdAt: now, updatedAt: now);
      final coin2 = WorldEntity(id: 'e_coin2', speciesId: 'sp_item', createdAt: now, updatedAt: now);
      LocationOrContainerSelection? selectedResult;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: Consumer(
                builder: (context, ref, _) => ElevatedButton(
                  onPressed: () async {
                    selectedResult = await LocationOrContainerSelectionSheet.show(
                      context,
                      title: AppStrings.moveSelectedCountTitle(2),
                      excludedContainerIds: {coin1.id, coin2.id},
                    );
                    if (selectedResult != null) {
                      await LocationOrContainerSelectionSheet.applyRelocation(
                        ref: ref,
                        entityIds: [coin1.id, coin2.id],
                        selection: selectedResult!,
                      );
                    }
                  },
                  child: const Text('Open Sheet'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      await tester.tap(find.text('Open Sheet'));
      await tester.pumpAndSettle();

      // Title should show custom title
      expect(find.text(AppStrings.moveSelectedCountTitle(2)), findsOneWidget);

      // Switch to 'Guardado en contenedor' mode
      await tester.tap(find.text(AppStrings.savedInContainer));
      await tester.pumpAndSettle();

      // Tap to open ContainerEntityPicker bottom sheet
      await tester.tap(find.text(AppStrings.selectContainerObject));
      await tester.pumpAndSettle();

      // Select 'Caja Fuerte 2'
      expect(find.text('Caja Fuerte 2'), findsWidgets);
      await tester.tap(find.text('Caja Fuerte 2').first);
      await tester.pumpAndSettle();

      // Confirm
      await tester.tap(find.text(AppStrings.confirm));
      await tester.pumpAndSettle();

      // Verify GUARDADO_EN relations exist for both coin1 and coin2
      final relations = await db.select(db.relationsTable).get();
      final coinRels = relations.where((r) => r.targetEntityId == 'e_box2' && r.relationType == 'GUARDADO_EN').toList();
      expect(coinRels.length, equals(2));
      expect(coinRels.map((r) => r.sourceEntityId).toSet(), equals({'e_coin1', 'e_coin2'}));
    });

    testWidgets('ContainerEntityPicker clear button clears input text and resets search', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: ContainerEntityPicker(
                onSelected: (_) {},
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final textFieldFinder = find.byType(TextField);
      expect(textFieldFinder, findsOneWidget);
      expect(find.byIcon(Icons.clear), findsNothing);

      await tester.enterText(textFieldFinder, 'Mochila');
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.clear), findsOneWidget);

      await tester.tap(find.byIcon(Icons.clear));
      await tester.pumpAndSettle();

      final textField = tester.widget<TextField>(textFieldFinder);
      expect(textField.controller?.text, isEmpty);
      expect(find.byIcon(Icons.clear), findsNothing);
    });
  });
}
