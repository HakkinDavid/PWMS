// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'species_magnitude.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SpeciesMagnitude _$SpeciesMagnitudeFromJson(Map<String, dynamic> json) {
  return _SpeciesMagnitude.fromJson(json);
}

/// @nodoc
mixin _$SpeciesMagnitude {
  String get id => throw _privateConstructorUsedError;
  String get speciesId => throw _privateConstructorUsedError;
  String get propertyName =>
      throw _privateConstructorUsedError; // e.g. "Masa", "Volumen", "Material"
  String get dataType =>
      throw _privateConstructorUsedError; // 'real', 'integer', 'string', 'boolean'
  String? get unitSymbol =>
      throw _privateConstructorUsedError; // null for non-numeric, or valid unit for numeric
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this SpeciesMagnitude to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SpeciesMagnitude
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SpeciesMagnitudeCopyWith<SpeciesMagnitude> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpeciesMagnitudeCopyWith<$Res> {
  factory $SpeciesMagnitudeCopyWith(
          SpeciesMagnitude value, $Res Function(SpeciesMagnitude) then) =
      _$SpeciesMagnitudeCopyWithImpl<$Res, SpeciesMagnitude>;
  @useResult
  $Res call(
      {String id,
      String speciesId,
      String propertyName,
      String dataType,
      String? unitSymbol,
      DateTime createdAt});
}

/// @nodoc
class _$SpeciesMagnitudeCopyWithImpl<$Res, $Val extends SpeciesMagnitude>
    implements $SpeciesMagnitudeCopyWith<$Res> {
  _$SpeciesMagnitudeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SpeciesMagnitude
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? speciesId = null,
    Object? propertyName = null,
    Object? dataType = null,
    Object? unitSymbol = freezed,
    Object? createdAt = null,
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
      propertyName: null == propertyName
          ? _value.propertyName
          : propertyName // ignore: cast_nullable_to_non_nullable
              as String,
      dataType: null == dataType
          ? _value.dataType
          : dataType // ignore: cast_nullable_to_non_nullable
              as String,
      unitSymbol: freezed == unitSymbol
          ? _value.unitSymbol
          : unitSymbol // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SpeciesMagnitudeImplCopyWith<$Res>
    implements $SpeciesMagnitudeCopyWith<$Res> {
  factory _$$SpeciesMagnitudeImplCopyWith(_$SpeciesMagnitudeImpl value,
          $Res Function(_$SpeciesMagnitudeImpl) then) =
      __$$SpeciesMagnitudeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String speciesId,
      String propertyName,
      String dataType,
      String? unitSymbol,
      DateTime createdAt});
}

/// @nodoc
class __$$SpeciesMagnitudeImplCopyWithImpl<$Res>
    extends _$SpeciesMagnitudeCopyWithImpl<$Res, _$SpeciesMagnitudeImpl>
    implements _$$SpeciesMagnitudeImplCopyWith<$Res> {
  __$$SpeciesMagnitudeImplCopyWithImpl(_$SpeciesMagnitudeImpl _value,
      $Res Function(_$SpeciesMagnitudeImpl) _then)
      : super(_value, _then);

  /// Create a copy of SpeciesMagnitude
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? speciesId = null,
    Object? propertyName = null,
    Object? dataType = null,
    Object? unitSymbol = freezed,
    Object? createdAt = null,
  }) {
    return _then(_$SpeciesMagnitudeImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      speciesId: null == speciesId
          ? _value.speciesId
          : speciesId // ignore: cast_nullable_to_non_nullable
              as String,
      propertyName: null == propertyName
          ? _value.propertyName
          : propertyName // ignore: cast_nullable_to_non_nullable
              as String,
      dataType: null == dataType
          ? _value.dataType
          : dataType // ignore: cast_nullable_to_non_nullable
              as String,
      unitSymbol: freezed == unitSymbol
          ? _value.unitSymbol
          : unitSymbol // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SpeciesMagnitudeImpl implements _SpeciesMagnitude {
  const _$SpeciesMagnitudeImpl(
      {required this.id,
      required this.speciesId,
      required this.propertyName,
      this.dataType = 'real',
      this.unitSymbol,
      required this.createdAt});

  factory _$SpeciesMagnitudeImpl.fromJson(Map<String, dynamic> json) =>
      _$$SpeciesMagnitudeImplFromJson(json);

  @override
  final String id;
  @override
  final String speciesId;
  @override
  final String propertyName;
// e.g. "Masa", "Volumen", "Material"
  @override
  @JsonKey()
  final String dataType;
// 'real', 'integer', 'string', 'boolean'
  @override
  final String? unitSymbol;
// null for non-numeric, or valid unit for numeric
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'SpeciesMagnitude(id: $id, speciesId: $speciesId, propertyName: $propertyName, dataType: $dataType, unitSymbol: $unitSymbol, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpeciesMagnitudeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.speciesId, speciesId) ||
                other.speciesId == speciesId) &&
            (identical(other.propertyName, propertyName) ||
                other.propertyName == propertyName) &&
            (identical(other.dataType, dataType) ||
                other.dataType == dataType) &&
            (identical(other.unitSymbol, unitSymbol) ||
                other.unitSymbol == unitSymbol) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, speciesId, propertyName,
      dataType, unitSymbol, createdAt);

  /// Create a copy of SpeciesMagnitude
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SpeciesMagnitudeImplCopyWith<_$SpeciesMagnitudeImpl> get copyWith =>
      __$$SpeciesMagnitudeImplCopyWithImpl<_$SpeciesMagnitudeImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SpeciesMagnitudeImplToJson(
      this,
    );
  }
}

abstract class _SpeciesMagnitude implements SpeciesMagnitude {
  const factory _SpeciesMagnitude(
      {required final String id,
      required final String speciesId,
      required final String propertyName,
      final String dataType,
      final String? unitSymbol,
      required final DateTime createdAt}) = _$SpeciesMagnitudeImpl;

  factory _SpeciesMagnitude.fromJson(Map<String, dynamic> json) =
      _$SpeciesMagnitudeImpl.fromJson;

  @override
  String get id;
  @override
  String get speciesId;
  @override
  String get propertyName; // e.g. "Masa", "Volumen", "Material"
  @override
  String get dataType; // 'real', 'integer', 'string', 'boolean'
  @override
  String? get unitSymbol; // null for non-numeric, or valid unit for numeric
  @override
  DateTime get createdAt;

  /// Create a copy of SpeciesMagnitude
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SpeciesMagnitudeImplCopyWith<_$SpeciesMagnitudeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
