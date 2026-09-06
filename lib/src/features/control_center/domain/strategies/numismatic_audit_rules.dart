import 'dart:io';
import 'package:flutter/material.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import 'package:platinum_world_management_system/src/core/constants/app_technical_strings.dart';
import 'package:platinum_world_management_system/src/core/providers/providers.dart';
import 'package:platinum_world_management_system/src/core/widgets/app_toast.dart';
import 'package:platinum_world_management_system/src/core/widgets/app_wheel_picker.dart';
import 'package:uuid/uuid.dart';
import '../../../catalog/domain/numismatic_data_helper.dart';
import '../../../entities/domain/attachment.dart';
import '../../../entities/domain/instance_magnitude.dart';
import '../../../entities/infrastructure/entity_repository.dart';
import '../audit_rule_strategy.dart';
import 'audit_rule_helper.dart';

/// Strategy 1: Subespecies Numismáticas Duplicadas
class NumismaticDuplicateSubspeciesStrategy implements IAuditRuleStrategy {
  const NumismaticDuplicateSubspeciesStrategy();

  @override
  AuditCardType get cardType => AuditCardType.numismaticDuplicateSubspecies;

  @override
  String get ruleId => AppTechnicalStrings.ruleNumismaticDuplicateSubspecies;

  @override
  AuditCategory get category => AuditCategory.integrity;

  @override
  Future<List<AuditCardData>> evaluate(AuditEvaluationContext context) async {
    final duplicateSubGroups = NumismaticDataHelper.findDuplicateSubspeciesGroups(context.allSubspecies);
    final cards = <AuditCardData>[];

    for (final entry in duplicateSubGroups.entries) {
      final canonicalSub = entry.value.first;
      final parentSpecies = context.speciesById[canonicalSub.speciesId];
      if (parentSpecies != null && NumismaticDataHelper.isNumismaticSpecies(parentSpecies)) {
        final dupCount = entry.value.length;
        cards.add(AuditRuleHelper.forSubspecies(
          id: AppTechnicalStrings.prefixNumisDup + canonicalSub.id,
          type: AuditCardType.numismaticDuplicateSubspecies,
          title: AppStrings.numismaticDuplicateSubspeciesCardTitle,
          subtitle: AppStrings.numismaticDuplicateSubspeciesSubtitle(
            canonicalSub.subspeciesName,
            dupCount,
            parentSpecies.name,
          ),
          question: AppStrings.numismaticDuplicateSubspeciesQuestion(
            dupCount,
            canonicalSub.subspeciesName,
          ),
          icon: Icons.filter_none,
          themeColor: Colors.deepOrange,
          subspecies: canonicalSub,
          species: parentSpecies,
          confirmLabel: AppStrings.confirmKeepSeparateAction,
          fixLabel: AppStrings.fixMergeSubspeciesAction,
          confirmToastMessage: AppStrings.duplicateSubspeciesKeptWithoutChanges,
          onFix: (ctx, ref) async {
            final confirm = await AuditRuleHelper.showConfirmationDialog(
              ctx,
              title: AppStrings.mergeDuplicateSubspeciesAction,
              content: AppStrings.mergeDuplicateSubspeciesPrompt(
                dupCount,
                canonicalSub.subspeciesName,
              ),
              confirmLabel: AppStrings.mergeAndReassignAction,
            );

            if (confirm) {
              await NumismaticDataHelper.mergeDuplicateSubspecies(
                catalogRepo: ref.read(catalogRepositoryProvider),
                entityRepo: ref.read(entityRepositoryProvider),
                canonicalSubspecies: canonicalSub,
                duplicateSubspeciesList: entry.value,
              );
              if (ctx.mounted) {
                AppToast.showSuccess(ctx, AppStrings.duplicateSubspeciesMergedSuccess);
              }
              return true;
            }
            return false;
          },
        ));
      }
    }
    return cards;
  }
}

/// Strategy 2: Incongruencias entre Subespecie e Instancia Numismática
class NumismaticSubspeciesIncongruityStrategy implements IAuditRuleStrategy {
  const NumismaticSubspeciesIncongruityStrategy();

