import 'package:flutter/material.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import 'package:platinum_world_management_system/src/core/constants/app_technical_strings.dart';
import 'package:platinum_world_management_system/src/core/providers/providers.dart';
import 'package:platinum_world_management_system/src/core/widgets/app_toast.dart';
import '../../../catalog/presentation/species_form_modal.dart';
import '../../../entities/domain/entity_template.dart';
import '../../../entities/presentation/instantiate_species_sheet.dart';
import '../audit_rule_strategy.dart';
import 'audit_rule_helper.dart';

/// Strategy 1: Subespecie sin instancias
class UninstantiatedSubspeciesStrategy implements IAuditRuleStrategy {
  const UninstantiatedSubspeciesStrategy();

  @override
  AuditCardType get cardType => AuditCardType.uninstantiatedSubspecies;

  @override
  String get ruleId => AppTechnicalStrings.ruleCatalogUninstantiatedSubspecies;

  @override
  Future<List<AuditCardData>> evaluate(AuditEvaluationContext context) async {
    final cards = <AuditCardData>[];

    for (final sub in context.allSubspecies) {
      final instanceCount = context.allEntities.where((e) => e.subspeciesId == sub.id).length;
      if (instanceCount == 0 && sub.subspeciesName.toLowerCase() != AppStrings.genericSubspeciesNameLower) {
        final parentSpecies = context.allCatalog.where((c) => c.id == sub.speciesId).firstOrNull;
        final subNameStr = AppStrings.subspeciesNameWithBrand(sub.subspeciesName, sub.brand);

        cards.add(AuditRuleHelper.forSubspecies(
          id: AppTechnicalStrings.prefixSub + sub.id,
          type: AuditCardType.uninstantiatedSubspecies,
          title: AppStrings.uninstantiatedSubspeciesCardTitle,
          subtitle: AppStrings.uninstantiatedSubspeciesSubtitle(
            subNameStr,
            parentSpecies?.name ?? AppStrings.unknownSpecies,
          ),
          question: AppStrings.uninstantiatedSubspeciesQuestion(subNameStr),
          icon: Icons.unarchive_outlined,
          themeColor: Colors.amber,
          subspecies: sub,
          species: parentSpecies,
          onConfirm: (ctx, ref) async {
            final choice = await showDialog<String>(
              context: ctx,
              builder: (dialogCtx) => AlertDialog(
                title: const Text(AppStrings.confirmSubspeciesTitle),
                content: Text(AppStrings.keepSubspeciesPrompt(subNameStr)),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogCtx, AppTechnicalStrings.actionCancel),
                    child: const Text(AppStrings.cancel),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(dialogCtx, AppTechnicalStrings.actionKeep),
                    child: const Text(AppStrings.keepAction),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(dialogCtx, AppTechnicalStrings.actionDelete),
                    child: const Text(
                      AppStrings.deleteSubspeciesAction,
                      style: TextStyle(color: Colors.redAccent),
                    ),
                  ),
                ],
              ),
            );

            if (choice == AppTechnicalStrings.actionKeep) {
              if (ctx.mounted) {
                AppToast.showSuccess(ctx, AppStrings.subspeciesKeptSuccess);
              }
              return true;
            } else if (choice == AppTechnicalStrings.actionDelete) {
              try {
                await ref.read(catalogRepositoryProvider).deleteSubspecies(sub.id);
                if (ctx.mounted) {
                  AppToast.showSuccess(ctx, AppStrings.subspeciesDeletedSuccess);
                }
                return true;
              } catch (e) {
                if (ctx.mounted) {
                  AppToast.showError(
                    ctx,
                    e.toString().replaceAll(AppTechnicalStrings.exceptionPrefix, AppTechnicalStrings.empty),
                  );
                }
                return false;
              }
            }
            return false;
          },
          onFix: (ctx, ref) async {
            if (parentSpecies != null) {
              final countBefore = (await ref.read(entityRepositoryProvider).getAllEntities())
                  .where((e) => e.subspeciesId == sub.id).length;

              await InstantiateSpeciesSheet.show(
                ctx,
                species: parentSpecies,
                initialSubspecies: sub,
              );

              final countAfter = (await ref.read(entityRepositoryProvider).getAllEntities())
                  .where((e) => e.subspeciesId == sub.id).length;

              return countAfter > countBefore;
            }
            return false;
          },
        ));
      }
    }
    return cards;
  }
}

/// Strategy 2: Violación de Regla de Especie Única
class UniquenessViolationStrategy implements IAuditRuleStrategy {
  const UniquenessViolationStrategy();

  @override
  AuditCardType get cardType => AuditCardType.uniquenessViolation;

  @override
  String get ruleId => AppTechnicalStrings.ruleCatalogUniquenessViolation;

