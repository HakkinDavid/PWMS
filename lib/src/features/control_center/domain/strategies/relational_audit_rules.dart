import 'package:flutter/material.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import 'package:platinum_world_management_system/src/core/constants/app_technical_strings.dart';
import 'package:platinum_world_management_system/src/core/providers/providers.dart';
import 'package:platinum_world_management_system/src/core/widgets/app_toast.dart';
import '../../../entities/presentation/instance_preview_card.dart';
import '../audit_rule_strategy.dart';
import 'audit_rule_helper.dart';

/// Strategy 1: Instancia huérfana (sin ubicación directa ni contenedor)
class OrphanEntityStrategy implements IAuditRuleStrategy {
  const OrphanEntityStrategy();

  @override
  AuditCardType get cardType => AuditCardType.orphanEntity;

  @override
  String get ruleId => AppTechnicalStrings.ruleRelationalOrphanEntity;

  @override
  AuditCategory get category => AuditCategory.integrity;

  @override
  Future<List<AuditCardData>> evaluate(AuditEvaluationContext context) async {
    final orphanEntities = context.allEntities.where((e) =>
      e.locationId == null &&
      !context.allRelations.any((r) => r.sourceEntityId == e.id && r.relationType == AppTechnicalStrings.relGuardadoEn)
    ).take(10);

    final cards = <AuditCardData>[];
    for (final entity in orphanEntities) {
      final species = context.allCatalog.where((c) => c.id == entity.speciesId).firstOrNull;
      final displayName = AuditRuleHelper.getEntityDisplayName(context, entity);
      final breadcrumb = AuditRuleHelper.getEntityBreadcrumb(context, entity);

      cards.add(AuditRuleHelper.forEntity(
        id: AppTechnicalStrings.prefixOrphan + entity.id,
        type: AuditCardType.orphanEntity,
        title: AppStrings.orphanEntityTitle,
        subtitle: AppStrings.orphanEntitySubtitle(displayName, breadcrumb.fullPath),
        question: AppStrings.orphanEntityQuestion(displayName),
        icon: Icons.wrong_location_outlined,
        themeColor: Colors.orangeAccent,
        entity: entity,
        species: species,
        confirmLabel: AppStrings.confirmKeepUnassignedAction,
        fixLabel: AppStrings.fixAssignLocationAction,
        confirmToastMessage: AppStrings.locationKeptUnassigned,
        onFix: (ctx, ref) => AuditRuleHelper.openLocationCorrection(ctx, ref, entityId: entity.id, fallback: entity),
      ));
    }
    return cards;
  }
}

/// Strategy 2: Conflicto de Ubicación (Guardado en contenedor pero con registro directo en instance_locations_table)
class LocationConflictStrategy implements IAuditRuleStrategy {
  const LocationConflictStrategy();

  @override
  AuditCardType get cardType => AuditCardType.locationConflict;

  @override
  String get ruleId => AppTechnicalStrings.ruleRelationalLocationConflict;

  @override
  AuditCategory get category => AuditCategory.integrity;

