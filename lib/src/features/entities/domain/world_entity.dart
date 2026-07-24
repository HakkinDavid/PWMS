import 'package:freezed_annotation/freezed_annotation.dart';
import 'instance_magnitude.dart';

part 'world_entity.freezed.dart';
part 'world_entity.g.dart';

@freezed
class WorldEntity with _$WorldEntity {
  const factory WorldEntity({
    required String id,
    required String speciesId, // Link to Catalog species
    String? subspeciesId, // Optional link to Subspecies variant
    String? locationId, // Link to Location Graph node
    @Default([]) List<InstanceMagnitude> magnitudes,
    DateTime? expirationDate,
    String? notes,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _WorldEntity;

  const WorldEntity._();

  bool isExpired({bool canExpire = true, DateTime? now}) {
    if (!canExpire || expirationDate == null) return false;
    final current = now ?? DateTime.now();
    return expirationDate!.isBefore(current);
  }

  bool isExpiringSoon({required int warningDays, bool canExpire = true, DateTime? now}) {
    if (!canExpire || expirationDate == null) return false;
    final current = now ?? DateTime.now();
    if (expirationDate!.isBefore(current)) return false; // Already expired
    final threshold = current.add(Duration(days: warningDays));
    return expirationDate!.isBefore(threshold) || expirationDate!.isAtSameMomentAs(threshold);
  }

  bool isValid({bool canExpire = true, DateTime? now}) {
    return !isExpired(canExpire: canExpire, now: now);
  }

  factory WorldEntity.fromJson(Map<String, dynamic> json) => _$WorldEntityFromJson(json);
}
