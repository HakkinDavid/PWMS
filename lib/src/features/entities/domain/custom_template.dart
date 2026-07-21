import 'package:freezed_annotation/freezed_annotation.dart';

part 'custom_template.freezed.dart';
part 'custom_template.g.dart';

@freezed
class CustomTemplate with _$CustomTemplate {
  const factory CustomTemplate({
    required String id,
    required String typeName,
    required String iconName,
    @Default(false) bool isContainer,
    @Default(false) bool isPlace,
    @Default([]) List<String> commonUnits,
    required DateTime createdAt,
  }) = _CustomTemplate;

  factory CustomTemplate.fromJson(Map<String, dynamic> json) => _$CustomTemplateFromJson(json);
}
