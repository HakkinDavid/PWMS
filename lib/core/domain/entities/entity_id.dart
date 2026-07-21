import 'package:uuid/uuid.dart';

/// Identificador permanente e inmutable de una entidad en el dominio.
class EntityId {
  final String value;

  const EntityId(this.value) : assert(value.length > 0, 'EntityId no puede estar vacío');

  /// Genera un nuevo [EntityId] único basado en UUID v4.
  factory EntityId.generate() {
    return EntityId(const Uuid().v4());
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EntityId && runtimeType == other.runtimeType && value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}
