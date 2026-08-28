import 'package:uuid/uuid.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import 'package:platinum_world_management_system/src/core/constants/app_technical_strings.dart';
import '../domain/activity_event.dart';
import '../domain/i_history_repository.dart';

class ActivityLoggerService {
  final IHistoryRepository _historyRepository;

  ActivityLoggerService(this._historyRepository);

  // ===========================================================================
  // ENTIDADES
  // ===========================================================================

  Future<void> logEntityCreated(
    String entityId,
    String entityName,
    String entityType, {
    String? speciesId,
    String? subspeciesId,
    String? locationId,
    DateTime? timestamp,
  }) async {
    final event = ActivityEvent(
      id: const Uuid().v4(),
      entityId: entityId,
      eventType: AppTechnicalStrings.eventTypeCreation,
      description: AppStrings.activityEntityCreated(entityName, entityType),
      metadata: {
        AppTechnicalStrings.keyCategory: AppTechnicalStrings.categoryEntity,
        AppTechnicalStrings.keyName: entityName,
        AppTechnicalStrings.keyType: entityType,
        if (speciesId != null) AppTechnicalStrings.colSpeciesId: speciesId,
        if (subspeciesId != null) AppTechnicalStrings.colSubspeciesId: subspeciesId,
        if (locationId != null) AppTechnicalStrings.colLocationId: locationId,
      },
      timestamp: timestamp ?? DateTime.now(),
    );
    await _historyRepository.logEvent(event);
  }

  Future<void> logEntityEdited(
    String entityId,
    String entityName, {
    String? details,
    Map<String, dynamic>? extraMetadata,
  }) async {
    final event = ActivityEvent(
      id: const Uuid().v4(),
      entityId: entityId,
      eventType: AppTechnicalStrings.eventTypeEdition,
      description: details != null
          ? AppStrings.activityEntityEditedWithDetails(entityName, details)
          : AppStrings.activityEntityEdited(entityName),
      metadata: {
        AppTechnicalStrings.keyCategory: AppTechnicalStrings.categoryEntity,
        AppTechnicalStrings.keyName: entityName,
        if (details != null) AppTechnicalStrings.keyDetails: details,
        if (extraMetadata != null) ...extraMetadata,
      },
      timestamp: DateTime.now(),
    );
    await _historyRepository.logEvent(event);
  }

  Future<void> logEntityDeleted(String entityId, String entityName) async {
    final event = ActivityEvent(
      id: const Uuid().v4(),
      entityId: entityId,
      eventType: AppTechnicalStrings.eventTypeDeletion,
      description: AppStrings.activityEntityDeleted(entityName),
      metadata: {
        AppTechnicalStrings.keyCategory: AppTechnicalStrings.categoryEntity,
        AppTechnicalStrings.keyName: entityName,
      },
      timestamp: DateTime.now(),
    );
    await _historyRepository.logEvent(event);
  }

  Future<void> logEntitiesBatchDeleted(int count, {List<String>? entityIds}) async {
    final event = ActivityEvent(
      id: const Uuid().v4(),
      entityId: null,
      eventType: AppTechnicalStrings.eventTypeBatchDeletion,
      description: AppStrings.activityEntitiesBatchDeleted(count),
      metadata: {
        AppTechnicalStrings.keyCategory: AppTechnicalStrings.categoryEntity,
        AppTechnicalStrings.keyCount: count,
        if (entityIds != null) AppTechnicalStrings.keyEntityIds: entityIds,
      },
      timestamp: DateTime.now(),
    );
    await _historyRepository.logEvent(event);
  }

  Future<void> logEntityMoved(String entityId, String entityName, String oldPlaceName, String newPlaceName) async {
    final event = ActivityEvent(
      id: const Uuid().v4(),
      entityId: entityId,
      eventType: AppTechnicalStrings.eventTypeMovement,
      description: AppStrings.activityEntityMoved(entityName, oldPlaceName, newPlaceName),
      metadata: {
        AppTechnicalStrings.keyCategory: AppTechnicalStrings.categoryEntity,
        AppTechnicalStrings.keyName: entityName,
        AppTechnicalStrings.keyFrom: oldPlaceName,
        AppTechnicalStrings.keyTo: newPlaceName,
      },
      timestamp: DateTime.now(),
    );
    await _historyRepository.logEvent(event);
  }

