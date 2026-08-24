import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import '../../../core/providers/providers.dart';
import '../../../core/widgets/app_confirmation_dialog.dart';
import '../../../core/widgets/app_toast.dart';
import '../../../core/widgets/app_wheel_picker.dart';
import '../domain/species_requirement.dart';

class RequirementsSectionWidget extends ConsumerStatefulWidget {
  final String sourceId;
  final String sourceType; // 'species' or 'entity'
  final String title;
  final bool isEditing;
  final List<SpeciesRequirement>? overrideRequirements;
  final void Function(List<SpeciesRequirement>)? onRequirementsChanged;

  const RequirementsSectionWidget({
    super.key,
    required this.sourceId,
    this.sourceType = 'species',
    this.title = AppStrings.requirementsTitle,
    this.isEditing = true,
    this.overrideRequirements,
    this.onRequirementsChanged,
  });

  @override
  ConsumerState<RequirementsSectionWidget> createState() => _RequirementsSectionWidgetState();
}

class _RequirementsSectionWidgetState extends ConsumerState<RequirementsSectionWidget> {
  List<SpeciesRequirement> _requirements = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    if (widget.overrideRequirements == null) {
      _loadRequirements();
    } else {
      _isLoading = false;
    }
  }

  @override
  void didUpdateWidget(covariant RequirementsSectionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.overrideRequirements != null) {
      _isLoading = false;
    }
  }

  Future<void> _loadRequirements() async {
    setState(() => _isLoading = true);
    try {
      final reqs = await ref.read(catalogRepositoryProvider).getRequirementsForSource(widget.sourceId);
      if (mounted) setState(() => _requirements = reqs);
    } catch (_) {
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _addRequirementDialog() async {
    final catalogState = ref.read(catalogListProvider);
    final catalogItems = catalogState.asData?.value ?? [];

    if (catalogItems.isEmpty) {
      AppToast.showRestriction(context, AppStrings.noCatalogSpeciesForRequirement);
      return;
    }

    String? selectedSpeciesId = catalogItems.first.id;
    final qtyController = TextEditingController(text: '1');
    final notesController = TextEditingController();

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            scrollable: true,
            title: const Text(AppStrings.addRequirementTitle),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(AppStrings.selectRequiredSpeciesPrompt),
                const SizedBox(height: 12),
                AppWheelPickerField<String>(
                  value: selectedSpeciesId,
                  items: catalogItems.map((c) => c.id).toList(),
                  labelBuilder: (id) => catalogItems.where((c) => c.id == id).firstOrNull?.name ?? id,
                  title: AppStrings.requiredSpeciesLabel,
                  decoration: const InputDecoration(labelText: AppStrings.requiredSpeciesLabel),
                  onChanged: (val) => setState(() => selectedSpeciesId = val),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: qtyController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: AppStrings.quantityRequiredLabel, hintText: AppStrings.quantityRequiredHint),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: notesController,
                  decoration: const InputDecoration(labelText: AppStrings.notesOptionalLabel, hintText: AppStrings.notesRequirementHint),
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text(AppStrings.cancel)),
              ElevatedButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text(AppStrings.save),
              ),
            ],
          );
        },
      ),
    );

    if (confirm == true && selectedSpeciesId != null) {
      final qty = double.tryParse(qtyController.text.trim()) ?? 1.0;
      final newReq = SpeciesRequirement(
        id: const Uuid().v4(),
        sourceId: widget.sourceId,
        sourceType: widget.sourceType,
        requiredSpeciesId: selectedSpeciesId!,
        requiredQuantity: qty,
        notes: notesController.text.trim().isNotEmpty ? notesController.text.trim() : null,
        createdAt: DateTime.now(),
      );

      if (widget.overrideRequirements != null && widget.onRequirementsChanged != null) {
        widget.onRequirementsChanged!([...widget.overrideRequirements!, newReq]);
      } else {
        await ref.read(catalogRepositoryProvider).saveRequirement(newReq);
        _loadRequirements();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final catalogState = ref.watch(catalogListProvider);
    final catalogItems = catalogState.asData?.value ?? [];
    final theme = Theme.of(context);
    final effectiveRequirements = widget.overrideRequirements ?? _requirements;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                widget.title,
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            if (widget.isEditing)
              TextButton.icon(
                onPressed: _addRequirementDialog,
                icon: const Icon(Icons.add, size: 18),
                label: const Text(AppStrings.add),
              ),
          ],
        ),
        const SizedBox(height: 4),

        if (_isLoading)
          const Center(child: Padding(padding: EdgeInsets.all(12), child: CircularProgressIndicator()))
        else if (effectiveRequirements.isEmpty)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withAlpha(80),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, size: 18, color: Colors.grey),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    AppStrings.noRequirementsDefined,
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: effectiveRequirements.length,
            itemBuilder: (context, index) {
              final req = effectiveRequirements[index];
              final reqSpecies = catalogItems.where((c) => c.id == req.requiredSpeciesId).firstOrNull;
              final speciesName = reqSpecies?.name ?? AppStrings.typeObject;
              final formattedQty = req.requiredQuantity % 1 == 0 ? '${req.requiredQuantity.toInt()}' : '${req.requiredQuantity}';

              return Card(
                margin: const EdgeInsets.only(bottom: 6),
                elevation: 0.5,
                child: ListTile(
                  dense: true,
                  leading: CircleAvatar(
                    radius: 16,
                    backgroundColor: theme.colorScheme.primary.withAlpha(25),
                    child: Icon(Icons.shopping_bag_outlined, color: theme.colorScheme.primary, size: 16),
                  ),
                  title: Text(
                    '${AppStrings.needsPrefix} $formattedQty x $speciesName',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  subtitle: req.notes != null ? Text(req.notes!, style: const TextStyle(fontSize: 11)) : null,
                  trailing: widget.isEditing
                      ? IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 18),
                          onPressed: () async {
                            final confirm = await AppConfirmationDialog.showDeleteConfirmation(
                              context: context,
                              title: AppStrings.confirmDeleteRequirementTitle,
                              message: '${AppStrings.confirmDeleteRequirementMessagePrefix}$speciesName${AppStrings.confirmDeleteRequirementMessageSuffix}',
                            );
                            if (!confirm) return;

                            if (widget.overrideRequirements != null && widget.onRequirementsChanged != null) {
                              widget.onRequirementsChanged!(
                                widget.overrideRequirements!.where((r) => r.id != req.id).toList(),
                              );
                            } else {
                              await ref.read(catalogRepositoryProvider).deleteRequirement(req.id);
                              _loadRequirements();
                            }
                          },
                        )
                      : null,
                ),
              );
            },
          ),
      ],
    );
  }
}
