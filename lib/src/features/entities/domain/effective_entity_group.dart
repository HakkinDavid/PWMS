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
