import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/domain/domain_rules.dart';
import '../../../core/providers/providers.dart';
import '../../locations/domain/location_path_helper.dart';
import '../domain/effective_entity_group.dart';

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
  int _selectedQuantity = 1;
  bool _isBusy = false;

  Future<void> _addSelectedQuantity() async {
    if (_selectedQuantity <= 0) return;
    setState(() => _isBusy = true);
    try {
      final archetype = widget.group.majorityEntity;
      for (int i = 0; i < _selectedQuantity; i++) {
        await ref.read(entityRepositoryProvider).instantiateOrMerge(
          archetype.speciesId,
          widget.group.effectiveLocationId,
          1.0,
          notes: archetype.notes,
        );
      }
      ref.read(entityListProvider.notifier).loadEntities();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al instanciar: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isBusy = false);
    }
  }

  Future<void> _removeSelectedQuantity() async {
    if (_selectedQuantity <= 0 || widget.group.entities.isEmpty) return;
    setState(() => _isBusy = true);
    try {
      final targets = widget.group.majorityInstances;
      final toRemoveCount = _selectedQuantity.clamp(1, targets.length);

      for (int i = 0; i < toRemoveCount; i++) {
        await ref.read(entityRepositoryProvider).deleteEntity(targets[i].id);
      }

      ref.read(entityListProvider.notifier).loadEntities();
      if (widget.group.entities.length <= toRemoveCount && mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isBusy = false);
    }
  }

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
              // Total Population Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(
                      '${widget.group.population}',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                    Text(
                      'Población',
                      style: TextStyle(fontSize: 10, color: theme.colorScheme.onPrimaryContainer.withAlpha(180)),
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

          // WheelPicker Container for Elegant Quantity Operations
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withAlpha(120),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: theme.dividerColor),
            ),
            child: Column(
              children: [
                Text(
                  'Selección Masiva con Selector de Rueda (WheelPicker)',
                  style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                // Cupertino WheelPicker
                SizedBox(
                  height: 110,
                  child: CupertinoPicker(
                    itemExtent: 36,
                    scrollController: FixedExtentScrollController(initialItem: 0),
                    onSelectedItemChanged: (index) {
                      setState(() => _selectedQuantity = index + 1);
                    },
                    children: List.generate(100, (idx) {
                      final val = idx + 1;
                      return Center(
                        child: Text(
                          '$val ${val == 1 ? "unidad" : "unidades"}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: _selectedQuantity == val ? FontWeight.bold : FontWeight.normal,
                            color: _selectedQuantity == val ? theme.colorScheme.primary : theme.textTheme.bodyMedium?.color,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 12),

                // Action Buttons for WheelPicker
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _isBusy || widget.group.population == 0 ? null : _removeSelectedQuantity,
                        icon: const Icon(Icons.remove_circle_outline, color: Colors.redAccent, size: 18),
                        label: Text(
                          'Eliminar $_selectedQuantity',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.withAlpha(20),
                          elevation: 0,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _isBusy ? null : _addSelectedQuantity,
                        icon: const Icon(Icons.add_circle_outline, color: Colors.green, size: 18),
                        label: Text(
                          'Añadir $_selectedQuantity',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.withAlpha(20),
                          elevation: 0,
                        ),
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
                final firstMag = entity.magnitudes.isNotEmpty ? entity.magnitudes.first : null;
                final shortId = entity.id.length > 8 ? entity.id.substring(0, 8) : entity.id;

                return Card(
                  margin: const EdgeInsets.only(bottom: 6),
                  child: ExpansionTile(
                    leading: CircleAvatar(
                      radius: 14,
                      backgroundColor: theme.colorScheme.primary.withAlpha(20),
                      child: Text(
                        '#${index + 1}',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
                      ),
                    ),
                    title: Text(
                      'Instancia ID: $shortId',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    subtitle: Text(
                      entity.notes != null && entity.notes!.isNotEmpty
                          ? entity.notes!
                          : (firstMag != null ? 'Magnitud: ${DomainRules.formatMagnitude(firstMag.magnitudeValue, firstMag.unitSymbol)} ${firstMag.unitSymbol}' : 'Sin notas'),
                      style: TextStyle(fontSize: 11, color: theme.colorScheme.secondary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (entity.notes != null) Text('Notas: ${entity.notes}', style: const TextStyle(fontSize: 12)),
                            if (entity.magnitudes.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text(
                                  'Magnitudes: ${entity.magnitudes.map((m) => '${m.propertyName}: ${DomainRules.formatMagnitude(m.magnitudeValue, m.unitSymbol)} ${m.unitSymbol}').join(', ')}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton.icon(
                                  icon: const Icon(Icons.open_in_new, size: 16),
                                  label: const Text('Ver Ficha Completa', style: TextStyle(fontSize: 12)),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    context.push('/entity/${entity.id}');
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                                  onPressed: () async {
                                    await ref.read(entityRepositoryProvider).deleteEntity(entity.id);
                                    ref.read(entityListProvider.notifier).loadEntities();
                                    if (mounted && widget.group.entities.length <= 1) {
                                      Navigator.pop(context);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
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
