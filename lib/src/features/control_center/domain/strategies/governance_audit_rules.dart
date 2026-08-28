import 'package:flutter/material.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import 'package:platinum_world_management_system/src/core/constants/app_technical_strings.dart';
import 'package:platinum_world_management_system/src/core/providers/providers.dart';
import 'package:platinum_world_management_system/src/core/widgets/app_toast.dart';
import 'package:platinum_world_management_system/src/core/widgets/app_wheel_picker.dart';
import 'package:uuid/uuid.dart';
import '../../../catalog/domain/catalog_item.dart';
import '../../../catalog/domain/subspecies.dart';
import '../../../catalog/presentation/add_edit_subspecies_modal.dart';
import '../../../catalog/presentation/standard_media_picker_sheet.dart';
import '../../../entities/domain/entity_template.dart';
import '../audit_rule_strategy.dart';
import 'audit_rule_helper.dart';

/// Strategy: Especies Homónimas Duplicadas en Catálogo
class DuplicateSpeciesStrategy implements IAuditRuleStrategy {
  const DuplicateSpeciesStrategy();

  @override
  AuditCardType get cardType => AuditCardType.duplicateSpecies;

  @override
  String get ruleId => AppTechnicalStrings.ruleGovernanceDuplicateSpecies;

  @override
  Future<List<AuditCardData>> evaluate(AuditEvaluationContext context) async {
    final Map<String, List<CatalogItem>> grouped = {};
    for (final sp in context.allCatalog) {
      final key = sp.name.trim().toLowerCase();
      grouped.putIfAbsent(key, () => []).add(sp);
    }
    grouped.removeWhere((key, list) => list.length <= 1);

    final cards = <AuditCardData>[];
    for (final entry in grouped.entries) {
      final speciesList = entry.value;
      final canonical = speciesList.first;
      final dupCount = speciesList.length;

      cards.add(AuditRuleHelper.forSpecies(
        id: AppTechnicalStrings.prefixDupSp + canonical.id,
        type: AuditCardType.duplicateSpecies,
        title: AppStrings.duplicateSpeciesAuditTitle,
        subtitle: AppStrings.duplicateSpeciesCardSubtitle(canonical.name, dupCount),
        question: AppStrings.duplicateSpeciesQuestion(canonical.name),
        icon: Icons.copy_all_outlined,
        themeColor: Colors.deepOrange,
        species: canonical,
        confirmToastMessage: AppStrings.attributesSkipped,
        onFix: (ctx, ref) async {
          final choice = await showDialog<String>(
            context: ctx,
            builder: (dialogCtx) => AlertDialog(
              title: const Text(AppStrings.duplicateSpeciesDialogTitle),
              content: Text(AppStrings.duplicateSpeciesPrompt(canonical.name)),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogCtx, AppTechnicalStrings.actionCancel),
                  child: const Text(AppStrings.cancel),
                ),
                OutlinedButton(
                  onPressed: () => Navigator.pop(dialogCtx, AppTechnicalStrings.actionEdit),
                  child: const Text(AppStrings.renameAction),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(dialogCtx, AppTechnicalStrings.actionMerge),
                  child: const Text(AppStrings.mergeWithExistingSpeciesAction),
                ),
              ],
            ),
          );

          if (choice == AppTechnicalStrings.actionMerge) {
            final catalogRepo = ref.read(catalogRepositoryProvider);
            for (int i = 1; i < speciesList.length; i++) {
              await catalogRepo.mergeSpecies(speciesList[i].id, canonical.id);
            }
            if (ctx.mounted) {
              AppToast.showSuccess(ctx, AppStrings.duplicateSpeciesMergedSuccess);
            }
            return true;
          } else if (choice == AppTechnicalStrings.actionEdit) {
            final newName = await AuditRuleHelper.showTextInputDialog(
              ctx,
              title: AppStrings.renameAction,
              labelText: AppStrings.nameLabel,
              initialValue: canonical.name,
            );
            if (newName != null && newName.trim().isNotEmpty && newName.trim() != canonical.name) {
              await ref.read(catalogRepositoryProvider).updateSpeciesName(canonical.id, newName.trim());
              if (ctx.mounted) {
                AppToast.showSuccess(ctx, AppStrings.speciesRenamedSuccess);
              }
              return true;
            }
          }
          return false;
        },
      ));
    }
    return cards;
  }
}

/// Strategy: Fotografía Compartida entre Especies Distintas
class DuplicatePhotoStrategy implements IAuditRuleStrategy {
  const DuplicatePhotoStrategy();

  @override
  AuditCardType get cardType => AuditCardType.duplicatePhotoAudit;

  @override
  String get ruleId => AppTechnicalStrings.ruleGovernanceDuplicatePhoto;

