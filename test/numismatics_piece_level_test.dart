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
        commonName: 'Cuauhtémoc',
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
      );
      expect(pieceCuartilla.matchesDenomination('1/4'), isTrue);
      expect(pieceCuartilla.matchesDenomination('0.25'), isTrue);
      expect(pieceCuartilla.matchesDenomination('1/2'), isFalse);

      const pieceOctavo = NumismaticPieceDefinition(
        denomination: '1/8',
        material: 'Cobre',
      );
      expect(pieceOctavo.matchesDenomination('1/8'), isTrue);
      expect(pieceOctavo.matchesDenomination('0.125'), isTrue);

      const piece50c = NumismaticPieceDefinition(
        denomination: '0.50',
        material: 'Bronce',
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
      );
      expect(singleMatPiece.effectiveAllowedMaterials, equals(['Plata']));

      const multiMatPiece = NumismaticPieceDefinition(
        denomination: '100',
        material: 'Polímero',
        allowedMaterials: ['Polímero', 'Papel de algodón'],
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
  });

  group('NumismaticEmissionRuleData Piece-Level Granularity Tests', () {
    test('synthesizes pieces seamlessly from legacy definitions', () {
      const rule = NumismaticEmissionRuleData(
        country: 'México',
        minYear: 1993,
        maxYear: 1995,
        validCurrencies: ['MXN'],
        defaultCurrency: 'MXN',
        denominations: ['10', '20', '50'],
        denominationMaterials: {
          '10': 'Plata / Aluminio-Bronce',
          '20': 'Plata / Latón',
          '50': 'Plata / Latón',
        },
      );

      expect(rule.effectivePieces.length, equals(3));
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
            commonName: 'Centavito Porfiriano',
          ),
          NumismaticPieceDefinition(
            denomination: '0.50',
            minYear: 1955,
            maxYear: 1959,
            material: 'Bronce',
            commonName: 'Cuauhtémoc',
          ),
          NumismaticPieceDefinition(
            denomination: '1',
            minYear: 1957,
            maxYear: 1967,
            material: 'Plata .100',
            commonName: 'Morelos Tepalcate',
          ),
        ],
      );

      expect(rule.getDenominationsForYear(1910), equals(['0.01']));
      expect(rule.getDenominationsForYear(1957), equals(['0.50', '1']));
      expect(rule.getDenominationsForYear(1965), equals(['1']));
      expect(rule.getPieceForDenomination('0.50', year: 1957)?.commonName, equals('Cuauhtémoc'));
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
      expect(result.availableMotifs, contains('Bicentenario de la Independencia Nacional (2021)'));
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
}