  @override
  AuditCardType get cardType => AuditCardType.numismaticSubspeciesIncongruity;

  @override
  String get ruleId => AppTechnicalStrings.ruleNumismaticSubspeciesIncongruity;

  @override
  AuditCategory get category => AuditCategory.integrity;

  @override
  Future<List<AuditCardData>> evaluate(AuditEvaluationContext context) async {
    final cards = <AuditCardData>[];

    for (final entity in context.allEntities) {
      final species = context.speciesById[entity.speciesId];
      if (species != null && NumismaticDataHelper.isNumismaticSpecies(species) && entity.subspeciesId != null) {
        final sub = context.subspeciesById[entity.subspeciesId];
        if (sub != null) {
          final displayName = AuditRuleHelper.getEntityDisplayName(context, entity);

          final issueMsg = NumismaticDataHelper.checkInstanceSubspeciesCongruence(
            subspecies: sub,
            instance: entity,
          );

          if (issueMsg != null) {
            cards.add(AuditRuleHelper.forEntity(
              id: AppTechnicalStrings.prefixNumisInc + entity.id,
              type: AuditCardType.numismaticSubspeciesIncongruity,
              title: AppStrings.numismaticIncongruityTitle,
              subtitle: AppStrings.numismaticSubspeciesIncongruitySubtitle(
                displayName,
                sub.subspeciesName,
              ),
              question: AppStrings.numismaticSubspeciesIncongruityQuestion(issueMsg),
              icon: Icons.currency_exchange,
              themeColor: Colors.purple,
              entity: entity,
              subspecies: sub,
              species: species,
              confirmLabel: AppStrings.confirmKeepDataAction,
              fixLabel: AppStrings.fixUpdateSubspeciesAction,
              confirmToastMessage: AppStrings.incongruitySkipped,
              onFix: (ctx, ref) async {
                final action = await showDialog<String>(
                  context: ctx,
                  builder: (dialogCtx) => AlertDialog(
                    title: const Text(AppStrings.correctNumismaticIncongruityTitle),
                    content: Text(AppStrings.syncInfoPrompt(displayName, issueMsg)),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(dialogCtx, AppTechnicalStrings.actionCancel),
                        child: const Text(AppStrings.cancel),
                      ),
                      OutlinedButton(
                        onPressed: () => Navigator.pop(dialogCtx, AppTechnicalStrings.actionSubspecies),
                        child: const Text(AppStrings.updateSubspeciesFromInstanceAction),
                      ),
                    ],
                  ),
                );

                if (action == AppTechnicalStrings.actionSubspecies) {
                  final freshEntity = await ref.read(entityRepositoryProvider).getEntityById(entity.id) ?? entity;
                  final freshSub = await ref.read(catalogRepositoryProvider).getSubspeciesById(sub.id) ?? sub;
                  final updatedSub = await NumismaticDataHelper.repairSubspeciesFromInstance(
                    catalogRepo: ref.read(catalogRepositoryProvider),
                    entityRepo: ref.read(entityRepositoryProvider),
                    subspecies: freshSub,
                    instance: freshEntity,
                  );
                  await NumismaticDataHelper.repairAttachmentFileNames(
                    catalogRepo: ref.read(catalogRepositoryProvider),
                    entityRepo: ref.read(entityRepositoryProvider),
                    subspecies: updatedSub,
                    instance: freshEntity,
                  );
                  if (ctx.mounted) {
                    AppToast.showSuccess(ctx, AppStrings.subspeciesAndAttachmentsSyncedSuccess);
                  }
                  return true;
                }
                return false;
              },
            ));
          }
        }
      }
    }
    return cards;
  }
}

/// Strategy 3: Nombres de Archivo de Adjuntos Desincronizados
class NumismaticAttachmentIncongruityStrategy implements IAuditRuleStrategy {
  const NumismaticAttachmentIncongruityStrategy();

  @override
  AuditCardType get cardType => AuditCardType.numismaticAttachmentIncongruity;

