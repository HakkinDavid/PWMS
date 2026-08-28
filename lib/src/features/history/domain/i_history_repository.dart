import 'activity_event.dart';

abstract class IHistoryRepository {
  Future<List<ActivityEvent>> getAllEvents();
  Future<List<ActivityEvent>> getRecentEvents({int limit = 20});
  Stream<List<ActivityEvent>> watchRecentEvents({int limit = 50});
  Stream<List<ActivityEvent>> watchAllEvents();
  Future<List<ActivityEvent>> getEventsForEntity(String entityId);
  Future<List<ActivityEvent>> getEventsFiltered({
    String? category,
    String? query,
    int limit = 50,
    int offset = 0,
  });
  Future<void> logEvent(ActivityEvent event);
  Future<void> logEventsBatch(List<ActivityEvent> events);
  Future<void> clearHistory();
}

