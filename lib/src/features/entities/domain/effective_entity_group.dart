import 'world_entity.dart';

class EffectiveEntityGroup {
  final String key;
  final String speciesId;
  final String? effectiveLocationId;
  final List<WorldEntity> entities;

  EffectiveEntityGroup({
    required this.key,
    required this.speciesId,
    required this.effectiveLocationId,
    required this.entities,
  });

  int get population => entities.length;

  WorldEntity get primaryEntity => entities.first;

  /// Determines the majority demographic archetype in the group (the most common profile of notes/magnitudes)
  WorldEntity get majorityEntity {
    if (entities.isEmpty) throw StateError('Group is empty');
    final Map<String, List<WorldEntity>> demographicMap = {};

    for (final e in entities) {
      final magSig = e.magnitudes.map((m) => '${m.propertyName}:${m.magnitudeValue}${m.unitSymbol}').join('|');
      final signature = '${e.notes ?? ""}_$magSig';
      demographicMap.putIfAbsent(signature, () => []).add(e);
    }

    List<WorldEntity> largestGroup = entities;
    int maxCount = 0;
    for (final groupList in demographicMap.values) {
      if (groupList.length > maxCount) {
        maxCount = groupList.length;
        largestGroup = groupList;
      }
    }

    return largestGroup.first;
  }

  /// Gets all instances matching the majority demographic
  List<WorldEntity> get majorityInstances {
    if (entities.isEmpty) return [];
    final majoritySig = '${majorityEntity.notes ?? ""}_${majorityEntity.magnitudes.map((m) => '${m.propertyName}:${m.magnitudeValue}${m.unitSymbol}').join('|')}';
    return entities.where((e) {
      final sig = '${e.notes ?? ""}_${e.magnitudes.map((m) => '${m.propertyName}:${m.magnitudeValue}${m.unitSymbol}').join('|')}';
      return sig == majoritySig;
    }).toList();
  }

  static List<EffectiveEntityGroup> groupEntities({
    required List<WorldEntity> entities,
    required Map<String, String?> effectiveLocationMap,
  }) {
    final Map<String, List<WorldEntity>> grouped = {};

    for (final entity in entities) {
      final locId = effectiveLocationMap[entity.id] ?? entity.locationId;
      final groupKey = '${entity.speciesId}_${locId ?? "root"}';

      if (!grouped.containsKey(groupKey)) {
        grouped[groupKey] = [];
      }
      grouped[groupKey]!.add(entity);
    }

    return grouped.entries.map((entry) {
      final first = entry.value.first;
      final locId = effectiveLocationMap[first.id] ?? first.locationId;
      return EffectiveEntityGroup(
        key: entry.key,
        speciesId: first.speciesId,
        effectiveLocationId: locId,
        entities: entry.value,
      );
    }).toList();
  }
}
