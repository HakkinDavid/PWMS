import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/providers/providers.dart';
import '../domain/catalog_item.dart';

class SpeciesTile extends ConsumerWidget {
  final CatalogItem species;
  final VoidCallback? onInstantiate;
  final VoidCallback? onTap;

  const SpeciesTile({
    super.key,
    required this.species,
    this.onInstantiate,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        onTap: onTap,
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 54,
            height: 54,
            color: theme.colorScheme.primary.withAlpha(25),
            child: FutureBuilder<String>(
              future: species.mainPhotoPath != null
                  ? ref.read(fileStorageServiceProvider).getAbsolutePath(species.mainPhotoPath!)
                  : Future.value(''),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.isNotEmpty && File(snapshot.data!).existsSync()) {
                  return Image.file(
                    File(snapshot.data!),
                    fit: BoxFit.cover,
                  );
                }
                return Icon(Icons.auto_awesome, color: theme.colorScheme.primary);
              },
            ),
          ),
        ),
        title: Text(
          species.name,
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                if (species.brand != null && species.brand!.isNotEmpty) ...[
                  Text(
                    species.brand!,
                    style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.primary, fontSize: 12),
                  ),
                  const Text(' • ', style: TextStyle(fontSize: 12)),
                ],
                Text(species.type, style: TextStyle(color: theme.colorScheme.secondary, fontSize: 12)),
              ],
            ),
            if (species.barcode != null && species.barcode!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.qr_code_scanner, size: 12, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(species.barcode!, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                ],
              ),
            ],
            if (species.description != null && species.description!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                species.description!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall,
              ),
            ],
          ],
        ),
        trailing: onInstantiate != null
            ? ElevatedButton.icon(
                onPressed: onInstantiate,
                icon: const Icon(Icons.add, size: 16),
                label: const Text(AppStrings.instantiateAction),
              )
            : null,
      ),
    );
  }
}
