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
          final rawDisplayName = AuditRuleHelper.getEntityDisplayName(context, entity);
          final derivedPieceName = NumismaticDataHelper.deriveInstanceName(entity, defaultSpeciesName: rawDisplayName);

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
                derivedPieceName,
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
                    content: Text(AppStrings.syncInfoPrompt(derivedPieceName, issueMsg)),
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
                  await NumismaticDataHelper.repairSubspeciesFromInstance(
                    catalogRepo: ref.read(catalogRepositoryProvider),
                    entityRepo: ref.read(entityRepositoryProvider),
                    subspecies: freshSub,
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
      if (species != null && NumismaticDataHelper.isNumismaticSpecies(species)) {
        final sub = entity.subspeciesId != null ? context.subspeciesById[entity.subspeciesId] : null;
        final rawDisplayName = AuditRuleHelper.getEntityDisplayName(context, entity);
        final instAttrs = NumismaticDataHelper.extractAttributesFromInstance(entity);
        var pieceDisplayName = NumismaticDataHelper.buildInstanceDisplayName(instAttrs);
        if (pieceDisplayName == AppStrings.defaultNumismaticPiece && sub != null) {
          final parsedSub = NumismaticDataHelper.parseSubspeciesName(sub.subspeciesName);
          if (parsedSub.currencyName != null || parsedSub.faceValueNumber != null) {
            pieceDisplayName = NumismaticDataHelper.buildSubspeciesName(
              faceValueNumber: parsedSub.faceValueNumber,
              faceValueStr: parsedSub.faceValueStr,
              currencyName: parsedSub.currencyName,
              country: parsedSub.country,
              year: parsedSub.year,
            );
          }
        }
        if (pieceDisplayName == AppStrings.defaultNumismaticPiece) {
          pieceDisplayName = sub?.subspeciesName ?? rawDisplayName;
        }

        final instanceAttachments = context.attachmentsByInstanceId[entity.id] ?? const <Attachment>[];
        if (instanceAttachments.isEmpty) continue;

        bool hasDesynced = false;
        Attachment? sampleDesynced;
        String? sampleExpected;

        for (int i = 0; i < instanceAttachments.length; i++) {
          final att = instanceAttachments[i];
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

          final expectedName = NumismaticDataHelper.buildAttachmentFileName(
            subspeciesName: pieceDisplayName,
            instanceId: entity.id,
            side: side,
            extension: ext,
          );

          if (att.fileName != expectedName) {
            hasDesynced = true;
            sampleDesynced ??= att;
            sampleExpected ??= expectedName;
          }
        }

        if (hasDesynced && sampleDesynced != null && sampleExpected != null) {
          cards.add(AuditRuleHelper.forEntity(
            id: AppTechnicalStrings.prefixNumisAtt + entity.id,
            type: AuditCardType.numismaticAttachmentIncongruity,
            title: AppStrings.desyncedAttachmentNameTitle,
            subtitle: AppStrings.desyncedAttachmentNameSubtitle(pieceDisplayName, sampleDesynced.fileName),
            question: AppStrings.desyncedAttachmentNameQuestion(
              sampleDesynced.fileName,
              pieceDisplayName,
              sampleExpected,
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
              final effectiveSub = sub != null ? (await ref.read(catalogRepositoryProvider).getSubspeciesById(sub.id) ?? sub) : null;
              if (effectiveSub != null) {
                await NumismaticDataHelper.repairAttachmentFileNames(
                  catalogRepo: ref.read(catalogRepositoryProvider),
                  entityRepo: ref.read(entityRepositoryProvider),
                  subspecies: effectiveSub,
                  instance: freshEntity,
                );
              }
              if (ctx.mounted) {
                AppToast.showSuccess(ctx, AppStrings.attachmentRenamedSuccess);
              }
              return true;
            },
          ));
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
      if (species != null && NumismaticDataHelper.isNumismaticSpecies(species)) {
        final sub = entity.subspeciesId != null ? context.subspeciesById[entity.subspeciesId] : null;
        final rawDisplayName = AuditRuleHelper.getEntityDisplayName(context, entity);
        final derivedPieceName = NumismaticDataHelper.deriveInstanceName(entity, defaultSpeciesName: rawDisplayName);

        final instAttrs = NumismaticDataHelper.extractAttributesFromInstance(entity);
        final missingMags = <String>[];
        if (instAttrs.faceValueNumber == null) missingMags.add(AppStrings.nominalValuePropertyName);
        if (instAttrs.year == null) missingMags.add(AppStrings.mintagePropertyName);
        if (instAttrs.currencyName == null) missingMags.add(AppStrings.currencyPropertyName);
        if (instAttrs.material == null || instAttrs.material!.trim().isEmpty) missingMags.add(AppStrings.materialPropertyName);
        if (instAttrs.country == null || instAttrs.country!.trim().isEmpty) missingMags.add(AppStrings.issuerPropertyName);
        if (instAttrs.grade == null || instAttrs.grade!.trim().isEmpty) missingMags.add(AppStrings.gradePropertyName);
        if (instAttrs.motif == null || instAttrs.motif!.trim().isEmpty) missingMags.add(AppStrings.motifPropertyName);

        if (missingMags.isNotEmpty) {
          cards.add(AuditRuleHelper.forEntity(
            id: AppTechnicalStrings.prefixNumisMag + entity.id,
            type: AuditCardType.numismaticMissingMagnitudes,
            title: AppStrings.incompleteNumismaticMagnitudesTitle,
            subtitle: AppStrings.incompleteNumismaticMagnitudesSubtitle(
              derivedPieceName,
              missingMags.join(AppTechnicalStrings.commaSpace),
            ),
            question: AppStrings.incompleteNumismaticMagnitudesQuestion(
              derivedPieceName,
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
              final parsedSub = sub != null ? NumismaticDataHelper.parseSubspeciesName(sub.subspeciesName) : const NumismaticAttributes();
              final freshEntity = await ref.read(entityRepositoryProvider).getEntityById(entity.id) ?? entity;
              final currentAttrs = NumismaticDataHelper.extractAttributesFromInstance(freshEntity);
              final List<InstanceMagnitude> currentMags = List.from(freshEntity.magnitudes);

              void setOrUpdateMagnitude({
                required String propertyName,
                required String dataType,
                String? stringValue,
                double? magnitudeValue,
                String? unitSymbol,
              }) {
                final idx = currentMags.indexWhere((m) => m.propertyName.trim().toLowerCase() == propertyName.trim().toLowerCase());
                if (idx >= 0) {
                  currentMags[idx] = currentMags[idx].copyWith(
                    dataType: dataType,
                    stringValue: stringValue,
                    magnitudeValue: magnitudeValue,
                    unitSymbol: unitSymbol,
                  );
                } else {
                  currentMags.add(InstanceMagnitude(
                    id: const Uuid().v4(),
                    instanceId: freshEntity.id,
                    propertyName: propertyName,
                    dataType: dataType,
                    stringValue: stringValue,
                    magnitudeValue: magnitudeValue,
                    unitSymbol: unitSymbol,
                  ));
                }
              }

              // 1. Nominal Value
              if (currentAttrs.faceValueNumber == null) {
                double? faceVal = parsedSub.faceValueNumber;
                if (faceVal == null) {
                  final textCtrl = TextEditingController();
                  final formKey = GlobalKey<FormState>();
                  final ok = await showDialog<bool>(
                    context: ctx,
                    builder: (dialogCtx) => AlertDialog(
                      title: const Text(AppStrings.nominalValuePropertyName),
                      content: Form(
                        key: formKey,
                        child: TextFormField(
                          controller: textCtrl,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: const InputDecoration(labelText: AppStrings.nominalValuePropertyName),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) return AppStrings.enterValidNominalValuePrompt;
                            if (double.tryParse(val.trim()) == null) return AppStrings.enterValidNominalValuePrompt;
                            return null;
                          },
                        ),
                      ),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(dialogCtx, false), child: const Text(AppStrings.cancel)),
                        ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState?.validate() ?? false) Navigator.pop(dialogCtx, true);
                          },
                          child: const Text(AppStrings.confirm),
                        ),
                      ],
                    ),
                  );
                  if (ok == true && textCtrl.text.trim().isNotEmpty) {
                    faceVal = double.tryParse(textCtrl.text.trim());
                  }
                }
                if (faceVal != null) {
                  setOrUpdateMagnitude(
                    propertyName: AppStrings.nominalValuePropertyName,
                    dataType: AppTechnicalStrings.datatypeRealLower,
                    magnitudeValue: faceVal,
                  );
                }
              }

              // 2. Mintage Year
              if (currentAttrs.year == null) {
                double? yearVal = parsedSub.year != null ? double.tryParse(parsedSub.year!) : null;
                if (yearVal == null) {
                  final textCtrl = TextEditingController();
                  final formKey = GlobalKey<FormState>();
                  final ok = await showDialog<bool>(
                    context: ctx,
                    builder: (dialogCtx) => AlertDialog(
                      title: const Text(AppStrings.mintagePropertyName),
                      content: Form(
                        key: formKey,
                        child: TextFormField(
                          controller: textCtrl,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: AppStrings.mintageYearLabel),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) return AppStrings.enterMintageYearPrompt;
                            final n = int.tryParse(val.trim());
                            if (n == null || n < 1500 || n > DateTime.now().year + 1) return AppStrings.enterValidMintageYearPrompt;
                            return null;
                          },
                        ),
                      ),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(dialogCtx, false), child: const Text(AppStrings.cancel)),
                        ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState?.validate() ?? false) Navigator.pop(dialogCtx, true);
                          },
                          child: const Text(AppStrings.confirm),
                        ),
                      ],
                    ),
                  );
                  if (ok == true && textCtrl.text.trim().isNotEmpty) {
                    yearVal = double.tryParse(textCtrl.text.trim());
                  }
                }
                if (yearVal != null) {
                  setOrUpdateMagnitude(
                    propertyName: AppStrings.mintagePropertyName,
                    dataType: AppTechnicalStrings.datatypeIntegerLower,
                    magnitudeValue: yearVal,
                    unitSymbol: AppStrings.yearUnitSymbol,
                  );
                }
              }

              // 3. Currency (ISO)
              if (currentAttrs.currencyName == null) {
                final currToUse = parsedSub.currencyName ?? sub?.subspeciesName ?? AppTechnicalStrings.currencyMxn;
                final iso = NumismaticDataHelper.resolveCurrencyIsoCode(currToUse);
                setOrUpdateMagnitude(
                  propertyName: AppStrings.currencyPropertyName,
                  dataType: AppTechnicalStrings.datatypeStringLower,
                  stringValue: iso,
                );
              }

              // 4. Country / Issuer
              if (currentAttrs.country == null || currentAttrs.country!.trim().isEmpty) {
                String? countryVal = parsedSub.country;
                if (countryVal == null || countryVal.trim().isEmpty) {
                  countryVal = await AppWheelPicker.show<String>(
                    ctx,
                    items: NumismaticDataHelper.countries,
                    initialValue: NumismaticDataHelper.countries.first,
                    labelBuilder: (c) => c,
                    title: AppStrings.issuerPropertyName,
                  );
                }
                if (countryVal != null && countryVal.isNotEmpty) {
                  setOrUpdateMagnitude(
                    propertyName: AppStrings.issuerPropertyName,
                    dataType: AppTechnicalStrings.datatypeStringLower,
                    stringValue: countryVal.trim(),
                  );
                }
              }

              // 5. Material
              if (currentAttrs.material == null || currentAttrs.material!.trim().isEmpty) {
                final matVal = await AppWheelPicker.show<String>(
                  ctx,
                  items: NumismaticDataHelper.coinMaterials,
                  initialValue: NumismaticDataHelper.coinMaterials.first,
                  labelBuilder: (m) => m,
                  title: AppStrings.materialPropertyName,
                );
                if (matVal != null && matVal.isNotEmpty) {
                  setOrUpdateMagnitude(
                    propertyName: AppStrings.materialPropertyName,
                    dataType: AppTechnicalStrings.datatypeStringLower,
                    stringValue: NumismaticDataHelper.resolveMaterial(matVal),
                  );
                }
              }

              // 6. Grade
              if (currentAttrs.grade == null || currentAttrs.grade!.trim().isEmpty) {
                final chosenGrade = await AppWheelPicker.show<String>(
                  ctx,
                  items: NumismaticDataHelper.grades,
                  initialValue: NumismaticDataHelper.grades.first,
                  labelBuilder: (g) => g,
                  title: AppStrings.assignGradeTitle,
                );
                if (chosenGrade != null && chosenGrade.isNotEmpty) {
                  setOrUpdateMagnitude(
                    propertyName: AppStrings.gradePropertyName,
                    dataType: AppTechnicalStrings.datatypeStringLower,
                    stringValue: NumismaticDataHelper.resolveGrade(chosenGrade),
                  );
                }
              }

              // 7. Motif
              if (currentAttrs.motif == null || currentAttrs.motif!.trim().isEmpty) {
                final yearInt = currentAttrs.year != null ? int.tryParse(currentAttrs.year!) : (parsedSub.year != null ? int.tryParse(parsedSub.year!) : null);
                final isBanknote = NumismaticDataHelper.isBanknotePiece(
                  species: species,
                  instance: freshEntity,
                  material: currentAttrs.material,
                );
                final availableMotifs = NumismaticDataHelper.getCommemorativeMotifs(
                  country: currentAttrs.country ?? parsedSub.country,
                  year: yearInt,
                  currencyCode: currentAttrs.currencyName ?? parsedSub.currencyName,
                  denomination: currentAttrs.faceValueStr ?? (currentAttrs.faceValueNumber != null ? (currentAttrs.faceValueNumber == currentAttrs.faceValueNumber!.toInt() ? currentAttrs.faceValueNumber!.toInt().toString() : currentAttrs.faceValueNumber.toString()) : null),
                  isBanknote: isBanknote,
                );

                String? chosenMotif;
                if (availableMotifs.isNotEmpty) {
                  final items = [...availableMotifs, AppStrings.otherSpecifyOption];
                  final selected = await AppWheelPicker.show<String>(
                    ctx,
                    items: items,
                    initialValue: items.first,
                    labelBuilder: (m) => m,
                    title: AppStrings.motifLabel,
                  );
                  if (selected == AppStrings.otherSpecifyOption) {
                    final textCtrl = TextEditingController();
                    final formKey = GlobalKey<FormState>();
                    final ok = await showDialog<bool>(
                      context: ctx,
                      builder: (dialogCtx) => AlertDialog(
                        title: const Text(AppStrings.motifLabel),
                        content: Form(
                          key: formKey,
                          child: TextFormField(
                            controller: textCtrl,
                            decoration: const InputDecoration(labelText: AppStrings.motifLabel),
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) return AppStrings.selectMotifPrompt;
                              return null;
                            },
                          ),
                        ),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(dialogCtx, false), child: const Text(AppStrings.cancel)),
                          ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState?.validate() ?? false) Navigator.pop(dialogCtx, true);
                            },
                            child: const Text(AppStrings.confirm),
                          ),
                        ],
                      ),
                    );
                    if (ok == true && textCtrl.text.trim().isNotEmpty) {
                      chosenMotif = textCtrl.text.trim();
                    }
                  } else if (selected != null && selected.isNotEmpty) {
                    chosenMotif = selected;
                  }
                } else {
                  final textCtrl = TextEditingController();
                  final formKey = GlobalKey<FormState>();
                  final ok = await showDialog<bool>(
                    context: ctx,
                    builder: (dialogCtx) => AlertDialog(
                      title: const Text(AppStrings.motifLabel),
                      content: Form(
                        key: formKey,
                        child: TextFormField(
                          controller: textCtrl,
                          decoration: const InputDecoration(labelText: AppStrings.motifLabel),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) return AppStrings.selectMotifPrompt;
                            return null;
                          },
                        ),
                      ),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(dialogCtx, false), child: const Text(AppStrings.cancel)),
                        ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState?.validate() ?? false) Navigator.pop(dialogCtx, true);
                          },
                          child: const Text(AppStrings.confirm),
                        ),
                      ],
                    ),
                  );
                  if (ok == true && textCtrl.text.trim().isNotEmpty) {
                    chosenMotif = textCtrl.text.trim();
                  }
                }

                if (chosenMotif != null && chosenMotif.isNotEmpty) {
                  setOrUpdateMagnitude(
                    propertyName: AppStrings.motifPropertyName,
                    dataType: AppTechnicalStrings.datatypeStringLower,
                    stringValue: chosenMotif.trim(),
                  );
                }
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
      if (species != null && NumismaticDataHelper.isNumismaticSpecies(species)) {
        final sub = entity.subspeciesId != null ? context.subspeciesById[entity.subspeciesId] : null;
        final rawDisplayName = AuditRuleHelper.getEntityDisplayName(context, entity);
        final derivedPieceName = NumismaticDataHelper.deriveInstanceName(entity, defaultSpeciesName: rawDisplayName);

        final instAttrs = NumismaticDataHelper.extractAttributesFromInstance(entity);
        if (instAttrs.grade == null || instAttrs.grade!.trim().isEmpty) {
          cards.add(AuditRuleHelper.forEntity(
            id: AppTechnicalStrings.prefixNumisEmptyGrade + entity.id,
            type: AuditCardType.emptyDataAudit,
            title: AppStrings.emptyGradeDataTitle,
            subtitle: AppStrings.emptyGradeDataSubtitle(derivedPieceName),
            question: AppStrings.emptyGradeDataQuestion(derivedPieceName),
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
                final resolvedGrade = NumismaticDataHelper.resolveGrade(chosenGrade);

                final existingGradeIdx = currentMags.indexWhere((m) {
                  final pName = m.propertyName.trim().toLowerCase();
                  return pName == AppStrings.gradePropertyName.toLowerCase() ||
                      pName == AppTechnicalStrings.magGradoLower ||
                      pName == AppTechnicalStrings.magConservacionWithAccentLower ||
                      pName == AppTechnicalStrings.magConservacionWithoutAccentLower;
                });

                if (existingGradeIdx >= 0) {
                  currentMags[existingGradeIdx] = currentMags[existingGradeIdx].copyWith(
                    propertyName: AppStrings.gradePropertyName,
                    dataType: AppTechnicalStrings.datatypeStringLower,
                    stringValue: resolvedGrade,
                    unitSymbol: null,
                    magnitudeValue: null,
                  );
                } else {
                  currentMags.add(InstanceMagnitude(
                    id: const Uuid().v4(),
                    instanceId: freshEntity.id,
                    propertyName: AppStrings.gradePropertyName,
                    dataType: AppTechnicalStrings.datatypeStringLower,
                    stringValue: resolvedGrade,
                  ));
                }

                final updatedEntity = freshEntity.copyWith(magnitudes: currentMags);
                await ref.read(entityRepositoryProvider).saveEntity(updatedEntity);

                if (ctx.mounted) {
                  AppToast.showSuccess(ctx, AppStrings.gradeUpdatedSuccess(resolvedGrade));
                }
                return true;
              }
              return false;
            },
          ));
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
          final rawDisplayName = AuditRuleHelper.getEntityDisplayName(context, entity);
          final derivedPieceName = NumismaticDataHelper.deriveInstanceName(entity, defaultSpeciesName: rawDisplayName);
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
                derivedPieceName,
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
                  final items = validMaterials.isNotEmpty
                      ? validMaterials
                      : NumismaticDataHelper.coinMaterials;
                  customValue = await AppWheelPicker.show<String>(
                    ctx,
                    items: items,
                    initialValue: items.first,
                    labelBuilder: (m) => m,
                    title: AppStrings.materialPropertyName,
                  );
                  if (customValue == null || customValue.isEmpty) {
                    return false;
                  }
                } else if (outlier.type == NumismaticEmissionOutlierType.motifMismatch) {
                  final attrs = NumismaticDataHelper.extractAttributesFromInstance(entity);
                  final yearInt = attrs.year != null ? int.tryParse(attrs.year!) : null;
                  final isBanknote = NumismaticDataHelper.isBanknotePiece(
                    species: species,
                    instance: entity,
                    material: attrs.material,
                  );
                  final denom = attrs.faceValueStr ?? (attrs.faceValueNumber != null ? (attrs.faceValueNumber == attrs.faceValueNumber!.toInt() ? attrs.faceValueNumber!.toInt().toString() : attrs.faceValueNumber.toString()) : null);
                  final availableMotifs = NumismaticDataHelper.getCommemorativeMotifs(
                    country: attrs.country,
                    year: yearInt,
                    currencyCode: attrs.currencyName,
                    denomination: denom,
                    isBanknote: isBanknote,
                  );
                  final isStrictlyCommem = NumismaticDataHelper.isStrictlyCommemorative(
                    country: attrs.country,
                    year: yearInt,
                    currencyCode: attrs.currencyName,
                    denomination: denom,
                    isBanknote: isBanknote,
                  );

                  final options = (attrs.motif != null && availableMotifs.isNotEmpty)
                      ? availableMotifs
                      : [
                          if (!isStrictlyCommem) AppStrings.noMotifStandardCirculation,
                          ...availableMotifs,
                        ];

                  customValue = await AppWheelPicker.show<String>(
                    ctx,
                    items: options,
                    initialValue: options.first,
                    labelBuilder: (m) => m,
                    title: AppStrings.motifLabel,
                  );
                  if (customValue == null || customValue.isEmpty) {
                    return false;
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
