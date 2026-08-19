import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import '../../../core/database/app_database.dart';
import '../domain/catalog_item.dart';
import '../domain/species_magnitude.dart';
import '../domain/species_requirement.dart';
import '../domain/subspecies.dart';
import '../../entities/domain/attachment.dart';
import '../../entities/domain/entity_template.dart';

import '../../../core/storage/file_storage_service.dart';

class CatalogRepository {
  final AppDatabase _db;
  final FileStorageService _fileStorageService;

  CatalogRepository(this._db, [FileStorageService? fileStorageService])
      : _fileStorageService = fileStorageService ?? FileStorageService();

  Future<Map<String, List<SpeciesMagnitude>>> _fetchMagnitudesForSpecies(List<String> speciesIds) async {
    if (speciesIds.isEmpty) return {};
    final magRows = await (_db.select(_db.speciesMagnitudesTable)
      ..where((t) => t.speciesId.isIn(speciesIds))).get();

    final Map<String, List<SpeciesMagnitude>> magMap = {};
    for (final m in magRows) {
      magMap.putIfAbsent(m.speciesId, () => []).add(SpeciesMagnitude(
        id: m.id,
        speciesId: m.speciesId,
        propertyName: m.propertyName,
        dataType: m.dataType,
        unitSymbol: m.unitSymbol,
        createdAt: m.createdAt,
      ));
    }
    return magMap;
  }

