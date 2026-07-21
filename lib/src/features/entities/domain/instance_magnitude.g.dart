// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instance_magnitude.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InstanceMagnitudeImpl _$$InstanceMagnitudeImplFromJson(
        Map<String, dynamic> json) =>
    _$InstanceMagnitudeImpl(
      id: json['id'] as String,
      instanceId: json['instanceId'] as String,
      propertyName: json['propertyName'] as String,
      magnitudeValue: (json['magnitudeValue'] as num).toDouble(),
      unitSymbol: json['unitSymbol'] as String,
    );

Map<String, dynamic> _$$InstanceMagnitudeImplToJson(
        _$InstanceMagnitudeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'instanceId': instance.instanceId,
      'propertyName': instance.propertyName,
      'magnitudeValue': instance.magnitudeValue,
      'unitSymbol': instance.unitSymbol,
    };
