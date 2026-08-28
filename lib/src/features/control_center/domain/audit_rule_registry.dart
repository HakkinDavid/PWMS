import 'audit_rule_strategy.dart';
import 'strategies/catalog_audit_rules.dart';
import 'strategies/expiration_audit_rules.dart';
import 'strategies/numismatic_audit_rules.dart';
import 'strategies/relational_audit_rules.dart';
import 'strategies/unit_magnitude_audit_rules.dart';

class AuditRuleRegistry {
  final List<IAuditRuleStrategy> _strategies;

  AuditRuleRegistry([List<IAuditRuleStrategy>? strategies])
      : _strategies = strategies ?? const [
          // 1. Relational anomaly rules
          OrphanEntityStrategy(),
          LocationConflictStrategy(),
          CyclicContainmentStrategy(),
          // 2. Catalog anomaly rules
          UninstantiatedSubspeciesStrategy(),
          UniquenessViolationStrategy(),
          SubgroupRuleViolationStrategy(),
          UninstantiatedSpeciesStrategy(),
          IncompleteSpeciesInfoStrategy(),
          RemoteImageAuditStrategy(),
          // 3. Expiration and Magnitude rules
          PerishableMissingExpirationStrategy(),
          NonPerishableWithExpirationStrategy(),
          MissingMandatoryMagnitudesStrategy(),
          AnomalousMagnitudeStrategy(),
          // 4. Unit and Magnitude rules
          InvalidUnitSymbolStrategy(),
          IntegerUnitIncongruityStrategy(),
          NonNumericWithUnitStrategy(),
          NegativeMagnitudeViolationStrategy(),
          PropertyNameSuggestionIncongruityStrategy(),
          // 5. Numismatic rules
          NumismaticDuplicateSubspeciesStrategy(),
          NumismaticSubspeciesIncongruityStrategy(),
          NumismaticAttachmentIncongruityStrategy(),
          NumismaticMissingMagnitudesStrategy(),
          EmptyDataAuditStrategy(),
          // 6. Periodic verification sampling
          OwnershipCheckStrategy(),
          LocationVerificationStrategy(),
        ];

  List<IAuditRuleStrategy> get strategies => List.unmodifiable(_strategies);

  Future<List<AuditCardData>> evaluateAll(AuditEvaluationContext context) async {
    final List<AuditCardData> allCards = [];

    for (final strategy in _strategies) {
      final cards = await strategy.evaluate(context);
      allCards.addAll(cards);
    }

    return allCards;
  }
}