  Future<void> logQuantityConsumed(String entityId, String entityName, double newQty, String unit) async {
    final event = ActivityEvent(
      id: const Uuid().v4(),
      entityId: entityId,
      eventType: AppTechnicalStrings.eventTypeConsumption,
      description: AppStrings.activityQuantityConsumed(entityName, newQty, unit),
      metadata: {
        AppTechnicalStrings.keyCategory: AppTechnicalStrings.categoryEntity,
        AppTechnicalStrings.keyName: entityName,
        AppTechnicalStrings.keyQuantity: newQty,
        AppTechnicalStrings.keyUnit: unit,
      },
      timestamp: DateTime.now(),
    );
    await _historyRepository.logEvent(event);
  }

  // ===========================================================================
  // ESPECIES Y CATÁLOGO
  // ===========================================================================

  Future<void> logSpeciesCreated(String speciesId, String name, String type) async {
    final event = ActivityEvent(
      id: const Uuid().v4(),
      entityId: null,
      eventType: AppTechnicalStrings.eventTypeSpeciesCreation,
      description: AppStrings.activitySpeciesCreated(name, type),
      metadata: {
        AppTechnicalStrings.keyCategory: AppTechnicalStrings.categorySpecies,
        AppTechnicalStrings.keySpeciesId: speciesId,
        AppTechnicalStrings.colName: name,
        AppTechnicalStrings.colType: type,
      },
      timestamp: DateTime.now(),
    );
    await _historyRepository.logEvent(event);
  }

  Future<void> logSpeciesEdited(String speciesId, String name, String details) async {
    final event = ActivityEvent(
      id: const Uuid().v4(),
      entityId: null,
      eventType: AppTechnicalStrings.eventTypeSpeciesEdition,
      description: AppStrings.activitySpeciesEdited(name, details),
      metadata: {
        AppTechnicalStrings.keyCategory: AppTechnicalStrings.categorySpecies,
        AppTechnicalStrings.keySpeciesId: speciesId,
        AppTechnicalStrings.colName: name,
        AppTechnicalStrings.keyDetails: details,
      },
      timestamp: DateTime.now(),
    );
    await _historyRepository.logEvent(event);
  }

  Future<void> logSpeciesDeleted(String speciesId, String name) async {
    final event = ActivityEvent(
      id: const Uuid().v4(),
      entityId: null,
      eventType: AppTechnicalStrings.eventTypeSpeciesDeletion,
      description: AppStrings.activitySpeciesDeleted(name),
      metadata: {
        AppTechnicalStrings.keyCategory: AppTechnicalStrings.categorySpecies,
        AppTechnicalStrings.keySpeciesId: speciesId,
        AppTechnicalStrings.colName: name,
      },
      timestamp: DateTime.now(),
    );
    await _historyRepository.logEvent(event);
  }

  Future<void> logSpeciesMerged(String sourceName, String targetName, {String? targetSpeciesId}) async {
    final event = ActivityEvent(
      id: const Uuid().v4(),
      entityId: null,
      eventType: AppTechnicalStrings.eventTypeSpeciesMerge,
      description: AppStrings.activitySpeciesMerged(sourceName, targetName),
      metadata: {
        AppTechnicalStrings.keyCategory: AppTechnicalStrings.categorySpecies,
        if (targetSpeciesId != null) AppTechnicalStrings.keySpeciesId: targetSpeciesId,
        AppTechnicalStrings.keySource: sourceName,
        AppTechnicalStrings.keyTarget: targetName,
      },
      timestamp: DateTime.now(),
    );
    await _historyRepository.logEvent(event);
  }

