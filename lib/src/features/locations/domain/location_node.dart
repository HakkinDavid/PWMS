import 'package:freezed_annotation/freezed_annotation.dart';

part 'location_node.freezed.dart';
part 'location_node.g.dart';

@freezed
class LocationNode with _$LocationNode {
  const factory LocationNode({
    required String id,
    required String name,
    String? parentLocationId,
    String? description,
    String? icon,
    required DateTime createdAt,
  }) = _LocationNode;

  factory LocationNode.fromJson(Map<String, dynamic> json) => _$LocationNodeFromJson(json);
}
