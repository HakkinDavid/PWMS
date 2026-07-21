// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'financial_transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FinancialTransactionImpl _$$FinancialTransactionImplFromJson(
        Map<String, dynamic> json) =>
    _$FinancialTransactionImpl(
      id: json['id'] as String,
      speciesId: json['speciesId'] as String,
      entityId: json['entityId'] as String?,
      transactionType: json['transactionType'] as String,
      magnitudeDelta: (json['magnitudeDelta'] as num).toDouble(),
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'MXN',
      isSale: json['isSale'] as bool? ?? false,
      notes: json['notes'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$$FinancialTransactionImplToJson(
        _$FinancialTransactionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'speciesId': instance.speciesId,
      'entityId': instance.entityId,
      'transactionType': instance.transactionType,
      'magnitudeDelta': instance.magnitudeDelta,
      'amount': instance.amount,
      'currency': instance.currency,
      'isSale': instance.isSale,
      'notes': instance.notes,
      'timestamp': instance.timestamp.toIso8601String(),
    };
