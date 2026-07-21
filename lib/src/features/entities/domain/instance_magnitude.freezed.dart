// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'instance_magnitude.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

InstanceMagnitude _$InstanceMagnitudeFromJson(Map<String, dynamic> json) {
  return _InstanceMagnitude.fromJson(json);
}

/// @nodoc
mixin _$InstanceMagnitude {
  String get id => throw _privateConstructorUsedError;
  String get instanceId => throw _privateConstructorUsedError;
  String get propertyName => throw _privateConstructorUsedError;
  double get magnitudeValue => throw _privateConstructorUsedError;
  String get unitSymbol => throw _privateConstructorUsedError;

  /// Serializes this InstanceMagnitude to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InstanceMagnitude
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InstanceMagnitudeCopyWith<InstanceMagnitude> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InstanceMagnitudeCopyWith<$Res> {
  factory $InstanceMagnitudeCopyWith(
          InstanceMagnitude value, $Res Function(InstanceMagnitude) then) =
      _$InstanceMagnitudeCopyWithImpl<$Res, InstanceMagnitude>;
  @useResult
  $Res call(
      {String id,
      String instanceId,
      String propertyName,
      double magnitudeValue,
      String unitSymbol});
}

/// @nodoc
class _$InstanceMagnitudeCopyWithImpl<$Res, $Val extends InstanceMagnitude>
    implements $InstanceMagnitudeCopyWith<$Res> {
  _$InstanceMagnitudeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InstanceMagnitude
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? instanceId = null,
    Object? propertyName = null,
    Object? magnitudeValue = null,
    Object? unitSymbol = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      instanceId: null == instanceId
          ? _value.instanceId
          : instanceId // ignore: cast_nullable_to_non_nullable
              as String,
      propertyName: null == propertyName
          ? _value.propertyName
          : propertyName // ignore: cast_nullable_to_non_nullable
              as String,
      magnitudeValue: null == magnitudeValue
          ? _value.magnitudeValue
          : magnitudeValue // ignore: cast_nullable_to_non_nullable
              as double,
      unitSymbol: null == unitSymbol
          ? _value.unitSymbol
          : unitSymbol // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InstanceMagnitudeImplCopyWith<$Res>
    implements $InstanceMagnitudeCopyWith<$Res> {
  factory _$$InstanceMagnitudeImplCopyWith(_$InstanceMagnitudeImpl value,
          $Res Function(_$InstanceMagnitudeImpl) then) =
      __$$InstanceMagnitudeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String instanceId,
      String propertyName,
      double magnitudeValue,
      String unitSymbol});
}

/// @nodoc
class __$$InstanceMagnitudeImplCopyWithImpl<$Res>
    extends _$InstanceMagnitudeCopyWithImpl<$Res, _$InstanceMagnitudeImpl>
    implements _$$InstanceMagnitudeImplCopyWith<$Res> {
  __$$InstanceMagnitudeImplCopyWithImpl(_$InstanceMagnitudeImpl _value,
      $Res Function(_$InstanceMagnitudeImpl) _then)
      : super(_value, _then);

  /// Create a copy of InstanceMagnitude
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? instanceId = null,
    Object? propertyName = null,
    Object? magnitudeValue = null,
    Object? unitSymbol = null,
  }) {
    return _then(_$InstanceMagnitudeImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      instanceId: null == instanceId
          ? _value.instanceId
          : instanceId // ignore: cast_nullable_to_non_nullable
              as String,
      propertyName: null == propertyName
          ? _value.propertyName
          : propertyName // ignore: cast_nullable_to_non_nullable
              as String,
      magnitudeValue: null == magnitudeValue
          ? _value.magnitudeValue
          : magnitudeValue // ignore: cast_nullable_to_non_nullable
              as double,
      unitSymbol: null == unitSymbol
          ? _value.unitSymbol
          : unitSymbol // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$InstanceMagnitudeImpl implements _InstanceMagnitude {
  const _$InstanceMagnitudeImpl(
      {required this.id,
      required this.instanceId,
      required this.propertyName,
      required this.magnitudeValue,
      required this.unitSymbol});

  factory _$InstanceMagnitudeImpl.fromJson(Map<String, dynamic> json) =>
      _$$InstanceMagnitudeImplFromJson(json);

  @override
  final String id;
  @override
  final String instanceId;
  @override
  final String propertyName;
  @override
  final double magnitudeValue;
  @override
  final String unitSymbol;

  @override
  String toString() {
    return 'InstanceMagnitude(id: $id, instanceId: $instanceId, propertyName: $propertyName, magnitudeValue: $magnitudeValue, unitSymbol: $unitSymbol)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InstanceMagnitudeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.instanceId, instanceId) ||
                other.instanceId == instanceId) &&
            (identical(other.propertyName, propertyName) ||
                other.propertyName == propertyName) &&
            (identical(other.magnitudeValue, magnitudeValue) ||
                other.magnitudeValue == magnitudeValue) &&
            (identical(other.unitSymbol, unitSymbol) ||
                other.unitSymbol == unitSymbol));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, instanceId, propertyName, magnitudeValue, unitSymbol);

  /// Create a copy of InstanceMagnitude
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InstanceMagnitudeImplCopyWith<_$InstanceMagnitudeImpl> get copyWith =>
      __$$InstanceMagnitudeImplCopyWithImpl<_$InstanceMagnitudeImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InstanceMagnitudeImplToJson(
      this,
    );
  }
}

abstract class _InstanceMagnitude implements InstanceMagnitude {
  const factory _InstanceMagnitude(
      {required final String id,
      required final String instanceId,
      required final String propertyName,
      required final double magnitudeValue,
      required final String unitSymbol}) = _$InstanceMagnitudeImpl;

  factory _InstanceMagnitude.fromJson(Map<String, dynamic> json) =
      _$InstanceMagnitudeImpl.fromJson;

  @override
  String get id;
  @override
  String get instanceId;
  @override
  String get propertyName;
  @override
  double get magnitudeValue;
  @override
  String get unitSymbol;

  /// Create a copy of InstanceMagnitude
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InstanceMagnitudeImplCopyWith<_$InstanceMagnitudeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
