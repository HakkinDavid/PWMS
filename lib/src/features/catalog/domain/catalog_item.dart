import 'package:freezed_annotation/freezed_annotation.dart';

part 'catalog_item.freezed.dart';
part 'catalog_item.g.dart';

@freezed
class CatalogItem with _$CatalogItem {
  const factory CatalogItem({
    required String id,
    required String name,
    @Default('Objeto') String type,
    String? brand,
    String? description,
    String? mainPhotoPath,
    String? barcode,
    @Default({}) Map<String, dynamic> customAttributes,
    String? defaultUnit,
    @Default(false) bool isUnique,
    @Default(true) bool hasMonetaryValue,
    @Default('MXN') String defaultMonetaryCurrency,
    required DateTime createdAt,
  }) = _CatalogItem;

  factory CatalogItem.fromJson(Map<String, dynamic> json) => _$CatalogItemFromJson(json);
}
