import 'package:platinum_world_management_system/src/core/constants/app_technical_strings.dart';
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

  /// Todos los grupos producidos son 100% homogéneos (Requisito 5)
  bool get isHomogeneous => true;

  static String _magnitudeSignature(WorldEntity entity) {
    final sorted = List.of(entity.magnitudes)..sort((a, b) => a.propertyName.compareTo(b.propertyName));
    return sorted.map((m) => AppTechnicalStrings.magnitudePropertySignature(m.propertyName, m.displayValue)).join(AppTechnicalStrings.pipe);
  }

  static List<EffectiveEntityGroup> groupEntities({
    required List<WorldEntity> entities,
    required Map<String, String?> effectiveLocationMap,
    Set<String>? containerEntityIds,
  }) {
    final Map<String, List<WorldEntity>> grouped = {};

    for (final entity in entities) {
      final locId = effectiveLocationMap[entity.id] ?? entity.locationId;
      final isContainer = containerEntityIds != null && containerEntityIds.contains(entity.id);

      // Requisito 6: Los elementos que contengan a otros (recibidores de GUARDADO_EN) NO deben agruparse.
      // Permanecen como instancias únicas e independientes.
      if (isContainer) {
        final uniqueKey = AppTechnicalStrings.containerEntityKey(entity.id);
        grouped[uniqueKey] = [entity];
      } else {
        // Requisitos 5 y 6: Solo agrupar elementos homogéneos con idéntica ubicación efectiva,
        // misma subespecie, mismas magnitudes y notas idénticas.
        final subId = entity.subspeciesId ?? AppTechnicalStrings.keyGeneric;
        final magSig = _magnitudeSignature(entity);
        final notesKey = entity.notes?.trim() ?? AppTechnicalStrings.empty;
        final groupKey = AppTechnicalStrings.entityGroupKey(entity.speciesId, locId, subId, magSig, notesKey);

        if (!grouped.containsKey(groupKey)) {
          grouped[groupKey] = [];
        }
        grouped[groupKey]!.add(entity);
      }
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
