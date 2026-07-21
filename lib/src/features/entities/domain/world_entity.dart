import 'package:freezed_annotation/freezed_annotation.dart';

part 'world_entity.freezed.dart';
part 'world_entity.g.dart';

@freezed
class WorldEntity with _$WorldEntity {
  const factory WorldEntity({
    required String id,
    required String speciesId, // Link to Catalog species
    String? locationId, // Link to Location Graph node
    double? quantity, // Magnitud
    String? unit,
    String? notes,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _WorldEntity;

  factory WorldEntity.fromJson(Map<String, dynamic> json) => _$WorldEntityFromJson(json);
}
