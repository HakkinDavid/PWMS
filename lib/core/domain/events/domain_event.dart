import '../entities/entity_id.dart';
import 'event_id.dart';

/// Evento inmutable del dominio que representa una acción registrada en el historial.
class DomainEvent {
  final EventId id;
  final String type;
  final EntityId entityId;
  final Map<String, dynamic> payload;
  final DateTime timestamp;

  const DomainEvent({
    required this.id,
    required this.type,
    required this.entityId,
    required this.payload,
    required this.timestamp,
  });

  factory DomainEvent.create({
    required String type,
    required EntityId entityId,
    Map<String, dynamic> payload = const {},
  }) {
    return DomainEvent(
      id: EventId.generate(),
      type: type,
      entityId: entityId,
      payload: payload,
      timestamp: DateTime.now().toUtc(),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DomainEvent && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'DomainEvent(id: $id, type: "$type", entity: $entityId, time: $timestamp)';
}
