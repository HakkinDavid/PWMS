import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/providers/providers.dart';
import '../../locations/domain/location_path_helper.dart';
import '../../locations/presentation/location_tree_picker.dart';
import '../domain/world_entity.dart';

class EntityTile extends ConsumerWidget {
  final WorldEntity entity;

  const EntityTile({
    super.key,
    required this.entity,
  });

  void _showQuickActionsMenu(BuildContext context, WidgetRef ref, String speciesName) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.visibility),
              title: const Text('Ver detalle de instancia'),
              onTap: () {
                Navigator.pop(ctx);
                context.push('/entity/${entity.id}');
              },
            ),
            ListTile(
              leading: const Icon(Icons.drive_file_move_outlined),
              title: const Text(AppStrings.move),
              onTap: () async {
                Navigator.pop(ctx);
                final newLocationId = await LocationTreePicker.show(context, initialSelectedId: entity.locationId);
                await ref.read(entityRepositoryProvider).moveOrMergeEntity(entity.id, newLocationId);
                ref.read(entityListProvider.notifier).loadEntities();
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.redAccent),
              title: const Text(AppStrings.delete, style: TextStyle(color: Colors.redAccent)),
              onTap: () async {
                Navigator.pop(ctx);
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (c) => AlertDialog(
                    title: const Text(AppStrings.deleteConfirmationTitle),
                    content: Text('${AppStrings.deleteConfirmationMessage} "$speciesName"?'),
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
                  await ref.read(entityRepositoryProvider).deleteEntity(entity.id);
                  ref.read(entityListProvider.notifier).loadEntities();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalogState = ref.watch(catalogListProvider);
    final locationsState = ref.watch(locationNodeListProvider);
    final theme = Theme.of(context);

    final catalogItems = catalogState.asData?.value ?? [];
    final locationNodes = locationsState.asData?.value ?? [];

    final species = catalogItems.where((c) => c.id == entity.speciesId).firstOrNull;
    final name = species?.name ?? AppStrings.typeObject;
    final type = species?.type ?? AppStrings.typeObject;

    final breadcrumb = LocationPathHelper.buildBreadcrumbPath(entity.locationId, locationNodes);

    return Card(
      margin: const EdgeInsets.only(bottom: 6),
      child: InkWell(
        onLongPress: () => _showQuickActionsMenu(context, ref, name),
        onTap: () => context.push('/entity/${entity.id}'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 44,
                  height: 44,
                  color: theme.colorScheme.primary.withAlpha(20),
                  child: FutureBuilder<String>(
                    future: species?.mainPhotoPath != null
                        ? ref.read(fileStorageServiceProvider).getAbsolutePath(species!.mainPhotoPath!)
                        : Future.value(''),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data!.isNotEmpty && File(snapshot.data!).existsSync()) {
                        return Image.file(
                          File(snapshot.data!),
                          fit: BoxFit.cover,
                        );
                      }
                      return Icon(Icons.category, color: theme.colorScheme.primary, size: 22);
                    },
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(Icons.account_tree_outlined, size: 12, color: theme.colorScheme.secondary),
                        const SizedBox(width: 4),
                        Expanded(
                          child: RichText(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                              style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
                              children: [
                                TextSpan(text: '$type • '),
                                if (breadcrumb.ancestorPath.isNotEmpty)
                                  TextSpan(
                                    text: '${breadcrumb.ancestorPath} ',
                                    style: TextStyle(color: theme.colorScheme.secondary.withAlpha(160)),
                                  ),
                                TextSpan(
                                  text: breadcrumb.targetName,
                                  style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (entity.quantity != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        'Magnitud: ${entity.quantity} ${entity.unit ?? species?.defaultUnit ?? ""}',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
