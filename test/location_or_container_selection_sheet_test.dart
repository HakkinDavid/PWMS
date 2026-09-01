import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import 'package:platinum_world_management_system/src/core/database/app_database.dart';
import 'package:platinum_world_management_system/src/core/providers/providers.dart';
import 'package:platinum_world_management_system/src/features/locations/presentation/location_or_container_selection_sheet.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  group('LocationOrContainerSelectionSheet Unit & Widget Tests', () {
    test('LocationOrContainerSelection equality and properties', () {
      const p1 = LocationOrContainerSelection.physicalNode('loc-1');
      const p2 = LocationOrContainerSelection.physicalNode('loc-1');
      const p3 = LocationOrContainerSelection.physicalNode('loc-2');
      const pNull = LocationOrContainerSelection.physicalNode();

      expect(p1, equals(p2));
      expect(p1 == p3, isFalse);
      expect(p1.isPhysicalNode, isTrue);
      expect(p1.isContainerEntity, isFalse);
      expect(p1.locationId, equals('loc-1'));
      expect(p1.containerEntityId, isNull);
      expect(pNull.locationId, isNull);

      const c1 = LocationOrContainerSelection.containerEntity('ent-1');
      const c2 = LocationOrContainerSelection.containerEntity('ent-1');
      const c3 = LocationOrContainerSelection.containerEntity('ent-2');

      expect(c1, equals(c2));
      expect(c1 == c3, isFalse);
      expect(c1 == p1, isFalse);
      expect(c1.isPhysicalNode, isFalse);
      expect(c1.isContainerEntity, isTrue);
      expect(c1.containerEntityId, equals('ent-1'));
      expect(c1.locationId, isNull);
    });

    testWidgets('LocationOrContainerSelectionSheet opens with preselected container and confirms', (WidgetTester tester) async {
      final now = DateTime.now();

      await db.into(db.catalogTable).insert(
            CatalogTableCompanion.insert(id: 'sp_safe', name: 'Caja Fuerte', type: const Value('Contenedor'), createdAt: now),
          );
      await db.into(db.entitiesTable).insert(
            EntitiesTableCompanion.insert(id: 'e_safe', speciesId: 'sp_safe', createdAt: now, updatedAt: now),
          );

      LocationOrContainerSelection? selectedResult;

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
                    selectedResult = await LocationOrContainerSelectionSheet.show(
                      context,
                      initialSelection: const LocationOrContainerSelection.containerEntity('e_safe'),
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
      await tester.tap(find.text('Open Sheet'));
      await tester.pumpAndSettle();

      // Preselection should show container entity card
      expect(find.text('Caja Fuerte'), findsWidgets);
      expect(find.byTooltip(AppStrings.changeContainerAction), findsOneWidget);

      // Confirm
      await tester.tap(find.text(AppStrings.confirm));
      await tester.pumpAndSettle();

      expect(selectedResult, isNotNull);
      expect(selectedResult!.isContainerEntity, isTrue);
      expect(selectedResult!.containerEntityId, equals('e_safe'));
    });

    testWidgets('LocationOrContainerSelectionSheet opens with preselected physical location and confirms', (WidgetTester tester) async {
      final now = DateTime.now();

      await db.into(db.locationsTable).insert(
            LocationsTableCompanion.insert(id: 'loc_office', name: 'Oficina Principal', createdAt: now),
          );

      LocationOrContainerSelection? selectedResult;

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
                    selectedResult = await LocationOrContainerSelectionSheet.show(
                      context,
                      initialSelection: const LocationOrContainerSelection.physicalNode('loc_office'),
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
      await tester.tap(find.text('Open Sheet'));
      await tester.pumpAndSettle();

      // Should display 'Oficina Principal'
      expect(find.text('Mundo > Oficina Principal'), findsWidgets);

      // Confirm
      await tester.tap(find.text(AppStrings.confirm));
      await tester.pumpAndSettle();

      expect(selectedResult, isNotNull);
      expect(selectedResult!.isPhysicalNode, isTrue);
      expect(selectedResult!.locationId, equals('loc_office'));
    });

    testWidgets('LocationOrContainerSelectionSheet cancel returns null', (WidgetTester tester) async {
      LocationOrContainerSelection? selectedResult = const LocationOrContainerSelection.physicalNode('initial');

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
                    selectedResult = await LocationOrContainerSelectionSheet.show(
                      context,
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
      await tester.tap(find.text('Open Sheet'));
      await tester.pumpAndSettle();

      // Close sheet via close button
      await tester.tap(find.byTooltip(AppStrings.close));
      await tester.pumpAndSettle();

      expect(selectedResult, isNull);
    });
  });
}
