import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:platinum_world_management_system/src/core/database/app_database.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/catalog_item.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/species_magnitude.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/subspecies.dart';
import 'package:platinum_world_management_system/src/features/catalog/infrastructure/catalog_repository.dart';
import 'package:platinum_world_management_system/src/features/entities/domain/effective_entity_group.dart';
import 'package:platinum_world_management_system/src/features/entities/domain/entity_display_helper.dart';
import 'package:platinum_world_management_system/src/features/entities/domain/instance_magnitude.dart';
import 'package:platinum_world_management_system/src/features/entities/domain/world_entity.dart';
import 'package:platinum_world_management_system/src/features/entities/infrastructure/entity_repository.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import 'package:platinum_world_management_system/src/core/constants/app_technical_strings.dart';
import 'package:uuid/uuid.dart';

void main() {
  late AppDatabase db;
  late CatalogRepository catalogRepo;
  late EntityRepository entityRepo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    catalogRepo = CatalogRepository(db);
    entityRepo = EntityRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('EntityDisplayHelper Name Resolution Tests', () {
    final testSpecies = CatalogItem(
      id: 'sp_1',
      name: 'Laptop',
      type: AppStrings.typeObject,
      createdAt: DateTime.now(),
    );

    final testSubspecies = Subspecies(
      id: 'sub_1',
      speciesId: 'sp_1',
      subspeciesName: 'MacBook Pro',
      brand: 'Apple',
      createdAt: DateTime.now(),
    );

    test('returns custom instance name when property "Nombre" has non-empty stringValue', () {
      final entity = WorldEntity(
        id: 'ent_1',
        speciesId: 'sp_1',
        subspeciesId: 'sub_1',
        magnitudes: [
          const InstanceMagnitude(
            id: 'mag_1',
            instanceId: 'ent_1',
            propertyName: 'Nombre',
            dataType: 'string',
            stringValue: 'Laptop de Trabajo',
          ),
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final displayName = EntityDisplayHelper.getDisplayName(
        entity: entity,
        catalogItems: [testSpecies],
        subspeciesList: [testSubspecies],
      );

      expect(displayName, equals('Laptop de Trabajo'));
      expect(EntityDisplayHelper.getInstanceCustomName(entity), equals('Laptop de Trabajo'));
    });

    test('is case-insensitive for property name "nombre" and "name"', () {
      final entityLower = WorldEntity(
        id: 'ent_1',
        speciesId: 'sp_1',
        magnitudes: [
          const InstanceMagnitude(
            id: 'mag_1',
            instanceId: 'ent_1',
            propertyName: 'nombre',
            dataType: 'string',
            stringValue: 'Mi Computadora',
          ),
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final entityEnglish = WorldEntity(
        id: 'ent_2',
        speciesId: 'sp_1',
        magnitudes: [
          const InstanceMagnitude(
            id: 'mag_2',
            instanceId: 'ent_2',
            propertyName: 'Name',
            dataType: 'string',
            stringValue: 'My Computer',
          ),
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(
        EntityDisplayHelper.getDisplayName(entity: entityLower, catalogItems: [testSpecies]),
        equals('Mi Computadora'),
      );
      expect(
        EntityDisplayHelper.getDisplayName(entity: entityEnglish, catalogItems: [testSpecies]),
        equals('My Computer'),
      );
    });

    test('falls back to subspecies when stringValue is null or whitespace', () {
      final entityNull = WorldEntity(
        id: 'ent_null',
        speciesId: 'sp_1',
        subspeciesId: 'sub_1',
        magnitudes: [
          const InstanceMagnitude(
            id: 'mag_1',
            instanceId: 'ent_null',
            propertyName: 'Nombre',
            dataType: 'string',
            stringValue: null,
          ),
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final entityEmpty = WorldEntity(
        id: 'ent_empty',
        speciesId: 'sp_1',
        subspeciesId: 'sub_1',
        magnitudes: [
          const InstanceMagnitude(
            id: 'mag_2',
            instanceId: 'ent_empty',
            propertyName: 'Nombre',
            dataType: 'string',
            stringValue: '   ',
          ),
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(
        EntityDisplayHelper.getDisplayName(
          entity: entityNull,
          catalogItems: [testSpecies],
          subspeciesList: [testSubspecies],
        ),
        equals('Laptop - MacBook Pro (Apple)'),
      );

      expect(
        EntityDisplayHelper.getDisplayName(
          entity: entityEmpty,
          catalogItems: [testSpecies],
          subspeciesList: [testSubspecies],
        ),
        equals('Laptop - MacBook Pro (Apple)'),
      );
    });

    test('falls back to species name when no subspecies and stringValue is null', () {
      final entity = WorldEntity(
        id: 'ent_generic',
        speciesId: 'sp_1',
        magnitudes: [
          const InstanceMagnitude(
            id: 'mag_1',
            instanceId: 'ent_generic',
            propertyName: 'Nombre',
            dataType: 'string',
            stringValue: null,
          ),
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(
        EntityDisplayHelper.getDisplayName(
          entity: entity,
          catalogItems: [testSpecies],
        ),
        equals('Laptop'),
      );
    });
  });

  group('EffectiveEntityGroup Signature and Grouping Tests', () {
    test('distinct custom names prevent grouping into the same stack', () {
      final entityA = WorldEntity(
        id: 'ent_a',
        speciesId: 'sp_1',
        locationId: 'loc_1',
        magnitudes: [
          const InstanceMagnitude(
            id: 'mag_a',
            instanceId: 'ent_a',
            propertyName: 'Nombre',
            dataType: 'string',
            stringValue: 'Laptop Personal',
          ),
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final entityB = WorldEntity(
        id: 'ent_b',
        speciesId: 'sp_1',
        locationId: 'loc_1',
        magnitudes: [
          const InstanceMagnitude(
            id: 'mag_b',
            instanceId: 'ent_b',
            propertyName: 'Nombre',
            dataType: 'string',
            stringValue: 'Laptop Trabajo',
          ),
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final groups = EffectiveEntityGroup.groupEntities(
        entities: [entityA, entityB],
        effectiveLocationMap: {'ent_a': 'loc_1', 'ent_b': 'loc_1'},
      );

      expect(groups.length, equals(2));
      expect(groups[0].population, equals(1));
      expect(groups[1].population, equals(1));
    });

    test('identical or null names group homogeneously', () {
      final entity1 = WorldEntity(
        id: 'ent_1',
        speciesId: 'sp_1',
        locationId: 'loc_1',
        magnitudes: [
          const InstanceMagnitude(
            id: 'mag_1',
            instanceId: 'ent_1',
            propertyName: 'Nombre',
            dataType: 'string',
            stringValue: null,
          ),
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final entity2 = WorldEntity(
        id: 'ent_2',
        speciesId: 'sp_1',
        locationId: 'loc_1',
        magnitudes: [
          const InstanceMagnitude(
            id: 'mag_2',
            instanceId: 'ent_2',
            propertyName: 'Nombre',
            dataType: 'string',
            stringValue: null,
          ),
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final groups = EffectiveEntityGroup.groupEntities(
        entities: [entity1, entity2],
        effectiveLocationMap: {'ent_1': 'loc_1', 'ent_2': 'loc_1'},
      );

      expect(groups.length, equals(1));
      expect(groups.first.population, equals(2));
    });
  });

  group('Database & Repository Integration Tests for Instance Name Property', () {
    test('saves species with Nombre magnitude preset and instantiates with optional stringValue', () async {
      // 1. Create Species with preset 'Nombre'
      final species = CatalogItem(
        id: const Uuid().v4(),
        name: 'Instrumento Musical',
        type: AppStrings.typeObject,
        magnitudes: [
          SpeciesMagnitude(
            id: const Uuid().v4(),
            speciesId: '',
            propertyName: AppStrings.propertyNameNombre,
            dataType: AppTechnicalStrings.datatypeStringLower,
            unitSymbol: null,
            createdAt: DateTime.now(),
          ),
        ],
        createdAt: DateTime.now(),
      );

      final savedSpecies = await catalogRepo.saveCatalogItem(species);
      expect(savedSpecies.magnitudes.length, equals(1));
      expect(savedSpecies.magnitudes.first.propertyName, equals('Nombre'));
      expect(savedSpecies.magnitudes.first.dataType, equals('string'));

      // 2. Instantiate with custom name
      final createdEntities = await entityRepo.instantiateEntities(
        savedSpecies.id,
        null,
        1,
        customMagnitudes: [
          InstanceMagnitude(
            id: const Uuid().v4(),
            instanceId: '',
            propertyName: 'Nombre',
            dataType: 'string',
            stringValue: 'Guitarra Fender Stratocaster',
          ),
        ],
      );

      expect(createdEntities.length, equals(1));
      final created = createdEntities.first;

      final fetched = await entityRepo.getEntityById(created.id);
      expect(fetched, isNotNull);
      expect(fetched!.magnitudes.length, equals(1));
      expect(fetched.magnitudes.first.stringValue, equals('Guitarra Fender Stratocaster'));

      // 3. Verify Search by custom instance name
      final searchResults = await entityRepo.searchEntities('Fender Stratocaster');
      expect(searchResults.any((e) => e.id == created.id), isTrue);

      // 4. Instantiate with null (empty) custom name
      final createdWithoutName = await entityRepo.instantiateEntities(
        savedSpecies.id,
        null,
        1,
        customMagnitudes: [
          InstanceMagnitude(
            id: const Uuid().v4(),
            instanceId: '',
            propertyName: 'Nombre',
            dataType: 'string',
            stringValue: null,
          ),
        ],
      );

      final fetchedWithoutName = await entityRepo.getEntityById(createdWithoutName.first.id);
      expect(fetchedWithoutName, isNotNull);
      expect(fetchedWithoutName!.magnitudes.first.stringValue, isNull);
    });
  });
}
