import 'package:freezed_annotation/freezed_annotation.dart';
import 'species_magnitude.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';

part 'catalog_item.freezed.dart';
part 'catalog_item.g.dart';

@freezed
class CatalogItem with _$CatalogItem {
  const factory CatalogItem({
    required String id,
    required String name,
    @Default(AppStrings.typeObject) String type,
    String? description,
    String? mainPhotoPath,
    @Default({}) Map<String, dynamic> customAttributes,
    @Default([]) List<SpeciesMagnitude> magnitudes,
    @Default(false) bool isUnique,
    @Default(true) bool isNonPerishable,
    int? defaultShelfLifeDays,
    int? warningDaysBeforeExpiration,
    required DateTime createdAt,
  }) = _CatalogItem;

  const CatalogItem._();

  bool get canExpire => type == AppStrings.typeObject && !isNonPerishable;

  factory CatalogItem.fromJson(Map<String, dynamic> json) => _$CatalogItemFromJson(json);
}
