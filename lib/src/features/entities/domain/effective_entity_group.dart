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

  int expiredCount({bool canExpire = true, DateTime? now}) =>
      entities.where((e) => e.isExpired(canExpire: canExpire, now: now)).length;

  int expiringSoonCount({required int warningDays, bool canExpire = true, DateTime? now}) =>
      entities.where((e) => e.isExpiringSoon(warningDays: warningDays, canExpire: canExpire, now: now)).length;

  int validCount({bool canExpire = true, DateTime? now}) =>
      entities.where((e) => e.isValid(canExpire: canExpire, now: now)).length;

  WorldEntity get primaryEntity => entities.first;

  /// Evalúa si el grupo es estrictamente homogéneo (Requisito 5)
  /// Todos los elementos deben compartir la misma subespecie, misma ubicación y magnitudes idénticas (salvo fecha de caducidad).
  bool get isHomogeneous {
    if (entities.length <= 1) return true;
    final firstSubId = primaryEntity.subspeciesId;
    final firstMagSig = _magnitudeSignature(primaryEntity);
    final firstNotes = primaryEntity.notes ?? '';

    for (final e in entities) {
      if (e.subspeciesId != firstSubId) return false;
      if (_magnitudeSignature(e) != firstMagSig) return false;
      if ((e.notes ?? '') != firstNotes) return false;
    }
    return true;
  }

  static String _magnitudeSignature(WorldEntity entity) {
    final sorted = List.of(entity.magnitudes)..sort((a, b) => a.propertyName.compareTo(b.propertyName));
    return sorted.map((m) => '${m.propertyName}:${m.displayValue}').join('|');
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
