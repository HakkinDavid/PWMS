import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import 'package:platinum_world_management_system/src/core/database/app_database.dart';
import 'package:platinum_world_management_system/src/core/providers/providers.dart';
import 'package:platinum_world_management_system/src/features/search/domain/sql_preset.dart';
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

  group('SQL Presets Database & Execution Tests', () {
    test('All default SQL presets have valid syntax on SQLite database', () async {
      for (final preset in SqlPreset.defaultPresets) {
        // Execute each query against SQLite to confirm no syntax or table name errors
        final results = await db.customSelect(preset.query).get();
        expect(results, isNotNull, reason: 'Preset "${preset.title}" (${preset.id}) failed to execute');
      }
    });

    test('Container & Split-Species Presets return expected datasets', () async {
      final now = DateTime.now();

      // Species: Box, Apple, Screwdriver
      await db.into(db.catalogTable).insert(
            CatalogTableCompanion.insert(
              id: 'sp_box',
              name: 'Caja Contenedora',
              createdAt: now,
            ),
          );
      await db.into(db.catalogTable).insert(
            CatalogTableCompanion.insert(
              id: 'sp_apple',
              name: 'Manzana Fuji',
              createdAt: now,
            ),
          );
      await db.into(db.catalogTable).insert(
            CatalogTableCompanion.insert(
              id: 'sp_driver',
              name: 'Destornillador',
              createdAt: now,
            ),
          );

      // Entities:
      // - 1 container (e_box)
      // - 2 apples: apple 1 inside box, apple 2 loose (non-contained)
      // - 1 screwdriver: loose (non-contained)
      await db.into(db.entitiesTable).insert(
            EntitiesTableCompanion.insert(id: 'e_box', speciesId: 'sp_box', createdAt: now, updatedAt: now),
          );
      await db.into(db.entitiesTable).insert(
            EntitiesTableCompanion.insert(id: 'e_apple_1', speciesId: 'sp_apple', createdAt: now, updatedAt: now),
          );
      await db.into(db.entitiesTable).insert(
            EntitiesTableCompanion.insert(id: 'e_apple_2', speciesId: 'sp_apple', createdAt: now, updatedAt: now),
          );
      await db.into(db.entitiesTable).insert(
            EntitiesTableCompanion.insert(id: 'e_driver', speciesId: 'sp_driver', createdAt: now, updatedAt: now),
          );

      // Relation: e_apple_1 is GUARDADO_EN e_box
      await db.into(db.relationsTable).insert(
            RelationsTableCompanion.insert(
              id: 'rel_1',
              sourceEntityId: 'e_apple_1',
              targetEntityId: 'e_box',
              relationType: 'GUARDADO_EN',
              createdAt: now,
            ),
          );

      // 1. All contained items
      final containedPreset = SqlPreset.defaultPresets.firstWhere((p) => p.id == 'contained_items_all');
      final containedResults = await db.customSelect(containedPreset.query).get();
      expect(containedResults.length, equals(1));
      expect(containedResults.first.data['id'], equals('e_apple_1'));
      expect(containedResults.first.data['container_id'], equals('e_box'));

      // 2. All non-contained items (e_box, e_apple_2, e_driver)
      final nonContainedPreset = SqlPreset.defaultPresets.firstWhere((p) => p.id == 'non_contained_items_all');
      final nonContainedResults = await db.customSelect(nonContainedPreset.query).get();
      final nonContainedIds = nonContainedResults.map((r) => r.data['id']).toSet();
      expect(nonContainedIds, equals({'e_box', 'e_apple_2', 'e_driver'}));

      // 3. Non-contained with species having >=1 contained instance:
      // sp_apple has e_apple_1 contained, so e_apple_2 should be returned (sp_driver has NO contained instance)
      final nonContainedSpeciesPreset =
          SqlPreset.defaultPresets.firstWhere((p) => p.id == 'non_contained_with_contained_species');
      final nonContainedSpeciesResults = await db.customSelect(nonContainedSpeciesPreset.query).get();
      expect(nonContainedSpeciesResults.length, equals(1));
      expect(nonContainedSpeciesResults.first.data['id'], equals('e_apple_2'));

      // 4. Contained with species having >=1 non-contained instance:
      // sp_apple has e_apple_2 non-contained, so e_apple_1 should be returned
      final containedSpeciesPreset =
          SqlPreset.defaultPresets.firstWhere((p) => p.id == 'contained_with_non_contained_species');
      final containedSpeciesResults = await db.customSelect(containedSpeciesPreset.query).get();
      expect(containedSpeciesResults.length, equals(1));
      expect(containedSpeciesResults.first.data['id'], equals('e_apple_1'));
    });

    test('Anomaly & Outlier Audit Presets pinpoint data issues accurately', () async {
      final now = DateTime.now();

      // 1. Orphan entity (no location_id and not contained in any container)
      await db.into(db.catalogTable).insert(
            CatalogTableCompanion.insert(id: 'sp_orphan', name: 'Objeto Huérfano', createdAt: now),
          );
      await db.into(db.entitiesTable).insert(
            EntitiesTableCompanion.insert(id: 'e_orphan', speciesId: 'sp_orphan', createdAt: now, updatedAt: now),
          );

      final orphanPreset = SqlPreset.defaultPresets.firstWhere((p) => p.id == 'audit_orphan_entities');
      final orphanResults = await db.customSelect(orphanPreset.query).get();
      expect(orphanResults.any((r) => r.data['id'] == 'e_orphan'), isTrue);

      // 2. Uniqueness violation
      await db.into(db.catalogTable).insert(
            CatalogTableCompanion.insert(
              id: 'sp_unique',
              name: 'Especie Única Duplicada',
              isUnique: const Value(true),
              createdAt: now,
            ),
          );
      await db.into(db.subspeciesTable).insert(
            SubspeciesTableCompanion.insert(
              id: 'sub_unique',
              speciesId: 'sp_unique',
              subspeciesName: 'Pieza Exclusiva #1',
              createdAt: now,
            ),
          );
      await db.into(db.entitiesTable).insert(
            EntitiesTableCompanion.insert(
              id: 'e_u1',
              speciesId: 'sp_unique',
              subspeciesId: const Value('sub_unique'),
              createdAt: now,
              updatedAt: now,
            ),
          );
      await db.into(db.entitiesTable).insert(
            EntitiesTableCompanion.insert(
              id: 'e_u2',
              speciesId: 'sp_unique',
              subspeciesId: const Value('sub_unique'),
              createdAt: now,
              updatedAt: now,
            ),
          );

      final uniquePreset = SqlPreset.defaultPresets.firstWhere((p) => p.id == 'audit_uniqueness_violation');
      final uniqueResults = await db.customSelect(uniquePreset.query).get();
      expect(uniqueResults.length, equals(1));
      expect(uniqueResults.first.data['species_id'], equals('sp_unique'));
      expect(uniqueResults.first.data['subspecies_id'], equals('sub_unique'));
      expect(uniqueResults.first.data['instance_count'], equals(2));

      // 3. Mutual containment anomaly
      await db.into(db.relationsTable).insert(
            RelationsTableCompanion.insert(
              id: 'r_ab',
              sourceEntityId: 'e_u1',
              targetEntityId: 'e_u2',
              relationType: 'GUARDADO_EN',
              createdAt: now,
            ),
          );
      await db.into(db.relationsTable).insert(
            RelationsTableCompanion.insert(
              id: 'r_ba',
              sourceEntityId: 'e_u2',
              targetEntityId: 'e_u1',
              relationType: 'GUARDADO_EN',
              createdAt: now,
            ),
          );

      final mutualPreset = SqlPreset.defaultPresets.firstWhere((p) => p.id == 'audit_mutual_containment');
      final mutualResults = await db.customSelect(mutualPreset.query).get();
      expect(mutualResults.length, equals(2));

      // 4. Subgroup rule violation (Ser Vivo with brand)
      await db.into(db.catalogTable).insert(
            CatalogTableCompanion.insert(id: 'sp_plant', name: 'Planta', type: const Value('Ser Vivo'), createdAt: now),
          );
      await db.into(db.subspeciesTable).insert(
            SubspeciesTableCompanion.insert(
              id: 'sub_plant',
              speciesId: 'sp_plant',
              subspeciesName: 'Cactus',
              brand: const Value('MarcaIlegal'),
              createdAt: now,
            ),
          );

      final subgroupPreset = SqlPreset.defaultPresets.firstWhere((p) => p.id == 'audit_subgroup_rule_violation');
      final subgroupResults = await db.customSelect(subgroupPreset.query).get();
      expect(subgroupResults.length, equals(1));
      expect(subgroupResults.first.data['brand'], equals('MarcaIlegal'));
    });
  });

  group('SQL Presets UI Interaction Widget Tests', () {
    testWidgets('SearchScreen filters presets by category and executes clicked preset',
        (WidgetTester tester) async {
      final now = DateTime.now();

      await db.into(db.catalogTable).insert(
            CatalogTableCompanion.insert(
              id: 'sp_test',
              name: 'Elemento de Prueba',
              createdAt: now,
            ),
          );
      await db.into(db.entitiesTable).insert(
            EntitiesTableCompanion.insert(
              id: 'e_test_1',
              speciesId: 'sp_test',
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
            home: SearchScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Open SQL console
      final sqlTabChip = find.widgetWithText(FilterChip, AppStrings.arbitrarySqlQueryLabel);
      expect(sqlTabChip, findsOneWidget);
      await tester.ensureVisible(sqlTabChip);
      await tester.pumpAndSettle();
      await tester.tap(sqlTabChip);
      await tester.pumpAndSettle();

      // Category choice chips should be visible
      final containersCategoryChip = find.widgetWithText(ChoiceChip, AppStrings.sqlCategoryContainers);
      expect(containersCategoryChip, findsOneWidget);
      await tester.ensureVisible(containersCategoryChip);
      await tester.pumpAndSettle();
      await tester.tap(containersCategoryChip);
      await tester.pumpAndSettle();

      // In Contenedores category, "Elementos no guardados" ActionChip should be visible
      final nonContainedChip = find.widgetWithText(ActionChip, AppStrings.sqlPresetNonContainedItems);
      expect(nonContainedChip, findsOneWidget);
      await tester.ensureVisible(nonContainedChip);
      await tester.pumpAndSettle();
      await tester.tap(nonContainedChip);
      await tester.pumpAndSettle();

      // Verify result table is displayed with e_test_1
      expect(find.text('e_test_1'), findsOneWidget);
      expect(find.text('Elemento de Prueba'), findsOneWidget);

      // Switch category to Auditoría
      final auditCategoryChip = find.widgetWithText(ChoiceChip, AppStrings.sqlCategoryAudit);
      expect(auditCategoryChip, findsOneWidget);
      await tester.ensureVisible(auditCategoryChip);
      await tester.pumpAndSettle();
      await tester.tap(auditCategoryChip);
      await tester.pumpAndSettle();

      // In Auditoría category, "Huérfanos sin ubicación" ActionChip should be visible
      final orphanChip = find.widgetWithText(ActionChip, AppStrings.sqlPresetOrphanEntities);
      expect(orphanChip, findsOneWidget);
      await tester.ensureVisible(orphanChip);
      await tester.pumpAndSettle();
      await tester.tap(orphanChip);
      await tester.pump();
      await tester.pumpAndSettle();

      // Verify DataTable or error
      expect(find.byType(DataTable), findsOneWidget);
      expect(find.text('e_test_1'), findsWidgets);
    });
  });
}
