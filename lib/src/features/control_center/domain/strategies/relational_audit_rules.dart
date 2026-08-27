import 'package:flutter/material.dart';
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
  String get ruleId => 'relational_orphan_entity';

  @override
  Future<List<AuditCardData>> evaluate(AuditEvaluationContext context) async {
    final orphanEntities = context.allEntities.where((e) =>
      e.locationId == null &&
      !context.allRelations.any((r) => r.sourceEntityId == e.id && r.relationType == 'GUARDADO_EN')
    ).take(10);

    final cards = <AuditCardData>[];
    for (final entity in orphanEntities) {
      final species = context.allCatalog.where((c) => c.id == entity.speciesId).firstOrNull;
      final displayName = AuditRuleHelper.getEntityDisplayName(context, entity);
      final breadcrumb = AuditRuleHelper.getEntityBreadcrumb(context, entity);

      cards.add(AuditRuleHelper.forEntity(
        id: 'orphan_${entity.id}',
        type: AuditCardType.orphanEntity,
        title: 'Instancia sin Ubicación ni Contenedor',
        subtitle: '$displayName • Ubicación efectiva: ${breadcrumb.fullPath}',
        question: 'La instancia "$displayName" no tiene ubicación física ni contenedor asignado. ¿Asignarle una ubicación o contenedor ahora?',
        icon: Icons.wrong_location_outlined,
        themeColor: Colors.orangeAccent,
        entity: entity,
        species: species,
        confirmToastMessage: 'Ubicación mantenida como no asignada.',
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
  String get ruleId => 'relational_location_conflict';

  @override
  Future<List<AuditCardData>> evaluate(AuditEvaluationContext context) async {
    final conflictEntities = context.allEntities.where((e) {
      if (!context.effectiveLocationMap.containsKey(e.id)) return false;
      return context.allRelations.any((r) => r.sourceEntityId == e.id && r.relationType == 'GUARDADO_EN');
    }).take(8);

    final cards = <AuditCardData>[];
    for (final entity in conflictEntities) {
      final species = context.allCatalog.where((c) => c.id == entity.speciesId).firstOrNull;
      final containerRel = context.allRelations.where((r) => r.sourceEntityId == entity.id && r.relationType == 'GUARDADO_EN').first;
      final containerEntity = context.allEntities.where((e) => e.id == containerRel.targetEntityId).firstOrNull;
      final containerSpecies = context.allCatalog.where((c) => c.id == containerEntity?.speciesId).firstOrNull;
      final containerName = containerSpecies?.name ?? 'Contenedor';
      final directLocId = context.effectiveLocationMap[entity.id];
      final directLoc = context.allLocations.where((l) => l.id == directLocId).firstOrNull;
      final directLocName = directLoc?.name ?? 'Ubicación directa';

      final displayName = AuditRuleHelper.getEntityDisplayName(context, entity);

      cards.add(AuditRuleHelper.forEntity(
        id: 'conflict_${entity.id}',
        type: AuditCardType.locationConflict,
        title: 'Conflicto de Ubicación en Contenedor',
        subtitle: '$displayName • En: $containerName & $directLocName',
        question: 'La instancia "$displayName" está guardada en "$containerName" pero también tiene asignada la ubicación directa "$directLocName". ¿Cómo deseas resolver la redundancia?',
        icon: Icons.alt_route,
        themeColor: Colors.purpleAccent,
        entity: entity,
        species: species,
        confirmToastMessage: 'Conflicto de ubicación omitido.',
        onFix: (ctx, ref) async {
          final choice = await showDialog<String>(
            context: ctx,
            builder: (dialogCtx) => AlertDialog(
              title: const Text('Resolver ubicación'),
              content: Text(
                'El elemento "$displayName" tiene doble asignación:\n\n'
                '• Contenedor: $containerName\n'
                '• Ubicación directa: $directLocName\n\n'
                '¿Cómo deseas resolverlo?'
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(dialogCtx, 'cancel'), child: const Text('Cancelar')),
                OutlinedButton(
                  onPressed: () => Navigator.pop(dialogCtx, 'keep_container'),
                  child: const Text('Solo en Contenedor'),
                ),
                OutlinedButton(
                  onPressed: () => Navigator.pop(dialogCtx, 'keep_direct'),
                  child: const Text('Solo Ubicación Directa'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(dialogCtx, 'reassign'),
                  child: const Text('Reasignar'),
                ),
              ],
            ),
          );

          if (choice == 'keep_container') {
            final freshEntity = await ref.read(entityRepositoryProvider).getEntityById(entity.id) ?? entity;
            await ref.read(entityRepositoryProvider).saveEntity(freshEntity.copyWith(locationId: null));
            if (ctx.mounted) {
              AppToast.showSuccess(ctx, 'Ubicación directa removida. Conservado en contenedor.');
            }
            return true;
          } else if (choice == 'keep_direct') {
            await ref.read(relationRepositoryProvider).deleteRelation(containerRel.id);
            if (ctx.mounted) {
              AppToast.showSuccess(ctx, 'Elemento retirado del contenedor.');
            }
            return true;
          } else if (choice == 'reassign') {
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
  String get ruleId => 'relational_cyclic_containment';

  @override
  Future<List<AuditCardData>> evaluate(AuditEvaluationContext context) async {
    final circularRels = context.allRelations.where((r) {
      if (r.sourceEntityId == r.targetEntityId) return true;
      if (r.relationType == 'GUARDADO_EN') {
        return context.allRelations.any((r2) =>
            r2.sourceEntityId == r.targetEntityId &&
            r2.targetEntityId == r.sourceEntityId &&
            r2.relationType == 'GUARDADO_EN');
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
        id: 'circ_${rel.id}',
        type: AuditCardType.cyclicContainment,
        title: 'Relación circular',
        subtitle: '${sourceSp?.name ?? "Origen"} ➔ ${targetSp?.name ?? "Destino"} (${rel.relationType})',
        question: 'Se detectó una relación circular o auto-referencia inválida entre "${sourceSp?.name}" y "${targetSp?.name}". ¿Deseas eliminar la relación conflictiva?',
        icon: Icons.loop,
        themeColor: Colors.redAccent,
        entity: sourceEnt,
        species: sourceSp,
        tile: sourceEnt != null ? InstancePreviewCard(entity: sourceEnt) : const SizedBox.shrink(),
        confirmToastMessage: 'Relación circular conservada.',
        onFix: (ctx, ref) async {
          final confirm = await AuditRuleHelper.showConfirmationDialog(
            ctx,
            title: 'Eliminar relación inválida',
            content: '¿Confirmas que deseas eliminar esta relación conflictiva?',
            confirmLabel: 'Eliminar Relación',
            isDestructive: true,
          );

          if (confirm) {
            await ref.read(relationRepositoryProvider).deleteRelation(rel.id);
            if (ctx.mounted) {
              AppToast.showSuccess(ctx, 'Relación conflictiva eliminada.');
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
  String get ruleId => 'relational_ownership_check';

  @override
  Future<List<AuditCardData>> evaluate(AuditEvaluationContext context) async {
    final sampleEntities = (context.allEntities.toList()..shuffle()).take(8);
    final cards = <AuditCardData>[];

    for (final entity in sampleEntities) {
      final species = context.allCatalog.where((c) => c.id == entity.speciesId).firstOrNull;
      final displayName = AuditRuleHelper.getEntityDisplayName(context, entity);
      final breadcrumb = AuditRuleHelper.getEntityBreadcrumb(context, entity);

      cards.add(AuditRuleHelper.forEntity(
        id: 'own_${entity.id}',
        type: AuditCardType.ownershipCheck,
        title: '¿Conservas este objeto?',
        subtitle: '$displayName • Ubicación efectiva: ${breadcrumb.fullPath}',
        question: '¿Aún conservas la instancia "$displayName" en su ubicación efectiva "${breadcrumb.fullPath}"?',
        icon: Icons.inventory_outlined,
        themeColor: Colors.blueAccent,
        entity: entity,
        species: species,
        confirmToastMessage: 'Instancia confirmada en inventario.',
        onFix: (ctx, ref) async {
          final choice = await showDialog<String>(
            context: ctx,
            builder: (dialogCtx) => AlertDialog(
              title: const Text('Corregir Instancia'),
              content: Text('¿Qué acción deseas realizar sobre la instancia "$displayName"?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogCtx, 'cancel'),
                  child: const Text('Cancelar'),
                ),
                OutlinedButton.icon(
                  onPressed: () => Navigator.pop(dialogCtx, 'location'),
                  icon: const Icon(Icons.edit_location_alt_outlined),
                  label: const Text('Corregir Ubicación / Contenedor'),
                ),
                TextButton.icon(
                  onPressed: () => Navigator.pop(dialogCtx, 'delete'),
                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                  label: const Text('Eliminar de Inventario', style: TextStyle(color: Colors.redAccent)),
                ),
              ],
            ),
          );

          if (choice == 'location') {
            return await AuditRuleHelper.openLocationCorrection(ctx, ref, entityId: entity.id, fallback: entity);
          } else if (choice == 'delete') {
            final confirmDelete = await AuditRuleHelper.showConfirmationDialog(
              ctx,
              title: 'Dar de Baja Instancia',
              content: '¿Confirmas que deseas eliminar del inventario esta instancia de "$displayName"?',
              confirmLabel: 'Eliminar Instancia',
              isDestructive: true,
            );

            if (confirmDelete) {
              await ref.read(entityRepositoryProvider).deleteEntity(entity.id);
              if (ctx.mounted) {
                AppToast.showSuccess(ctx, 'Instancia dada de baja.');
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
  String get ruleId => 'relational_location_verification';

  @override
  Future<List<AuditCardData>> evaluate(AuditEvaluationContext context) async {
    final locationCheckSample = (context.allEntities.where((e) => e.locationId != null).toList()..shuffle()).take(6);
    final cards = <AuditCardData>[];

    for (final entity in locationCheckSample) {
      final species = context.allCatalog.where((c) => c.id == entity.speciesId).firstOrNull;
      final displayName = AuditRuleHelper.getEntityDisplayName(context, entity);
      final breadcrumb = AuditRuleHelper.getEntityBreadcrumb(context, entity);

      cards.add(AuditRuleHelper.forEntity(
        id: 'loc_verif_${entity.id}',
        type: AuditCardType.locationVerification,
        title: '¿Has movido este objeto?',
        subtitle: '$displayName • Ubicación registrada: ${breadcrumb.fullPath}',
        question: '¿La ubicación efectiva actual de "$displayName" sigue siendo exactamente "${breadcrumb.fullPath}"?',
        icon: Icons.edit_location_alt_outlined,
        themeColor: Colors.teal,
        entity: entity,
        species: species,
        confirmToastMessage: 'Ubicación confirmada.',
        onFix: (ctx, ref) => AuditRuleHelper.openLocationCorrection(ctx, ref, entityId: entity.id, fallback: entity),
      ));
    }
    return cards;
  }
}

