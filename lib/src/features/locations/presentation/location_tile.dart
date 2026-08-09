import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';
import '../domain/location_node.dart';

class LocationTile extends StatelessWidget {
  final LocationNode node;
  final int itemCount;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const LocationTile({
    super.key,
    required this.node,
    this.itemCount = 0,
    this.onTap,
    this.onLongPress,
  });

  static IconData resolveLocationIcon(String? iconName) {
    if (iconName == null || iconName.trim().isEmpty) return Icons.location_on;
    final name = iconName.trim().toLowerCase();
    if (name.contains('home') || name.contains('casa')) return Icons.home_outlined;
    if (name.contains('room') || name.contains('cuarto') || name.contains('habitacion')) return Icons.bedroom_parent_outlined;
    if (name.contains('box') || name.contains('caja') || name.contains('contenedor')) return Icons.inventory_2_outlined;
    if (name.contains('folder') || name.contains('carpeta')) return Icons.folder_outlined;
    if (name.contains('store') || name.contains('bodega') || name.contains('almacen')) return Icons.store_outlined;
    if (name.contains('shelf') || name.contains('estante') || name.contains('armario')) return Icons.shelves;
    return Icons.location_on_outlined;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconData = resolveLocationIcon(node.icon);

    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: theme.dividerColor.withAlpha(80)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(8),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                iconData,
                color: theme.colorScheme.onSecondaryContainer,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    node.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$itemCount ${AppStrings.objectsLabel}',
                    style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
