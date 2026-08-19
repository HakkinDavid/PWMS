import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:platinum_world_management_system/src/core/database/app_database.dart';
import '../../catalog/domain/catalog_item.dart';
import '../../catalog/domain/species_magnitude.dart';
import '../../catalog/domain/species_requirement.dart';
import '../../catalog/domain/subspecies.dart';
import '../../entities/domain/instance_magnitude.dart';
import '../../entities/domain/world_entity.dart';
import '../../locations/domain/location_node.dart';
import '../../relations/domain/entity_relation.dart';

enum AuditCardType {
  uninstantiatedSubspecies,
  locationVerification,
  ownershipCheck,
  expirationAudit,
  orphanEntity,
  incompleteSpeciesInfo,
  remoteImageAudit,
  numismaticSubspeciesIncongruity,
  numismaticDuplicateSubspecies,
  numismaticAttachmentIncongruity,
  numismaticMissingMagnitudes,
  emptyDataAudit,
  locationConflict,
  cyclicContainment,
  uniquenessViolation,
  perishableMissingExpiration,
  nonPerishableWithExpiration,
  subgroupRuleViolation,
  missingMandatoryMagnitudes,
  uninstantiatedSpecies,
  anomalousMagnitude,
}

class AuditCardData {
  final String id;
  final AuditCardType type;
  final String title;
  final String subtitle;
  final String question;
  final IconData icon;
  final Color themeColor;
  final Widget tile;
  final CatalogItem? species;
  final Subspecies? subspecies;
  final WorldEntity? entity;
  final Future<bool> Function(BuildContext context, WidgetRef ref) onConfirm;
  final Future<bool> Function(BuildContext context, WidgetRef ref) onFix;

  AuditCardData({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.question,
    required this.icon,
    required this.themeColor,
    required this.tile,
    this.species,
    this.subspecies,
    this.entity,
    required this.onConfirm,
    required this.onFix,
  });
}

class AuditEvaluationContext {
  final AppDatabase db;
  final List<WorldEntity> allEntities;
  final List<CatalogItem> allCatalog;
  final List<Subspecies> allSubspecies;
  final List<EntityRelation> allRelations;
  final List<LocationNode> allLocations;
  final List<SpeciesMagnitude> allSpeciesMagnitudes;
  final List<InstanceMagnitude> allInstanceMagnitudes;
  final List<SpeciesRequirement> allRequirements;
  final Map<String, String?> effectiveLocationMap;

  const AuditEvaluationContext({
    required this.db,
    required this.allEntities,
    required this.allCatalog,
    required this.allSubspecies,
    required this.allRelations,
    required this.allLocations,
    required this.allSpeciesMagnitudes,
    required this.allInstanceMagnitudes,
    required this.allRequirements,
    required this.effectiveLocationMap,
  });
}

abstract class IAuditRuleStrategy {
  AuditCardType get cardType;
  String get ruleId;

  Future<List<AuditCardData>> evaluate(AuditEvaluationContext context);
}
