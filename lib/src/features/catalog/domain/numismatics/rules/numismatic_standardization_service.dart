import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import 'package:platinum_world_management_system/src/core/constants/app_technical_strings.dart';
import '../../../../entities/domain/instance_magnitude.dart';
import '../../../../entities/domain/world_entity.dart';
import '../../../../entities/domain/i_entity_repository.dart';
import '../../../infrastructure/catalog_repository.dart';
import '../../subspecies.dart';
import '../numismatic_parser.dart';
import 'numismatic_outlier_detector.dart';

/// Service dedicated to entity, magnitude, and attachment standardization and live repair.
class NumismaticStandardizationService {
  NumismaticStandardizationService._();

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

    // Check if other instances use this subspecies with a different currency
    final allEntities = await entityRepo.getAllEntities();
    final siblingInstances = allEntities.where((e) => e.subspeciesId == subspecies.id && e.id != instance.id).toList();

    Subspecies effectiveSub;
    if (siblingInstances.isEmpty) {
      // Safe to update the subspecies directly
      final canonicalNotes = NumismaticParser.buildSubspeciesNotes(
        currencyName: canonicalCurrency,
      );
      effectiveSub = subspecies.copyWith(
        subspeciesName: canonicalCurrency,
        notes: canonicalNotes.isNotEmpty ? canonicalNotes : subspecies.notes,
      );
      await catalogRepo.saveSubspecies(effectiveSub);
    } else {
      // Sibling instances exist; do not destroy their subspecies. Find or create matching currency subspecies for this instance.
      final speciesSubs = await catalogRepo.getSubspeciesForSpecies(subspecies.speciesId);
      var targetSub = speciesSubs.where((s) => NumismaticParser.areCurrenciesEquivalent(s.subspeciesName, canonicalCurrency)).firstOrNull;
      if (targetSub == null) {
        targetSub = Subspecies(
          id: const Uuid().v4(),
          speciesId: subspecies.speciesId,
          subspeciesName: canonicalCurrency,
          notes: NumismaticParser.buildSubspeciesNotes(currencyName: canonicalCurrency),
          createdAt: DateTime.now(),
        );
        await catalogRepo.saveSubspecies(targetSub);
      }
      effectiveSub = targetSub;
    }

    // Standardize instance magnitudes ('Divisa', 'Grado', 'Material', 'Emisor') if present
    final List<InstanceMagnitude> updatedMags = instance.magnitudes.map((m) {
      final pName = m.propertyName.trim().toLowerCase();
      if (pName == AppStrings.magDivisa.toLowerCase() ||
          pName == AppStrings.currencyPropertyName.toLowerCase() ||
          pName == AppTechnicalStrings.magDivisaLower ||
          pName == AppTechnicalStrings.magMonedaLower) {
        final iso = NumismaticParser.resolveCurrencyIsoCode(m.stringValue ?? canonicalCurrency);
        return m.copyWith(
          propertyName: AppStrings.currencyPropertyName,
          dataType: AppTechnicalStrings.datatypeStringLower,
          stringValue: iso,
          magnitudeValue: null,
          unitSymbol: null,
        );
      }
      if (pName == AppStrings.magGrado.toLowerCase() ||
          pName == AppStrings.gradePropertyName.toLowerCase() ||
          pName == AppTechnicalStrings.magGradoLower ||
          pName == AppTechnicalStrings.magConservacionWithAccentLower ||
          pName == AppTechnicalStrings.magConservacionWithoutAccentLower) {
        return m.copyWith(
          propertyName: AppStrings.gradePropertyName,
          dataType: AppTechnicalStrings.datatypeStringLower,
          stringValue: m.stringValue != null ? NumismaticParser.resolveGrade(m.stringValue!) : null,
          magnitudeValue: null,
          unitSymbol: null,
        );
      }
      if (pName == AppStrings.magMaterial.toLowerCase() ||
          pName == AppStrings.materialPropertyName.toLowerCase() ||
          pName == AppTechnicalStrings.magMaterialLower ||
          pName == AppTechnicalStrings.magMetalLower) {
        return m.copyWith(
          propertyName: AppStrings.materialPropertyName,
          dataType: AppTechnicalStrings.datatypeStringLower,
          stringValue: m.stringValue != null ? NumismaticParser.resolveMaterial(m.stringValue!) : null,
          magnitudeValue: null,
          unitSymbol: null,
        );
      }
      if (pName == AppStrings.magEmisor.toLowerCase() ||
          pName == AppStrings.issuerPropertyName.toLowerCase() ||
          pName == AppTechnicalStrings.magPaisLower ||
          pName == AppTechnicalStrings.magPaisWithoutAccentLower ||
          pName == AppTechnicalStrings.magEmisorLower) {
        return m.copyWith(
          propertyName: AppStrings.issuerPropertyName,
          dataType: AppTechnicalStrings.datatypeStringLower,
          unitSymbol: null,
        );
      }
      if (pName == AppStrings.motifPropertyName.toLowerCase() ||
          pName == AppTechnicalStrings.magMotivoLower) {
        return m.copyWith(
          propertyName: AppStrings.motifPropertyName,
          dataType: AppTechnicalStrings.datatypeStringLower,
          stringValue: m.stringValue?.trim(),
          magnitudeValue: null,
          unitSymbol: null,
        );
      }
      return m;
    }).toList();

