// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attachment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AttachmentImpl _$$AttachmentImplFromJson(Map<String, dynamic> json) =>
    _$AttachmentImpl(
      id: json['id'] as String,
      entityId: json['entityId'] as String,
      filePath: json['filePath'] as String,
      fileName: json['fileName'] as String,
      fileType: json['fileType'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$AttachmentImplToJson(_$AttachmentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'entityId': instance.entityId,
      'filePath': instance.filePath,
      'fileName': instance.fileName,
      'fileType': instance.fileType,
      'createdAt': instance.createdAt.toIso8601String(),
    };
