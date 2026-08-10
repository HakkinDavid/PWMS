import 'package:uuid/uuid.dart';
import '../domain/activity_event.dart';
import '../domain/i_history_repository.dart';


class ActivityLoggerService {
  final IHistoryRepository _historyRepository;

  ActivityLoggerService(this._historyRepository);

  Future<void> logEntityCreated(String entityId, String entityName, String entityType) async {
    final event = ActivityEvent(
      id: const Uuid().v4(),
      entityId: entityId,
      eventType: 'creation',
      description: 'Registrado en tu mundo: "$entityName" ($entityType)',
      metadata: {'name': entityName, 'type': entityType},
      timestamp: DateTime.now(),
    );
    await _historyRepository.logEvent(event);
  }

  Future<void> logEntityEdited(String entityId, String entityName, {String? details}) async {
    final event = ActivityEvent(
      id: const Uuid().v4(),
      entityId: entityId,
      eventType: 'edition',
      description: details != null ? 'Editado "$entityName": $details' : 'Editada información de "$entityName"',
      metadata: {'name': entityName, 'details': details},
      timestamp: DateTime.now(),
    );
    await _historyRepository.logEvent(event);
  }

  Future<void> logEntityDeleted(String entityId, String entityName) async {
    final event = ActivityEvent(
      id: const Uuid().v4(),
      entityId: entityId,
      eventType: 'deletion',
      description: 'Eliminado de tu mundo: "$entityName"',
      metadata: {'name': entityName},
      timestamp: DateTime.now(),
    );
    await _historyRepository.logEvent(event);
  }

  Future<void> logEntityMoved(String entityId, String entityName, String oldPlaceName, String newPlaceName) async {
    final event = ActivityEvent(
      id: const Uuid().v4(),
      entityId: entityId,
      eventType: 'movement',
      description: 'Trasladado "$entityName" de "$oldPlaceName" a "$newPlaceName"',
      metadata: {'name': entityName, 'from': oldPlaceName, 'to': newPlaceName},
      timestamp: DateTime.now(),
    );
    await _historyRepository.logEvent(event);
  }

  Future<void> logAttachmentAdded(String entityId, String entityName, String fileName) async {
    final event = ActivityEvent(
      id: const Uuid().v4(),
      entityId: entityId,
      eventType: 'attachment',
      description: 'Adjuntado archivo "$fileName" a "$entityName"',
      metadata: {'name': entityName, 'file': fileName},
      timestamp: DateTime.now(),
    );
    await _historyRepository.logEvent(event);
  }

  Future<void> logAttachmentRemoved(String entityId, String entityName, String fileName) async {
    final event = ActivityEvent(
      id: const Uuid().v4(),
      entityId: entityId,
      eventType: 'attachment_removed',
      description: 'Eliminado archivo "$fileName" de "$entityName"',
      metadata: {'name': entityName, 'file': fileName},
      timestamp: DateTime.now(),
    );
    await _historyRepository.logEvent(event);
  }

  Future<void> logRelationAdded(String sourceName, String targetName, String relationType) async {
    final event = ActivityEvent(
      id: const Uuid().v4(),
      entityId: null,
      eventType: 'relation',
      description: 'Vínculo establecido: "$sourceName" $relationType "$targetName"',
      metadata: {'source': sourceName, 'target': targetName, 'type': relationType},
      timestamp: DateTime.now(),
    );
    await _historyRepository.logEvent(event);
  }

  Future<void> logRelationRemoved(String sourceName, String targetName, String relationType) async {
    final event = ActivityEvent(
      id: const Uuid().v4(),
      entityId: null,
      eventType: 'relation_removed',
      description: 'Vínculo eliminado: "$sourceName" $relationType "$targetName"',
      metadata: {'source': sourceName, 'target': targetName, 'type': relationType},
      timestamp: DateTime.now(),
    );
    await _historyRepository.logEvent(event);
  }

  Future<void> logPhotoChanged(String entityId, String entityName) async {
    final event = ActivityEvent(
      id: const Uuid().v4(),
      entityId: entityId,
      eventType: 'photo_changed',
      description: 'Actualizada fotografía principal de "$entityName"',
      metadata: {'name': entityName},
      timestamp: DateTime.now(),
    );
    await _historyRepository.logEvent(event);
  }

  Future<void> logPhotoRemoved(String entityId, String entityName) async {
    final event = ActivityEvent(
      id: const Uuid().v4(),
      entityId: entityId,
      eventType: 'photo_removed',
      description: 'Eliminada fotografía principal de "$entityName"',
      metadata: {'name': entityName},
      timestamp: DateTime.now(),
    );
    await _historyRepository.logEvent(event);
  }

  Future<void> logQuantityConsumed(String entityId, String entityName, double newQty, String unit) async {
    final event = ActivityEvent(
      id: const Uuid().v4(),
      entityId: entityId,
      eventType: 'consumption',
      description: 'Cantidad ajustada de "$entityName": $newQty $unit',
      metadata: {'name': entityName, 'quantity': newQty, 'unit': unit},
      timestamp: DateTime.now(),
    );
    await _historyRepository.logEvent(event);
  }
}