  CatalogItem _mapToDomainSync(CatalogTableData row, {List<SpeciesMagnitude> magnitudes = const []}) {
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

  Future<CatalogItem> _mapToDomain(CatalogTableData row) async {
    final magMap = await _fetchMagnitudesForSpecies([row.id]);
    return _mapToDomainSync(row, magnitudes: magMap[row.id] ?? const []);
  }

  Future<List<CatalogItem>> getAllCatalogItems() async {
    final query = _db.select(_db.catalogTable)..orderBy([(t) => OrderingTerm.asc(t.name)]);
    final rows = await query.get();
    final speciesIds = rows.map((r) => r.id).toList();
    final magMap = await _fetchMagnitudesForSpecies(speciesIds);

    return rows.map((row) => _mapToDomainSync(row, magnitudes: magMap[row.id] ?? const [])).toList();
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

  Future<CatalogItem> saveCatalogItem(CatalogItem item) async {
    final all = await getAllCatalogItems();

    final existingItem = all.where((c) => c.id == item.id).firstOrNull;
    if (existingItem != null && existingItem.mainPhotoPath != null && existingItem.mainPhotoPath!.isNotEmpty && existingItem.mainPhotoPath != item.mainPhotoPath) {
      final oldPhoto = existingItem.mainPhotoPath!;
      final allSubs = await getAllSubspecies();
      final isUsedElsewhere = all.any((c) => c.id != item.id && c.mainPhotoPath == oldPhoto) ||
          allSubs.any((s) => s.photoPath == oldPhoto);
      if (!isUsedElsewhere) {
        await _fileStorageService.deleteFile(oldPhoto);
      }
    }

    final nameDup = all.where((c) => c.id != item.id && c.name.toLowerCase() == item.name.trim().toLowerCase()).firstOrNull;
    final isNewSpecies = !all.any((c) => c.id == item.id);

    if (nameDup != null) {
      if (isNewSpecies) {
        // Requisito 1: Si se intenta crear una especie existente, integrar subespecies y magnitudes a la especie existente
        final targetSpeciesId = nameDup.id;

        // Reasignar subespecies que hayan sido vinculadas al id temporal
        await (_db.update(_db.subspeciesTable)..where((t) => t.speciesId.equals(item.id)))
            .write(SubspeciesTableCompanion(speciesId: Value(targetSpeciesId)));

        // Integrar magnitudes faltantes
        final existingMags = nameDup.magnitudes;
        for (final mag in item.magnitudes) {
          final isDup = existingMags.any((m) =>
              m.propertyName.toLowerCase() == mag.propertyName.toLowerCase() &&
              m.unitSymbol == mag.unitSymbol);
          if (!isDup) {
            await addSpeciesMagnitude(
              targetSpeciesId,
              mag.propertyName,
              dataType: mag.dataType,
              unitSymbol: mag.unitSymbol,
            );
          }
        }

        // Actualizar foto principal o descripción si la existente no tenía
        if ((nameDup.mainPhotoPath == null || nameDup.mainPhotoPath!.isEmpty) && item.mainPhotoPath != null) {
          await (_db.update(_db.catalogTable)..where((t) => t.id.equals(targetSpeciesId)))
              .write(CatalogTableCompanion(mainPhotoPath: Value(item.mainPhotoPath)));
        }

        final updated = await getCatalogItemById(targetSpeciesId);
        return updated ?? nameDup;
      } else {
        throw Exception(AppStrings.duplicateSpeciesNameError);
      }
    }

    if (item.mainPhotoPath != null && item.mainPhotoPath!.isNotEmpty) {
      final photoDup = all.where((c) => c.id != item.id && c.mainPhotoPath == item.mainPhotoPath).firstOrNull;
      if (photoDup != null) {
        throw Exception(AppStrings.duplicatePhotoError);
      }
    }

    final finalName = item.name.trim();
    final finalType = item.type;

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
    await _db.transaction(() async {
      await _db.into(_db.catalogTable).insertOnConflictUpdate(companion);

      await (_db.delete(_db.speciesMagnitudesTable)..where((t) => t.speciesId.equals(item.id))).go();
      for (final mag in item.magnitudes) {
        await _db.into(_db.speciesMagnitudesTable).insert(SpeciesMagnitudesTableCompanion(
          id: Value(mag.id.isEmpty ? const Uuid().v4() : mag.id),
          speciesId: Value(item.id),
          propertyName: Value(mag.propertyName),
          dataType: Value(mag.dataType),
          unitSymbol: Value(mag.unitSymbol),
          createdAt: Value(mag.createdAt),
        ));
      }

      await ensureDefaultSubspecies(item.id);
    });

    final saved = await getCatalogItemById(item.id);
    return saved ?? item;
  }

  Future<void> updateSpeciesName(String speciesId, String newName) async {
    final clean = newName.trim();
    if (clean.isEmpty) return;
    final item = await getCatalogItemById(speciesId);
    if (item == null) return;

    final updated = item.copyWith(name: clean);
    await saveCatalogItem(updated);
  }

  Future<void> removeSpeciesMainPhoto(String speciesId) async {
    final item = await getCatalogItemById(speciesId);
    if (item == null || item.mainPhotoPath == null || item.mainPhotoPath!.isEmpty) return;

    final oldPhoto = item.mainPhotoPath!;
    await (_db.update(_db.catalogTable)..where((t) => t.id.equals(speciesId)))
        .write(const CatalogTableCompanion(mainPhotoPath: Value(null)));

    final allItems = await getAllCatalogItems();
    final allSubs = await getAllSubspecies();
    final isUsedElsewhere = allItems.any((c) => c.mainPhotoPath == oldPhoto) ||
        allSubs.any((s) => s.photoPath == oldPhoto);
    if (!isUsedElsewhere) {
      await _fileStorageService.deleteFile(oldPhoto);
    }
  }

  Future<void> removeSubspeciesPhoto(String subspeciesId) async {
    final sub = await getSubspeciesById(subspeciesId);
    if (sub == null || sub.photoPath == null || sub.photoPath!.isEmpty) return;

    final oldPhoto = sub.photoPath!;
    await (_db.update(_db.subspeciesTable)..where((t) => t.id.equals(subspeciesId)))
        .write(const SubspeciesTableCompanion(photoPath: Value(null)));

    final allItems = await getAllCatalogItems();
    final allSubs = await getAllSubspecies();
    final isUsedElsewhere = allItems.any((c) => c.mainPhotoPath == oldPhoto) ||
        allSubs.any((s) => s.id != subspeciesId && s.photoPath == oldPhoto);
    if (!isUsedElsewhere) {
      await _fileStorageService.deleteFile(oldPhoto);
    }
  }

  Future<void> ensureDefaultSubspecies(String speciesId) async {
    final query = _db.select(_db.subspeciesTable)..where((t) => t.speciesId.equals(speciesId));
    final rows = await query.get();
    if (rows.isEmpty) {
      await saveSubspecies(Subspecies(
        id: const Uuid().v4(),
        speciesId: speciesId,
        subspeciesName: AppStrings.genericSubspeciesName,
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
      throw Exception(AppStrings.cannotDeleteSpeciesWithInstancesError);
    }

    await (_db.delete(_db.subspeciesTable)..where((t) => t.speciesId.equals(id))).go();
    await (_db.delete(_db.speciesRequirementsTable)..where((t) => t.sourceId.equals(id) | t.requiredSpeciesId.equals(id))).go();
    await (_db.delete(_db.speciesMagnitudesTable)..where((t) => t.speciesId.equals(id))).go();
    await (_db.delete(_db.catalogTable)..where((t) => t.id.equals(id))).go();
  }

  // --- REORGANIZACIÓN TAXONÓMICA ---

  /// Unir Especie A en Especie B (Requisito 2a)
  Future<void> mergeSpecies(String sourceSpeciesId, String targetSpeciesId) async {
    if (sourceSpeciesId == targetSpeciesId) return;

    await _db.transaction(() async {
      // 1. Reasignar subespecies de origen a destino
      await (_db.update(_db.subspeciesTable)..where((t) => t.speciesId.equals(sourceSpeciesId)))
          .write(SubspeciesTableCompanion(speciesId: Value(targetSpeciesId)));

      // 2. Reasignar entidades de origen a destino
      await (_db.update(_db.entitiesTable)..where((t) => t.speciesId.equals(sourceSpeciesId)))
          .write(EntitiesTableCompanion(speciesId: Value(targetSpeciesId)));

      // 3. Reasignar adjuntos
      await (_db.update(_db.attachmentsTable)..where((t) => t.speciesId.equals(sourceSpeciesId)))
          .write(AttachmentsTableCompanion(speciesId: Value(targetSpeciesId)));

      // 4. Reasignar requerimientos
      await (_db.update(_db.speciesRequirementsTable)..where((t) => t.sourceId.equals(sourceSpeciesId)))
          .write(SpeciesRequirementsTableCompanion(sourceId: Value(targetSpeciesId)));
      await (_db.update(_db.speciesRequirementsTable)..where((t) => t.requiredSpeciesId.equals(sourceSpeciesId)))
          .write(SpeciesRequirementsTableCompanion(requiredSpeciesId: Value(targetSpeciesId)));

      // 5. Eliminar magnitudes y especie de origen
      await (_db.delete(_db.speciesMagnitudesTable)..where((t) => t.speciesId.equals(sourceSpeciesId))).go();
      await (_db.delete(_db.catalogTable)..where((t) => t.id.equals(sourceSpeciesId))).go();
    });
  }

  /// Separar Subespecie de su especie original a una nueva especie (Requisitos 2b, 6a, 6b)
  Future<CatalogItem> separateSubspecies(String subspeciesId, String newSpeciesName) async {
    final sub = await getSubspeciesById(subspeciesId);
    if (sub == null) throw Exception(AppStrings.subspeciesNotFoundError);

    final parentSpecies = await getCatalogItemById(sub.speciesId);
    if (parentSpecies == null) throw Exception(AppStrings.speciesNotFoundError);

    final newSpecies = await getOrCreateSpecies(
      newSpeciesName,
      type: parentSpecies.type,
      description: '${AppStrings.separatedFromSpeciesPrefix}${parentSpecies.name}',
      mainPhotoPath: sub.photoPath ?? parentSpecies.mainPhotoPath,
    );

    await _db.transaction(() async {
      // 6.a: Si la especie de origen tiene la misma foto que la subespecie, limpiar foto de origen
      if (parentSpecies.mainPhotoPath != null && parentSpecies.mainPhotoPath == sub.photoPath) {
        await (_db.update(_db.catalogTable)..where((t) => t.id.equals(parentSpecies.id)))
            .write(const CatalogTableCompanion(mainPhotoPath: Value(null)));
      }

      // Mover la subespecie a la nueva especie
      await (_db.update(_db.subspeciesTable)..where((t) => t.id.equals(subspeciesId)))
          .write(SubspeciesTableCompanion(speciesId: Value(newSpecies.id)));

      // Mover las entidades correspondientes a la nueva especie
      await (_db.update(_db.entitiesTable)..where((t) => t.subspeciesId.equals(subspeciesId)))
          .write(EntitiesTableCompanion(speciesId: Value(newSpecies.id)));

      // 6.b: Si la especie de origen quedó sin subespecies, eliminarla
      final remainingSubs = await (_db.select(_db.subspeciesTable)..where((t) => t.speciesId.equals(parentSpecies.id))).get();
      if (remainingSubs.isEmpty) {
        await (_db.delete(_db.speciesRequirementsTable)..where((t) => t.sourceId.equals(parentSpecies.id) | t.requiredSpeciesId.equals(parentSpecies.id))).go();
        await (_db.delete(_db.speciesMagnitudesTable)..where((t) => t.speciesId.equals(parentSpecies.id))).go();
        await (_db.delete(_db.catalogTable)..where((t) => t.id.equals(parentSpecies.id))).go();
      }
    });

    return newSpecies;
  }

  /// Mover Subespecie a otra especie existente (Requisitos 2c y 7)
  Future<void> moveSubspecies(String subspeciesId, String targetSpeciesId) async {
    final sub = await getSubspeciesById(subspeciesId);
    if (sub == null) throw Exception('Subespecie no encontrada');
    final oldSpeciesId = sub.speciesId;
    if (oldSpeciesId == targetSpeciesId) return;

    await _db.transaction(() async {
      // Reasignar subespecie
      await (_db.update(_db.subspeciesTable)..where((t) => t.id.equals(subspeciesId)))
          .write(SubspeciesTableCompanion(speciesId: Value(targetSpeciesId)));

      // Reasignar entidades que pertenecen a esta subespecie
      await (_db.update(_db.entitiesTable)..where((t) => t.subspeciesId.equals(subspeciesId)))
          .write(EntitiesTableCompanion(speciesId: Value(targetSpeciesId)));

      // 7: Si la especie de origen quedó sin subespecies, eliminarla
      final remainingSubs = await (_db.select(_db.subspeciesTable)..where((t) => t.speciesId.equals(oldSpeciesId))).get();
      if (remainingSubs.isEmpty) {
        await (_db.delete(_db.speciesRequirementsTable)..where((t) => t.sourceId.equals(oldSpeciesId) | t.requiredSpeciesId.equals(oldSpeciesId))).go();
        await (_db.delete(_db.speciesMagnitudesTable)..where((t) => t.speciesId.equals(oldSpeciesId))).go();
        await (_db.delete(_db.catalogTable)..where((t) => t.id.equals(oldSpeciesId))).go();
      }
    });
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
    final existingSub = await getSubspeciesById(subspecies.id);
    if (existingSub != null && existingSub.photoPath != null && existingSub.photoPath!.isNotEmpty && existingSub.photoPath != subspecies.photoPath) {
      final oldPhoto = existingSub.photoPath!;
      final allItems = await getAllCatalogItems();
      final allSubs = await getAllSubspecies();
      final isUsedElsewhere = allItems.any((c) => c.mainPhotoPath == oldPhoto) ||
          allSubs.any((s) => s.id != subspecies.id && s.photoPath == oldPhoto);
      if (!isUsedElsewhere) {
        await _fileStorageService.deleteFile(oldPhoto);
      }
    }

    String? finalBrand = subspecies.brand?.trim();
    String? finalBarcode = subspecies.barcode?.trim();

    if (subspecies.speciesId.isNotEmpty) {
      final species = await getCatalogItemById(subspecies.speciesId);
      if (species != null && !EntityTemplateRegistry.hasBarcodeAndBrand(species.type)) {
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
      throw Exception(AppStrings.cannotDeleteSubspeciesWithInstancesError);
    }

    await (_db.delete(_db.subspeciesTable)..where((t) => t.id.equals(id))).go();
  }

  // --- SPECIES & ENTITY REQUIREMENTS CRUD ---

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

  // --- ATTACHMENTS & MAGNITUDES ---

  Future<void> addAttachment({
    required String speciesId,
    String? instanceId,
    required String filePath,
    required String fileName,
    required String fileType,
  }) async {
    String storedPath = filePath;
    try {
      if (await _fileStorageService.fileExists(filePath)) {
        storedPath = await _fileStorageService.saveFile(filePath);
      }
    } catch (_) {
      // Fallback if saveFile fails or path is already stored
    }

    final companion = AttachmentsTableCompanion(
      id: Value(const Uuid().v4()),
      speciesId: Value(speciesId),
      instanceId: Value(instanceId),
      filePath: Value(storedPath),
      fileName: Value(fileName),
      fileType: Value(fileType),
      createdAt: Value(DateTime.now()),
    );
    await _db.into(_db.attachmentsTable).insertOnConflictUpdate(companion);
  }

  Future<void> updateAttachment(Attachment attachment) async {
    final companion = AttachmentsTableCompanion(
      id: Value(attachment.id),
      speciesId: Value(attachment.speciesId),
      instanceId: Value(attachment.instanceId),
      filePath: Value(attachment.filePath),
      fileName: Value(attachment.fileName),
      fileType: Value(attachment.fileType),
      createdAt: Value(attachment.createdAt),
    );
    await _db.into(_db.attachmentsTable).insertOnConflictUpdate(companion);
  }

  Future<void> addSpeciesMagnitude(
    String speciesId,
    String propertyName, {
    String dataType = 'real',
    String? unitSymbol,
  }) async {
    final cleanName = propertyName.trim();
    final cleanUnit = unitSymbol?.trim();

    final query = _db.select(_db.speciesMagnitudesTable)
      ..where((t) {
        final nameCond = t.speciesId.equals(speciesId) & t.propertyName.equals(cleanName);
        if (cleanUnit != null && cleanUnit.isNotEmpty) {
          return nameCond & t.unitSymbol.equals(cleanUnit);
        } else {
          return nameCond & (t.unitSymbol.isNull() | t.unitSymbol.equals(''));
        }
      });
    final existing = await query.getSingleOrNull();

    if (existing == null) {
      await _db.into(_db.speciesMagnitudesTable).insert(
        SpeciesMagnitudesTableCompanion(
          id: Value(const Uuid().v4()),
          speciesId: Value(speciesId),
          propertyName: Value(cleanName),
          dataType: Value(dataType),
          unitSymbol: Value(cleanUnit),
          createdAt: Value(DateTime.now()),
        ),
      );
    }
  }
}
