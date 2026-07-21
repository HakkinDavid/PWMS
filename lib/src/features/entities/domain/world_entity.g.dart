// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'world_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WorldEntityImpl _$$WorldEntityImplFromJson(Map<String, dynamic> json) =>
    _$WorldEntityImpl(
      id: json['id'] as String,
      speciesId: json['speciesId'] as String,
      locationId: json['locationId'] as String?,
      quantity: (json['quantity'] as num?)?.toDouble(),
      unit: json['unit'] as String?,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$WorldEntityImplToJson(_$WorldEntityImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'speciesId': instance.speciesId,
      'locationId': instance.locationId,
      'quantity': instance.quantity,
      'unit': instance.unit,
      'notes': instance.notes,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
