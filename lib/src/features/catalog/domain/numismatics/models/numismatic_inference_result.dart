import '../rules/numismatic_outlier_detector.dart';
import 'numismatic_emission_rule_data.dart';
import 'numismatic_piece_definition.dart';

/// Consolidated result of evaluating a numismatic query context in a single pass.
class NumismaticInferenceResult {
  final NumismaticEmissionRuleData? matchingEpoch;
  final NumismaticPieceDefinition? matchingPiece;
  final List<String> availableCurrencies;
  final String? inferredCurrency;
  final List<String> availableDenominations;
  final List<NumismaticPieceDefinition> availablePieces;
  final List<String> validMaterials;
  final String? inferredMaterial;
  final List<String> availableMotifs;
  final List<NumismaticEmissionOutlier> outliers;

  const NumismaticInferenceResult({
    this.matchingEpoch,
    this.matchingPiece,
    this.availableCurrencies = const [],
    this.inferredCurrency,
    this.availableDenominations = const [],
    this.availablePieces = const [],
    this.validMaterials = const [],
    this.inferredMaterial,
    this.availableMotifs = const [],
    this.outliers = const [],
  });
}
