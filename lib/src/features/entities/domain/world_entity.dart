import 'package:freezed_annotation/freezed_annotation.dart';
import 'instance_magnitude.dart';

part 'world_entity.freezed.dart';
part 'world_entity.g.dart';

@freezed
class WorldEntity with _$WorldEntity {
  const factory WorldEntity({
    required String id,
    required String speciesId, // Link to Catalog species
    String? locationId, // Link to Location Graph node
    @Default([]) List<InstanceMagnitude> magnitudes,
    String? notes,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _WorldEntity;

  factory WorldEntity.fromJson(Map<String, dynamic> json) => _$WorldEntityFromJson(json);
}
