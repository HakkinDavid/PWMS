import '../constants/app_strings.dart';

enum PropertyDataType {
  real('real', AppStrings.dataTypeRealLabel),
  integer('integer', AppStrings.dataTypeIntegerLabel),
  string('string', AppStrings.dataTypeStringLabel),
  boolean('boolean', AppStrings.dataTypeBooleanLabel);

  final String code;
  final String label;

  const PropertyDataType(this.code, this.label);

  static PropertyDataType fromCode(String? code) {
    if (code == null) return PropertyDataType.real;
    final clean = code.trim().toLowerCase();
    switch (clean) {
      case 'integer':
      case 'entero':
      case 'int':
      case 'año':
        return PropertyDataType.integer;
      case 'string':
      case 'texto':
      case 'text':
        return PropertyDataType.string;
      case 'boolean':
      case 'booleano':
      case 'bool':
        return PropertyDataType.boolean;
      case 'real':
      case 'double':
      case 'float':
      case 'número real':
      default:
        return PropertyDataType.real;
    }
  }

  bool get isNumeric => this == PropertyDataType.real || this == PropertyDataType.integer;
  bool get isString => this == PropertyDataType.string;
  bool get isBoolean => this == PropertyDataType.boolean;
}
