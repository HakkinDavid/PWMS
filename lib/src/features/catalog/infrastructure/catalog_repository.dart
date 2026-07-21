import 'package:drift/drift.dart';
import '../../../core/database/app_database.dart';
import '../domain/catalog_item.dart';

class CatalogRepository {
  final AppDatabase _db;

  CatalogRepository(this._db);

  CatalogItem _mapToDomain(CatalogTableData row) {
    return CatalogItem(
      id: row.id,
      name: row.name,
      brand: row.brand,
      description: row.description,
      mainPhotoPath: row.mainPhotoPath,
      defaultType: row.defaultType,
      barcode: row.barcode,
      createdAt: row.createdAt,
    );
  }

  Future<List<CatalogItem>> getAllCatalogItems() async {
    final query = _db.select(_db.catalogTable)..orderBy([(t) => OrderingTerm.asc(t.name)]);
    final rows = await query.get();
    return rows.map(_mapToDomain).toList();
  }

  Future<CatalogItem?> getCatalogItemById(String id) async {
    final query = _db.select(_db.catalogTable)..where((t) => t.id.equals(id));
    final row = await query.getSingleOrNull();
    return row != null ? _mapToDomain(row) : null;
  }

  Future<void> saveCatalogItem(CatalogItem item) async {
    final companion = CatalogTableCompanion(
      id: Value(item.id),
      name: Value(item.name),
      brand: Value(item.brand),
      description: Value(item.description),
      mainPhotoPath: Value(item.mainPhotoPath),
      defaultType: Value(item.defaultType),
      barcode: Value(item.barcode),
      createdAt: Value(item.createdAt),
    );
    await _db.into(_db.catalogTable).insertOnConflictUpdate(companion);
  }

  Future<void> deleteCatalogItem(String id) async {
    await (_db.delete(_db.catalogTable)..where((t) => t.id.equals(id))).go();
  }
}
