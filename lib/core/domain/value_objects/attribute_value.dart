/// Objeto de Valor inmutable que representa el valor de un atributo.
class AttributeValue {
  final Object value;

  const AttributeValue(this.value);

  /// Constructores de conveniencia fuertemente tipados
  factory AttributeValue.string(String val) => AttributeValue(val);
  factory AttributeValue.number(num val) => AttributeValue(val);
  factory AttributeValue.boolean(bool val) => AttributeValue(val);
  factory AttributeValue.dateTime(DateTime val) => AttributeValue(val.toIso8601String());

  String get asString => value.toString();

  num? get asNumber => value is num ? value as num : num.tryParse(value.toString());

  bool get asBoolean => value is bool
      ? value as bool
      : (value.toString().toLowerCase() == 'true' || value.toString() == '1');

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AttributeValue &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value.toString();
}
