import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import '../../../core/providers/providers.dart';
import '../../../core/router/app_navigation_extension.dart';
import '../../entities/presentation/instantiate_species_sheet.dart';
import '../domain/catalog_item.dart';
import 'species_form_modal.dart';

/// Modal bottom sheet for quick actions on a species (View Details, Instantiate, Edit, Delete).
class SpeciesQuickActionsSheet {
  SpeciesQuickActionsSheet._();

  static void show(BuildContext context, WidgetRef ref, CatalogItem species) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      useSafeArea: true,
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.visibility),
              title: const Text(AppStrings.viewSpeciesDetail),
              onTap: () {
                Navigator.pop(ctx);
                context.pushSpeciesDetail(species.id);
              },
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text(AppStrings.instantiateAction),
              onTap: () {
                Navigator.pop(ctx);
                InstantiateSpeciesSheet.show(context, species: species);
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text(AppStrings.editSpeciesTitle),
              onTap: () {
                Navigator.pop(ctx);
                SpeciesFormModal.show(
                  context,
                  initialSpecies: species,
                  onSpeciesSaved: (_) {
                    ref.invalidate(catalogListProvider);
                  },
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.redAccent),
              title: const Text(AppStrings.delete, style: TextStyle(color: Colors.redAccent)),
              onTap: () async {
                Navigator.pop(ctx);
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (c) => AlertDialog(
                    title: const Text(AppStrings.deleteConfirmationTitle),
                    content: Text(AppStrings.confirmDeleteSpeciesNamed(species.name)),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(c, false), child: const Text(AppStrings.cancel)),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(c, true),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                        child: const Text(AppStrings.delete),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  await ref.read(catalogListProvider.notifier).deleteCatalogItem(species.id);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