    // Backfill Emisor from legacy subspecies name if missing on instance
    final hasEmisor = updatedMags.any((m) {
      final pName = m.propertyName.trim().toLowerCase();
      return pName == AppStrings.magEmisor.toLowerCase() ||
          pName == AppStrings.issuerPropertyName.toLowerCase() ||
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

    final updatedInstance = instance.copyWith(
      subspeciesId: effectiveSub.id,
      magnitudes: updatedMags,
    );
    await entityRepo.saveEntity(updatedInstance);

    // Standardize attachment file names using instance derived title
    await repairAttachmentFileNames(
      catalogRepo: catalogRepo,
      entityRepo: entityRepo,
      subspecies: effectiveSub,
      instance: updatedInstance,
    );

    return effectiveSub;
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
    for (int i = 0; i < attachments.length; i++) {
      final att = attachments[i];
      final lowerName = att.fileName.toLowerCase();
      String side;
      if (lowerName.contains(AppTechnicalStrings.anversoParensLower) || lowerName.contains(AppTechnicalStrings.anversoLower)) {
        side = AppTechnicalStrings.anversoLower;
      } else if (lowerName.contains(AppTechnicalStrings.reversoParensLower) || lowerName.contains(AppTechnicalStrings.reversoLower)) {
        side = AppTechnicalStrings.reversoLower;
      } else if (lowerName.contains(AppTechnicalStrings.cantoLower) || lowerName.contains(AppTechnicalStrings.edgeLower)) {
        side = AppTechnicalStrings.cantoLower;
      } else if (lowerName.contains(AppTechnicalStrings.certificadoLower) || lowerName.contains(AppTechnicalStrings.certLower)) {
        side = AppTechnicalStrings.certificadoLower;
      } else if (lowerName.contains(AppTechnicalStrings.slabLower) || lowerName.contains(AppTechnicalStrings.estucheLower)) {
        side = AppTechnicalStrings.estucheLower;
      } else {
        side = i == 0 ? AppTechnicalStrings.anversoLower : (i == 1 ? AppTechnicalStrings.reversoLower : AppTechnicalStrings.adjuntoIndex(i + 1));
      }

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
          magnitudeValue: magnitudeValue,
          unitSymbol: unitSymbol,
        );
      } else {
        mags.add(InstanceMagnitude(
          id: const Uuid().v4(),
          instanceId: instance.id,
          propertyName: propertyName,
          dataType: dataType,
          stringValue: stringValue,
          magnitudeValue: magnitudeValue,
          unitSymbol: unitSymbol,
        ));
      }
    }

    String? targetNewSubspeciesId = instance.subspeciesId;

    switch (outlier.type) {
      case NumismaticEmissionOutlierType.currencyAnachronism:
        final targetCurr = customValue ?? outlier.expectedValue;
        if (targetCurr != null && targetCurr.isNotEmpty) {
          final targetIso = NumismaticParser.resolveCurrencyIsoCode(targetCurr);
          setOrUpdateMagnitude(
            propertyName: AppStrings.currencyPropertyName,
            dataType: AppTechnicalStrings.datatypeStringLower,
            stringValue: targetIso,
          );

          // Sincronizar subespecie a la nueva divisa
          final canonicalCurrName = NumismaticParser.resolveCurrencyName(targetCurr);
          final speciesSubs = await catalogRepo.getSubspeciesForSpecies(instance.speciesId);
          var matchingSub = speciesSubs.where((s) => NumismaticParser.areCurrenciesEquivalent(s.subspeciesName, canonicalCurrName)).firstOrNull;
          if (matchingSub == null) {
            matchingSub = Subspecies(
              id: const Uuid().v4(),
              speciesId: instance.speciesId,
              subspeciesName: canonicalCurrName,
              notes: NumismaticParser.buildSubspeciesNotes(currencyName: canonicalCurrName),
              createdAt: DateTime.now(),
            );
            await catalogRepo.saveSubspecies(matchingSub);
          }
          targetNewSubspeciesId = matchingSub.id;
        }
        break;

      case NumismaticEmissionOutlierType.materialContradiction:
        final targetMat = customValue ?? outlier.expectedValue;
        if (targetMat != null && targetMat.isNotEmpty) {
          final stdMat = NumismaticParser.resolveMaterial(targetMat);
          setOrUpdateMagnitude(
            propertyName: AppStrings.materialPropertyName,
            dataType: AppTechnicalStrings.datatypeStringLower,
            stringValue: stdMat,
          );
        }
        break;

      case NumismaticEmissionOutlierType.motifMismatch:
        final targetMotif = customValue ?? outlier.expectedValue;
        if (targetMotif == null ||
            targetMotif.trim().isEmpty ||
            targetMotif == AppTechnicalStrings.none ||
            targetMotif == AppStrings.standardCirculationToken) {
          mags.removeWhere((m) =>
              m.propertyName.trim().toLowerCase() == AppStrings.motifPropertyName.toLowerCase() ||
              m.propertyName.trim().toLowerCase() == AppTechnicalStrings.magMotivoLower);
        } else {
          setOrUpdateMagnitude(
            propertyName: AppStrings.motifPropertyName,
            dataType: AppTechnicalStrings.datatypeStringLower,
            stringValue: targetMotif.trim(),
          );
        }
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

    final updatedEntity = instance.copyWith(
      subspeciesId: targetNewSubspeciesId,
      magnitudes: mags,
    );
    await entityRepo.saveEntity(updatedEntity);

    if (updatedEntity.subspeciesId != null) {
      final sub = await catalogRepo.getSubspeciesById(updatedEntity.subspeciesId!);
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
