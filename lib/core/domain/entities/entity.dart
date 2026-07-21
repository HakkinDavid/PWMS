import '../templates/template_id.dart';
import '../value_objects/attribute_key.dart';
import '../value_objects/attribute_value.dart';
import 'entity_id.dart';

/// Agregado principal: Entidad genérica del mundo personal.
///
/// En el PWMS no existen clases rígidas (herramienta, vehículo, animal, persona).
/// Todas son simplemente [Entity]. Sus diferencias provienen exclusivamente de sus
/// atributos y relaciones.
class Entity {
  final EntityId id;
  final TemplateId? templateId;
  final EntityId? parentId;
  final Map<AttributeKey, AttributeValue> attributes;

  const Entity({
    required this.id,
    this.templateId,
    this.parentId,
    this.attributes = const {},
  });

  /// Nombre de la entidad obtenido del atributo 'name' o fallback con su identificador.
  String get name => attributes[AttributeKey.name]?.asString ?? 'Sin Nombre';

  /// Descripción opcional obtenida del atributo 'description'.
  String? get description => attributes[AttributeKey.description]?.asString;

  /// Tipo semántico visual ('space', 'container', 'object', 'document', 'resource').
  String get kind => attributes[AttributeKey.kind]?.asString ?? 'object';

  /// Crea una copia inmutable con los campos modificados.
  Entity copyWith({
    EntityId? id,
    TemplateId? templateId,
    Object? parentId = const _Sentinel(),
    Map<AttributeKey, AttributeValue>? attributes,
  }) {
    return Entity(
      id: id ?? this.id,
      templateId: templateId ?? this.templateId,
      parentId: parentId is _Sentinel ? this.parentId : (parentId as EntityId?),
      attributes: attributes ?? this.attributes,
    );
  }

  /// Retorna una nueva entidad con un atributo agregado o reemplazado.
  Entity withAttribute(AttributeKey key, AttributeValue value) {
    final newAttributes = Map<AttributeKey, AttributeValue>.from(attributes);
    newAttributes[key] = value;
    return copyWith(attributes: newAttributes);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Entity && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Entity(id: $id, name: "$name", parent: $parentId)';
}

class _Sentinel {
  const _Sentinel();
}
