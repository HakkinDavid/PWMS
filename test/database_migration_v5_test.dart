import 'dart:io';
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:platinum_world_management_system/src/core/database/app_database.dart';
import 'package:platinum_world_management_system/src/core/database/database_backup_service.dart';
import 'package:platinum_world_management_system/src/core/domain/domain_rules.dart';
import 'package:platinum_world_management_system/src/core/providers/providers.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/catalog_item.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/species_magnitude.dart';
import 'package:platinum_world_management_system/src/features/control_center/domain/audit_rule_strategy.dart';
import 'package:platinum_world_management_system/src/features/control_center/domain/strategies/expiration_audit_rules.dart';
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
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;

  setUp(() {
    tempDir = Directory.systemTemp.createTempSync('migration_v5_unit_test_');
    PathProviderPlatform.instance = FakePathProviderPlatform(
      tempPath: p.join(tempDir.path, 'temp'),
      docsPath: p.join(tempDir.path, 'docs'),
    );
  });

  tearDown(() {
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  group('Migration v5 & Nullable Instance Magnitudes Tests', () {
    test('1. AppDatabase onUpgrade from v4 to v5 succeeds and schemaVersion is 5', () async {
      final executor = NativeDatabase.memory();
      final db = AppDatabase(executor);

      expect(db.schemaVersion, equals(5));

      // Execute migration v4 -> v5
      await db.migration.onUpgrade(db.createMigrator(), 4, 5);

      await db.close();
    });

    test('2. DatabaseBackupService preserves null magnitudeValue during v4 to v5 migration and restore', () async {
      final db = AppDatabase(NativeDatabase.memory());
      final backupService = DatabaseBackupService(db);

      final v4Json = {
        'version': 4,
        'exportedAt': DateTime.now().toIso8601String(),
        'tables': {
          'catalog': [
            {'id': 'sp_note', 'name': 'Billete de 10 Rupias', 'type': 'Objeto', 'createdAt': DateTime.now().toIso8601String()},
          ],
          'entities': [
            {'id': 'e_note', 'speciesId': 'sp_note', 'createdAt': DateTime.now().toIso8601String(), 'updatedAt': DateTime.now().toIso8601String()},
          ],
          'instanceMagnitudes': [
            {
              'id': 'im_1',
              'instanceId': 'e_note',
              'propertyName': 'Acuñación',
              'dataType': 'integer',
              'magnitudeValue': null, // Intentionally null for undated banknote
              'stringValue': null,
              'unitSymbol': 'año',
            },
            {
              'id': 'im_2',
              'instanceId': 'e_note',
              'propertyName': 'Valor Nominal',
              'dataType': 'real',
              'magnitudeValue': 10.0,
              'stringValue': null,
              'unitSymbol': null,
            }
          ]
        }
      };

      final migrated = backupService.migrateImportedData(v4Json, targetVersion: 5);
      expect(migrated['version'], equals(5));

      final tables = migrated['tables'] as Map<String, dynamic>;
      final mags = tables['instanceMagnitudes'] as List;

      final undatedMag = mags.firstWhere((m) => m['id'] == 'im_1');
      expect(undatedMag['magnitudeValue'], isNull);

      final faceValMag = mags.firstWhere((m) => m['id'] == 'im_2');
      expect(faceValMag['magnitudeValue'], equals(10.0));

      await db.close();
    });

    test('3. InstanceMagnitude with null magnitudeValue displays placeholder and does not force 0', () {
      const undatedMintage = InstanceMagnitude(
        id: 'im_undated',
        instanceId: 'e_note',
        propertyName: 'Acuñación',
        dataType: 'integer',
        magnitudeValue: null,
        unitSymbol: 'año',
      );

      expect(undatedMintage.displayValue, equals('—'));

      const unspecifiedReal = InstanceMagnitude(
        id: 'im_mass',
        instanceId: 'e_box',
        propertyName: 'Masa',
        dataType: 'real',
        magnitudeValue: null,
        unitSymbol: 'kg',
      );

      expect(unspecifiedReal.displayValue, equals('—'));

      const unspecifiedString = InstanceMagnitude(
        id: 'im_str',
        instanceId: 'e_box',
        propertyName: 'Material',
        dataType: 'string',
        stringValue: null,
      );

      expect(unspecifiedString.displayValue, equals(''));
    });

    test('4. DomainRules formatMagnitude and isValidMagnitudeForUnit handle null gracefully', () {
      expect(DomainRules.formatMagnitude(null, 'año'), equals('—'));
      expect(DomainRules.formatMagnitude(2022.0, 'año'), equals('2022'));
      expect(DomainRules.isValidMagnitudeForUnit(magnitude: null, unitSymbol: 'año'), isTrue);
      expect(DomainRules.isValidMagnitudeForUnit(magnitude: 2022.0, unitSymbol: 'año'), isTrue);
    });

    test('5. Control Center strategies do not falsely flag explicit null magnitudes as anomalous', () async {
      final db = AppDatabase(NativeDatabase.memory());
      const anomStrategy = AnomalousMagnitudeStrategy();

      final entityWithNullMag = WorldEntity(
        id: 'e_note',
        speciesId: 'sp_note',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        magnitudes: [
          const InstanceMagnitude(
            id: 'im_undated',
            instanceId: 'e_note',
            propertyName: 'Acuñación',
            dataType: 'integer',
            magnitudeValue: null,
            unitSymbol: 'año',
          ),
          const InstanceMagnitude(
            id: 'im_real_null',
            instanceId: 'e_note',
            propertyName: 'Grosor',
            dataType: 'real',
            magnitudeValue: null,
            unitSymbol: 'mm',
          ),
        ],
      );

      final context = AuditEvaluationContext(
        db: db,
        allEntities: [entityWithNullMag],
        allCatalog: const [],
        allSubspecies: const [],
        allRelations: const [],
        allLocations: const [],
        allSpeciesMagnitudes: const [],
        allInstanceMagnitudes: entityWithNullMag.magnitudes,
        allRequirements: const [],
        effectiveLocationMap: const {},
      );

      final cards = await anomStrategy.evaluate(context);
      expect(cards.isEmpty, isTrue);

      await db.close();
    });

    testWidgets('6. MissingMandatoryMagnitudesStrategy onFix presents explicit dialog with [Establecer nulo]', (WidgetTester tester) async {
      final db = AppDatabase(NativeDatabase.memory());
      const missingStrategy = MissingMandatoryMagnitudesStrategy();

      final now = DateTime.now();
      await db.into(db.catalogTable).insert(
        CatalogTableCompanion.insert(id: 'sp_note', name: 'Billete 10 Rupias', type: const Value('Objeto'), createdAt: now),
      );
      await db.into(db.entitiesTable).insert(
        EntitiesTableCompanion.insert(id: 'ent_note_1', speciesId: 'sp_note', createdAt: now, updatedAt: now),
      );

      final speciesMag = SpeciesMagnitude(
        id: 'sm_mintage',
        speciesId: 'sp_note',
        propertyName: 'Acuñación',
        dataType: 'integer',
        unitSymbol: 'año',
        createdAt: now,
      );

      final entityWithoutMag = WorldEntity(
        id: 'ent_note_1',
        speciesId: 'sp_note',
        createdAt: now,
        updatedAt: now,
        magnitudes: const [],
      );

      final species = CatalogItem(
        id: 'sp_note',
        name: 'Billete 10 Rupias',
        type: 'Objeto',
        createdAt: now,
        magnitudes: [speciesMag],
      );

      final context = AuditEvaluationContext(
        db: db,
        allEntities: [entityWithoutMag],
        allCatalog: [species],
        allSubspecies: const [],
        allRelations: const [],
        allLocations: const [],
        allSpeciesMagnitudes: [speciesMag],
        allInstanceMagnitudes: const [],
        allRequirements: const [],
        effectiveLocationMap: const {},
      );

      final cards = await missingStrategy.evaluate(context);
      expect(cards.length, equals(1));
      final card = cards.first;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (ctx) => Consumer(
                  builder: (context, ref, _) => ElevatedButton(
                    onPressed: () async {
                      await card.onFix?.call(ctx, ref);
                    },
                    child: const Text('Resolve'),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      // Tap Resolve to trigger onFix dialog
      await tester.tap(find.text('Resolve'));
      await tester.pumpAndSettle();

      // Check that the explicit dialog options are present:
      expect(find.text('Establecer nulo'), findsOneWidget);
      expect(find.text('Ingresar valor'), findsOneWidget);
      expect(find.text('Cancelar'), findsOneWidget);

      // Tap [Establecer nulo]
      await tester.tap(find.text('Establecer nulo'));
      await tester.pumpAndSettle();

      // Verify that the entity now has the magnitude stored with magnitudeValue == null
      final savedMags = await (db.select(db.instanceMagnitudesTable)..where((t) => t.instanceId.equals('ent_note_1'))).get();
      expect(savedMags.length, equals(1));
      expect(savedMags.first.propertyName, equals('Acuñación'));
      expect(savedMags.first.magnitudeValue, isNull);
      expect(savedMags.first.stringValue, isNull);

      await tester.pump(const Duration(seconds: 4));
      await db.close();
    });
  });
}
