import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../../../core/database/app_database.dart';
import '../domain/catalog_item.dart';

class CatalogRepository {
  final AppDatabase _db;

  CatalogRepository(this._db);

  CatalogItem _mapToDomain(CatalogTableData row) {
    Map<String, dynamic> customAttrs = {};
    if (row.customAttributes.isNotEmpty) {
      try {
        customAttrs = Map<String, dynamic>.from(jsonDecode(row.customAttributes));
      } catch (_) {}
    }

    return CatalogItem(
      id: row.id,
      name: row.name,
      type: row.type,
      brand: row.brand,
      description: row.description,
      mainPhotoPath: row.mainPhotoPath,
      barcode: row.barcode,
      customAttributes: customAttrs,
      defaultUnit: row.defaultUnit,
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

  Future<List<CatalogItem>> searchCatalog(String queryStr) async {
    final clean = queryStr.toLowerCase().trim();
    if (clean.isEmpty) return getAllCatalogItems();

    final all = await getAllCatalogItems();
    return all.where((item) {
      final nameMatch = item.name.toLowerCase().contains(clean);
      final brandMatch = item.brand?.toLowerCase().contains(clean) ?? false;
      final typeMatch = item.type.toLowerCase().contains(clean);
      final barcodeMatch = item.barcode?.toLowerCase().contains(clean) ?? false;
      return nameMatch || brandMatch || typeMatch || barcodeMatch;
    }).toList();
  }

  Future<CatalogItem> getOrCreateSpecies(
    String name, {
    String type = 'Objeto / Herramienta',
    String? brand,
    String? description,
    String? mainPhotoPath,
    String? barcode,
  }) async {
    final cleanName = name.trim();
    final all = await getAllCatalogItems();
    final existing = all.where((e) => e.name.toLowerCase() == cleanName.toLowerCase()).firstOrNull;
    if (existing != null) return existing;

    final newItem = CatalogItem(
      id: const Uuid().v4(),
      name: cleanName,
      type: type,
      brand: brand,
      description: description,
      mainPhotoPath: mainPhotoPath,
      barcode: barcode,
      createdAt: DateTime.now(),
    );

    await saveCatalogItem(newItem);
    return newItem;
  }

  Future<void> saveCatalogItem(CatalogItem item) async {
    final companion = CatalogTableCompanion(
      id: Value(item.id),
      name: Value(item.name),
      type: Value(item.type),
      brand: Value(item.brand),
      description: Value(item.description),
      mainPhotoPath: Value(item.mainPhotoPath),
      barcode: Value(item.barcode),
      customAttributes: Value(jsonEncode(item.customAttributes)),
      defaultUnit: Value(item.defaultUnit),
      createdAt: Value(item.createdAt),
    );
    await _db.into(_db.catalogTable).insertOnConflictUpdate(companion);
  }

  Future<void> deleteCatalogItem(String id) async {
    await (_db.delete(_db.catalogTable)..where((t) => t.id.equals(id))).go();
  }
}
