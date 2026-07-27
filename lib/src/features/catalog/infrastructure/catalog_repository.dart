import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/database/app_database.dart';
import '../domain/catalog_item.dart';
import '../domain/species_magnitude.dart';
import '../domain/species_requirement.dart';
import '../domain/subspecies.dart';

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
      unitSymbol: m.unitSymbol,
      createdAt: m.createdAt,
    )).toList();

    return CatalogItem(
      id: row.id,
      name: row.name,
      type: row.type,
      description: row.description,
      mainPhotoPath: row.mainPhotoPath,
      customAttributes: customAttrs,
      magnitudes: magnitudes,
      isUnique: row.isUnique,
      isNonPerishable: row.isNonPerishable,
      defaultShelfLifeDays: row.defaultShelfLifeDays,
      warningDaysBeforeExpiration: row.warningDaysBeforeExpiration,
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
      final typeMatch = item.type.toLowerCase().contains(clean);
      return nameMatch || typeMatch;
    }).toList();
  }

  Future<CatalogItem> getOrCreateSpecies(
    String name, {
    String type = AppStrings.typeObject,
    String? description,
    String? mainPhotoPath,
    bool isUnique = false,
  }) async {
    final cleanName = name.trim();
    final all = await getAllCatalogItems();
    final existing = all.where((e) => e.name.toLowerCase() == cleanName.toLowerCase()).firstOrNull;
    if (existing != null) return existing;

    final newItem = CatalogItem(
      id: const Uuid().v4(),
      name: cleanName,
      type: type,
      description: description,
      mainPhotoPath: mainPhotoPath,
      isUnique: isUnique,
      createdAt: DateTime.now(),
    );

    await saveCatalogItem(newItem);
    return newItem;
  }

  Future<void> saveCatalogItem(CatalogItem item) async {
    final all = await getAllCatalogItems();
    final existing = await getCatalogItemById(item.id);

    // Rule: No duplicate name or main photo
    final nameDup = all.where((c) => c.id != item.id && c.name.toLowerCase() == item.name.trim().toLowerCase()).firstOrNull;
    if (nameDup != null) {
      throw Exception(AppStrings.duplicateSpeciesNameError);
    }

    if (item.mainPhotoPath != null && item.mainPhotoPath!.isNotEmpty) {
      final photoDup = all.where((c) => c.id != item.id && c.mainPhotoPath == item.mainPhotoPath).firstOrNull;
      if (photoDup != null) {
        throw Exception(AppStrings.duplicatePhotoError);
      }
    }

    final finalName = item.name.trim();
    final finalType = existing != null ? existing.type : item.type;

    final companion = CatalogTableCompanion(
      id: Value(item.id),
      name: Value(finalName),
      type: Value(finalType),
      description: Value(item.description),
      mainPhotoPath: Value(item.mainPhotoPath),
      customAttributes: Value(jsonEncode(item.customAttributes)),
      isUnique: Value(item.isUnique),
      isNonPerishable: Value(finalType == 'Objeto' ? item.isNonPerishable : true),
      defaultShelfLifeDays: Value(finalType == 'Objeto' && !item.isNonPerishable ? item.defaultShelfLifeDays : null),
      warningDaysBeforeExpiration: Value(finalType == 'Objeto' && !item.isNonPerishable ? item.warningDaysBeforeExpiration : null),
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
        unitSymbol: Value(mag.unitSymbol),
        createdAt: Value(mag.createdAt),
      ));
    }

    // Rule #1: Ensure default generic subspecies exists ONLY if no subspecies exist
    await ensureDefaultSubspecies(item.id);
  }

  Future<void> ensureDefaultSubspecies(String speciesId) async {
    final query = _db.select(_db.subspeciesTable)..where((t) => t.speciesId.equals(speciesId));
    final rows = await query.get();
    if (rows.isEmpty) {
      await saveSubspecies(Subspecies(
        id: const Uuid().v4(),
        speciesId: speciesId,
        subspeciesName: 'Genérica',
        brand: null,
        barcode: null,
        photoPath: null,
        notes: null,
        createdAt: DateTime.now(),
      ));
    }
  }

  Future<void> deleteCatalogItem(String id) async {
    final entityRows = await (_db.select(_db.entitiesTable)..where((t) => t.speciesId.equals(id))).get();
    if (entityRows.isNotEmpty) {
      throw Exception('No se puede eliminar una especie que tiene instancias registradas en tu mundo.');
    }

    await (_db.delete(_db.subspeciesTable)..where((t) => t.speciesId.equals(id))).go();
    await (_db.delete(_db.speciesRequirementsTable)..where((t) => t.sourceId.equals(id) | t.requiredSpeciesId.equals(id))).go();
    await (_db.delete(_db.speciesMagnitudesTable)..where((t) => t.speciesId.equals(id))).go();
    await (_db.delete(_db.catalogTable)..where((t) => t.id.equals(id))).go();
  }

  // --- SUBSPECIES CRUD ---

  Future<List<Subspecies>> getAllSubspecies() async {
    final query = _db.select(_db.subspeciesTable);
    final rows = await query.get();
    return rows.map((r) => Subspecies(
      id: r.id,
      speciesId: r.speciesId,
      subspeciesName: r.subspeciesName,
      brand: r.brand,
      barcode: r.barcode,
      photoPath: r.photoPath,
      notes: r.notes,
      createdAt: r.createdAt,
    )).toList();
  }

  Future<List<Subspecies>> getSubspeciesForSpecies(String speciesId) async {
    final query = _db.select(_db.subspeciesTable)..where((t) => t.speciesId.equals(speciesId));
    final rows = await query.get();
    return rows.map((r) => Subspecies(
      id: r.id,
      speciesId: r.speciesId,
      subspeciesName: r.subspeciesName,
      brand: r.brand,
      barcode: r.barcode,
      photoPath: r.photoPath,
      notes: r.notes,
      createdAt: r.createdAt,
    )).toList();
  }

  Future<Subspecies?> getSubspeciesById(String id) async {
    final query = _db.select(_db.subspeciesTable)..where((t) => t.id.equals(id));
    final r = await query.getSingleOrNull();
    if (r == null) return null;
    return Subspecies(
      id: r.id,
      speciesId: r.speciesId,
      subspeciesName: r.subspeciesName,
      brand: r.brand,
      barcode: r.barcode,
      photoPath: r.photoPath,
      notes: r.notes,
      createdAt: r.createdAt,
    );
  }

  Future<void> saveSubspecies(Subspecies subspecies) async {
    // Structural constraint: Brand & Barcode ONLY exist for "Objeto"
    String? finalBrand = subspecies.brand?.trim();
    String? finalBarcode = subspecies.barcode?.trim();

    if (subspecies.speciesId.isNotEmpty) {
      final species = await getCatalogItemById(subspecies.speciesId);
      if (species != null && species.type != AppStrings.typeObject) {
        finalBrand = null;
        finalBarcode = null;
      }
    }

    final companion = SubspeciesTableCompanion(
      id: Value(subspecies.id),
      speciesId: Value(subspecies.speciesId),
      subspeciesName: Value(subspecies.subspeciesName.trim()),
      brand: Value(finalBrand),
      barcode: Value(finalBarcode),
      photoPath: Value(subspecies.photoPath),
      notes: Value(subspecies.notes?.trim()),
      createdAt: Value(subspecies.createdAt),
    );
    await _db.into(_db.subspeciesTable).insertOnConflictUpdate(companion);
  }

  Future<void> deleteSubspecies(String id) async {
    final sub = await getSubspeciesById(id);
    if (sub != null) {
      final existingForSpecies = await getSubspeciesForSpecies(sub.speciesId);
      if (existingForSpecies.length <= 1) {
        throw Exception(AppStrings.cannotDeleteOnlySubspecies);
      }
    }

    final entityRows = await (_db.select(_db.entitiesTable)..where((t) => t.subspeciesId.equals(id))).get();
    if (entityRows.isNotEmpty) {
      throw Exception('No se puede eliminar una subespecie que tiene instancias registradas en tu mundo.');
    }

    await (_db.delete(_db.subspeciesTable)..where((t) => t.id.equals(id))).go();
  }

  // --- SPECIES & ENTITY REQUIREMENTS CRUD (NECESITA) ---

  Future<List<SpeciesRequirement>> getRequirementsForSource(String sourceId) async {
    final query = _db.select(_db.speciesRequirementsTable)..where((t) => t.sourceId.equals(sourceId));
    final rows = await query.get();
    return rows.map((r) => SpeciesRequirement(
      id: r.id,
      sourceId: r.sourceId,
      sourceType: r.sourceType,
      requiredSpeciesId: r.requiredSpeciesId,
      requiredQuantity: r.requiredQuantity,
      notes: r.notes,
      createdAt: r.createdAt,
    )).toList();
  }

  Future<void> saveRequirement(SpeciesRequirement req) async {
    final companion = SpeciesRequirementsTableCompanion(
      id: Value(req.id.isEmpty ? const Uuid().v4() : req.id),
      sourceId: Value(req.sourceId),
      sourceType: Value(req.sourceType),
      requiredSpeciesId: Value(req.requiredSpeciesId),
      requiredQuantity: Value(req.requiredQuantity),
      notes: Value(req.notes),
      createdAt: Value(req.createdAt),
    );
    await _db.into(_db.speciesRequirementsTable).insertOnConflictUpdate(companion);
  }

  Future<void> deleteRequirement(String requirementId) async {
    await (_db.delete(_db.speciesRequirementsTable)..where((t) => t.id.equals(requirementId))).go();
  }
}
