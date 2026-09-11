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
import 'package:platinum_world_management_system/src/features/catalog/domain/numismatics/numismatic_domain_rules.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/subspecies.dart';
import 'package:platinum_world_management_system/src/features/control_center/domain/audit_rule_strategy.dart';
import 'package:platinum_world_management_system/src/features/control_center/domain/strategies/governance_audit_rules.dart';
import 'package:platinum_world_management_system/src/features/control_center/domain/strategies/numismatic_audit_rules.dart';
import 'package:platinum_world_management_system/src/features/entities/domain/instance_magnitude.dart';
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

    testWidgets('AppWheelPicker options wrap long text without ellipsis', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  await AppWheelPicker.show<String>(
                    context,
                    items: [
                      'Esta es una opción con un texto bastante largo que debe hacer wrap en el wheel picker',
                      'Segunda opción también suficientemente extensa para requerir varias líneas de texto',
                    ],
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

      final textWidgets = tester.widgetList<Text>(find.byType(Text));
      final optionTexts = textWidgets.where((t) => t.data?.contains('Esta es una opción') ?? false).toList();
      expect(optionTexts, isNotEmpty);
      final optionText = optionTexts.first;

      // Ensure maxLines is not restricted to 1 and overflow is not ellipsis
      expect(optionText.maxLines, isNull);
      expect(optionText.overflow, isNull);
      expect(optionText.softWrap, isTrue);
      expect(optionText.textAlign, TextAlign.center);
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

  group('CCC Text Formatting for Multiple vs Single Options', () {
    final coinSpecies = CatalogItem(
      id: 'sp_coin',
      name: 'Moneda Numismática',
      type: 'Moneda',
      createdAt: DateTime.now(),
    );

    test('When multiple materials are valid, text does not say "Esperado" and uses magnitude not among expected phrasing', () {
      // Mexico 1988 50 Pesos has both Cuproníquel and Acero inoxidable
      final instance = WorldEntity(
        id: 'inst_mex_50',
        speciesId: 'sp_coin',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        magnitudes: [
          const InstanceMagnitude(id: '1', instanceId: 'inst_mex_50', propertyName: 'País', stringValue: 'México', dataType: 'string'),
          const InstanceMagnitude(id: '2', instanceId: 'inst_mex_50', propertyName: 'Acuñación', stringValue: '1988', dataType: 'string'),
          const InstanceMagnitude(id: '3', instanceId: 'inst_mex_50', propertyName: 'Divisa', stringValue: 'MXP', dataType: 'string'),
          const InstanceMagnitude(id: '4', instanceId: 'inst_mex_50', propertyName: 'Valor nominal', stringValue: '50', dataType: 'string'),
          const InstanceMagnitude(id: '5', instanceId: 'inst_mex_50', propertyName: 'Material', stringValue: 'Oro', dataType: 'string'),
        ],
      );

      final outliers = NumismaticDomainRules.checkEmissionOutliers(
        instance: instance,
        species: coinSpecies,
      );

      expect(outliers.length, 1);
      final matOutlier = outliers.first;
      expect(matOutlier.type, NumismaticEmissionOutlierType.materialContradiction);

      // Must NOT contain "Esperado" or "Esperada"
      expect(matOutlier.description.contains('Esperado'), isFalse);
      expect(matOutlier.description.contains('Esperada'), isFalse);
      // Must contain the expected phrasing with current value
      expect(matOutlier.description, AppStrings.numismaticMagnitudeNotAmongExpectedDesc('Material', currentValue: 'Oro'));
    });

    test('When only 1 material is valid, text specifies the single expected material and current value', () {
      // Mexico 1980 5 Pesos has only Cuproníquel
      final instance = WorldEntity(
        id: 'inst_mex_5',
        speciesId: 'sp_coin',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        magnitudes: [
          const InstanceMagnitude(id: '1', instanceId: 'inst_mex_5', propertyName: 'País', stringValue: 'México', dataType: 'string'),
          const InstanceMagnitude(id: '2', instanceId: 'inst_mex_5', propertyName: 'Acuñación', stringValue: '1980', dataType: 'string'),
          const InstanceMagnitude(id: '3', instanceId: 'inst_mex_5', propertyName: 'Divisa', stringValue: 'MXP', dataType: 'string'),
          const InstanceMagnitude(id: '4', instanceId: 'inst_mex_5', propertyName: 'Valor nominal', stringValue: '5', dataType: 'string'),
          const InstanceMagnitude(id: '5', instanceId: 'inst_mex_5', propertyName: 'Material', stringValue: 'Oro', dataType: 'string'),
        ],
      );

      final outliers = NumismaticDomainRules.checkEmissionOutliers(
        instance: instance,
        species: coinSpecies,
      );

      expect(outliers.length, 1);
      final matOutlier = outliers.first;
      expect(matOutlier.type, NumismaticEmissionOutlierType.materialContradiction);

      // Should contain "Esperado:" and current material for 1 option
      expect(matOutlier.description.contains('Esperado: "Cuproníquel"'), isTrue);
      expect(matOutlier.description.contains('Material "Oro"'), isTrue);
    });

    test('When motif does not match single commemorative option, description indicates current and expected motif', () {
      // Mexico 1993 10 Nuevos Pesos has only Piedra del Sol
      final instance = WorldEntity(
        id: 'inst_mex_n10',
        speciesId: 'sp_coin',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        magnitudes: [
          const InstanceMagnitude(id: '1', instanceId: 'inst_mex_n10', propertyName: 'País', stringValue: 'México', dataType: 'string'),
          const InstanceMagnitude(id: '2', instanceId: 'inst_mex_n10', propertyName: 'Acuñación', stringValue: '1993', dataType: 'string'),
          const InstanceMagnitude(id: '3', instanceId: 'inst_mex_n10', propertyName: 'Divisa', stringValue: 'MXN', dataType: 'string'),
          const InstanceMagnitude(id: '4', instanceId: 'inst_mex_n10', propertyName: 'Valor nominal', stringValue: '10', dataType: 'string'),
          const InstanceMagnitude(id: '5', instanceId: 'inst_mex_n10', propertyName: 'Material', stringValue: 'Bimetálica', dataType: 'string'),
          const InstanceMagnitude(id: '6', instanceId: 'inst_mex_n10', propertyName: 'Motivo', stringValue: 'Emisión de cambio de régimen', dataType: 'string'),
        ],
      );

      final outliers = NumismaticDomainRules.checkEmissionOutliers(
        instance: instance,
        species: coinSpecies,
      );

      expect(outliers.length, 1);
      final motifOutlier = outliers.first;
      expect(motifOutlier.type, NumismaticEmissionOutlierType.motifMismatch);
      expect(motifOutlier.description, contains('Motivo actual "Emisión de cambio de régimen"'));
      expect(motifOutlier.description, contains('Esperado: "Nuevo Peso - Piedra del Sol (Centro de Plata Sterling .925)"'));
    });

    testWidgets('NumismaticEmissionOutlierStrategy motif onFix returns immediately without modal or dialog for single motif option', (WidgetTester tester) async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      final now = DateTime.now();

      await db.into(db.catalogTable).insert(
            CatalogTableCompanion.insert(
              id: 'sp_coin_n10',
              name: 'Moneda Numismática',
              mainPhotoPath: const Value('local/coin.jpg'),
              createdAt: now,
            ),
          );

      await db.into(db.subspeciesTable).insert(
            SubspeciesTableCompanion.insert(
              id: 'sub_n10',
              speciesId: 'sp_coin_n10',
              subspeciesName: '10 Nuevos Pesos 1993',
              createdAt: now,
            ),
          );

      await db.into(db.entitiesTable).insert(
            EntitiesTableCompanion.insert(
              id: 'e_n10',
              speciesId: 'sp_coin_n10',
              subspeciesId: const Value('sub_n10'),
              locationId: const Value('loc_1'),
              createdAt: now,
              updatedAt: now,
            ),
          );

      // Add magnitudes for Mexico 1993 10 MXN coin with incorrect motif
      final mags = [
        const InstanceMagnitude(id: 'm1', instanceId: 'e_n10', propertyName: 'País', stringValue: 'México', dataType: 'string'),
        const InstanceMagnitude(id: 'm2', instanceId: 'e_n10', propertyName: 'Acuñación', stringValue: '1993', dataType: 'string'),
        const InstanceMagnitude(id: 'm3', instanceId: 'e_n10', propertyName: 'Divisa', stringValue: 'MXN', dataType: 'string'),
        const InstanceMagnitude(id: 'm4', instanceId: 'e_n10', propertyName: 'Valor nominal', stringValue: '10', dataType: 'string'),
        const InstanceMagnitude(id: 'm5', instanceId: 'e_n10', propertyName: 'Material', stringValue: 'Bimetálica', dataType: 'string'),
        const InstanceMagnitude(id: 'm6', instanceId: 'e_n10', propertyName: 'Motivo', stringValue: 'Emisión de cambio de régimen', dataType: 'string'),
      ];

      for (final m in mags) {
        await db.into(db.instanceMagnitudesTable).insert(
              InstanceMagnitudesTableCompanion.insert(
                id: m.id,
                instanceId: m.instanceId,
                propertyName: m.propertyName,
                dataType: Value(m.dataType),
                stringValue: Value(m.stringValue),
                magnitudeValue: Value(m.magnitudeValue),
              ),
            );
      }

      final species = CatalogItem(
        id: 'sp_coin_n10',
        name: 'Moneda Numismática',
        type: 'Moneda',
        mainPhotoPath: 'local/coin.jpg',
        createdAt: now,
      );
      final sub = Subspecies(
        id: 'sub_n10',
        speciesId: 'sp_coin_n10',
        subspeciesName: '10 Nuevos Pesos 1993',
        createdAt: now,
      );
      final entity = WorldEntity(
        id: 'e_n10',
        speciesId: 'sp_coin_n10',
        subspeciesId: 'sub_n10',
        locationId: 'loc_1',
        createdAt: now,
        updatedAt: now,
        magnitudes: mags,
      );

      final context = AuditEvaluationContext(
        db: db,
        allEntities: [entity],
        allCatalog: [species],
        allSubspecies: [sub],
        allLocations: const [],
        allRelations: const [],
        allSpeciesMagnitudes: const [],
        allInstanceMagnitudes: mags,
        allRequirements: const [],
        effectiveLocationMap: const {},
      );

      const strategy = NumismaticEmissionOutlierStrategy();
      final cards = await strategy.evaluate(context);
      expect(cards.length, 1);
      final card = cards.first;
      expect(card.type, AuditCardType.numismaticEmissionOutlier);

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

      // Trigger onFix
      bool? fixResult;
      card.onFix(buildCtx, widgetRef).then((res) => fixResult = res);
      await tester.pumpAndSettle();

      // Should NOT open any dialog or AppWheelPicker because there is only 1 canonical motif
      expect(find.byType(AlertDialog), findsNothing);
      expect(find.byType(AppWheelPicker<String>), findsNothing);
      expect(fixResult, isTrue);

      // Verify the entity was updated with the canonical motif in the database
      final updatedMags = await (db.select(db.instanceMagnitudesTable)..where((tbl) => tbl.instanceId.equals('e_n10'))).get();
      final motifMag = updatedMags.firstWhere((m) => m.propertyName == 'Motivo');
      expect(motifMag.stringValue, 'Nuevo Peso - Piedra del Sol (Centro de Plata Sterling .925)');

      // Allow AppToast timer to complete
      await tester.pump(const Duration(seconds: 4));
    });

    testWidgets('NumismaticEmissionOutlierStrategy motif onFix auto-resolves to "Nuevo Peso" for 2 Nuevos Pesos without dialog', (WidgetTester tester) async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(() => db.close());
      final now = DateTime.now();

      await db.into(db.catalogTable).insert(
            CatalogTableCompanion.insert(
              id: 'sp_coin_n2',
              name: 'Moneda Numismática',
              mainPhotoPath: const Value('local/coin.jpg'),
              createdAt: now,
            ),
          );

      await db.into(db.subspeciesTable).insert(
            SubspeciesTableCompanion.insert(
              id: 'sub_n2',
              speciesId: 'sp_coin_n2',
              subspeciesName: '2 Nuevos Pesos 1993',
              createdAt: now,
            ),
          );

      await db.into(db.entitiesTable).insert(
            EntitiesTableCompanion.insert(
              id: 'e_n2',
              speciesId: 'sp_coin_n2',
              subspeciesId: const Value('sub_n2'),
              locationId: const Value('loc_1'),
              createdAt: now,
              updatedAt: now,
            ),
          );

      // Add magnitudes for Mexico 1993 2 MXN coin with incorrect motif
      final mags = [
        const InstanceMagnitude(id: 'm1_n2', instanceId: 'e_n2', propertyName: 'País', stringValue: 'México', dataType: 'string'),
        const InstanceMagnitude(id: 'm2_n2', instanceId: 'e_n2', propertyName: 'Acuñación', stringValue: '1993', dataType: 'string'),
        const InstanceMagnitude(id: 'm3_n2', instanceId: 'e_n2', propertyName: 'Divisa', stringValue: 'MXN', dataType: 'string'),
        const InstanceMagnitude(id: 'm4_n2', instanceId: 'e_n2', propertyName: 'Valor nominal', stringValue: '2', dataType: 'string'),
        const InstanceMagnitude(id: 'm5_n2', instanceId: 'e_n2', propertyName: 'Material', stringValue: 'Bimetálica', dataType: 'string'),
        const InstanceMagnitude(id: 'm6_n2', instanceId: 'e_n2', propertyName: 'Motivo', stringValue: 'Emisión de cambio de régimen', dataType: 'string'),
      ];

      for (final m in mags) {
        await db.into(db.instanceMagnitudesTable).insert(
              InstanceMagnitudesTableCompanion.insert(
                id: m.id,
                instanceId: m.instanceId,
                propertyName: m.propertyName,
                dataType: Value(m.dataType),
                stringValue: Value(m.stringValue),
                magnitudeValue: Value(m.magnitudeValue),
              ),
            );
      }

      final species = CatalogItem(
        id: 'sp_coin_n2',
        name: 'Moneda Numismática',
        type: 'Moneda',
        mainPhotoPath: 'local/coin.jpg',
        createdAt: now,
      );
      final sub = Subspecies(
        id: 'sub_n2',
        speciesId: 'sp_coin_n2',
        subspeciesName: '2 Nuevos Pesos 1993',
        createdAt: now,
      );
      final entity = WorldEntity(
        id: 'e_n2',
        speciesId: 'sp_coin_n2',
        subspeciesId: 'sub_n2',
        locationId: 'loc_1',
        createdAt: now,
        updatedAt: now,
        magnitudes: mags,
      );

      final context = AuditEvaluationContext(
        db: db,
        allEntities: [entity],
        allCatalog: [species],
        allSubspecies: [sub],
        allLocations: const [],
        allRelations: const [],
        allSpeciesMagnitudes: const [],
        allInstanceMagnitudes: mags,
        allRequirements: const [],
        effectiveLocationMap: const {},
      );

      const strategy = NumismaticEmissionOutlierStrategy();
      final cards = await strategy.evaluate(context);
      expect(cards.length, 1);
      final card = cards.first;
      expect(card.type, AuditCardType.numismaticEmissionOutlier);
      expect(card.question, contains('Esperado: "Nuevo Peso - Anillo de los Días (Piedra del Sol)"'));

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

      // Trigger onFix
      bool? fixResult;
      card.onFix(buildCtx, widgetRef).then((res) => fixResult = res);
      await tester.pumpAndSettle();

      // Should NOT open any dialog or AppWheelPicker because there is only 1 canonical motif ("Nuevo Peso - Anillo de los Días (Piedra del Sol)")
      expect(find.byType(AlertDialog), findsNothing);
      expect(find.byType(AppWheelPicker<String>), findsNothing);
      expect(fixResult, isTrue);

      // Verify the entity was updated with "Nuevo Peso - Anillo de los Días (Piedra del Sol)" in the database
      final updatedMags = await (db.select(db.instanceMagnitudesTable)..where((tbl) => tbl.instanceId.equals('e_n2'))).get();
      final motifMag = updatedMags.firstWhere((m) => m.propertyName == 'Motivo');
      expect(motifMag.stringValue, 'Nuevo Peso - Anillo de los Días (Piedra del Sol)');

      // Allow AppToast timer to complete
      await tester.pump(const Duration(seconds: 4));
    });
  });
}
