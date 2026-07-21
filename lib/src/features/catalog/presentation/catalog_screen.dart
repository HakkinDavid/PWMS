import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/units_registry.dart';
import '../../../core/providers/providers.dart';
import '../../entities/presentation/instantiate_species_sheet.dart';
import '../domain/catalog_item.dart';
import 'species_tile.dart';

class CatalogScreen extends ConsumerWidget {
  const CatalogScreen({super.key});

  void _showCreateSpeciesModal(BuildContext context, WidgetRef ref) {
    final nameCtrl = TextEditingController();
    final brandCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final barcodeCtrl = TextEditingController();
    String type = AppStrings.typeObject;
    String defaultUnit = UnitsRegistry.countingUnits.first;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final theme = Theme.of(ctx);
        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 16,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                const SizedBox(height: 16),
                Text(
                  AppStrings.createSpeciesHeader,
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: nameCtrl,
                  autofocus: true,
                  decoration: const InputDecoration(
                    labelText: AppStrings.nameLabel,
                    prefixIcon: Icon(Icons.auto_awesome),
                  ),
                ),
                const SizedBox(height: 12),

                // SI Unit Dropdown Selector
                DropdownButtonFormField<String>(
                  initialValue: defaultUnit,
                  decoration: const InputDecoration(
                    labelText: AppStrings.unitLabel,
                    prefixIcon: Icon(Icons.straighten),
                  ),
                  items: UnitsRegistry.allSiUnits
                      .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) defaultUnit = val;
                  },
                ),
                const SizedBox(height: 12),

                TextField(
                  controller: brandCtrl,
                  decoration: const InputDecoration(
                    labelText: AppStrings.brandLabel,
                    prefixIcon: Icon(Icons.branding_watermark),
                  ),
                ),
                const SizedBox(height: 12),

                TextField(
                  controller: barcodeCtrl,
                  decoration: const InputDecoration(
                    labelText: AppStrings.barcodeLabel,
                    prefixIcon: Icon(Icons.qr_code),
                  ),
                ),
                const SizedBox(height: 12),

                TextField(
                  controller: descCtrl,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: AppStrings.descriptionLabel,
                    prefixIcon: Icon(Icons.notes),
                  ),
                ),
                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      final name = nameCtrl.text.trim();
                      if (name.isEmpty) return;

                      final item = CatalogItem(
                        id: const Uuid().v4(),
                        name: name,
                        type: type,
                        brand: brandCtrl.text.trim().isNotEmpty ? brandCtrl.text.trim() : null,
                        description: descCtrl.text.trim().isNotEmpty ? descCtrl.text.trim() : null,
                        barcode: barcodeCtrl.text.trim().isNotEmpty ? barcodeCtrl.text.trim() : null,
                        defaultUnit: defaultUnit,
                        createdAt: DateTime.now(),
                      );

                      await ref.read(catalogListProvider.notifier).saveCatalogItem(item);
                      if (ctx.mounted) Navigator.pop(ctx);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text(AppStrings.saveSpeciesAction, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalogState = ref.watch(catalogListProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.catalogTitle),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateSpeciesModal(context, ref),
        icon: const Icon(Icons.add_circle_outline),
        label: const Text(AppStrings.newSpeciesTitle),
      ),
      body: catalogState.when(
        data: (items) {
          if (items.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.public, size: 64, color: theme.colorScheme.primary.withAlpha(120)),
                    const SizedBox(height: 16),
                    Text(
                      AppStrings.emptyCatalog,
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return SpeciesTile(
                species: item,
                onInstantiate: () {
                  // Pure instantiation: quantity & location ONLY!
                  InstantiateSpeciesSheet.show(
                    context,
                    species: item,
                  );
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