  @override
  Future<List<AuditCardData>> evaluate(AuditEvaluationContext context) async {
    final conflictEntities = context.allEntities.where((e) {
      if (!context.effectiveLocationMap.containsKey(e.id)) return false;
      return context.allRelations.any((r) => r.sourceEntityId == e.id && r.relationType == AppTechnicalStrings.relGuardadoEn);
    }).take(8);

    final cards = <AuditCardData>[];
    for (final entity in conflictEntities) {
      final species = context.allCatalog.where((c) => c.id == entity.speciesId).firstOrNull;
      final containerRel = context.allRelations.where((r) => r.sourceEntityId == entity.id && r.relationType == AppTechnicalStrings.relGuardadoEn).first;
      final containerEntity = context.allEntities.where((e) => e.id == containerRel.targetEntityId).firstOrNull;
      final containerSpecies = context.allCatalog.where((c) => c.id == containerEntity?.speciesId).firstOrNull;
      final containerName = containerSpecies?.name ?? AppStrings.containerFallback;
      final directLocId = context.effectiveLocationMap[entity.id];
      final directLoc = context.allLocations.where((l) => l.id == directLocId).firstOrNull;
      final directLocName = directLoc?.name ?? AppStrings.directLocationFallback;

      final displayName = AuditRuleHelper.getEntityDisplayName(context, entity);

      cards.add(AuditRuleHelper.forEntity(
        id: AppTechnicalStrings.prefixConflict + entity.id,
        type: AuditCardType.locationConflict,
        title: AppStrings.relationalLocationConflictTitle,
        subtitle: AppStrings.locationConflictSubtitle(displayName, containerName, directLocName),
        question: AppStrings.locationConflictQuestion(displayName, containerName, directLocName),
        icon: Icons.alt_route,
        themeColor: Colors.purpleAccent,
        entity: entity,
        species: species,
        confirmLabel: AppStrings.confirmKeepConflictAction,
        fixLabel: AppStrings.fixResolveLocationAction,
        confirmToastMessage: AppStrings.locationConflictSkipped,
        onFix: (ctx, ref) async {
          final choice = await showDialog<String>(
            context: ctx,
            builder: (dialogCtx) => AlertDialog(
              title: const Text(AppStrings.resolveLocationTitle),
              content: Text(
                AppStrings.resolveLocationConflictPrompt(displayName, containerName, directLocName),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogCtx, AppTechnicalStrings.actionCancel),
                  child: const Text(AppStrings.cancel),
                ),
                OutlinedButton(
                  onPressed: () => Navigator.pop(dialogCtx, AppTechnicalStrings.actionKeepContainer),
                  child: const Text(AppStrings.onlyInContainerAction),
                ),
                OutlinedButton(
                  onPressed: () => Navigator.pop(dialogCtx, AppTechnicalStrings.actionKeepDirect),
                  child: const Text(AppStrings.onlyDirectLocationAction),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(dialogCtx, AppTechnicalStrings.actionReassign),
                  child: const Text(AppStrings.reassignLocationAction),
                ),
              ],
            ),
          );

          if (choice == AppTechnicalStrings.actionKeepContainer) {
            final freshEntity = await ref.read(entityRepositoryProvider).getEntityById(entity.id) ?? entity;
            await ref.read(entityRepositoryProvider).saveEntity(freshEntity.copyWith(locationId: null));
            if (ctx.mounted) {
              AppToast.showSuccess(ctx, AppStrings.directLocationRemovedKeptInContainerSuccess);
            }
            return true;
          } else if (choice == AppTechnicalStrings.actionKeepDirect) {
            await ref.read(relationRepositoryProvider).deleteRelation(containerRel.id);
            if (ctx.mounted) {
              AppToast.showSuccess(ctx, AppStrings.elementRemovedFromContainerSuccess);
            }
            return true;
          } else if (choice == AppTechnicalStrings.actionReassign) {
            return await AuditRuleHelper.openLocationCorrection(ctx, ref, entityId: entity.id, fallback: entity);
          }
          return false;
        },
      ));
    }
    return cards;
  }
}

/// Strategy 3: Relaciones Circulares o Auto-Referencias
class CyclicContainmentStrategy implements IAuditRuleStrategy {
  const CyclicContainmentStrategy();

  @override
  AuditCardType get cardType => AuditCardType.cyclicContainment;

  @override
  String get ruleId => AppTechnicalStrings.ruleRelationalCyclicContainment;

  @override
  AuditCategory get category => AuditCategory.integrity;

