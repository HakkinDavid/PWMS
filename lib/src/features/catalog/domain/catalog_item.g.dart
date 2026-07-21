// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CatalogItemImpl _$$CatalogItemImplFromJson(Map<String, dynamic> json) =>
    _$CatalogItemImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      brand: json['brand'] as String?,
      description: json['description'] as String?,
      mainPhotoPath: json['mainPhotoPath'] as String?,
      defaultType: json['defaultType'] as String? ?? 'Objeto / Herramienta',
      barcode: json['barcode'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$CatalogItemImplToJson(_$CatalogItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'brand': instance.brand,
      'description': instance.description,
      'mainPhotoPath': instance.mainPhotoPath,
      'defaultType': instance.defaultType,
      'barcode': instance.barcode,
      'createdAt': instance.createdAt.toIso8601String(),
    };
