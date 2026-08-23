import 'package:flutter/material.dart';
import 'package:platinum_world_management_system/src/core/providers/providers.dart';
import 'package:platinum_world_management_system/src/core/widgets/app_toast.dart';
import '../../../catalog/presentation/species_form_modal.dart';
import '../../../catalog/presentation/species_tile.dart';
import '../../../catalog/presentation/standard_media_picker_sheet.dart';
import '../../../catalog/presentation/subspecies_tile.dart';
import '../../../entities/domain/entity_template.dart';
import '../../../entities/presentation/instantiate_species_sheet.dart';
import '../audit_rule_strategy.dart';

/// Strategy 1: Subespecie sin instancias
class UninstantiatedSubspeciesStrategy implements IAuditRuleStrategy {
  const UninstantiatedSubspeciesStrategy();

  @override
  AuditCardType get cardType => AuditCardType.uninstantiatedSubspecies;

  @override
  String get ruleId => 'catalog_uninstantiated_subspecies';

  @override
  Future<List<AuditCardData>> evaluate(AuditEvaluationContext context) async {
    final cards = <AuditCardData>[];

    for (final sub in context.allSubspecies) {
      final instanceCount = context.allEntities.where((e) => e.subspeciesId == sub.id).length;
      if (instanceCount == 0 && sub.subspeciesName.toLowerCase() != 'genérica') {
        final parentSpecies = context.allCatalog.where((c) => c.id == sub.speciesId).firstOrNull;
        final subNameStr = '${sub.subspeciesName}${sub.brand != null && sub.brand!.isNotEmpty ? " (${sub.brand})" : ""}';

        cards.add(AuditCardData(
          id: 'sub_${sub.id}',
          type: AuditCardType.uninstantiatedSubspecies,
          title: 'Subespecie sin Instancia',
          subtitle: '$subNameStr • Especie: ${parentSpecies?.name ?? "Desconocida"}',
          question: 'No existe ninguna instancia registrada para la subespecie "$subNameStr". ¿Deseas mantenerla o eliminarla?',
          icon: Icons.unarchive_outlined,
          themeColor: Colors.amber,
          subspecies: sub,
          species: parentSpecies,
          onConfirm: (ctx, ref) async {
            final choice = await showDialog<String>(
              context: ctx,
              builder: (dialogCtx) => AlertDialog(
                title: const Text('Confirmar Subespecie'),
                content: Text('¿Deseas mantener la subespecie "$subNameStr" en tu catálogo o eliminarla?'),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(dialogCtx, 'cancel'), child: const Text('Cancelar')),
                  TextButton(onPressed: () => Navigator.pop(dialogCtx, 'keep'), child: const Text('Mantener')),
                  TextButton(
                    onPressed: () => Navigator.pop(dialogCtx, 'delete'),
                    child: const Text('Eliminar Subespecie', style: TextStyle(color: Colors.redAccent)),
                  ),
                ],
              ),
            );

            if (choice == 'keep') {
              if (ctx.mounted) {
                AppToast.showSuccess(ctx, 'Subespecie mantenida.');
              }
              return true;
            } else if (choice == 'delete') {
              try {
                await ref.read(catalogRepositoryProvider).deleteSubspecies(sub.id);
                if (ctx.mounted) {
                  AppToast.showSuccess(ctx, 'Subespecie eliminada.');
                }
                return true;
              } catch (e) {
                if (ctx.mounted) {
                  AppToast.showError(ctx, e.toString().replaceAll('Exception: ', ''));
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
          tile: SubspeciesTile(
            subspecies: sub,
            speciesName: parentSpecies?.name,
          ),
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
  String get ruleId => 'catalog_uniqueness_violation';

  @override
  Future<List<AuditCardData>> evaluate(AuditEvaluationContext context) async {
    final cards = <AuditCardData>[];

    for (final sp in context.allCatalog.where((c) => c.isUnique)) {
      final spSubspecies = context.allSubspecies.where((s) => s.speciesId == sp.id).toList();
      for (final sub in spSubspecies) {
        final matchingInstances = context.allEntities.where((e) => e.speciesId == sp.id && e.subspeciesId == sub.id).toList();
        if (matchingInstances.length > 1) {
          cards.add(AuditCardData(
            id: 'uniq_viol_${sub.id}',
            type: AuditCardType.uniquenessViolation,
            title: 'Subespecie Única Duplicada',
            subtitle: '${sub.subspeciesName} • ${sp.name} (${matchingInstances.length} instancias)',
            question: 'La subespecie "${sub.subspeciesName}" de la especie única "${sp.name}" tiene ${matchingInstances.length} instancias físicas duplicadas. ¿Cómo deseas proceder?',
            icon: Icons.content_copy,
            themeColor: Colors.deepOrangeAccent,
            species: sp,
            subspecies: sub,
            tile: SubspeciesTile(subspecies: sub, speciesName: sp.name),
            onConfirm: (ctx, ref) async {
              if (ctx.mounted) {
                AppToast.showSuccess(ctx, 'Duplicidad de subespecie omitida.');
              }
              return true;
            },
            onFix: (ctx, ref) async {
              final choice = await showDialog<String>(
                context: ctx,
                builder: (dialogCtx) => AlertDialog(
                  title: const Text('Resolver unicidad'),
                  content: Text(
                    'La subespecie "${sub.subspeciesName}" de la especie única "${sp.name}" tiene ${matchingInstances.length} instancias.\n\n'
                    '¿Deseas permitir múltiples instancias convirtiendo la especie en No Única o eliminar los duplicados de esta subespecie?'
                  ),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(dialogCtx, 'cancel'), child: const Text('Cancelar')),
                    OutlinedButton(
                      onPressed: () => Navigator.pop(dialogCtx, 'make_not_unique'),
                      child: const Text('Convertir a No Única'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(dialogCtx, 'delete_duplicates'),
                      child: const Text('Eliminar Duplicados', style: TextStyle(color: Colors.redAccent)),
                    ),
                  ],
                ),
              );

              if (choice == 'make_not_unique') {
                final freshSp = await ref.read(catalogRepositoryProvider).getCatalogItemById(sp.id) ?? sp;
                await ref.read(catalogRepositoryProvider).saveCatalogItem(freshSp.copyWith(isUnique: false));
                if (ctx.mounted) {
                  AppToast.showSuccess(ctx, 'Especie configurada como No Única.');
                }
                return true;
              } else if (choice == 'delete_duplicates') {
                for (int i = 1; i < matchingInstances.length; i++) {
                  await ref.read(entityRepositoryProvider).deleteEntity(matchingInstances[i].id);
                }
                if (ctx.mounted) {
                  AppToast.showSuccess(ctx, 'Instancias duplicadas eliminadas. Se conservó 1 instancia.');
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
  String get ruleId => 'catalog_subgroup_rule_violation';

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

      cards.add(AuditCardData(
        id: 'subgroup_viol_${sub.id}',
        type: AuditCardType.subgroupRuleViolation,
        title: 'Infracción de Regla de Subgrupo',
        subtitle: '${sub.subspeciesName} • Tipo: ${sp?.type ?? ""}',
        question: 'El subgrupo "${sp?.type}" no permite marca ni código de barras. ¿Deseas limpiar estos atributos?',
        icon: Icons.rule_folder_outlined,
        themeColor: Colors.deepPurpleAccent,
        subspecies: sub,
        species: sp,
        tile: SubspeciesTile(subspecies: sub, speciesName: sp?.name ?? ''),
        onConfirm: (ctx, ref) async {
          if (ctx.mounted) {
            AppToast.showSuccess(ctx, 'Atributos omitidos.');
          }
          return true;
        },
        onFix: (ctx, ref) async {
          final freshSub = await ref.read(catalogRepositoryProvider).getSubspeciesById(sub.id) ?? sub;
          final updatedSub = freshSub.copyWith(clearBrand: true, clearBarcode: true);
          await ref.read(catalogRepositoryProvider).saveSubspecies(updatedSub);
          if (ctx.mounted) {
            AppToast.showSuccess(ctx, 'Marca y código de barras removidos.');
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
  String get ruleId => 'catalog_uninstantiated_species';

  @override
  Future<List<AuditCardData>> evaluate(AuditEvaluationContext context) async {
    final uninstantiatedSpecies = context.allCatalog.where((sp) {
      return !context.allEntities.any((e) => e.speciesId == sp.id);
    }).take(8);

    final cards = <AuditCardData>[];
    for (final sp in uninstantiatedSpecies) {
      cards.add(AuditCardData(
        id: 'uninst_sp_${sp.id}',
        type: AuditCardType.uninstantiatedSpecies,
        title: 'Especie sin Instancias en el Mundo',
        subtitle: '${sp.name} (${sp.type})',
        question: 'La especie "${sp.name}" no tiene ninguna instancia física registrada. ¿Deseas crear una instancia o eliminar la especie?',
        icon: Icons.category_outlined,
        themeColor: Colors.brown,
        species: sp,
        tile: SpeciesTile(species: sp),
        onConfirm: (ctx, ref) async {
          if (ctx.mounted) {
            AppToast.showSuccess(ctx, 'Especie conservada en catálogo.');
          }
          return true;
        },
        onFix: (ctx, ref) async {
          final choice = await showDialog<String>(
            context: ctx,
            builder: (dialogCtx) => AlertDialog(
              title: Text('Gestionar "${sp.name}"'),
              content: const Text('¿Qué acción deseas realizar con esta especie?'),
              actions: [
                TextButton(onPressed: () => Navigator.pop(dialogCtx, 'cancel'), child: const Text('Cancelar')),
                ElevatedButton.icon(
                  onPressed: () => Navigator.pop(dialogCtx, 'instantiate'),
                  icon: const Icon(Icons.add),
                  label: const Text('Crear Instancia'),
                ),
                TextButton.icon(
                  onPressed: () => Navigator.pop(dialogCtx, 'delete'),
                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                  label: const Text('Eliminar Especie', style: TextStyle(color: Colors.redAccent)),
                ),
              ],
            ),
          );

          if (choice == 'instantiate') {
            await InstantiateSpeciesSheet.show(ctx, species: sp);
            final afterCount = (await ref.read(entityRepositoryProvider).getAllEntities()).where((e) => e.speciesId == sp.id).length;
            return afterCount > 0;
          } else if (choice == 'delete') {
            try {
              await ref.read(catalogRepositoryProvider).deleteCatalogItem(sp.id);
              if (ctx.mounted) {
                AppToast.showSuccess(ctx, 'Especie eliminada del catálogo.');
              }
              return true;
            } catch (e) {
              if (ctx.mounted) {
                AppToast.showError(ctx, e.toString().replaceAll('Exception: ', ''));
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
  String get ruleId => 'catalog_incomplete_species_info';

  @override
  Future<List<AuditCardData>> evaluate(AuditEvaluationContext context) async {
    final incompleteSpecies = context.allCatalog.where((c) => (c.mainPhotoPath == null || c.mainPhotoPath!.isEmpty)).take(5);
    final cards = <AuditCardData>[];

    for (final sp in incompleteSpecies) {
      cards.add(AuditCardData(
        id: 'spec_inc_${sp.id}',
        type: AuditCardType.incompleteSpeciesInfo,
        title: 'Especie sin Imagen Principal',
        subtitle: '${sp.name} (${sp.type})',
        question: 'La especie "${sp.name}" no tiene una imagen principal asignada. ¿Deseas agregarle una foto o buscarla en Internet?',
        icon: Icons.add_a_photo_outlined,
        themeColor: Colors.purpleAccent,
        species: sp,
        tile: SpeciesTile(species: sp),
        onConfirm: (ctx, ref) async {
          if (ctx.mounted) {
            AppToast.showSuccess(ctx, 'Información omitida por el momento.');
          }
          return true;
        },
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
  String get ruleId => 'catalog_remote_image_audit';

  @override
  Future<List<AuditCardData>> evaluate(AuditEvaluationContext context) async {
    final cards = <AuditCardData>[];

    // Species with remote images
    final remoteImageSpecies = context.allCatalog.where((c) =>
      c.mainPhotoPath != null &&
      (c.mainPhotoPath!.startsWith('http://') || c.mainPhotoPath!.startsWith('https://'))
    );
    for (final sp in remoteImageSpecies) {
      cards.add(AuditCardData(
        id: 'spec_remote_${sp.id}',
        type: AuditCardType.remoteImageAudit,
        title: 'Imagen de Especie No Local (URL Remota)',
        subtitle: '${sp.name} (${sp.type}) • Imagen en Internet',
        question: 'La especie "${sp.name}" tiene una imagen referenciada desde una URL remota de Internet. ¿Deseas descargarla y guardarla localmente en el dispositivo para tenerla offline y respaldable?',
        icon: Icons.cloud_download_outlined,
        themeColor: Colors.indigoAccent,
        species: sp,
        tile: SpeciesTile(species: sp),
        onConfirm: (ctx, ref) async {
          if (ctx.mounted) {
            AppToast.showSuccess(ctx, 'Imagen remota conservada sin descargar.');
          }
          return true;
        },
        onFix: (ctx, ref) async {
          final lookupService = ref.read(productLookupServiceProvider);
          final fileStorage = ref.read(fileStorageServiceProvider);
          final localTempPath = await lookupService.downloadAndSaveImage(sp.mainPhotoPath!);
          if (localTempPath != null) {
            final relPath = await fileStorage.saveFile(localTempPath);
            final freshSp = await ref.read(catalogRepositoryProvider).getCatalogItemById(sp.id) ?? sp;
            final updatedSp = freshSp.copyWith(mainPhotoPath: relPath);
            await ref.read(catalogRepositoryProvider).saveCatalogItem(updatedSp);
            ref.read(catalogListProvider.notifier).loadCatalog();
            if (ctx.mounted) {
              AppToast.showSuccess(ctx, 'Imagen descargada y guardada localmente con éxito.');
            }
            return true;
          } else {
            if (ctx.mounted) {
              AppToast.showError(ctx, 'No se pudo descargar automáticamente la imagen. Puedes seleccionarla mediante el selector de medios.');
              final picked = await StandardMediaPickerSheet.show(
                ctx,
                title: 'Foto de ${sp.name}',
                webSearchQuery: sp.name,
                allowDocuments: false,
              );
              if (picked != null) {
                final relPath = picked.file != null
                    ? await fileStorage.saveFile(picked.file!.path)
                    : picked.relativeStoredPath;
                if (relPath != null) {
                  final freshSp = await ref.read(catalogRepositoryProvider).getCatalogItemById(sp.id) ?? sp;
                  final updatedSp = freshSp.copyWith(mainPhotoPath: relPath);
                  await ref.read(catalogRepositoryProvider).saveCatalogItem(updatedSp);
                  ref.invalidate(catalogListProvider);
                  return true;
                }
              }
              return false;
            }
          }
          return false;
        },
      ));
    }

    // Subspecies with remote images
    final remoteImageSubspecies = context.allSubspecies.where((s) =>
      s.photoPath != null &&
      (s.photoPath!.startsWith('http://') || s.photoPath!.startsWith('https://'))
    );
    for (final sub in remoteImageSubspecies) {
      final parentSpecies = context.allCatalog.where((c) => c.id == sub.speciesId).firstOrNull;
      cards.add(AuditCardData(
        id: 'sub_remote_${sub.id}',
        type: AuditCardType.remoteImageAudit,
        title: 'Imagen de Subespecie No Local (URL Remota)',
        subtitle: '${sub.subspeciesName} • ${parentSpecies?.name ?? ""}',
        question: 'La subespecie "${sub.subspeciesName}" tiene una imagen referenciada desde una URL remota de Internet. ¿Deseas descargarla y guardarla localmente en el dispositivo?',
        icon: Icons.cloud_download_outlined,
        themeColor: Colors.indigo,
        subspecies: sub,
        species: parentSpecies,
        tile: SubspeciesTile(subspecies: sub, speciesName: parentSpecies?.name ?? ''),
        onConfirm: (ctx, ref) async {
          if (ctx.mounted) {
            AppToast.showSuccess(ctx, 'Imagen remota conservada sin descargar.');
          }
          return true;
        },
        onFix: (ctx, ref) async {
          final lookupService = ref.read(productLookupServiceProvider);
          final fileStorage = ref.read(fileStorageServiceProvider);
          final localTempPath = await lookupService.downloadAndSaveImage(sub.photoPath!);
          if (localTempPath != null) {
            final relPath = await fileStorage.saveFile(localTempPath);
            final freshSub = await ref.read(catalogRepositoryProvider).getSubspeciesById(sub.id) ?? sub;
            final updatedSub = freshSub.copyWith(photoPath: relPath);
            await ref.read(catalogRepositoryProvider).saveSubspecies(updatedSub);
            ref.invalidate(subspeciesListProvider);
            if (ctx.mounted) {
              AppToast.showSuccess(ctx, 'Imagen descargada y guardada localmente con éxito.');
            }
            return true;
          } else {
            if (ctx.mounted) {
              AppToast.showError(ctx, 'No se pudo descargar automáticamente la imagen. Puedes seleccionarla mediante el selector de medios.');
              final picked = await StandardMediaPickerSheet.show(
                ctx,
                title: 'Foto de ${sub.subspeciesName}',
                webSearchQuery: sub.subspeciesName,
                allowDocuments: false,
              );
              if (picked != null) {
                final relPath = picked.file != null
                    ? await fileStorage.saveFile(picked.file!.path)
                    : picked.relativeStoredPath;
                if (relPath != null) {
                  final freshSub = await ref.read(catalogRepositoryProvider).getSubspeciesById(sub.id) ?? sub;
                  final updatedSub = freshSub.copyWith(photoPath: relPath);
                  await ref.read(catalogRepositoryProvider).saveSubspecies(updatedSub);
                  ref.invalidate(subspeciesListProvider);
                  return true;
                }
              }
              return false;
            }
          }
          return false;
        },
      ));
    }

    return cards;
  }
}
