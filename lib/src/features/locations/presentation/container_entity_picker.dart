import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import '../../../core/providers/providers.dart';
import '../../entities/domain/entity_display_helper.dart';
import '../../entities/domain/world_entity.dart';
import '../../entities/presentation/instance_preview_card.dart';

class ContainerEntityPicker extends ConsumerStatefulWidget {
  final String? initialSelectedId;
  final String? excludeEntityId;
  final ValueChanged<WorldEntity> onSelected;

  const ContainerEntityPicker({
    super.key,
    this.initialSelectedId,
    this.excludeEntityId,
    required this.onSelected,
  });

  /// Shows the container entity picker modal bottom sheet and returns the selected [WorldEntity],
  /// or null if dismissed without selection.
  static Future<WorldEntity?> show(
    BuildContext context, {
    String? initialSelectedId,
    String? excludeEntityId,
  }) {
    return showModalBottomSheet<WorldEntity?>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final theme = Theme.of(ctx);
        final mediaQuery = MediaQuery.of(ctx);
        final bottomPadding = mediaQuery.viewInsets.bottom > 0
            ? mediaQuery.viewInsets.bottom + 20
            : mediaQuery.padding.bottom + 20;

        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 16,
            bottom: bottomPadding,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: mediaQuery.size.height * 0.85,
            ),
            child: ContainerEntityPicker(
              initialSelectedId: initialSelectedId,
              excludeEntityId: excludeEntityId,
              onSelected: (entity) {
                Navigator.pop(ctx, entity);
              },
            ),
          ),
        );
      },
    );
  }

  @override
  ConsumerState<ContainerEntityPicker> createState() => _ContainerEntityPickerState();
}

class _ContainerEntityPickerState extends ConsumerState<ContainerEntityPicker> {
  String? _selectedId;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _selectedId = widget.initialSelectedId;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final entitiesState = ref.watch(entityListProvider);
    final catalogState = ref.watch(catalogListProvider);
    final subspeciesState = ref.watch(subspeciesListProvider);

    final allEntities = entitiesState.asData?.value ?? [];
    final catalogItems = catalogState.asData?.value ?? [];
    final subspeciesList = subspeciesState.asData?.value ?? [];

    final candidateContainers = allEntities.where((e) => e.id != widget.excludeEntityId).toList();

    final query = _searchQuery.trim().toLowerCase();
    final filteredContainers = candidateContainers.where((e) {
      if (query.isEmpty) return true;

      final displayName = EntityDisplayHelper.getDisplayName(
        entity: e,
        catalogItems: catalogItems,
        subspeciesList: subspeciesList,
      ).toLowerCase();
      if (displayName.contains(query)) return true;

      final species = catalogItems.where((c) => c.id == e.speciesId).firstOrNull;
      if (species != null) {
        if (species.name.toLowerCase().contains(query)) return true;
        if (species.type.toLowerCase().contains(query)) return true;
      }

      final subspecies = subspeciesList.where((s) => s.id == e.subspeciesId).firstOrNull;
      if (subspecies != null) {
        if (subspecies.subspeciesName.toLowerCase().contains(query)) return true;
        if ((subspecies.brand ?? '').toLowerCase().contains(query)) return true;
        if ((subspecies.barcode ?? '').toLowerCase().contains(query)) return true;
      }

      if ((e.notes ?? '').toLowerCase().contains(query)) return true;
      if (e.magnitudes.any((m) => m.propertyName.toLowerCase().contains(query) || m.displayValue.toLowerCase().contains(query))) {
        return true;
      }

      return false;
    }).toList();

    return Column(
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                AppStrings.selectContainerObject,
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close),
              tooltip: AppStrings.close,
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: AppStrings.searchContainerHint,
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _searchQuery = '');
                    },
                  )
                : null,
            filled: true,
            isDense: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: theme.dividerColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: theme.dividerColor),
            ),
          ),
          onChanged: (val) => setState(() => _searchQuery = val),
        ),
        const SizedBox(height: 14),
        Expanded(
          child: entitiesState.isLoading
              ? const Center(child: CircularProgressIndicator())
              : candidateContainers.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.inventory_2_outlined, size: 48, color: Colors.grey.shade400),
                          const SizedBox(height: 12),
                          Text(
                            AppStrings.noContainerObjectsAvailable,
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    )
                  : filteredContainers.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.search_off_outlined, size: 48, color: Colors.grey.shade400),
                              const SizedBox(height: 12),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: Text(
                                  AppStrings.noContainersFoundForQuery(_searchQuery),
                                  style: TextStyle(color: Colors.grey.shade600),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          itemCount: filteredContainers.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final candidate = filteredContainers[index];
                            final isSelected = candidate.id == _selectedId;
                            return InstancePreviewCard(
                              entity: candidate,
                              isSelected: isSelected,
                              trailing: isSelected
                                  ? Icon(Icons.check_circle, color: theme.colorScheme.primary)
                                  : const Icon(Icons.chevron_right, size: 18),
                              onTap: () {
                                setState(() => _selectedId = candidate.id);
                                widget.onSelected(candidate);
                              },
                            );
                          },
                        ),
        ),
      ],
    );
  }
}