  @override
  Future<List<AuditCardData>> evaluate(AuditEvaluationContext context) async {
    final Map<String, List<CatalogItem>> photoMap = {};
    for (final sp in context.allCatalog) {
      if (sp.mainPhotoPath != null && sp.mainPhotoPath!.trim().isNotEmpty) {
        photoMap.putIfAbsent(sp.mainPhotoPath!.trim(), () => []).add(sp);
      }
    }
    photoMap.removeWhere((path, list) => list.length <= 1);

    final cards = <AuditCardData>[];
    for (final entry in photoMap.entries) {
      final speciesList = entry.value;
      for (int i = 0; i < speciesList.length; i++) {
        final current = speciesList[i];
        final other = speciesList[(i + 1) % speciesList.length];

        cards.add(AuditRuleHelper.forSpecies(
          id: AppTechnicalStrings.prefixDupPhoto + current.id,
          type: AuditCardType.duplicatePhotoAudit,
          title: AppStrings.duplicatePhotoAuditTitle,
          subtitle: AppStrings.duplicatePhotoCardSubtitle(current.name, other.name),
          question: AppStrings.duplicatePhotoQuestion(current.name, other.name),
          icon: Icons.photo_library_outlined,
          themeColor: Colors.indigoAccent,
          species: current,
          confirmToastMessage: AppStrings.attributesSkipped,
          onFix: (ctx, ref) async {
            final choice = await showDialog<String>(
              context: ctx,
              builder: (dialogCtx) => AlertDialog(
                title: const Text(AppStrings.duplicatePhotoDialogTitle),
                content: Text(AppStrings.duplicatePhotoPrompt(other.name)),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogCtx, AppTechnicalStrings.actionCancel),
                    child: const Text(AppStrings.cancel),
                  ),
                  OutlinedButton(
                    onPressed: () => Navigator.pop(dialogCtx, AppTechnicalStrings.actionDelete),
                    child: const Text(AppStrings.confirmRemovePhotoTitle),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(dialogCtx, AppTechnicalStrings.actionEdit),
                    child: const Text(AppStrings.changePhotoAction),
                  ),
                ],
              ),
            );

            if (choice == AppTechnicalStrings.actionDelete) {
              await ref.read(catalogRepositoryProvider).removeSpeciesMainPhoto(current.id);
              if (ctx.mounted) {
                AppToast.showSuccess(ctx, AppStrings.photoDecoupledSuccess);
              }
              return true;
            } else if (choice == AppTechnicalStrings.actionEdit) {
              final result = await StandardMediaPickerSheet.show(
                ctx,
                title: AppStrings.speciesPhotoTitle,
                webSearchQuery: current.name,
              );
              if (result != null) {
                final storage = ref.read(fileStorageServiceProvider);
                final savedPath = result.file != null
                    ? await storage.saveFile(result.file!.path)
                    : result.relativeStoredPath;
                if (savedPath != null) {
                  final freshSp = await ref.read(catalogRepositoryProvider).getCatalogItemById(current.id) ?? current;
                  await ref.read(catalogRepositoryProvider).saveCatalogItem(freshSp.copyWith(mainPhotoPath: savedPath));
                  if (ctx.mounted) {
                    AppToast.showSuccess(ctx, AppStrings.photoDecoupledSuccess);
                  }
                  return true;
                }
              }
            }
            return false;
          },
        ));
      }
    }
    return cards;
  }
}

/// Strategy: Especie sin Subespecies Registradas
class SpeciesWithoutSubspeciesStrategy implements IAuditRuleStrategy {
  const SpeciesWithoutSubspeciesStrategy();

  @override
  AuditCardType get cardType => AuditCardType.speciesWithoutSubspecies;

  @override
  String get ruleId => AppTechnicalStrings.ruleGovernanceSpeciesWithoutSubspecies;

