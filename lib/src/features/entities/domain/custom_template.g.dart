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
      isContainer: json['isContainer'] as bool? ?? false,
      isPlace: json['isPlace'] as bool? ?? false,
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
      'isContainer': instance.isContainer,
      'isPlace': instance.isPlace,
      'commonUnits': instance.commonUnits,
      'createdAt': instance.createdAt.toIso8601String(),
    };
