// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'world_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WorldEntity _$WorldEntityFromJson(Map<String, dynamic> json) {
  return _WorldEntity.fromJson(json);
}

/// @nodoc
mixin _$WorldEntity {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get alias => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String? get mainPhotoPath => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  String? get placeId => throw _privateConstructorUsedError;
  String? get parentEntityId => throw _privateConstructorUsedError;
  double? get quantity => throw _privateConstructorUsedError;
  String? get unit => throw _privateConstructorUsedError;
  String? get barcode => throw _privateConstructorUsedError;
  Map<String, dynamic> get customAttributes =>
      throw _privateConstructorUsedError;
  bool get isArchived => throw _privateConstructorUsedError;
  bool get isContainer => throw _privateConstructorUsedError;
  bool get isPlace => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this WorldEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorldEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorldEntityCopyWith<WorldEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorldEntityCopyWith<$Res> {
  factory $WorldEntityCopyWith(
          WorldEntity value, $Res Function(WorldEntity) then) =
      _$WorldEntityCopyWithImpl<$Res, WorldEntity>;
  @useResult
  $Res call(
      {String id,
      String name,
      String? alias,
      String type,
      String? mainPhotoPath,
      String? notes,
      String? placeId,
      String? parentEntityId,
      double? quantity,
      String? unit,
      String? barcode,
      Map<String, dynamic> customAttributes,
      bool isArchived,
      bool isContainer,
      bool isPlace,
      List<String> tags,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$WorldEntityCopyWithImpl<$Res, $Val extends WorldEntity>
    implements $WorldEntityCopyWith<$Res> {
  _$WorldEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorldEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? alias = freezed,
    Object? type = null,
    Object? mainPhotoPath = freezed,
    Object? notes = freezed,
    Object? placeId = freezed,
    Object? parentEntityId = freezed,
    Object? quantity = freezed,
    Object? unit = freezed,
    Object? barcode = freezed,
    Object? customAttributes = null,
    Object? isArchived = null,
    Object? isContainer = null,
    Object? isPlace = null,
    Object? tags = null,
    Object? createdAt = null,
    Object? updatedAt = null,
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
      alias: freezed == alias
          ? _value.alias
          : alias // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      mainPhotoPath: freezed == mainPhotoPath
          ? _value.mainPhotoPath
          : mainPhotoPath // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      placeId: freezed == placeId
          ? _value.placeId
          : placeId // ignore: cast_nullable_to_non_nullable
              as String?,
      parentEntityId: freezed == parentEntityId
          ? _value.parentEntityId
          : parentEntityId // ignore: cast_nullable_to_non_nullable
              as String?,
      quantity: freezed == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double?,
      unit: freezed == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String?,
      barcode: freezed == barcode
          ? _value.barcode
          : barcode // ignore: cast_nullable_to_non_nullable
              as String?,
      customAttributes: null == customAttributes
          ? _value.customAttributes
          : customAttributes // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      isArchived: null == isArchived
          ? _value.isArchived
          : isArchived // ignore: cast_nullable_to_non_nullable
              as bool,
      isContainer: null == isContainer
          ? _value.isContainer
          : isContainer // ignore: cast_nullable_to_non_nullable
              as bool,
      isPlace: null == isPlace
          ? _value.isPlace
          : isPlace // ignore: cast_nullable_to_non_nullable
              as bool,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorldEntityImplCopyWith<$Res>
    implements $WorldEntityCopyWith<$Res> {
  factory _$$WorldEntityImplCopyWith(
          _$WorldEntityImpl value, $Res Function(_$WorldEntityImpl) then) =
      __$$WorldEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String? alias,
      String type,
      String? mainPhotoPath,
      String? notes,
      String? placeId,
      String? parentEntityId,
      double? quantity,
      String? unit,
      String? barcode,
      Map<String, dynamic> customAttributes,
      bool isArchived,
      bool isContainer,
      bool isPlace,
      List<String> tags,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$WorldEntityImplCopyWithImpl<$Res>
    extends _$WorldEntityCopyWithImpl<$Res, _$WorldEntityImpl>
    implements _$$WorldEntityImplCopyWith<$Res> {
  __$$WorldEntityImplCopyWithImpl(
      _$WorldEntityImpl _value, $Res Function(_$WorldEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of WorldEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? alias = freezed,
    Object? type = null,
    Object? mainPhotoPath = freezed,
    Object? notes = freezed,
    Object? placeId = freezed,
    Object? parentEntityId = freezed,
    Object? quantity = freezed,
    Object? unit = freezed,
    Object? barcode = freezed,
    Object? customAttributes = null,
    Object? isArchived = null,
    Object? isContainer = null,
    Object? isPlace = null,
    Object? tags = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$WorldEntityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      alias: freezed == alias
          ? _value.alias
          : alias // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      mainPhotoPath: freezed == mainPhotoPath
          ? _value.mainPhotoPath
          : mainPhotoPath // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      placeId: freezed == placeId
          ? _value.placeId
          : placeId // ignore: cast_nullable_to_non_nullable
              as String?,
      parentEntityId: freezed == parentEntityId
          ? _value.parentEntityId
          : parentEntityId // ignore: cast_nullable_to_non_nullable
              as String?,
      quantity: freezed == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double?,
      unit: freezed == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String?,
      barcode: freezed == barcode
          ? _value.barcode
          : barcode // ignore: cast_nullable_to_non_nullable
              as String?,
      customAttributes: null == customAttributes
          ? _value._customAttributes
          : customAttributes // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      isArchived: null == isArchived
          ? _value.isArchived
          : isArchived // ignore: cast_nullable_to_non_nullable
              as bool,
      isContainer: null == isContainer
          ? _value.isContainer
          : isContainer // ignore: cast_nullable_to_non_nullable
              as bool,
      isPlace: null == isPlace
          ? _value.isPlace
          : isPlace // ignore: cast_nullable_to_non_nullable
              as bool,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorldEntityImpl implements _WorldEntity {
  const _$WorldEntityImpl(
      {required this.id,
      required this.name,
      this.alias,
      required this.type,
      this.mainPhotoPath,
      this.notes,
      this.placeId,
      this.parentEntityId,
      this.quantity,
      this.unit,
      this.barcode,
      final Map<String, dynamic> customAttributes = const {},
      this.isArchived = false,
      this.isContainer = false,
      this.isPlace = false,
      final List<String> tags = const [],
      required this.createdAt,
      required this.updatedAt})
      : _customAttributes = customAttributes,
        _tags = tags;

  factory _$WorldEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorldEntityImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? alias;
  @override
  final String type;
  @override
  final String? mainPhotoPath;
  @override
  final String? notes;
  @override
  final String? placeId;
  @override
  final String? parentEntityId;
  @override
  final double? quantity;
  @override
  final String? unit;
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
  @JsonKey()
  final bool isArchived;
  @override
  @JsonKey()
  final bool isContainer;
  @override
  @JsonKey()
  final bool isPlace;
  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'WorldEntity(id: $id, name: $name, alias: $alias, type: $type, mainPhotoPath: $mainPhotoPath, notes: $notes, placeId: $placeId, parentEntityId: $parentEntityId, quantity: $quantity, unit: $unit, barcode: $barcode, customAttributes: $customAttributes, isArchived: $isArchived, isContainer: $isContainer, isPlace: $isPlace, tags: $tags, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorldEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.alias, alias) || other.alias == alias) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.mainPhotoPath, mainPhotoPath) ||
                other.mainPhotoPath == mainPhotoPath) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.placeId, placeId) || other.placeId == placeId) &&
            (identical(other.parentEntityId, parentEntityId) ||
                other.parentEntityId == parentEntityId) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.barcode, barcode) || other.barcode == barcode) &&
            const DeepCollectionEquality()
                .equals(other._customAttributes, _customAttributes) &&
            (identical(other.isArchived, isArchived) ||
                other.isArchived == isArchived) &&
            (identical(other.isContainer, isContainer) ||
                other.isContainer == isContainer) &&
            (identical(other.isPlace, isPlace) || other.isPlace == isPlace) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      alias,
      type,
      mainPhotoPath,
      notes,
      placeId,
      parentEntityId,
      quantity,
      unit,
      barcode,
      const DeepCollectionEquality().hash(_customAttributes),
      isArchived,
      isContainer,
      isPlace,
      const DeepCollectionEquality().hash(_tags),
      createdAt,
      updatedAt);

  /// Create a copy of WorldEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorldEntityImplCopyWith<_$WorldEntityImpl> get copyWith =>
      __$$WorldEntityImplCopyWithImpl<_$WorldEntityImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorldEntityImplToJson(
      this,
    );
  }
}

abstract class _WorldEntity implements WorldEntity {
  const factory _WorldEntity(
      {required final String id,
      required final String name,
      final String? alias,
      required final String type,
      final String? mainPhotoPath,
      final String? notes,
      final String? placeId,
      final String? parentEntityId,
      final double? quantity,
      final String? unit,
      final String? barcode,
      final Map<String, dynamic> customAttributes,
      final bool isArchived,
      final bool isContainer,
      final bool isPlace,
      final List<String> tags,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$WorldEntityImpl;

  factory _WorldEntity.fromJson(Map<String, dynamic> json) =
      _$WorldEntityImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get alias;
  @override
  String get type;
  @override
  String? get mainPhotoPath;
  @override
  String? get notes;
  @override
  String? get placeId;
  @override
  String? get parentEntityId;
  @override
  double? get quantity;
  @override
  String? get unit;
  @override
  String? get barcode;
  @override
  Map<String, dynamic> get customAttributes;
  @override
  bool get isArchived;
  @override
  bool get isContainer;
  @override
  bool get isPlace;
  @override
  List<String> get tags;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of WorldEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorldEntityImplCopyWith<_$WorldEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
