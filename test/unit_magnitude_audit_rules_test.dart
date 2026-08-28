import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:platinum_world_management_system/src/core/database/app_database.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/catalog_item.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/species_magnitude.dart';
import 'package:platinum_world_management_system/src/features/control_center/domain/audit_rule_strategy.dart';
import 'package:platinum_world_management_system/src/features/control_center/domain/strategies/unit_magnitude_audit_rules.dart';
import 'package:platinum_world_management_system/src/features/entities/domain/instance_magnitude.dart';
import 'package:platinum_world_management_system/src/features/entities/domain/world_entity.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  group('Unit & Magnitude Anomaly Audit Strategies Tests', () {
    test('1. InvalidUnitSymbolStrategy detects unknown/unregistered unit symbols', () async {
      const strategy = InvalidUnitSymbolStrategy();

      final speciesWithInvalidUnit = CatalogItem(
        id: 'sp1',
        name: 'Objeto Raro',
        type: 'Objeto',
        createdAt: DateTime.now(),
        magnitudes: [
          SpeciesMagnitude(
            id: 'sm1',
            speciesId: 'sp1',
            propertyName: 'Grosor',
            unitSymbol: 'custom_unit_xyz',
            createdAt: DateTime.now(),
          ),
        ],
      );

      final entityWithInvalidUnit = WorldEntity(
        id: 'e1',
        speciesId: 'sp1',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        magnitudes: [
          const InstanceMagnitude(
            id: 'im1',
            instanceId: 'e1',
            propertyName: 'Densidad',
            unitSymbol: 'invalid_si',
            magnitudeValue: 15.0,
          ),
        ],
      );

      final context = AuditEvaluationContext(
        db: db,
        allEntities: [entityWithInvalidUnit],
        allCatalog: [speciesWithInvalidUnit],
        allSubspecies: const [],
        allRelations: const [],
        allLocations: const [],
        allSpeciesMagnitudes: speciesWithInvalidUnit.magnitudes,
        allInstanceMagnitudes: entityWithInvalidUnit.magnitudes,
        allRequirements: const [],
        effectiveLocationMap: const {},
      );

      final cards = await strategy.evaluate(context);
      expect(cards.length, 2);
      expect(cards.any((c) => c.type == AuditCardType.invalidUnitSymbol && c.species?.id == 'sp1'), isTrue);
      expect(cards.any((c) => c.type == AuditCardType.invalidUnitSymbol && c.entity?.id == 'e1'), isTrue);
    });

    test('2. IntegerUnitIncongruityStrategy detects decimal data types, fractions on discrete units, and unique species violations', () async {
      const strategy = IntegerUnitIncongruityStrategy();

      // Species with unit 'unidad' but dataType 'real'
      final speciesWithWrongDataType = CatalogItem(
        id: 'sp_discrete',
        name: 'Tornillo',
        type: 'Objeto',
        isUnique: false,
        createdAt: DateTime.now(),
        magnitudes: [
          SpeciesMagnitude(
            id: 'sm_disc',
            speciesId: 'sp_discrete',
            propertyName: 'Cantidad',
            dataType: 'real',
            unitSymbol: 'unidad',
            createdAt: DateTime.now(),
          ),
        ],
      );

      // Unique species with integer unit 'unidad'
      final uniqueSpeciesWithIntegerUnit = CatalogItem(
        id: 'sp_unique',
        name: 'Monalisa',
        type: 'Objeto',
        isUnique: true,
        createdAt: DateTime.now(),
        magnitudes: [
          SpeciesMagnitude(
            id: 'sm_uniq',
            speciesId: 'sp_unique',
            propertyName: 'Cantidad',
            dataType: 'integer',
            unitSymbol: 'unidad',
            createdAt: DateTime.now(),
          ),
        ],
      );

      // Instance with fractional magnitude on discrete unit 'unidad' (2.5 unidad)
      final entityWithDecimalFraction = WorldEntity(
        id: 'e_frac',
        speciesId: 'sp_discrete',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        magnitudes: [
          const InstanceMagnitude(
            id: 'im_frac',
            instanceId: 'e_frac',
            propertyName: 'Cantidad',
            dataType: 'integer',
            magnitudeValue: 2.5,
            unitSymbol: 'unidad',
          ),
        ],
      );

      final context = AuditEvaluationContext(
        db: db,
        allEntities: [entityWithDecimalFraction],
        allCatalog: [speciesWithWrongDataType, uniqueSpeciesWithIntegerUnit],
        allSubspecies: const [],
        allRelations: const [],
        allLocations: const [],
        allSpeciesMagnitudes: [...speciesWithWrongDataType.magnitudes, ...uniqueSpeciesWithIntegerUnit.magnitudes],
        allInstanceMagnitudes: entityWithDecimalFraction.magnitudes,
        allRequirements: const [],
        effectiveLocationMap: const {},
      );

      final cards = await strategy.evaluate(context);
      expect(cards.length, 3);
      expect(cards.every((c) => c.type == AuditCardType.integerUnitIncongruity), isTrue);
    });

    test('3. NonNumericWithUnitStrategy detects unit symbols assigned to string/boolean properties', () async {
      const strategy = NonNumericWithUnitStrategy();

      final speciesWithTextUnit = CatalogItem(
        id: 'sp_text',
        name: 'Libro',
        type: 'Objeto',
        createdAt: DateTime.now(),
        magnitudes: [
          SpeciesMagnitude(
            id: 'sm_str',
            speciesId: 'sp_text',
            propertyName: 'Autor',
            dataType: 'string',
            unitSymbol: 'kg', // invalid on string
            createdAt: DateTime.now(),
          ),
        ],
      );

      final entityWithBoolUnit = WorldEntity(
        id: 'e_bool',
        speciesId: 'sp_text',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        magnitudes: [
          const InstanceMagnitude(
            id: 'im_bool',
            instanceId: 'e_bool',
            propertyName: 'Edición Especial',
            dataType: 'boolean',
            stringValue: 'true',
            unitSymbol: 'm', // invalid on bool
          ),
        ],
      );

      final context = AuditEvaluationContext(
        db: db,
        allEntities: [entityWithBoolUnit],
        allCatalog: [speciesWithTextUnit],
        allSubspecies: const [],
        allRelations: const [],
        allLocations: const [],
        allSpeciesMagnitudes: speciesWithTextUnit.magnitudes,
        allInstanceMagnitudes: entityWithBoolUnit.magnitudes,
        allRequirements: const [],
        effectiveLocationMap: const {},
      );

      final cards = await strategy.evaluate(context);
      expect(cards.length, 2);
      expect(cards.every((c) => c.type == AuditCardType.nonNumericWithUnit), isTrue);
    });

    test('4. NegativeMagnitudeViolationStrategy detects negative values on non-negative units', () async {
      const strategy = NegativeMagnitudeViolationStrategy();

      final entityWithNegativeWeight = WorldEntity(
        id: 'e_neg',
        speciesId: 'sp_box',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        magnitudes: [
          const InstanceMagnitude(
            id: 'im_neg',
            instanceId: 'e_neg',
            propertyName: 'Masa',
            dataType: 'real',
            magnitudeValue: -5.0,
            unitSymbol: 'kg',
          ),
        ],
      );

      final context = AuditEvaluationContext(
        db: db,
        allEntities: [entityWithNegativeWeight],
        allCatalog: const [],
        allSubspecies: const [],
        allRelations: const [],
        allLocations: const [],
        allSpeciesMagnitudes: const [],
        allInstanceMagnitudes: entityWithNegativeWeight.magnitudes,
        allRequirements: const [],
        effectiveLocationMap: const {},
      );

      final cards = await strategy.evaluate(context);
      expect(cards.length, 1);
      expect(cards.first.type, AuditCardType.negativeMagnitudeViolation);
      expect(cards.first.entity?.id, 'e_neg');
    });

    test('5. PropertyNameSuggestionIncongruityStrategy detects generic uninformative property names', () async {
      const strategy = PropertyNameSuggestionIncongruityStrategy();

      final speciesWithGenericProp = CatalogItem(
        id: 'sp_gen',
        name: 'Materia Prima',
        type: 'Objeto',
        createdAt: DateTime.now(),
        magnitudes: [
          SpeciesMagnitude(
            id: 'sm_gen1',
            speciesId: 'sp_gen',
            propertyName: 'Propiedad', // Generic name, but unit is 'unidad' -> suggested: 'Cantidad'
            dataType: 'integer',
            unitSymbol: 'unidad',
            createdAt: DateTime.now(),
          ),
          SpeciesMagnitude(
            id: 'sm_gen2',
            speciesId: 'sp_gen',
            propertyName: 'default', // Generic name, unit is 'kg' -> suggested: 'Masa'
            dataType: 'real',
            unitSymbol: 'kg',
            createdAt: DateTime.now(),
          ),
        ],
      );

      final context = AuditEvaluationContext(
        db: db,
        allEntities: const [],
        allCatalog: [speciesWithGenericProp],
        allSubspecies: const [],
        allRelations: const [],
        allLocations: const [],
        allSpeciesMagnitudes: speciesWithGenericProp.magnitudes,
        allInstanceMagnitudes: const [],
        allRequirements: const [],
        effectiveLocationMap: const {},
      );

      final cards = await strategy.evaluate(context);
      expect(cards.length, 2);
      expect(cards.every((c) => c.type == AuditCardType.propertyNameSuggestionIncongruity), isTrue);
    });
  });
}
