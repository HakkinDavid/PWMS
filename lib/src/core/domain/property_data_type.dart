import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import 'package:platinum_world_management_system/src/core/constants/app_technical_strings.dart';

enum PropertyDataType {
  real(AppTechnicalStrings.datatypeRealLower, AppStrings.dataTypeRealLabel),
  integer(AppTechnicalStrings.datatypeIntegerLower, AppStrings.dataTypeIntegerLabel),
  string(AppTechnicalStrings.datatypeStringLower, AppStrings.dataTypeStringLabel),
  boolean(AppTechnicalStrings.datatypeBooleanLower, AppStrings.dataTypeBooleanLabel);

  final String code;
  final String label;

  const PropertyDataType(this.code, this.label);

  static PropertyDataType fromCode(String? code) {
    if (code == null) return PropertyDataType.real;
    final clean = code.trim().toLowerCase();
    switch (clean) {
      case AppTechnicalStrings.datatypeIntegerLower:
      case AppTechnicalStrings.datatypeEntero:
      case AppTechnicalStrings.datatypeInt:
      case AppTechnicalStrings.unitYear:
        return PropertyDataType.integer;
      case AppTechnicalStrings.datatypeStringLower:
      case AppTechnicalStrings.datatypeTexto:
      case AppTechnicalStrings.datatypeText:
        return PropertyDataType.string;
      case AppTechnicalStrings.datatypeBooleanLower:
      case AppTechnicalStrings.datatypeBooleano:
      case AppTechnicalStrings.datatypeBool:
        return PropertyDataType.boolean;
      case AppTechnicalStrings.datatypeRealLower:
      case AppTechnicalStrings.datatypeDouble:
      case AppTechnicalStrings.datatypeFloat:
      case AppTechnicalStrings.datatypeNumeroReal:
      default:
        return PropertyDataType.real;
    }
  }

  bool get isNumeric => this == PropertyDataType.real || this == PropertyDataType.integer;
  bool get isString => this == PropertyDataType.string;
  bool get isBoolean => this == PropertyDataType.boolean;
}

