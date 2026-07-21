import 'package:platinum_world_management_system/core/domain/entities/entity_id.dart';
import 'package:platinum_world_management_system/core/domain/events/domain_event.dart';
import 'package:platinum_world_management_system/core/domain/repositories/event_repository.dart';

class InMemoryEventRepository implements EventRepository {
  final List<DomainEvent> _events = [];

  @override
  Future<void> record(DomainEvent event) async {
    _events.add(event);
  }

  @override
  Future<List<DomainEvent>> findByEntityId(EntityId entityId) async {
    return _events.where((e) => e.entityId == entityId).toList();
  }

  @override
  Future<List<DomainEvent>> findAll() async {
    return List.unmodifiable(_events);
  }
}
