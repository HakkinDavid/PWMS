import 'dart:io';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import 'package:platinum_world_management_system/src/core/constants/app_technical_strings.dart';
import 'package:platinum_world_management_system/src/core/database/app_database.dart';
import '../subspecies.dart';
import '../../../entities/domain/world_entity.dart';
import '../../../entities/domain/i_entity_repository.dart';
import '../../../entities/infrastructure/entity_repository.dart';
import '../../infrastructure/catalog_repository.dart';
import 'numismatic_parser.dart';

class NumismaticCongruenceIssue {
  final String subspeciesId;
  final String? instanceId;
  final String issueType; // 'magnitude_mismatch', 'duplicate_subspecies', 'attachment_mismatch', 'missing_magnitudes'
  final String description;
  final NumismaticAttributes expectedAttributes;
  final NumismaticAttributes? foundAttributes;

  const NumismaticCongruenceIssue({
    required this.subspeciesId,
    this.instanceId,
    required this.issueType,
    required this.description,
    required this.expectedAttributes,
    this.foundAttributes,
  });
}

class NumismaticDomainRules {
  NumismaticDomainRules._();

  /// Checks if instance magnitudes and subspecies title follow the strict canonical pattern.
  static String? checkInstanceSubspeciesCongruence({
    required Subspecies subspecies,
    required WorldEntity instance,
  }) {
    final instAttrs = NumismaticParser.extractAttributesFromInstance(instance);
    final subAttrs = NumismaticParser.parseSubspeciesName(subspecies.subspeciesName);

    final mismatches = <String>[];

    // 1. Strict subspecies title pattern check
    final canonicalTitle = NumismaticParser.buildSubspeciesName(
      faceValueNumber: instAttrs.faceValueNumber ?? subAttrs.faceValueNumber,
      currencyName: instAttrs.currencyName ?? subAttrs.currencyName,
      country: subAttrs.country,
      year: instAttrs.year ?? subAttrs.year,
    );

    if (subspecies.subspeciesName.trim() != canonicalTitle.trim()) {
      mismatches.add(AppStrings.numisAuditTitleMismatch(subspecies.subspeciesName, canonicalTitle));
    }

    // 2. Year check
    if (instAttrs.year != null &&
        subAttrs.year != null &&
        instAttrs.year != subAttrs.year) {
      mismatches.add(AppStrings.numisAuditYearMismatch(instAttrs.year!, subAttrs.year!));
    }

    // 3. Face value check
    if (instAttrs.faceValueNumber != null &&
        subAttrs.faceValueNumber != null &&
        (instAttrs.faceValueNumber! - subAttrs.faceValueNumber!).abs() > 0.001) {
      mismatches.add(AppStrings.numisAuditFaceValueMismatch(instAttrs.faceValueNumber!, subAttrs.faceValueNumber!));
    }

    // 4. Instance magnitude currency standardization check (must be ISO code)
    if (instAttrs.currencyName != null) {
      final isoCode = NumismaticParser.resolveCurrencyIsoCode(instAttrs.currencyName!);
      if (instAttrs.currencyName!.trim().toUpperCase() != isoCode) {
        mismatches.add(AppStrings.numisAuditCurrencyNotIso(instAttrs.currencyName!, isoCode));
      }
    }

    // 5. Instance magnitude grade standardization check
    if (instAttrs.grade != null && instAttrs.grade!.isNotEmpty) {
      final stdGrade = NumismaticParser.resolveGrade(instAttrs.grade!);
      if (instAttrs.grade!.trim() != stdGrade) {
        mismatches.add(AppStrings.numisAuditGradeMismatch(instAttrs.grade!, stdGrade));
      }
    }

    // 6. Instance magnitude material standardization check
    if (instAttrs.material != null && instAttrs.material!.isNotEmpty) {
      final stdMat = NumismaticParser.resolveMaterial(instAttrs.material!);
      if (instAttrs.material!.trim() != stdMat) {
        mismatches.add(AppStrings.numisAuditMaterialMismatch(instAttrs.material!, stdMat));
      }
    }

    if (mismatches.isNotEmpty) {
      return AppStrings.numisAuditIncongruence(mismatches.join(AppTechnicalStrings.pipeWithSpaces));
    }

    return null;
  }

