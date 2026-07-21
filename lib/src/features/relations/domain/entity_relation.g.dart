// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entity_relation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EntityRelationImpl _$$EntityRelationImplFromJson(Map<String, dynamic> json) =>
    _$EntityRelationImpl(
      id: json['id'] as String,
      sourceEntityId: json['sourceEntityId'] as String,
      targetEntityId: json['targetEntityId'] as String,
      relationType: json['relationType'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$EntityRelationImplToJson(
        _$EntityRelationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sourceEntityId': instance.sourceEntityId,
      'targetEntityId': instance.targetEntityId,
      'relationType': instance.relationType,
      'createdAt': instance.createdAt.toIso8601String(),
    };
