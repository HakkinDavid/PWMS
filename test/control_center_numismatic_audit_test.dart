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

void main() {
  late AppDatabase db;
  late CatalogRepository catalogRepo;
  late EntityRepository entityRepo;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    db = AppDatabase(NativeDatabase.memory());
    catalogRepo = CatalogRepository(db);
    entityRepo = EntityRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('Control Center Numismatic Audit Integration Tests', () {
    test('Repair subspecies from instance updates subspecies name and notes in DB', () async {
      final species = await catalogRepo.getOrCreateSpecies(
        'Moneda',
        type: 'Objeto',
        description: 'Categoría numismática (Moneda)',
      );

      // Create subspecies with outdated year 2020
      final subspecies = Subspecies(
        id: const Uuid().v4(),
        speciesId: species.id,
        subspeciesName: '5 Pesos Mexicanos - México (2020)',
        notes: 'Moneda: Pesos Mexicanos | Año: 2020',
        createdAt: DateTime.now(),
      );
      await catalogRepo.saveSubspecies(subspecies);

      // Create instance with actual corrected year 2022 in magnitude
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
            stringValue: 'MXN',
          ),
        ],
      );
      await entityRepo.saveEntity(updatedInstance);

      // Verify incongruence detected
      final issueBefore = NumismaticDataHelper.checkInstanceSubspeciesCongruence(
        subspecies: subspecies,
        instance: updatedInstance,
      );
      expect(issueBefore, isNotNull);
      expect(issueBefore, contains('Año'));

      // Perform repair
      final repairedSub = await NumismaticDataHelper.repairSubspeciesFromInstance(
        catalogRepo: catalogRepo,
        entityRepo: entityRepo,
        subspecies: subspecies,
        instance: updatedInstance,
      );

      expect(repairedSub.subspeciesName, equals('5 Pesos Mexicanos - México (2022)'));
      expect(repairedSub.notes, contains('2022'));

      final issueAfter = NumismaticDataHelper.checkInstanceSubspeciesCongruence(
        subspecies: repairedSub,
        instance: updatedInstance,
      );
      expect(issueAfter, isNull);
    });

    test('Merge duplicate subspecies reassigns instances and deletes duplicates in DB', () async {
      final species = await catalogRepo.getOrCreateSpecies('Billete', type: 'Objeto');

      final subCanonical = Subspecies(
        id: const Uuid().v4(),
        speciesId: species.id,
        subspeciesName: '100 Pesos Sor Juana - México (2021)',
        createdAt: DateTime.now(),
      );
      await catalogRepo.saveSubspecies(subCanonical);

      final subDuplicate = Subspecies(
        id: const Uuid().v4(),
        speciesId: species.id,
        subspeciesName: '100 Pesos Sor Juana - México (2021)',
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

    test('Repair attachment file names synchronizes attachment filename with updated subspecies name', () async {
      final species = await catalogRepo.getOrCreateSpecies('Moneda', type: 'Objeto');
      final sub = Subspecies(
        id: const Uuid().v4(),
        speciesId: species.id,
        subspeciesName: '20 Pesos Conmemorativa - México (2023)',
        createdAt: DateTime.now(),
      );
      await catalogRepo.saveSubspecies(sub);

      final instance = await entityRepo.instantiateOrMerge(species.id, null, 1.0, subspeciesId: sub.id);

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
        instance: instance,
      );

      final attachments = await entityRepo.getAttachmentsForInstance(instance.id);
      expect(attachments.length, equals(1));

      final expectedFileName = NumismaticDataHelper.buildAttachmentFileName(
        subspeciesName: sub.subspeciesName,
        instanceId: instance.id,
        side: 'anverso',
        extension: 'png',
      );
      expect(attachments.first.fileName, equals(expectedFileName));
    });
  });
}
