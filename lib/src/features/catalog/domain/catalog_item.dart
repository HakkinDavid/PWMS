import 'package:freezed_annotation/freezed_annotation.dart';
import 'species_magnitude.dart';

part 'catalog_item.freezed.dart';
part 'catalog_item.g.dart';

@freezed
class CatalogItem with _$CatalogItem {
  const factory CatalogItem({
    required String id,
    required String name,
    @Default('Objeto') String type,
    String? description,
    String? mainPhotoPath,
    @Default({}) Map<String, dynamic> customAttributes,
    @Default([]) List<SpeciesMagnitude> magnitudes,
    @Default(false) bool isUnique,
    int? defaultShelfLifeDays,
    int? warningDaysBeforeExpiration,
    required DateTime createdAt,
  }) = _CatalogItem;

  factory CatalogItem.fromJson(Map<String, dynamic> json) => _$CatalogItemFromJson(json);
}
