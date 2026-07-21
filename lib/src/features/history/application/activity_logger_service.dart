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
      description: 'Registrado: "$entityName" ($entityType)',
      metadata: {'name': entityName, 'type': entityType},
      timestamp: DateTime.now(),
    );
    await _historyRepository.logEvent(event);
  }

  Future<void> logEntityEdited(String entityId, String entityName) async {
    final event = ActivityEvent(
      id: const Uuid().v4(),
      entityId: entityId,
      eventType: 'edition',
      description: 'Actualizado: "$entityName"',
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

  Future<void> logRelationAdded(String sourceName, String targetName, String relationType) async {
    final event = ActivityEvent(
      id: const Uuid().v4(),
      entityId: null,
      eventType: 'relation',
      description: 'Relación establecida: "$sourceName" $relationType "$targetName"',
      metadata: {'source': sourceName, 'target': targetName, 'type': relationType},
      timestamp: DateTime.now(),
    );
    await _historyRepository.logEvent(event);
  }
}
