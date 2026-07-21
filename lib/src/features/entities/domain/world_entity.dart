import 'package:freezed_annotation/freezed_annotation.dart';

part 'world_entity.freezed.dart';
part 'world_entity.g.dart';

@freezed
class WorldEntity with _$WorldEntity {
  const factory WorldEntity({
    required String id,
    String? speciesId, // Link to Universe Catalog species item
    required String name,
    String? alias,
    required String type,
    String? mainPhotoPath,
    String? notes,
    String? placeId,
    String? parentEntityId,
    double? quantity,
    String? unit,
    String? barcode,
    @Default({}) Map<String, dynamic> customAttributes,
    @Default(false) bool isArchived,
    @Default(false) bool isContainer,
    @Default(false) bool isPlace,
    @Default([]) List<String> tags,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _WorldEntity;

  factory WorldEntity.fromJson(Map<String, dynamic> json) => _$WorldEntityFromJson(json);
}
