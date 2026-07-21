import 'package:freezed_annotation/freezed_annotation.dart';

part 'instance_magnitude.freezed.dart';
part 'instance_magnitude.g.dart';

@freezed
class InstanceMagnitude with _$InstanceMagnitude {
  const factory InstanceMagnitude({
    required String id,
    required String instanceId,
    required String propertyName,
    required double magnitudeValue,
    required String unitSymbol,
  }) = _InstanceMagnitude;

  factory InstanceMagnitude.fromJson(Map<String, dynamic> json) => _$InstanceMagnitudeFromJson(json);
}
