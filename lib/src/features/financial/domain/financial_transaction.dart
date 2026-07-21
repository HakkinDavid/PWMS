import 'package:freezed_annotation/freezed_annotation.dart';

part 'financial_transaction.freezed.dart';
part 'financial_transaction.g.dart';

@freezed
class FinancialTransaction with _$FinancialTransaction {
  const factory FinancialTransaction({
    required String id,
    required String speciesId,
    String? entityId,
    required String transactionType, // 'increment', 'instantiation', 'sale', 'decrement'
    required double magnitudeDelta,
    required double amount,
    @Default('MXN') String currency, // 'MXN' or 'USD'
    @Default(false) bool isSale,
    String? notes,
    required DateTime timestamp,
  }) = _FinancialTransaction;

  factory FinancialTransaction.fromJson(Map<String, dynamic> json) => _$FinancialTransactionFromJson(json);
}
