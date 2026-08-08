import 'package:freezed_annotation/freezed_annotation.dart';

part 'attachment.freezed.dart';
part 'attachment.g.dart';

@freezed
class Attachment with _$Attachment {
  const factory Attachment({
    required String id,
    required String speciesId, // Attachments belong to the Catalog Species!
    String? instanceId, // Optional link to specific World Entity Instance
    required String filePath,
    required String fileName,
    required String fileType,
    required DateTime createdAt,
  }) = _Attachment;

  factory Attachment.fromJson(Map<String, dynamic> json) => _$AttachmentFromJson(json);
}