  @override
  String get ruleId => AppTechnicalStrings.ruleNumismaticAttachmentIncongruity;

  @override
  AuditCategory get category => AuditCategory.integrity;

  @override
  Future<List<AuditCardData>> evaluate(AuditEvaluationContext context) async {
    final cards = <AuditCardData>[];

    for (final entity in context.allEntities) {
      final species = context.speciesById[entity.speciesId];
      if (species != null && NumismaticDataHelper.isNumismaticSpecies(species) && entity.subspeciesId != null) {
        final sub = context.subspeciesById[entity.subspeciesId];
        if (sub != null) {
          final displayName = AuditRuleHelper.getEntityDisplayName(context, entity);

          final instAttrs = NumismaticDataHelper.extractAttributesFromInstance(entity);
          final pieceDisplayName = NumismaticDataHelper.buildInstanceDisplayName(instAttrs);

          final instanceAttachments = context.attachmentsByInstanceId[entity.id] ?? const <Attachment>[];
          for (final att in instanceAttachments) {
            final isObverse = att.fileName.toLowerCase().contains(AppTechnicalStrings.anversoParensLower) ||
                att.fileName.toLowerCase().contains(AppTechnicalStrings.anversoLower);
            final side = isObverse ? AppTechnicalStrings.anversoLower : AppTechnicalStrings.reversoLower;
            final file = File(att.filePath);
            final ext = att.fileName.contains(AppTechnicalStrings.dot)
                ? att.fileName.split(AppTechnicalStrings.dot).last
                : (file.path.contains(AppTechnicalStrings.dot)
                    ? file.path.split(AppTechnicalStrings.dot).last
                    : AppTechnicalStrings.empty);

            final expectedName = NumismaticDataHelper.buildAttachmentFileName(
              subspeciesName: pieceDisplayName,
              instanceId: entity.id,
              side: side,
              extension: ext,
            );

            if (att.fileName != expectedName) {
              cards.add(AuditRuleHelper.forEntity(
                id: AppTechnicalStrings.prefixNumisAtt + att.id,
                type: AuditCardType.numismaticAttachmentIncongruity,
                title: AppStrings.desyncedAttachmentNameTitle,
                subtitle: AppStrings.desyncedAttachmentNameSubtitle(displayName, att.fileName),
                question: AppStrings.desyncedAttachmentNameQuestion(
                  att.fileName,
                  pieceDisplayName,
                  expectedName,
                ),
                icon: Icons.attachment,
                themeColor: Colors.indigo,
                entity: entity,
                subspecies: sub,
                species: species,
                confirmLabel: AppStrings.confirmKeepNameAction,
                fixLabel: AppStrings.fixRenameFileAction,
                confirmToastMessage: AppStrings.attachmentNameRetainedSuccess,
                onFix: (ctx, ref) async {
                  final freshEntity = await ref.read(entityRepositoryProvider).getEntityById(entity.id) ?? entity;
                  final freshSub = await ref.read(catalogRepositoryProvider).getSubspeciesById(sub.id) ?? sub;
                  await NumismaticDataHelper.repairAttachmentFileNames(
                    catalogRepo: ref.read(catalogRepositoryProvider),
                    entityRepo: ref.read(entityRepositoryProvider),
                    subspecies: freshSub,
                    instance: freshEntity,
                  );
                  if (ctx.mounted) {
                    AppToast.showSuccess(ctx, AppStrings.attachmentRenamedSuccess);
                  }
                  return true;
                },
              ));
            }
          }
        }
      }
    }
    return cards;
  }
}

/// Strategy 4: Magnitudes Numismáticas Faltantes
class NumismaticMissingMagnitudesStrategy implements IAuditRuleStrategy {
  const NumismaticMissingMagnitudesStrategy();

  @override
  AuditCardType get cardType => AuditCardType.numismaticMissingMagnitudes;

  @override
  String get ruleId => AppTechnicalStrings.ruleNumismaticMissingMagnitudes;

  @override
  AuditCategory get category => AuditCategory.integrity;

