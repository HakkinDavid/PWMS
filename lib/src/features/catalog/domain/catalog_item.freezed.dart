// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'catalog_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CatalogItem _$CatalogItemFromJson(Map<String, dynamic> json) {
  return _CatalogItem.fromJson(json);
}

/// @nodoc
mixin _$CatalogItem {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String? get brand => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get mainPhotoPath => throw _privateConstructorUsedError;
  String? get barcode => throw _privateConstructorUsedError;
  Map<String, dynamic> get customAttributes =>
      throw _privateConstructorUsedError;
  String? get defaultUnit => throw _privateConstructorUsedError;
  bool get isUnique => throw _privateConstructorUsedError;
  bool get hasMonetaryValue => throw _privateConstructorUsedError;
  String get defaultMonetaryCurrency => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this CatalogItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CatalogItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CatalogItemCopyWith<CatalogItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CatalogItemCopyWith<$Res> {
  factory $CatalogItemCopyWith(
          CatalogItem value, $Res Function(CatalogItem) then) =
      _$CatalogItemCopyWithImpl<$Res, CatalogItem>;
  @useResult
  $Res call(
      {String id,
      String name,
      String type,
      String? brand,
      String? description,
      String? mainPhotoPath,
      String? barcode,
      Map<String, dynamic> customAttributes,
      String? defaultUnit,
      bool isUnique,
      bool hasMonetaryValue,
      String defaultMonetaryCurrency,
      DateTime createdAt});
}

/// @nodoc
class _$CatalogItemCopyWithImpl<$Res, $Val extends CatalogItem>
    implements $CatalogItemCopyWith<$Res> {
  _$CatalogItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CatalogItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? brand = freezed,
    Object? description = freezed,
    Object? mainPhotoPath = freezed,
    Object? barcode = freezed,
    Object? customAttributes = null,
    Object? defaultUnit = freezed,
    Object? isUnique = null,
    Object? hasMonetaryValue = null,
    Object? defaultMonetaryCurrency = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      brand: freezed == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      mainPhotoPath: freezed == mainPhotoPath
          ? _value.mainPhotoPath
          : mainPhotoPath // ignore: cast_nullable_to_non_nullable
              as String?,
      barcode: freezed == barcode
          ? _value.barcode
          : barcode // ignore: cast_nullable_to_non_nullable
              as String?,
      customAttributes: null == customAttributes
          ? _value.customAttributes
          : customAttributes // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      defaultUnit: freezed == defaultUnit
          ? _value.defaultUnit
          : defaultUnit // ignore: cast_nullable_to_non_nullable
              as String?,
      isUnique: null == isUnique
          ? _value.isUnique
          : isUnique // ignore: cast_nullable_to_non_nullable
              as bool,
      hasMonetaryValue: null == hasMonetaryValue
          ? _value.hasMonetaryValue
          : hasMonetaryValue // ignore: cast_nullable_to_non_nullable
              as bool,
      defaultMonetaryCurrency: null == defaultMonetaryCurrency
          ? _value.defaultMonetaryCurrency
          : defaultMonetaryCurrency // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CatalogItemImplCopyWith<$Res>
    implements $CatalogItemCopyWith<$Res> {
  factory _$$CatalogItemImplCopyWith(
          _$CatalogItemImpl value, $Res Function(_$CatalogItemImpl) then) =
      __$$CatalogItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String type,
      String? brand,
      String? description,
      String? mainPhotoPath,
      String? barcode,
      Map<String, dynamic> customAttributes,
      String? defaultUnit,
      bool isUnique,
      bool hasMonetaryValue,
      String defaultMonetaryCurrency,
      DateTime createdAt});
}

