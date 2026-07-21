// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'world_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WorldEntityImpl _$$WorldEntityImplFromJson(Map<String, dynamic> json) =>
    _$WorldEntityImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      alias: json['alias'] as String?,
      type: json['type'] as String,
      mainPhotoPath: json['mainPhotoPath'] as String?,
      notes: json['notes'] as String?,
      placeId: json['placeId'] as String?,
      parentEntityId: json['parentEntityId'] as String?,
      quantity: (json['quantity'] as num?)?.toDouble(),
      unit: json['unit'] as String?,
      barcode: json['barcode'] as String?,
      customAttributes:
          json['customAttributes'] as Map<String, dynamic>? ?? const {},
      isArchived: json['isArchived'] as bool? ?? false,
      isContainer: json['isContainer'] as bool? ?? false,
      isPlace: json['isPlace'] as bool? ?? false,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$WorldEntityImplToJson(_$WorldEntityImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'alias': instance.alias,
      'type': instance.type,
      'mainPhotoPath': instance.mainPhotoPath,
      'notes': instance.notes,
      'placeId': instance.placeId,
      'parentEntityId': instance.parentEntityId,
      'quantity': instance.quantity,
      'unit': instance.unit,
      'barcode': instance.barcode,
      'customAttributes': instance.customAttributes,
      'isArchived': instance.isArchived,
      'isContainer': instance.isContainer,
      'isPlace': instance.isPlace,
      'tags': instance.tags,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
