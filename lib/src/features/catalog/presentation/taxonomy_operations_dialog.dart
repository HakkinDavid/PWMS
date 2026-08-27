import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import '../../../core/providers/providers.dart';
import '../../../core/widgets/app_toast.dart';
import '../../../core/widgets/app_wheel_picker.dart';
import '../domain/catalog_item.dart';
import '../domain/subspecies.dart';

class TaxonomyOperationsDialog {
  TaxonomyOperationsDialog._();

  /// 2a. Unir Especie Origen en Especie Destino
  static Future<void> showMergeSpeciesDialog(BuildContext context, WidgetRef ref, CatalogItem sourceSpecies) async {
    final catalog = ref.read(catalogListProvider).asData?.value ?? [];
    final targetOptions = catalog.where((c) => c.id != sourceSpecies.id).toList();

    if (targetOptions.isEmpty) {
      AppToast.showRestriction(context, AppStrings.noOtherSpeciesToMergeError);
      return;
    }

    CatalogItem? selectedTarget = targetOptions.first;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              scrollable: true,
              title: const Text(AppStrings.mergeSpeciesDialogTitle),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.mergeSpeciesDescription(sourceSpecies.name),
                    style: const TextStyle(fontSize: 13),
                  ),
                  const SizedBox(height: 16),
                  AppWheelPickerField<CatalogItem>(
                    value: selectedTarget,
                    items: targetOptions,
                    labelBuilder: (c) => c.name,
                    title: AppStrings.targetSpeciesFormLabel,
                    decoration: const InputDecoration(
                      labelText: AppStrings.targetSpeciesFormLabel,
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (val) => setState(() => selectedTarget = val),
                  ),
                ],
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text(AppStrings.cancel)),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.amber.shade800, foregroundColor: Colors.white),
                  onPressed: () => Navigator.pop(ctx, true),
                  child: const Text(AppStrings.mergeSpeciesAction),
                ),
              ],
            );
          },
        );
      },
    );

    if (confirm == true && selectedTarget != null) {
      try {
        final repo = ref.read(catalogRepositoryProvider);
        await repo.mergeSpecies(sourceSpecies.id, selectedTarget!.id);
        ref.read(catalogListProvider.notifier).loadCatalog();
        ref.read(entityListProvider.notifier).loadEntities();
        if (context.mounted) {
          AppToast.showSuccess(context, AppStrings.speciesMergedSuccess(sourceSpecies.name, selectedTarget!.name));
        }
      } catch (e) {
        if (context.mounted) AppToast.showError(context, AppStrings.mergeSpeciesError(e.toString()));
      }
    }
  }

  /// 2b. Separar Subespecie en una nueva Especie
  static Future<void> showSeparateSubspeciesDialog(BuildContext context, WidgetRef ref, Subspecies subspecies) async {
    final nameCtrl = TextEditingController(text: AppStrings.newSpeciesDefaultName(subspecies.subspeciesName));

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          scrollable: true,
          title: const Text(AppStrings.separateInNewSpeciesDialogTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.separateSubspeciesDescription(subspecies.subspeciesName),
                style: const TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameCtrl,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: AppStrings.newSpeciesNameFormLabel,
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text(AppStrings.cancel)),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text(AppStrings.separateAction),
            ),
          ],
        );
      },
    );

    if (confirm == true && nameCtrl.text.trim().isNotEmpty) {
      try {
        final repo = ref.read(catalogRepositoryProvider);
        final newSpecies = await repo.separateSubspecies(subspecies.id, nameCtrl.text.trim());
        ref.read(catalogListProvider.notifier).loadCatalog();
        ref.read(entityListProvider.notifier).loadEntities();
        if (context.mounted) {
          AppToast.showSuccess(context, AppStrings.subspeciesSeparatedSuccess(newSpecies.name));
        }
      } catch (e) {
        if (context.mounted) AppToast.showError(context, AppStrings.separateSubspeciesError(e));
      }
    }
  }

  /// 2c. Mover Subespecie a otra Especie existente
  static Future<void> showMoveSubspeciesDialog(BuildContext context, WidgetRef ref, Subspecies subspecies) async {
    final catalog = ref.read(catalogListProvider).asData?.value ?? [];
    final targetOptions = catalog.where((c) => c.id != subspecies.speciesId).toList();

    if (targetOptions.isEmpty) {
      AppToast.showRestriction(context, AppStrings.noOtherSpeciesToMoveError);
      return;
    }

    CatalogItem? selectedTarget = targetOptions.first;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              scrollable: true,
              title: const Text(AppStrings.moveSubspeciesTitle),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.moveSubspeciesDescription(subspecies.subspeciesName),
                    style: const TextStyle(fontSize: 13),
                  ),
                  const SizedBox(height: 16),
                  AppWheelPickerField<CatalogItem>(
                    value: selectedTarget,
                    items: targetOptions,
                    labelBuilder: (c) => c.name,
                    title: AppStrings.targetSpeciesLabel,
                    decoration: const InputDecoration(
                      labelText: AppStrings.targetSpeciesLabel,
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (val) => setState(() => selectedTarget = val),
                  ),
                ],
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text(AppStrings.cancel)),
                ElevatedButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  child: const Text(AppStrings.moveSubspeciesTitle),
                ),
              ],
            );
          },
        );
      },
    );

    if (confirm == true && selectedTarget != null) {
      try {
        final repo = ref.read(catalogRepositoryProvider);
        await repo.moveSubspecies(subspecies.id, selectedTarget!.id);
        ref.read(catalogListProvider.notifier).loadCatalog();
        ref.read(entityListProvider.notifier).loadEntities();
        if (context.mounted) {
          AppToast.showSuccess(context, AppStrings.subspeciesMovedSuccess(selectedTarget!.name));
        }
      } catch (e) {
        if (context.mounted) AppToast.showError(context, AppStrings.moveSubspeciesError(e));
      }
    }
  }
}
