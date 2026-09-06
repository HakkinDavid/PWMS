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