  Future<void> logSubspeciesCreated(String subspeciesId, String subName, String speciesName, {String? speciesId}) async {
    final event = ActivityEvent(
      id: const Uuid().v4(),
      entityId: null,
      eventType: AppTechnicalStrings.eventTypeSubspeciesCreation,
      description: AppStrings.activitySubspeciesCreated(subName, speciesName),
      metadata: {
        AppTechnicalStrings.keyCategory: AppTechnicalStrings.categorySpecies,
        AppTechnicalStrings.keySubspeciesId: subspeciesId,
        if (speciesId != null) AppTechnicalStrings.keySpeciesId: speciesId,
        AppTechnicalStrings.colName: subName,
        AppTechnicalStrings.keySpeciesName: speciesName,
      },
      timestamp: DateTime.now(),
    );
    await _historyRepository.logEvent(event);
  }

  Future<void> logSubspeciesSeparated(String subName, String newSpeciesName, {String? newSpeciesId}) async {
    final event = ActivityEvent(
      id: const Uuid().v4(),
      entityId: null,
      eventType: AppTechnicalStrings.eventTypeSubspeciesSeparation,
      description: AppStrings.activitySubspeciesSeparated(subName, newSpeciesName),
      metadata: {
        AppTechnicalStrings.keyCategory: AppTechnicalStrings.categorySpecies,
        if (newSpeciesId != null) AppTechnicalStrings.keySpeciesId: newSpeciesId,
        AppTechnicalStrings.colName: subName,
        AppTechnicalStrings.keyNewSpecies: newSpeciesName,
      },
      timestamp: DateTime.now(),
    );
    await _historyRepository.logEvent(event);
  }

  Future<void> logSubspeciesMoved(String subName, String targetSpeciesName, {String? targetSpeciesId}) async {
    final event = ActivityEvent(
      id: const Uuid().v4(),
      entityId: null,
      eventType: AppTechnicalStrings.eventTypeSubspeciesMovement,
      description: AppStrings.activitySubspeciesMoved(subName, targetSpeciesName),
      metadata: {
        AppTechnicalStrings.keyCategory: AppTechnicalStrings.categorySpecies,
        if (targetSpeciesId != null) AppTechnicalStrings.keySpeciesId: targetSpeciesId,
        AppTechnicalStrings.colName: subName,
        AppTechnicalStrings.keyTargetSpecies: targetSpeciesName,
      },
      timestamp: DateTime.now(),
    );
    await _historyRepository.logEvent(event);
  }

  Future<void> logSubspeciesDeleted(String subName) async {
    final event = ActivityEvent(
      id: const Uuid().v4(),
      entityId: null,
      eventType: AppTechnicalStrings.eventTypeSubspeciesDeletion,
      description: AppStrings.activitySubspeciesDeleted(subName),
      metadata: {
        AppTechnicalStrings.keyCategory: AppTechnicalStrings.categorySpecies,
        AppTechnicalStrings.colName: subName,
      },
      timestamp: DateTime.now(),
    );
    await _historyRepository.logEvent(event);
  }

  // ===========================================================================
  // UBICACIONES
  // ===========================================================================

  Future<void> logLocationCreated(String locationId, String name) async {
    final event = ActivityEvent(
      id: const Uuid().v4(),
      entityId: null,
      eventType: AppTechnicalStrings.eventTypeLocationCreation,
      description: AppStrings.activityLocationCreated(name),
      metadata: {
        AppTechnicalStrings.keyCategory: AppTechnicalStrings.categoryLocation,
        AppTechnicalStrings.keyLocationId: locationId,
        AppTechnicalStrings.colName: name,
      },
      timestamp: DateTime.now(),
    );
    await _historyRepository.logEvent(event);
  }

  Future<void> logLocationEdited(String locationId, String name) async {
    final event = ActivityEvent(
      id: const Uuid().v4(),
      entityId: null,
      eventType: AppTechnicalStrings.eventTypeLocationEdition,
      description: AppStrings.activityLocationEdited(name),
      metadata: {
        AppTechnicalStrings.keyCategory: AppTechnicalStrings.categoryLocation,
        AppTechnicalStrings.keyLocationId: locationId,
        AppTechnicalStrings.colName: name,
      },
      timestamp: DateTime.now(),
    );
    await _historyRepository.logEvent(event);
  }

