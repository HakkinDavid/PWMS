import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/providers/providers.dart';
import '../../../core/widgets/app_toast.dart';
import '../domain/catalog_item.dart';
import '../domain/subspecies.dart';

class TaxonomyOperationsDialog {
  TaxonomyOperationsDialog._();

  /// 2a. Unir Especie Origen en Especie Destino
  static Future<void> showMergeSpeciesDialog(BuildContext context, WidgetRef ref, CatalogItem sourceSpecies) async {
    final catalog = ref.read(catalogListProvider).asData?.value ?? [];
    final targetOptions = catalog.where((c) => c.id != sourceSpecies.id).toList();

    if (targetOptions.isEmpty) {
      AppToast.showRestriction(context, 'No hay otras especies disponibles para fusionar.');
      return;
    }

    CatalogItem? selectedTarget = targetOptions.first;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Unir Especie'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Se fusionará "${sourceSpecies.name}" con otra especie. Todas las subespecies e instancias pertenecerán a la especie destino.',
                    style: const TextStyle(fontSize: 13),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<CatalogItem>(
                    value: selectedTarget,
                    decoration: const InputDecoration(
                      labelText: 'Especie Destino',
                      border: OutlineInputBorder(),
                    ),
                    items: targetOptions.map((c) {
                      return DropdownMenuItem(value: c, child: Text(c.name));
                    }).toList(),
                    onChanged: (val) => setState(() => selectedTarget = val),
                  ),
                ],
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.amber.shade800, foregroundColor: Colors.white),
                  onPressed: () => Navigator.pop(ctx, true),
                  child: const Text('Unir Especies'),
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
          AppToast.showSuccess(context, 'Especie "${sourceSpecies.name}" unida exitosamente en "${selectedTarget!.name}".');
        }
      } catch (e) {
        if (context.mounted) AppToast.showError(context, 'Error al unir especies: $e');
      }
    }
  }

  /// 2b. Separar Subespecie en una nueva Especie
  static Future<void> showSeparateSubspeciesDialog(BuildContext context, WidgetRef ref, Subspecies subspecies) async {
    final nameCtrl = TextEditingController(text: '${subspecies.subspeciesName} (Especie)');

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Separar en Nueva Especie'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'La subespecie "${subspecies.subspeciesName}" se promoverá a una especie independiente.',
                style: const TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameCtrl,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Nombre de la Nueva Especie',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(AppStrings.cancel)),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(AppStrings.separateAction),
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
          AppToast.showSuccess(context, '${AppStrings.subspeciesSeparatedSuccessPrefix}"${newSpecies.name}".');
        }
      } catch (e) {
        if (context.mounted) AppToast.showError(context, '${AppStrings.separateSubspeciesErrorPrefix}$e');
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
              title: Text(AppStrings.moveSubspeciesTitle),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Se moverá la subespecie "${subspecies.subspeciesName}" y sus instancias a la especie seleccionada.',
                    style: const TextStyle(fontSize: 13),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<CatalogItem>(
                    value: selectedTarget,
                    decoration: InputDecoration(
                      labelText: AppStrings.targetSpeciesLabel,
                      border: const OutlineInputBorder(),
                    ),
                    items: targetOptions.map((c) {
                      return DropdownMenuItem(value: c, child: Text(c.name));
                    }).toList(),
                    onChanged: (val) => setState(() => selectedTarget = val),
                  ),
                ],
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(AppStrings.cancel)),
                ElevatedButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  child: Text(AppStrings.moveSubspeciesTitle),
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
          AppToast.showSuccess(context, '${AppStrings.subspeciesMovedSuccessPrefix}"${selectedTarget!.name}".');
        }
      } catch (e) {
        if (context.mounted) AppToast.showError(context, '${AppStrings.moveSubspeciesErrorPrefix}$e');
      }
    }
  }
}
