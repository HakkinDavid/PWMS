import 'dart:convert';
import 'dart:io';
import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:platinum_world_management_system/src/core/database/app_database.dart';
import 'package:platinum_world_management_system/src/core/database/database_backup_service.dart';

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
    tempDir = Directory.systemTemp.createTempSync('migration_unit_test_');
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

  group('Migration v4 Enforcing Contained Entity Direct Location Null Tests', () {
    test('AppDatabase onUpgrade from v3 to v4 cleans direct locations for contained entities', () async {
      final executor = NativeDatabase.memory();
      final db = AppDatabase(executor);

      final now = DateTime.now();

      // Seed catalog, locations, entities, relations and direct locations
      await db.into(db.catalogTable).insert(
            CatalogTableCompanion.insert(id: 'sp_box', name: 'Caja Fuerte', createdAt: now),
          );
      await db.into(db.catalogTable).insert(
            CatalogTableCompanion.insert(id: 'sp_gold', name: 'Moneda de Oro', createdAt: now),
          );
      await db.into(db.locationsTable).insert(
            LocationsTableCompanion.insert(id: 'loc_office', name: 'Oficina', createdAt: now),
          );

      // Box is directly in office
      await db.into(db.entitiesTable).insert(
            EntitiesTableCompanion.insert(id: 'e_box', speciesId: 'sp_box', locationId: const drift.Value('loc_office'), createdAt: now, updatedAt: now),
          );
      await db.into(db.instanceLocationsTable).insert(
            InstanceLocationsTableCompanion.insert(instanceId: 'e_box', locationId: 'loc_office', createdAt: now),
          );

      // Gold coin is contained in Box, BUT has legacy direct location in DB (conflict to be migrated)
      await db.into(db.entitiesTable).insert(
            EntitiesTableCompanion.insert(id: 'e_gold', speciesId: 'sp_gold', locationId: const drift.Value('loc_office'), createdAt: now, updatedAt: now),
          );
      await db.into(db.instanceLocationsTable).insert(
            InstanceLocationsTableCompanion.insert(instanceId: 'e_gold', locationId: 'loc_office', createdAt: now),
          );
      await db.into(db.relationsTable).insert(
            RelationsTableCompanion.insert(
              id: 'rel_bg',
              sourceEntityId: 'e_gold',
              targetEntityId: 'e_box',
              relationType: 'GUARDADO_EN',
              createdAt: now,
            ),
          );

      // Execute migration v3 -> v4 logic via onUpgrade
      await db.migration.onUpgrade(db.createMigrator(), 3, 4);

      // Verify that e_box (not contained) still has direct location
      final boxDirectLoc = await (db.select(db.instanceLocationsTable)..where((t) => t.instanceId.equals('e_box'))).getSingleOrNull();
      expect(boxDirectLoc, isNotNull);
      expect(boxDirectLoc?.locationId, equals('loc_office'));

      final boxEntity = await (db.select(db.entitiesTable)..where((t) => t.id.equals('e_box'))).getSingle();
      expect(boxEntity.locationId, equals('loc_office'));

      // Verify that e_gold (contained in e_box) has NULL direct location in entities_table and NO row in instance_locations_table
      final goldDirectLoc = await (db.select(db.instanceLocationsTable)..where((t) => t.instanceId.equals('e_gold'))).getSingleOrNull();
      expect(goldDirectLoc, isNull);

      final goldEntity = await (db.select(db.entitiesTable)..where((t) => t.id.equals('e_gold'))).getSingle();
      expect(goldEntity.locationId, isNull);

      await db.close();
    });

    test('DatabaseBackupService JSON migration from v3 to v4 enforces locationId null for contained items', () {
      final db = AppDatabase(NativeDatabase.memory());
      final backupService = DatabaseBackupService(db);

      final v3Json = {
        'version': 3,
        'exportedAt': DateTime.now().toIso8601String(),
        'tables': {
          'catalog': [
            {'id': 'sp_box', 'name': 'Caja', 'type': 'Objeto', 'createdAt': DateTime.now().toIso8601String()},
            {'id': 'sp_gem', 'name': 'Gema', 'type': 'Objeto', 'createdAt': DateTime.now().toIso8601String()},
          ],
          'entities': [
            {'id': 'e_box', 'speciesId': 'sp_box', 'locationId': 'loc_room', 'createdAt': DateTime.now().toIso8601String(), 'updatedAt': DateTime.now().toIso8601String()},
            {'id': 'e_gem', 'speciesId': 'sp_gem', 'locationId': 'loc_room', 'createdAt': DateTime.now().toIso8601String(), 'updatedAt': DateTime.now().toIso8601String()},
          ],
          'instanceLocations': [
            {'id': 'il_1', 'instanceId': 'e_box', 'locationId': 'loc_room', 'createdAt': DateTime.now().toIso8601String()},
            {'id': 'il_2', 'instanceId': 'e_gem', 'locationId': 'loc_room', 'createdAt': DateTime.now().toIso8601String()},
          ],
          'relations': [
            {
              'id': 'rel_1',
              'sourceEntityId': 'e_gem',
              'targetEntityId': 'e_box',
              'relationType': 'GUARDADO_EN',
              'createdAt': DateTime.now().toIso8601String()
            }
          ]
        }
      };

      final migrated = backupService.migrateImportedData(v3Json, targetVersion: 4);

      expect(migrated['version'], equals(4));

      final tables = migrated['tables'] as Map<String, dynamic>;
      final entities = tables['entities'] as List;
      final instanceLocations = tables['instanceLocations'] as List;

      // e_box should keep its location
      final boxEntity = entities.firstWhere((e) => e['id'] == 'e_box');
      expect(boxEntity['locationId'], equals('loc_room'));

      final boxLoc = instanceLocations.where((il) => il['instanceId'] == 'e_box').firstOrNull;
      expect(boxLoc, isNotNull);

      // e_gem is contained, so locationId must be null and deleted from instanceLocations
      final gemEntity = entities.firstWhere((e) => e['id'] == 'e_gem');
      expect(gemEntity['locationId'], isNull);

      final gemLoc = instanceLocations.where((il) => il['instanceId'] == 'e_gem').firstOrNull;
      expect(gemLoc, isNull);
    });
  });
}
