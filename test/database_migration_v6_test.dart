import 'dart:convert';
import 'dart:io';
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
    tempDir = Directory.systemTemp.createTempSync('migration_v6_unit_test_');
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

  group('Migration v6 & Ignored Audit Cards Tests', () {
    test('1. AppDatabase onUpgrade from v5 to v6 creates ignored_audit_cards table and schemaVersion is 6', () async {
      final executor = NativeDatabase.memory();
      final db = AppDatabase(executor);

      expect(db.schemaVersion, equals(6));

      // Execute migration v5 -> v6
      await db.migration.onUpgrade(db.createMigrator(), 5, 6);

      // Verify ignoredAuditCardsTable is accessible
      final cards = await db.getAllIgnoredAuditCards();
      expect(cards, isEmpty);

      await db.close();
    });

    test('2. AppDatabase helper methods ignore, query, unignore, and check ignored cards', () async {
      final db = AppDatabase(NativeDatabase.memory());

      expect(await db.isAuditCardIgnored('card_numis_1'), isFalse);

      await db.ignoreAuditCard(
        'card_numis_1',
        ruleId: 'numismatic_subspecies_incongruity',
        targetId: 'sub_123',
        targetType: 'subspecies',
        title: 'Verificación de Moneda',
        subtitle: '10 Pesos Mexicanos',
      );

      expect(await db.isAuditCardIgnored('card_numis_1'), isTrue);

      final allIgnored = await db.getAllIgnoredAuditCards();
      expect(allIgnored.length, equals(1));
      expect(allIgnored.first.cardId, equals('card_numis_1'));
      expect(allIgnored.first.ruleId, equals('numismatic_subspecies_incongruity'));
      expect(allIgnored.first.title, equals('Verificación de Moneda'));
      expect(allIgnored.first.subtitle, equals('10 Pesos Mexicanos'));

      // Unignore
      await db.unignoreAuditCard('card_numis_1');
      expect(await db.isAuditCardIgnored('card_numis_1'), isFalse);
      expect(await db.getAllIgnoredAuditCards(), isEmpty);

      await db.close();
    });

    test('3. DatabaseBackupService exports ignored_audit_cards and restores them faithfully', () async {
      final db = AppDatabase(NativeDatabase.memory());
      final backupService = DatabaseBackupService(db);

      // Seed an ignored card
      await db.ignoreAuditCard(
        'card_ignored_42',
        ruleId: 'orphan_entity',
        targetId: 'e_orphan_1',
        targetType: 'entity',
        title: 'Entidad sin Ubicación',
        subtitle: 'Moneda Antigua',
      );

      // Export
      final exportedJson = await backupService.exportDatabaseToJsonMap();
      expect(exportedJson['version'], equals(6));
      final tables = exportedJson['tables'] as Map<String, dynamic>;
      expect(tables.containsKey('ignored_audit_cards'), isTrue);

      final ignoredList = tables['ignored_audit_cards'] as List;
      expect(ignoredList.length, equals(1));
      expect(ignoredList.first['cardId'], equals('card_ignored_42'));
      expect(ignoredList.first['ruleId'], equals('orphan_entity'));
      expect(ignoredList.first['title'], equals('Entidad sin Ubicación'));

      // Re-import into a fresh database
      final freshDb = AppDatabase(NativeDatabase.memory());
      final freshBackupService = DatabaseBackupService(freshDb);

      await freshBackupService.importDatabaseFromJsonString(jsonEncode(exportedJson));

      final restored = await freshDb.getAllIgnoredAuditCards();
      expect(restored.length, equals(1));
      expect(restored.first.cardId, equals('card_ignored_42'));
      expect(restored.first.ruleId, equals('orphan_entity'));
      expect(restored.first.title, equals('Entidad sin Ubicación'));
      expect(restored.first.subtitle, equals('Moneda Antigua'));

      await db.close();
      await freshDb.close();
    });

    test('4. migrateImportedData handles legacy v5 backup without ignored_audit_cards gracefully', () async {
      final db = AppDatabase(NativeDatabase.memory());
      final backupService = DatabaseBackupService(db);

      final v5Json = {
        'version': 5,
        'exportedAt': DateTime.now().toIso8601String(),
        'tables': {
          'catalog': [
            {'id': 'sp_1', 'name': 'Caja Fuerte', 'type': 'Objeto', 'createdAt': DateTime.now().toIso8601String()},
          ],
          'entities': [
            {'id': 'e_1', 'speciesId': 'sp_1', 'createdAt': DateTime.now().toIso8601String(), 'updatedAt': DateTime.now().toIso8601String()},
          ],
        }
      };

      final migrated = backupService.migrateImportedData(v5Json, targetVersion: 6);

      expect(migrated['version'], equals(6));
      final tables = migrated['tables'] as Map<String, dynamic>;
      expect(tables.containsKey('ignored_audit_cards'), isTrue);
      expect(tables['ignored_audit_cards'], isA<List>());
      expect((tables['ignored_audit_cards'] as List), isEmpty);

      // Verify that import completes without throwing
      await expectLater(backupService.importDatabaseFromJsonString(jsonEncode(migrated)), completes);

      await db.close();
    });
  });
}
