import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:platinum_world_management_system/src/core/constants/app_technical_strings.dart';
import 'package:platinum_world_management_system/src/core/database/app_database.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/species_magnitude.dart';
import 'package:platinum_world_management_system/src/features/catalog/infrastructure/catalog_repository.dart';
import 'package:platinum_world_management_system/src/features/entities/domain/effective_entity_group.dart';
import 'package:platinum_world_management_system/src/features/entities/domain/instance_magnitude.dart';
import 'package:platinum_world_management_system/src/features/entities/infrastructure/entity_repository.dart';
import 'package:platinum_world_management_system/src/features/locations/domain/location_node.dart';
import 'package:platinum_world_management_system/src/features/locations/infrastructure/location_repository.dart';
import 'package:platinum_world_management_system/src/features/relations/domain/entity_relation.dart';
import 'package:platinum_world_management_system/src/features/relations/infrastructure/relation_repository.dart';
import 'package:uuid/uuid.dart';

void main() {
  late AppDatabase db;
  late EntityRepository entityRepo;
  late CatalogRepository catalogRepo;
  late LocationRepository locationRepo;
  late RelationRepository relationRepo;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    db = AppDatabase(NativeDatabase.memory());
    entityRepo = EntityRepository(db);
    catalogRepo = CatalogRepository(db);
    locationRepo = LocationRepository(db);
    relationRepo = RelationRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('Batch Instantiation, Relationships and Location Integrity Tests', () {
    test('1. Batch Instantiating N entities in a Container entity: all N receive GUARDADO_EN relation and effective location', () async {
      // 1. Setup physical location node
      final locNode = LocationNode(id: 'loc-drawer-1', name: 'Gaveta 1', createdAt: DateTime.now());
      await locationRepo.saveNode(locNode);

      // 2. Setup Container entity (e.g. Organizer Box in Gaveta 1)
      final boxSpecies = await catalogRepo.getOrCreateSpecies('Caja Organizadora', type: 'Objeto');
      final boxEntity = await entityRepo.instantiateOrMerge(boxSpecies.id, locNode.id, 1);
      expect(boxEntity.locationId, equals('loc-drawer-1'));

      // 3. Setup Species to batch instantiate (e.g. 5 Resistencias 10k)
      final resistorSpecies = await catalogRepo.getOrCreateSpecies('Resistencia 10k', type: 'Objeto');

      // 4. Batch instantiate 5 units with targetPhysicalLoc = null (Container Mode)
      final createdInstances = await entityRepo.instantiateEntities(
        resistorSpecies.id,
        null,
        5,
        notes: 'Lote 2026-A',
      );

      expect(createdInstances.length, equals(5));

      // 5. Create GUARDADO_EN relation for each of the 5 instances
      for (final inst in createdInstances) {
        final rel = EntityRelation(
          id: const Uuid().v4(),
          sourceEntityId: inst.id,
          targetEntityId: boxEntity.id,
          relationType: AppTechnicalStrings.relGuardadoEn,
          createdAt: DateTime.now(),
        );
        await relationRepo.addRelation(rel);
      }

      // 6. Verify relations table: all 5 entities must have the GUARDADO_EN relation
      final allRels = await relationRepo.getAllRelations();
      final containedRels = allRels.where((r) => r.targetEntityId == boxEntity.id && r.relationType == AppTechnicalStrings.relGuardadoEn).toList();
      expect(containedRels.length, equals(5));

      final containedSourceIds = containedRels.map((r) => r.sourceEntityId).toSet();
      for (final inst in createdInstances) {
        expect(containedSourceIds.contains(inst.id), isTrue, reason: 'Instance ${inst.id} must be related to the container');
      }

      // 7. Verify all 5 entities resolve effective location from Container Box ('loc-drawer-1')
      final allEntities = await entityRepo.getAllEntities();
      final resistorEntities = allEntities.where((e) => e.speciesId == resistorSpecies.id).toList();
      expect(resistorEntities.length, equals(5));

      for (final ent in resistorEntities) {
        expect(ent.locationId, equals('loc-drawer-1'), reason: 'Instance ${ent.id} must resolve effective location from container');
      }
    });

    test('2. Batch Instantiating N entities with magnitudes & expiration: all N get individual magnitudes and expiration date without multiplication', () async {
      final locNode = LocationNode(id: 'loc-pantry', name: 'Despensa', createdAt: DateTime.now());
      await locationRepo.saveNode(locNode);

      // Create Perishable species with magnitudes
      final milkSpecies = await catalogRepo.getOrCreateSpecies('Leche Entera 1L', type: 'Objeto');
      final updatedMilkSpecies = milkSpecies.copyWith(
        isNonPerishable: false,
        magnitudes: [
          SpeciesMagnitude(
            id: 'mag-vol',
            speciesId: milkSpecies.id,
            propertyName: 'Volumen',
            dataType: 'real',
            unitSymbol: 'L',
            createdAt: DateTime.now(),
          ),
          SpeciesMagnitude(
            id: 'mag-fat',
            speciesId: milkSpecies.id,
            propertyName: 'Grasa',
            dataType: 'string',
            createdAt: DateTime.now(),
          ),
        ],
      );
      await catalogRepo.saveCatalogItem(updatedMilkSpecies);

      final expDate = DateTime(2026, 9, 15, 12, 0, 0);
      final customMags = [
        const InstanceMagnitude(
          id: '',
          instanceId: '',
          propertyName: 'Volumen',
          dataType: 'real',
          magnitudeValue: 1.0,
          unitSymbol: 'L',
        ),
        const InstanceMagnitude(
          id: '',
          instanceId: '',
          propertyName: 'Grasa',
          dataType: 'string',
          stringValue: '3.5%',
        ),
      ];

      // Instantiate 4 bottles of milk
      final createdMilks = await entityRepo.instantiateEntities(
        milkSpecies.id,
        locNode.id,
        4,
        customMagnitudes: customMags,
        expirationDate: expDate,
      );

      expect(createdMilks.length, equals(4));

      final allEntities = await entityRepo.getAllEntities();
      final milkEntities = allEntities.where((e) => e.speciesId == milkSpecies.id).toList();
      expect(milkEntities.length, equals(4));

      for (final milk in milkEntities) {
        expect(milk.locationId, equals('loc-pantry'));
        expect(milk.expirationDate, equals(expDate));
        expect(milk.magnitudes.length, equals(2));

        final volMag = milk.magnitudes.firstWhere((m) => m.propertyName == 'Volumen');
        expect(volMag.magnitudeValue, equals(1.0), reason: 'Magnitude value per instance must NOT be multiplied by quantity');
        expect(volMag.unitSymbol, equals('L'));

        final fatMag = milk.magnitudes.firstWhere((m) => m.propertyName == 'Grasa');
        expect(fatMag.stringValue, equals('3.5%'));
      }

      // Verify they form a single homogeneous group
      final groups = EffectiveEntityGroup.groupEntities(
        entities: milkEntities,
        effectiveLocationMap: {for (var e in milkEntities) e.id: e.locationId},
      );
      expect(groups.length, equals(1));
      expect(groups.first.population, equals(4));
    });

    test('3. Batch Instantiating in Physical Node sets direct location for all N entities', () async {
      final locNode = LocationNode(id: 'loc-shed', name: 'Cobertizo', createdAt: DateTime.now());
      await locationRepo.saveNode(locNode);

      final plankSpecies = await catalogRepo.getOrCreateSpecies('Tabla de Roble', type: 'Objeto');

      final createdPlanks = await entityRepo.instantiateEntities(
        plankSpecies.id,
        locNode.id,
        6,
        notes: '2x4x8',
      );

      expect(createdPlanks.length, equals(6));

      final allEntities = await entityRepo.getAllEntities();
      final plankEntities = allEntities.where((e) => e.speciesId == plankSpecies.id).toList();
      expect(plankEntities.length, equals(6));

      for (final plank in plankEntities) {
        expect(plank.locationId, equals('loc-shed'));
        expect(plank.notes, equals('2x4x8'));
      }
    });
  });
}
