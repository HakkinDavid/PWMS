import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';
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

  late AppDatabase db;
  late DatabaseBackupService backupService;
  late Directory tempDir;

  setUp(() {
    tempDir = Directory.systemTemp.createTempSync('backup_unit_test_');
    PathProviderPlatform.instance = FakePathProviderPlatform(
      tempPath: p.join(tempDir.path, 'temp'),
      docsPath: p.join(tempDir.path, 'docs'),
    );

    db = AppDatabase(NativeDatabase.memory());
    backupService = DatabaseBackupService(db);
  });

  tearDown(() async {
    await db.close();
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  group('DatabaseBackupService ZIP Snapshot Tests', () {
    test('exportDatabaseToJsonMap generates valid structure with 14 tables including appSettings and data types', () async {
      await db.setSetting('app_theme', 'dark');

      final jsonMap = await backupService.exportDatabaseToJsonMap();

      expect(jsonMap.containsKey('version'), isTrue);
      expect(jsonMap.containsKey('exportedAt'), isTrue);
      expect(jsonMap.containsKey('tables'), isTrue);

      final tables = jsonMap['tables'] as Map<String, dynamic>;
      expect(tables.length, equals(15));
      expect(tables.containsKey('catalog'), isTrue);
      expect(tables.containsKey('subspecies'), isTrue);
      expect(tables.containsKey('entities'), isTrue);
      expect(tables.containsKey('locations'), isTrue);
      expect(tables.containsKey('appSettings'), isTrue);
      expect(tables.containsKey('ignored_audit_cards'), isTrue);

      final settings = tables['appSettings'] as List;
      expect(settings.any((s) => s['key'] == 'app_theme' && s['value'] == 'dark'), isTrue);
    });

    test('importDatabaseFromFile imports ZIP archive and restores tables, settings and media files', () async {
      // 1. Create dummy JSON
      final dummyMap = {
        'version': 3,
        'exportedAt': DateTime.now().toIso8601String(),
        'tables': {
          'locations': [
            {
              'id': 'loc-test',
              'name': 'Ubicación de Prueba',
              'parentLocationId': null,
              'description': 'Test',
              'icon': null,
              'createdAt': DateTime.now().toIso8601String(),
            }
          ],
          'catalog': [
            {
              'id': 'spec-test',
              'name': 'Especie de Prueba',
              'type': 'Objeto',
              'description': null,
              'mainPhotoPath': '/data/user/0/com.example/sample_photo.jpg',
              'customAttributes': null,
              'isUnique': false,
              'isNonPerishable': true,
              'defaultShelfLifeDays': null,
              'warningDaysBeforeExpiration': 7,
              'createdAt': DateTime.now().toIso8601String(),
            }
          ],
          'subspecies': [],
          'speciesMagnitudes': [],
          'entities': [],
          'instanceMagnitudes': [],
          'instanceLocations': [],
          'relations': [],
          'attachments': [],
          'historyEvents': [],
          'customTemplates': [],
          'speciesRequirements': [],
          'notifications': [],
          'appSettings': [
            {'key': 'currency', 'value': 'MXN'}
          ],
        }
      };

      final jsonStr = jsonEncode(dummyMap);

      // 2. Build in-memory ZIP archive
      final archive = Archive();
      final jsonBytes = utf8.encode(jsonStr);
      archive.addFile(ArchiveFile('database.json', jsonBytes.length, jsonBytes));

      final samplePhotoBytes = utf8.encode('fake_image_bytes');
      archive.addFile(ArchiveFile('files/sample_photo.jpg', samplePhotoBytes.length, samplePhotoBytes));

      final zipBytes = ZipEncoder().encode(archive)!;

      // 3. Write ZIP to temporary file
      final zipFile = File(p.join(tempDir.path, 'backup.zip'));
      await zipFile.writeAsBytes(zipBytes);

      // 4. Import ZIP into database
      await backupService.importDatabaseFromFile(zipFile);

      // 5. Verify database content restored and path sanitized
      final catalogItems = await db.select(db.catalogTable).get();
      expect(catalogItems.length, equals(1));
      expect(catalogItems.first.name, equals('Especie de Prueba'));
      expect(catalogItems.first.mainPhotoPath, equals('sample_photo.jpg'));

      final locations = await db.select(db.locationsTable).get();
      expect(locations.length, equals(1));
      expect(locations.first.name, equals('Ubicación de Prueba'));

      final settingVal = await db.getSetting('currency');
      expect(settingVal, equals('MXN'));

      // 6. Verify physical file restored in media dir
      final restoredFile = File(p.join(tempDir.path, 'docs', 'pwms_media', 'sample_photo.jpg'));
      expect(restoredFile.existsSync(), isTrue);
      expect(restoredFile.readAsStringSync(), equals('fake_image_bytes'));
    });

    test('importDatabaseFromFile ignores macOS metadata files (__MACOSX, ._database.json)', () async {
      final dummyMap = {
        'version': 1,
        'exportedAt': DateTime.now().toIso8601String(),
        'tables': {
          'locations': [],
          'catalog': [],
          'subspecies': [],
          'speciesMagnitudes': [],
          'entities': [],
          'instanceMagnitudes': [],
          'instanceLocations': [],
          'relations': [],
          'attachments': [],
          'historyEvents': [],
          'customTemplates': [],
          'speciesRequirements': [],
          'notifications': [],
        }
      };

      final archive = Archive();
      final jsonBytes = utf8.encode(jsonEncode(dummyMap));
      archive.addFile(ArchiveFile('database.json', jsonBytes.length, jsonBytes));

      // Simulate macOS AppleDouble metadata binary file
      final macMetadataBytes = [0x00, 0x05, 0x16, 0x07, 0x00, 0x02, 0x00, 0x00, 0x4D, 0x61, 0x63, 0x20, 0x4F, 0x53];
      archive.addFile(ArchiveFile('__MACOSX/._database.json', macMetadataBytes.length, macMetadataBytes));
      archive.addFile(ArchiveFile('.DS_Store', 10, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]));

      final zipBytes = ZipEncoder().encode(archive)!;
      final zipFile = File(p.join(tempDir.path, 'mac_backup.zip'));
      await zipFile.writeAsBytes(zipBytes);

      // Should not throw FormatException / Unexpected extension byte
      await expectLater(backupService.importDatabaseFromFile(zipFile), completes);
    });

    test('migrateImportedData executes sequential step migrations and retroactively repairs legacy data', () async {
      final v1Map = {
        'version': '1.0',
        'exportedAt': DateTime.now().toIso8601String(),
        'tables': {
          'catalog': [
            {'id': 'c1', 'name': 'Objeto Antiguo', 'mainPhotoPath': '/data/user/0/app/pic.jpg'}
          ],
          'attachments': [
            {'id': 'a1', 'speciesId': 'c1', 'filePath': '/storage/emulated/0/doc.pdf', 'fileName': 'doc.pdf', 'fileType': 'doc', 'createdAt': DateTime.now().toIso8601String()}
          ]
        }
      };

      final migrated = backupService.migrateImportedData(v1Map, targetVersion: 3);

      expect(migrated['version'], equals(3));
      final tables = migrated['tables'] as Map<String, dynamic>;

      // Verify v1 -> v2 defaults
      final catalogItem = (tables['catalog'] as List).first as Map<String, dynamic>;
      expect(catalogItem['type'], equals('Objeto'));
      expect(catalogItem['isNonPerishable'], equals(true));
      expect(catalogItem['mainPhotoPath'], equals('pic.jpg'));

      // Verify v2 -> v3 defaults
      final attachmentItem = (tables['attachments'] as List).first as Map<String, dynamic>;
      expect(attachmentItem.containsKey('instanceId'), isTrue);
      expect(attachmentItem['instanceId'], isNull);
      expect(attachmentItem['filePath'], equals('doc.pdf'));
    });
  });
}