  @override
  Future<List<AuditCardData>> evaluate(AuditEvaluationContext context) async {
    final circularRels = context.allRelations.where((r) {
      if (r.sourceEntityId == r.targetEntityId) return true;
      if (r.relationType == AppTechnicalStrings.relGuardadoEn) {
        return context.allRelations.any((r2) =>
            r2.sourceEntityId == r.targetEntityId &&
            r2.targetEntityId == r.sourceEntityId &&
            r2.relationType == AppTechnicalStrings.relGuardadoEn);
      }
      return false;
    }).toList();

    final cards = <AuditCardData>[];
    for (final rel in circularRels) {
      final sourceEnt = context.allEntities.where((e) => e.id == rel.sourceEntityId).firstOrNull;
      final targetEnt = context.allEntities.where((e) => e.id == rel.targetEntityId).firstOrNull;
      final sourceSp = context.allCatalog.where((c) => c.id == sourceEnt?.speciesId).firstOrNull;
      final targetSp = context.allCatalog.where((c) => c.id == targetEnt?.speciesId).firstOrNull;

      cards.add(AuditRuleHelper.createCard(
        id: AppTechnicalStrings.prefixCirc + rel.id,
        type: AuditCardType.cyclicContainment,
        title: AppStrings.circularRelationTitle,
        subtitle: AppStrings.circularRelationSubtitle(
          sourceSp?.name ?? AppStrings.originFallback,
          targetSp?.name ?? AppStrings.destinationFallback,
          rel.relationType,
        ),
        question: AppStrings.circularRelationQuestion(
          sourceSp?.name ?? AppStrings.originFallback,
          targetSp?.name ?? AppStrings.destinationFallback,
        ),
        icon: Icons.loop,
        themeColor: Colors.redAccent,
        entity: sourceEnt,
        species: sourceSp,
        tile: sourceEnt != null ? InstancePreviewCard(entity: sourceEnt) : const SizedBox.shrink(),
        confirmLabel: AppStrings.confirmKeepRelationAction,
        fixLabel: AppStrings.fixDeleteRelationAction,
        confirmToastMessage: AppStrings.circularRelationKept,
        onFix: (ctx, ref) async {
          final confirm = await AuditRuleHelper.showConfirmationDialog(
            ctx,
            title: AppStrings.deleteInvalidRelationAction,
            content: AppStrings.confirmDeleteConflictingRelationMessage,
            confirmLabel: AppStrings.deleteRelationActionLabel,
            isDestructive: true,
          );

          if (confirm) {
            await ref.read(relationRepositoryProvider).deleteRelation(rel.id);
            if (ctx.mounted) {
              AppToast.showSuccess(ctx, AppStrings.conflictingRelationDeletedSuccess);
            }
            return true;
          }
          return false;
        },
      ));
    }
    return cards;
  }
}

/// Strategy 4: Auditoría de Posesión y Conservación
class OwnershipCheckStrategy implements IAuditRuleStrategy {
  const OwnershipCheckStrategy();

  @override
  AuditCardType get cardType => AuditCardType.ownershipCheck;

  @override
  String get ruleId => AppTechnicalStrings.ruleRelationalOwnershipCheck;

  @override
  AuditCategory get category => AuditCategory.routine;

