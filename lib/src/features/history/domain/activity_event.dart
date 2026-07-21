import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity_event.freezed.dart';
part 'activity_event.g.dart';

@freezed
class ActivityEvent with _$ActivityEvent {
  const factory ActivityEvent({
    required String id,
    String? entityId,
    required String eventType, // creation, edition, movement, attachment, relation
    required String description,
    Map<String, dynamic>? metadata,
    required DateTime timestamp,
  }) = _ActivityEvent;

  factory ActivityEvent.fromJson(Map<String, dynamic> json) => _$ActivityEventFromJson(json);
}