  @override
  Future<List<AuditCardData>> evaluate(AuditEvaluationContext context) async {
    final emptySpecies = context.allCatalog.where((sp) {
      return !context.allSubspecies.any((sub) => sub.speciesId == sp.id);
    }).toList();

    final cards = <AuditCardData>[];
    for (final sp in emptySpecies) {
      cards.add(AuditRuleHelper.forSpecies(
        id: AppTechnicalStrings.prefixNoSub + sp.id,
        type: AuditCardType.speciesWithoutSubspecies,
        title: AppStrings.speciesWithoutSubspeciesAuditTitle,
        subtitle: AppStrings.speciesWithoutSubspeciesSubtitle(sp.name),
        question: AppStrings.speciesWithoutSubspeciesQuestion(sp.name),
        icon: Icons.view_in_ar_outlined,
        themeColor: Colors.amber.shade800,
        species: sp,
        confirmToastMessage: AppStrings.speciesKeptInCatalog,
        onFix: (ctx, ref) async {
          final choice = await showDialog<String>(
            context: ctx,
            builder: (dialogCtx) => AlertDialog(
              title: const Text(AppStrings.speciesWithoutSubspeciesAuditTitle),
              content: Text(AppStrings.speciesWithoutSubspeciesQuestion(sp.name)),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogCtx, AppTechnicalStrings.actionCancel),
                  child: const Text(AppStrings.cancel),
                ),
                ElevatedButton.icon(
                  onPressed: () => Navigator.pop(dialogCtx, AppTechnicalStrings.actionInstantiate),
                  icon: const Icon(Icons.add),
                  label: const Text(AppStrings.generateGenericSubspeciesAction),
                ),
                OutlinedButton.icon(
                  onPressed: () => Navigator.pop(dialogCtx, AppTechnicalStrings.actionEdit),
                  icon: const Icon(Icons.edit_note),
                  label: const Text(AppStrings.addSubspeciesTab),
                ),
                TextButton.icon(
                  onPressed: () => Navigator.pop(dialogCtx, AppTechnicalStrings.actionDelete),
                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                  label: const Text(AppStrings.deleteSpeciesAction, style: TextStyle(color: Colors.redAccent)),
                ),
              ],
            ),
          );

          if (choice == AppTechnicalStrings.actionInstantiate) {
            final catalogRepo = ref.read(catalogRepositoryProvider);
            final genericSub = Subspecies(
              id: const Uuid().v4(),
              speciesId: sp.id,
              subspeciesName: AppStrings.genericSubspeciesName,
              createdAt: DateTime.now(),
            );
            await catalogRepo.saveSubspecies(genericSub);
            if (ctx.mounted) {
              AppToast.showSuccess(ctx, AppStrings.genericSubspeciesGeneratedSuccess);
            }
            return true;
          } else if (choice == AppTechnicalStrings.actionEdit) {
            final result = await AddEditSubspeciesModal.show(
              ctx,
              species: sp,
              defaultSpeciesName: sp.name,
              isObject: EntityTemplateRegistry.hasBarcodeAndBrand(sp.type),
            );
            if (result != null) {
              await ref.read(catalogRepositoryProvider).saveSubspecies(result.copyWith(speciesId: sp.id));
              return true;
            }
          } else if (choice == AppTechnicalStrings.actionDelete) {
            await ref.read(catalogRepositoryProvider).deleteCatalogItem(sp.id, cascadeEntities: true);
            if (ctx.mounted) {
              AppToast.showSuccess(ctx, AppStrings.speciesDeletedFromCatalogSuccess);
            }
            return true;
          }
          return false;
        },
      ));
    }
    return cards;
  }
}

/// Strategy: Instancias Desvinculadas o Huérfanas de Subespecie
class UnlinkedInstancesStrategy implements IAuditRuleStrategy {
  const UnlinkedInstancesStrategy();

  @override
  AuditCardType get cardType => AuditCardType.unlinkedInstances;

  @override
  String get ruleId => AppTechnicalStrings.ruleGovernanceUnlinkedInstances;

