import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import 'package:platinum_world_management_system/src/core/constants/app_technical_strings.dart';
import 'package:platinum_world_management_system/src/core/database/app_database.dart';
import '../../../../entities/domain/instance_magnitude.dart';
import '../../../../entities/domain/i_entity_repository.dart';
import '../../../../entities/infrastructure/entity_repository.dart';
import '../../../infrastructure/catalog_repository.dart';
import '../../subspecies.dart';
import '../numismatic_parser.dart';
import 'numismatic_standardization_service.dart';

/// Service dedicated to bulk database migrations, repairs, and deduplication of numismatic datasets.
class NumismaticMigrationService {
  NumismaticMigrationService._();

  /// Merges duplicate subspecies into a canonical subspecies. Reassigns entities and deletes duplicates.
  static Future<void> mergeDuplicateSubspecies({
    required CatalogRepository catalogRepo,
    required IEntityRepository entityRepo,
    required Subspecies canonicalSubspecies,
    required List<Subspecies> duplicateSubspeciesList,
  }) async {
    final allEntities = await entityRepo.getAllEntities();

    // Standardize the canonical subspecies name to canonical currency name
    final parsed = NumismaticParser.parseSubspeciesName(canonicalSubspecies.subspeciesName);
    final rawCurr = (parsed.currencyName != null && parsed.currencyName!.isNotEmpty)
        ? parsed.currencyName!
        : canonicalSubspecies.subspeciesName;
    final canonicalCurrency = NumismaticParser.resolveCurrencyName(rawCurr);

    var targetCanonical = canonicalSubspecies;
    if (canonicalSubspecies.subspeciesName != canonicalCurrency) {
      targetCanonical = canonicalSubspecies.copyWith(
        subspeciesName: canonicalCurrency,
        notes: NumismaticParser.buildSubspeciesNotes(currencyName: canonicalCurrency),
      );
      await catalogRepo.saveSubspecies(targetCanonical);
    }

    for (final dup in duplicateSubspeciesList) {
      if (dup.id == targetCanonical.id) continue;

      // Reassign entities belonging to dup
      final entitiesToMove = allEntities.where((e) => e.subspeciesId == dup.id);
      for (final entity in entitiesToMove) {
        final updated = entity.copyWith(subspeciesId: targetCanonical.id);
        await entityRepo.saveEntity(updated);
      }

      // Delete duplicate subspecies
      await catalogRepo.deleteSubspecies(dup.id);
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
            pName == AppTechnicalStrings.magMotivoLower ||
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
                pName == AppTechnicalStrings.magMotivoLower ||
                pName == AppTechnicalStrings.magRazonEdicionEspecialLower ||
                pName == AppTechnicalStrings.magRazonEdicionEspecialWithoutAccentLower) {
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
            } else if (pName == AppTechnicalStrings.magEdicionEspecialLower || pName == AppTechnicalStrings.magEdicionEspecialWithoutAccentLower) {
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
            if (lowerNotes.contains(AppTechnicalStrings.magEdicionEspecialLower) || lowerNotes.contains(AppTechnicalStrings.magEdicionEspecialWithoutAccentLower)) {
              final matchWithPrefix = RegExp(AppTechnicalStrings.regexEdicionEspecialNote, caseSensitive: false).firstMatch(inst.notes!);
              if (matchWithPrefix != null) {
                final raw = matchWithPrefix.group(1)?.trim();
                if (raw != null && raw.isNotEmpty) {
                  extractedMotifFromNotes = raw;
                }
                cleanedNotes = inst.notes!.replaceAll(matchWithPrefix.group(0)!, AppTechnicalStrings.empty).trim();
                cleanedNotes = cleanedNotes.replaceAll(RegExp(AppTechnicalStrings.regexLeadingTrailingPipesAndSpaces), AppTechnicalStrings.empty).replaceAll(RegExp(AppTechnicalStrings.regexConsecutivePipes), AppTechnicalStrings.pipeWithSpaces).trim();
                if (cleanedNotes.isEmpty) {
                  cleanedNotes = null;
                }
              }
            } else if (lowerNotes.contains(AppTechnicalStrings.prefixMotivoColon) || lowerNotes.contains(AppTechnicalStrings.prefixMotivoColonWithSpace)) {
              final matchMotif = RegExp(AppTechnicalStrings.regexMotivoNote, caseSensitive: false).firstMatch(inst.notes!);
              if (matchMotif != null) {
                final raw = matchMotif.group(1)?.trim();
                if (raw != null && raw.isNotEmpty) {
                  extractedMotifFromNotes = raw;
                }
                cleanedNotes = inst.notes!.replaceAll(matchMotif.group(0)!, AppTechnicalStrings.empty).trim();
                cleanedNotes = cleanedNotes.replaceAll(RegExp(AppTechnicalStrings.regexLeadingTrailingPipesAndSpaces), AppTechnicalStrings.empty).replaceAll(RegExp(AppTechnicalStrings.regexConsecutivePipes), AppTechnicalStrings.pipeWithSpaces).trim();
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
                    p == AppTechnicalStrings.magMotivoLower ||
                    p == AppTechnicalStrings.magRazonEdicionEspecialLower ||
                    p == AppTechnicalStrings.magRazonEdicionEspecialWithoutAccentLower) &&
                m.stringValue != null &&
                m.stringValue!.trim().isNotEmpty;
          }).firstOrNull;

          if (existingMotifMag != null) {
            resolvedMotif = existingMotifMag.stringValue!.trim();
          } else if (extractedMotifFromNotes != null && extractedMotifFromNotes.isNotEmpty) {
            resolvedMotif = extractedMotifFromNotes;
          }

          if (resolvedMotif != null && resolvedMotif.isNotEmpty) {
            final norm = resolvedMotif.trim().toLowerCase();
            if (norm.contains(AppTechnicalStrings.cambioDeRegimenLower) ||
                norm.contains(AppTechnicalStrings.cambioDeRegimenWithoutAccentLower) ||
                norm == AppTechnicalStrings.emisionDeCambioDeRegimenLower ||
                norm == AppTechnicalStrings.emisionDeCambioDeRegimenWithoutAccentLower) {
              final emisorMag = customMags.where((m) => m.propertyName == AppStrings.issuerPropertyName).firstOrNull?.stringValue;
              final yearMag = customMags.where((m) => m.propertyName == AppStrings.mintagePropertyName).firstOrNull?.magnitudeValue?.toInt();
              final denomMag = customMags.where((m) => m.propertyName == AppStrings.nominalValuePropertyName).firstOrNull?.magnitudeValue;
              if (emisorMag != null && (emisorMag.toLowerCase().contains(AppTechnicalStrings.mexicoLower) || emisorMag.toLowerCase().contains(AppTechnicalStrings.mexicoWithoutAccentLower)) && yearMag != null && yearMag >= 1992 && yearMag <= 1995) {
                if (denomMag != null && (denomMag - 10).abs() < 0.01) {
                  resolvedMotif = AppTechnicalStrings.motifNuevoPesoPiedraDelSolPlata;
                } else if (denomMag != null && (denomMag - 20).abs() < 0.01) {
                  resolvedMotif = AppTechnicalStrings.motifNuevoPesoHidalgoPlata;
                } else if (denomMag != null && (denomMag - 50).abs() < 0.01) {
                  resolvedMotif = AppTechnicalStrings.motifNuevoPesoNinosHeroesPlata;
                } else {
                  resolvedMotif = AppTechnicalStrings.motifNuevoPeso;
                }
              }
            }
          }

          final motifIdx = customMags.indexWhere((m) {
            final p = m.propertyName.trim().toLowerCase();
            return p == AppStrings.motifPropertyName.toLowerCase() || p == AppTechnicalStrings.magMotivoLower;
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

          await NumismaticStandardizationService.repairAttachmentFileNames(
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
      final dupGroups = NumismaticStandardizationService.findDuplicateSubspeciesGroups(refreshedSubs);
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
