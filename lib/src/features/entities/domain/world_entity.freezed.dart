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
  String get speciesId =>
      throw _privateConstructorUsedError; // Link to Catalog species
  String? get subspeciesId =>
      throw _privateConstructorUsedError; // Optional link to Subspecies variant
  String? get locationId =>
      throw _privateConstructorUsedError; // Link to Location Graph node
  List<InstanceMagnitude> get magnitudes => throw _privateConstructorUsedError;
  DateTime? get expirationDate => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
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
      String speciesId,
      String? subspeciesId,
      String? locationId,
      List<InstanceMagnitude> magnitudes,
      DateTime? expirationDate,
      String? notes,
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
    Object? speciesId = null,
    Object? subspeciesId = freezed,
    Object? locationId = freezed,
    Object? magnitudes = null,
    Object? expirationDate = freezed,
    Object? notes = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      speciesId: null == speciesId
          ? _value.speciesId
          : speciesId // ignore: cast_nullable_to_non_nullable
              as String,
      subspeciesId: freezed == subspeciesId
          ? _value.subspeciesId
          : subspeciesId // ignore: cast_nullable_to_non_nullable
              as String?,
      locationId: freezed == locationId
          ? _value.locationId
          : locationId // ignore: cast_nullable_to_non_nullable
              as String?,
      magnitudes: null == magnitudes
          ? _value.magnitudes
          : magnitudes // ignore: cast_nullable_to_non_nullable
              as List<InstanceMagnitude>,
      expirationDate: freezed == expirationDate
          ? _value.expirationDate
          : expirationDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
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
      String speciesId,
      String? subspeciesId,
      String? locationId,
      List<InstanceMagnitude> magnitudes,
      DateTime? expirationDate,
      String? notes,
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
    Object? speciesId = null,
    Object? subspeciesId = freezed,
    Object? locationId = freezed,
    Object? magnitudes = null,
    Object? expirationDate = freezed,
    Object? notes = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$WorldEntityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      speciesId: null == speciesId
          ? _value.speciesId
          : speciesId // ignore: cast_nullable_to_non_nullable
              as String,
      subspeciesId: freezed == subspeciesId
          ? _value.subspeciesId
          : subspeciesId // ignore: cast_nullable_to_non_nullable
              as String?,
      locationId: freezed == locationId
          ? _value.locationId
          : locationId // ignore: cast_nullable_to_non_nullable
              as String?,
      magnitudes: null == magnitudes
          ? _value._magnitudes
          : magnitudes // ignore: cast_nullable_to_non_nullable
              as List<InstanceMagnitude>,
      expirationDate: freezed == expirationDate
          ? _value.expirationDate
          : expirationDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
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
class _$WorldEntityImpl extends _WorldEntity {
  const _$WorldEntityImpl(
      {required this.id,
      required this.speciesId,
      this.subspeciesId,
      this.locationId,
      final List<InstanceMagnitude> magnitudes = const [],
      this.expirationDate,
      this.notes,
      required this.createdAt,
      required this.updatedAt})
      : _magnitudes = magnitudes,
        super._();

  factory _$WorldEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorldEntityImplFromJson(json);

  @override
  final String id;
  @override
  final String speciesId;
// Link to Catalog species
  @override
  final String? subspeciesId;
// Optional link to Subspecies variant
  @override
  final String? locationId;
// Link to Location Graph node
  final List<InstanceMagnitude> _magnitudes;
// Link to Location Graph node
  @override
  @JsonKey()
  List<InstanceMagnitude> get magnitudes {
    if (_magnitudes is EqualUnmodifiableListView) return _magnitudes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_magnitudes);
  }

  @override
  final DateTime? expirationDate;
  @override
  final String? notes;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'WorldEntity(id: $id, speciesId: $speciesId, subspeciesId: $subspeciesId, locationId: $locationId, magnitudes: $magnitudes, expirationDate: $expirationDate, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorldEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.speciesId, speciesId) ||
                other.speciesId == speciesId) &&
            (identical(other.subspeciesId, subspeciesId) ||
                other.subspeciesId == subspeciesId) &&
            (identical(other.locationId, locationId) ||
                other.locationId == locationId) &&
            const DeepCollectionEquality()
                .equals(other._magnitudes, _magnitudes) &&
            (identical(other.expirationDate, expirationDate) ||
                other.expirationDate == expirationDate) &&
            (identical(other.notes, notes) || other.notes == notes) &&
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
      speciesId,
      subspeciesId,
      locationId,
      const DeepCollectionEquality().hash(_magnitudes),
      expirationDate,
      notes,
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

abstract class _WorldEntity extends WorldEntity {
  const factory _WorldEntity(
      {required final String id,
      required final String speciesId,
      final String? subspeciesId,
      final String? locationId,
      final List<InstanceMagnitude> magnitudes,
      final DateTime? expirationDate,
      final String? notes,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$WorldEntityImpl;
  const _WorldEntity._() : super._();

  factory _WorldEntity.fromJson(Map<String, dynamic> json) =
      _$WorldEntityImpl.fromJson;

  @override
  String get id;
  @override
  String get speciesId; // Link to Catalog species
  @override
  String? get subspeciesId; // Optional link to Subspecies variant
  @override
  String? get locationId; // Link to Location Graph node
  @override
  List<InstanceMagnitude> get magnitudes;
  @override
  DateTime? get expirationDate;
  @override
  String? get notes;
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
