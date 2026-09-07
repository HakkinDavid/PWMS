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
        expect(rule.denominations, isNotEmpty);
        expect(rule.validCurrencies, isNotEmpty);

        // Every piece must have a non-empty denomination, currency, and non-empty motifs
        for (final piece in rule.pieces) {
          expect(piece.denomination.trim(), isNotEmpty);
          expect(piece.currency.trim(), isNotEmpty);
          expect(piece.motifs, isNotEmpty, reason: 'Piece ${piece.denomination} in ${rule.country} (${rule.minYear}-${rule.maxYear}) has empty motifs');
        }
      }
    });

    test('Mexico rules preserve complex alloys, materials and motifs', () {
      // 1.1 Virreinato: 1/4 has Plata and Cobre
      final virreinato = mexicoEmissionRules.firstWhere(
        (r) => r.country == 'Virreinato de Nueva España' && r.minYear == 1536,
      );
      final pieceCuartilla = virreinato.pieces.firstWhere((p) => p.denomination == '1/4');
      expect(pieceCuartilla.material, equals('Plata'));
      expect(pieceCuartilla.effectiveAllowedMaterials, containsAll(['Plata', 'Cobre']));

      // 1.23 Familia C Bicentenario y Centenario (2008–2010)
      final bicentenarioMex = mexicoEmissionRules.firstWhere(
        (r) => r.country == 'México' && r.minYear == 2008 && !r.isBanknote,
      );
      final piece5 = bicentenarioMex.pieces.firstWhere((p) => p.denomination == '5');
      expect(piece5.motifs.length, equals(37)); // 37 Bicentenario motifs

      // 1.25 Conmemorativas Familia C1 Dodecagonal (2020–presente)
      final conmem2020 = mexicoEmissionRules.firstWhere(
        (r) => r.country == 'México' && r.minYear == 2020 && !r.isBanknote,
      );
      final piece20 = conmem2020.pieces.firstWhere((p) => p.denomination == '20');
      expect(piece20.motifs.length, greaterThanOrEqualTo(10));
    });

    test('USA rules preserve quarters and presidential dollar motifs', () {
      final modernUSA = usaEmissionRules.firstWhere(
        (r) => r.country == 'Estados Unidos' && r.minYear == 2000,
      );
      final quarter = modernUSA.pieces.firstWhere((p) => p.denomination == '0.25');
      expect(quarter.motifs.length, greaterThan(60)); // State Quarters + ATB + Women Quarters
      final dollar = modernUSA.pieces.firstWhere((p) => p.denomination == '1');
      expect(dollar.motifs.length, greaterThan(40)); // Sacagawea + Presidential + Innovation
    });

    test('Spain rules preserve Pesetas and Euro commemorative motifs', () {
      final pesetaAutonomica = spainEmissionRules.firstWhere(
        (r) => r.country == 'España' && r.minYear == 1982,
      );
      final piece25 = pesetaAutonomica.pieces.firstWhere((p) => p.denomination == '25');
      expect(piece25.motifs.length, equals(11));

      final piece2000 = pesetaAutonomica.pieces.firstWhere((p) => p.denomination == '2000');
      expect(piece2000.motifs.length, equals(8));

      final euroSpain = spainEmissionRules.firstWhere(
        (r) => r.country == 'España' && r.minYear == 1999,
      );
      final piece2Euro = euroSpain.pieces.firstWhere((p) => p.denomination == '2');
      expect(piece2Euro.motifs.length, greaterThanOrEqualTo(25));
    });

    test('Banknote rules preserve Bank of Mexico and international families', () {
      final mexicoFamiliaG = banknoteEmissionRules.firstWhere(
        (r) => r.country == 'México' && r.minYear == 2020,
      );
      expect(mexicoFamiliaG.isBanknote, isTrue);
      final piece20 = mexicoFamiliaG.pieces.firstWhere((p) => p.denomination == '20');
      expect(piece20.material, equals('Polímero'));
      expect(piece20.motifs, isNotEmpty);
    });

    test('NumismaticMatrix evaluation executes with complete parity', () {
      // Test Mexico 1822 4 Reales (Plata) vs 4 Escudos (Oro)
      final res1 = NumismaticMatrix.evaluate(const NumismaticQueryContext(
        country: 'Imperio Mexicano (Primer y Segundo Imperio)',
        year: 1822,
        denomination: '4',
        currencyCode: 'MXR',
      ));
      expect(res1.matchingPiece, isNotNull);
      expect(res1.inferredMaterial, equals('Plata'));
      expect(res1.validMaterials, contains('Plata'));

      final res1Gold = NumismaticMatrix.evaluate(const NumismaticQueryContext(
        country: 'Imperio Mexicano (Primer y Segundo Imperio)',
        year: 1822,
        denomination: '4',
        currencyCode: 'MXE',
      ));
      expect(res1Gold.matchingPiece, isNotNull);
      expect(res1Gold.inferredMaterial, equals('Oro'));
      expect(res1Gold.validMaterials, contains('Oro'));


      // Test USA 2004 Quarter (Westward Journey / State Quarters active)
      final res2 = NumismaticMatrix.evaluate(const NumismaticQueryContext(
        country: 'Estados Unidos',
        year: 2004,
        denomination: '0.25',
        currencyCode: 'USD',
      ));
      expect(res2.matchingPiece, isNotNull);
      expect(res2.availableMotifs.length, equals(5)); // 5 state quarters for 2004
      expect(res2.availableMotifs, contains('50 State Quarters - Florida'));

      // Test Spain 1994 25 Pesetas (País Vasco)
      final res3 = NumismaticMatrix.evaluate(const NumismaticQueryContext(
        country: 'España',
        year: 1994,
        denomination: '25',
        currencyCode: 'ESP',
      ));
      expect(res3.matchingPiece, isNotNull);
      expect(res3.availableMotifs, contains('País Vasco'));
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

      // Spain 1 Peseta 1994 with valid motif -> no motif outlier
      final entitySpain1 = WorldEntity(
        id: 'inst-sp1-1994',
        speciesId: 'sp-coin',
        createdAt: now,
        updatedAt: now,
        magnitudes: const [
          InstanceMagnitude(id: 'm1', instanceId: 'inst-sp1-1994', propertyName: 'País', dataType: 'string', stringValue: 'España'),
          InstanceMagnitude(id: 'm2', instanceId: 'inst-sp1-1994', propertyName: 'Acuñación', dataType: 'integer', magnitudeValue: 1994.0, unitSymbol: 'año'),
          InstanceMagnitude(id: 'm3', instanceId: 'inst-sp1-1994', propertyName: 'Divisa', dataType: 'string', stringValue: 'ESP'),
          InstanceMagnitude(id: 'm4', instanceId: 'inst-sp1-1994', propertyName: 'Valor nominal', dataType: 'real', magnitudeValue: 1.0),
          InstanceMagnitude(id: 'm5', instanceId: 'inst-sp1-1994', propertyName: 'Material', dataType: 'string', stringValue: 'Aluminio'),
          InstanceMagnitude(id: 'm6', instanceId: 'inst-sp1-1994', propertyName: 'Motivo', dataType: 'string', stringValue: 'Grande / Lenteja'),
        ],
      );

      final outliersSpain1 = NumismaticDomainRules.checkEmissionOutliers(instance: entitySpain1);
      expect(outliersSpain1.any((o) => o.type == NumismaticEmissionOutlierType.motifMismatch), isFalse);
    });
  });
}
