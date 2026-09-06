import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/native.dart';
import 'package:uuid/uuid.dart';
import 'package:platinum_world_management_system/src/core/database/app_database.dart';
import 'package:platinum_world_management_system/src/core/providers/providers.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/subspecies.dart';
import 'package:platinum_world_management_system/src/features/catalog/infrastructure/catalog_repository.dart';
import 'package:platinum_world_management_system/src/features/entities/domain/entity_photo_helper.dart';
import 'package:platinum_world_management_system/src/features/entities/domain/instance_magnitude.dart';
import 'package:platinum_world_management_system/src/features/entities/infrastructure/entity_repository.dart';

void main() {
  late AppDatabase db;
  late CatalogRepository catalogRepo;
  late EntityRepository entityRepo;
  late ProviderContainer container;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    db = AppDatabase(NativeDatabase.memory());
    catalogRepo = CatalogRepository(db);
    entityRepo = EntityRepository(db);

    container = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(db),
        catalogRepositoryProvider.overrideWithValue(catalogRepo),
        entityRepositoryProvider.overrideWithValue(entityRepo),
      ],
    );
  });

  tearDown(() async {
    container.dispose();
    await db.close();
  });

  group('Numismatic Registration & Attachment Fallback Tests', () {
    test('Numismatic species and subspecies are created without photo paths', () async {
      final species = await catalogRepo.getOrCreateSpecies(
        'Moneda',
        type: 'Objeto',
        description: 'Categoría numismática (Moneda)',
        mainPhotoPath: null,
      );

      expect(species.mainPhotoPath, isNull);

      final subspecies = Subspecies(
        id: const Uuid().v4(),
        speciesId: species.id,
        subspeciesName: '5 Pesos Mexicanos - México (2022)',
        photoPath: null,
        createdAt: DateTime.now(),
      );
      await catalogRepo.saveSubspecies(subspecies);

      final savedSubspecies = await catalogRepo.getSubspeciesById(subspecies.id);
      expect(savedSubspecies, isNotNull);
      expect(savedSubspecies!.photoPath, isNull);
    });

    test('Attachments are saved per instance with (anverso) and (reverso) names', () async {
      final species = await catalogRepo.getOrCreateSpecies('Moneda', type: 'Objeto', mainPhotoPath: null);
      final subspecies = Subspecies(
        id: const Uuid().v4(),
        speciesId: species.id,
        subspeciesName: '10 Pesos Mexicanos',
        photoPath: null,
        createdAt: DateTime.now(),
      );
      await catalogRepo.saveSubspecies(subspecies);

      final instance = await entityRepo.instantiateOrMerge(species.id, null, 1.0, subspeciesId: subspecies.id);

      final obverseFileName = '10 Pesos Mexicanos (${instance.id}) (anverso).jpg';
      final reverseFileName = '10 Pesos Mexicanos (${instance.id}) (reverso).jpg';

      await catalogRepo.addAttachment(
        speciesId: species.id,
        instanceId: instance.id,
        filePath: '/tmp/obverse.jpg',
        fileName: obverseFileName,
        fileType: 'image',
      );

      await catalogRepo.addAttachment(
        speciesId: species.id,
        instanceId: instance.id,
        filePath: '/tmp/reverse.jpg',
        fileName: reverseFileName,
        fileType: 'image',
      );

      final instanceAttachments = await entityRepo.getAttachmentsForInstance(instance.id);
      expect(instanceAttachments.length, equals(2));
      expect(instanceAttachments.any((a) => a.fileName == obverseFileName && a.instanceId == instance.id), isTrue);
      expect(instanceAttachments.any((a) => a.fileName == reverseFileName && a.instanceId == instance.id), isTrue);
    });

    test('resolveEffectiveEntityPhotoPath takes precedence: 1. Instance attachment, 2. Subspecies, 3. Species', () async {
      final species = await catalogRepo.getOrCreateSpecies('Billete', type: 'Objeto', mainPhotoPath: '/storage/photos/species_photo.jpg');
      final subspecies = Subspecies(
        id: const Uuid().v4(),
        speciesId: species.id,
        subspeciesName: '100 Pesos Sor Juana',
        photoPath: '/storage/photos/subspecies_photo.jpg',
        createdAt: DateTime.now(),
      );
      await catalogRepo.saveSubspecies(subspecies);

      final instance = await entityRepo.instantiateOrMerge(species.id, null, 1.0, subspeciesId: subspecies.id);

      // Without instance attachment, subspecies photo takes precedence over species
      final resolvedSubspecies = await resolveEffectiveEntityPhotoPathWithRepo(
        entityRepo,
        subspecies: subspecies,
        species: species,
        instanceId: instance.id,
      );
      expect(resolvedSubspecies, equals('/storage/photos/subspecies_photo.jpg'));

      // With instance attachment, instance attachment takes precedence over both subspecies and species
      await catalogRepo.addAttachment(
        speciesId: species.id,
        instanceId: instance.id,
        filePath: '/storage/photos/instance_photo.jpg',
        fileName: 'instance_photo.jpg',
        fileType: 'image',
      );

      final resolvedInstance = await resolveEffectiveEntityPhotoPathWithRepo(
        entityRepo,
        subspecies: subspecies,
        species: species,
        instanceId: instance.id,
      );
      expect(resolvedInstance, equals('/storage/photos/instance_photo.jpg'));
    });

    test('Numismatic entity creation sets Motivo to null when no motif applies', () async {
      final species = await catalogRepo.getOrCreateSpecies('Moneda', type: 'Objeto');
      await catalogRepo.addSpeciesMagnitude(species.id, 'Valor nominal', dataType: 'real');
      await catalogRepo.addSpeciesMagnitude(species.id, 'Acuñación', dataType: 'integer', unitSymbol: 'año');
      await catalogRepo.addSpeciesMagnitude(species.id, 'Divisa', dataType: 'string');
      await catalogRepo.addSpeciesMagnitude(species.id, 'Material', dataType: 'string');
      await catalogRepo.addSpeciesMagnitude(species.id, 'Grado', dataType: 'string');
      await catalogRepo.addSpeciesMagnitude(species.id, 'Emisor', dataType: 'string');
      await catalogRepo.addSpeciesMagnitude(species.id, 'Motivo', dataType: 'string');

      final subspecies = Subspecies(
        id: const Uuid().v4(),
        speciesId: species.id,
        subspeciesName: 'Pesos Mexicanos',
        createdAt: DateTime.now(),
      );
      await catalogRepo.saveSubspecies(subspecies);

      final instance = await entityRepo.instantiateOrMerge(species.id, null, 1.0, subspeciesId: subspecies.id);

      final freshSpecies = await catalogRepo.getCatalogItemById(species.id);
      expect(freshSpecies, isNotNull);

      // Simulate registration logic mapping from NumismaticScanResult (when motif is null)
      final List<InstanceMagnitude> customInstanceMags = [];
      for (final sm in freshSpecies!.magnitudes) {
        String? strVal;
        if (sm.propertyName == 'Divisa') {
          strVal = 'MXN';
        } else if (sm.propertyName == 'Motivo') {
          strVal = null; // None applies
        }

        customInstanceMags.add(InstanceMagnitude(
          id: const Uuid().v4(),
          instanceId: instance.id,
          propertyName: sm.propertyName,
          dataType: sm.dataType,
          stringValue: strVal,
        ));
      }

      final updatedInstance = instance.copyWith(magnitudes: customInstanceMags);
      await entityRepo.saveEntity(updatedInstance);

      final reloaded = await entityRepo.getEntityById(instance.id);
      expect(reloaded, isNotNull);

      final motifMag = reloaded!.magnitudes.firstWhere((m) => m.propertyName == 'Motivo');
      expect(motifMag.stringValue, isNull);
      expect(motifMag.dataType, equals('string'));

      final hasSpecial = reloaded.magnitudes.any((m) => m.propertyName == 'Edición especial');
      expect(hasSpecial, isFalse);
    });
  });
}
