// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ActivityEventImpl _$$ActivityEventImplFromJson(Map<String, dynamic> json) =>
    _$ActivityEventImpl(
      id: json['id'] as String,
      entityId: json['entityId'] as String?,
      eventType: json['eventType'] as String,
      description: json['description'] as String,
      metadata: json['metadata'] as Map<String, dynamic>?,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$$ActivityEventImplToJson(_$ActivityEventImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'entityId': instance.entityId,
      'eventType': instance.eventType,
      'description': instance.description,
      'metadata': instance.metadata,
      'timestamp': instance.timestamp.toIso8601String(),
    };
