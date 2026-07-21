import 'package:freezed_annotation/freezed_annotation.dart';

part 'world_entity.freezed.dart';
part 'world_entity.g.dart';

@freezed
class WorldEntity with _$WorldEntity {
  const factory WorldEntity({
    required String id,
    required String name,
    String? alias,
    required String type,
    String? mainPhotoPath,
    String? notes,
    String? placeId,
    String? parentEntityId, // Containment parent ID (can be place or container entity)
    double? quantity,       // Countable or measurable quantity
    String? unit,           // Unit of measurement (e.g. piezas, kg, litros)
    @Default(false) bool isContainer,
    @Default(false) bool isPlace,
    @Default([]) List<String> tags,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _WorldEntity;

  factory WorldEntity.fromJson(Map<String, dynamic> json) => _$WorldEntityFromJson(json);
}