  @override
  Future<List<AuditCardData>> evaluate(AuditEvaluationContext context) async {
    final unlinkedEntities = context.allEntities.where((e) {
      final hasSpecies = context.allCatalog.any((c) => c.id == e.speciesId);
      final hasSubspecies = e.subspeciesId != null && context.allSubspecies.any((s) => s.id == e.subspeciesId);
      return !hasSpecies || !hasSubspecies;
    }).toList();

    final cards = <AuditCardData>[];
    for (final entity in unlinkedEntities) {
      final species = context.allCatalog.where((c) => c.id == entity.speciesId).firstOrNull;
      final displayName = AuditRuleHelper.getEntityDisplayName(context, entity);

      cards.add(AuditRuleHelper.forEntity(
        id: AppTechnicalStrings.prefixUnlink + entity.id,
        type: AuditCardType.unlinkedInstances,
        title: AppStrings.unlinkedInstancesAuditTitle,
        subtitle: AppStrings.unlinkedInstancesSubtitle(displayName),
        question: AppStrings.unlinkedInstancesQuestion(displayName),
        icon: Icons.link_off_outlined,
        themeColor: Colors.redAccent,
        entity: entity,
        species: species,
        confirmToastMessage: AppStrings.attributesSkipped,
        onFix: (ctx, ref) async {
          final choice = await showDialog<String>(
            context: ctx,
            builder: (dialogCtx) => AlertDialog(
              title: const Text(AppStrings.unlinkedInstancesAuditTitle),
              content: Text(AppStrings.unlinkedInstancesQuestion(displayName)),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogCtx, AppTechnicalStrings.actionCancel),
                  child: const Text(AppStrings.cancel),
                ),
                if (species != null)
                  ElevatedButton(
                    onPressed: () => Navigator.pop(dialogCtx, AppTechnicalStrings.actionReassign),
                    child: const Text(AppStrings.reassignToSubspeciesTitle),
                  ),
                TextButton(
                  onPressed: () => Navigator.pop(dialogCtx, AppTechnicalStrings.actionDelete),
                  child: const Text(AppStrings.deregisterInstanceAction, style: TextStyle(color: Colors.redAccent)),
                ),
              ],
            ),
          );

          if (choice == AppTechnicalStrings.actionReassign && species != null) {
            final subs = context.allSubspecies.where((s) => s.speciesId == species.id).toList();
            if (subs.isEmpty) {
              // Create generic subspecies and reassign
              final genericSub = Subspecies(
                id: const Uuid().v4(),
                speciesId: species.id,
                subspeciesName: AppStrings.genericSubspeciesName,
                createdAt: DateTime.now(),
              );
              await ref.read(catalogRepositoryProvider).saveSubspecies(genericSub);
              final freshEnt = await ref.read(entityRepositoryProvider).getEntityById(entity.id) ?? entity;
              await ref.read(entityRepositoryProvider).saveEntity(freshEnt.copyWith(subspeciesId: genericSub.id));
              if (ctx.mounted) {
                AppToast.showSuccess(ctx, AppStrings.instanceReassignedSuccess);
              }
              return true;
            } else {
              final chosenSub = await AppWheelPicker.show<Subspecies>(
                ctx,
                items: subs,
                initialValue: subs.first,
                labelBuilder: (s) => s.subspeciesName,
                title: AppStrings.selectTargetSubspeciesPrompt,
              );
              if (chosenSub != null) {
                final freshEnt = await ref.read(entityRepositoryProvider).getEntityById(entity.id) ?? entity;
                await ref.read(entityRepositoryProvider).saveEntity(freshEnt.copyWith(subspeciesId: chosenSub.id));
                if (ctx.mounted) {
                  AppToast.showSuccess(ctx, AppStrings.instanceReassignedSuccess);
                }
                return true;
              }
            }
          } else if (choice == AppTechnicalStrings.actionDelete) {
            await ref.read(entityRepositoryProvider).deleteEntity(entity.id);
            if (ctx.mounted) {
              AppToast.showSuccess(ctx, AppStrings.instanceDeregisteredSuccess);
            }
            return true;
          }
          return false;
        },
      ));
    }
    return cards;
  }
}

/// Strategy: Fecha de Caducidad Anómala
class AnomalousExpirationStrategy implements IAuditRuleStrategy {
  const AnomalousExpirationStrategy();

  @override
  AuditCardType get cardType => AuditCardType.anomalousExpiration;

  @override
  String get ruleId => AppTechnicalStrings.ruleGovernanceAnomalousExpiration;

  @override
  Future<List<AuditCardData>> evaluate(AuditEvaluationContext context) async {
    final now = DateTime.now();
    final anomalousEntities = context.allEntities.where((e) {
      if (e.expirationDate == null) return false;
      final exp = e.expirationDate!;
      final isVeryOld = exp.isBefore(now.subtract(const Duration(days: 365 * 2)));
      final isVeryDistant = exp.isAfter(now.add(const Duration(days: 365 * 20)));
      return isVeryOld || isVeryDistant;
    }).toList();

    final cards = <AuditCardData>[];
    for (final entity in anomalousEntities) {
      final species = context.allCatalog.where((c) => c.id == entity.speciesId).firstOrNull;
      final displayName = AuditRuleHelper.getEntityDisplayName(context, entity);
      final formattedDate = entity.expirationDate.toString().substring(0, 10);

      cards.add(AuditRuleHelper.forEntity(
        id: AppTechnicalStrings.prefixAnomExp + entity.id,
        type: AuditCardType.anomalousExpiration,
        title: AppStrings.anomalousExpirationAuditTitle,
        subtitle: AppStrings.anomalousExpirationSubtitle(displayName, formattedDate),
        question: AppStrings.anomalousExpirationQuestion(displayName),
        icon: Icons.warning_amber_outlined,
        themeColor: Colors.amber.shade900,
        entity: entity,
        species: species,
        confirmToastMessage: AppStrings.attributesSkipped,
        onFix: (ctx, ref) async {
          final picked = await showDatePicker(
            context: ctx,
            initialDate: entity.expirationDate ?? DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
            helpText: AppStrings.selectExpirationDatePrompt,
          );
          if (picked != null) {
            final freshEnt = await ref.read(entityRepositoryProvider).getEntityById(entity.id) ?? entity;
            await ref.read(entityRepositoryProvider).saveEntity(freshEnt.copyWith(expirationDate: picked));
            if (ctx.mounted) {
              AppToast.showSuccess(ctx, AppStrings.expirationDateUpdatedSuccess);
            }
            return true;
          }
          return false;
        },
      ));
    }
    return cards;
  }
}
