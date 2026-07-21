import 'package:uuid/uuid.dart';

/// Identificador inmutable de un evento auditable del dominio.
class EventId {
  final String value;

  const EventId(this.value) : assert(value.length > 0, 'EventId no puede estar vacío');

  factory EventId.generate() {
    return EventId(const Uuid().v4());
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventId && runtimeType == other.runtimeType && value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}
