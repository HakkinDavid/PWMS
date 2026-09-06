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
import 'package:platinum_world_management_system/src/core/widgets/app_wheel_picker.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/catalog_item.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/subspecies.dart';
import 'package:platinum_world_management_system/src/features/control_center/domain/audit_rule_strategy.dart';
import 'package:platinum_world_management_system/src/features/control_center/domain/strategies/governance_audit_rules.dart';
import 'package:platinum_world_management_system/src/features/control_center/presentation/control_center_screen.dart';
import 'package:platinum_world_management_system/src/features/entities/domain/world_entity.dart';

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
  group('AppWheelPicker Single Option Behavior', () {
    testWidgets('AppWheelPicker.show returns single option immediately without opening sheet', (WidgetTester tester) async {
      String? selectedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  selectedValue = await AppWheelPicker.show<String>(
                    context,
                    items: ['Única Opción'],
                    labelBuilder: (item) => item,
                  );
                },
                child: const Text('Abrir Picker'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Abrir Picker'));
      await tester.pumpAndSettle();

      // Should return the only option immediately
      expect(selectedValue, 'Única Opción');
      // Bottom sheet should NOT be present
      expect(find.byType(AppWheelPicker<String>), findsNothing);
      expect(find.text(AppStrings.confirm), findsNothing);
    });

    testWidgets('AppWheelPicker.showPicker returns WheelPickerResult for single option', (WidgetTester tester) async {
      WheelPickerResult<int>? result;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  result = await AppWheelPicker.showPicker<int>(
                    context,
                    items: [42],
                    labelBuilder: (item) => item.toString(),
                  );
                },
                child: const Text('Abrir Picker'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Abrir Picker'));
      await tester.pumpAndSettle();

      expect(result, isNotNull);
      expect(result!.value, 42);
      expect(find.byType(AppWheelPicker<int>), findsNothing);
    });

    testWidgets('AppWheelPicker.show with multiple options opens bottom sheet normally', (WidgetTester tester) async {
      String? selectedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  selectedValue = await AppWheelPicker.show<String>(
                    context,
                    items: ['Opción 1', 'Opción 2'],
                    labelBuilder: (item) => item,
                  );
                },
                child: const Text('Abrir Picker Multiple'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Abrir Picker Multiple'));
      await tester.pumpAndSettle();

      // Bottom sheet should be visible with multiple options
      expect(find.byType(AppWheelPicker<String>), findsOneWidget);
      expect(find.text(AppStrings.confirm), findsOneWidget);

      // Tap confirm button
      await tester.tap(find.text(AppStrings.confirm));
      await tester.pumpAndSettle();

      expect(selectedValue, 'Opción 1');
      expect(find.byType(AppWheelPicker<String>), findsNothing);
    });
  });

  group('CCC Single Option Auto-Apply Integration Test', () {
    late AppDatabase db;
    late Directory tempDir;

    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      tempDir = Directory.systemTemp.createTempSync('cc_single_option_test_');
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

    testWidgets('CCC with 1 subspecies option applies fix directly without opening picker modal', (WidgetTester tester) async {
      final now = DateTime.now();

      // Create a species
      await db.into(db.catalogTable).insert(
            CatalogTableCompanion.insert(
              id: 'sp_coin',
              name: 'Moneda Antigua',
              mainPhotoPath: const Value('local/coin.jpg'),
              createdAt: now,
            ),
          );

      // Create a single subspecies
      await db.into(db.subspeciesTable).insert(
            SubspeciesTableCompanion.insert(
              id: 'sub_1',
              speciesId: 'sp_coin',
              subspeciesName: 'Variedad Única',
              createdAt: now,
            ),
          );

      // Create an entity pointing to non-existent subspecies (invalid subspecies anomaly)
      await db.into(db.entitiesTable).insert(
            EntitiesTableCompanion.insert(
              id: 'e_coin',
              speciesId: 'sp_coin',
              subspeciesId: const Value('sub_non_existent'),
              locationId: const Value('loc_1'),
              createdAt: now,
              updatedAt: now,
            ),
          );

      final species = CatalogItem(
        id: 'sp_coin',
        name: 'Moneda Antigua',
        type: 'Moneda',
        mainPhotoPath: 'local/coin.jpg',
        createdAt: now,
      );
      final sub = Subspecies(
        id: 'sub_1',
        speciesId: 'sp_coin',
        subspeciesName: 'Variedad Única',
        createdAt: now,
      );
      final entity = WorldEntity(
        id: 'e_coin',
        speciesId: 'sp_coin',
        subspeciesId: 'sub_non_existent',
        locationId: 'loc_1',
        createdAt: now,
        updatedAt: now,
      );

      final context = AuditEvaluationContext(
        db: db,
        allEntities: [entity],
        allCatalog: [species],
        allSubspecies: [sub],
        allLocations: const [],
        allRelations: const [],
        allSpeciesMagnitudes: const [],
        allInstanceMagnitudes: const [],
        allRequirements: const [],
        effectiveLocationMap: const {},
      );

      const strategy = UnlinkedInstancesStrategy();
      final cards = await strategy.evaluate(context);
      expect(cards.length, 1);
      final card = cards.first;

      late BuildContext buildCtx;
      late WidgetRef widgetRef;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: Consumer(
                builder: (ctx, ref, _) {
                  buildCtx = ctx;
                  widgetRef = ref;
                  return const SizedBox();
                },
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Start onFix in background
      bool? fixResult;
      card.onFix(buildCtx, widgetRef).then((res) => fixResult = res);
      await tester.pumpAndSettle();

      // Dialog asks to Reassign or Delete
      final reassignBtn = find.text(AppStrings.reassignToSubspeciesTitle);
      expect(reassignBtn, findsOneWidget);

      await tester.tap(reassignBtn);
      await tester.pumpAndSettle();

      // AppWheelPicker should NOT open a modal bottom sheet because subs has only 1 item ('sub_1')
      expect(find.byType(AppWheelPicker<Subspecies>), findsNothing);
      expect(fixResult, isTrue);

      // Verify the entity was updated in the database to sub_1
      final updatedEntity = await (db.select(db.entitiesTable)..where((tbl) => tbl.id.equals('e_coin'))).getSingle();
      expect(updatedEntity.subspeciesId, 'sub_1');

      // Allow AppToast timer to complete
      await tester.pump(const Duration(seconds: 4));
    });
  });
}
