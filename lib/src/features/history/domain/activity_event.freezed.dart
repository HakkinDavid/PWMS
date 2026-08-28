// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ActivityEvent _$ActivityEventFromJson(Map<String, dynamic> json) {
  return _ActivityEvent.fromJson(json);
}

/// @nodoc
mixin _$ActivityEvent {
  String get id => throw _privateConstructorUsedError;
  String? get entityId => throw _privateConstructorUsedError;
  String get eventType => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;

  /// Serializes this ActivityEvent to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ActivityEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ActivityEventCopyWith<ActivityEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivityEventCopyWith<$Res> {
  factory $ActivityEventCopyWith(
          ActivityEvent value, $Res Function(ActivityEvent) then) =
      _$ActivityEventCopyWithImpl<$Res, ActivityEvent>;
  @useResult
  $Res call(
      {String id,
      String? entityId,
      String eventType,
      String description,
      Map<String, dynamic>? metadata,
      DateTime timestamp});
}

/// @nodoc
class _$ActivityEventCopyWithImpl<$Res, $Val extends ActivityEvent>
    implements $ActivityEventCopyWith<$Res> {
  _$ActivityEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ActivityEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? entityId = freezed,
    Object? eventType = null,
    Object? description = null,
    Object? metadata = freezed,
    Object? timestamp = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      entityId: freezed == entityId
          ? _value.entityId
          : entityId // ignore: cast_nullable_to_non_nullable
              as String?,
      eventType: null == eventType
          ? _value.eventType
          : eventType // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ActivityEventImplCopyWith<$Res>
    implements $ActivityEventCopyWith<$Res> {
  factory _$$ActivityEventImplCopyWith(
          _$ActivityEventImpl value, $Res Function(_$ActivityEventImpl) then) =
      __$$ActivityEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String? entityId,
      String eventType,
      String description,
      Map<String, dynamic>? metadata,
      DateTime timestamp});
}

/// @nodoc
class __$$ActivityEventImplCopyWithImpl<$Res>
    extends _$ActivityEventCopyWithImpl<$Res, _$ActivityEventImpl>
    implements _$$ActivityEventImplCopyWith<$Res> {
  __$$ActivityEventImplCopyWithImpl(
      _$ActivityEventImpl _value, $Res Function(_$ActivityEventImpl) _then)
      : super(_value, _then);

  /// Create a copy of ActivityEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? entityId = freezed,
    Object? eventType = null,
    Object? description = null,
    Object? metadata = freezed,
    Object? timestamp = null,
  }) {
    return _then(_$ActivityEventImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      entityId: freezed == entityId
          ? _value.entityId
          : entityId // ignore: cast_nullable_to_non_nullable
              as String?,
      eventType: null == eventType
          ? _value.eventType
          : eventType // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ActivityEventImpl extends _ActivityEvent {
  const _$ActivityEventImpl(
      {required this.id,
      this.entityId,
      required this.eventType,
      required this.description,
      final Map<String, dynamic>? metadata,
      required this.timestamp})
      : _metadata = metadata,
        super._();

  factory _$ActivityEventImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActivityEventImplFromJson(json);

  @override
  final String id;
  @override
  final String? entityId;
  @override
  final String eventType;
  @override
  final String description;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final DateTime timestamp;

  @override
  String toString() {
    return 'ActivityEvent(id: $id, entityId: $entityId, eventType: $eventType, description: $description, metadata: $metadata, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivityEventImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.entityId, entityId) ||
                other.entityId == entityId) &&
            (identical(other.eventType, eventType) ||
                other.eventType == eventType) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, entityId, eventType,
      description, const DeepCollectionEquality().hash(_metadata), timestamp);

  /// Create a copy of ActivityEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActivityEventImplCopyWith<_$ActivityEventImpl> get copyWith =>
      __$$ActivityEventImplCopyWithImpl<_$ActivityEventImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ActivityEventImplToJson(
      this,
    );
  }
}

abstract class _ActivityEvent extends ActivityEvent {
  const factory _ActivityEvent(
      {required final String id,
      final String? entityId,
      required final String eventType,
      required final String description,
      final Map<String, dynamic>? metadata,
      required final DateTime timestamp}) = _$ActivityEventImpl;
  const _ActivityEvent._() : super._();

  factory _ActivityEvent.fromJson(Map<String, dynamic> json) =
      _$ActivityEventImpl.fromJson;

  @override
  String get id;
  @override
  String? get entityId;
  @override
  String get eventType;
  @override
  String get description;
  @override
  Map<String, dynamic>? get metadata;
  @override
  DateTime get timestamp;

  /// Create a copy of ActivityEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActivityEventImplCopyWith<_$ActivityEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