  /// Identifies duplicate subspecies under the same species (same canonical title).
  static Map<String, List<Subspecies>> findDuplicateSubspeciesGroups(
      List<Subspecies> subspeciesList) {
    final Map<String, List<Subspecies>> grouped = {};

    for (final sub in subspeciesList) {
      if (sub.subspeciesName.toLowerCase() == AppTechnicalStrings.numisGenericSubspeciesKind) continue;

      final parsed = NumismaticParser.parseSubspeciesName(sub.subspeciesName);
      final normTitle = NumismaticParser.buildSubspeciesName(
        faceValueNumber: parsed.faceValueNumber,
        currencyName: parsed.currencyName,
        country: parsed.country,
        year: parsed.year,
      );

      final key = AppTechnicalStrings.numisSubspeciesKey(sub.speciesId, normTitle.trim().toLowerCase());
      grouped.putIfAbsent(key, () => []).add(sub);
    }

    grouped.removeWhere((key, list) => list.length <= 1);
    return grouped;
  }

  /// Repairs subspecies title, notes, instance magnitudes & attachment file names to strict canonical standards.
  static Future<Subspecies> repairSubspeciesFromInstance({
    required CatalogRepository catalogRepo,
    required IEntityRepository entityRepo,
    required Subspecies subspecies,
    required WorldEntity instance,
  }) async {
    final instAttrs = NumismaticParser.extractAttributesFromInstance(instance);
    final subAttrs = NumismaticParser.parseSubspeciesName(subspecies.subspeciesName);

    final canonicalTitle = NumismaticParser.buildSubspeciesName(
      faceValueNumber: instAttrs.faceValueNumber ?? subAttrs.faceValueNumber,
      currencyName: instAttrs.currencyName ?? subAttrs.currencyName,
      country: subAttrs.country,
      year: instAttrs.year ?? subAttrs.year,
    );

    final canonicalNotes = NumismaticParser.buildSubspeciesNotes(
      currencyName: instAttrs.currencyName ?? subAttrs.currencyName,
      year: instAttrs.year ?? subAttrs.year,
      composition: instAttrs.material != null ? NumismaticParser.resolveMaterial(instAttrs.material!) : null,
    );

    final updatedSub = subspecies.copyWith(
      subspeciesName: canonicalTitle,
      notes: canonicalNotes.isNotEmpty ? canonicalNotes : subspecies.notes,
    );

    await catalogRepo.saveSubspecies(updatedSub);

    // Standardize instance magnitudes ('Divisa', 'Grado', 'Material') if present
    final updatedMags = instance.magnitudes.map((m) {
      if (m.propertyName == AppStrings.magDivisa && m.stringValue != null) {
        final iso = NumismaticParser.resolveCurrencyIsoCode(m.stringValue!);
        return m.copyWith(stringValue: iso);
      }
      if (m.propertyName == AppStrings.magGrado && m.stringValue != null) {
        return m.copyWith(stringValue: NumismaticParser.resolveGrade(m.stringValue!));
      }
      if (m.propertyName == AppStrings.magMaterial && m.stringValue != null) {
        return m.copyWith(stringValue: NumismaticParser.resolveMaterial(m.stringValue!));
      }
      return m;
    }).toList();

    final updatedInstance = instance.copyWith(magnitudes: updatedMags);
    await entityRepo.saveEntity(updatedInstance);

    // Standardize attachment file names
    await repairAttachmentFileNames(
      catalogRepo: catalogRepo,
      entityRepo: entityRepo,
      subspecies: updatedSub,
      instance: updatedInstance,
    );

    return updatedSub;
  }

