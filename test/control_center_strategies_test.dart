import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:platinum_world_management_system/src/core/database/app_database.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/catalog_item.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/subspecies.dart';
import 'package:platinum_world_management_system/src/features/control_center/domain/audit_rule_registry.dart';
import 'package:platinum_world_management_system/src/features/control_center/domain/audit_rule_strategy.dart';
import 'package:platinum_world_management_system/src/features/control_center/domain/strategies/catalog_audit_rules.dart';
import 'package:platinum_world_management_system/src/features/control_center/domain/strategies/expiration_audit_rules.dart';
import 'package:platinum_world_management_system/src/features/control_center/domain/strategies/relational_audit_rules.dart';
import 'package:platinum_world_management_system/src/features/entities/domain/world_entity.dart';
import 'package:platinum_world_management_system/src/features/relations/domain/entity_relation.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  group('Control Center Strategy Pattern Tests', () {
    test('AuditRuleRegistry initializes all strategies', () {
      final registry = AuditRuleRegistry();
      expect(registry.strategies.length, 20);
    });

    test('OrphanEntityStrategy detects instances without location or container', () async {
      const strategy = OrphanEntityStrategy();

      final orphan = WorldEntity(
        id: 'e1',
        speciesId: 'sp1',
        locationId: null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final species = CatalogItem(
        id: 'sp1',
        name: 'Objeto Huérfano',
        type: 'Objeto',
        createdAt: DateTime.now(),
      );

      final context = AuditEvaluationContext(
        db: db,
        allEntities: [orphan],
        allCatalog: [species],
        allSubspecies: const [],
        allRelations: const [],
        allLocations: const [],
        allSpeciesMagnitudes: const [],
        allInstanceMagnitudes: const [],
        allRequirements: const [],
        effectiveLocationMap: const {},
      );

      final cards = await strategy.evaluate(context);
      expect(cards.length, 1);
      expect(cards.first.type, AuditCardType.orphanEntity);
      expect(cards.first.entity?.id, 'e1');
    });

    test('CyclicContainmentStrategy detects self-referencing relations', () async {
      const strategy = CyclicContainmentStrategy();

      final rel = EntityRelation(
        id: 'r1',
        sourceEntityId: 'e1',
        targetEntityId: 'e1',
        relationType: 'GUARDADO_EN',
        createdAt: DateTime.now(),
      );

      final entity = WorldEntity(
        id: 'e1',
        speciesId: 'sp1',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final context = AuditEvaluationContext(
        db: db,
        allEntities: [entity],
        allCatalog: const [],
        allSubspecies: const [],
        allRelations: [rel],
        allLocations: const [],
        allSpeciesMagnitudes: const [],
        allInstanceMagnitudes: const [],
        allRequirements: const [],
        effectiveLocationMap: const {},
      );

      final cards = await strategy.evaluate(context);
      expect(cards.length, 1);
      expect(cards.first.type, AuditCardType.cyclicContainment);
    });

    test('PerishableMissingExpirationStrategy detects perishables with null expiration', () async {
      const strategy = PerishableMissingExpirationStrategy();

      final perishableSpecies = CatalogItem(
        id: 'sp_food',
        name: 'Yogurt Natural',
        type: 'Objeto',
        isNonPerishable: false,
        createdAt: DateTime.now(),
      );

      final instance = WorldEntity(
        id: 'e_yogurt',
        speciesId: 'sp_food',
        expirationDate: null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final context = AuditEvaluationContext(
        db: db,
        allEntities: [instance],
        allCatalog: [perishableSpecies],
        allSubspecies: const [],
        allRelations: const [],
        allLocations: const [],
        allSpeciesMagnitudes: const [],
        allInstanceMagnitudes: const [],
        allRequirements: const [],
        effectiveLocationMap: const {},
      );

      final cards = await strategy.evaluate(context);
      expect(cards.length, 1);
      expect(cards.first.type, AuditCardType.perishableMissingExpiration);
    });

    test('UniquenessViolationStrategy detects multiple instances of unique subspecies', () async {
      const strategy = UniquenessViolationStrategy();

      final uniqueSpecies = CatalogItem(
        id: 'sp_unique',
        name: 'Reliquia Familiar',
        type: 'Objeto',
        isUnique: true,
        createdAt: DateTime.now(),
      );

      final sub = Subspecies(
        id: 'sub_unique',
        speciesId: 'sp_unique',
        subspeciesName: 'Reliquia Oro',
        createdAt: DateTime.now(),
      );

      final e1 = WorldEntity(
        id: 'e1',
        speciesId: 'sp_unique',
        subspeciesId: 'sub_unique',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      final e2 = WorldEntity(
        id: 'e2',
        speciesId: 'sp_unique',
        subspeciesId: 'sub_unique',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final context = AuditEvaluationContext(
        db: db,
        allEntities: [e1, e2],
        allCatalog: [uniqueSpecies],
        allSubspecies: [sub],
        allRelations: const [],
        allLocations: const [],
        allSpeciesMagnitudes: const [],
        allInstanceMagnitudes: const [],
        allRequirements: const [],
        effectiveLocationMap: const {},
      );

      final cards = await strategy.evaluate(context);
      expect(cards.length, 1);
      expect(cards.first.type, AuditCardType.uniquenessViolation);
    });
  });
}
