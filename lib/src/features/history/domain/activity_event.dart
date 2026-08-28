import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:platinum_world_management_system/src/core/constants/app_technical_strings.dart';

part 'activity_event.freezed.dart';
part 'activity_event.g.dart';

@freezed
class ActivityEvent with _$ActivityEvent {
  const ActivityEvent._();

  const factory ActivityEvent({
    required String id,
    String? entityId,
    required String eventType,
    required String description,
    Map<String, dynamic>? metadata,
    required DateTime timestamp,
  }) = _ActivityEvent;

  factory ActivityEvent.fromJson(Map<String, dynamic> json) => _$ActivityEventFromJson(json);

  String get category {
    if (metadata != null && metadata![AppTechnicalStrings.keyCategory] != null) {
      return metadata![AppTechnicalStrings.keyCategory].toString();
    }
    final et = eventType.toLowerCase();
    if (et.contains(AppTechnicalStrings.categorySpecies) || et.contains(AppTechnicalStrings.tableSubspecies)) {
      return AppTechnicalStrings.categorySpecies;
    }
    if (et.contains(AppTechnicalStrings.categoryLocation)) {
      return AppTechnicalStrings.categoryLocation;
    }
    if (et.contains(AppTechnicalStrings.categoryRelation) || et == AppTechnicalStrings.eventTypeAttachment || et == AppTechnicalStrings.eventTypeAttachmentRemoved) {
      return AppTechnicalStrings.categoryRelation;
    }
    if (et.contains(AppTechnicalStrings.categoryBackup)) {
      return AppTechnicalStrings.categoryBackup;
    }
    if (et.contains(AppTechnicalStrings.categoryAuditLower) || et.contains(AppTechnicalStrings.typeMigration) || et.contains(AppTechnicalStrings.categorySystem)) {
      return AppTechnicalStrings.categorySystem;
    }
    return AppTechnicalStrings.categoryEntity;
  }

  String? get resolvedTargetId {
    if (metadata != null && metadata![AppTechnicalStrings.keyTargetId] != null) {
      return metadata![AppTechnicalStrings.keyTargetId].toString();
    }
    if (metadata != null && metadata![AppTechnicalStrings.keySpeciesId] != null) {
      return metadata![AppTechnicalStrings.keySpeciesId].toString();
    }
    if (metadata != null && metadata![AppTechnicalStrings.keyLocationId] != null) {
      return metadata![AppTechnicalStrings.keyLocationId].toString();
    }
    return entityId;
  }

  String? get resolvedTargetType {
    if (metadata != null && metadata![AppTechnicalStrings.keyTargetType] != null) {
      return metadata![AppTechnicalStrings.keyTargetType].toString();
    }
    final cat = category;
    if (cat == AppTechnicalStrings.categorySpecies) return AppTechnicalStrings.notifTargetTypeSpecies;
    if (cat == AppTechnicalStrings.categoryLocation) return AppTechnicalStrings.categoryLocation;
    if (cat == AppTechnicalStrings.categoryEntity) return AppTechnicalStrings.notifTargetTypeEntity;
    return null;
  }

  bool get isNavigable => resolvedTargetId != null && resolvedTargetType != null;
}

