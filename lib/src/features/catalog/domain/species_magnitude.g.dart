// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'species_magnitude.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SpeciesMagnitudeImpl _$$SpeciesMagnitudeImplFromJson(
        Map<String, dynamic> json) =>
    _$SpeciesMagnitudeImpl(
      id: json['id'] as String,
      speciesId: json['speciesId'] as String,
      propertyName: json['propertyName'] as String,
      dataType: json['dataType'] as String? ?? 'real',
      unitSymbol: json['unitSymbol'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$SpeciesMagnitudeImplToJson(
        _$SpeciesMagnitudeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'speciesId': instance.speciesId,
      'propertyName': instance.propertyName,
      'dataType': instance.dataType,
      'unitSymbol': instance.unitSymbol,
      'createdAt': instance.createdAt.toIso8601String(),
    };
