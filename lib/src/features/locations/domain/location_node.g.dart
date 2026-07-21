// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_node.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LocationNodeImpl _$$LocationNodeImplFromJson(Map<String, dynamic> json) =>
    _$LocationNodeImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      parentLocationId: json['parentLocationId'] as String?,
      description: json['description'] as String?,
      icon: json['icon'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$LocationNodeImplToJson(_$LocationNodeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'parentLocationId': instance.parentLocationId,
      'description': instance.description,
      'icon': instance.icon,
      'createdAt': instance.createdAt.toIso8601String(),
    };
