// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'entity_relation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

EntityRelation _$EntityRelationFromJson(Map<String, dynamic> json) {
  return _EntityRelation.fromJson(json);
}

/// @nodoc
mixin _$EntityRelation {
  String get id => throw _privateConstructorUsedError;
  String get sourceEntityId => throw _privateConstructorUsedError;
  String get targetEntityId => throw _privateConstructorUsedError;
  String get relationType => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this EntityRelation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EntityRelation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EntityRelationCopyWith<EntityRelation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EntityRelationCopyWith<$Res> {
  factory $EntityRelationCopyWith(
          EntityRelation value, $Res Function(EntityRelation) then) =
      _$EntityRelationCopyWithImpl<$Res, EntityRelation>;
  @useResult
  $Res call(
      {String id,
      String sourceEntityId,
      String targetEntityId,
      String relationType,
      DateTime createdAt});
}

/// @nodoc
class _$EntityRelationCopyWithImpl<$Res, $Val extends EntityRelation>
    implements $EntityRelationCopyWith<$Res> {
  _$EntityRelationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EntityRelation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sourceEntityId = null,
    Object? targetEntityId = null,
    Object? relationType = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      sourceEntityId: null == sourceEntityId
          ? _value.sourceEntityId
          : sourceEntityId // ignore: cast_nullable_to_non_nullable
              as String,
      targetEntityId: null == targetEntityId
          ? _value.targetEntityId
          : targetEntityId // ignore: cast_nullable_to_non_nullable
              as String,
      relationType: null == relationType
          ? _value.relationType
          : relationType // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EntityRelationImplCopyWith<$Res>
    implements $EntityRelationCopyWith<$Res> {
  factory _$$EntityRelationImplCopyWith(_$EntityRelationImpl value,
          $Res Function(_$EntityRelationImpl) then) =
      __$$EntityRelationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String sourceEntityId,
      String targetEntityId,
      String relationType,
      DateTime createdAt});
}

/// @nodoc
class __$$EntityRelationImplCopyWithImpl<$Res>
    extends _$EntityRelationCopyWithImpl<$Res, _$EntityRelationImpl>
    implements _$$EntityRelationImplCopyWith<$Res> {
  __$$EntityRelationImplCopyWithImpl(
      _$EntityRelationImpl _value, $Res Function(_$EntityRelationImpl) _then)
      : super(_value, _then);

  /// Create a copy of EntityRelation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sourceEntityId = null,
    Object? targetEntityId = null,
    Object? relationType = null,
    Object? createdAt = null,
  }) {
    return _then(_$EntityRelationImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      sourceEntityId: null == sourceEntityId
          ? _value.sourceEntityId
          : sourceEntityId // ignore: cast_nullable_to_non_nullable
              as String,
      targetEntityId: null == targetEntityId
          ? _value.targetEntityId
          : targetEntityId // ignore: cast_nullable_to_non_nullable
              as String,
      relationType: null == relationType
          ? _value.relationType
          : relationType // ignore: cast_nullable_to_non_nullable
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
class _$EntityRelationImpl implements _EntityRelation {
  const _$EntityRelationImpl(
      {required this.id,
      required this.sourceEntityId,
      required this.targetEntityId,
      required this.relationType,
      required this.createdAt});

  factory _$EntityRelationImpl.fromJson(Map<String, dynamic> json) =>
      _$$EntityRelationImplFromJson(json);

  @override
  final String id;
  @override
  final String sourceEntityId;
  @override
  final String targetEntityId;
  @override
  final String relationType;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'EntityRelation(id: $id, sourceEntityId: $sourceEntityId, targetEntityId: $targetEntityId, relationType: $relationType, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EntityRelationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sourceEntityId, sourceEntityId) ||
                other.sourceEntityId == sourceEntityId) &&
            (identical(other.targetEntityId, targetEntityId) ||
                other.targetEntityId == targetEntityId) &&
            (identical(other.relationType, relationType) ||
                other.relationType == relationType) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, sourceEntityId, targetEntityId, relationType, createdAt);

  /// Create a copy of EntityRelation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EntityRelationImplCopyWith<_$EntityRelationImpl> get copyWith =>
      __$$EntityRelationImplCopyWithImpl<_$EntityRelationImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EntityRelationImplToJson(
      this,
    );
  }
}

abstract class _EntityRelation implements EntityRelation {
  const factory _EntityRelation(
      {required final String id,
      required final String sourceEntityId,
      required final String targetEntityId,
      required final String relationType,
      required final DateTime createdAt}) = _$EntityRelationImpl;

  factory _EntityRelation.fromJson(Map<String, dynamic> json) =
      _$EntityRelationImpl.fromJson;

  @override
  String get id;
  @override
  String get sourceEntityId;
  @override
  String get targetEntityId;
  @override
  String get relationType;
  @override
  DateTime get createdAt;

  /// Create a copy of EntityRelation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EntityRelationImplCopyWith<_$EntityRelationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
