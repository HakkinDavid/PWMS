import 'package:platinum_world_management_system/src/core/constants/app_technical_strings.dart';
import '../../entities/domain/world_entity.dart';
import '../../relations/domain/entity_relation.dart';

class LocationResolver {
  LocationResolver._();

  /// Relation types that transmit location inheritance recursively
  static const Set<String> locationInheritingTypes = {
    AppTechnicalStrings.relGuardadoEn,
    AppTechnicalStrings.relParteDe,
  };

  /// Resolves the effective location ID for [entityId] by inspecting relations and direct locations.
  /// 
  /// - [directLocations]: Map of entityId -> direct locationId (from InstanceLocationsTable)
  /// - [relations]: List of all entity relations
  /// Resolves the effective location ID for [entityId] by inspecting relations and direct locations.
  /// 
  /// - [directLocations]: Map of entityId -> direct locationId (from InstanceLocationsTable)
  /// - [relations]: List of all entity relations
  /// - [parentContainerMap]: Optional pre-indexed map of sourceEntityId -> targetEntityId for O(1) lookups
  static String? getEffectiveLocationId({
    required String entityId,
    required Map<String, String?> directLocations,
    required List<EntityRelation> relations,
    Map<String, String>? parentContainerMap,
  }) {
    final parentMap = parentContainerMap ?? {
      for (final r in relations)
        if (locationInheritingTypes.contains(r.relationType))
          r.sourceEntityId: r.targetEntityId,
    };

    final Set<String> visited = {entityId};
    String currentId = entityId;

    while (true) {
      final targetId = parentMap[currentId];

      if (targetId == null) {
        // Not contained in any entity -> return its direct physical location
        return directLocations[currentId];
      }

      // Cycle detection
      if (visited.contains(targetId)) {
        // Cycle detected: fallback to direct location of currentId
        return directLocations[currentId];
      }

      visited.add(targetId);
      currentId = targetId;
    }
  }

  /// Evaluates effective location IDs for a list of entities.
  static Map<String, String?> resolveAllEffectiveLocations({
    required List<WorldEntity> entities,
    required Map<String, String?> directLocations,
    required List<EntityRelation> relations,
  }) {
    final parentMap = {
      for (final r in relations)
        if (locationInheritingTypes.contains(r.relationType))
          r.sourceEntityId: r.targetEntityId,
    };

    final Map<String, String?> result = {};
    for (final entity in entities) {
      result[entity.id] = getEffectiveLocationId(
        entityId: entity.id,
        directLocations: directLocations,
        relations: relations,
        parentContainerMap: parentMap,
      );
    }
    return result;
  }

  /// Checks if adding a location-inheriting relation from [sourceId] to [targetId] would create a cycle.
  /// Returns `true` if a cycle would be formed.
  static bool detectCircularContainment({
    required String sourceId,
    required String targetId,
    required List<EntityRelation> relations,
  }) {
    if (sourceId == targetId) return true;

    final parentMap = {
      for (final r in relations)
        if (locationInheritingTypes.contains(r.relationType))
          r.sourceEntityId: r.targetEntityId,
    };

    final Set<String> visited = {targetId};
    String currentId = targetId;

    while (true) {
      if (currentId == sourceId) return true;

      final nextTarget = parentMap[currentId];
      if (nextTarget == null) return false;
      if (visited.contains(nextTarget)) return true;

      visited.add(nextTarget);
      currentId = nextTarget;
    }
  }

  /// Gets all entity IDs transitively contained within [containerId] (direct + indirect children).
  static Set<String> getContainedEntityIds({
    required String containerId,
    required List<EntityRelation> relations,
  }) {
    final Map<String, List<String>> childrenByContainer = {};
    for (final r in relations) {
      if (locationInheritingTypes.contains(r.relationType)) {
        childrenByContainer.putIfAbsent(r.targetEntityId, () => []).add(r.sourceEntityId);
      }
    }

    final Set<String> containedIds = {};
    final List<String> queue = [containerId];

    while (queue.isNotEmpty) {
      final currentContainer = queue.removeAt(0);
      final children = childrenByContainer[currentContainer] ?? const [];

      for (final childId in children) {
        if (!containedIds.contains(childId)) {
          containedIds.add(childId);
          queue.add(childId);
        }
      }
    }

    return containedIds;
  }
}
