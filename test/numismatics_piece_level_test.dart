import 'package:flutter_test/flutter_test.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/numismatics/models/numismatic_models.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/numismatics/numismatic_matrix.dart';

void main() {
  group('NumismaticPieceDefinition Unit Tests', () {
    test('matchesYear correctly evaluates boundaries and intervals', () {
      const piece = NumismaticPieceDefinition(
        denomination: '0.50',
        minYear: 1955,
        maxYear: 1959,
        material: 'Bronce',
        motifs: [
          NumismaticMotifRule('Cuauhtémoc', 1955, 1959),
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
        material: 'Plata',
        motifs: [
          NumismaticMotifRule('Cuartilla', 1800),
        ],
      );
      expect(pieceCuartilla.matchesDenomination('1/4'), isTrue);
      expect(pieceCuartilla.matchesDenomination('0.25'), isTrue);
      expect(pieceCuartilla.matchesDenomination('1/2'), isFalse);

      const pieceOctavo = NumismaticPieceDefinition(
        denomination: '1/8',
        material: 'Cobre',
        motifs: [
          NumismaticMotifRule('Octavo', 1800),
        ],
      );
      expect(pieceOctavo.matchesDenomination('1/8'), isTrue);
      expect(pieceOctavo.matchesDenomination('0.125'), isTrue);

      const piece50c = NumismaticPieceDefinition(
        denomination: '0.50',
        material: 'Bronce',
        motifs: [
          NumismaticMotifRule('50 Centavos', 1950),
        ],
      );
      expect(piece50c.matchesDenomination('0.50'), isTrue);
      expect(piece50c.matchesDenomination('0.5'), isTrue);
      expect(piece50c.matchesDenomination('1/2'), isTrue);
      expect(piece50c.matchesDenomination('0.20'), isFalse);
    });

    test('effectiveAllowedMaterials resolves primary and concurrent alloys', () {
      const singleMatPiece = NumismaticPieceDefinition(
        denomination: '1',
        material: 'Plata',
        motifs: [
          NumismaticMotifRule('Un Peso', 1900),
        ],
      );
      expect(singleMatPiece.effectiveAllowedMaterials, equals(['Plata']));

      const multiMatPiece = NumismaticPieceDefinition(
        denomination: '100',
        material: 'Polímero',
        allowedMaterials: ['Polímero', 'Papel de algodón'],
        motifs: [
          NumismaticMotifRule('Cien Pesos', 2020),
        ],
      );
      expect(multiMatPiece.effectiveAllowedMaterials, equals(['Polímero', 'Papel de algodón']));
    });

    test('getMotifsForYear filters temporally bounded motifs', () {
      const piece = NumismaticPieceDefinition(
        denomination: '100',
        motifs: [
          NumismaticMotifRule('Centenario de la Revolución Mexicana (2010)', 2009, 2010),
          NumismaticMotifRule('Centenario de la Constitución Política de 1917 (2017)', 2016, 2017),
        ],
      );

      expect(piece.getMotifsForYear(2010), equals(['Centenario de la Revolución Mexicana (2010)']));
      expect(piece.getMotifsForYear(2017), equals(['Centenario de la Constitución Política de 1917 (2017)']));
      expect(piece.getMotifsForYear(2014), isEmpty);
    });

    test('NumismaticMotifRule handles descriptive names, standard flag and year matching', () {
      const standardMotif = NumismaticMotifRule(
        'Lincoln Memorial (1959-2008)',
        2000,
        2008,
      );

      expect(standardMotif.name, equals('Lincoln Memorial (1959-2008)'));
      expect(standardMotif.matchesYear(2004), isTrue);
      expect(standardMotif.matchesYear(1999), isFalse);
      expect(standardMotif.matchesYear(2009), isFalse);
      expect(standardMotif.matchesYear(null), isTrue);

      const commemorativeMotif = NumismaticMotifRule(
        'Lincoln Bicentennial - Birthplace (2009)',
        2009,
      );
      expect(commemorativeMotif.minYear, equals(2009));
      expect(commemorativeMotif.maxYear, equals(2009));
      expect(commemorativeMotif.matchesYear(2009), isTrue);
      expect(commemorativeMotif.matchesYear(2010), isFalse);
    });
  });

  group('NumismaticEmissionRuleData Piece-Level Granularity Tests', () {
    test('supports piece definitions and derives denomination metadata correctly', () {
      const rule = NumismaticEmissionRuleData(
        country: 'México',
        minYear: 1993,
        maxYear: 1995,
        validCurrencies: ['MXN'],
        defaultCurrency: 'MXN',
        pieces: [
          NumismaticPieceDefinition(
            denomination: '10',
            material: 'Plata / Aluminio-Bronce',
            motifs: [NumismaticMotifRule('10 Nuevos Pesos', 1993, 1995)],
          ),
          NumismaticPieceDefinition(
            denomination: '20',
            material: 'Plata / Latón',
            motifs: [NumismaticMotifRule('20 Nuevos Pesos', 1993, 1995)],
          ),
          NumismaticPieceDefinition(
            denomination: '50',
            material: 'Plata / Latón',
            motifs: [NumismaticMotifRule('50 Nuevos Pesos', 1993, 1995)],
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
        minYear: 1905,
        maxYear: 1969,
        validCurrencies: ['MXP'],
        defaultCurrency: 'MXP',
        pieces: [
          NumismaticPieceDefinition(
            denomination: '0.01',
            minYear: 1905,
            maxYear: 1914,
            material: 'Cobre',
            motifs: [NumismaticMotifRule('Centavito Porfiriano', 1905, 1914)],
          ),
          NumismaticPieceDefinition(
            denomination: '0.50',
            minYear: 1955,
            maxYear: 1959,
            material: 'Bronce',
            motifs: [NumismaticMotifRule('Cuauhtémoc', 1955, 1959)],
          ),
          NumismaticPieceDefinition(
            denomination: '1',
            minYear: 1957,
            maxYear: 1967,
            material: 'Plata .100',
            motifs: [NumismaticMotifRule('Morelos Tepalcate', 1957, 1967)],
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
      expect(piece10?.effectiveAllowedMaterials, contains('Bimetálica'));

      final piece20 = mex92.getPieceForDenomination('20', year: 1993);
      expect(piece20?.effectiveAllowedMaterials, contains('Bimetálica'));

      final piece50 = mex92.getPieceForDenomination('50', year: 1993);
      expect(piece50?.effectiveAllowedMaterials, contains('Bimetálica'));

      final mex03 = NumismaticMatrix.findRule('México', 2005, isBanknote: false);
      expect(mex03, isNotNull);
      final piece100 = mex03!.getPieceForDenomination('100', year: 2005);
      expect(piece100?.effectiveAllowedMaterials, containsAll(['Bimetálica', 'Plata']));
    });

    test('All piece definitions in registry have canonical materials and valid allowedMaterials', () {
      final allRules = NumismaticMatrix.findRules('México', 2000)
          .followedBy(NumismaticMatrix.findRules('España', 2000))
          .followedBy(NumismaticMatrix.findRules('Estados Unidos', 2000));
      for (final r in allRules) {
        for (final p in r.pieces) {
          if (p.allowedMaterials.isNotEmpty && p.material != null) {
            expect(p.allowedMaterials, contains(p.material));
          }
        }
      }
    });
  });
}

