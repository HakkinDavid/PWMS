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
      dataType:
          json['dataType'] as String? ?? AppTechnicalStrings.datatypeRealLower,
      magnitudeValue: (json['magnitudeValue'] as num?)?.toDouble() ?? 0.0,
      stringValue: json['stringValue'] as String?,
      unitSymbol: json['unitSymbol'] as String?,
    );

Map<String, dynamic> _$$InstanceMagnitudeImplToJson(
        _$InstanceMagnitudeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'instanceId': instance.instanceId,
      'propertyName': instance.propertyName,
      'dataType': instance.dataType,
      'magnitudeValue': instance.magnitudeValue,
      'stringValue': instance.stringValue,
      'unitSymbol': instance.unitSymbol,
    };
