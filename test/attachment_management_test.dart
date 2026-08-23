import 'dart:io';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:platinum_world_management_system/src/core/database/app_database.dart';
import 'package:platinum_world_management_system/src/core/storage/file_storage_service.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/catalog_item.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/numismatic_data_helper.dart';
import 'package:platinum_world_management_system/src/features/catalog/infrastructure/catalog_repository.dart';
import 'package:platinum_world_management_system/src/features/entities/domain/attachment.dart';
import 'package:platinum_world_management_system/src/features/entities/infrastructure/entity_repository.dart';

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
  late EntityRepository entityRepo;
  late CatalogRepository catalogRepo;
  late Directory tempDir;
  late FileStorageService fileStorageService;

  setUp(() async {
    tempDir = Directory.systemTemp.createTempSync('attachment_test_media_');
    PathProviderPlatform.instance = FakePathProviderPlatform(
      tempPath: p.join(tempDir.path, 'temp'),
      docsPath: p.join(tempDir.path, 'docs'),
    );

    fileStorageService = FileStorageService();
    db = AppDatabase(NativeDatabase.memory());
    entityRepo = EntityRepository(db, fileStorageService);
    catalogRepo = CatalogRepository(db, fileStorageService);
  });

  tearDown(() async {
    await db.close();
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('Attachment Management & In-Place Replacement Tests', () {
    test('addAttachment creates species and instance attachments correctly', () async {
      // 1. Setup species and instance
      final species = await catalogRepo.getOrCreateSpecies('Moneda 5 Pesos', type: 'Objeto');
      final instance = await entityRepo.instantiateOrMerge(species.id, null, 1.0);

      // 2. Add species attachment
      final speciesAtt = Attachment(
        id: 'att_species_1',
        speciesId: species.id,
        instanceId: null,
        filePath: 'mock/species_manual.pdf',
        fileName: 'manual.pdf',
        fileType: 'pdf',
        createdAt: DateTime(2026, 1, 1, 12, 0),
      );
      await entityRepo.addAttachment(speciesAtt);

      // 3. Add instance attachment
      final instanceAtt = Attachment(
        id: 'att_inst_1',
        speciesId: species.id,
        instanceId: instance.id,
        filePath: 'mock/coin_obverse.jpg',
        fileName: '5_Pesos_(anverso).jpg',
        fileType: 'image',
        createdAt: DateTime(2026, 1, 2, 14, 0),
      );
      await entityRepo.addAttachment(instanceAtt);

      // 4. Query species attachments (only species-level)
      final speciesList = await entityRepo.getAttachmentsForSpecies(species.id);
      expect(speciesList.length, 1);
      expect(speciesList.first.id, 'att_species_1');
      expect(speciesList.first.instanceId, isNull);

      // 5. Query instance attachments
      final instanceList = await entityRepo.getAttachmentsForInstance(instance.id);
      expect(instanceList.length, 1);
      expect(instanceList.first.id, 'att_inst_1');
      expect(instanceList.first.instanceId, instance.id);
    });

    test('updateAttachment modifies metadata while preserving ID, speciesId, and createdAt', () async {
      final species = await catalogRepo.getOrCreateSpecies('Billete 100 Pesos', type: 'Objeto');
      final originalCreated = DateTime(2026, 1, 1, 10, 0);

      final att = Attachment(
        id: 'att_rename_test',
        speciesId: species.id,
        instanceId: null,
        filePath: 'mock/original.jpg',
        fileName: 'foto_antigua.jpg',
        fileType: 'image',
        createdAt: originalCreated,
      );
      await entityRepo.addAttachment(att);

      // Rename
      final updated = att.copyWith(fileName: 'foto_nueva_renombrada.jpg');
      await entityRepo.updateAttachment(updated);

      final list = await entityRepo.getAttachmentsForSpecies(species.id);
      expect(list.length, 1);
      expect(list.first.id, 'att_rename_test');
      expect(list.first.fileName, 'foto_nueva_renombrada.jpg');
      expect(list.first.createdAt, originalCreated);
    });

    test('replaceAttachmentFile updates physical path and metadata in-place', () async {
      final species = await catalogRepo.getOrCreateSpecies('Moneda 10 Pesos', type: 'Objeto');
      final instance = await entityRepo.instantiateOrMerge(species.id, null, 1.0);

      // Create a temporary physical file
      final initialFile = File('${tempDir.path}/initial_obverse.jpg');
      await initialFile.writeAsString('initial-content');

      final savedRelative = await fileStorageService.saveFile(initialFile.path);
      final originalCreated = DateTime(2026, 2, 1, 8, 30);

      final att = Attachment(
        id: 'att_inplace_replace',
        speciesId: species.id,
        instanceId: instance.id,
        filePath: savedRelative,
        fileName: '10_Pesos (anverso).jpg',
        fileType: 'image',
        createdAt: originalCreated,
      );
      await entityRepo.addAttachment(att);

      // Create new replacement physical file
      final newFile = File('${tempDir.path}/replacement_obverse.jpg');
      await newFile.writeAsString('high-def-cropped-replacement-content');

      // Replace in-place
      await entityRepo.replaceAttachmentFile(
        'att_inplace_replace',
        newFile.path,
        newFileName: '10_Pesos (anverso)_v2.jpg',
        newFileType: 'image',
      );

      final list = await entityRepo.getAttachmentsForInstance(instance.id);
      expect(list.length, 1);
      final replaced = list.first;

      // Identity & metadata preservation
      expect(replaced.id, 'att_inplace_replace');
      expect(replaced.speciesId, species.id);
      expect(replaced.instanceId, instance.id);
      expect(replaced.createdAt, originalCreated);
      expect(replaced.fileName, '10_Pesos (anverso)_v2.jpg');
      expect(replaced.filePath, isNot(savedRelative)); // New path stored
    });

    test('deleteAttachment deletes database record and file', () async {
      final species = await catalogRepo.getOrCreateSpecies('Prueba Delete', type: 'Objeto');
      final testFile = File('${tempDir.path}/to_delete.png');
      await testFile.writeAsString('dummy data');
      final savedRelative = await fileStorageService.saveFile(testFile.path);

      final att = Attachment(
        id: 'att_to_delete',
        speciesId: species.id,
        instanceId: null,
        filePath: savedRelative,
        fileName: 'to_delete.png',
        fileType: 'image',
        createdAt: DateTime.now(),
      );
      await entityRepo.addAttachment(att);

      var list = await entityRepo.getAttachmentsForSpecies(species.id);
      expect(list.length, 1);

      await entityRepo.deleteAttachment('att_to_delete');

      list = await entityRepo.getAttachmentsForSpecies(species.id);
      expect(list.isEmpty, isTrue);
    });

    test('Numismatic mode detection and helper rules', () {
      final coinSpecies = CatalogItem(id: 'c1', name: 'Moneda 1 Peso', type: 'Objeto', createdAt: DateTime.now());
      final banknoteSpecies = CatalogItem(id: 'b1', name: 'Billete 50 Pesos', type: 'Objeto', createdAt: DateTime.now());
      final generalSpecies = CatalogItem(id: 'g1', name: 'Taza de Café', type: 'Objeto', createdAt: DateTime.now());

      expect(NumismaticDataHelper.isNumismaticSpecies(coinSpecies), isTrue);
      expect(NumismaticDataHelper.isNumismaticSpecies(banknoteSpecies), isTrue);
      expect(NumismaticDataHelper.isNumismaticSpecies(generalSpecies), isFalse);

      expect(NumismaticDataHelper.isCoin(coinSpecies), isTrue);
      expect(NumismaticDataHelper.isCoin(banknoteSpecies), isFalse);

      final fileName = NumismaticDataHelper.buildAttachmentFileName(
        subspeciesName: '5 Pesos - México (2020)',
        instanceId: 'inst_99',
        side: 'anverso',
        extension: 'jpg',
      );
      expect(fileName, '5 Pesos - México (2020) (inst_99) (anverso).jpg');
    });
  });
}
