// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'location_node.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LocationNode _$LocationNodeFromJson(Map<String, dynamic> json) {
  return _LocationNode.fromJson(json);
}

/// @nodoc
mixin _$LocationNode {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get parentLocationId => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get icon => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this LocationNode to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LocationNode
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LocationNodeCopyWith<LocationNode> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LocationNodeCopyWith<$Res> {
  factory $LocationNodeCopyWith(
          LocationNode value, $Res Function(LocationNode) then) =
      _$LocationNodeCopyWithImpl<$Res, LocationNode>;
  @useResult
  $Res call(
      {String id,
      String name,
      String? parentLocationId,
      String? description,
      String? icon,
      DateTime createdAt});
}

/// @nodoc
class _$LocationNodeCopyWithImpl<$Res, $Val extends LocationNode>
    implements $LocationNodeCopyWith<$Res> {
  _$LocationNodeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LocationNode
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? parentLocationId = freezed,
    Object? description = freezed,
    Object? icon = freezed,
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
      parentLocationId: freezed == parentLocationId
          ? _value.parentLocationId
          : parentLocationId // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LocationNodeImplCopyWith<$Res>
    implements $LocationNodeCopyWith<$Res> {
  factory _$$LocationNodeImplCopyWith(
          _$LocationNodeImpl value, $Res Function(_$LocationNodeImpl) then) =
      __$$LocationNodeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String? parentLocationId,
      String? description,
      String? icon,
      DateTime createdAt});
}

/// @nodoc
class __$$LocationNodeImplCopyWithImpl<$Res>
    extends _$LocationNodeCopyWithImpl<$Res, _$LocationNodeImpl>
    implements _$$LocationNodeImplCopyWith<$Res> {
  __$$LocationNodeImplCopyWithImpl(
      _$LocationNodeImpl _value, $Res Function(_$LocationNodeImpl) _then)
      : super(_value, _then);

  /// Create a copy of LocationNode
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? parentLocationId = freezed,
    Object? description = freezed,
    Object? icon = freezed,
    Object? createdAt = null,
  }) {
    return _then(_$LocationNodeImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      parentLocationId: freezed == parentLocationId
          ? _value.parentLocationId
          : parentLocationId // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
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
class _$LocationNodeImpl implements _LocationNode {
  const _$LocationNodeImpl(
      {required this.id,
      required this.name,
      this.parentLocationId,
      this.description,
      this.icon,
      required this.createdAt});

  factory _$LocationNodeImpl.fromJson(Map<String, dynamic> json) =>
      _$$LocationNodeImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? parentLocationId;
  @override
  final String? description;
  @override
  final String? icon;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'LocationNode(id: $id, name: $name, parentLocationId: $parentLocationId, description: $description, icon: $icon, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LocationNodeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.parentLocationId, parentLocationId) ||
                other.parentLocationId == parentLocationId) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, name, parentLocationId, description, icon, createdAt);

  /// Create a copy of LocationNode
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LocationNodeImplCopyWith<_$LocationNodeImpl> get copyWith =>
      __$$LocationNodeImplCopyWithImpl<_$LocationNodeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LocationNodeImplToJson(
      this,
    );
  }
}

abstract class _LocationNode implements LocationNode {
  const factory _LocationNode(
      {required final String id,
      required final String name,
      final String? parentLocationId,
      final String? description,
      final String? icon,
      required final DateTime createdAt}) = _$LocationNodeImpl;

  factory _LocationNode.fromJson(Map<String, dynamic> json) =
      _$LocationNodeImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get parentLocationId;
  @override
  String? get description;
  @override
  String? get icon;
  @override
  DateTime get createdAt;

  /// Create a copy of LocationNode
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LocationNodeImplCopyWith<_$LocationNodeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
