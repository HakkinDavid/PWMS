import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';

part 'species_magnitude.freezed.dart';
part 'species_magnitude.g.dart';

@freezed
class SpeciesMagnitude with _$SpeciesMagnitude {
  const factory SpeciesMagnitude({
    required String id,
    required String speciesId,
    required String propertyName, // e.g. "Masa", "Volumen", "Material"
    @Default('real') String dataType, // 'real', 'integer', 'string', 'boolean'
    String? unitSymbol, // null for non-numeric, or valid unit for numeric
    required DateTime createdAt,
  }) = _SpeciesMagnitude;

  factory SpeciesMagnitude.fromJson(Map<String, dynamic> json) => _$SpeciesMagnitudeFromJson(json);
}

