import 'package:freezed_annotation/freezed_annotation.dart';
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
    @Default('real') String dataType,
    @Default(0.0) double magnitudeValue,
    String? stringValue,
    String? unitSymbol,
  }) = _InstanceMagnitude;

  factory InstanceMagnitude.fromJson(Map<String, dynamic> json) => _$InstanceMagnitudeFromJson(json);

  PropertyDataType get type => PropertyDataType.fromCode(dataType);

  String get displayValue {
    switch (type) {
      case PropertyDataType.string:
        return stringValue ?? '';
      case PropertyDataType.boolean:
        if (stringValue != null && stringValue!.isNotEmpty) {
          final clean = stringValue!.trim().toLowerCase();
          return (clean == 'true' || clean == '1' || clean == 'sí' || clean == 'si') ? 'Sí' : 'No';
        }
        return magnitudeValue > 0 ? 'Sí' : 'No';
      case PropertyDataType.integer:
        final formattedInt = magnitudeValue.toInt().toString();
        final u = unitSymbol?.trim() ?? '';
        return u.isNotEmpty ? '$formattedInt $u' : formattedInt;
      case PropertyDataType.real:
        final formattedVal = DomainRules.formatMagnitude(magnitudeValue, unitSymbol);
        final u = unitSymbol?.trim() ?? '';
        return u.isNotEmpty ? '$formattedVal $u' : formattedVal;
    }
  }
}

