import 'package:freezed_annotation/freezed_annotation.dart';

part 'entity_relation.freezed.dart';
part 'entity_relation.g.dart';

@freezed
class EntityRelation with _$EntityRelation {
  const factory EntityRelation({
    required String id,
    required String sourceEntityId,
    required String targetEntityId,
    required String relationType,
    required DateTime createdAt,
  }) = _EntityRelation;

  factory EntityRelation.fromJson(Map<String, dynamic> json) => _$EntityRelationFromJson(json);
}
