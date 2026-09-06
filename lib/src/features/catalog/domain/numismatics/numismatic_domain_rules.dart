import 'dart:io';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import 'package:platinum_world_management_system/src/core/constants/app_technical_strings.dart';
import 'package:platinum_world_management_system/src/core/database/app_database.dart';
import '../catalog_item.dart';
import '../subspecies.dart';
import '../../../entities/domain/instance_magnitude.dart';
import '../../../entities/domain/world_entity.dart';
import '../../../entities/domain/i_entity_repository.dart';
import '../../../entities/infrastructure/entity_repository.dart';
import '../../infrastructure/catalog_repository.dart';
import 'numismatic_parser.dart';
import 'numismatic_matrix.dart';

enum NumismaticEmissionOutlierType {
  currencyAnachronism,
  materialContradiction,
  motifMismatch,
  denominationAnomaly,
  yearOutOfRange,
}

class NumismaticEmissionOutlier {
  final NumismaticEmissionOutlierType type;
  final String title;
  final String description;
  final String suggestedFixDescription;
  final String? expectedValue;
  final String? foundValue;
  final String? targetPropertyName;

  const NumismaticEmissionOutlier({
    required this.type,
    required this.title,
    required this.description,
    required this.suggestedFixDescription,
    this.expectedValue,
    this.foundValue,
    this.targetPropertyName,
  });
}

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

      final key = AppTechnicalStrings.numisSubspeciesKey(
        sub.speciesId,
        NumismaticParser.normalizeCurrencyText(canonicalCurrency),
      );
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

      // Deduplicate speciesMagnitudes for this species if multiple exist with same name
      final preExistingSmRows = await (db.select(db.speciesMagnitudesTable)..where((t) => t.speciesId.equals(species.id))).get();
      final seenSmNames = <String, String>{};
      for (final smRow in preExistingSmRows) {
        final normName = smRow.propertyName.trim().toLowerCase();
        if (seenSmNames.containsKey(normName)) {
          await (db.delete(db.speciesMagnitudesTable)..where((t) => t.id.equals(smRow.id))).go();
        } else {
          seenSmNames[normName] = smRow.id;
        }
      }

      // 1. Ensure species has required standard magnitudes registered & correct dataTypes in speciesMagnitudesTable
      await catalogRepo.addSpeciesMagnitude(species.id, AppStrings.nominalValuePropertyName, dataType: AppTechnicalStrings.datatypeRealLower);
      await catalogRepo.addSpeciesMagnitude(species.id, AppStrings.mintagePropertyName, dataType: AppTechnicalStrings.datatypeIntegerLower, unitSymbol: AppStrings.yearUnitSymbol);
      await catalogRepo.addSpeciesMagnitude(species.id, AppStrings.currencyPropertyName, dataType: AppTechnicalStrings.datatypeStringLower);
      await catalogRepo.addSpeciesMagnitude(species.id, AppStrings.materialPropertyName, dataType: AppTechnicalStrings.datatypeStringLower);
      await catalogRepo.addSpeciesMagnitude(species.id, AppStrings.gradePropertyName, dataType: AppTechnicalStrings.datatypeStringLower);
      await catalogRepo.addSpeciesMagnitude(species.id, AppStrings.issuerPropertyName, dataType: AppTechnicalStrings.datatypeStringLower);
      await catalogRepo.addSpeciesMagnitude(species.id, AppStrings.motifPropertyName, dataType: AppTechnicalStrings.datatypeStringLower);

      // Fix any data types and unit symbols in DB for speciesMagnitudes
      final existingSmRows = await (db.select(db.speciesMagnitudesTable)..where((t) => t.speciesId.equals(species.id))).get();
      for (final smRow in existingSmRows) {
        final pName = smRow.propertyName.trim().toLowerCase();
        String? targetDt;
        String? targetUnit = smRow.unitSymbol;

        if (pName == AppStrings.currencyPropertyName.toLowerCase() ||
            pName == AppStrings.materialPropertyName.toLowerCase() ||
            pName == AppStrings.gradePropertyName.toLowerCase() ||
            pName == AppStrings.issuerPropertyName.toLowerCase() ||
            pName == AppStrings.motifPropertyName.toLowerCase() ||
            pName == 'motivo' ||
            pName == AppTechnicalStrings.magPaisLower ||
            pName == AppTechnicalStrings.magPaisWithoutAccentLower ||
            pName == AppTechnicalStrings.magMonedaLower ||
            pName == AppTechnicalStrings.magMetalLower ||
            pName == AppTechnicalStrings.magConservacionWithAccentLower ||
            pName == AppTechnicalStrings.magConservacionWithoutAccentLower) {
          targetDt = AppTechnicalStrings.datatypeStringLower;
          targetUnit = null;
        } else if (pName == AppStrings.mintagePropertyName.toLowerCase() ||
            pName == AppStrings.mintageYearLabel.toLowerCase() ||
            pName == AppTechnicalStrings.magAcunacionWithAccentLower ||
            pName == AppTechnicalStrings.magAcunacionWithoutAccentLower ||
            pName == AppTechnicalStrings.magAnoWithAccentLower ||
            pName == AppTechnicalStrings.magAnoWithoutAccentLower ||
            pName == AppTechnicalStrings.magAnoDeAcunacionLower) {
          targetDt = AppTechnicalStrings.datatypeIntegerLower;
          targetUnit ??= AppStrings.yearUnitSymbol;
        } else if (pName == AppStrings.nominalValuePropertyName.toLowerCase() ||
            pName == AppStrings.magValorNominal.toLowerCase() ||
            pName == AppTechnicalStrings.magValorFacialLower ||
            pName == AppTechnicalStrings.magValorNominalLower) {
          targetDt = AppTechnicalStrings.datatypeRealLower;
          targetUnit = null;
        }

        if (targetDt != null && (smRow.dataType != targetDt || smRow.unitSymbol != targetUnit)) {
          await (db.update(db.speciesMagnitudesTable)..where((t) => t.id.equals(smRow.id))).write(
            SpeciesMagnitudesTableCompanion(
              dataType: Value(targetDt),
              unitSymbol: Value(targetUnit),
            ),
          );
        }
      }

      final Map<String, Subspecies> currencySubspeciesMap = {};

      for (final sub in subspeciesList) {
        final parsedOld = NumismaticParser.parseSubspeciesName(sub.subspeciesName);
        final rawCurr = (parsedOld.currencyName != null && parsedOld.currencyName!.isNotEmpty)
            ? parsedOld.currencyName!
            : sub.subspeciesName;
        final canonicalCurrency = NumismaticParser.resolveCurrencyName(rawCurr);
        final normKey = NumismaticParser.normalizeCurrencyText(canonicalCurrency);

        // Find or create currency subspecies
        Subspecies? targetCurrencySub = currencySubspeciesMap[normKey];
        if (targetCurrencySub == null) {
          final existing = subspeciesList.where(
            (s) => NumismaticParser.areCurrenciesEquivalent(s.subspeciesName, canonicalCurrency),
          ).firstOrNull;

          if (existing != null) {
            targetCurrencySub = existing;
            if (existing.subspeciesName != canonicalCurrency) {
              targetCurrencySub = existing.copyWith(
                subspeciesName: canonicalCurrency,
                notes: NumismaticParser.buildSubspeciesNotes(currencyName: canonicalCurrency),
              );
              await catalogRepo.saveSubspecies(targetCurrencySub);
            }
          } else {
            targetCurrencySub = sub.copyWith(
              subspeciesName: canonicalCurrency,
              notes: NumismaticParser.buildSubspeciesNotes(currencyName: canonicalCurrency),
            );
            await catalogRepo.saveSubspecies(targetCurrencySub);
          }
          currencySubspeciesMap[normKey] = targetCurrencySub;
        }

        // Migrate instances under this sub
        final subInstances = instances.where((e) => e.subspeciesId == sub.id).toList();
        for (final inst in subInstances) {
          final List<InstanceMagnitude> customMags = [];
          final subNotes = sub.notes ?? AppTechnicalStrings.empty;
          final instNotes = inst.notes ?? AppTechnicalStrings.empty;

          // Process existing magnitudes and standardize them
          for (final m in inst.magnitudes) {
            final pName = m.propertyName.trim().toLowerCase();
            if (pName == AppStrings.magDivisa.toLowerCase() ||
                pName == AppStrings.currencyPropertyName.toLowerCase() ||
                pName == AppTechnicalStrings.magDivisaLower ||
                pName == AppTechnicalStrings.magMonedaLower) {
              var currVal = m.stringValue?.trim();
              if (currVal == null || currVal.isEmpty) {
                final notesMatch = RegExp(AppTechnicalStrings.regexMonedaNote).firstMatch(subNotes);
                if (notesMatch != null) {
                  currVal = notesMatch.group(1)?.trim();
                } else if (parsedOld.currencyName != null) {
                  currVal = parsedOld.currencyName;
                } else {
                  currVal = canonicalCurrency;
                }
              }
              final iso = currVal != null && currVal.isNotEmpty
                  ? NumismaticParser.resolveCurrencyIsoCode(currVal)
                  : NumismaticParser.resolveCurrencyIsoCode(canonicalCurrency);

              customMags.add(m.copyWith(
                propertyName: AppStrings.currencyPropertyName,
                dataType: AppTechnicalStrings.datatypeStringLower,
                stringValue: iso,
                unitSymbol: null,
                magnitudeValue: null,
              ));
            } else if (pName == AppStrings.magMaterial.toLowerCase() ||
                pName == AppStrings.materialPropertyName.toLowerCase() ||
                pName == AppTechnicalStrings.magMaterialLower ||
                pName == AppTechnicalStrings.magMetalLower) {
              var matVal = m.stringValue?.trim();
              if (matVal == null || matVal.isEmpty) {
                final matMatch = RegExp(AppTechnicalStrings.regexMaterialNote).firstMatch(subNotes);
                final metalMatch = RegExp(AppTechnicalStrings.regexMetalNote).firstMatch(subNotes);
                if (matMatch != null) {
                  matVal = matMatch.group(1)?.trim();
                } else if (metalMatch != null) {
                  matVal = metalMatch.group(1)?.trim();
                } else if (species.name == AppStrings.banknoteRectangleLabel) {
                  matVal = AppStrings.materialPaper;
                }
              }
              final stdMat = matVal != null && matVal.isNotEmpty
                  ? NumismaticParser.resolveMaterial(matVal)
                  : (species.name == AppStrings.banknoteRectangleLabel ? AppStrings.materialPaper : null);

              customMags.add(m.copyWith(
                propertyName: AppStrings.materialPropertyName,
                dataType: AppTechnicalStrings.datatypeStringLower,
                stringValue: stdMat,
                unitSymbol: null,
                magnitudeValue: null,
              ));
            } else if (pName == AppStrings.magGrado.toLowerCase() ||
                pName == AppStrings.gradePropertyName.toLowerCase() ||
                pName == AppTechnicalStrings.magGradoLower ||
                pName == AppTechnicalStrings.magConservacionWithAccentLower ||
                pName == AppTechnicalStrings.magConservacionWithoutAccentLower) {
              var gradeVal = m.stringValue?.trim();
              if (gradeVal == null || gradeVal.isEmpty) {
                final gradeMatch = RegExp(AppTechnicalStrings.regexGradoNote).firstMatch(instNotes);
                if (gradeMatch != null) {
                  final g = gradeMatch.group(1)?.trim();
                  if (g != null && g != AppStrings.unspecifiedGrade && g.isNotEmpty) {
                    gradeVal = g;
                  }
                }
              }
              final stdGrade = gradeVal != null && gradeVal.isNotEmpty
                  ? NumismaticParser.resolveGrade(gradeVal)
                  : null;

              customMags.add(m.copyWith(
                propertyName: AppStrings.gradePropertyName,
                dataType: AppTechnicalStrings.datatypeStringLower,
                stringValue: stdGrade,
                unitSymbol: null,
                magnitudeValue: null,
              ));
            } else if (pName == AppStrings.magEmisor.toLowerCase() ||
                pName == AppStrings.issuerPropertyName.toLowerCase() ||
                pName == AppTechnicalStrings.magPaisLower ||
                pName == AppTechnicalStrings.magPaisWithoutAccentLower ||
                pName == AppTechnicalStrings.magEmisorLower) {
              var countryVal = m.stringValue?.trim();
              if ((countryVal == null || countryVal.isEmpty) && parsedOld.country != null && parsedOld.country!.isNotEmpty) {
                countryVal = parsedOld.country!.trim();
              }
              customMags.add(m.copyWith(
                propertyName: AppStrings.issuerPropertyName,
                dataType: AppTechnicalStrings.datatypeStringLower,
                stringValue: countryVal,
                unitSymbol: null,
                magnitudeValue: null,
              ));
            } else if (pName == AppStrings.magAcunacion.toLowerCase() ||
                pName == AppStrings.mintagePropertyName.toLowerCase() ||
                pName == AppTechnicalStrings.magAcunacionWithAccentLower ||
                pName == AppTechnicalStrings.magAcunacionWithoutAccentLower ||
                pName == AppTechnicalStrings.magAnoWithAccentLower ||
                pName == AppTechnicalStrings.magAnoWithoutAccentLower ||
                pName == AppTechnicalStrings.magAnoDeAcunacionLower ||
                pName == AppTechnicalStrings.magMintageLower) {
              var numVal = m.magnitudeValue;
              if (numVal == null && m.stringValue != null) {
                numVal = double.tryParse(m.stringValue!);
              }
              if (numVal == null && parsedOld.year != null) {
                numVal = double.tryParse(parsedOld.year!);
              }
              customMags.add(m.copyWith(
                propertyName: AppStrings.mintagePropertyName,
                dataType: AppTechnicalStrings.datatypeIntegerLower,
                magnitudeValue: numVal,
                unitSymbol: AppStrings.yearUnitSymbol,
                stringValue: null,
              ));
            } else if (pName == AppStrings.magValorNominal.toLowerCase() ||
                pName == AppStrings.nominalValuePropertyName.toLowerCase() ||
                pName == AppTechnicalStrings.magValorFacialLower ||
                pName == AppTechnicalStrings.magValorNominalLower) {
              var numVal = m.magnitudeValue;
              if (numVal == null && parsedOld.faceValueNumber != null) {
                numVal = parsedOld.faceValueNumber;
              }
              customMags.add(m.copyWith(
                propertyName: AppStrings.nominalValuePropertyName,
                dataType: AppTechnicalStrings.datatypeRealLower,
                magnitudeValue: numVal,
                unitSymbol: null,
              ));
            } else if (pName == AppStrings.motifPropertyName.toLowerCase() ||
                pName == 'motivo' ||
                pName == 'razón de edición especial' ||
                pName == 'razon de edicion especial') {
              var motifVal = m.stringValue?.trim();
              if (motifVal != null && motifVal.isNotEmpty) {
                customMags.add(m.copyWith(
                  propertyName: AppStrings.motifPropertyName,
                  dataType: AppTechnicalStrings.datatypeStringLower,
                  stringValue: motifVal,
                  unitSymbol: null,
                  magnitudeValue: null,
                ));
              }
            } else if (pName == 'edición especial' || pName == 'edicion especial') {
              // Ignore obsolete special edition magnitude
            } else {
              customMags.add(m);
            }
          }

          // Backfill missing standard magnitudes
          final hasNominal = customMags.any((m) {
            final p = m.propertyName.trim().toLowerCase();
            return p == AppStrings.nominalValuePropertyName.toLowerCase() ||
                p == AppStrings.magValorNominal.toLowerCase() ||
                p == AppTechnicalStrings.magValorFacialLower ||
                p == AppTechnicalStrings.magValorNominalLower;
          });
          if (!hasNominal && parsedOld.faceValueNumber != null) {
            customMags.add(InstanceMagnitude(
              id: const Uuid().v4(),
              instanceId: inst.id,
              propertyName: AppStrings.nominalValuePropertyName,
              dataType: AppTechnicalStrings.datatypeRealLower,
              magnitudeValue: parsedOld.faceValueNumber,
            ));
          }

          final hasMintage = customMags.any((m) {
            final p = m.propertyName.trim().toLowerCase();
            return p == AppStrings.mintagePropertyName.toLowerCase() ||
                p == AppStrings.magAcunacion.toLowerCase() ||
                p == AppTechnicalStrings.magAcunacionWithAccentLower ||
                p == AppTechnicalStrings.magAcunacionWithoutAccentLower ||
                p == AppTechnicalStrings.magAnoWithAccentLower ||
                p == AppTechnicalStrings.magAnoWithoutAccentLower ||
                p == AppTechnicalStrings.magAnoDeAcunacionLower ||
                p == AppTechnicalStrings.magMintageLower;
          });
          if (!hasMintage && parsedOld.year != null && double.tryParse(parsedOld.year!) != null) {
            customMags.add(InstanceMagnitude(
              id: const Uuid().v4(),
              instanceId: inst.id,
              propertyName: AppStrings.mintagePropertyName,
              dataType: AppTechnicalStrings.datatypeIntegerLower,
              magnitudeValue: double.parse(parsedOld.year!),
              unitSymbol: AppStrings.yearUnitSymbol,
            ));
          }

          final hasCurrency = customMags.any((m) {
            final p = m.propertyName.trim().toLowerCase();
            return p == AppStrings.currencyPropertyName.toLowerCase() ||
                p == AppStrings.magDivisa.toLowerCase() ||
                p == AppTechnicalStrings.magDivisaLower ||
                p == AppTechnicalStrings.magMonedaLower;
          });
          if (!hasCurrency) {
            String? currStr;
            final notesMatch = RegExp(AppTechnicalStrings.regexMonedaNote).firstMatch(subNotes);
            if (notesMatch != null) {
              currStr = notesMatch.group(1)?.trim();
            } else if (parsedOld.currencyName != null) {
              currStr = parsedOld.currencyName;
            } else {
              currStr = canonicalCurrency;
            }
            final iso = NumismaticParser.resolveCurrencyIsoCode(currStr ?? canonicalCurrency);
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
            return p == AppStrings.issuerPropertyName.toLowerCase() ||
                p == AppStrings.magEmisor.toLowerCase() ||
                p == AppTechnicalStrings.magPaisLower ||
                p == AppTechnicalStrings.magPaisWithoutAccentLower ||
                p == AppTechnicalStrings.magEmisorLower;
          });
          if (!hasEmisor && parsedOld.country != null && parsedOld.country!.isNotEmpty) {
            customMags.add(InstanceMagnitude(
              id: const Uuid().v4(),
              instanceId: inst.id,
              propertyName: AppStrings.issuerPropertyName,
              dataType: AppTechnicalStrings.datatypeStringLower,
              stringValue: parsedOld.country!.trim(),
            ));
          }

          final hasMaterial = customMags.any((m) {
            final p = m.propertyName.trim().toLowerCase();
            return p == AppStrings.materialPropertyName.toLowerCase() ||
                p == AppStrings.magMaterial.toLowerCase() ||
                p == AppTechnicalStrings.magMaterialLower ||
                p == AppTechnicalStrings.magMetalLower;
          });
          if (!hasMaterial) {
            String? matStr;
            final matMatch = RegExp(AppTechnicalStrings.regexMaterialNote).firstMatch(subNotes);
            final metalMatch = RegExp(AppTechnicalStrings.regexMetalNote).firstMatch(subNotes);
            if (matMatch != null) {
              matStr = matMatch.group(1)?.trim();
            } else if (metalMatch != null) {
              matStr = metalMatch.group(1)?.trim();
            } else if (species.name == AppStrings.banknoteRectangleLabel) {
              matStr = AppStrings.materialPaper;
            }
            if (matStr != null && matStr.isNotEmpty) {
              customMags.add(InstanceMagnitude(
                id: const Uuid().v4(),
                instanceId: inst.id,
                propertyName: AppStrings.materialPropertyName,
                dataType: AppTechnicalStrings.datatypeStringLower,
                stringValue: NumismaticParser.resolveMaterial(matStr),
              ));
            }
          }

          final hasGrade = customMags.any((m) {
            final p = m.propertyName.trim().toLowerCase();
            return p == AppStrings.gradePropertyName.toLowerCase() ||
                p == AppStrings.magGrado.toLowerCase() ||
                p == AppTechnicalStrings.magGradoLower ||
                p == AppTechnicalStrings.magConservacionWithAccentLower ||
                p == AppTechnicalStrings.magConservacionWithoutAccentLower;
          });
          if (!hasGrade) {
            final gradeMatch = RegExp(AppTechnicalStrings.regexGradoNote).firstMatch(instNotes);
            if (gradeMatch != null) {
              final g = gradeMatch.group(1)?.trim();
              if (g != null && g != AppStrings.unspecifiedGrade && g.isNotEmpty) {
                customMags.add(InstanceMagnitude(
                  id: const Uuid().v4(),
                  instanceId: inst.id,
                  propertyName: AppStrings.gradePropertyName,
                  dataType: AppTechnicalStrings.datatypeStringLower,
                  stringValue: NumismaticParser.resolveGrade(g),
                ));
              }
            }
          }

          // Extract special edition / motif from legacy notes if not present in magnitudes, and clean notes
          String? cleanedNotes = inst.notes;
          String? extractedMotifFromNotes;
          if (inst.notes != null && inst.notes!.isNotEmpty) {
            final lowerNotes = inst.notes!.toLowerCase();
            if (lowerNotes.contains('edición especial') || lowerNotes.contains('edicion especial')) {
              final matchWithPrefix = RegExp(r'(?:\[\s*)?Edici(?:ó|o)n\s+especial\s*:\s*([^\]|\n]+)(?:\])?', caseSensitive: false).firstMatch(inst.notes!);
              if (matchWithPrefix != null) {
                final raw = matchWithPrefix.group(1)?.trim();
                if (raw != null && raw.isNotEmpty) {
                  extractedMotifFromNotes = raw;
                }
                cleanedNotes = inst.notes!.replaceAll(matchWithPrefix.group(0)!, '').trim();
                cleanedNotes = cleanedNotes.replaceAll(RegExp(r'^[|\s]+|[|\s]+$'), '').replaceAll(RegExp(r'\s*\|\s*\|\s*'), ' | ').trim();
                if (cleanedNotes.isEmpty) {
                  cleanedNotes = null;
                }
              }
            } else if (lowerNotes.contains('motivo:') || lowerNotes.contains('motivo :')) {
              final matchMotif = RegExp(r'(?:\[\s*)?Motivo\s*:\s*([^\]|\n]+)(?:\])?', caseSensitive: false).firstMatch(inst.notes!);
              if (matchMotif != null) {
                final raw = matchMotif.group(1)?.trim();
                if (raw != null && raw.isNotEmpty) {
                  extractedMotifFromNotes = raw;
                }
                cleanedNotes = inst.notes!.replaceAll(matchMotif.group(0)!, '').trim();
                cleanedNotes = cleanedNotes.replaceAll(RegExp(r'^[|\s]+|[|\s]+$'), '').replaceAll(RegExp(r'\s*\|\s*\|\s*'), ' | ').trim();
                if (cleanedNotes.isEmpty) {
                  cleanedNotes = null;
                }
              }
            }
          }

          // Check for existing motif in magnitudes or extracted from notes
          String? resolvedMotif;
          final existingMotifMag = customMags.where((m) {
            final p = m.propertyName.trim().toLowerCase();
            return (p == AppStrings.motifPropertyName.toLowerCase() ||
                    p == 'motivo' ||
                    p == 'razón de edición especial' ||
                    p == 'razon de edicion especial') &&
                m.stringValue != null &&
                m.stringValue!.trim().isNotEmpty;
          }).firstOrNull;

          if (existingMotifMag != null) {
            resolvedMotif = existingMotifMag.stringValue!.trim();
          } else if (extractedMotifFromNotes != null && extractedMotifFromNotes.isNotEmpty) {
            resolvedMotif = extractedMotifFromNotes;
          }

          final motifIdx = customMags.indexWhere((m) {
            final p = m.propertyName.trim().toLowerCase();
            return p == AppStrings.motifPropertyName.toLowerCase() || p == 'motivo';
          });

          if (motifIdx >= 0) {
            customMags[motifIdx] = customMags[motifIdx].copyWith(
              propertyName: AppStrings.motifPropertyName,
              dataType: AppTechnicalStrings.datatypeStringLower,
              stringValue: (resolvedMotif != null && resolvedMotif.isNotEmpty) ? resolvedMotif : null,
              unitSymbol: null,
            );
          } else {
            customMags.add(InstanceMagnitude(
              id: const Uuid().v4(),
              instanceId: inst.id,
              propertyName: AppStrings.motifPropertyName,
              dataType: AppTechnicalStrings.datatypeStringLower,
              stringValue: (resolvedMotif != null && resolvedMotif.isNotEmpty) ? resolvedMotif : null,
            ));
          }

          // Deduplicate customMags by normalized propertyName (keep best value)
          final Map<String, InstanceMagnitude> deduped = {};
          for (final mag in customMags) {
            final key = mag.propertyName.trim().toLowerCase();
            if (!deduped.containsKey(key)) {
              deduped[key] = mag;
            } else {
              final prev = deduped[key]!;
              final hasVal = (mag.stringValue != null && mag.stringValue!.isNotEmpty) || mag.magnitudeValue != null;
              final prevHasVal = (prev.stringValue != null && prev.stringValue!.isNotEmpty) || prev.magnitudeValue != null;
              if (hasVal || !prevHasVal) {
                deduped[key] = mag;
              }
            }
          }

          final updatedInst = inst.copyWith(
            subspeciesId: targetCurrencySub.id,
            notes: cleanedNotes,
            magnitudes: deduped.values.toList(),
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

  /// Analyzes an instance against historical emission matrix rules and returns detected outliers.
  static List<NumismaticEmissionOutlier> checkEmissionOutliers({
    required WorldEntity instance,
    CatalogItem? species,
  }) {
    if (species != null && !NumismaticParser.isNumismaticSpecies(species)) {
      return const [];
    }

    final attrs = NumismaticParser.extractAttributesFromInstance(instance);
    final country = attrs.country?.trim();
    final yearStr = attrs.year?.trim();
    final year = yearStr != null ? int.tryParse(yearStr) : null;
    final currency = attrs.currencyName?.trim();
    final material = attrs.material?.trim();

    final isBanknote = NumismaticParser.isBanknotePiece(
      species: species,
      instance: instance,
      material: material,
    );

    String? denomStr = attrs.faceValueStr?.trim();
    if (denomStr == null && attrs.faceValueNumber != null) {
      final numVal = attrs.faceValueNumber!;
      denomStr = (numVal == numVal.toInt()) ? numVal.toInt().toString() : numVal.toString();
    }

    final outliers = <NumismaticEmissionOutlier>[];

    if (country == null || country.isEmpty || country == AppStrings.otherSpecifyOption) {
      return outliers;
    }

    // 1. Year Outlier / Chronological range check
    if (year != null) {
      final currentYear = DateTime.now().year;
      if (year < 1500 || year > currentYear + 1) {
        outliers.add(NumismaticEmissionOutlier(
          type: NumismaticEmissionOutlierType.yearOutOfRange,
          title: AppStrings.numismaticEmissionOutlierCardTitle,
          description: AppStrings.numismaticYearOutOfRangeDesc(year, country),
          suggestedFixDescription: AppStrings.fixCorrectYearAction,
          foundValue: year.toString(),
          targetPropertyName: AppStrings.mintagePropertyName,
        ));
      }
    }

    // 2. Emission matrix matching
    if (year != null && year >= 1500 && year <= DateTime.now().year + 1) {
      final allRules = NumismaticMatrix.findRules(country, year, isBanknote: isBanknote);
      if (allRules.isNotEmpty) {
        // A. Currency anachronism check
        if (currency != null && currency.isNotEmpty) {
          final iso = NumismaticParser.resolveCurrencyIsoCode(currency);
          final allValidCurrencies = allRules.expand((r) => r.validCurrencies).toSet();
          if (!allValidCurrencies.contains(iso)) {
            final expectedIso = allRules.first.defaultCurrency ?? allRules.first.validCurrencies.first;
            outliers.add(NumismaticEmissionOutlier(
              type: NumismaticEmissionOutlierType.currencyAnachronism,
              title: AppStrings.numismaticEmissionOutlierCardTitle,
              description: AppStrings.numismaticCurrencyAnachronismDesc(iso, expectedIso, year, country),
              suggestedFixDescription: AppStrings.fixCorrectCurrencyAction,
              expectedValue: expectedIso,
              foundValue: iso,
              targetPropertyName: AppStrings.currencyPropertyName,
            ));
          }
        }

        final rule = NumismaticMatrix.findRule(
          country,
          year,
          currencyCode: currency,
          denomination: denomStr,
          isBanknote: isBanknote,
        ) ?? allRules.first;

        // B. Material contradiction check
        if (denomStr != null && denomStr.isNotEmpty && material != null && material.isNotEmpty) {
          final validMaterials = NumismaticMatrix.getValidMaterials(
            country: country,
            year: year,
            currencyCode: currency,
            denomination: denomStr,
            isBanknote: isBanknote,
          );
          if (validMaterials.isNotEmpty) {
            final resolvedFoundMat = NumismaticParser.resolveMaterial(material);
            final isValid = validMaterials.any((m) {
              final cleanM = m.trim().toLowerCase();
              return cleanM == resolvedFoundMat.toLowerCase() ||
                  cleanM == material.trim().toLowerCase();
            });
            if (!isValid) {
              final expectedMat = validMaterials.first;
              outliers.add(NumismaticEmissionOutlier(
                type: NumismaticEmissionOutlierType.materialContradiction,
                title: AppStrings.numismaticEmissionOutlierCardTitle,
                description: AppStrings.numismaticMaterialContradictionDesc(material, expectedMat, denomStr),
                suggestedFixDescription: AppStrings.fixCorrectMaterialAction,
                expectedValue: expectedMat,
                foundValue: material,
                targetPropertyName: AppStrings.materialPropertyName,
              ));
            }
          }
        }

        // C. Commemorative Motif check
        if (denomStr != null && denomStr.isNotEmpty) {
          final motifs = NumismaticMatrix.getCommemorativeMotifs(
            country: country,
            year: year,
            currencyCode: currency,
            denomination: denomStr,
            isBanknote: isBanknote,
          );
          final isStrictlyCommemorative = rule.isCommemorativeDenomination(denomStr);
          final effectiveMotif = attrs.motif;

          bool isMotifMismatch = false;
          if (effectiveMotif != null && effectiveMotif.trim().isNotEmpty) {
            if (motifs.isNotEmpty) {
              final cleanFound = effectiveMotif.trim().toLowerCase();
              final matchesAny = motifs.any((m) {
                final cleanM = m.trim().toLowerCase();
                return cleanM == cleanFound || cleanM.contains(cleanFound) || cleanFound.contains(cleanM);
              });
              if (!matchesAny) {
                isMotifMismatch = true;
              }
            } else {
              isMotifMismatch = true;
            }
          } else if (isStrictlyCommemorative && motifs.isNotEmpty) {
            isMotifMismatch = true;
          }

          if (isMotifMismatch) {
            final expectedMotif = motifs.isNotEmpty ? motifs.first : AppStrings.motifPropertyName;
            outliers.add(NumismaticEmissionOutlier(
              type: NumismaticEmissionOutlierType.motifMismatch,
              title: AppStrings.numismaticEmissionOutlierCardTitle,
              description: AppStrings.numismaticMotifMismatchDesc(denomStr, expectedMotif),
              suggestedFixDescription: AppStrings.fixSetMotifAction,
              expectedValue: expectedMotif,
              foundValue: effectiveMotif,
              targetPropertyName: AppStrings.motifPropertyName,
            ));
          }
        }

        // D. Denomination anomaly check
        if (denomStr != null && denomStr.isNotEmpty) {
          final matchesDenom = allRules.any((r) => r.hasDenomination(denomStr!));
          if (!matchesDenom) {
            outliers.add(NumismaticEmissionOutlier(
              type: NumismaticEmissionOutlierType.denominationAnomaly,
              title: AppStrings.numismaticEmissionOutlierCardTitle,
              description: AppStrings.numismaticDenominationAnomalyDesc(denomStr, country, year),
              suggestedFixDescription: AppStrings.fixPickDenominationAction,
              expectedValue: rule.denominations.first,
              foundValue: denomStr,
              targetPropertyName: AppStrings.nominalValuePropertyName,
            ));
          }
        }
      }
    }

    return outliers;
  }

  /// Repairs a detected emission outlier on an instance entity and updates repository.
  static Future<WorldEntity> repairEmissionOutlier({
    required IEntityRepository entityRepo,
    required CatalogRepository catalogRepo,
    required WorldEntity instance,
    required NumismaticEmissionOutlier outlier,
    String? customValue,
  }) async {
    final List<InstanceMagnitude> mags = List.from(instance.magnitudes);

    void setOrUpdateMagnitude({
      required String propertyName,
      required String dataType,
      String? stringValue,
      double? magnitudeValue,
      String? unitSymbol,
    }) {
      final idx = mags.indexWhere((m) => m.propertyName.trim().toLowerCase() == propertyName.trim().toLowerCase());
      if (idx >= 0) {
        mags[idx] = mags[idx].copyWith(
          dataType: dataType,
          stringValue: stringValue,
          magnitudeValue: magnitudeValue ?? 0.0,
          unitSymbol: unitSymbol,
        );
      } else {
        mags.add(InstanceMagnitude(
          id: const Uuid().v4(),
          instanceId: instance.id,
          propertyName: propertyName,
          dataType: dataType,
          stringValue: stringValue,
          magnitudeValue: magnitudeValue ?? 0.0,
          unitSymbol: unitSymbol,
        ));
      }
    }

    switch (outlier.type) {
      case NumismaticEmissionOutlierType.currencyAnachronism:
        final targetCurr = customValue ?? outlier.expectedValue;
        if (targetCurr != null && targetCurr.isNotEmpty) {
          setOrUpdateMagnitude(
            propertyName: AppStrings.currencyPropertyName,
            dataType: AppTechnicalStrings.datatypeStringLower,
            stringValue: targetCurr,
          );
        }
        break;

      case NumismaticEmissionOutlierType.materialContradiction:
        final targetMat = customValue ?? outlier.expectedValue;
        if (targetMat != null && targetMat.isNotEmpty) {
          setOrUpdateMagnitude(
            propertyName: AppStrings.materialPropertyName,
            dataType: AppTechnicalStrings.datatypeStringLower,
            stringValue: targetMat,
          );
        }
        break;

      case NumismaticEmissionOutlierType.motifMismatch:
        final targetMotif = customValue ?? outlier.expectedValue ?? AppStrings.motifPropertyName;
        setOrUpdateMagnitude(
          propertyName: AppStrings.motifPropertyName,
          dataType: AppTechnicalStrings.datatypeStringLower,
          stringValue: targetMotif,
        );
        break;

      case NumismaticEmissionOutlierType.denominationAnomaly:
        final targetDenomStr = customValue ?? outlier.expectedValue;
        if (targetDenomStr != null) {
          final parsedNum = double.tryParse(targetDenomStr);
          if (parsedNum != null) {
            setOrUpdateMagnitude(
              propertyName: AppStrings.nominalValuePropertyName,
              dataType: AppTechnicalStrings.datatypeRealLower,
              magnitudeValue: parsedNum,
            );
          }
        }
        break;

      case NumismaticEmissionOutlierType.yearOutOfRange:
        final targetYearStr = customValue ?? outlier.expectedValue;
        if (targetYearStr != null) {
          final parsedYear = double.tryParse(targetYearStr);
          if (parsedYear != null) {
            setOrUpdateMagnitude(
              propertyName: AppStrings.mintagePropertyName,
              dataType: AppTechnicalStrings.datatypeIntegerLower,
              magnitudeValue: parsedYear,
              unitSymbol: AppStrings.yearUnitSymbol,
            );
          }
        }
        break;
    }

    final updatedEntity = instance.copyWith(magnitudes: mags);
    await entityRepo.saveEntity(updatedEntity);

    if (instance.subspeciesId != null) {
      final sub = await catalogRepo.getSubspeciesById(instance.subspeciesId!);
      if (sub != null) {
        await repairAttachmentFileNames(
          catalogRepo: catalogRepo,
          entityRepo: entityRepo,
          subspecies: sub,
          instance: updatedEntity,
        );
      }
    }

    return updatedEntity;
  }
}
