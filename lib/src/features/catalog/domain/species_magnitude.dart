import 'package:freezed_annotation/freezed_annotation.dart';

part 'species_magnitude.freezed.dart';
part 'species_magnitude.g.dart';

@freezed
class SpeciesMagnitude with _$SpeciesMagnitude {
  const factory SpeciesMagnitude({
    required String id,
    required String speciesId,
    required String propertyName, // e.g. "Masa", "Volumen", "Magnitud Principal"
    required double magnitudeValue,
    required String unitSymbol,
    required DateTime createdAt,
  }) = _SpeciesMagnitude;

  factory SpeciesMagnitude.fromJson(Map<String, dynamic> json) => _$SpeciesMagnitudeFromJson(json);
}
