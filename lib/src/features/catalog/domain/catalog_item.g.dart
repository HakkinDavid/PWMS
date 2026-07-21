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
      brand: json['brand'] as String?,
      description: json['description'] as String?,
      mainPhotoPath: json['mainPhotoPath'] as String?,
      barcode: json['barcode'] as String?,
      customAttributes:
          json['customAttributes'] as Map<String, dynamic>? ?? const {},
      defaultUnit: json['defaultUnit'] as String?,
      isUnique: json['isUnique'] as bool? ?? false,
      hasMonetaryValue: json['hasMonetaryValue'] as bool? ?? true,
      defaultMonetaryCurrency:
          json['defaultMonetaryCurrency'] as String? ?? 'MXN',
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$CatalogItemImplToJson(_$CatalogItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'brand': instance.brand,
      'description': instance.description,
      'mainPhotoPath': instance.mainPhotoPath,
      'barcode': instance.barcode,
      'customAttributes': instance.customAttributes,
      'defaultUnit': instance.defaultUnit,
      'isUnique': instance.isUnique,
      'hasMonetaryValue': instance.hasMonetaryValue,
      'defaultMonetaryCurrency': instance.defaultMonetaryCurrency,
      'createdAt': instance.createdAt.toIso8601String(),
    };
