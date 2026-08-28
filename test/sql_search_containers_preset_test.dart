import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import 'package:platinum_world_management_system/src/core/database/app_database.dart';
import 'package:platinum_world_management_system/src/core/providers/providers.dart';
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

  group('SQL Containers Preset Tests', () {
    test('SQL query for containers returns entities receiving GUARDADO_EN relations', () async {
      final now = DateTime.now();

      // Insert catalog items (species)
      await db.into(db.catalogTable).insert(
            CatalogTableCompanion.insert(
              id: 'spec_box',
              name: 'Caja de Herramientas',
              createdAt: now,
            ),
          );
      await db.into(db.catalogTable).insert(
            CatalogTableCompanion.insert(
              id: 'spec_wrench',
              name: 'Llave Inglesa',
              createdAt: now,
            ),
          );
      await db.into(db.catalogTable).insert(
            CatalogTableCompanion.insert(
              id: 'spec_book',
              name: 'Libro de Notas',
              createdAt: now,
            ),
          );

      // Insert entities
      await db.into(db.entitiesTable).insert(
            EntitiesTableCompanion.insert(
              id: 'entity_container_1',
              speciesId: 'spec_box',
              createdAt: now,
              updatedAt: now,
            ),
          );
      await db.into(db.entitiesTable).insert(
            EntitiesTableCompanion.insert(
              id: 'entity_item_1',
              speciesId: 'spec_wrench',
              createdAt: now,
              updatedAt: now,
            ),
          );
      await db.into(db.entitiesTable).insert(
            EntitiesTableCompanion.insert(
              id: 'entity_item_2',
              speciesId: 'spec_book',
              createdAt: now,
              updatedAt: now,
            ),
          );

      // Insert relations:
      // entity_item_1 is GUARDADO_EN entity_container_1
      await db.into(db.relationsTable).insert(
            RelationsTableCompanion.insert(
              id: 'rel_1',
              sourceEntityId: 'entity_item_1',
              targetEntityId: 'entity_container_1',
              relationType: 'GUARDADO_EN',
              createdAt: now,
            ),
          );
      // entity_item_2 is PARTE_DE entity_container_1 (not GUARDADO_EN)
      await db.into(db.relationsTable).insert(
            RelationsTableCompanion.insert(
              id: 'rel_2',
              sourceEntityId: 'entity_item_2',
              targetEntityId: 'entity_container_1',
              relationType: 'PARTE_DE',
              createdAt: now,
            ),
          );

      const query =
          "SELECT DISTINCT e.id, c.name, e.location_id FROM entities_table e JOIN relations_table r ON e.id = r.target_entity_id JOIN catalog_table c ON e.species_id = c.id WHERE r.relation_type = 'GUARDADO_EN';";

      final results = await db.customSelect(query).get();

      expect(results.length, equals(1));
      expect(results.first.data['id'], equals('entity_container_1'));
      expect(results.first.data['name'], equals('Caja de Herramientas'));
    });

    testWidgets('SearchScreen SQL console contains Contenedores chip and executes query', (WidgetTester tester) async {
      final now = DateTime.now();

      await db.into(db.catalogTable).insert(
            CatalogTableCompanion.insert(
              id: 'spec_backpack',
              name: 'Mochila de Viaje',
              createdAt: now,
            ),
          );
      await db.into(db.entitiesTable).insert(
            EntitiesTableCompanion.insert(
              id: 'entity_backpack',
              speciesId: 'spec_backpack',
              createdAt: now,
              updatedAt: now,
            ),
          );
      await db.into(db.entitiesTable).insert(
            EntitiesTableCompanion.insert(
              id: 'entity_passport',
              speciesId: 'spec_backpack',
              createdAt: now,
              updatedAt: now,
            ),
          );
      await db.into(db.relationsTable).insert(
            RelationsTableCompanion.insert(
              id: 'rel_bag',
              sourceEntityId: 'entity_passport',
              targetEntityId: 'entity_backpack',
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
            home: SearchScreen(initialScope: AppStrings.arbitrarySqlQueryLabel),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Open presets picker via AppWheelPicker
      final presetButton = find.widgetWithIcon(FilledButton, Icons.bookmark_border);
      expect(presetButton, findsOneWidget);
      await tester.tap(presetButton);
      await tester.pumpAndSettle();

      // Confirm preset selection
      final confirmBtn = find.widgetWithText(ElevatedButton, AppStrings.confirm);
      await tester.tap(confirmBtn);
      await tester.pumpAndSettle();

      // Verify query result renders
      expect(find.text('entity_backpack'), findsWidgets);
      expect(find.text('Mochila de Viaje'), findsWidgets);
    });
  });
}
