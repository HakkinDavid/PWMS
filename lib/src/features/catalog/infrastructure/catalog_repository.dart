import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../../../core/database/app_database.dart';
import '../../../core/domain/domain_rules.dart';
import '../domain/catalog_item.dart';
import '../domain/species_magnitude.dart';

class CatalogRepository {
  final AppDatabase _db;

  CatalogRepository(this._db);

  Future<CatalogItem> _mapToDomain(CatalogTableData row) async {
    Map<String, dynamic> customAttrs = {};
    if (row.customAttributes.isNotEmpty) {
      try {
        customAttrs = Map<String, dynamic>.from(jsonDecode(row.customAttributes));
      } catch (_) {}
    }

    // Query 4NF Species Magnitudes (1:N)
    final magRows = await (_db.select(_db.speciesMagnitudesTable)..where((t) => t.speciesId.equals(row.id))).get();
    final magnitudes = magRows.map((m) => SpeciesMagnitude(
      id: m.id,
      speciesId: m.speciesId,
      propertyName: m.propertyName,
      magnitudeValue: m.magnitudeValue,
      unitSymbol: m.unitSymbol,
      createdAt: m.createdAt,
    )).toList();

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
      magnitudes: magnitudes,
      isUnique: row.isUnique,
      hasMonetaryValue: row.hasMonetaryValue,
      defaultMonetaryCurrency: row.defaultMonetaryCurrency,
      createdAt: row.createdAt,
    );
  }

  Future<List<CatalogItem>> getAllCatalogItems() async {
    final query = _db.select(_db.catalogTable)..orderBy([(t) => OrderingTerm.asc(t.name)]);
    final rows = await query.get();
    final List<CatalogItem> results = [];
    for (final row in rows) {
      results.add(await _mapToDomain(row));
    }
    return results;
  }

  Future<CatalogItem?> getCatalogItemById(String id) async {
    final query = _db.select(_db.catalogTable)..where((t) => t.id.equals(id));
    final row = await query.getSingleOrNull();
    return row != null ? await _mapToDomain(row) : null;
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
    String type = 'Objeto',
    String? brand,
    String? description,
    String? mainPhotoPath,
    String? barcode,
    String? defaultUnit,
    bool isUnique = false,
    bool hasMonetaryValue = true,
    String defaultMonetaryCurrency = 'MXN',
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
      defaultUnit: defaultUnit,
      isUnique: isUnique,
      hasMonetaryValue: hasMonetaryValue,
      defaultMonetaryCurrency: defaultMonetaryCurrency,
      createdAt: DateTime.now(),
    );

    await saveCatalogItem(newItem);
    return newItem;
  }

  Future<void> saveCatalogItem(CatalogItem item) async {
    // Single Source of Truth Rule Check: Unique species cannot have integer counting units ("pieza")
    if (item.defaultUnit != null && !DomainRules.isUnitAllowedForSpecies(unitSymbol: item.defaultUnit!, isUnique: item.isUnique)) {
      throw Exception('Una Especie Única no puede asociarse con la unidad "pieza" o unidades de conteo.');
    }

    final all = await getAllCatalogItems();
    final existing = await getCatalogItemById(item.id);

    // Rule: No duplicate name or main photo
    final nameDup = all.where((c) => c.id != item.id && c.name.toLowerCase() == item.name.trim().toLowerCase()).firstOrNull;
    if (nameDup != null) {
      throw Exception('Ya existe una especie con el nombre "${item.name}"');
    }

    if (item.mainPhotoPath != null && item.mainPhotoPath!.isNotEmpty) {
      final photoDup = all.where((c) => c.id != item.id && c.mainPhotoPath == item.mainPhotoPath).firstOrNull;
      if (photoDup != null) {
        throw Exception('Ya existe una especie con esta misma imagen principal');
      }
    }

    final finalName = existing != null ? existing.name : item.name.trim();
    final finalType = existing != null ? existing.type : item.type;

    final companion = CatalogTableCompanion(
      id: Value(item.id),
      name: Value(finalName),
      type: Value(finalType),
      brand: Value(item.brand),
      description: Value(item.description),
      mainPhotoPath: Value(item.mainPhotoPath),
      barcode: Value(item.barcode),
      customAttributes: Value(jsonEncode(item.customAttributes)),
      defaultUnit: Value(item.defaultUnit),
      isUnique: Value(item.isUnique),
      hasMonetaryValue: Value(item.hasMonetaryValue),
      defaultMonetaryCurrency: Value(item.defaultMonetaryCurrency),
      createdAt: Value(item.createdAt),
    );
    await _db.into(_db.catalogTable).insertOnConflictUpdate(companion);

    // Persist 4NF Species Magnitudes (1:N)
    await (_db.delete(_db.speciesMagnitudesTable)..where((t) => t.speciesId.equals(item.id))).go();
    for (final mag in item.magnitudes) {
      await _db.into(_db.speciesMagnitudesTable).insert(SpeciesMagnitudesTableCompanion(
        id: Value(mag.id.isEmpty ? const Uuid().v4() : mag.id),
        speciesId: Value(item.id),
        propertyName: Value(mag.propertyName),
        magnitudeValue: Value(mag.magnitudeValue),
        unitSymbol: Value(mag.unitSymbol),
        createdAt: Value(mag.createdAt),
      ));
    }
  }

  Future<void> deleteCatalogItem(String id) async {
    await (_db.delete(_db.speciesMagnitudesTable)..where((t) => t.speciesId.equals(id))).go();
    await (_db.delete(_db.catalogTable)..where((t) => t.id.equals(id))).go();
  }
}
