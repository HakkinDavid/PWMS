import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/providers/providers.dart';
import '../../../core/widgets/app_toast.dart';
import '../../../core/widgets/integer_wheel_picker.dart';
import '../../catalog/domain/catalog_item.dart';
import '../../catalog/domain/subspecies.dart';
import '../../locations/presentation/location_tree_picker.dart';
import '../../relations/domain/entity_relation.dart';
import '../domain/entity_display_helper.dart';
import '../domain/entity_template.dart';
import '../../../core/domain/property_data_type.dart';
import '../domain/instance_magnitude.dart';

class InstantiateSpeciesSheet extends ConsumerStatefulWidget {
  final CatalogItem? species;
  final String? initialLocationId;
  final Subspecies? initialSubspecies;
  final Map<String, double>? initialMagnitudeValues;
  final String? initialNotes;
  final String? secondaryPhotoPath;

  const InstantiateSpeciesSheet({
    super.key,
    this.species,
    this.initialLocationId,
    this.initialSubspecies,
    this.initialMagnitudeValues,
    this.initialNotes,
    this.secondaryPhotoPath,
  });

  static Future<void> show(
    BuildContext context, {
    CatalogItem? species,
    String? initialLocationId,
    Subspecies? initialSubspecies,
    Map<String, double>? initialMagnitudeValues,
    String? initialNotes,
    String? secondaryPhotoPath,
  }) {
    return showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => InstantiateSpeciesSheet(
        species: species,
        initialLocationId: initialLocationId,
        initialSubspecies: initialSubspecies,
        initialMagnitudeValues: initialMagnitudeValues,
        initialNotes: initialNotes,
        secondaryPhotoPath: secondaryPhotoPath,
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
  DateTime? _expirationDate;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _selectedLocationId = widget.initialLocationId;
    if (widget.initialNotes != null && widget.initialNotes!.isNotEmpty) {
      _notesController.text = widget.initialNotes!;
    }
    if (widget.species != null) {
      _onSpeciesSelected(widget.species!);
    }
  }

  void _onSpeciesSelected(CatalogItem species) {
    setState(() {
      _selectedSpecies = species;
      _selectedSubspecies = widget.initialSubspecies;
      _availableSubspecies = [];
      _magnitudeControllers.clear();

      if (species.canExpire && species.defaultShelfLifeDays != null && species.defaultShelfLifeDays! > 0) {
        _expirationDate = DateTime.now().add(Duration(days: species.defaultShelfLifeDays!));
      } else {
        _expirationDate = null;
      }

      for (final mag in species.magnitudes) {
        final prefilledVal = widget.initialMagnitudeValues?[mag.propertyName];
        final initialText = prefilledVal != null
            ? (prefilledVal == prefilledVal.roundToDouble() ? prefilledVal.toInt().toString() : prefilledVal.toString())
            : '';
        _magnitudeControllers[mag.propertyName] = TextEditingController(text: initialText);
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
          if (widget.initialSubspecies != null) {
            final match = list.where((s) => s.id == widget.initialSubspecies!.id).firstOrNull;
            _selectedSubspecies = match ?? widget.initialSubspecies;
            if (match == null && widget.initialSubspecies != null) {
              _availableSubspecies = [widget.initialSubspecies!, ...list];
            }
          } else if (list.isNotEmpty) {
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
      AppToast.showRestriction(context, AppStrings.selectSpeciesToInstantiate);
      return;
    }

    if (_selectedSubspecies == null) {
      AppToast.showRestriction(context, AppStrings.selectSubspeciesOrBrandPrompt);
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
          AppToast.showRestriction(context, AppStrings.singleInstanceSubspeciesError);
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

      // Build specific instance magnitudes with explicit property names & primitive data types
      if (species.magnitudes.isNotEmpty) {
        final List<InstanceMagnitude> customInstanceMags = [];
        for (final sm in species.magnitudes) {
          final ctrl = _magnitudeControllers[sm.propertyName];
          final rawText = ctrl?.text.trim() ?? '';
          final type = PropertyDataType.fromCode(sm.dataType);

          double magVal = 0.0;
          String? strVal;

          if (type.isNumeric) {
            final parsedVal = double.tryParse(rawText) ?? 1.0;
            magVal = parsedVal * addQty;
          } else {
            strVal = rawText;
          }

          customInstanceMags.add(InstanceMagnitude(
            id: const Uuid().v4(),
            instanceId: result.id,
            propertyName: sm.propertyName,
            dataType: sm.dataType,
            magnitudeValue: magVal,
            stringValue: strVal,
            unitSymbol: type.isNumeric ? sm.unitSymbol : null,
          ));
        }

        final updatedWithMags = result.copyWith(magnitudes: customInstanceMags);
        await entityRepo.saveEntity(updatedWithMags);
      }

      if (widget.secondaryPhotoPath != null && widget.secondaryPhotoPath!.isNotEmpty) {
        final catalogRepo = ref.read(catalogRepositoryProvider);
        await catalogRepo.addAttachment(
          speciesId: species.id,
          instanceId: result.id,
          filePath: widget.secondaryPhotoPath!,
          fileName: 'Reverso_${species.name}.jpg',
          fileType: 'image',
        );
        ref.invalidate(instanceAttachmentsProvider(result.id));
        ref.invalidate(speciesAttachmentsProvider(species.id));
      }

      if (_expirationDate != null) {
        final currentEntity = await entityRepo.getEntityById(result.id) ?? result;
        final updatedWithExp = currentEntity.copyWith(expirationDate: _expirationDate);
        await entityRepo.saveEntity(updatedWithExp);
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
        AppToast.showSuccess(
          context,
          '${AppStrings.speciesInstantiatedSuccess}: "${species.name}"',
        );
      }
    } catch (e) {
      if (mounted) {
        AppToast.showError(context, '${AppStrings.errorPrefix}$e');
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

    final mediaQuery = MediaQuery.of(context);
    final bottomPadding = mediaQuery.viewInsets.bottom > 0
        ? mediaQuery.viewInsets.bottom + 20
        : mediaQuery.padding.bottom + 20;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 16,
        bottom: bottomPadding,
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
              isExpanded: true,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.public),
                hintText: AppStrings.selectSpeciesPrompt,
              ),
              items: catalogItems.map((c) {
                return DropdownMenuItem(
                  value: c.id,
                  child: Text('${c.name} (${c.type})', overflow: TextOverflow.ellipsis),
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
                isExpanded: true,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.branding_watermark),
                  hintText: AppStrings.selectSubspeciesOrBrandPrompt,
                ),
                items: _availableSubspecies.map((sub) {
                  final brandText = sub.brand != null ? ' (${sub.brand})' : '';
                  return DropdownMenuItem(
                    value: sub.id,
                    child: Text('${sub.subspeciesName}$brandText', overflow: TextOverflow.ellipsis),
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
                  final subspeciesState = ref.watch(subspeciesListProvider);
                  final entities = entitiesState.asData?.value ?? [];
                  final subspeciesList = subspeciesState.asData?.value ?? [];

                  if (entities.isEmpty) {
                    return const Text(AppStrings.noContainerObjectsAvailable);
                  }
                  return DropdownButtonFormField<String>(
                    initialValue: _selectedContainerEntityId,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.inventory_2_outlined),
                      hintText: AppStrings.selectContainerObject,
                    ),
                    items: entities.map((e) {
                      final name = EntityDisplayHelper.getDisplayName(
                        entity: e,
                        catalogItems: catalogItems,
                        subspeciesList: subspeciesList,
                      );
                      return DropdownMenuItem(value: e.id, child: Text(name, overflow: TextOverflow.ellipsis));
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
                      final type = PropertyDataType.fromCode(sm.dataType);
                      final labelText = (sm.unitSymbol != null && sm.unitSymbol!.trim().isNotEmpty)
                          ? '${sm.propertyName} (${sm.unitSymbol})'
                          : '${sm.propertyName} (${sm.dataType})';

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: TextField(
                          controller: ctrl,
                          keyboardType: type.isNumeric
                              ? const TextInputType.numberWithOptions(decimal: true)
                              : TextInputType.text,
                          decoration: InputDecoration(
                            labelText: labelText,
                            prefixIcon: Icon(type.isNumeric ? Icons.straighten : Icons.text_fields),
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

            // DatePicker de Caducidad (Solo para especies que pueden caducar)
            if (_selectedSpecies != null && _selectedSpecies!.canExpire) ...[
              Text(AppStrings.expirationDateOptionalLabel, style: theme.textTheme.labelLarge),
              const SizedBox(height: 6),
              InkWell(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _expirationDate ?? DateTime.now().add(const Duration(days: 30)),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() => _expirationDate = picked);
                  }
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.colorScheme.outline.withOpacity(0.5)),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        color: _expirationDate != null ? theme.colorScheme.primary : Colors.grey,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _expirationDate != null
                              ? '${_expirationDate!.day.toString().padLeft(2, '0')}/${_expirationDate!.month.toString().padLeft(2, '0')}/${_expirationDate!.year}'
                              : AppStrings.noExpirationDate,
                          style: TextStyle(
                            color: _expirationDate != null ? theme.colorScheme.onSurface : Colors.grey,
                            fontWeight: _expirationDate != null ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ),
                      if (_expirationDate != null)
                        IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () => setState(() => _expirationDate = null),
                          tooltip: AppStrings.removeExpirationDateTooltip,
                        ),
                    ],
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
