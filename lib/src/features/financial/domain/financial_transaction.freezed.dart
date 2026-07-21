// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'financial_transaction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FinancialTransaction _$FinancialTransactionFromJson(Map<String, dynamic> json) {
  return _FinancialTransaction.fromJson(json);
}

/// @nodoc
mixin _$FinancialTransaction {
  String get id => throw _privateConstructorUsedError;
  String get speciesId => throw _privateConstructorUsedError;
  String? get entityId => throw _privateConstructorUsedError;
  String get transactionType =>
      throw _privateConstructorUsedError; // 'increment', 'instantiation', 'sale', 'decrement'
  double get magnitudeDelta => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError; // 'MXN' or 'USD'
  bool get isSale => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;

  /// Serializes this FinancialTransaction to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FinancialTransaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FinancialTransactionCopyWith<FinancialTransaction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FinancialTransactionCopyWith<$Res> {
  factory $FinancialTransactionCopyWith(FinancialTransaction value,
          $Res Function(FinancialTransaction) then) =
      _$FinancialTransactionCopyWithImpl<$Res, FinancialTransaction>;
  @useResult
  $Res call(
      {String id,
      String speciesId,
      String? entityId,
      String transactionType,
      double magnitudeDelta,
      double amount,
      String currency,
      bool isSale,
      String? notes,
      DateTime timestamp});
}

/// @nodoc
class _$FinancialTransactionCopyWithImpl<$Res,
        $Val extends FinancialTransaction>
    implements $FinancialTransactionCopyWith<$Res> {
  _$FinancialTransactionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FinancialTransaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? speciesId = null,
    Object? entityId = freezed,
    Object? transactionType = null,
    Object? magnitudeDelta = null,
    Object? amount = null,
    Object? currency = null,
    Object? isSale = null,
    Object? notes = freezed,
    Object? timestamp = null,
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
      entityId: freezed == entityId
          ? _value.entityId
          : entityId // ignore: cast_nullable_to_non_nullable
              as String?,
      transactionType: null == transactionType
          ? _value.transactionType
          : transactionType // ignore: cast_nullable_to_non_nullable
              as String,
      magnitudeDelta: null == magnitudeDelta
          ? _value.magnitudeDelta
          : magnitudeDelta // ignore: cast_nullable_to_non_nullable
              as double,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      isSale: null == isSale
          ? _value.isSale
          : isSale // ignore: cast_nullable_to_non_nullable
              as bool,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FinancialTransactionImplCopyWith<$Res>
    implements $FinancialTransactionCopyWith<$Res> {
  factory _$$FinancialTransactionImplCopyWith(_$FinancialTransactionImpl value,
          $Res Function(_$FinancialTransactionImpl) then) =
      __$$FinancialTransactionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String speciesId,
      String? entityId,
      String transactionType,
      double magnitudeDelta,
      double amount,
      String currency,
      bool isSale,
      String? notes,
      DateTime timestamp});
}

/// @nodoc
class __$$FinancialTransactionImplCopyWithImpl<$Res>
    extends _$FinancialTransactionCopyWithImpl<$Res, _$FinancialTransactionImpl>
    implements _$$FinancialTransactionImplCopyWith<$Res> {
  __$$FinancialTransactionImplCopyWithImpl(_$FinancialTransactionImpl _value,
      $Res Function(_$FinancialTransactionImpl) _then)
      : super(_value, _then);

  /// Create a copy of FinancialTransaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? speciesId = null,
    Object? entityId = freezed,
    Object? transactionType = null,
    Object? magnitudeDelta = null,
    Object? amount = null,
    Object? currency = null,
    Object? isSale = null,
    Object? notes = freezed,
    Object? timestamp = null,
  }) {
    return _then(_$FinancialTransactionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      speciesId: null == speciesId
          ? _value.speciesId
          : speciesId // ignore: cast_nullable_to_non_nullable
              as String,
      entityId: freezed == entityId
          ? _value.entityId
          : entityId // ignore: cast_nullable_to_non_nullable
              as String?,
      transactionType: null == transactionType
          ? _value.transactionType
          : transactionType // ignore: cast_nullable_to_non_nullable
              as String,
      magnitudeDelta: null == magnitudeDelta
          ? _value.magnitudeDelta
          : magnitudeDelta // ignore: cast_nullable_to_non_nullable
              as double,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      isSale: null == isSale
          ? _value.isSale
          : isSale // ignore: cast_nullable_to_non_nullable
              as bool,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FinancialTransactionImpl implements _FinancialTransaction {
  const _$FinancialTransactionImpl(
      {required this.id,
      required this.speciesId,
      this.entityId,
      required this.transactionType,
      required this.magnitudeDelta,
      required this.amount,
      this.currency = 'MXN',
      this.isSale = false,
      this.notes,
      required this.timestamp});

  factory _$FinancialTransactionImpl.fromJson(Map<String, dynamic> json) =>
      _$$FinancialTransactionImplFromJson(json);

  @override
  final String id;
  @override
  final String speciesId;
  @override
  final String? entityId;
  @override
  final String transactionType;
// 'increment', 'instantiation', 'sale', 'decrement'
  @override
  final double magnitudeDelta;
  @override
  final double amount;
  @override
  @JsonKey()
  final String currency;
// 'MXN' or 'USD'
  @override
  @JsonKey()
  final bool isSale;
  @override
  final String? notes;
  @override
  final DateTime timestamp;

  @override
  String toString() {
    return 'FinancialTransaction(id: $id, speciesId: $speciesId, entityId: $entityId, transactionType: $transactionType, magnitudeDelta: $magnitudeDelta, amount: $amount, currency: $currency, isSale: $isSale, notes: $notes, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FinancialTransactionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.speciesId, speciesId) ||
                other.speciesId == speciesId) &&
            (identical(other.entityId, entityId) ||
                other.entityId == entityId) &&
            (identical(other.transactionType, transactionType) ||
                other.transactionType == transactionType) &&
            (identical(other.magnitudeDelta, magnitudeDelta) ||
                other.magnitudeDelta == magnitudeDelta) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.isSale, isSale) || other.isSale == isSale) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      speciesId,
      entityId,
      transactionType,
      magnitudeDelta,
      amount,
      currency,
      isSale,
      notes,
      timestamp);

  /// Create a copy of FinancialTransaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FinancialTransactionImplCopyWith<_$FinancialTransactionImpl>
      get copyWith =>
          __$$FinancialTransactionImplCopyWithImpl<_$FinancialTransactionImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FinancialTransactionImplToJson(
      this,
    );
  }
}

abstract class _FinancialTransaction implements FinancialTransaction {
  const factory _FinancialTransaction(
      {required final String id,
      required final String speciesId,
      final String? entityId,
      required final String transactionType,
      required final double magnitudeDelta,
      required final double amount,
      final String currency,
      final bool isSale,
      final String? notes,
      required final DateTime timestamp}) = _$FinancialTransactionImpl;

  factory _FinancialTransaction.fromJson(Map<String, dynamic> json) =
      _$FinancialTransactionImpl.fromJson;

  @override
  String get id;
  @override
  String get speciesId;
  @override
  String? get entityId;
  @override
  String
      get transactionType; // 'increment', 'instantiation', 'sale', 'decrement'
  @override
  double get magnitudeDelta;
  @override
  double get amount;
  @override
  String get currency; // 'MXN' or 'USD'
  @override
  bool get isSale;
  @override
  String? get notes;
  @override
  DateTime get timestamp;

  /// Create a copy of FinancialTransaction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FinancialTransactionImplCopyWith<_$FinancialTransactionImpl>
      get copyWith => throw _privateConstructorUsedError;
}
