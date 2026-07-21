// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_template.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CustomTemplateImpl _$$CustomTemplateImplFromJson(Map<String, dynamic> json) =>
    _$CustomTemplateImpl(
      id: json['id'] as String,
      typeName: json['typeName'] as String,
      iconName: json['iconName'] as String,
      commonUnits: (json['commonUnits'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$CustomTemplateImplToJson(
        _$CustomTemplateImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'typeName': instance.typeName,
      'iconName': instance.iconName,
      'commonUnits': instance.commonUnits,
      'createdAt': instance.createdAt.toIso8601String(),
    };
