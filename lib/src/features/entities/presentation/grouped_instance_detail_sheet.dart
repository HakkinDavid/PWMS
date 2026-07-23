import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/providers/providers.dart';
import '../../locations/domain/location_path_helper.dart';
import '../domain/effective_entity_group.dart';
import 'instance_preview_card.dart';
import 'quantity_operation_helper.dart';

class GroupedInstanceDetailSheet extends ConsumerStatefulWidget {
  final EffectiveEntityGroup group;

  const GroupedInstanceDetailSheet({super.key, required this.group});

  static Future<void> show(BuildContext context, EffectiveEntityGroup group) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => GroupedInstanceDetailSheet(group: group),
    );
  }

  @override
  ConsumerState<GroupedInstanceDetailSheet> createState() => _GroupedInstanceDetailSheetState();
}

class _GroupedInstanceDetailSheetState extends ConsumerState<GroupedInstanceDetailSheet> {
  @override
  Widget build(BuildContext context) {
    final catalogState = ref.watch(catalogListProvider);
    final locationsState = ref.watch(locationNodeListProvider);
    final theme = Theme.of(context);

    final catalogItems = catalogState.asData?.value ?? [];
    final locationNodes = locationsState.asData?.value ?? [];

    final species = catalogItems.where((c) => c.id == widget.group.speciesId).firstOrNull;
    final name = species?.name ?? AppStrings.typeObject;
    final type = species?.type ?? AppStrings.typeObject;

    final breadcrumb = LocationPathHelper.buildBreadcrumbPath(widget.group.effectiveLocationId, locationNodes);

    final majorityArchetype = widget.group.majorityEntity;
    final majorityCount = widget.group.majorityInstances.length;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag Handle
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

          // Header Info
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: SizedBox(
                  width: 56,
                  height: 56,
                  child: FutureBuilder<String>(
                    future: species?.mainPhotoPath != null
                        ? ref.read(fileStorageServiceProvider).getAbsolutePath(species!.mainPhotoPath!)
                        : Future.value(''),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data!.isNotEmpty && File(snapshot.data!).existsSync()) {
                        return Image.file(File(snapshot.data!), fit: BoxFit.cover);
                      }
                      return Container(
                        color: theme.colorScheme.primary.withAlpha(25),
                        child: Icon(Icons.category, color: theme.colorScheme.primary, size: 28),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$type • ${breadcrumb.fullPath}',
                      style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.secondary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Demografía Mayoritaria Banner
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: theme.colorScheme.secondaryContainer.withAlpha(80),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.colorScheme.secondary.withAlpha(60)),
            ),
            child: Row(
              children: [
                Icon(Icons.groups, size: 20, color: theme.colorScheme.secondary),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Demografía Mayoritaria ($majorityCount de ${widget.group.population})',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                      ),
                      Text(
                        majorityArchetype.notes != null && majorityArchetype.notes!.isNotEmpty
                            ? 'Perfil: "${majorityArchetype.notes}"'
                            : 'Perfil estándar de la especie (sin notas diferenciales)',
                        style: TextStyle(fontSize: 10, color: theme.colorScheme.secondary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Interactive Control Panel implementing Rules a), b), and c)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withAlpha(120),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: theme.dividerColor),
            ),
            child: Column(
              children: [
                const Text(
                  'Gestión Dinámica de Población',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  '• Toque corto en -/+: Resta o suma 1 unidad\n• Toque largo en -/+: Activa el WheelPicker\n• Toque en la cifra: Escribe la población objetivo',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 10, color: theme.colorScheme.secondary),
                ),
                const SizedBox(height: 14),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Button [-]
                    GestureDetector(
                      onTap: () => QuantityOperationHelper.removeOne(ref, widget.group),
                      onLongPress: () => QuantityOperationHelper.showWheelPickerModal(context, ref, group: widget.group, isAdd: false),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.withAlpha(25),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.redAccent.withAlpha(100)),
                        ),
                        child: const Icon(Icons.remove, size: 24, color: Colors.redAccent),
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Broad Quantity Display (Broad touch target for direct numeric input)
                    InkWell(
                      onTap: () => QuantityOperationHelper.showDirectNumericInputDialog(context, ref, group: widget.group),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: theme.colorScheme.primary.withAlpha(100), width: 1.5),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  '${widget.group.population}',
                                  style: theme.textTheme.headlineMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.onPrimaryContainer,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Icon(Icons.edit_note, size: 18, color: theme.colorScheme.primary),
                              ],
                            ),
                            Text(
                              'Población',
                              style: TextStyle(fontSize: 10, color: theme.colorScheme.onPrimaryContainer.withAlpha(180)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Button [+]
                    GestureDetector(
                      onTap: () => QuantityOperationHelper.addOne(ref, widget.group),
                      onLongPress: () => QuantityOperationHelper.showWheelPickerModal(context, ref, group: widget.group, isAdd: true),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green.withAlpha(25),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.green.withAlpha(100)),
                        ),
                        child: const Icon(Icons.add, size: 24, color: Colors.green),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          Text(
            'Detalle de Instancias en el Grupo (${widget.group.population})',
            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          // Individual Instance Cards List
          Expanded(
            child: ListView.builder(
              itemCount: widget.group.entities.length,
              itemBuilder: (context, index) {
                final entity = widget.group.entities[index];
                return InstancePreviewCard(
                  entity: entity,
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/entity/${entity.id}');
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                    onPressed: () async {
                      final nav = Navigator.of(context);
                      await ref.read(entityRepositoryProvider).deleteEntity(entity.id);
                      ref.read(entityListProvider.notifier).loadEntities();
                      if (mounted && widget.group.entities.length <= 1) {
                        nav.pop();
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