  @override
  Future<List<AuditCardData>> evaluate(AuditEvaluationContext context) async {
    final cards = <AuditCardData>[];

    for (final entity in context.allEntities) {
      final species = context.speciesById[entity.speciesId];
      if (species != null && NumismaticDataHelper.isNumismaticSpecies(species) && entity.subspeciesId != null) {
        final sub = context.subspeciesById[entity.subspeciesId];
        if (sub != null) {
          final displayName = AuditRuleHelper.getEntityDisplayName(context, entity);

          final instAttrs = NumismaticDataHelper.extractAttributesFromInstance(entity);
          final missingMags = <String>[];
          if (instAttrs.faceValueNumber == null) missingMags.add(AppStrings.nominalValuePropertyName);
          if (instAttrs.year == null) missingMags.add(AppStrings.mintagePropertyName);
          if (instAttrs.currencyName == null) missingMags.add(AppStrings.currencyPropertyName);

          if (missingMags.isNotEmpty) {
            cards.add(AuditRuleHelper.forEntity(
              id: AppTechnicalStrings.prefixNumisMag + entity.id,
              type: AuditCardType.numismaticMissingMagnitudes,
              title: AppStrings.incompleteNumismaticMagnitudesTitle,
              subtitle: AppStrings.incompleteNumismaticMagnitudesSubtitle(
                displayName,
                missingMags.join(AppTechnicalStrings.commaSpace),
              ),
              question: AppStrings.incompleteNumismaticMagnitudesQuestion(
                displayName,
                missingMags.join(AppTechnicalStrings.commaSpace),
              ),
              icon: Icons.fact_check_outlined,
              themeColor: Colors.blueGrey,
              entity: entity,
              subspecies: sub,
              species: species,
              confirmLabel: AppStrings.confirmKeepEmptyAction,
              fixLabel: AppStrings.fixAutocompleteAction,
              confirmToastMessage: AppStrings.magnitudesRetainedSuccess,
              onFix: (ctx, ref) async {
                final parsedSub = NumismaticDataHelper.parseSubspeciesName(sub.subspeciesName);
                final freshEntity = await ref.read(entityRepositoryProvider).getEntityById(entity.id) ?? entity;
                final freshInstAttrs = NumismaticDataHelper.extractAttributesFromInstance(freshEntity);
                final List<InstanceMagnitude> currentMags = List.from(freshEntity.magnitudes);

                if (parsedSub.faceValueNumber != null && freshInstAttrs.faceValueNumber == null) {
                  currentMags.add(InstanceMagnitude(
                    id: const Uuid().v4(),
                    instanceId: freshEntity.id,
                    propertyName: AppStrings.nominalValuePropertyName,
                    dataType: AppTechnicalStrings.datatypeRealLower,
                    magnitudeValue: parsedSub.faceValueNumber!,
                  ));
                }

                if (parsedSub.year != null && freshInstAttrs.year == null && double.tryParse(parsedSub.year!) != null) {
                  currentMags.add(InstanceMagnitude(
                    id: const Uuid().v4(),
                    instanceId: freshEntity.id,
                    propertyName: AppStrings.mintagePropertyName,
                    dataType: AppTechnicalStrings.datatypeIntegerLower,
                    magnitudeValue: double.parse(parsedSub.year!),
                    unitSymbol: AppStrings.unitYear,
                  ));
                }

                if (freshInstAttrs.currencyName == null) {
                  final currToUse = parsedSub.currencyName ?? sub.subspeciesName;
                  final iso = NumismaticDataHelper.resolveCurrencyIsoCode(currToUse);
                  currentMags.add(InstanceMagnitude(
                    id: const Uuid().v4(),
                    instanceId: freshEntity.id,
                    propertyName: AppStrings.currencyPropertyName,
                    dataType: AppTechnicalStrings.datatypeStringLower,
                    stringValue: iso,
                  ));
                }

                if (parsedSub.country != null && parsedSub.country!.isNotEmpty && freshInstAttrs.country == null) {
                  currentMags.add(InstanceMagnitude(
                    id: const Uuid().v4(),
                    instanceId: freshEntity.id,
                    propertyName: AppStrings.issuerPropertyName,
                    dataType: AppTechnicalStrings.datatypeStringLower,
                    stringValue: parsedSub.country!,
                  ));
                }

                final updatedEntity = freshEntity.copyWith(magnitudes: currentMags);
                await ref.read(entityRepositoryProvider).saveEntity(updatedEntity);

                if (ctx.mounted) {
                  AppToast.showSuccess(ctx, AppStrings.numismaticMagnitudesAutoFilledSuccess);
                }
                return true;
              },
            ));
          }
        }
      }
    }
    return cards;
  }
}

