import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import '../../../core/domain/domain_rules.dart';
import '../../../core/providers/providers.dart';
import '../../../core/router/app_navigation_extension.dart';
import '../../../core/widgets/app_toast.dart';
import '../../entities/presentation/instantiate_species_sheet.dart';
import '../../locations/domain/location_path_helper.dart';
import 'species_detail_view.dart';
import 'species_form_modal.dart';
import 'subspecies_section_widget.dart';

class SpeciesDetailScreen extends ConsumerStatefulWidget {
  final String speciesId;

  const SpeciesDetailScreen({super.key, required this.speciesId});

  @override
  ConsumerState<SpeciesDetailScreen> createState() => _SpeciesDetailScreenState();
}

class _SpeciesDetailScreenState extends ConsumerState<SpeciesDetailScreen> {
  bool _isEditing = false;

  @override
  Widget build(BuildContext context) {
    final catalogState = ref.watch(catalogListProvider);
    final entitiesState = ref.watch(entityListProvider);
    final locationsState = ref.watch(locationNodeListProvider);
    final theme = Theme.of(context);

    return catalogState.when(
      skipLoadingOnRefresh: true,
      skipLoadingOnReload: true,
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
                AppStrings.masterCatalogSpeciesBadge,
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
              species.isUnique ? AppStrings.locationLabel : '${AppStrings.tabEntities} (${instances.length})',
              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            if (instances.isEmpty)
              const Text(AppStrings.notInstantiatedYet, style: TextStyle(color: Colors.grey, fontSize: 12))
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
                      ? ((firstMag.unitSymbol != null && firstMag.unitSymbol!.trim().isNotEmpty)
                          ? '${AppStrings.quantityLabel}: ${DomainRules.formatMagnitude(firstMag.magnitudeValue, firstMag.unitSymbol)} ${firstMag.unitSymbol}'
                          : '${AppStrings.quantityLabel}: ${firstMag.displayValue}')
                      : AppStrings.registeredInstance;

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
                        context.pushEntityDetail(inst.id);
                      },
                    ),
                  );
                },
              ),
            const SizedBox(height: 16),
            SubspeciesSectionWidget(speciesId: species.id, isEditing: _isEditing),
            const SizedBox(height: 16),
          ],
        );

        return Scaffold(
          body: SpeciesDetailView(
            species: species,
            showAttachmentAction: _isEditing,
            instanceSpecificsHeader: locationsSummaryHeader,
            actions: [
              IconButton(
                icon: Icon(_isEditing ? Icons.check : Icons.edit_outlined),
                tooltip: _isEditing ? AppStrings.saveChangesAction : AppStrings.edit,
                onPressed: () {
                  setState(() => _isEditing = !_isEditing);
                },
              ),
              if (_isEditing) ...[
                IconButton(
                  icon: const Icon(Icons.settings_outlined),
                  tooltip: AppStrings.editSpeciesTitle,
                  onPressed: () {
                    SpeciesFormModal.show(context, initialSpecies: species);
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.delete_outline,
                    color: hasExistingInstance ? Colors.grey.shade400 : Colors.redAccent,
                  ),
                  tooltip: hasExistingInstance
                      ? AppStrings.cannotDeleteSpeciesWithInstancesError
                      : AppStrings.delete,
                  onPressed: hasExistingInstance
                      ? () {
                          AppToast.showRestriction(context, AppStrings.cannotDeleteSpeciesWithInstancesError);
                        }
                      : () async {
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
                            try {
                              await ref.read(catalogListProvider.notifier).deleteCatalogItem(species.id);
                              if (context.mounted) context.pop();
                            } catch (e) {
                              if (context.mounted) {
                                AppToast.showError(context, e.toString().replaceAll('Exception: ', ''));
                              }
                            }
                          }
                        },
                ),
              ],
            ],
          ),

          // Hide Instanciar button if species is unique and already has an instance
          floatingActionButton: (species.isUnique && hasExistingInstance)
              ? null
              : FloatingActionButton(
                  heroTag: null,
                  onPressed: () {
                    InstantiateSpeciesSheet.show(context, species: species);
                  },
                  tooltip: AppStrings.instantiateAction,
                  child: const Icon(Icons.add),
                ),
        );
      },
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, _) => Scaffold(body: Center(child: Text('${AppStrings.errorPrefix}$err'))),
    );
  }
}
