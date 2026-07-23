import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/providers/providers.dart';
import '../../catalog/domain/catalog_item.dart';
import '../../catalog/presentation/species_form_modal.dart';
import '../../catalog/presentation/species_tile.dart';
import 'instantiate_species_sheet.dart';

import '../../catalog/presentation/subspecies_section_widget.dart';

enum RegisterModalMode { selectFromCatalog, createNewSpecies, addSubspeciesToExisting }

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
  late RegisterModalMode _currentMode;
  String? _selectedSpeciesIdForSubspecies;

  @override
  void initState() {
    super.initState();
    _currentMode = widget.startInCreateSpecies ? RegisterModalMode.createNewSpecies : RegisterModalMode.selectFromCatalog;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final catalogState = ref.watch(catalogListProvider);
    final catalogItems = catalogState.asData?.value ?? [];

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
        height: MediaQuery.of(context).size.height * 0.84,
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

            // Fixed 3-way Segmented Control (No horizontal scrolling!)
            SizedBox(
              width: double.infinity,
              child: SegmentedButton<RegisterModalMode>(
                showSelectedIcon: false,
                style: SegmentedButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                segments: const [
                  ButtonSegment(
                    value: RegisterModalMode.selectFromCatalog,
                    label: Text(AppStrings.instantiateTab, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                    icon: Icon(Icons.public, size: 16),
                  ),
                  ButtonSegment(
                    value: RegisterModalMode.createNewSpecies,
                    label: Text(AppStrings.createSpeciesTab, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                    icon: Icon(Icons.add, size: 16),
                  ),
                  ButtonSegment(
                    value: RegisterModalMode.addSubspeciesToExisting,
                    label: Text(AppStrings.addSubspeciesTab, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                    icon: Icon(Icons.branding_watermark, size: 16),
                  ),
                ],
                selected: {_currentMode},
                onSelectionChanged: (set) {
                  setState(() => _currentMode = set.first);
                },
              ),
            ),
            const SizedBox(height: 12),

            // Body: Select from Catalog vs Create Species vs Add Subspecies to Existing
            Expanded(
              child: _currentMode == RegisterModalMode.createNewSpecies
                  ? SpeciesFormModal(
                      onSpeciesSaved: (createdSpecies) {
                        Navigator.pop(context);
                        InstantiateSpeciesSheet.show(
                          context,
                          species: createdSpecies,
                          initialLocationId: widget.initialLocationId,
                        );
                      },
                    )
                  : _currentMode == RegisterModalMode.addSubspeciesToExisting
                      ? _buildAddSubspeciesToExistingView(context, catalogItems)
                      : _buildBrowseCatalogView(context, catalogState),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddSubspeciesToExistingView(BuildContext context, List<CatalogItem> catalogItems) {
    if (catalogItems.isEmpty) {
      return const Center(child: Text(AppStrings.emptyCatalog));
    }

    _selectedSpeciesIdForSubspecies ??= catalogItems.first.id;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppStrings.catalogSpeciesLabel, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            initialValue: _selectedSpeciesIdForSubspecies,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.public),
              hintText: AppStrings.selectSpeciesPrompt,
            ),
            items: catalogItems.map((c) {
              return DropdownMenuItem(
                value: c.id,
                child: Text('${c.name} (${c.type})'),
              );
            }).toList(),
            onChanged: (val) {
              if (val != null) setState(() => _selectedSpeciesIdForSubspecies = val);
            },
          ),
          const SizedBox(height: 16),
          if (_selectedSpeciesIdForSubspecies != null)
            SubspeciesSectionWidget(speciesId: _selectedSpeciesIdForSubspecies!),
        ],
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
                    onPressed: () => setState(() => _currentMode = RegisterModalMode.createNewSpecies),
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
