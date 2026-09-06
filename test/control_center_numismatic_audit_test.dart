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
import 'package:platinum_world_management_system/src/features/control_center/domain/audit_rule_strategy.dart';
import 'package:platinum_world_management_system/src/features/control_center/domain/strategies/numismatic_audit_rules.dart';

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

    test('NumismaticEmissionOutlierStrategy detects currency anachronism and repairs to canonical epoch currency', () async {
      final species = await catalogRepo.getOrCreateSpecies('Moneda', type: 'Objeto');
      final sub = Subspecies(
        id: const Uuid().v4(),
        speciesId: species.id,
        subspeciesName: 'Pesos Mexicanos Antiguos',
        createdAt: DateTime.now(),
      );
      await catalogRepo.saveSubspecies(sub);

      // Create piece with anachronistic currency: Mexico 1982 coin registered as MXN (Nuevos Pesos) instead of MXP
      final instance = await entityRepo.instantiateOrMerge(species.id, null, 1.0, subspeciesId: sub.id);
      final updatedInstance = instance.copyWith(
        magnitudes: [
          InstanceMagnitude(
            id: const Uuid().v4(),
            instanceId: instance.id,
            propertyName: 'Valor nominal',
            dataType: 'real',
            magnitudeValue: 50.0,
          ),
          InstanceMagnitude(
            id: const Uuid().v4(),
            instanceId: instance.id,
            propertyName: 'Acuñación',
            dataType: 'integer',
            magnitudeValue: 1982.0,
            unitSymbol: 'año',
          ),
          InstanceMagnitude(
            id: const Uuid().v4(),
            instanceId: instance.id,
            propertyName: 'Divisa',
            dataType: 'string',
            stringValue: 'MXN', // Anachronism!
          ),
          InstanceMagnitude(
            id: const Uuid().v4(),
            instanceId: instance.id,
            propertyName: 'Emisor',
            dataType: 'string',
            stringValue: 'México',
          ),
          InstanceMagnitude(
            id: const Uuid().v4(),
            instanceId: instance.id,
            propertyName: 'Material',
            dataType: 'string',
            stringValue: 'Cuproníquel',
          ),
        ],
      );
      await entityRepo.saveEntity(updatedInstance);

      final evalContext = AuditEvaluationContext(
        db: db,
        allEntities: await entityRepo.getAllEntities(),
        allCatalog: await catalogRepo.getAllCatalogItems(),
        allSubspecies: await catalogRepo.getAllSubspecies(),
        allRelations: const [],
        allLocations: const [],
        allSpeciesMagnitudes: const [],
        allInstanceMagnitudes: const [],
        allRequirements: const [],
        effectiveLocationMap: const {},
      );

      const strategy = NumismaticEmissionOutlierStrategy();
      final cards = await strategy.evaluate(evalContext);

      expect(cards.length, equals(1));
      expect(cards.first.type, equals(AuditCardType.numismaticEmissionOutlier));
      expect(cards.first.subtitle, contains('MXN'));
      expect(cards.first.subtitle, contains('MXP'));

      // Test pure domain detection
      final outliers = NumismaticDataHelper.checkEmissionOutliers(instance: updatedInstance, species: species);
      expect(outliers.length, equals(1));
      expect(outliers.first.type, equals(NumismaticEmissionOutlierType.currencyAnachronism));
      expect(outliers.first.expectedValue, equals('MXP'));

      // Test repair
      final repairedEntity = await NumismaticDataHelper.repairEmissionOutlier(
        entityRepo: entityRepo,
        catalogRepo: catalogRepo,
        instance: updatedInstance,
        outlier: outliers.first,
      );

      final reloadedMag = repairedEntity.magnitudes.firstWhere((m) => m.propertyName == 'Divisa');
      expect(reloadedMag.stringValue, equals('MXP'));

      // Re-evaluating context should now yield 0 outlier cards
      final evalContextAfter = AuditEvaluationContext(
        db: db,
        allEntities: await entityRepo.getAllEntities(),
        allCatalog: await catalogRepo.getAllCatalogItems(),
        allSubspecies: await catalogRepo.getAllSubspecies(),
        allRelations: const [],
        allLocations: const [],
        allSpeciesMagnitudes: const [],
        allInstanceMagnitudes: const [],
        allRequirements: const [],
        effectiveLocationMap: const {},
      );
      final cardsAfter = await strategy.evaluate(evalContextAfter);
      expect(cardsAfter.isEmpty, isTrue);
    });

    test('NumismaticEmissionOutlierStrategy detects material contradiction and repairs to canonical material', () async {
      final species = await catalogRepo.getOrCreateSpecies('Moneda', type: 'Objeto');
      final sub = Subspecies(
        id: const Uuid().v4(),
        speciesId: species.id,
        subspeciesName: 'Pesos Mexicanos Antiguos',
        createdAt: DateTime.now(),
      );
      await catalogRepo.saveSubspecies(sub);

      // Create piece with contradictory material: Mexico 1982 50 Pesos coin with 'Oro' instead of 'Cuproníquel'
      final instance = await entityRepo.instantiateOrMerge(species.id, null, 1.0, subspeciesId: sub.id);
      final updatedInstance = instance.copyWith(
        magnitudes: [
          InstanceMagnitude(
            id: const Uuid().v4(),
            instanceId: instance.id,
            propertyName: 'Valor nominal',
            dataType: 'real',
            magnitudeValue: 50.0,
          ),
          InstanceMagnitude(
            id: const Uuid().v4(),
            instanceId: instance.id,
            propertyName: 'Acuñación',
            dataType: 'integer',
            magnitudeValue: 1982.0,
            unitSymbol: 'año',
          ),
          InstanceMagnitude(
            id: const Uuid().v4(),
            instanceId: instance.id,
            propertyName: 'Divisa',
            dataType: 'string',
            stringValue: 'MXP',
          ),
          InstanceMagnitude(
            id: const Uuid().v4(),
            instanceId: instance.id,
            propertyName: 'Emisor',
            dataType: 'string',
            stringValue: 'México',
          ),
          InstanceMagnitude(
            id: const Uuid().v4(),
            instanceId: instance.id,
            propertyName: 'Material',
            dataType: 'string',
            stringValue: 'Oro', // Contradiction! 1982 50 Pesos Coyolxauhqui is Cuproníquel
          ),
        ],
      );
      await entityRepo.saveEntity(updatedInstance);

      final outliers = NumismaticDataHelper.checkEmissionOutliers(instance: updatedInstance, species: species);
      expect(outliers.length, equals(1));
      expect(outliers.first.type, equals(NumismaticEmissionOutlierType.materialContradiction));
      expect(outliers.first.expectedValue, equals('Cuproníquel'));

      final repairedEntity = await NumismaticDataHelper.repairEmissionOutlier(
        entityRepo: entityRepo,
        catalogRepo: catalogRepo,
        instance: updatedInstance,
        outlier: outliers.first,
      );

      final reloadedMat = repairedEntity.magnitudes.firstWhere((m) => m.propertyName == 'Material');
      expect(reloadedMat.stringValue, equals('Cuproníquel'));
    });

    test('NumismaticEmissionOutlierStrategy detects missing commemorative special edition for 2008 Mexico and repairs it', () async {
      final species = await catalogRepo.getOrCreateSpecies('Moneda', type: 'Objeto');
      final sub = Subspecies(
        id: const Uuid().v4(),
        speciesId: species.id,
        subspeciesName: '5 Pesos Bicentenario',
        createdAt: DateTime.now(),
      );
      await catalogRepo.saveSubspecies(sub);

      // Create Mexico 2008 5 Pesos coin without special edition flag
      final instance = await entityRepo.instantiateOrMerge(species.id, null, 1.0, subspeciesId: sub.id);
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
            magnitudeValue: 2008.0,
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
          InstanceMagnitude(
            id: const Uuid().v4(),
            instanceId: instance.id,
            propertyName: 'Material',
            dataType: 'string',
            stringValue: 'Bimetálica',
          ),
        ],
      );
      await entityRepo.saveEntity(updatedInstance);

      final outliers = NumismaticDataHelper.checkEmissionOutliers(instance: updatedInstance, species: species);
      expect(outliers.length, equals(1));
      expect(outliers.first.type, equals(NumismaticEmissionOutlierType.specialEditionMismatch));
      expect(outliers.first.expectedValue, equals('Conmemorativa'));

      final repairedEntity = await NumismaticDataHelper.repairEmissionOutlier(
        entityRepo: entityRepo,
        catalogRepo: catalogRepo,
        instance: updatedInstance,
        outlier: outliers.first,
      );

      final reloadedSpecial = repairedEntity.magnitudes.firstWhere((m) => m.propertyName == 'Edición especial');
      expect(reloadedSpecial.stringValue, equals('true'));

      final reloadedReason = repairedEntity.magnitudes.firstWhere((m) => m.propertyName == 'Razón de edición especial');
      expect(reloadedReason.stringValue, equals('Conmemorativa'));
    });

    test('repairAndStandardizeImportedData groups singular and plural pieces into single canonical subspecies', () async {
      final species = await catalogRepo.getOrCreateSpecies('Moneda', type: 'Objeto');

      // Create two legacy subspecies: 1 Franco Francés (singular) and 5 Francos Franceses (plural)
      final sub1 = Subspecies(
        id: const Uuid().v4(),
        speciesId: species.id,
        subspeciesName: '1 Franco Francés - Francia (1960)',
        notes: 'Moneda: Franco Francés | Año: 1960',
        createdAt: DateTime.now(),
      );
      await catalogRepo.saveSubspecies(sub1);

      final sub5 = Subspecies(
        id: const Uuid().v4(),
        speciesId: species.id,
        subspeciesName: '5 Francos Franceses - Francia (1960)',
        notes: 'Moneda: Francos Franceses | Año: 1960',
        createdAt: DateTime.now(),
      );
      await catalogRepo.saveSubspecies(sub5);

      final inst1 = await entityRepo.instantiateOrMerge(species.id, null, 1.0, subspeciesId: sub1.id);
      final inst5 = await entityRepo.instantiateOrMerge(species.id, null, 1.0, subspeciesId: sub5.id);

      // Run bulk repair and standardize
      await NumismaticDataHelper.repairAndStandardizeImportedData(db);

      // Verify that there is ONLY ONE subspecies in total for FRF, named 'Francos Franceses'
      final allSubs = await catalogRepo.getSubspeciesForSpecies(species.id);
      expect(allSubs.length, equals(1));
      expect(allSubs.first.subspeciesName, equals('Francos Franceses'));

      // Verify instances are assigned to the single canonical subspecies and have Divisa FRF
      final reloadedInst1 = await entityRepo.getEntityById(inst1.id);
      final reloadedInst5 = await entityRepo.getEntityById(inst5.id);

      expect(reloadedInst1!.subspeciesId, equals(allSubs.first.id));
      expect(reloadedInst5!.subspeciesId, equals(allSubs.first.id));

      final divisa1 = reloadedInst1.magnitudes.firstWhere((m) => m.propertyName == 'Divisa');
      expect(divisa1.stringValue, equals('FRF'));

      final divisa5 = reloadedInst5.magnitudes.firstWhere((m) => m.propertyName == 'Divisa');
      expect(divisa5.stringValue, equals('FRF'));

      // Verify NO incongruence in CCC
      final issue1 = NumismaticDataHelper.checkInstanceSubspeciesCongruence(
        subspecies: allSubs.first,
        instance: reloadedInst1,
      );
      expect(issue1, isNull);

      final issue5 = NumismaticDataHelper.checkInstanceSubspeciesCongruence(
        subspecies: allSubs.first,
        instance: reloadedInst5,
      );
      expect(issue5, isNull);
    });

    test('checkEmissionOutliers accepts both Cuproníquel and Acero inoxidable for Mexico 1988 50 MXP coin', () async {
      final species = await catalogRepo.getOrCreateSpecies('Moneda', type: 'Objeto');

      // Cuproníquel instance
      final instCuNi = WorldEntity(
        id: 'inst-1988-cuni',
        speciesId: species.id,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        magnitudes: const [
          InstanceMagnitude(id: 'm1', instanceId: 'inst-1988-cuni', propertyName: 'País', dataType: 'string', stringValue: 'México'),
          InstanceMagnitude(id: 'm2', instanceId: 'inst-1988-cuni', propertyName: 'Acuñación', dataType: 'integer', magnitudeValue: 1988.0, unitSymbol: 'año'),
          InstanceMagnitude(id: 'm3', instanceId: 'inst-1988-cuni', propertyName: 'Divisa', dataType: 'string', stringValue: 'MXP'),
          InstanceMagnitude(id: 'm4', instanceId: 'inst-1988-cuni', propertyName: 'Valor nominal', dataType: 'real', magnitudeValue: 50.0),
          InstanceMagnitude(id: 'm5', instanceId: 'inst-1988-cuni', propertyName: 'Material', dataType: 'string', stringValue: 'Cuproníquel'),
        ],
      );
      expect(NumismaticDataHelper.checkEmissionOutliers(instance: instCuNi, species: species), isEmpty);

      // Acero inoxidable instance
      final instAcero = WorldEntity(
        id: 'inst-1988-acero',
        speciesId: species.id,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        magnitudes: const [
          InstanceMagnitude(id: 'm1', instanceId: 'inst-1988-acero', propertyName: 'País', dataType: 'string', stringValue: 'México'),
          InstanceMagnitude(id: 'm2', instanceId: 'inst-1988-acero', propertyName: 'Acuñación', dataType: 'integer', magnitudeValue: 1988.0, unitSymbol: 'año'),
          InstanceMagnitude(id: 'm3', instanceId: 'inst-1988-acero', propertyName: 'Divisa', dataType: 'string', stringValue: 'MXP'),
          InstanceMagnitude(id: 'm4', instanceId: 'inst-1988-acero', propertyName: 'Valor nominal', dataType: 'real', magnitudeValue: 50.0),
          InstanceMagnitude(id: 'm5', instanceId: 'inst-1988-acero', propertyName: 'Material', dataType: 'string', stringValue: 'Acero inoxidable'),
        ],
      );
      expect(NumismaticDataHelper.checkEmissionOutliers(instance: instAcero, species: species), isEmpty);
    });

    test('checkEmissionOutliers accepts both Papel de algodón and Polímero for Mexico 2019 100 MXN banknote', () async {
      final species = await catalogRepo.getOrCreateSpecies('Billete', type: 'Objeto');

      // 2019 Papel de algodón (Familia F - Nezahualcóyotl)
      final instAlgodon = WorldEntity(
        id: 'inst-2019-algodon',
        speciesId: species.id,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        magnitudes: const [
          InstanceMagnitude(id: 'm1', instanceId: 'inst-2019-algodon', propertyName: 'País', dataType: 'string', stringValue: 'México'),
          InstanceMagnitude(id: 'm2', instanceId: 'inst-2019-algodon', propertyName: 'Acuñación', dataType: 'integer', magnitudeValue: 2019.0, unitSymbol: 'año'),
          InstanceMagnitude(id: 'm3', instanceId: 'inst-2019-algodon', propertyName: 'Divisa', dataType: 'string', stringValue: 'MXN'),
          InstanceMagnitude(id: 'm4', instanceId: 'inst-2019-algodon', propertyName: 'Valor nominal', dataType: 'real', magnitudeValue: 100.0),
          InstanceMagnitude(id: 'm5', instanceId: 'inst-2019-algodon', propertyName: 'Material', dataType: 'string', stringValue: 'Papel de algodón'),
        ],
      );
      expect(NumismaticDataHelper.checkEmissionOutliers(instance: instAlgodon, species: species), isEmpty);

      // 2019 Polímero (Familia G - Sor Juana)
      final instPolimero = WorldEntity(
        id: 'inst-2019-polimero',
        speciesId: species.id,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        magnitudes: const [
          InstanceMagnitude(id: 'm1', instanceId: 'inst-2019-polimero', propertyName: 'País', dataType: 'string', stringValue: 'México'),
          InstanceMagnitude(id: 'm2', instanceId: 'inst-2019-polimero', propertyName: 'Acuñación', dataType: 'integer', magnitudeValue: 2019.0, unitSymbol: 'año'),
          InstanceMagnitude(id: 'm3', instanceId: 'inst-2019-polimero', propertyName: 'Divisa', dataType: 'string', stringValue: 'MXN'),
          InstanceMagnitude(id: 'm4', instanceId: 'inst-2019-polimero', propertyName: 'Valor nominal', dataType: 'real', magnitudeValue: 100.0),
          InstanceMagnitude(id: 'm5', instanceId: 'inst-2019-polimero', propertyName: 'Material', dataType: 'string', stringValue: 'Polímero'),
        ],
      );
      expect(NumismaticDataHelper.checkEmissionOutliers(instance: instPolimero, species: species), isEmpty);
    });

    test('Motivo magnitude is repaired and persisted directly without touching instance notes', () async {
      final species = await catalogRepo.getOrCreateSpecies('Moneda', type: 'Objeto');
      final sub = Subspecies(
        id: const Uuid().v4(),
        speciesId: species.id,
        subspeciesName: '200 Pesos Conmemorativa',
        createdAt: DateTime.now(),
      );
      await catalogRepo.saveSubspecies(sub);

      final instance = await entityRepo.instantiateOrMerge(species.id, null, 1.0, subspeciesId: sub.id);
      final updatedInstance = instance.copyWith(
        notes: 'Original user note',
        magnitudes: [
          InstanceMagnitude(
            id: const Uuid().v4(),
            instanceId: instance.id,
            propertyName: 'Valor nominal',
            dataType: 'real',
            magnitudeValue: 200.0,
          ),
          InstanceMagnitude(
            id: const Uuid().v4(),
            instanceId: instance.id,
            propertyName: 'Acuñación',
            dataType: 'integer',
            magnitudeValue: 1985.0,
            unitSymbol: 'año',
          ),
          InstanceMagnitude(
            id: const Uuid().v4(),
            instanceId: instance.id,
            propertyName: 'Divisa',
            dataType: 'string',
            stringValue: 'MXP',
          ),
          InstanceMagnitude(
            id: const Uuid().v4(),
            instanceId: instance.id,
            propertyName: 'Emisor',
            dataType: 'string',
            stringValue: 'México',
          ),
          InstanceMagnitude(
            id: const Uuid().v4(),
            instanceId: instance.id,
            propertyName: 'Material',
            dataType: 'string',
            stringValue: 'Cuproníquel',
          ),
          InstanceMagnitude(
            id: const Uuid().v4(),
            instanceId: instance.id,
            propertyName: 'Edición especial',
            dataType: 'boolean',
            stringValue: 'true',
          ),
          InstanceMagnitude(
            id: const Uuid().v4(),
            instanceId: instance.id,
            propertyName: 'Motivo',
            dataType: 'string',
            stringValue: 'Motivo Inexistente 123',
          ),
        ],
      );
      await entityRepo.saveEntity(updatedInstance);

      final outliers = NumismaticDataHelper.checkEmissionOutliers(instance: updatedInstance, species: species);
      expect(outliers.length, equals(1));
      expect(outliers.first.type, equals(NumismaticEmissionOutlierType.motifContradiction));

      // Repair with canonical motif
      final repairedEntity = await NumismaticDataHelper.repairEmissionOutlier(
        entityRepo: entityRepo,
        catalogRepo: catalogRepo,
        instance: updatedInstance,
        outlier: outliers.first,
        replacementValue: '175 Aniversario de la Independencia',
      );

      final reloadedMotif = repairedEntity.magnitudes.firstWhere((m) => m.propertyName == 'Motivo');
      expect(reloadedMotif.stringValue, equals('175 Aniversario de la Independencia'));

      // User notes must remain untouched
      expect(repairedEntity.notes, equals('Original user note'));
    });
  });
}