/// @nodoc
class __$$CatalogItemImplCopyWithImpl<$Res>
    extends _$CatalogItemCopyWithImpl<$Res, _$CatalogItemImpl>
    implements _$$CatalogItemImplCopyWith<$Res> {
  __$$CatalogItemImplCopyWithImpl(
      _$CatalogItemImpl _value, $Res Function(_$CatalogItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of CatalogItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? brand = freezed,
    Object? description = freezed,
    Object? mainPhotoPath = freezed,
    Object? barcode = freezed,
    Object? customAttributes = null,
    Object? defaultUnit = freezed,
    Object? isUnique = null,
    Object? hasMonetaryValue = null,
    Object? defaultMonetaryCurrency = null,
    Object? createdAt = null,
  }) {
    return _then(_$CatalogItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      brand: freezed == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      mainPhotoPath: freezed == mainPhotoPath
          ? _value.mainPhotoPath
          : mainPhotoPath // ignore: cast_nullable_to_non_nullable
              as String?,
      barcode: freezed == barcode
          ? _value.barcode
          : barcode // ignore: cast_nullable_to_non_nullable
              as String?,
      customAttributes: null == customAttributes
          ? _value._customAttributes
          : customAttributes // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      defaultUnit: freezed == defaultUnit
          ? _value.defaultUnit
          : defaultUnit // ignore: cast_nullable_to_non_nullable
              as String?,
      isUnique: null == isUnique
          ? _value.isUnique
          : isUnique // ignore: cast_nullable_to_non_nullable
              as bool,
      hasMonetaryValue: null == hasMonetaryValue
          ? _value.hasMonetaryValue
          : hasMonetaryValue // ignore: cast_nullable_to_non_nullable
              as bool,
      defaultMonetaryCurrency: null == defaultMonetaryCurrency
          ? _value.defaultMonetaryCurrency
          : defaultMonetaryCurrency // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CatalogItemImpl implements _CatalogItem {
  const _$CatalogItemImpl(
      {required this.id,
      required this.name,
      this.type = 'Objeto',
      this.brand,
      this.description,
      this.mainPhotoPath,
      this.barcode,
      final Map<String, dynamic> customAttributes = const {},
      this.defaultUnit,
      this.isUnique = false,
      this.hasMonetaryValue = true,
      this.defaultMonetaryCurrency = 'MXN',
      required this.createdAt})
      : _customAttributes = customAttributes;

  factory _$CatalogItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$CatalogItemImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  @JsonKey()
  final String type;
  @override
  final String? brand;
  @override
  final String? description;
  @override
  final String? mainPhotoPath;
  @override
  final String? barcode;
  final Map<String, dynamic> _customAttributes;
  @override
  @JsonKey()
  Map<String, dynamic> get customAttributes {
    if (_customAttributes is EqualUnmodifiableMapView) return _customAttributes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_customAttributes);
  }

  @override
  final String? defaultUnit;
  @override
  @JsonKey()
  final bool isUnique;
  @override
  @JsonKey()
  final bool hasMonetaryValue;
  @override
  @JsonKey()
  final String defaultMonetaryCurrency;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'CatalogItem(id: $id, name: $name, type: $type, brand: $brand, description: $description, mainPhotoPath: $mainPhotoPath, barcode: $barcode, customAttributes: $customAttributes, defaultUnit: $defaultUnit, isUnique: $isUnique, hasMonetaryValue: $hasMonetaryValue, defaultMonetaryCurrency: $defaultMonetaryCurrency, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CatalogItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.brand, brand) || other.brand == brand) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.mainPhotoPath, mainPhotoPath) ||
                other.mainPhotoPath == mainPhotoPath) &&
            (identical(other.barcode, barcode) || other.barcode == barcode) &&
            const DeepCollectionEquality()
                .equals(other._customAttributes, _customAttributes) &&
            (identical(other.defaultUnit, defaultUnit) ||
                other.defaultUnit == defaultUnit) &&
            (identical(other.isUnique, isUnique) ||
                other.isUnique == isUnique) &&
            (identical(other.hasMonetaryValue, hasMonetaryValue) ||
                other.hasMonetaryValue == hasMonetaryValue) &&
            (identical(
                    other.defaultMonetaryCurrency, defaultMonetaryCurrency) ||
                other.defaultMonetaryCurrency == defaultMonetaryCurrency) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      type,
      brand,
      description,
      mainPhotoPath,
      barcode,
      const DeepCollectionEquality().hash(_customAttributes),
      defaultUnit,
      isUnique,
      hasMonetaryValue,
      defaultMonetaryCurrency,
      createdAt);

  /// Create a copy of CatalogItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CatalogItemImplCopyWith<_$CatalogItemImpl> get copyWith =>
      __$$CatalogItemImplCopyWithImpl<_$CatalogItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CatalogItemImplToJson(
      this,
    );
  }
}

abstract class _CatalogItem implements CatalogItem {
  const factory _CatalogItem(
      {required final String id,
      required final String name,
      final String type,
      final String? brand,
      final String? description,
      final String? mainPhotoPath,
      final String? barcode,
      final Map<String, dynamic> customAttributes,
      final String? defaultUnit,
      final bool isUnique,
      final bool hasMonetaryValue,
      final String defaultMonetaryCurrency,
      required final DateTime createdAt}) = _$CatalogItemImpl;

  factory _CatalogItem.fromJson(Map<String, dynamic> json) =
      _$CatalogItemImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get type;
  @override
  String? get brand;
  @override
  String? get description;
  @override
  String? get mainPhotoPath;
  @override
  String? get barcode;
  @override
  Map<String, dynamic> get customAttributes;
  @override
  String? get defaultUnit;
  @override
  bool get isUnique;
  @override
  bool get hasMonetaryValue;
  @override
  String get defaultMonetaryCurrency;
  @override
  DateTime get createdAt;

  /// Create a copy of CatalogItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CatalogItemImplCopyWith<_$CatalogItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
