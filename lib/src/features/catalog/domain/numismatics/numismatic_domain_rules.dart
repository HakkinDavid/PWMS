import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import 'package:platinum_world_management_system/src/core/constants/app_technical_strings.dart';
import 'package:platinum_world_management_system/src/core/database/app_database.dart';
import '../subspecies.dart';
import '../../../entities/domain/instance_magnitude.dart';
import '../../../entities/domain/world_entity.dart';
import '../../../entities/domain/i_entity_repository.dart';
import '../../../entities/infrastructure/entity_repository.dart';
import '../../infrastructure/catalog_repository.dart';
import 'numismatic_parser.dart';

class NumismaticCongruenceIssue {
  final String subspeciesId;
  final String? instanceId;
  final String issueType; // 'currency_mismatch', 'duplicate_subspecies', 'attachment_mismatch', 'missing_magnitudes'
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

  /// Checks if instance magnitudes match the currency subspecies and canonical standardization.
  static String? checkInstanceSubspeciesCongruence({
    required Subspecies subspecies,
    required WorldEntity instance,
  }) {
    final instAttrs = NumismaticParser.extractAttributesFromInstance(instance);
    final mismatches = <String>[];

    final parsedSub = NumismaticParser.parseSubspeciesName(subspecies.subspeciesName);
    final subCurrency = (parsedSub.currencyName != null && parsedSub.currencyName!.isNotEmpty)
        ? parsedSub.currencyName!
        : subspecies.subspeciesName;

    // 1. Currency congruence check between instance and subspecies
    if (instAttrs.currencyName != null && instAttrs.currencyName!.isNotEmpty) {
      final isEquivalent = NumismaticParser.areCurrenciesEquivalent(
        instAttrs.currencyName,
        subCurrency,
      );
      if (!isEquivalent) {
        final expectedCurr = NumismaticParser.resolveCurrencyName(subCurrency);
        mismatches.add(
          AppStrings.numisAuditCurrencyMismatch(instAttrs.currencyName!, expectedCurr),
        );
      }
    }

    // 2. Instance magnitude currency standardization check (must be ISO code)
    if (instAttrs.currencyName != null && instAttrs.currencyName!.isNotEmpty) {
      final isoCode = NumismaticParser.resolveCurrencyIsoCode(instAttrs.currencyName!);
      if (instAttrs.currencyName!.trim().toUpperCase() != isoCode) {
        mismatches.add(AppStrings.numisAuditCurrencyNotIso(instAttrs.currencyName!, isoCode));
      }
    }

    // 3. Instance magnitude grade standardization check
    if (instAttrs.grade != null && instAttrs.grade!.isNotEmpty) {
      final stdGrade = NumismaticParser.resolveGrade(instAttrs.grade!);
      if (instAttrs.grade!.trim() != stdGrade) {
        mismatches.add(AppStrings.numisAuditGradeMismatch(instAttrs.grade!, stdGrade));
      }
    }

    // 4. Instance magnitude material standardization check
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

  /// Identifies duplicate currency subspecies under the same species (e.g. 'MXN' and 'Pesos Mexicanos').
  static Map<String, List<Subspecies>> findDuplicateSubspeciesGroups(
      List<Subspecies> subspeciesList) {
    final Map<String, List<Subspecies>> grouped = {};

    for (final sub in subspeciesList) {
      if (sub.subspeciesName.toLowerCase() == AppTechnicalStrings.numisGenericSubspeciesKind) continue;

      // Extract canonical currency name (handles both granular legacy titles and currency-only titles)
      final parsed = NumismaticParser.parseSubspeciesName(sub.subspeciesName);
      final rawCurr = (parsed.currencyName != null && parsed.currencyName!.isNotEmpty)
          ? parsed.currencyName!
          : sub.subspeciesName;
      final canonicalCurrency = NumismaticParser.resolveCurrencyName(rawCurr);

      final key = AppTechnicalStrings.numisSubspeciesKey(sub.speciesId, canonicalCurrency.trim().toLowerCase());
      grouped.putIfAbsent(key, () => []).add(sub);
    }

    grouped.removeWhere((key, list) => list.length <= 1);
    return grouped;
  }

  /// Repairs subspecies title, instance magnitudes & attachment file names to strict canonical standards.
  static Future<Subspecies> repairSubspeciesFromInstance({
    required CatalogRepository catalogRepo,
    required IEntityRepository entityRepo,
    required Subspecies subspecies,
    required WorldEntity instance,
  }) async {
    final instAttrs = NumismaticParser.extractAttributesFromInstance(instance);
    final parsedOld = NumismaticParser.parseSubspeciesName(subspecies.subspeciesName);

    // Resolve canonical currency name for the subspecies
    final rawCurr = (instAttrs.currencyName != null && instAttrs.currencyName!.isNotEmpty)
        ? instAttrs.currencyName!
        : (parsedOld.currencyName ?? subspecies.subspeciesName);
    final canonicalCurrency = NumismaticParser.resolveCurrencyName(rawCurr);

    final canonicalNotes = NumismaticParser.buildSubspeciesNotes(
      currencyName: canonicalCurrency,
    );

    final updatedSub = subspecies.copyWith(
      subspeciesName: canonicalCurrency,
      notes: canonicalNotes.isNotEmpty ? canonicalNotes : subspecies.notes,
    );

    await catalogRepo.saveSubspecies(updatedSub);

    // Standardize instance magnitudes ('Divisa', 'Grado', 'Material', 'Emisor') if present
    final List<InstanceMagnitude> updatedMags = instance.magnitudes.map((m) {
      final pName = m.propertyName.trim().toLowerCase();
      if (pName == AppStrings.magDivisa.toLowerCase() && m.stringValue != null) {
        final iso = NumismaticParser.resolveCurrencyIsoCode(m.stringValue!);
        return m.copyWith(stringValue: iso);
      }
      if (pName == AppStrings.magGrado.toLowerCase() && m.stringValue != null) {
        return m.copyWith(stringValue: NumismaticParser.resolveGrade(m.stringValue!));
      }
      if (pName == AppStrings.magMaterial.toLowerCase() && m.stringValue != null) {
        return m.copyWith(stringValue: NumismaticParser.resolveMaterial(m.stringValue!));
      }
      return m;
    }).toList();

    // Backfill Emisor from legacy subspecies name if missing on instance
    final hasEmisor = updatedMags.any((m) {
      final pName = m.propertyName.trim().toLowerCase();
      return pName == AppStrings.magEmisor.toLowerCase() ||
          pName == AppTechnicalStrings.magPaisLower ||
          pName == AppTechnicalStrings.magPaisWithoutAccentLower;
    });
    if (!hasEmisor && parsedOld.country != null && parsedOld.country!.trim().isNotEmpty) {
      updatedMags.add(InstanceMagnitude(
        id: const Uuid().v4(),
        instanceId: instance.id,
        propertyName: AppStrings.issuerPropertyName,
        dataType: AppTechnicalStrings.datatypeStringLower,
        stringValue: parsedOld.country!.trim(),
      ));
    }

    final updatedInstance = instance.copyWith(magnitudes: updatedMags);
    await entityRepo.saveEntity(updatedInstance);

    // Standardize attachment file names using instance derived title
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

  /// Renames attachment files and updates database records to match current canonical instance derived name.
  static Future<void> repairAttachmentFileNames({
    required CatalogRepository catalogRepo,
    required IEntityRepository entityRepo,
    required Subspecies subspecies,
    required WorldEntity instance,
  }) async {
    final instAttrs = NumismaticParser.extractAttributesFromInstance(instance);
    var pieceDisplayName = NumismaticParser.buildInstanceDisplayName(instAttrs);
    if (pieceDisplayName == AppStrings.defaultNumismaticPiece) {
      final parsedSub = NumismaticParser.parseSubspeciesName(subspecies.subspeciesName);
      if (parsedSub.currencyName != null || parsedSub.faceValueNumber != null) {
        pieceDisplayName = NumismaticParser.buildSubspeciesName(
          faceValueNumber: parsedSub.faceValueNumber,
          faceValueStr: parsedSub.faceValueStr,
          currencyName: parsedSub.currencyName,
          country: parsedSub.country,
          year: parsedSub.year,
        );
      }
      if (pieceDisplayName == AppStrings.defaultNumismaticPiece) {
        pieceDisplayName = subspecies.subspeciesName;
      }
    }

    final attachments = await entityRepo.getAttachmentsForInstance(instance.id);
    for (final att in attachments) {
      final isObverse = att.fileName.toLowerCase().contains(AppTechnicalStrings.anversoParensLower) ||
          att.fileName.toLowerCase().contains(AppTechnicalStrings.anversoLower);
      final side = isObverse ? AppTechnicalStrings.anversoLower : AppTechnicalStrings.reversoLower;

      final file = File(att.filePath);
      final ext = att.fileName.contains(AppTechnicalStrings.dot)
          ? att.fileName.split(AppTechnicalStrings.dot).last
          : (file.path.contains(AppTechnicalStrings.dot)
              ? file.path.split(AppTechnicalStrings.dot).last
              : AppTechnicalStrings.empty);

      final expectedName = NumismaticParser.buildAttachmentFileName(
        subspeciesName: pieceDisplayName,
        instanceId: instance.id,
        side: side,
        extension: ext,
      );

      if (att.fileName != expectedName) {
        // Renombrar archivo en disco si existe
        if (file.existsSync()) {
          final parentDir = file.parent.path;
          final newPath = AppStrings.numisAttachmentPath(parentDir, expectedName);
          final renamedFile = file.renameSync(newPath);

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

  /// Repairs, consolidates and standardizes numismatic records in bulk after database import or migration.
  static Future<void> repairAndStandardizeImportedData(AppDatabase db) async {
    final catalogRepo = CatalogRepository(db);
    final entityRepo = EntityRepository(db);

    final allCatalog = await catalogRepo.getAllCatalogItems();
    final allEntities = await entityRepo.getAllEntities();
    final numismaticSpecies = allCatalog.where(NumismaticParser.isNumismaticSpecies).toList();

    for (final species in numismaticSpecies) {
      final subspeciesList = await catalogRepo.getSubspeciesForSpecies(species.id);
      final instances = allEntities.where((e) => e.speciesId == species.id).toList();

      // Ensure species has required standard magnitudes registered
      await catalogRepo.addSpeciesMagnitude(species.id, AppStrings.nominalValuePropertyName, dataType: AppTechnicalStrings.datatypeRealLower);
      await catalogRepo.addSpeciesMagnitude(species.id, AppStrings.mintagePropertyName, dataType: AppTechnicalStrings.datatypeIntegerLower, unitSymbol: AppStrings.yearUnitSymbol);
      await catalogRepo.addSpeciesMagnitude(species.id, AppStrings.currencyPropertyName, dataType: AppTechnicalStrings.datatypeStringLower);
      await catalogRepo.addSpeciesMagnitude(species.id, AppStrings.materialPropertyName, dataType: AppTechnicalStrings.datatypeStringLower);
      await catalogRepo.addSpeciesMagnitude(species.id, AppStrings.gradePropertyName, dataType: AppTechnicalStrings.datatypeStringLower);
      await catalogRepo.addSpeciesMagnitude(species.id, AppStrings.issuerPropertyName, dataType: AppTechnicalStrings.datatypeStringLower);

      final Map<String, Subspecies> currencySubspeciesMap = {};

      for (final sub in subspeciesList) {
        final parsedOld = NumismaticParser.parseSubspeciesName(sub.subspeciesName);
        final rawCurr = (parsedOld.currencyName != null && parsedOld.currencyName!.isNotEmpty)
            ? parsedOld.currencyName!
            : sub.subspeciesName;
        final canonicalCurrency = NumismaticParser.resolveCurrencyName(rawCurr);

        // Find or create currency subspecies
        Subspecies? targetCurrencySub = currencySubspeciesMap[canonicalCurrency.toLowerCase()];
        if (targetCurrencySub == null) {
          final existing = subspeciesList.where(
            (s) => s.subspeciesName.trim().toLowerCase() == canonicalCurrency.toLowerCase(),
          ).firstOrNull;

          if (existing != null) {
            targetCurrencySub = existing;
          } else {
            targetCurrencySub = sub.copyWith(
              subspeciesName: canonicalCurrency,
              notes: NumismaticParser.buildSubspeciesNotes(currencyName: canonicalCurrency),
            );
            await catalogRepo.saveSubspecies(targetCurrencySub);
          }
          currencySubspeciesMap[canonicalCurrency.toLowerCase()] = targetCurrencySub;
        }

        // Migrate instances under this sub
        final subInstances = instances.where((e) => e.subspeciesId == sub.id).toList();
        for (final inst in subInstances) {
          final instAttrs = NumismaticParser.extractAttributesFromInstance(inst);
          final List<InstanceMagnitude> customMags = List.from(inst.magnitudes);

          // Backfill missing magnitudes from parsedOld title if missing
          if (instAttrs.faceValueNumber == null && parsedOld.faceValueNumber != null) {
            customMags.add(InstanceMagnitude(
              id: const Uuid().v4(),
              instanceId: inst.id,
              propertyName: AppStrings.nominalValuePropertyName,
              dataType: AppTechnicalStrings.datatypeRealLower,
              magnitudeValue: parsedOld.faceValueNumber,
            ));
          }

          if (instAttrs.year == null && parsedOld.year != null && double.tryParse(parsedOld.year!) != null) {
            customMags.add(InstanceMagnitude(
              id: const Uuid().v4(),
              instanceId: inst.id,
              propertyName: AppStrings.mintagePropertyName,
              dataType: AppTechnicalStrings.datatypeIntegerLower,
              magnitudeValue: double.parse(parsedOld.year!),
              unitSymbol: AppStrings.yearUnitSymbol,
            ));
          }

          if (instAttrs.currencyName == null) {
            final iso = NumismaticParser.resolveCurrencyIsoCode(canonicalCurrency);
            customMags.add(InstanceMagnitude(
              id: const Uuid().v4(),
              instanceId: inst.id,
              propertyName: AppStrings.currencyPropertyName,
              dataType: AppTechnicalStrings.datatypeStringLower,
              stringValue: iso,
            ));
          }

          final hasEmisor = customMags.any((m) {
            final p = m.propertyName.trim().toLowerCase();
            return p == AppStrings.magEmisor.toLowerCase() ||
                p == AppTechnicalStrings.magPaisLower ||
                p == AppTechnicalStrings.magPaisWithoutAccentLower;
          });
          if (!hasEmisor && parsedOld.country != null && parsedOld.country!.isNotEmpty) {
            customMags.add(InstanceMagnitude(
              id: const Uuid().v4(),
              instanceId: inst.id,
              propertyName: AppStrings.issuerPropertyName,
              dataType: AppTechnicalStrings.datatypeStringLower,
              stringValue: parsedOld.country,
            ));
          }

          final updatedInst = inst.copyWith(
            subspeciesId: targetCurrencySub.id,
            magnitudes: customMags,
          );
          await entityRepo.saveEntity(updatedInst);

          await repairAttachmentFileNames(
            catalogRepo: catalogRepo,
            entityRepo: entityRepo,
            subspecies: targetCurrencySub,
            instance: updatedInst,
          );
        }

        // If this old subspecies is not the targetCurrencySub, delete it
        if (sub.id != targetCurrencySub.id) {
          await catalogRepo.deleteSubspecies(sub.id);
        }
      }

      // Merge any duplicate currency subspecies
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
