import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/units_registry.dart';
import '../../../core/providers/providers.dart';
import '../../entities/presentation/instantiate_species_sheet.dart';
import '../../locations/domain/location_path_helper.dart';
import '../domain/catalog_item.dart';
import 'species_detail_view.dart';

class SpeciesDetailScreen extends ConsumerWidget {
  final String speciesId;

  const SpeciesDetailScreen({super.key, required this.speciesId});

  void _showEditSpeciesModal(BuildContext context, WidgetRef ref, CatalogItem species) {
    final brandCtrl = TextEditingController(text: species.brand);
    final barcodeCtrl = TextEditingController(text: species.barcode);
    final descCtrl = TextEditingController(text: species.description);
    String defaultUnit = species.defaultUnit ?? UnitsRegistry.countingUnits.first;
    bool isUnique = species.isUnique;
    bool hasMonetaryValue = species.hasMonetaryValue;
    String currency = species.defaultMonetaryCurrency;
    XFile? newImage;

    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final theme = Theme.of(ctx);
        return StatefulBuilder(
          builder: (context, setStateModal) {
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
                      'Editar Especie',
                      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),

                    // Rule #4: Name and Type read-only!
                    Text('Nombre: ${species.name} (no modificable)', style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text('Tipo: ${species.type} (no modificable)', style: TextStyle(color: theme.colorScheme.secondary)),
                    const SizedBox(height: 16),

                    // Photo Picker
                    GestureDetector(
                      onTap: () async {
                        final picker = ImagePicker();
                        final img = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
                        if (img != null) setStateModal(() => newImage = img);
                      },
                      child: Container(
                        height: 80,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: theme.dividerColor),
                        ),
                        child: Center(
                          child: Text(
                            newImage != null ? 'Nueva foto seleccionada' : 'Cambiar foto principal',
                            style: TextStyle(color: theme.colorScheme.primary),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Unique Checkbox
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text(AppStrings.isUniqueLabel),
                      value: isUnique,
                      onChanged: (val) => setStateModal(() => isUnique = val ?? false),
                    ),

                    // Monetary Value Checkbox
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Permitir valor monetario'),
                      value: hasMonetaryValue,
                      onChanged: (val) => setStateModal(() => hasMonetaryValue = val ?? true),
                    ),

                    if (hasMonetaryValue) ...[
                      DropdownButtonFormField<String>(
                        initialValue: currency,
                        decoration: const InputDecoration(labelText: AppStrings.currencyLabel),
                        items: const [
                          DropdownMenuItem(value: 'MXN', child: Text('MXN')),
                          DropdownMenuItem(value: 'USD', child: Text('USD')),
                        ],
                        onChanged: (val) {
                          if (val != null) setStateModal(() => currency = val);
                        },
                      ),
                      const SizedBox(height: 12),
                    ],

                    DropdownButtonFormField<String>(
                      initialValue: defaultUnit,
                      decoration: const InputDecoration(labelText: AppStrings.unitLabel),
                      items: UnitsRegistry.allSiUnits
                          .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) setStateModal(() => defaultUnit = val);
                      },
                    ),
                    const SizedBox(height: 12),

                    TextField(
                      controller: brandCtrl,
                      decoration: const InputDecoration(labelText: AppStrings.brandLabel),
                    ),
                    const SizedBox(height: 12),

                    TextField(
                      controller: barcodeCtrl,
                      decoration: const InputDecoration(labelText: AppStrings.barcodeLabel),
                    ),
                    const SizedBox(height: 12),

                    TextField(
                      controller: descCtrl,
                      maxLines: 2,
                      decoration: const InputDecoration(labelText: AppStrings.descriptionLabel),
                    ),
                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          try {
                            String? photoPath = species.mainPhotoPath;
                            if (newImage != null) {
                              photoPath = await ref.read(fileStorageServiceProvider).saveFile(newImage!.path);
                            }

                            final updated = species.copyWith(
                              brand: brandCtrl.text.trim().isNotEmpty ? brandCtrl.text.trim() : null,
                              barcode: barcodeCtrl.text.trim().isNotEmpty ? barcodeCtrl.text.trim() : null,
                              description: descCtrl.text.trim().isNotEmpty ? descCtrl.text.trim() : null,
                              defaultUnit: defaultUnit,
                              isUnique: isUnique,
                              hasMonetaryValue: hasMonetaryValue,
                              defaultMonetaryCurrency: currency,
                              mainPhotoPath: photoPath,
                            );

                            await ref.read(catalogListProvider.notifier).saveCatalogItem(updated);
                            if (ctx.mounted) Navigator.pop(ctx);
                          } catch (e) {
                            if (ctx.mounted) {
                              ScaffoldMessenger.of(ctx).showSnackBar(
                                SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: const Text(AppStrings.save, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalogState = ref.watch(catalogListProvider);
    final entitiesState = ref.watch(entityListProvider);
    final locationsState = ref.watch(locationNodeListProvider);
    final theme = Theme.of(context);

    return catalogState.when(
      data: (items) {
        final species = items.where((c) => c.id == speciesId).firstOrNull;
        if (species == null) {
          return const Scaffold(
            body: Center(child: Text(AppStrings.emptyCatalog)),
          );
        }

        final allEntities = entitiesState.asData?.value ?? [];
        final locationNodes = locationsState.asData?.value ?? [];
        final instances = allEntities.where((e) => e.speciesId == species.id).toList();
        final hasExistingInstance = instances.isNotEmpty;

        // Rule #16: World Instance Locations Summary Card for this Species
        final locationsSummaryHeader = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Distinct Species Header Badge (Rule #14)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withAlpha(25),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'ESPECIE DE CATÁLOGO MAESTRO',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 14),

            Text(
              'Instancias en el Mundo (${instances.length})',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (instances.isEmpty)
              const Text('Esta especie aún no ha sido instanciada en tu mundo.', style: TextStyle(color: Colors.grey, fontSize: 13))
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: instances.length,
                itemBuilder: (ctx, idx) {
                  final inst = instances[idx];
                  final breadcrumb = LocationPathHelper.buildBreadcrumbPath(inst.locationId, locationNodes);

                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      dense: true,
                      leading: Icon(Icons.location_on, color: theme.colorScheme.primary, size: 20),
                      title: Text('${breadcrumb.ancestorPath} ${breadcrumb.targetName}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      subtitle: Text('Magnitud: ${inst.quantity ?? 1.0} ${inst.unit ?? species.defaultUnit ?? ""}'),
                      trailing: const Icon(Icons.chevron_right, size: 18),
                      onTap: () {
                        context.push('/entity/${inst.id}');
                      },
                    ),
                  );
                },
              ),
          ],
        );

        return Scaffold(
          body: SpeciesDetailView(
            species: species,
            instanceSpecificsHeader: locationsSummaryHeader,
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                tooltip: AppStrings.edit,
                onPressed: () => _showEditSpeciesModal(context, ref, species),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                tooltip: AppStrings.delete,
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (c) => AlertDialog(
                      title: const Text(AppStrings.deleteConfirmationTitle),
                      content: Text('${AppStrings.deleteConfirmationMessage} "${species.name}"?'),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(c, false), child: const Text(AppStrings.cancel)),
                        TextButton(
                          onPressed: () => Navigator.pop(c, true),
                          child: const Text(AppStrings.delete, style: TextStyle(color: Colors.redAccent)),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    await ref.read(catalogListProvider.notifier).deleteCatalogItem(species.id);
                    if (context.mounted) context.pop();
                  }
                },
              ),
            ],
          ),

          // Rule #18: Hide Instanciar button if species is unique and already has an instance!
          floatingActionButton: (species.isUnique && hasExistingInstance)
              ? null
              : FloatingActionButton(
                  heroTag: 'fab_species_instantiate',
                  onPressed: () {
                    InstantiateSpeciesSheet.show(context, species: species);
                  },
                  tooltip: AppStrings.instantiateAction,
                  child: const Icon(Icons.add),
                ),
        );
      },
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, _) => Scaffold(body: Center(child: Text('Error: $err'))),
    );
  }
}