/// Strategy 5: Atributos Opcionales Vacíos (ej. Grado de Conservación)
class EmptyDataAuditStrategy implements IAuditRuleStrategy {
  const EmptyDataAuditStrategy();

  @override
  AuditCardType get cardType => AuditCardType.emptyDataAudit;

  @override
  String get ruleId => AppTechnicalStrings.ruleNumismaticEmptyDataAudit;

  @override
  AuditCategory get category => AuditCategory.integrity;

  @override
  Future<List<AuditCardData>> evaluate(AuditEvaluationContext context) async {
    final cards = <AuditCardData>[];

    for (final entity in context.allEntities) {
      final species = context.speciesById[entity.speciesId];
      if (species != null && NumismaticDataHelper.isNumismaticSpecies(species) && entity.subspeciesId != null) {
        final sub = context.subspeciesById[entity.subspeciesId];
        if (sub != null) {
          final displayName = AuditRuleHelper.getEntityDisplayName(context, entity);

          final instAttrs = NumismaticDataHelper.extractAttributesFromInstance(entity);
          if (instAttrs.grade == null || instAttrs.grade!.trim().isEmpty) {
            cards.add(AuditRuleHelper.forEntity(
              id: AppTechnicalStrings.prefixNumisEmptyGrade + entity.id,
              type: AuditCardType.emptyDataAudit,
              title: AppStrings.emptyGradeDataTitle,
              subtitle: AppStrings.emptyGradeDataSubtitle(displayName),
              question: AppStrings.emptyGradeDataQuestion(displayName),
              icon: Icons.star_outline,
              themeColor: Colors.amber.shade800,
              entity: entity,
              subspecies: sub,
              species: species,
              confirmLabel: AppStrings.confirmWithoutGradeAction,
              fixLabel: AppStrings.fixAssignGradeAction,
              confirmToastMessage: AppStrings.gradeRetainedEmptySuccess,
              onFix: (ctx, ref) async {
                final chosenGrade = await AppWheelPicker.show<String>(
                  ctx,
                  items: NumismaticDataHelper.grades,
                  initialValue: NumismaticDataHelper.grades.first,
                  labelBuilder: (g) => g,
                  title: AppStrings.assignGradeTitle,
                );

                if (chosenGrade != null && chosenGrade.isNotEmpty) {
                  final freshEntity = await ref.read(entityRepositoryProvider).getEntityById(entity.id) ?? entity;
                  final List<InstanceMagnitude> currentMags = List.from(freshEntity.magnitudes);
                  final existingGradeIdx = currentMags.indexWhere((m) => m.propertyName == AppStrings.gradePropertyName);
                  if (existingGradeIdx >= 0) {
                    currentMags[existingGradeIdx] = currentMags[existingGradeIdx].copyWith(
                      dataType: AppTechnicalStrings.datatypeStringLower,
                      stringValue: chosenGrade,
                      unitSymbol: null,
                      magnitudeValue: 0.0,
                    );
                  } else {
                    currentMags.add(InstanceMagnitude(
                      id: const Uuid().v4(),
                      instanceId: freshEntity.id,
                      propertyName: AppStrings.gradePropertyName,
                      dataType: AppTechnicalStrings.datatypeStringLower,
                      stringValue: chosenGrade,
                    ));
                  }

                  final updatedEntity = freshEntity.copyWith(magnitudes: currentMags);
                  await ref.read(entityRepositoryProvider).saveEntity(updatedEntity);

                  if (ctx.mounted) {
                    AppToast.showSuccess(ctx, AppStrings.gradeUpdatedSuccess(chosenGrade));
                  }
                  return true;
                }
                return false;
              },
            ));
          }
        }
      }
    }
    return cards;
  }
}

