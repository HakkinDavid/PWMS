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

  static LocationBreadcrumb buildBreadcrumbPath(
    String? locationId,
    List<LocationNode> allNodes, {
    Map<String, LocationNode>? nodeMap,
  }) {
    if (locationId == null) {
      return const LocationBreadcrumb(ancestorPath: AppTechnicalStrings.empty, targetName: AppStrings.rootLocationName);
    }

    final map = nodeMap ?? {for (final n in allNodes) n.id: n};
    final List<String> nodeNames = [];
    String? currentId = locationId;

    while (currentId != null) {
      final node = map[currentId];
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
    Map<String, LocationNode>? nodeMap,
    Map<String, EntityRelation>? parentRelMap,
    Map<String, WorldEntity>? entityMap,
    Map<String, CatalogItem>? speciesMap,
    Map<String, Subspecies>? subspeciesMap,
  }) {
    if (entityId == null) {
      return buildBreadcrumbPath(effectiveLocationId, allNodes, nodeMap: nodeMap);
    }

    final pRelMap = parentRelMap ?? () {
      final map = <String, EntityRelation>{};
      for (final r in allRelations) {
        if (LocationResolver.locationInheritingTypes.contains(r.relationType)) {
          map.putIfAbsent(r.sourceEntityId, () => r);
        }
      }
      return map;
    }();
    final eMap = entityMap ?? {for (final e in allEntities) e.id: e};
    final sMap = speciesMap ?? {for (final s in catalogItems) s.id: s};
    final subMap = subspeciesMap ??
        (subspeciesList != null ? {for (final sub in subspeciesList) sub.id: sub} : null);

    // Trace container chain up
    final List<String> containerNames = [];
    final Set<String> visited = {entityId};
    String currentId = entityId;

    while (true) {
      final parentRel = pRelMap[currentId];
      if (parentRel == null) break;

      final targetId = parentRel.targetEntityId;
      if (visited.contains(targetId)) break;
      visited.add(targetId);

      final targetEntity = eMap[targetId];
      if (targetEntity != null) {
        final targetSpecies = sMap[targetEntity.speciesId];
        Subspecies? targetSubspecies;
        final subId = targetEntity.subspeciesId;
        if (subId != null && subMap != null) {
          targetSubspecies = subMap[subId];
        }
        final baseName = EntityDisplayHelper.getDisplayNameWithLookups(
          entity: targetEntity,
          species: targetSpecies,
          subspecies: targetSubspecies,
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
      final outermostEntity = eMap[currentId];
      resolvedPhysicalLocId = outermostEntity?.locationId;
    }

    final physicalBreadcrumb = buildBreadcrumbPath(resolvedPhysicalLocId, allNodes, nodeMap: nodeMap);

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