  @override
  Future<List<AuditCardData>> evaluate(AuditEvaluationContext context) async {
    final cards = <AuditCardData>[];

    for (final sp in context.allCatalog.where((c) => c.isUnique)) {
      final spSubspecies = context.allSubspecies.where((s) => s.speciesId == sp.id).toList();
      for (final sub in spSubspecies) {
        final matchingInstances = context.allEntities.where((e) => e.speciesId == sp.id && e.subspeciesId == sub.id).toList();
        if (matchingInstances.length > 1) {
          cards.add(AuditRuleHelper.forSubspecies(
            id: AppTechnicalStrings.prefixUniqViol + sub.id,
            type: AuditCardType.uniquenessViolation,
            title: AppStrings.uniqueSubspeciesDuplicatedTitle,
            subtitle: AppStrings.uniqueSubspeciesDuplicatedSubtitle(
              sub.subspeciesName,
              sp.name,
              matchingInstances.length,
            ),
            question: AppStrings.uniqueSubspeciesDuplicatedQuestion(
              sub.subspeciesName,
              sp.name,
              matchingInstances.length,
            ),
            icon: Icons.content_copy,
            themeColor: Colors.deepOrangeAccent,
            species: sp,
            subspecies: sub,
            confirmToastMessage: AppStrings.subspeciesDuplicationSkipped,
            onFix: (ctx, ref) async {
              final choice = await showDialog<String>(
                context: ctx,
                builder: (dialogCtx) => AlertDialog(
                  title: const Text(AppStrings.resolveUniquenessTitle),
                  content: Text(
                    AppStrings.resolveUniquenessPrompt(
                      sub.subspeciesName,
                      sp.name,
                      matchingInstances.length,
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(dialogCtx, AppTechnicalStrings.actionCancel),
                      child: const Text(AppStrings.cancel),
                    ),
                    OutlinedButton(
                      onPressed: () => Navigator.pop(dialogCtx, AppTechnicalStrings.actionMakeNotUnique),
                      child: const Text(AppStrings.makeNonUniqueAction),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(dialogCtx, AppTechnicalStrings.actionDeleteDuplicates),
                      child: const Text(
                        AppStrings.deleteDuplicatesAction,
                        style: TextStyle(color: Colors.redAccent),
                      ),
                    ),
                  ],
                ),
              );

              if (choice == AppTechnicalStrings.actionMakeNotUnique) {
                final freshSp = await ref.read(catalogRepositoryProvider).getCatalogItemById(sp.id) ?? sp;
                await ref.read(catalogRepositoryProvider).saveCatalogItem(freshSp.copyWith(isUnique: false));
                if (ctx.mounted) {
                  AppToast.showSuccess(ctx, AppStrings.speciesSetToNotUniqueSuccess);
                }
                return true;
              } else if (choice == AppTechnicalStrings.actionDeleteDuplicates) {
                for (int i = 1; i < matchingInstances.length; i++) {
                  await ref.read(entityRepositoryProvider).deleteEntity(matchingInstances[i].id);
                }
                if (ctx.mounted) {
                  AppToast.showSuccess(ctx, AppStrings.duplicatesDeletedPreservedOneSuccess);
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

/// Strategy 3: Infracción de Reglas de Subgrupo (Marca/Código en subgrupos no permitidos)
class SubgroupRuleViolationStrategy implements IAuditRuleStrategy {
  const SubgroupRuleViolationStrategy();

  @override
  AuditCardType get cardType => AuditCardType.subgroupRuleViolation;

  @override
  String get ruleId => AppTechnicalStrings.ruleCatalogSubgroupRuleViolation;

  @override
  Future<List<AuditCardData>> evaluate(AuditEvaluationContext context) async {
    final invalidSubspecies = context.allSubspecies.where((sub) {
      final sp = context.allCatalog.where((c) => c.id == sub.speciesId).firstOrNull;
      return sp != null &&
          !EntityTemplateRegistry.hasBarcodeAndBrand(sp.type) &&
          ((sub.brand != null && sub.brand!.isNotEmpty) || (sub.barcode != null && sub.barcode!.isNotEmpty));
    }).take(8);

    final cards = <AuditCardData>[];
    for (final sub in invalidSubspecies) {
      final sp = context.allCatalog.where((c) => c.id == sub.speciesId).firstOrNull;

      cards.add(AuditRuleHelper.forSubspecies(
        id: AppTechnicalStrings.prefixSubgroupViol + sub.id,
        type: AuditCardType.subgroupRuleViolation,
        title: AppStrings.subgroupRuleViolationTitle,
        subtitle: AppStrings.subgroupRuleViolationSubtitle(
          sub.subspeciesName,
          sp?.type ?? AppTechnicalStrings.empty,
        ),
        question: AppStrings.subgroupRuleViolationQuestion(sp?.type ?? AppTechnicalStrings.empty),
        icon: Icons.rule_folder_outlined,
        themeColor: Colors.deepPurpleAccent,
        subspecies: sub,
        species: sp,
        confirmToastMessage: AppStrings.attributesSkipped,
        onFix: (ctx, ref) async {
          final freshSub = await ref.read(catalogRepositoryProvider).getSubspeciesById(sub.id) ?? sub;
          final updatedSub = freshSub.copyWith(clearBrand: true, clearBarcode: true);
          await ref.read(catalogRepositoryProvider).saveSubspecies(updatedSub);
          if (ctx.mounted) {
            AppToast.showSuccess(ctx, AppStrings.brandAndBarcodeRemovedSuccess);
          }
          return true;
        },
      ));
    }
    return cards;
  }
}

/// Strategy 4: Especies en Catálogo sin Instancias
class UninstantiatedSpeciesStrategy implements IAuditRuleStrategy {
  const UninstantiatedSpeciesStrategy();

  @override
  AuditCardType get cardType => AuditCardType.uninstantiatedSpecies;

  @override
  String get ruleId => AppTechnicalStrings.ruleCatalogUninstantiatedSpecies;

  @override
  Future<List<AuditCardData>> evaluate(AuditEvaluationContext context) async {
    final uninstantiatedSpecies = context.allCatalog.where((sp) {
      return !context.allEntities.any((e) => e.speciesId == sp.id);
    }).take(8);

    final cards = <AuditCardData>[];
    for (final sp in uninstantiatedSpecies) {
      cards.add(AuditRuleHelper.forSpecies(
        id: AppTechnicalStrings.prefixUninstSp + sp.id,
        type: AuditCardType.uninstantiatedSpecies,
        title: AppStrings.uninstantiatedSpeciesWorldTitle,
        subtitle: AppStrings.speciesWithType(sp.name, sp.type),
        question: AppStrings.uninstantiatedSpeciesQuestion(sp.name),
        icon: Icons.category_outlined,
        themeColor: Colors.brown,
        species: sp,
        confirmToastMessage: AppStrings.speciesKeptInCatalog,
        onFix: (ctx, ref) async {
          final choice = await showDialog<String>(
            context: ctx,
            builder: (dialogCtx) => AlertDialog(
              title: Text(AppStrings.manageSpeciesTitle(sp.name)),
              content: const Text(AppStrings.whatActionForSpeciesPrompt),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogCtx, AppTechnicalStrings.actionCancel),
                  child: const Text(AppStrings.cancel),
                ),
                ElevatedButton.icon(
                  onPressed: () => Navigator.pop(dialogCtx, AppTechnicalStrings.actionInstantiate),
                  icon: const Icon(Icons.add),
                  label: const Text(AppStrings.createInstanceAction),
                ),
                TextButton.icon(
                  onPressed: () => Navigator.pop(dialogCtx, AppTechnicalStrings.actionDelete),
                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                  label: const Text(
                    AppStrings.deleteSpeciesAction,
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ),
              ],
            ),
          );

          if (choice == AppTechnicalStrings.actionInstantiate) {
            await InstantiateSpeciesSheet.show(ctx, species: sp);
            final afterCount = (await ref.read(entityRepositoryProvider).getAllEntities()).where((e) => e.speciesId == sp.id).length;
            return afterCount > 0;
          } else if (choice == AppTechnicalStrings.actionDelete) {
            try {
              await ref.read(catalogRepositoryProvider).deleteCatalogItem(sp.id);
              if (ctx.mounted) {
                AppToast.showSuccess(ctx, AppStrings.speciesDeletedFromCatalogSuccess);
              }
              return true;
            } catch (e) {
              if (ctx.mounted) {
                AppToast.showError(
                  ctx,
                  e.toString().replaceAll(AppTechnicalStrings.exceptionPrefix, AppTechnicalStrings.empty),
                );
              }
            }
          }
          return false;
        },
      ));
    }
    return cards;
  }
}

/// Strategy 5: Especie con información incompleta
class IncompleteSpeciesInfoStrategy implements IAuditRuleStrategy {
  const IncompleteSpeciesInfoStrategy();

  @override
  AuditCardType get cardType => AuditCardType.incompleteSpeciesInfo;

  @override
  String get ruleId => AppTechnicalStrings.ruleCatalogIncompleteSpeciesInfo;

  @override
  Future<List<AuditCardData>> evaluate(AuditEvaluationContext context) async {
    final incompleteSpecies = context.allCatalog.where((c) => (c.mainPhotoPath == null || c.mainPhotoPath!.isEmpty)).take(5);
    final cards = <AuditCardData>[];

    for (final sp in incompleteSpecies) {
      cards.add(AuditRuleHelper.forSpecies(
        id: AppTechnicalStrings.prefixSpecInc + sp.id,
        type: AuditCardType.incompleteSpeciesInfo,
        title: AppStrings.incompleteSpeciesInfoTitle,
        subtitle: AppStrings.speciesWithType(sp.name, sp.type),
        question: AppStrings.incompleteSpeciesInfoQuestion(sp.name),
        icon: Icons.add_a_photo_outlined,
        themeColor: Colors.purpleAccent,
        species: sp,
        confirmToastMessage: AppStrings.informationSkippedForNow,
        onFix: (ctx, ref) async {
          final freshSp = await ref.read(catalogRepositoryProvider).getCatalogItemById(sp.id) ?? sp;
          final result = await SpeciesFormModal.show(ctx, initialSpecies: freshSp);
          return result != null;
        },
      ));
    }
    return cards;
  }
}

/// Strategy 6: Especies y Subespecies con Imágenes Remotas (HTTP / HTTPS)
class RemoteImageAuditStrategy implements IAuditRuleStrategy {
  const RemoteImageAuditStrategy();

  @override
  AuditCardType get cardType => AuditCardType.remoteImageAudit;

  @override
  String get ruleId => AppTechnicalStrings.ruleCatalogRemoteImageAudit;

  @override
  Future<List<AuditCardData>> evaluate(AuditEvaluationContext context) async {
    final cards = <AuditCardData>[];

    // Species with remote images
    final remoteImageSpecies = context.allCatalog.where((c) =>
      c.mainPhotoPath != null &&
      (c.mainPhotoPath!.startsWith(AppTechnicalStrings.schemeHttp) ||
       c.mainPhotoPath!.startsWith(AppTechnicalStrings.schemeHttps))
    );
    for (final sp in remoteImageSpecies) {
      cards.add(AuditRuleHelper.forSpecies(
        id: AppTechnicalStrings.prefixSpecRemote + sp.id,
        type: AuditCardType.remoteImageAudit,
        title: AppStrings.remoteSpeciesImageTitle,
        subtitle: AppStrings.remoteSpeciesImageSubtitle(sp.name, sp.type),
        question: AppStrings.remoteSpeciesImageQuestion(sp.name),
        icon: Icons.cloud_download_outlined,
        themeColor: Colors.indigoAccent,
        species: sp,
        confirmToastMessage: AppStrings.remoteImageKeptWithoutDownload,
        onFix: (ctx, ref) async {
          return await AuditRuleHelper.resolveRemoteImage(
            context: ctx,
            ref: ref,
            remoteUrl: sp.mainPhotoPath!,
            displayName: sp.name,
            onSave: (relPath) async {
              final freshSp = await ref.read(catalogRepositoryProvider).getCatalogItemById(sp.id) ?? sp;
              final updatedSp = freshSp.copyWith(mainPhotoPath: relPath);
              await ref.read(catalogRepositoryProvider).saveCatalogItem(updatedSp);
              ref.read(catalogListProvider.notifier).loadCatalog();
            },
          );
        },
      ));
    }

    // Subspecies with remote images
    final remoteImageSubspecies = context.allSubspecies.where((s) =>
      s.photoPath != null &&
      (s.photoPath!.startsWith(AppTechnicalStrings.schemeHttp) ||
       s.photoPath!.startsWith(AppTechnicalStrings.schemeHttps))
    );
    for (final sub in remoteImageSubspecies) {
      final parentSpecies = context.allCatalog.where((c) => c.id == sub.speciesId).firstOrNull;
      cards.add(AuditRuleHelper.forSubspecies(
        id: AppTechnicalStrings.prefixSubRemote + sub.id,
        type: AuditCardType.remoteImageAudit,
        title: AppStrings.remoteSubspeciesImageTitle,
        subtitle: AppStrings.remoteSubspeciesImageSubtitle(
          sub.subspeciesName,
          parentSpecies?.name ?? AppTechnicalStrings.empty,
        ),
        question: AppStrings.remoteSubspeciesImageQuestion(sub.subspeciesName),
        icon: Icons.cloud_download_outlined,
        themeColor: Colors.indigo,
        subspecies: sub,
        species: parentSpecies,
        confirmToastMessage: AppStrings.remoteImageKeptWithoutDownload,
        onFix: (ctx, ref) async {
          return await AuditRuleHelper.resolveRemoteImage(
            context: ctx,
            ref: ref,
            remoteUrl: sub.photoPath!,
            displayName: sub.subspeciesName,
            onSave: (relPath) async {
              final freshSub = await ref.read(catalogRepositoryProvider).getSubspeciesById(sub.id) ?? sub;
              final updatedSub = freshSub.copyWith(photoPath: relPath);
              await ref.read(catalogRepositoryProvider).saveSubspecies(updatedSub);
              ref.invalidate(subspeciesListProvider);
            },
          );
        },
      ));
    }

    return cards;
  }
}
