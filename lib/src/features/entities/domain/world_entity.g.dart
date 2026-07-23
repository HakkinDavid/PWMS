// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'world_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WorldEntityImpl _$$WorldEntityImplFromJson(Map<String, dynamic> json) =>
    _$WorldEntityImpl(
      id: json['id'] as String,
      speciesId: json['speciesId'] as String,
      subspeciesId: json['subspeciesId'] as String?,
      locationId: json['locationId'] as String?,
      magnitudes: (json['magnitudes'] as List<dynamic>?)
              ?.map(
                  (e) => InstanceMagnitude.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$WorldEntityImplToJson(_$WorldEntityImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'speciesId': instance.speciesId,
      'subspeciesId': instance.subspeciesId,
      'locationId': instance.locationId,
      'magnitudes': instance.magnitudes,
      'notes': instance.notes,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