  @override
  Future<List<AuditCardData>> evaluate(AuditEvaluationContext context) async {
    final sampleEntities = (context.allEntities.toList()..shuffle()).take(8);
    final cards = <AuditCardData>[];

    for (final entity in sampleEntities) {
      final species = context.allCatalog.where((c) => c.id == entity.speciesId).firstOrNull;
      final displayName = AuditRuleHelper.getEntityDisplayName(context, entity);
      final breadcrumb = AuditRuleHelper.getEntityBreadcrumb(context, entity);

      cards.add(AuditRuleHelper.forEntity(
        id: AppTechnicalStrings.prefixOwn + entity.id,
        type: AuditCardType.ownershipCheck,
        category: AuditCategory.routine,
        title: AppStrings.keepThisObjectQuestion,
        subtitle: AppStrings.ownershipCheckSubtitle(displayName, breadcrumb.fullPath),
        question: AppStrings.ownershipCheckQuestion(displayName, breadcrumb.fullPath),
        icon: Icons.inventory_outlined,
        themeColor: Colors.blueAccent,
        entity: entity,
        species: species,
        confirmLabel: AppStrings.confirmIKeepThisObject,
        fixLabel: AppStrings.fixRelocateOrManageAction,
        confirmToastMessage: AppStrings.instanceConfirmedInInventory,
        onFix: (ctx, ref) async {
          final choice = await showDialog<String>(
            context: ctx,
            builder: (dialogCtx) => AlertDialog(
              title: const Text(AppStrings.correctInstanceTitle),
              content: Text(AppStrings.whatActionForInstancePrompt(displayName)),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogCtx, AppTechnicalStrings.actionCancel),
                  child: const Text(AppStrings.cancel),
                ),
                OutlinedButton.icon(
                  onPressed: () => Navigator.pop(dialogCtx, AppTechnicalStrings.actionLocation),
                  icon: const Icon(Icons.edit_location_alt_outlined),
                  label: const Text(AppStrings.correctLocationOrContainerAction),
                ),
                TextButton.icon(
                  onPressed: () => Navigator.pop(dialogCtx, AppTechnicalStrings.actionDelete),
                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                  label: const Text(
                    AppStrings.deleteFromInventoryAction,
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ),
              ],
            ),
          );

          if (choice == AppTechnicalStrings.actionLocation) {
            return await AuditRuleHelper.openLocationCorrection(ctx, ref, entityId: entity.id, fallback: entity);
          } else if (choice == AppTechnicalStrings.actionDelete) {
            final confirmDelete = await AuditRuleHelper.showConfirmationDialog(
              ctx,
              title: AppStrings.deregisterInstanceTitle,
              content: AppStrings.confirmDeregisterInstanceMessage(displayName),
              confirmLabel: AppStrings.deregisterInstanceAction,
              isDestructive: true,
            );

            if (confirmDelete) {
              await ref.read(entityRepositoryProvider).deleteEntity(entity.id);
              if (ctx.mounted) {
                AppToast.showSuccess(ctx, AppStrings.instanceDeregisteredSuccess);
              }
              return true;
            }
          }
          return false;
        },
      ));
    }
    return cards;
  }
}

/// Strategy 5: Verificación Periódica de Ubicación
class LocationVerificationStrategy implements IAuditRuleStrategy {
  const LocationVerificationStrategy();

  @override
  AuditCardType get cardType => AuditCardType.locationVerification;

  @override
  String get ruleId => AppTechnicalStrings.ruleRelationalLocationVerification;

  @override
  AuditCategory get category => AuditCategory.routine;

  @override
  Future<List<AuditCardData>> evaluate(AuditEvaluationContext context) async {
    final locationCheckSample = (context.allEntities.where((e) => e.locationId != null).toList()..shuffle()).take(6);
    final cards = <AuditCardData>[];

    for (final entity in locationCheckSample) {
      final species = context.allCatalog.where((c) => c.id == entity.speciesId).firstOrNull;
      final displayName = AuditRuleHelper.getEntityDisplayName(context, entity);
      final breadcrumb = AuditRuleHelper.getEntityBreadcrumb(context, entity);

      cards.add(AuditRuleHelper.forEntity(
        id: AppTechnicalStrings.prefixLocVerif + entity.id,
        type: AuditCardType.locationVerification,
        category: AuditCategory.routine,
        title: AppStrings.haveYouMovedThisObjectQuestion,
        subtitle: AppStrings.locationVerificationSubtitle(displayName, breadcrumb.fullPath),
        question: AppStrings.locationVerificationQuestion(displayName, breadcrumb.fullPath),
        icon: Icons.edit_location_alt_outlined,
        themeColor: Colors.teal,
        entity: entity,
        species: species,
        confirmLabel: AppStrings.confirmItIsHere,
        fixLabel: AppStrings.fixRelocateAction,
        confirmToastMessage: AppStrings.locationConfirmedSuccess,
        onFix: (ctx, ref) => AuditRuleHelper.openLocationCorrection(ctx, ref, entityId: entity.id, fallback: entity),
      ));
    }
    return cards;
  }
}
