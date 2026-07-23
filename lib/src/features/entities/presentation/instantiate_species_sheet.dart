import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/providers/providers.dart';
import '../../../core/widgets/integer_wheel_picker.dart';
import '../../catalog/domain/catalog_item.dart';
import '../../catalog/domain/subspecies.dart';
import '../../locations/presentation/location_tree_picker.dart';
import '../../relations/domain/entity_relation.dart';
import '../domain/entity_template.dart';
import '../domain/instance_magnitude.dart';

class InstantiateSpeciesSheet extends ConsumerStatefulWidget {
  final CatalogItem? species;
  final String? initialLocationId;

  const InstantiateSpeciesSheet({
    super.key,
    this.species,
    this.initialLocationId,
  });

  static Future<void> show(
    BuildContext context, {
    CatalogItem? species,
    String? initialLocationId,
  }) {
    return showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => InstantiateSpeciesSheet(
        species: species,
        initialLocationId: initialLocationId,
      ),
    );
  }

  @override
  ConsumerState<InstantiateSpeciesSheet> createState() => _InstantiateSpeciesSheetState();
}

enum InstantiationLocationMode { physicalNode, containerEntity }

class _InstantiateSpeciesSheetState extends ConsumerState<InstantiateSpeciesSheet> {
  final _qtyController = TextEditingController(text: '1');
  final _notesController = TextEditingController();
  final Map<String, TextEditingController> _magnitudeControllers = {};

  CatalogItem? _selectedSpecies;
  Subspecies? _selectedSubspecies;
  List<Subspecies> _availableSubspecies = [];

