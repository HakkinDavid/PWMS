import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:uuid/uuid.dart';
import 'package:platinum_world_management_system/src/core/database/app_database.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/numismatic_data_helper.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/subspecies.dart';
import 'package:platinum_world_management_system/src/features/catalog/infrastructure/catalog_repository.dart';
import 'package:platinum_world_management_system/src/features/entities/domain/instance_magnitude.dart';
import 'package:platinum_world_management_system/src/features/entities/infrastructure/entity_repository.dart';

import 'package:path/path.dart' as p;
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

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
  late AppDatabase db;
  late CatalogRepository catalogRepo;
  late EntityRepository entityRepo;
  late Directory tempDir;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    tempDir = Directory.systemTemp.createTempSync('cc_audit_test_');
    PathProviderPlatform.instance = FakePathProviderPlatform(
      tempPath: p.join(tempDir.path, 'temp'),
      docsPath: p.join(tempDir.path, 'docs'),
    );

    db = AppDatabase(NativeDatabase.memory());
    catalogRepo = CatalogRepository(db);
    entityRepo = EntityRepository(db);
  });

  tearDown(() async {
    await db.close();
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  group('Control Center Numismatic Audit Integration Tests', () {
    test('Repair subspecies from instance updates subspecies name and notes in DB', () async {
      final species = await catalogRepo.getOrCreateSpecies(
        'Moneda',
        type: 'Objeto',
        description: 'Categoría numismática (Moneda)',
      );

      // Create subspecies with legacy granular name
      final subspecies = Subspecies(
        id: const Uuid().v4(),
        speciesId: species.id,
        subspeciesName: '5 Pesos Mexicanos - México (2020)',
        notes: 'Moneda: Pesos Mexicanos | Año: 2020',
        createdAt: DateTime.now(),
      );
      await catalogRepo.saveSubspecies(subspecies);

      // Create instance with actual corrected year 2022 and non-ISO currency in magnitude
      final instance = await entityRepo.instantiateOrMerge(
        species.id,
        null,
        1.0,
        subspeciesId: subspecies.id,
      );

      final updatedInstance = instance.copyWith(
        magnitudes: [
          InstanceMagnitude(
            id: const Uuid().v4(),
            instanceId: instance.id,
            propertyName: 'Valor nominal',
            dataType: 'real',
            magnitudeValue: 5.0,
          ),
          InstanceMagnitude(
            id: const Uuid().v4(),
            instanceId: instance.id,
            propertyName: 'Acuñación',
            dataType: 'integer',
            magnitudeValue: 2022.0,
            unitSymbol: 'año',
          ),
          InstanceMagnitude(
            id: const Uuid().v4(),
            instanceId: instance.id,
            propertyName: 'Divisa',
            dataType: 'string',
            stringValue: 'Pesos Mexicanos',
          ),
        ],
      );
      await entityRepo.saveEntity(updatedInstance);

      // Verify incongruence detected due to non-ISO currency code on instance
      final issueBefore = NumismaticDataHelper.checkInstanceSubspeciesCongruence(
        subspecies: subspecies,
        instance: updatedInstance,
      );
      expect(issueBefore, isNotNull);
      expect(issueBefore, contains('ISO'));

      // Perform repair
      final repairedSub = await NumismaticDataHelper.repairSubspeciesFromInstance(
        catalogRepo: catalogRepo,
        entityRepo: entityRepo,
        subspecies: subspecies,
        instance: updatedInstance,
      );

      expect(repairedSub.subspeciesName, equals('Pesos Mexicanos'));
      expect(repairedSub.notes, contains('Pesos Mexicanos'));

      // Verify instance magnitudes were standardized (Divisa -> MXN, Emisor backfilled)
      final reloadedEntity = await entityRepo.getEntityById(instance.id);
      final divisaMag = reloadedEntity!.magnitudes.firstWhere((m) => m.propertyName == 'Divisa');
      expect(divisaMag.stringValue, equals('MXN'));

      final emisorMag = reloadedEntity.magnitudes.firstWhere((m) => m.propertyName == 'Emisor');
      expect(emisorMag.stringValue, equals('México'));

      final issueAfter = NumismaticDataHelper.checkInstanceSubspeciesCongruence(
        subspecies: repairedSub,
        instance: reloadedEntity,
      );
      expect(issueAfter, isNull);
    });

    test('Merge duplicate subspecies reassigns instances and deletes duplicates in DB', () async {
      final species = await catalogRepo.getOrCreateSpecies('Billete', type: 'Objeto');

      final subCanonical = Subspecies(
        id: const Uuid().v4(),
        speciesId: species.id,
        subspeciesName: 'Pesos Mexicanos',
        createdAt: DateTime.now(),
      );
      await catalogRepo.saveSubspecies(subCanonical);

      final subDuplicate = Subspecies(
        id: const Uuid().v4(),
        speciesId: species.id,
        subspeciesName: 'MXN',
        createdAt: DateTime.now(),
      );
      await catalogRepo.saveSubspecies(subDuplicate);

      // Instantiate piece under duplicate subspecies
      final entityOnDup = await entityRepo.instantiateOrMerge(
        species.id,
        null,
        1.0,
        subspeciesId: subDuplicate.id,
      );

      expect(entityOnDup.subspeciesId, equals(subDuplicate.id));

      final allSubs = await catalogRepo.getAllSubspecies();
      final dupGroups = NumismaticDataHelper.findDuplicateSubspeciesGroups(allSubs);
      expect(dupGroups.length, equals(1));

      // Perform merge
      await NumismaticDataHelper.mergeDuplicateSubspecies(
        catalogRepo: catalogRepo,
        entityRepo: entityRepo,
        canonicalSubspecies: subCanonical,
        duplicateSubspeciesList: dupGroups.values.first,
      );

      // Verify duplicate subspecies is deleted
      final remainingSubs = await catalogRepo.getAllSubspecies();
      expect(remainingSubs.any((s) => s.id == subDuplicate.id), isFalse);

      // Verify entity was reassigned to canonical subspecies
      final movedEntity = await entityRepo.getEntityById(entityOnDup.id);
      expect(movedEntity!.subspeciesId, equals(subCanonical.id));
    });

    test('Repair attachment file names synchronizes attachment filename with updated instance derived title', () async {
      final species = await catalogRepo.getOrCreateSpecies('Moneda', type: 'Objeto');
      final sub = Subspecies(
        id: const Uuid().v4(),
        speciesId: species.id,
        subspeciesName: 'Pesos Mexicanos',
        createdAt: DateTime.now(),
      );
      await catalogRepo.saveSubspecies(sub);

      final instance = await entityRepo.instantiateOrMerge(species.id, null, 1.0, subspeciesId: sub.id);
      final updatedInstance = instance.copyWith(
        magnitudes: [
          InstanceMagnitude(
            id: const Uuid().v4(),
            instanceId: instance.id,
            propertyName: 'Valor nominal',
            dataType: 'real',
            magnitudeValue: 20.0,
          ),
          InstanceMagnitude(
            id: const Uuid().v4(),
            instanceId: instance.id,
            propertyName: 'Acuñación',
            dataType: 'integer',
            magnitudeValue: 2023.0,
            unitSymbol: 'año',
          ),
          InstanceMagnitude(
            id: const Uuid().v4(),
            instanceId: instance.id,
            propertyName: 'Divisa',
            dataType: 'string',
            stringValue: 'MXN',
          ),
          InstanceMagnitude(
            id: const Uuid().v4(),
            instanceId: instance.id,
            propertyName: 'Emisor',
            dataType: 'string',
            stringValue: 'México',
          ),
        ],
      );
      await entityRepo.saveEntity(updatedInstance);

      final oldFileName = 'Old Name (${instance.id}) (anverso).png';
      await catalogRepo.addAttachment(
        speciesId: species.id,
        instanceId: instance.id,
        filePath: '/tmp/old_anverso.png',
        fileName: oldFileName,
        fileType: 'image',
      );

      await NumismaticDataHelper.repairAttachmentFileNames(
        catalogRepo: catalogRepo,
        entityRepo: entityRepo,
        subspecies: sub,
        instance: updatedInstance,
      );

      final attachments = await entityRepo.getAttachmentsForInstance(instance.id);
      expect(attachments.length, equals(1));

      final expectedDisplayName = NumismaticDataHelper.buildInstanceDisplayName(
        NumismaticDataHelper.extractAttributesFromInstance(updatedInstance),
      );
      expect(expectedDisplayName, equals('20 Pesos Mexicanos - México (2023)'));

      final expectedFileName = NumismaticDataHelper.buildAttachmentFileName(
        subspeciesName: expectedDisplayName,
        instanceId: instance.id,
        side: 'anverso',
        extension: 'png',
      );
      expect(attachments.first.fileName, equals(expectedFileName));
    });

    test('Audit of empty data detects empty Grado and assigns standard grade value correctly', () async {
      final species = await catalogRepo.getOrCreateSpecies('Moneda', type: 'Objeto');
      final sub = Subspecies(
        id: const Uuid().v4(),
        speciesId: species.id,
        subspeciesName: '10 Pesos Mexicanos - México (2023)',
        createdAt: DateTime.now(),
      );
      await catalogRepo.saveSubspecies(sub);

      final instance = await entityRepo.instantiateOrMerge(species.id, null, 1.0, subspeciesId: sub.id);

      // Instance has empty grade
      final attrs = NumismaticDataHelper.extractAttributesFromInstance(instance);
      expect(attrs.grade, isNull);

      // Simulate assigning grade via emptyDataAudit fix action
      const chosenGrade = 'Sin circular (UNC)';
      final List<InstanceMagnitude> currentMags = List.from(instance.magnitudes);
      final existingGradeIdx = currentMags.indexWhere((m) => m.propertyName == 'Grado');
      if (existingGradeIdx >= 0) {
        currentMags[existingGradeIdx] = currentMags[existingGradeIdx].copyWith(
          dataType: 'string',
          stringValue: chosenGrade,
          unitSymbol: null,
          magnitudeValue: 0.0,
        );
      } else {
        currentMags.add(const InstanceMagnitude(
          id: 'test-grade-id',
          instanceId: 'test-inst',
          propertyName: 'Grado',
          dataType: 'string',
          stringValue: chosenGrade,
        ));
      }

      final updatedEntity = instance.copyWith(magnitudes: currentMags);
      await entityRepo.saveEntity(updatedEntity);

      final reloaded = await entityRepo.getEntityById(instance.id);
      final updatedAttrs = NumismaticDataHelper.extractAttributesFromInstance(reloaded!);
      expect(updatedAttrs.grade, equals('Sin circular (UNC)'));
    });

    test('Audit of remote images detects HTTP/HTTPS URLs on species and updates to local storage path', () async {
      // 1. Create species with remote image URL (mimicking Peluche / Refrigerador)
      final species = await catalogRepo.getOrCreateSpecies(
        'Refrigerador',
        type: 'Objeto',
        mainPhotoPath: 'http://c.shld.net/rpx/i/s/pi/mp/10139565/5357427829',
      );

      // Verify remote image is detected
      final isRemote = species.mainPhotoPath != null &&
          (species.mainPhotoPath!.startsWith('http://') || species.mainPhotoPath!.startsWith('https://'));
      expect(isRemote, isTrue);

      // Simulate fixing by saving local relative file
      const localRelativeFileName = 'refrigerador_downloaded_guid.jpg';
      final updatedSpecies = species.copyWith(mainPhotoPath: localRelativeFileName);
      await catalogRepo.saveCatalogItem(updatedSpecies);

      final reloadedSpecies = await catalogRepo.getCatalogItemById(species.id);
      expect(reloadedSpecies!.mainPhotoPath, equals(localRelativeFileName));
      expect(reloadedSpecies.mainPhotoPath!.startsWith('http'), isFalse);
    });
  });
}


