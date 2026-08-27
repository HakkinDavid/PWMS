import 'package:uuid/uuid.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import 'package:platinum_world_management_system/src/core/constants/app_technical_strings.dart';
import '../domain/activity_event.dart';
import '../domain/i_history_repository.dart';


class ActivityLoggerService {
  final IHistoryRepository _historyRepository;

  ActivityLoggerService(this._historyRepository);

  Future<void> logEntityCreated(String entityId, String entityName, String entityType) async {
    final event = ActivityEvent(
      id: const Uuid().v4(),
      entityId: entityId,
      eventType: AppTechnicalStrings.eventCreation,
      description: AppStrings.activityEntityCreated(entityName, entityType),
      metadata: {AppTechnicalStrings.keyName: entityName, AppTechnicalStrings.keyType: entityType},
      timestamp: DateTime.now(),
    );
    await _historyRepository.logEvent(event);
  }

  Future<void> logEntityEdited(String entityId, String entityName, {String? details}) async {
    final event = ActivityEvent(
      id: const Uuid().v4(),
      entityId: entityId,
      eventType: AppTechnicalStrings.eventEdition,
      description: details != null
          ? AppStrings.activityEntityEditedWithDetails(entityName, details)
          : AppStrings.activityEntityEdited(entityName),
      metadata: {AppTechnicalStrings.keyName: entityName, AppTechnicalStrings.keyDetails: details},
      timestamp: DateTime.now(),
    );
    await _historyRepository.logEvent(event);
  }

  Future<void> logEntityDeleted(String entityId, String entityName) async {
    final event = ActivityEvent(
      id: const Uuid().v4(),
      entityId: entityId,
      eventType: AppTechnicalStrings.eventDeletion,
      description: AppStrings.activityEntityDeleted(entityName),
      metadata: {AppTechnicalStrings.keyName: entityName},
      timestamp: DateTime.now(),
    );
    await _historyRepository.logEvent(event);
  }

  Future<void> logEntityMoved(String entityId, String entityName, String oldPlaceName, String newPlaceName) async {
    final event = ActivityEvent(
      id: const Uuid().v4(),
      entityId: entityId,
      eventType: AppTechnicalStrings.eventMovement,
      description: AppStrings.activityEntityMoved(entityName, oldPlaceName, newPlaceName),
      metadata: {
        AppTechnicalStrings.keyName: entityName,
        AppTechnicalStrings.keyFrom: oldPlaceName,
        AppTechnicalStrings.keyTo: newPlaceName,
      },
      timestamp: DateTime.now(),
    );
    await _historyRepository.logEvent(event);
  }

  Future<void> logAttachmentAdded(String entityId, String entityName, String fileName) async {
    final event = ActivityEvent(
      id: const Uuid().v4(),
      entityId: entityId,
      eventType: AppTechnicalStrings.eventAttachment,
      description: AppStrings.activityAttachmentAdded(fileName, entityName),
      metadata: {AppTechnicalStrings.keyName: entityName, AppTechnicalStrings.keyFile: fileName},
      timestamp: DateTime.now(),
    );
    await _historyRepository.logEvent(event);
  }

  Future<void> logAttachmentRemoved(String entityId, String entityName, String fileName) async {
    final event = ActivityEvent(
      id: const Uuid().v4(),
      entityId: entityId,
      eventType: AppTechnicalStrings.eventAttachmentRemoved,
      description: AppStrings.activityAttachmentRemoved(fileName, entityName),
      metadata: {AppTechnicalStrings.keyName: entityName, AppTechnicalStrings.keyFile: fileName},
      timestamp: DateTime.now(),
    );
    await _historyRepository.logEvent(event);
  }

  Future<void> logRelationAdded(String sourceName, String targetName, String relationType) async {
    final event = ActivityEvent(
      id: const Uuid().v4(),
      entityId: null,
      eventType: AppTechnicalStrings.eventRelation,
      description: AppStrings.activityRelationAdded(sourceName, relationType, targetName),
      metadata: {
        AppTechnicalStrings.keySource: sourceName,
        AppTechnicalStrings.keyTarget: targetName,
        AppTechnicalStrings.keyType: relationType,
      },
      timestamp: DateTime.now(),
    );
    await _historyRepository.logEvent(event);
  }

  Future<void> logRelationRemoved(String sourceName, String targetName, String relationType) async {
    final event = ActivityEvent(
      id: const Uuid().v4(),
      entityId: null,
      eventType: AppTechnicalStrings.eventRelationRemoved,
      description: AppStrings.activityRelationRemoved(sourceName, relationType, targetName),
      metadata: {
        AppTechnicalStrings.keySource: sourceName,
        AppTechnicalStrings.keyTarget: targetName,
        AppTechnicalStrings.keyType: relationType,
      },
      timestamp: DateTime.now(),
    );
    await _historyRepository.logEvent(event);
  }

  Future<void> logPhotoChanged(String entityId, String entityName) async {
    final event = ActivityEvent(
      id: const Uuid().v4(),
      entityId: entityId,
      eventType: AppTechnicalStrings.eventPhotoChanged,
      description: AppStrings.activityPhotoChanged(entityName),
      metadata: {AppTechnicalStrings.keyName: entityName},
      timestamp: DateTime.now(),
    );
    await _historyRepository.logEvent(event);
  }

  Future<void> logPhotoRemoved(String entityId, String entityName) async {
    final event = ActivityEvent(
      id: const Uuid().v4(),
      entityId: entityId,
      eventType: AppTechnicalStrings.eventPhotoRemoved,
      description: AppStrings.activityPhotoRemoved(entityName),
      metadata: {AppTechnicalStrings.keyName: entityName},
      timestamp: DateTime.now(),
    );
    await _historyRepository.logEvent(event);
  }

  Future<void> logQuantityConsumed(String entityId, String entityName, double newQty, String unit) async {
    final event = ActivityEvent(
      id: const Uuid().v4(),
      entityId: entityId,
      eventType: AppTechnicalStrings.eventConsumption,
      description: AppStrings.activityQuantityConsumed(entityName, newQty, unit),
      metadata: {
        AppTechnicalStrings.keyName: entityName,
        AppTechnicalStrings.keyQuantity: newQty,
        AppTechnicalStrings.keyUnit: unit,
      },
      timestamp: DateTime.now(),
    );
    await _historyRepository.logEvent(event);
  }
}
