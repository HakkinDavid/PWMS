import 'package:flutter_test/flutter_test.dart';
import 'package:platinum_world_management_system/src/features/entities/domain/instance_magnitude.dart';
import 'package:platinum_world_management_system/src/features/entities/domain/world_entity.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/numismatics/data/banknote_emission_rules.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/numismatics/data/mexico_emission_rules.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/numismatics/data/numismatic_rules_registry.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/numismatics/data/spain_emission_rules.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/numismatics/data/usa_emission_rules.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/numismatics/data/world_coins_emission_rules.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/numismatics/models/numismatic_models.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/numismatics/numismatic_domain_rules.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/numismatics/numismatic_matrix.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/numismatics/rules/numismatic_outlier_detector.dart';

void main() {
  group('Numismatic Data Migration Integrity Tests', () {
    test('All rule lists contain valid non-empty piece definitions', () {
      expect(mexicoEmissionRules.length, equals(25));
      expect(usaEmissionRules.length, equals(9));
      expect(spainEmissionRules.length, equals(6));
      expect(worldCoinsEmissionRules.length, equals(51));
      expect(banknoteEmissionRules.length, equals(30));

      final allRules = NumismaticRulesRegistry.allRules;
      expect(allRules.length, equals(121));

      for (final rule in allRules) {
        expect(rule.pieces, isNotEmpty, reason: 'Rule for ${rule.country} (${rule.minYear}-${rule.maxYear}) has empty pieces');
        expect(rule.effectivePieces, equals(rule.pieces));
        expect(rule.denominations, isNotEmpty);
        expect(rule.validCurrencies, isNotEmpty);

        // Every piece must have a non-empty denomination
        for (final piece in rule.pieces) {
          expect(piece.denomination.trim(), isNotEmpty);
          if (rule.isBanknote) {
            expect(piece.isBanknote, isTrue);
          }
        }
      }
    });

    test('Mexico rules preserve complex alloys, allowed materials and motifs', () {
      // 1.1 Virreinato: 1/4 has Plata and Cobre allowed
      final virreinato = mexicoEmissionRules.firstWhere(
        (r) => r.country == 'Virreinato de Nueva España' && r.minYear == 1536,
      );
      final pieceCuartilla = virreinato.pieces.firstWhere((p) => p.denomination == '1/4');
      expect(pieceCuartilla.material, equals('Plata'));
      expect(pieceCuartilla.effectiveAllowedMaterials, equals(['Plata', 'Cobre']));

      // 1.23 Familia C Bicentenario y Centenario (2008–2010)
      final bicentenarioMex = mexicoEmissionRules.firstWhere(
        (r) => r.country == 'México' && r.minYear == 2008 && !r.isBanknote,
      );
      final piece5 = bicentenarioMex.pieces.firstWhere((p) => p.denomination == '5');
      expect(piece5.motifs.length, equals(37)); // 37 Bicentenario motifs
      expect(piece5.allowsStandardForYear(2008), isFalse); // Strictly commemorative!

      // 1.25 Conmemorativas Familia C1 Dodecagonal (2020–presente)
      final conmem2020 = mexicoEmissionRules.firstWhere(
        (r) => r.country == 'México' && r.minYear == 2020 && !r.isBanknote,
      );
      final piece20 = conmem2020.pieces.firstWhere((p) => p.denomination == '20');
      expect(piece20.motifs.length, greaterThanOrEqualTo(10));
      expect(piece20.allowsStandardForYear(2020), isFalse); // All $20 Dodecagonal coins are commemorative issues
    });

    test('USA rules preserve quarters and presidential dollar motifs', () {
      final modernUSA = usaEmissionRules.firstWhere(
        (r) => r.country == 'Estados Unidos' && r.minYear == 2000,
      );
      final quarter = modernUSA.pieces.firstWhere((p) => p.denomination == '0.25');
      expect(quarter.motifs.length, greaterThan(60)); // State Quarters + ATB + Women Quarters
      expect(quarter.allowsStandardForYear(2004), isFalse); // 50 State Quarters only in 2004 (no generic eagle)

      final dollar = modernUSA.pieces.firstWhere((p) => p.denomination == '1');
      expect(dollar.motifs.length, greaterThan(40)); // Sacagawea + Presidential + Innovation
    });

    test('Spain rules preserve Pesetas and Euro commemorative motifs', () {
      final pesetaAutonomica = spainEmissionRules.firstWhere(
        (r) => r.country == 'España' && r.minYear == 1982,
      );
      final piece25 = pesetaAutonomica.pieces.firstWhere((p) => p.denomination == '25');
      expect(piece25.motifs.length, equals(11)); // 10 motifs + 1 standard
      expect(piece25.allowsStandardForYear(1994), isTrue);

      final piece2000 = pesetaAutonomica.pieces.firstWhere((p) => p.denomination == '2000');
      expect(piece2000.motifs.length, equals(8));
      expect(piece2000.allowsStandardForYear(1994), isFalse); // Strictly commemorative silver coin!

      final euroSpain = spainEmissionRules.firstWhere(
        (r) => r.country == 'España' && r.minYear == 1999,
      );
      final piece2Euro = euroSpain.pieces.firstWhere((p) => p.denomination == '2');
      expect(piece2Euro.motifs.length, greaterThanOrEqualTo(25));
      expect(piece2Euro.allowsStandardForYear(2014), isTrue);
    });

    test('Banknote rules preserve Bank of Mexico and international families', () {
      final mexicoFamiliaG = banknoteEmissionRules.firstWhere(
        (r) => r.country == 'México' && r.minYear == 2020,
      );
      expect(mexicoFamiliaG.isBanknote, isTrue);
      final piece20 = mexicoFamiliaG.pieces.firstWhere((p) => p.denomination == '20');
      expect(piece20.material, equals('Polímero'));
      expect(piece20.isBanknote, isTrue);
      expect(piece20.motifs, isNotEmpty);
      expect(piece20.allowsStandardForYear(2021), isTrue);
    });

    test('NumismaticMatrix evaluation executes with complete parity', () {
      // Test Mexico 1822 4 Reales (allowed Plata/Oro)
      final res1 = NumismaticMatrix.evaluate(const NumismaticQueryContext(
        country: 'Imperio Mexicano (Primer y Segundo Imperio)',
        year: 1822,
        denomination: '4',
        currencyCode: 'MXR',
      ));
      expect(res1.matchingPiece, isNotNull);
      expect(res1.inferredMaterial, equals('Oro'));
      expect(res1.validMaterials, equals(['Oro', 'Plata']));

      // Test USA 2004 Quarter (Westward Journey / State Quarters active)
      final res2 = NumismaticMatrix.evaluate(const NumismaticQueryContext(
        country: 'Estados Unidos',
        year: 2004,
        denomination: '0.25',
        currencyCode: 'USD',
      ));
      expect(res2.matchingPiece, isNotNull);
      expect(res2.availableMotifs.length, equals(5)); // 5 state quarters for 2004
      expect(res2.availableMotifs, contains('50 State Quarters - Florida (2004)'));

      // Test Spain 1994 25 Pesetas (País Vasco)
      final res3 = NumismaticMatrix.evaluate(const NumismaticQueryContext(
        country: 'España',
        year: 1994,
        denomination: '25',
        currencyCode: 'ESP',
      ));
      expect(res3.matchingPiece, isNotNull);
      expect(res3.availableMotifs, contains('País Vasco (1994)'));
    });

    test('Outlier detector alerts when strictly commemorative coin is missing motif', () {
      final now = DateTime.now();

      // Mexico $5 2008 without motif -> should alert that motif is required!
      final entityMex5 = WorldEntity(
        id: 'inst-mex5-2008',
        speciesId: 'sp-coin',
        createdAt: now,
        updatedAt: now,
        magnitudes: const [
          InstanceMagnitude(id: 'm1', instanceId: 'inst-mex5-2008', propertyName: 'País', dataType: 'string', stringValue: 'México'),
          InstanceMagnitude(id: 'm2', instanceId: 'inst-mex5-2008', propertyName: 'Acuñación', dataType: 'integer', magnitudeValue: 2008.0, unitSymbol: 'año'),
          InstanceMagnitude(id: 'm3', instanceId: 'inst-mex5-2008', propertyName: 'Divisa', dataType: 'string', stringValue: 'MXN'),
          InstanceMagnitude(id: 'm4', instanceId: 'inst-mex5-2008', propertyName: 'Valor nominal', dataType: 'real', magnitudeValue: 5.0),
          InstanceMagnitude(id: 'm5', instanceId: 'inst-mex5-2008', propertyName: 'Material', dataType: 'string', stringValue: 'Bimetálica'),
        ],
      );

      final outliersMex5 = NumismaticDomainRules.checkEmissionOutliers(instance: entityMex5);
      expect(outliersMex5.any((o) => o.type == NumismaticEmissionOutlierType.motifMismatch), isTrue);

      // Spain 25 Pesetas 1994 without motif -> standard circulation is valid, no motif outlier
      final entitySpain25 = WorldEntity(
        id: 'inst-sp25-1994',
        speciesId: 'sp-coin',
        createdAt: now,
        updatedAt: now,
        magnitudes: const [
          InstanceMagnitude(id: 'm1', instanceId: 'inst-sp25-1994', propertyName: 'País', dataType: 'string', stringValue: 'España'),
          InstanceMagnitude(id: 'm2', instanceId: 'inst-sp25-1994', propertyName: 'Acuñación', dataType: 'integer', magnitudeValue: 1994.0, unitSymbol: 'año'),
          InstanceMagnitude(id: 'm3', instanceId: 'inst-sp25-1994', propertyName: 'Divisa', dataType: 'string', stringValue: 'ESP'),
          InstanceMagnitude(id: 'm4', instanceId: 'inst-sp25-1994', propertyName: 'Valor nominal', dataType: 'real', magnitudeValue: 25.0),
          InstanceMagnitude(id: 'm5', instanceId: 'inst-sp25-1994', propertyName: 'Material', dataType: 'string', stringValue: 'Bronce de aluminio'),
        ],
      );

      final outliersSpain25 = NumismaticDomainRules.checkEmissionOutliers(instance: entitySpain25);
      expect(outliersSpain25.any((o) => o.type == NumismaticEmissionOutlierType.motifMismatch), isFalse);
    });
  });
}