  /// Merges duplicate subspecies into a canonical subspecies. Reassigns entities and deletes duplicates.
  static Future<void> mergeDuplicateSubspecies({
    required CatalogRepository catalogRepo,
    required IEntityRepository entityRepo,
    required Subspecies canonicalSubspecies,
    required List<Subspecies> duplicateSubspeciesList,
  }) async {
    final allEntities = await entityRepo.getAllEntities();

    for (final dup in duplicateSubspeciesList) {
      if (dup.id == canonicalSubspecies.id) continue;

      // Reassign entities belonging to dup
      final entitiesToMove = allEntities.where((e) => e.subspeciesId == dup.id);
      for (final entity in entitiesToMove) {
        final updated = entity.copyWith(subspeciesId: canonicalSubspecies.id);
        await entityRepo.saveEntity(updated);
      }

      // Delete duplicate subspecies
      await catalogRepo.deleteSubspecies(dup.id);
    }
  }

  /// Renames attachment files and updates database records to match current canonical subspecies name.
  static Future<void> repairAttachmentFileNames({
    required CatalogRepository catalogRepo,
    required IEntityRepository entityRepo,
    required Subspecies subspecies,
    required WorldEntity instance,
  }) async {
    final attachments = await entityRepo.getAttachmentsForInstance(instance.id);
    for (final att in attachments) {
      final isObverse = att.fileName.toLowerCase().contains(AppTechnicalStrings.anversoParensLower) ||
          att.fileName.toLowerCase().contains(AppTechnicalStrings.anversoLower);
      final side = isObverse ? AppTechnicalStrings.anversoLower : AppTechnicalStrings.reversoLower;

      final file = File(att.filePath);
      final ext = file.path.contains(AppTechnicalStrings.dot) ? file.path.split(AppTechnicalStrings.dot).last : AppTechnicalStrings.extJpgNoExt;

      final expectedName = NumismaticParser.buildAttachmentFileName(
        subspeciesName: subspecies.subspeciesName,
        instanceId: instance.id,
        side: side,
        extension: ext,
      );

      if (att.fileName != expectedName) {
        // Renombrar archivo en disco si existe
        if (await file.exists()) {
          final parentDir = file.parent.path;
          final newPath = AppStrings.numisAttachmentPath(parentDir, expectedName);
          final renamedFile = await file.rename(newPath);

          // Actualizar en base de datos
          final updatedAtt = att.copyWith(
            fileName: expectedName,
            filePath: renamedFile.path,
          );
          await catalogRepo.updateAttachment(updatedAtt);
        } else {
          // Solo actualizar nombre en DB
          final updatedAtt = att.copyWith(fileName: expectedName);
          await catalogRepo.updateAttachment(updatedAtt);
        }
      }
    }
  }

  /// Repairs and standardizes numismatic records in bulk after database import or migration.
  static Future<void> repairAndStandardizeImportedData(AppDatabase db) async {
    final catalogRepo = CatalogRepository(db);
    final entityRepo = EntityRepository(db);

    final allCatalog = await catalogRepo.getAllCatalogItems();
    final allEntities = await entityRepo.getAllEntities();
    final numismaticSpecies = allCatalog.where(NumismaticParser.isNumismaticSpecies).toList();

    for (final species in numismaticSpecies) {
      final subspeciesList = await catalogRepo.getSubspeciesForSpecies(species.id);
      final instances = allEntities.where((e) => e.speciesId == species.id).toList();

      for (final sub in subspeciesList) {
        final subInstances = instances.where((e) => e.subspeciesId == sub.id).toList();
        if (subInstances.isNotEmpty) {
          await repairSubspeciesFromInstance(
            catalogRepo: catalogRepo,
            entityRepo: entityRepo,
            subspecies: sub,
            instance: subInstances.first,
          );
        }
      }

      // Merge duplicate subspecies
      final refreshedSubs = await catalogRepo.getSubspeciesForSpecies(species.id);
      final dupGroups = findDuplicateSubspeciesGroups(refreshedSubs);
      for (final group in dupGroups.values) {
        final canonical = group.first;
        await mergeDuplicateSubspecies(
          catalogRepo: catalogRepo,
          entityRepo: entityRepo,
          canonicalSubspecies: canonical,
          duplicateSubspeciesList: group,
        );
      }
    }
  }
}
