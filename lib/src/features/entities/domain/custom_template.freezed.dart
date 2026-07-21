// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'custom_template.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CustomTemplate _$CustomTemplateFromJson(Map<String, dynamic> json) {
  return _CustomTemplate.fromJson(json);
}

/// @nodoc
mixin _$CustomTemplate {
  String get id => throw _privateConstructorUsedError;
  String get typeName => throw _privateConstructorUsedError;
  String get iconName => throw _privateConstructorUsedError;
  bool get isContainer => throw _privateConstructorUsedError;
  bool get isPlace => throw _privateConstructorUsedError;
  List<String> get commonUnits => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this CustomTemplate to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CustomTemplate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CustomTemplateCopyWith<CustomTemplate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomTemplateCopyWith<$Res> {
  factory $CustomTemplateCopyWith(
          CustomTemplate value, $Res Function(CustomTemplate) then) =
      _$CustomTemplateCopyWithImpl<$Res, CustomTemplate>;
  @useResult
  $Res call(
      {String id,
      String typeName,
      String iconName,
      bool isContainer,
      bool isPlace,
      List<String> commonUnits,
      DateTime createdAt});
}

/// @nodoc
class _$CustomTemplateCopyWithImpl<$Res, $Val extends CustomTemplate>
    implements $CustomTemplateCopyWith<$Res> {
  _$CustomTemplateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CustomTemplate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? typeName = null,
    Object? iconName = null,
    Object? isContainer = null,
    Object? isPlace = null,
    Object? commonUnits = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      typeName: null == typeName
          ? _value.typeName
          : typeName // ignore: cast_nullable_to_non_nullable
              as String,
      iconName: null == iconName
          ? _value.iconName
          : iconName // ignore: cast_nullable_to_non_nullable
              as String,
      isContainer: null == isContainer
          ? _value.isContainer
          : isContainer // ignore: cast_nullable_to_non_nullable
              as bool,
      isPlace: null == isPlace
          ? _value.isPlace
          : isPlace // ignore: cast_nullable_to_non_nullable
              as bool,
      commonUnits: null == commonUnits
          ? _value.commonUnits
          : commonUnits // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CustomTemplateImplCopyWith<$Res>
    implements $CustomTemplateCopyWith<$Res> {
  factory _$$CustomTemplateImplCopyWith(_$CustomTemplateImpl value,
          $Res Function(_$CustomTemplateImpl) then) =
      __$$CustomTemplateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String typeName,
      String iconName,
      bool isContainer,
      bool isPlace,
      List<String> commonUnits,
      DateTime createdAt});
}

/// @nodoc
class __$$CustomTemplateImplCopyWithImpl<$Res>
    extends _$CustomTemplateCopyWithImpl<$Res, _$CustomTemplateImpl>
    implements _$$CustomTemplateImplCopyWith<$Res> {
  __$$CustomTemplateImplCopyWithImpl(
      _$CustomTemplateImpl _value, $Res Function(_$CustomTemplateImpl) _then)
      : super(_value, _then);

  /// Create a copy of CustomTemplate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? typeName = null,
    Object? iconName = null,
    Object? isContainer = null,
    Object? isPlace = null,
    Object? commonUnits = null,
    Object? createdAt = null,
  }) {
    return _then(_$CustomTemplateImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      typeName: null == typeName
          ? _value.typeName
          : typeName // ignore: cast_nullable_to_non_nullable
              as String,
      iconName: null == iconName
          ? _value.iconName
          : iconName // ignore: cast_nullable_to_non_nullable
              as String,
      isContainer: null == isContainer
          ? _value.isContainer
          : isContainer // ignore: cast_nullable_to_non_nullable
              as bool,
      isPlace: null == isPlace
          ? _value.isPlace
          : isPlace // ignore: cast_nullable_to_non_nullable
              as bool,
      commonUnits: null == commonUnits
          ? _value._commonUnits
          : commonUnits // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CustomTemplateImpl implements _CustomTemplate {
  const _$CustomTemplateImpl(
      {required this.id,
      required this.typeName,
      required this.iconName,
      this.isContainer = false,
      this.isPlace = false,
      final List<String> commonUnits = const [],
      required this.createdAt})
      : _commonUnits = commonUnits;

  factory _$CustomTemplateImpl.fromJson(Map<String, dynamic> json) =>
      _$$CustomTemplateImplFromJson(json);

  @override
  final String id;
  @override
  final String typeName;
  @override
  final String iconName;
  @override
  @JsonKey()
  final bool isContainer;
  @override
  @JsonKey()
  final bool isPlace;
  final List<String> _commonUnits;
  @override
  @JsonKey()
  List<String> get commonUnits {
    if (_commonUnits is EqualUnmodifiableListView) return _commonUnits;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_commonUnits);
  }

  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'CustomTemplate(id: $id, typeName: $typeName, iconName: $iconName, isContainer: $isContainer, isPlace: $isPlace, commonUnits: $commonUnits, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomTemplateImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.typeName, typeName) ||
                other.typeName == typeName) &&
            (identical(other.iconName, iconName) ||
                other.iconName == iconName) &&
            (identical(other.isContainer, isContainer) ||
                other.isContainer == isContainer) &&
            (identical(other.isPlace, isPlace) || other.isPlace == isPlace) &&
            const DeepCollectionEquality()
                .equals(other._commonUnits, _commonUnits) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      typeName,
      iconName,
      isContainer,
      isPlace,
      const DeepCollectionEquality().hash(_commonUnits),
      createdAt);

  /// Create a copy of CustomTemplate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomTemplateImplCopyWith<_$CustomTemplateImpl> get copyWith =>
      __$$CustomTemplateImplCopyWithImpl<_$CustomTemplateImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CustomTemplateImplToJson(
      this,
    );
  }
}

abstract class _CustomTemplate implements CustomTemplate {
  const factory _CustomTemplate(
      {required final String id,
      required final String typeName,
      required final String iconName,
      final bool isContainer,
      final bool isPlace,
      final List<String> commonUnits,
      required final DateTime createdAt}) = _$CustomTemplateImpl;

  factory _CustomTemplate.fromJson(Map<String, dynamic> json) =
      _$CustomTemplateImpl.fromJson;

  @override
  String get id;
  @override
  String get typeName;
  @override
  String get iconName;
  @override
  bool get isContainer;
  @override
  bool get isPlace;
  @override
  List<String> get commonUnits;
  @override
  DateTime get createdAt;

  /// Create a copy of CustomTemplate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CustomTemplateImplCopyWith<_$CustomTemplateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
