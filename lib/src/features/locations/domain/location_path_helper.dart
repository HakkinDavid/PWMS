import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import 'package:platinum_world_management_system/src/core/constants/app_technical_strings.dart';
import '../../catalog/domain/catalog_item.dart';
import '../../catalog/domain/subspecies.dart';
import '../../entities/domain/entity_display_helper.dart';
import '../../entities/domain/world_entity.dart';
import '../../relations/domain/entity_relation.dart';
import 'location_node.dart';
import 'location_resolver.dart';

class LocationBreadcrumb {
  final String ancestorPath;
  final String targetName;

  const LocationBreadcrumb({
    required this.ancestorPath,
    required this.targetName,
  });

  String get fullPath => AppTechnicalStrings.formatBreadcrumbFullPath(ancestorPath, targetName);
}

class LocationPathHelper {
  LocationPathHelper._();

  static LocationBreadcrumb buildBreadcrumbPath(String? locationId, List<LocationNode> allNodes) {
    if (locationId == null) {
      return const LocationBreadcrumb(ancestorPath: AppTechnicalStrings.empty, targetName: AppStrings.rootLocationName);
    }

    final List<String> nodeNames = [];
    String? currentId = locationId;

    while (currentId != null) {
      final node = allNodes.where((n) => n.id == currentId).firstOrNull;
      if (node != null) {
        nodeNames.insert(0, node.name);
        currentId = node.parentLocationId;
      } else {
        break;
      }
    }

    if (nodeNames.isEmpty) {
      return const LocationBreadcrumb(ancestorPath: AppTechnicalStrings.empty, targetName: AppStrings.rootLocationName);
    }

    final targetName = nodeNames.last;
    final ancestors = [AppStrings.rootLocationName, ...nodeNames.sublist(0, nodeNames.length - 1)];
    final ancestorPath = AppTechnicalStrings.formatBreadcrumbAncestorPath(ancestors);

    return LocationBreadcrumb(
      ancestorPath: ancestorPath,
      targetName: targetName,
    );
  }

  /// Builds a complete effective breadcrumb path combining physical Location Graph nodes
  /// and recursive container relationships (GUARDADO_EN / PARTE_DE) using the `@` delimiter.
  /// 
  /// Format example: `Casa > Cocina @ Refrigerador` or `Casa > Habitación @ Mochila > Bolsa > Cartera`
  static LocationBreadcrumb buildEffectiveBreadcrumb({
    required String? entityId,
    required String? effectiveLocationId,
    required List<WorldEntity> allEntities,
    required List<EntityRelation> allRelations,
    required List<LocationNode> allNodes,
    required List<CatalogItem> catalogItems,
    List<Subspecies>? subspeciesList,
  }) {
    if (entityId == null) {
      return buildBreadcrumbPath(effectiveLocationId, allNodes);
    }

    // Trace container chain up
    final List<String> containerNames = [];
    final Set<String> visited = {entityId};
    String currentId = entityId;

    while (true) {
      final parentRel = allRelations.where((r) =>
        r.sourceEntityId == currentId &&
        LocationResolver.locationInheritingTypes.contains(r.relationType)
      ).firstOrNull;

      if (parentRel == null) break;

      final targetId = parentRel.targetEntityId;
      if (visited.contains(targetId)) break;
      visited.add(targetId);

      final targetEntity = allEntities.where((e) => e.id == targetId).firstOrNull;
      if (targetEntity != null) {
        final baseName = EntityDisplayHelper.getDisplayName(
          entity: targetEntity,
          catalogItems: catalogItems,
          subspeciesList: subspeciesList,
        );
        final name = targetEntity.notes != null && targetEntity.notes!.isNotEmpty
            ? AppTechnicalStrings.formatEntityWithNotes(baseName, targetEntity.notes!)
            : baseName;
        containerNames.insert(0, name);
      }

      currentId = targetId;
    }

    String? resolvedPhysicalLocId = effectiveLocationId;
    if (resolvedPhysicalLocId == null && currentId != entityId) {
      final outermostEntity = allEntities.where((e) => e.id == currentId).firstOrNull;
      resolvedPhysicalLocId = outermostEntity?.locationId;
    }

    final physicalBreadcrumb = buildBreadcrumbPath(resolvedPhysicalLocId, allNodes);

    if (containerNames.isEmpty) {
      return physicalBreadcrumb;
    }

    final physicalFull = physicalBreadcrumb.fullPath;
    final containerChainStr = containerNames.join(AppTechnicalDelimiters.greaterThanWithSpaces);

    return LocationBreadcrumb(
      ancestorPath: AppTechnicalStrings.formatEffectiveBreadcrumbAncestor(physicalFull),
      targetName: containerChainStr,
    );
  }
}
