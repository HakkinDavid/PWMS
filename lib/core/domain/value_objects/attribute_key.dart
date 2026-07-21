/// Objeto de Valor que representa la clave de un atributo en una entidad o plantilla.
class AttributeKey {
  final String value;

  const AttributeKey(this.value)
      : assert(value.length > 0, 'AttributeKey no puede estar vacío');

  /// Claves estándar comunes como constantes de conveniencia (no restrictivas).
  static const AttributeKey name = AttributeKey('name');
  static const AttributeKey description = AttributeKey('description');
  static const AttributeKey kind = AttributeKey('kind');

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AttributeKey &&
          runtimeType == other.runtimeType &&
          value.toLowerCase() == other.value.toLowerCase();

  @override
  int get hashCode => value.toLowerCase().hashCode;

  @override
  String toString() => value;
}
