// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CatalogItemImpl _$$CatalogItemImplFromJson(Map<String, dynamic> json) =>
    _$CatalogItemImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String? ?? 'Objeto',
      description: json['description'] as String?,
      mainPhotoPath: json['mainPhotoPath'] as String?,
      customAttributes:
          json['customAttributes'] as Map<String, dynamic>? ?? const {},
      magnitudes: (json['magnitudes'] as List<dynamic>?)
              ?.map((e) => SpeciesMagnitude.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      isUnique: json['isUnique'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$CatalogItemImplToJson(_$CatalogItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'description': instance.description,
      'mainPhotoPath': instance.mainPhotoPath,
      'customAttributes': instance.customAttributes,
      'magnitudes': instance.magnitudes,
      'isUnique': instance.isUnique,
      'createdAt': instance.createdAt.toIso8601String(),
    };