  Future<void> logLocationMoved(String locationId, String name, String? parentName) async {
    final event = ActivityEvent(
      id: const Uuid().v4(),
      entityId: null,
      eventType: AppTechnicalStrings.eventTypeLocationMovement,
      description: AppStrings.activityLocationMoved(name, parentName),
      metadata: {
        AppTechnicalStrings.keyCategory: AppTechnicalStrings.categoryLocation,
        AppTechnicalStrings.keyLocationId: locationId,
        AppTechnicalStrings.colName: name,
        AppTechnicalStrings.keyParent: parentName,
      },
      timestamp: DateTime.now(),
    );
    await _historyRepository.logEvent(event);
  }

  Future<void> logLocationDeleted(String locationId, String name) async {
    final event = ActivityEvent(
      id: const Uuid().v4(),
      entityId: null,
      eventType: AppTechnicalStrings.eventTypeLocationDeletion,
      description: AppStrings.activityLocationDeleted(name),
      metadata: {
        AppTechnicalStrings.keyCategory: AppTechnicalStrings.categoryLocation,
        AppTechnicalStrings.keyLocationId: locationId,
        AppTechnicalStrings.colName: name,
      },
      timestamp: DateTime.now(),
    );
    await _historyRepository.logEvent(event);
  }

  // ===========================================================================
  // RELACIONES Y ADJUNTOS
  // ===========================================================================

  Future<void> logRelationAdded(String sourceName, String targetName, String relationType, {String? sourceId, String? targetId}) async {
    final event = ActivityEvent(
      id: const Uuid().v4(),
      entityId: sourceId,
      eventType: AppTechnicalStrings.eventTypeRelation,
      description: AppStrings.activityRelationAdded(sourceName, relationType, targetName),
      metadata: {
        AppTechnicalStrings.keyCategory: AppTechnicalStrings.categoryRelation,
        AppTechnicalStrings.keySource: sourceName,
        AppTechnicalStrings.keyTarget: targetName,
        AppTechnicalStrings.keyType: relationType,
        if (sourceId != null) AppTechnicalStrings.keySourceId: sourceId,
        if (targetId != null) AppTechnicalStrings.keyTargetId: targetId,
      },
      timestamp: DateTime.now(),
    );
    await _historyRepository.logEvent(event);
  }

  Future<void> logRelationRemoved(String sourceName, String targetName, String relationType, {String? sourceId, String? targetId}) async {
    final event = ActivityEvent(
      id: const Uuid().v4(),
      entityId: sourceId,
      eventType: AppTechnicalStrings.eventTypeRelationRemoved,
      description: AppStrings.activityRelationRemoved(sourceName, relationType, targetName),
      metadata: {
        AppTechnicalStrings.keyCategory: AppTechnicalStrings.categoryRelation,
        AppTechnicalStrings.keySource: sourceName,
        AppTechnicalStrings.keyTarget: targetName,
        AppTechnicalStrings.keyType: relationType,
        if (sourceId != null) AppTechnicalStrings.keySourceId: sourceId,
        if (targetId != null) AppTechnicalStrings.keyTargetId: targetId,
      },
      timestamp: DateTime.now(),
    );
    await _historyRepository.logEvent(event);
  }

  Future<void> logAttachmentAdded(String? entityId, String entityName, String fileName, {String? speciesId}) async {
    final event = ActivityEvent(
      id: const Uuid().v4(),
      entityId: entityId,
      eventType: AppTechnicalStrings.eventTypeAttachment,
      description: AppStrings.activityAttachmentAdded(fileName, entityName),
      metadata: {
        AppTechnicalStrings.keyCategory: AppTechnicalStrings.categoryRelation,
        AppTechnicalStrings.keyName: entityName,
        AppTechnicalStrings.keyFile: fileName,
        if (speciesId != null) AppTechnicalStrings.keySpeciesId: speciesId,
      },
      timestamp: DateTime.now(),
    );
    await _historyRepository.logEvent(event);
  }

