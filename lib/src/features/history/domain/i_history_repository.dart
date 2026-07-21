import 'activity_event.dart';

abstract class IHistoryRepository {
  Future<List<ActivityEvent>> getRecentEvents({int limit = 20});
  Future<List<ActivityEvent>> getEventsForEntity(String entityId);
  Future<void> logEvent(ActivityEvent event);
}