/// Strategy 6: Anomalía Histórica en Emisión Numismática (Outliers en Coinbase)
class NumismaticEmissionOutlierStrategy implements IAuditRuleStrategy {
  const NumismaticEmissionOutlierStrategy();

  @override
  AuditCardType get cardType => AuditCardType.numismaticEmissionOutlier;

  @override
  String get ruleId => AppTechnicalStrings.ruleNumismaticEmissionOutlier;

  @override
  AuditCategory get category => AuditCategory.integrity;

  @override
  Future<List<AuditCardData>> evaluate(AuditEvaluationContext context) async {
    final cards = <AuditCardData>[];

    for (final entity in context.allEntities) {
      final species = context.speciesById[entity.speciesId];
      if (species != null && NumismaticDataHelper.isNumismaticSpecies(species) && entity.subspeciesId != null) {
        final sub = context.subspeciesById[entity.subspeciesId];
        if (sub != null) {
          final displayName = AuditRuleHelper.getEntityDisplayName(context, entity);
          final outliers = NumismaticDataHelper.checkEmissionOutliers(
            instance: entity,
            species: species,
          );

          for (int i = 0; i < outliers.length; i++) {
            final outlier = outliers[i];
            final cardId = AppTechnicalStrings.prefixNumisOutlier + entity.id + AppTechnicalStrings.underscore + i.toString();

            String fixBtnLabel;
            switch (outlier.type) {
              case NumismaticEmissionOutlierType.currencyAnachronism:
                fixBtnLabel = AppStrings.fixCorrectCurrencyAction;
                break;
              case NumismaticEmissionOutlierType.materialContradiction:
                fixBtnLabel = AppStrings.fixCorrectMaterialAction;
                break;
              case NumismaticEmissionOutlierType.motifMismatch:
                fixBtnLabel = AppStrings.fixSetMotifAction;
                break;
              case NumismaticEmissionOutlierType.denominationAnomaly:
                fixBtnLabel = AppStrings.fixPickDenominationAction;
                break;
              case NumismaticEmissionOutlierType.yearOutOfRange:
                fixBtnLabel = AppStrings.fixCorrectYearAction;
                break;
            }

            cards.add(AuditRuleHelper.forEntity(
              id: cardId,
              type: AuditCardType.numismaticEmissionOutlier,
              title: AppStrings.numismaticEmissionOutlierCardTitle,
              subtitle: AppStrings.numismaticEmissionOutlierSubtitle(
                displayName,
                outlier.description,
              ),
              question: AppStrings.numismaticEmissionOutlierQuestion(
                outlier.description,
                outlier.suggestedFixDescription,
              ),
              icon: Icons.history_edu,
              themeColor: Colors.deepPurple,
              entity: entity,
              subspecies: sub,
              species: species,
              confirmLabel: AppStrings.confirmKeepDataAction,
              fixLabel: fixBtnLabel,
              confirmToastMessage: AppStrings.numismaticEmissionOutlierSkipped,
              onFix: (ctx, ref) async {
                String? customValue;

                if (outlier.type == NumismaticEmissionOutlierType.currencyAnachronism) {
                  final attrs = NumismaticDataHelper.extractAttributesFromInstance(entity);
                  final yearInt = attrs.year != null ? int.tryParse(attrs.year!) : null;
                  final isBanknote = NumismaticDataHelper.isBanknotePiece(
                    species: species,
                    instance: entity,
                    material: attrs.material,
                  );
                  final availableCurrencies = NumismaticDataHelper.getCurrenciesForCountry(
                    attrs.country,
                    year: yearInt,
                    isBanknote: isBanknote,
                  ).where((c) => c != AppStrings.otherSpecifyOption).toList();

                  if (availableCurrencies.isNotEmpty) {
                    customValue = await AppWheelPicker.show<String>(
                      ctx,
                      items: availableCurrencies,
                      initialValue: availableCurrencies.first,
                      labelBuilder: (c) => c,
                      title: AppStrings.currencyPropertyName,
                    );
                    if (customValue == null || customValue.isEmpty) {
                      return false;
                    }
                  }
                } else if (outlier.type == NumismaticEmissionOutlierType.denominationAnomaly) {
                  final attrs = NumismaticDataHelper.extractAttributesFromInstance(entity);
                  final yearInt = attrs.year != null ? int.tryParse(attrs.year!) : null;
                  final isBanknote = NumismaticDataHelper.isBanknotePiece(
                    species: species,
                    instance: entity,
                    material: attrs.material,
                  );
                  final availableDenoms = NumismaticDataHelper.getDenominationsForCountry(
                    country: attrs.country,
                    year: yearInt,
                    currencyCode: attrs.currencyName,
                    isBanknote: isBanknote,
                  ).where((d) => d != AppStrings.otherSpecifyOption).toList();

                  if (availableDenoms.isNotEmpty) {
                    customValue = await AppWheelPicker.show<String>(
                      ctx,
                      items: availableDenoms,
                      initialValue: availableDenoms.first,
                      labelBuilder: (d) => d,
                      title: AppStrings.denominationNumberLabel,
                    );
                    if (customValue == null || customValue.isEmpty) {
                      return false;
                    }
                  }
                } else if (outlier.type == NumismaticEmissionOutlierType.materialContradiction) {
                  final attrs = NumismaticDataHelper.extractAttributesFromInstance(entity);
                  final yearInt = attrs.year != null ? int.tryParse(attrs.year!) : null;
                  final isBanknote = NumismaticDataHelper.isBanknotePiece(
                    species: species,
                    instance: entity,
                    material: attrs.material,
                  );
                  final validMaterials = NumismaticDataHelper.getValidMaterialsForCountry(
                    country: attrs.country,
                    year: yearInt,
                    currencyCode: attrs.currencyName,
                    denomination: attrs.faceValueStr ?? (attrs.faceValueNumber != null ? (attrs.faceValueNumber == attrs.faceValueNumber!.toInt() ? attrs.faceValueNumber!.toInt().toString() : attrs.faceValueNumber.toString()) : null),
                    isBanknote: isBanknote,
                  );
                  if (validMaterials.isNotEmpty) {
                    customValue = await AppWheelPicker.show<String>(
                      ctx,
                      items: validMaterials,
                      initialValue: validMaterials.first,
                      labelBuilder: (m) => m,
                      title: AppStrings.magMaterial,
                    );
                    if (customValue == null || customValue.isEmpty) {
                      return false;
                    }
                  }
                } else if (outlier.type == NumismaticEmissionOutlierType.motifMismatch) {
                  final attrs = NumismaticDataHelper.extractAttributesFromInstance(entity);
                  final yearInt = attrs.year != null ? int.tryParse(attrs.year!) : null;
                  final isBanknote = NumismaticDataHelper.isBanknotePiece(
                    species: species,
                    instance: entity,
                    material: attrs.material,
                  );
                  final availableMotifs = NumismaticDataHelper.getCommemorativeMotifs(
                    country: attrs.country,
                    year: yearInt,
                    currencyCode: attrs.currencyName,
                    denomination: attrs.faceValueStr ?? (attrs.faceValueNumber != null ? (attrs.faceValueNumber == attrs.faceValueNumber!.toInt() ? attrs.faceValueNumber!.toInt().toString() : attrs.faceValueNumber.toString()) : null),
                    isBanknote: isBanknote,
                  );

                  if (availableMotifs.isNotEmpty) {
                    final items = [...availableMotifs, AppStrings.customMotifOption];
                    final picked = await AppWheelPicker.show<String>(
                      ctx,
                      items: items,
                      initialValue: items.first,
                      labelBuilder: (m) => m,
                      title: AppStrings.motifLabel,
                    );
                    if (picked == null || picked.isEmpty) {
                      return false;
                    }
                    if (picked == AppStrings.customMotifOption) {
                      final textCtrl = TextEditingController(text: outlier.foundValue ?? AppTechnicalStrings.empty);
                      final formKey = GlobalKey<FormState>();
                      final confirmed = await showDialog<bool>(
                        context: ctx,
                        builder: (dialogCtx) => AlertDialog(
                          title: const Text(AppStrings.motifLabel),
                          content: Form(
                            key: formKey,
                            child: TextFormField(
                              controller: textCtrl,
                              decoration: const InputDecoration(labelText: AppStrings.motifLabel),
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return AppStrings.selectMotifPrompt;
                                }
                                return null;
                              },
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(dialogCtx, false),
                              child: const Text(AppStrings.cancel),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (formKey.currentState?.validate() ?? false) {
                                  Navigator.pop(dialogCtx, true);
                                }
                              },
                              child: const Text(AppStrings.confirm),
                            ),
                          ],
                        ),
                      );
                      if (confirmed == true && textCtrl.text.trim().isNotEmpty) {
                        customValue = textCtrl.text.trim();
                      } else {
                        return false;
                      }
                    } else {
                      customValue = picked;
                    }
                  } else {
                    final textCtrl = TextEditingController(text: outlier.foundValue ?? AppTechnicalStrings.empty);
                    final formKey = GlobalKey<FormState>();
                    final confirmed = await showDialog<bool>(
                      context: ctx,
                      builder: (dialogCtx) => AlertDialog(
                        title: const Text(AppStrings.motifLabel),
                        content: Form(
                          key: formKey,
                          child: TextFormField(
                            controller: textCtrl,
                            decoration: const InputDecoration(labelText: AppStrings.motifLabel),
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) {
                                return AppStrings.selectMotifPrompt;
                              }
                              return null;
                            },
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(dialogCtx, false),
                            child: const Text(AppStrings.cancel),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState?.validate() ?? false) {
                                Navigator.pop(dialogCtx, true);
                              }
                            },
                            child: const Text(AppStrings.confirm),
                          ),
                        ],
                      ),
                    );
                    if (confirmed == true && textCtrl.text.trim().isNotEmpty) {
                      customValue = textCtrl.text.trim();
                    } else {
                      return false;
                    }
                  }
                } else if (outlier.type == NumismaticEmissionOutlierType.yearOutOfRange) {
                  final textCtrl = TextEditingController(text: outlier.foundValue ?? AppTechnicalStrings.empty);
                  final formKey = GlobalKey<FormState>();
                  final confirmed = await showDialog<bool>(
                    context: ctx,
                    builder: (dialogCtx) => AlertDialog(
                      title: const Text(AppStrings.mintageYearLabel),
                      content: Form(
                        key: formKey,
                        child: TextFormField(
                          controller: textCtrl,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: AppStrings.mintageYearLabel),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return AppStrings.enterMintageYearPrompt;
                            }
                            final n = int.tryParse(val.trim());
                            if (n == null || n < 1500 || n > DateTime.now().year + 1) {
                              return AppStrings.enterValidMintageYearPrompt;
                            }
                            return null;
                          },
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(dialogCtx, false),
                          child: const Text(AppStrings.cancel),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState?.validate() ?? false) {
                              Navigator.pop(dialogCtx, true);
                            }
                          },
                          child: const Text(AppStrings.confirm),
                        ),
                      ],
                    ),
                  );
                  if (confirmed == true) {
                    customValue = textCtrl.text.trim();
                  } else {
                    return false;
                  }
                }

                final freshEntity = await ref.read(entityRepositoryProvider).getEntityById(entity.id) ?? entity;
                await NumismaticDataHelper.repairEmissionOutlier(
                  entityRepo: ref.read(entityRepositoryProvider),
                  catalogRepo: ref.read(catalogRepositoryProvider),
                  instance: freshEntity,
                  outlier: outlier,
                  customValue: customValue,
                );

                if (ctx.mounted) {
                  AppToast.showSuccess(ctx, AppStrings.numismaticEmissionOutlierFixedSuccess);
                }
                return true;
              },
            ));
          }
        }
      }
    }
    return cards;
  }
}
