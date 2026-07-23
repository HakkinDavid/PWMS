import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/providers/providers.dart';
import '../../catalog/domain/catalog_item.dart';
import '../../catalog/presentation/species_form_modal.dart';
import '../../catalog/presentation/species_tile.dart';
import 'instantiate_species_sheet.dart';

class RegisterObjectModal extends ConsumerStatefulWidget {
  final String? initialLocationId;
  final bool startInCreateSpecies;

  const RegisterObjectModal({
    super.key,
    this.initialLocationId,
    this.startInCreateSpecies = false,
  });

  static Future<void> show(
    BuildContext context, {
    String? initialLocationId,
    bool startInCreateSpecies = false,
  }) {
    return showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => RegisterObjectModal(
        initialLocationId: initialLocationId,
        startInCreateSpecies: startInCreateSpecies,
      ),
    );
  }

  @override
  ConsumerState<RegisterObjectModal> createState() => _RegisterObjectModalState();
}

class _RegisterObjectModalState extends ConsumerState<RegisterObjectModal> {
  bool _isCreatingNewSpecies = false;

  @override
  void initState() {
    super.initState();
    _isCreatingNewSpecies = widget.startInCreateSpecies;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final catalogState = ref.watch(catalogListProvider);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 14,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.82,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.withAlpha(100),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Mode Switcher Chips
            Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    visualDensity: VisualDensity.compact,
                    label: const Center(child: Text(AppStrings.selectFromCatalogChoice)),
                    selected: !_isCreatingNewSpecies,
                    onSelected: (val) {
                      if (val) setState(() => _isCreatingNewSpecies = false);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ChoiceChip(
                    visualDensity: VisualDensity.compact,
                    label: const Center(child: Text(AppStrings.createNewSpeciesChoice)),
                    selected: _isCreatingNewSpecies,
                    onSelected: (val) {
                      if (val) setState(() => _isCreatingNewSpecies = true);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Body: Catalog Browser vs Shared SpeciesFormModal
            Expanded(
              child: _isCreatingNewSpecies
                  ? SpeciesFormModal(
                      onSpeciesSaved: (createdSpecies) {
                        Navigator.pop(context); // Close RegisterObjectModal
                        InstantiateSpeciesSheet.show(
                          context,
                          species: createdSpecies,
                          initialLocationId: widget.initialLocationId,
                        );
                      },
                    )
                  : _buildBrowseCatalogView(context, catalogState),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBrowseCatalogView(BuildContext context, AsyncValue<List<CatalogItem>> catalogState) {
    return catalogState.when(
      data: (items) {
        if (items.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.public, size: 48, color: Colors.grey),
                  const SizedBox(height: 12),
                  const Text(AppStrings.emptyCatalog),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => setState(() => _isCreatingNewSpecies = true),
                    icon: const Icon(Icons.add),
                    label: const Text(AppStrings.createFirstSpeciesAction),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (ctx, idx) {
            final item = items[idx];
            return SpeciesTile(
              species: item,
              onInstantiate: () {
                Navigator.pop(context);
                InstantiateSpeciesSheet.show(
                  context,
                  species: item,
                  initialLocationId: widget.initialLocationId,
                );
              },
              onTap: () {
                Navigator.pop(context);
                InstantiateSpeciesSheet.show(
                  context,
                  species: item,
                  initialLocationId: widget.initialLocationId,
                );
              },
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('${AppStrings.errorPrefix}$err')),
    );
  }
}