  Future<void> logAttachmentRemoved(String? entityId, String entityName, String fileName) async {
    final event = ActivityEvent(
      id: const Uuid().v4(),
      entityId: entityId,
      eventType: AppTechnicalStrings.eventTypeAttachmentRemoved,
      description: AppStrings.activityAttachmentRemoved(fileName, entityName),
      metadata: {
        AppTechnicalStrings.keyCategory: AppTechnicalStrings.categoryRelation,
        AppTechnicalStrings.keyName: entityName,
        AppTechnicalStrings.keyFile: fileName,
      },
      timestamp: DateTime.now(),
    );
    await _historyRepository.logEvent(event);
  }

  Future<void> logPhotoChanged(String entityId, String entityName) async {
    final event = ActivityEvent(
      id: const Uuid().v4(),
      entityId: entityId,
      eventType: AppTechnicalStrings.eventTypePhotoChanged,
      description: AppStrings.activityPhotoChanged(entityName),
      metadata: {
        AppTechnicalStrings.keyCategory: AppTechnicalStrings.categoryEntity,
        AppTechnicalStrings.keyName: entityName,
      },
      timestamp: DateTime.now(),
    );
    await _historyRepository.logEvent(event);
  }

  Future<void> logPhotoRemoved(String entityId, String entityName) async {
    final event = ActivityEvent(
      id: const Uuid().v4(),
      entityId: entityId,
      eventType: AppTechnicalStrings.eventTypePhotoRemoved,
      description: AppStrings.activityPhotoRemoved(entityName),
      metadata: {
        AppTechnicalStrings.keyCategory: AppTechnicalStrings.categoryEntity,
        AppTechnicalStrings.keyName: entityName,
      },
      timestamp: DateTime.now(),
    );
    await _historyRepository.logEvent(event);
  }

  // ===========================================================================
  // RESPALDOS Y SISTEMA
  // ===========================================================================

  Future<void> logBackupExported(int totalRecords) async {
    final event = ActivityEvent(
      id: const Uuid().v4(),
      entityId: null,
      eventType: AppTechnicalStrings.eventTypeBackupExport,
      description: AppStrings.activityBackupExported(totalRecords),
      metadata: {
        AppTechnicalStrings.keyCategory: AppTechnicalStrings.categoryBackup,
        AppTechnicalStrings.keyTotalRecords: totalRecords,
      },
      timestamp: DateTime.now(),
    );
    await _historyRepository.logEvent(event);
  }

  Future<void> logBackupRestored(int totalRecords, {String? originDate, int? schemaVersion}) async {
    final event = ActivityEvent(
      id: const Uuid().v4(),
      entityId: null,
      eventType: AppTechnicalStrings.eventTypeBackupRestore,
      description: AppStrings.activityBackupRestored(totalRecords, originDate),
      metadata: {
        AppTechnicalStrings.keyCategory: AppTechnicalStrings.categoryBackup,
        AppTechnicalStrings.keyTotalRecords: totalRecords,
        if (originDate != null) AppTechnicalStrings.keyOriginDate: originDate,
        if (schemaVersion != null) AppTechnicalStrings.keySchemaVersion: schemaVersion,
      },
      timestamp: DateTime.now(),
    );
    await _historyRepository.logEvent(event);
  }

  Future<void> logAuditFixApplied(String ruleTitle, String details) async {
    final event = ActivityEvent(
      id: const Uuid().v4(),
      entityId: null,
      eventType: AppTechnicalStrings.eventTypeAuditFix,
      description: AppStrings.activityAuditFixApplied(ruleTitle, details),
      metadata: {
        AppTechnicalStrings.keyCategory: AppTechnicalStrings.categorySystem,
        AppTechnicalStrings.keyRuleTitle: ruleTitle,
        AppTechnicalStrings.keyDetails: details,
      },
      timestamp: DateTime.now(),
    );
    await _historyRepository.logEvent(event);
  }
}

