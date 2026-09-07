import 'package:flutter_test/flutter_test.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/numismatics/data/banknote_emission_rules.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/numismatics/data/mexico_emission_rules.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/numismatics/data/numismatic_rules_registry.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/numismatics/data/spain_emission_rules.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/numismatics/data/usa_emission_rules.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/numismatics/data/world_coins_emission_rules.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/numismatics/models/numismatic_models.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/numismatics/numismatic_matrix.dart';

void main() {
  group('Numismatic Data Migration Integrity Tests', () {
    test('All rule lists contain valid non-empty piece definitions', () {
      expect(mexicoEmissionRules.length, equals(27));
      expect(usaEmissionRules.length, equals(9));
      expect(spainEmissionRules.length, equals(6));
      expect(worldCoinsEmissionRules.length, equals(51));
      expect(banknoteEmissionRules.length, equals(30));

      final allRules = NumismaticRulesRegistry.allRules;
      expect(allRules.length, equals(123));

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

      // 1.25 Familia C Bicentenario y Centenario (2008–2010)
      final bicentenarioMex = mexicoEmissionRules.firstWhere(
        (r) => r.country == 'México' && r.minYear == 2008 && !r.isBanknote,
      );
      final piece5 = bicentenarioMex.pieces.firstWhere((p) => p.denomination == '5');
      expect(piece5.motifs.length, equals(37)); // 37 Bicentenario motifs

      // 1.27 Conmemorativas Familia C1 Dodecagonal (2020–presente)
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
      expect(piece25.motifs.length, equals(10));

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
      expect(piece20.isBanknote, isTrue);
      expect(piece20.motifs, isNotEmpty);
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
  });
}