  InstantiationLocationMode _locationMode = InstantiationLocationMode.physicalNode;
  String? _selectedLocationId;
  String? _selectedContainerEntityId;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _selectedLocationId = widget.initialLocationId;
    if (widget.species != null) {
      _onSpeciesSelected(widget.species!);
    }
  }

  void _onSpeciesSelected(CatalogItem species) {
    setState(() {
      _selectedSpecies = species;
      _selectedSubspecies = null;
      _availableSubspecies = [];
      _magnitudeControllers.clear();

      for (final mag in species.magnitudes) {
        _magnitudeControllers[mag.propertyName] = TextEditingController(text: '1');
      }
    });

    _loadSubspeciesForSpecies(species.id);
  }

  Future<void> _loadSubspeciesForSpecies(String speciesId) async {
    try {
      final list = await ref.read(catalogRepositoryProvider).getSubspeciesForSpecies(speciesId);
      if (mounted) {
        setState(() {
          _availableSubspecies = list;
          if (list.isNotEmpty) {
            _selectedSubspecies = list.first;
          }
        });
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _qtyController.dispose();
    _notesController.dispose();
    for (final controller in _magnitudeControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _pickLocationFromTree() async {
    final result = await LocationTreePicker.show(context, initialSelectedId: _selectedLocationId);
    if (result != null) {
      setState(() {
        _selectedLocationId = result.locationId;
      });
    }
  }

  Future<void> _confirmInstantiation() async {
    if (_selectedSpecies == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.selectSpeciesToInstantiate)),
      );
      return;
    }

    final species = _selectedSpecies!;
    final template = EntityTemplateRegistry.getTemplate(species.type);

    // Single instance check for non-countable abstract templates or unique species (evaluated PER SUBSPECIES!)
    if (!template.hasQuantity || species.isUnique) {
      final existingEntities = ref.read(entityListProvider).asData?.value ?? [];
      final targetSubId = _selectedSubspecies?.id;
      final alreadyExists = existingEntities.any((e) => e.speciesId == species.id && e.subspeciesId == targetSubId);
      if (alreadyExists) {
        if (mounted) {
          final subName = _selectedSubspecies?.subspeciesName ?? 'Genérica';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('La subespecie "$subName" de esta especie única ya está instanciada en el mundo.'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }
    }

    final double addQty = double.tryParse(_qtyController.text.trim()) ?? 1.0;
    setState(() => _isSaving = true);

    try {
      final entityRepo = ref.read(entityRepositoryProvider);
      final relationRepo = ref.read(relationRepositoryProvider);

      final targetPhysicalLoc = _locationMode == InstantiationLocationMode.physicalNode ? _selectedLocationId : null;

      final result = await entityRepo.instantiateOrMerge(
        species.id,
        targetPhysicalLoc,
        addQty,
        subspeciesId: _selectedSubspecies?.id,
        notes: _notesController.text.trim().isNotEmpty ? _notesController.text.trim() : null,
      );

      // Build specific instance magnitudes with explicit property names
      if (species.magnitudes.isNotEmpty) {
        final List<InstanceMagnitude> customInstanceMags = [];
        for (final sm in species.magnitudes) {
          final ctrl = _magnitudeControllers[sm.propertyName];
          final customVal = ctrl != null ? (double.tryParse(ctrl.text.trim()) ?? 1.0) : 1.0;

          customInstanceMags.add(InstanceMagnitude(
            id: const Uuid().v4(),
            instanceId: result.id,
            propertyName: sm.propertyName,
            magnitudeValue: customVal * addQty,
            unitSymbol: sm.unitSymbol,
          ));
        }

        final updatedWithMags = result.copyWith(magnitudes: customInstanceMags);
        await entityRepo.saveEntity(updatedWithMags);
      }

      // If container mode is selected, create GUARDADO_EN relation
      if (_locationMode == InstantiationLocationMode.containerEntity && _selectedContainerEntityId != null) {
        final rel = EntityRelation(
          id: const Uuid().v4(),
          sourceEntityId: result.id,
          targetEntityId: _selectedContainerEntityId!,
          relationType: 'GUARDADO_EN',
          createdAt: DateTime.now(),
        );
        await relationRepo.addRelation(rel);
      }

      ref.read(entityListProvider.notifier).loadEntities();
      await ref.read(activityLoggerServiceProvider).logEntityCreated(result.id, species.name, species.type);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${AppStrings.speciesInstantiatedSuccess}: "${species.name}"'),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${AppStrings.errorPrefix}$e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final locationsState = ref.watch(locationNodeListProvider);
    final catalogState = ref.watch(catalogListProvider);
    final catalogItems = catalogState.asData?.value ?? [];
    final theme = Theme.of(context);

    final template = _selectedSpecies != null
        ? EntityTemplateRegistry.getTemplate(_selectedSpecies!.type)
        : EntityTemplateRegistry.getTemplate(AppStrings.typeObject);

    String locationDisplayName = AppStrings.rootLocationName;
    if (_selectedLocationId != null) {
      locationsState.whenData((nodes) {
        final found = nodes.where((n) => n.id == _selectedLocationId).firstOrNull;
        if (found != null) locationDisplayName = found.name;
      });
    }

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
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
              _selectedSpecies != null
                  ? '${AppStrings.instantiateAction} "${_selectedSpecies!.name}"'
                  : AppStrings.instantiateCatalogSpeciesHeader,
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // 1. Selector de Especie del Catálogo Maestro
            Text(AppStrings.catalogSpeciesLabel, style: theme.textTheme.labelLarge),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              initialValue: _selectedSpecies?.id,
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
                if (val != null) {
                  final found = catalogItems.where((c) => c.id == val).firstOrNull;
                  if (found != null) {
                    _onSpeciesSelected(found);
                  }
                }
              },
            ),
            const SizedBox(height: 16),

            // 2. Selector de Subespecie
            if (_availableSubspecies.isNotEmpty) ...[
              Text(AppStrings.subspeciesOrBrandCommercialLabel, style: theme.textTheme.labelLarge),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                initialValue: _selectedSubspecies?.id,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.branding_watermark),
                  hintText: AppStrings.selectSubspeciesOrBrandPrompt,
                ),
                items: _availableSubspecies.map((sub) {
                  final brandText = sub.brand != null ? ' (${sub.brand})' : '';
                  return DropdownMenuItem(
                    value: sub.id,
                    child: Text('${sub.subspeciesName}$brandText'),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedSubspecies = _availableSubspecies.where((s) => s.id == val).firstOrNull;
                  });
                },
              ),
              const SizedBox(height: 16),
            ],

            // 3. Segmented Choice: Physical Node vs Container Entity
            SegmentedButton<InstantiationLocationMode>(
              segments: const [
                ButtonSegment(
                  value: InstantiationLocationMode.physicalNode,
                  label: Text(AppStrings.physicalLocation),
                  icon: Icon(Icons.account_tree_outlined),
                ),
                ButtonSegment(
                  value: InstantiationLocationMode.containerEntity,
                  label: Text(AppStrings.savedInContainer),
                  icon: Icon(Icons.inventory_2_outlined),
                ),
              ],
              selected: {_locationMode},
              onSelectionChanged: (set) {
                setState(() => _locationMode = set.first);
              },
            ),
            const SizedBox(height: 16),

            if (_locationMode == InstantiationLocationMode.physicalNode) ...[
              Text(AppStrings.locationLabel, style: theme.textTheme.labelLarge),
              const SizedBox(height: 8),
              InkWell(
                onTap: _pickLocationFromTree,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.dividerColor),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.account_tree_outlined),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          locationDisplayName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                ),
              ),
            ] else ...[
              Text(AppStrings.selectContainerPrompt, style: theme.textTheme.labelLarge),
              const SizedBox(height: 8),
              Consumer(
                builder: (context, ref, _) {
                  final entitiesState = ref.watch(entityListProvider);
                  final entities = entitiesState.asData?.value ?? [];

                  if (entities.isEmpty) {
                    return const Text(AppStrings.noContainerObjectsAvailable);
                  }
                  return DropdownButtonFormField<String>(
                    initialValue: _selectedContainerEntityId,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.inventory_2_outlined),
                      hintText: AppStrings.selectContainerObject,
                    ),
                    items: entities.map((e) {
                      final sp = catalogItems.where((c) => c.id == e.speciesId).firstOrNull;
                      final name = sp?.name ?? AppStrings.containerObjectLabel;
                      return DropdownMenuItem(value: e.id, child: Text(name));
                    }).toList(),
                    onChanged: (val) => setState(() => _selectedContainerEntityId = val),
                  );
                },
              ),
            ],
            const SizedBox(height: 16),

            // 4. Especificar el Nombre de Cada Magnitud Registrada
            if (_selectedSpecies != null && _selectedSpecies!.magnitudes.isNotEmpty) ...[
              Text(AppStrings.magnitudesAndSpecificProps, style: theme.textTheme.labelLarge),
              const SizedBox(height: 8),
              Card(
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: _selectedSpecies!.magnitudes.map((sm) {
                      final ctrl = _magnitudeControllers[sm.propertyName];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: TextField(
                          controller: ctrl,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: InputDecoration(
                            labelText: '${sm.propertyName} (${sm.unitSymbol})',
                            prefixIcon: const Icon(Icons.straighten),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // 5. Instanciación por población (si aplica)
            if (template.hasQuantity && (_selectedSpecies == null || !_selectedSpecies!.isUnique)) ...[
              GestureDetector(
                onTap: () async {
                  final currentVal = (double.tryParse(_qtyController.text.trim()) ?? 1.0).toInt();
                  final picked = await IntegerWheelPicker.show(context, initialValue: currentVal, minValue: 1);
                  if (picked != null) {
                    setState(() => _qtyController.text = '$picked');
                  }
                },
                child: AbsorbPointer(
                  absorbing: true,
                  child: TextField(
                    controller: _qtyController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: AppStrings.quantityToInstantiateLabel,
                      prefixIcon: Icon(Icons.numbers),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Optional Notes
            TextField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: AppStrings.notesLabel,
                prefixIcon: Icon(Icons.notes),
              ),
            ),
            const SizedBox(height: 24),

            // Confirm Instantiation Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _confirmInstantiation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: _isSaving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(AppStrings.instantiateAction, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
