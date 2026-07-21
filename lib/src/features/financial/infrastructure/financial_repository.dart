import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../../../core/database/app_database.dart';
import '../domain/financial_transaction.dart';

class FinancialRepository {
  final AppDatabase _db;

  FinancialRepository(this._db);

  FinancialTransaction _mapToDomain(FinancialTransactionsTableData row) {
    return FinancialTransaction(
      id: row.id,
      speciesId: row.speciesId,
      entityId: row.entityId,
      transactionType: row.transactionType,
      magnitudeDelta: row.magnitudeDelta,
      amount: row.totalAmount,
      currency: row.currency,
      isSale: row.isSale,
      notes: row.notes,
      timestamp: row.timestamp,
    );
  }

  Future<List<FinancialTransaction>> getAllTransactions() async {
    final query = _db.select(_db.financialTransactionsTable)
      ..orderBy([(t) => OrderingTerm.desc(t.timestamp)]);
    final rows = await query.get();
    return rows.map(_mapToDomain).toList();
  }

  Future<List<FinancialTransaction>> getTransactionsForSpecies(String speciesId) async {
    final query = _db.select(_db.financialTransactionsTable)
      ..where((t) => t.speciesId.equals(speciesId))
      ..orderBy([(t) => OrderingTerm.desc(t.timestamp)]);
    final rows = await query.get();
    return rows.map(_mapToDomain).toList();
  }

  Future<void> recordTransaction({
    required String speciesId,
    String? entityId,
    required String transactionType,
    required double magnitudeDelta,
    required double amount,
    String currency = 'MXN',
    bool isSale = false,
    String? notes,
  }) async {
    final companion = FinancialTransactionsTableCompanion(
      id: Value(const Uuid().v4()),
      speciesId: Value(speciesId),
      entityId: Value(entityId),
      transactionType: Value(transactionType),
      magnitudeDelta: Value(magnitudeDelta),
      totalAmount: Value(amount),
      currency: Value(currency),
      isSale: Value(isSale),
      notes: Value(notes),
      timestamp: Value(DateTime.now()),
    );

    await _db.into(_db.financialTransactionsTable).insert(companion);
  }
}
