import 'package:flutter_test/flutter_test.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/numismatics/data/numismatic_materials_registry.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/numismatics/data/numismatic_rules_registry.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/numismatics/models/numismatic_models.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/numismatics/numismatic_matrix.dart';

void main() {
  group('NumismaticPieceDefinition Unit Tests', () {
    test('matchesYear correctly evaluates boundaries and intervals derived from motifs', () {
      const piece = NumismaticPieceDefinition(
        denomination: '0.50',
        currency: 'MXP',
        motifs: [
          NumismaticMotifRule(
            'Cuauhtémoc',
            minYear: 1955,
            maxYear: 1959,
            material: 'Bronce',
          ),
        ],
      );

      expect(piece.matchesYear(null), isTrue);
      expect(piece.matchesYear(1954), isFalse);
      expect(piece.matchesYear(1955), isTrue);
      expect(piece.matchesYear(1957), isTrue);
      expect(piece.matchesYear(1959), isTrue);
      expect(piece.matchesYear(1960), isFalse);
    });

    test('matchesDenomination accurately handles fractions, decimals and integers', () {
      const pieceCuartilla = NumismaticPieceDefinition(
        denomination: '1/4',
        currency: 'MXR',
        motifs: [
          NumismaticMotifRule('Cuartilla', minYear: 1800, material: 'Plata'),
        ],
      );
      expect(pieceCuartilla.matchesDenomination('1/4'), isTrue);
      expect(pieceCuartilla.matchesDenomination('0.25'), isTrue);
      expect(pieceCuartilla.matchesDenomination('1/2'), isFalse);

      const pieceOctavo = NumismaticPieceDefinition(
        denomination: '1/8',
        currency: 'MXR',
        motifs: [
          NumismaticMotifRule('Octavo', minYear: 1800, material: 'Cobre'),
        ],
      );
      expect(pieceOctavo.matchesDenomination('1/8'), isTrue);
      expect(pieceOctavo.matchesDenomination('0.125'), isTrue);

      const piece50c = NumismaticPieceDefinition(
        denomination: '0.50',
        currency: 'MXP',
        motifs: [
          NumismaticMotifRule('50 Centavos', minYear: 1950, material: 'Bronce'),
        ],
      );
      expect(piece50c.matchesDenomination('0.50'), isTrue);
      expect(piece50c.matchesDenomination('0.5'), isTrue);
      expect(piece50c.matchesDenomination('1/2'), isTrue);
      expect(piece50c.matchesDenomination('0.20'), isFalse);
    });

    test('effectiveAllowedMaterials and getMaterialsForYear resolves primary and concurrent alloys', () {
      const singleMatPiece = NumismaticPieceDefinition(
        denomination: '1',
        currency: 'MXP',
        motifs: [
          NumismaticMotifRule('Un Peso', minYear: 1900, material: 'Plata'),
        ],
      );
      expect(singleMatPiece.effectiveAllowedMaterials, equals(['Plata']));
      expect(singleMatPiece.getMaterialsForYear(1900), equals(['Plata']));

      const multiMatPiece = NumismaticPieceDefinition(
        denomination: '100',
        currency: 'MXN',
        motifs: [
          NumismaticMotifRule('Cien Pesos Polímero', minYear: 2020, material: 'Polímero'),
          NumismaticMotifRule('Cien Pesos Algodón', minYear: 2020, material: 'Papel de algodón'),
        ],
      );
      expect(multiMatPiece.effectiveAllowedMaterials, containsAll(['Polímero', 'Papel de algodón']));
      expect(multiMatPiece.getMaterialsForYear(2020), containsAll(['Polímero', 'Papel de algodón']));
    });

    test('getMotifsForYear filters temporally bounded motifs', () {
      const piece = NumismaticPieceDefinition(
        denomination: '100',
        currency: 'MXN',
        motifs: [
          NumismaticMotifRule('Centenario de la Revolución Mexicana (2010)', minYear: 2009, maxYear: 2010, material: 'Polímero'),
          NumismaticMotifRule('Centenario de la Constitución Política de 1917 (2017)', minYear: 2016, maxYear: 2017, material: 'Papel de algodón'),
        ],
      );

      expect(piece.getMotifsForYear(2010), equals(['Centenario de la Revolución Mexicana (2010)']));
      expect(piece.getMotifsForYear(2017), equals(['Centenario de la Constitución Política de 1917 (2017)']));
      expect(piece.getMotifsForYear(2014), isEmpty);
    });

    test('NumismaticMotifRule handles descriptive names, material and year matching', () {
      const standardMotif = NumismaticMotifRule(
        'Lincoln Memorial (1959-2008)',
        minYear: 2000,
        maxYear: 2008,
        material: 'Zinc recubierto de cobre',
      );

      expect(standardMotif.name, equals('Lincoln Memorial (1959-2008)'));
      expect(standardMotif.material, equals('Zinc recubierto de cobre'));
      expect(standardMotif.matchesYear(2004), isTrue);
      expect(standardMotif.matchesYear(1999), isFalse);
      expect(standardMotif.matchesYear(2009), isFalse);
      expect(standardMotif.matchesYear(null), isTrue);

      const commemorativeMotif = NumismaticMotifRule(
        'Lincoln Bicentennial - Birthplace (2009)',
        minYear: 2009,
        material: 'Zinc recubierto de cobre',
      );
      expect(commemorativeMotif.minYear, equals(2009));
      expect(commemorativeMotif.maxYear, equals(2009));
      expect(commemorativeMotif.material, equals('Zinc recubierto de cobre'));
      expect(commemorativeMotif.matchesYear(2009), isTrue);
      expect(commemorativeMotif.matchesYear(2010), isFalse);
    });
  });

  group('NumismaticEmissionRuleData Piece-Level Granularity Tests', () {
    test('supports piece definitions and derives denomination metadata correctly', () {
      const rule = NumismaticEmissionRuleData(
        country: 'México',
        pieces: [
          NumismaticPieceDefinition(
            denomination: '10',
            currency: 'MXN',
            motifs: [NumismaticMotifRule('10 Nuevos Pesos', minYear: 1993, maxYear: 1995, material: 'Plata / Aluminio-Bronce')],
          ),
          NumismaticPieceDefinition(
            denomination: '20',
            currency: 'MXN',
            motifs: [NumismaticMotifRule('20 Nuevos Pesos', minYear: 1993, maxYear: 1995, material: 'Plata / Latón')],
          ),
          NumismaticPieceDefinition(
            denomination: '50',
            currency: 'MXN',
            motifs: [NumismaticMotifRule('50 Nuevos Pesos', minYear: 1993, maxYear: 1995, material: 'Plata / Latón')],
          ),
        ],
      );

      expect(rule.pieces.length, equals(3));
      expect(rule.denominations, equals(['10', '20', '50']));
      expect(rule.denominationMaterials['10'], equals('Plata / Aluminio-Bronce'));
    });

    test('supports explicit piece definitions with dynamic year filtering', () {
      const rule = NumismaticEmissionRuleData(
        country: 'México',
        pieces: [
          NumismaticPieceDefinition(
            denomination: '0.01',
            currency: 'MXP',
            motifs: [NumismaticMotifRule('Centavito Porfiriano', minYear: 1905, maxYear: 1914, material: 'Cobre')],
          ),
          NumismaticPieceDefinition(
            denomination: '0.50',
            currency: 'MXP',
            motifs: [NumismaticMotifRule('Cuauhtémoc', minYear: 1955, maxYear: 1959, material: 'Bronce')],
          ),
          NumismaticPieceDefinition(
            denomination: '1',
            currency: 'MXP',
            motifs: [NumismaticMotifRule('Morelos Tepalcate', minYear: 1957, maxYear: 1967, material: 'Plata .100')],
          ),
        ],
      );

      expect(rule.getDenominationsForYear(1910), equals(['0.01']));
      expect(rule.getDenominationsForYear(1957), equals(['0.50', '1']));
      expect(rule.getDenominationsForYear(1965), equals(['1']));
      expect(rule.getPieceForDenomination('0.50', year: 1957)?.motifs.first.name, equals('Cuauhtémoc'));
    });
  });

  group('NumismaticMatrix 1-Pass Unified Inferences (evaluate)', () {
    test('evaluates valid query context in a single pass', () {
      const context = NumismaticQueryContext(
        country: 'México',
        year: 2021,
        denomination: '20',
        isBanknote: false,
      );

      final result = NumismaticMatrix.evaluate(context);

      expect(result.matchingEpoch, isNotNull);
      expect(result.inferredCurrency, equals('MXN'));
      expect(result.availableCurrencies, contains('MXN'));
      expect(result.availableDenominations, contains('20'));
      expect(result.validMaterials, isNotEmpty);
      expect(result.inferredMaterial, isNotNull);
      expect(result.availableMotifs, contains('Bicentenario de la Independencia Nacional'));
    });

    test('evaluates banknote context accurately in a single pass', () {
      const context = NumismaticQueryContext(
        country: 'México',
        year: 2021,
        denomination: '50',
        isBanknote: true,
      );

      final result = NumismaticMatrix.evaluate(context);

      expect(result.matchingEpoch, isNotNull);
      expect(result.inferredCurrency, equals('MXN'));
      expect(result.inferredMaterial, equals('Polímero'));
      expect(result.validMaterials, contains('Polímero'));
    });

    test('handles unknown country gracefully', () {
      const context = NumismaticQueryContext(
        country: 'Atlantis',
        year: 2000,
        isBanknote: false,
      );

      final result = NumismaticMatrix.evaluate(context);
      expect(result.matchingEpoch, isNull);
      expect(result.availableDenominations, isNotEmpty);
    });
  });

  group('NumismaticPieceDefinition Materials & Definition Congruence Tests', () {
    test('Mexican N\$ 10, 20, 50 and 100 pesos provide congruent allowed materials', () {
      final mex92 = NumismaticMatrix.findRule('México', 1993, isBanknote: false);
      expect(mex92, isNotNull);
      final piece10 = mex92!.getPieceForDenomination('10', year: 1993);
      expect(piece10?.effectiveAllowedMaterials, contains(NumismaticMaterialsRegistry.nameBimetallicSilver925BronzeAl));

      final piece20 = mex92.getPieceForDenomination('20', year: 1993);
      expect(piece20?.effectiveAllowedMaterials, contains(NumismaticMaterialsRegistry.nameBimetallicSilver925BronzeAl));

      final piece50 = mex92.getPieceForDenomination('50', year: 1993);
      expect(piece50?.effectiveAllowedMaterials, contains(NumismaticMaterialsRegistry.nameBimetallicSilver925BronzeAl));

      final mex03 = NumismaticMatrix.findRule('México', 2005, isBanknote: false);
      expect(mex03, isNotNull);
      final piece100 = mex03!.getPieceForDenomination('100', year: 2005);
      expect(piece100?.effectiveAllowedMaterials, contains(NumismaticMaterialsRegistry.nameBimetallicSilver925BronzeAl));
    });

    test('All piece definitions in registry have valid non-empty motifs with explicit materials', () {
      final allRules = NumismaticRulesRegistry.allRules;
      for (final r in allRules) {
        for (final p in r.pieces) {
          expect(p.motifs, isNotEmpty);
          for (final m in p.motifs) {
            expect(m.material.trim(), isNotEmpty);
            expect(m.minYear, greaterThanOrEqualTo(1000));
            expect(m.maxYear, greaterThanOrEqualTo(m.minYear));
          }
        }
      }
    });

    test('All piece definitions in registry are strictly unique per denomination and currency within each emission rule', () {
      for (final rule in NumismaticRulesRegistry.allRules) {
        final seenPieces = <String>{};
        for (final p in rule.pieces) {
          final key = '${p.denomination}_${p.currency}';
          expect(
            seenPieces.contains(key),
            isFalse,
            reason: 'Duplicate piece "${p.denomination}" (${p.currency}) found in rule for ${rule.country} (${rule.minYear}-${rule.maxYear})',
          );
          seenPieces.add(key);
        }
      }
    });

    test('Consolidated multi-motif piece definitions resolve motifs accurately by year', () {
      // Mexico 1905-1914 1 Peso (Resplandor vs Caballito)
      final mex1905 = NumismaticMatrix.findRule('México', 1908);
      expect(mex1905, isNotNull);
      final piece1P = mex1905!.getPieceForDenomination('1', year: 1908);
      expect(piece1P, isNotNull);
      expect(piece1P!.getMotifsForYear(1908), equals(['Fuerte Resplandor']));

      final piece1PCaballito = mex1905.getPieceForDenomination('1', year: 1910);
      expect(piece1PCaballito!.getMotifsForYear(1910), contains('Caballito - Centenario de la Independencia (1910-1914)'));

      // Mexico 1950-1956 5 Pesos (Ferrocarril, Hidalgo Laurel, Bicentenario, Hidalgo Chico)
      final mex1950 = NumismaticMatrix.findRule('México', 1953);
      expect(mex1950, isNotNull);
      final piece5P = mex1950!.getPieceForDenomination('5', year: 1953);
      expect(piece5P, isNotNull);
      expect(piece5P!.getMotifsForYear(1950), contains('Inauguración del Ferrocarril del Sureste'));
      expect(piece5P.getMotifsForYear(1952), contains('Hidalgo - Laurel (1951-1954)'));
      expect(piece5P.getMotifsForYear(1953), contains('Año de Hidalgo - Bicentenario del Natalicio de Miguel Hidalgo'));
      expect(piece5P.getMotifsForYear(1955), contains('Hidalgo Chico (1955-1957)'));

      // USA 1 Dollar (Silver Dollar vs Gold Dollar)
      final usa1850 = NumismaticMatrix.findRule('Estados Unidos', 1850);
      expect(usa1850, isNotNull);
      final piece1Dollar = usa1850!.getPieceForDenomination('1', year: 1850);
      expect(piece1Dollar, isNotNull);
      expect(piece1Dollar!.effectiveAllowedMaterials, containsAll([NumismaticMaterialsRegistry.nameSilver900, NumismaticMaterialsRegistry.nameGold900]));
      expect(piece1Dollar.getMotifsForYear(1840).length, equals(1)); // Only Silver Dollar (1794-1857)
      expect(piece1Dollar.getMotifsForYear(1850).length, equals(2)); // Both Silver and Gold Dollar
    });

    test('commemorativeMotifsByDenomination preserves all multi-motif rules without overwrite', () {
      final mex1950 = NumismaticMatrix.findRule('México', 1950);
      expect(mex1950, isNotNull);
      final motifs5P = mex1950!.commemorativeMotifsByDenomination['5'];
      expect(motifs5P, isNotNull);
      expect(motifs5P!.length, equals(4));
    });
  });
}


