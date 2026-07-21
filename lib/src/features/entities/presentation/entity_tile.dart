import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/providers/providers.dart';
import '../domain/world_entity.dart';

class EntityTile extends ConsumerWidget {
  final WorldEntity entity;

  const EntityTile({
    super.key,
    required this.entity,
  });

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

    String locationName = AppStrings.rootLocationName;
    if (entity.locationId != null) {
      final found = locationNodes.where((n) => n.id == entity.locationId).firstOrNull;
      if (found != null) locationName = found.name;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 50,
            height: 50,
            color: theme.colorScheme.primary.withAlpha(25),
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
                return Icon(Icons.category, color: theme.colorScheme.primary);
              },
            ),
          ),
        ),
        title: Text(
          name,
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.account_tree_outlined, size: 14, color: theme.colorScheme.secondary),
                const SizedBox(width: 4),
                Text('$type • $locationName', style: TextStyle(color: theme.colorScheme.secondary, fontSize: 12)),
              ],
            ),
            if (entity.quantity != null) ...[
              const SizedBox(height: 4),
              Text(
                'Cantidad: ${entity.quantity} ${entity.unit ?? species?.defaultUnit ?? ""}',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
            if (entity.notes != null && entity.notes!.isNotEmpty) ...[
              const SizedBox(height: 2),
              Text(
                'Nota: ${entity.notes}',
                style: theme.textTheme.bodySmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          context.push('/entity/${entity.id}');
        },
      ),
    );
  }
}
