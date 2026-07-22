import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/domain/domain_rules.dart';
import '../../../core/providers/providers.dart';
import '../../entities/presentation/instantiate_species_sheet.dart';
import '../../locations/domain/location_path_helper.dart';
import 'species_detail_view.dart';
import 'species_form_modal.dart';

class SpeciesDetailScreen extends ConsumerStatefulWidget {
  final String speciesId;

  const SpeciesDetailScreen({super.key, required this.speciesId});

  @override
  ConsumerState<SpeciesDetailScreen> createState() => _SpeciesDetailScreenState();
}

class _SpeciesDetailScreenState extends ConsumerState<SpeciesDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final catalogState = ref.watch(catalogListProvider);
    final entitiesState = ref.watch(entityListProvider);
    final locationsState = ref.watch(locationNodeListProvider);
    final theme = Theme.of(context);

    return catalogState.when(
      data: (items) {
        final species = items.where((c) => c.id == widget.speciesId).firstOrNull;
        if (species == null) {
          return const Scaffold(
            body: Center(child: Text(AppStrings.emptyCatalog)),
          );
        }

        final allEntities = entitiesState.asData?.value ?? [];
        final locationNodes = locationsState.asData?.value ?? [];
        final instances = allEntities.where((e) => e.speciesId == species.id).toList();
        final hasExistingInstance = instances.isNotEmpty;

        // World Instance Locations Summary Card for this Species
        final locationsSummaryHeader = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Distinct Species Header Badge
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
              species.isUnique ? 'Ubicación' : 'Instancias en el Mundo (${instances.length})',
              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            if (instances.isEmpty)
              const Text('Esta especie aún no ha sido instanciada en tu mundo.', style: TextStyle(color: Colors.grey, fontSize: 12))
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: instances.length,
                itemBuilder: (ctx, idx) {
                  final inst = instances[idx];
                  final breadcrumb = LocationPathHelper.buildBreadcrumbPath(inst.locationId, locationNodes);
                  final firstMag = inst.magnitudes.isNotEmpty ? inst.magnitudes.first : null;
                  final magText = firstMag != null
                      ? 'Magnitud: ${DomainRules.formatMagnitude(firstMag.magnitudeValue, firstMag.unitSymbol)} ${firstMag.unitSymbol}'
                      : 'Instancia registrada';

                  return Card(
                    margin: const EdgeInsets.only(bottom: 4),
                    elevation: 0.5,
                    child: ListTile(
                      dense: true,
                      visualDensity: VisualDensity.compact,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                      leading: Icon(Icons.location_on, color: theme.colorScheme.primary, size: 18),
                      title: Text(
                        '${breadcrumb.ancestorPath} ${breadcrumb.targetName}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                      ),
                      subtitle: Text(
                        magText,
                        style: const TextStyle(fontSize: 10),
                      ),
                      trailing: const Icon(Icons.chevron_right, size: 16),
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
                onPressed: () {
                  SpeciesFormModal.show(context, initialSpecies: species);
                },
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

          // Hide Instanciar button if species is unique and already has an instance
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
