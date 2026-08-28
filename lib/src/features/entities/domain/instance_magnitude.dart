import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import 'package:platinum_world_management_system/src/core/constants/app_technical_strings.dart';
import '../../../core/domain/domain_rules.dart';
import '../../../core/domain/property_data_type.dart';

part 'instance_magnitude.freezed.dart';
part 'instance_magnitude.g.dart';

@freezed
class InstanceMagnitude with _$InstanceMagnitude {
  const InstanceMagnitude._();

  const factory InstanceMagnitude({
    required String id,
    required String instanceId,
    required String propertyName,
    @Default(AppTechnicalStrings.datatypeRealLower) String dataType,
    double? magnitudeValue,
    String? stringValue,
    String? unitSymbol,
  }) = _InstanceMagnitude;

  factory InstanceMagnitude.fromJson(Map<String, dynamic> json) => _$InstanceMagnitudeFromJson(json);

  PropertyDataType get type => PropertyDataType.fromCode(dataType);

  String get displayValue {
    switch (type) {
      case PropertyDataType.string:
        return stringValue ?? AppTechnicalStrings.empty;
      case PropertyDataType.boolean:
        if (stringValue != null && stringValue!.isNotEmpty) {
          final clean = stringValue!.trim().toLowerCase();
          return (clean == AppTechnicalStrings.boolTrue ||
                  clean == AppTechnicalStrings.valOne ||
                  clean == AppTechnicalStrings.valSiWithAccent ||
                  clean == AppTechnicalStrings.valSiWithoutAccent)
              ? AppStrings.affirmativeYes
              : AppStrings.negativeNo;
        }
        if (magnitudeValue == null) return AppStrings.unspecifiedPropertyPlaceholder;
        return magnitudeValue! > 0 ? AppStrings.affirmativeYes : AppStrings.negativeNo;
      case PropertyDataType.integer:
        if (magnitudeValue == null) return AppStrings.unspecifiedPropertyPlaceholder;
        final formattedInt = magnitudeValue!.toInt().toString();
        final u = unitSymbol?.trim() ?? AppTechnicalStrings.empty;
        return u.isNotEmpty ? AppStrings.valueWithUnit(formattedInt, u) : formattedInt;
      case PropertyDataType.real:
        if (magnitudeValue == null) return AppStrings.unspecifiedPropertyPlaceholder;
        final formattedVal = DomainRules.formatMagnitude(magnitudeValue, unitSymbol);
        final u = unitSymbol?.trim() ?? AppTechnicalStrings.empty;
        return u.isNotEmpty ? AppStrings.valueWithUnit(formattedVal, u) : formattedVal;
    }
  }
}

