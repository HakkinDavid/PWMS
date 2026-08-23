import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import '../../../core/providers/providers.dart';
import '../../../core/router/app_navigation_extension.dart';
import '../../locations/domain/location_node.dart';

class ContainerContentsView extends ConsumerWidget {
  final LocationNode location;

  const ContainerContentsView({
    super.key,
    required this.location,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entitiesState = ref.watch(entityListProvider);
    final catalogState = ref.watch(catalogListProvider);
    final theme = Theme.of(context);

    return entitiesState.when(
      data: (allEntities) {
        final children = allEntities.where((e) => e.locationId == location.id).toList();

        if (children.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox, size: 48, color: theme.disabledColor),
                  const SizedBox(height: 12),
                  Text(
                    AppStrings.locationHasNoObjectsOrSublocations,
                    style: theme.textTheme.bodyMedium?.copyWith(color: theme.disabledColor),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        final catalogItems = catalogState.asData?.value ?? [];

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: children.length,
          itemBuilder: (context, index) {
            final child = children[index];
            final species = catalogItems.where((c) => c.id == child.speciesId).firstOrNull;
            final name = species?.name ?? AppStrings.typeObject;
            final type = species?.type ?? AppStrings.typeObject;

            final firstMag = child.magnitudes.isNotEmpty ? child.magnitudes.first : null;
            final subtitleText = firstMag != null
                ? '$type • ${firstMag.propertyName}: ${firstMag.displayValue}'
                : type;

            return Card(
              child: ListTile(
                leading: const Icon(Icons.inventory_2),
                title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(subtitleText),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  context.pushEntityDetail(child.id);
                },
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('${AppStrings.errorPrefix}$err')),
    );
  }
}
