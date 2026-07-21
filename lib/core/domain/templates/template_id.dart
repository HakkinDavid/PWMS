/// Identificador inmutable de una plantilla en el dominio.
class TemplateId {
  final String value;

  const TemplateId(this.value) : assert(value.length > 0, 'TemplateId no puede estar vacío');

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TemplateId && runtimeType == other.runtimeType && value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}
