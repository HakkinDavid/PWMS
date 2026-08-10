import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import '../../../core/providers/providers.dart';
import '../domain/subspecies.dart';
import 'species_text_badge_avatar.dart';

class SubspeciesTile extends ConsumerWidget {
  final Subspecies subspecies;
  final String? speciesName;
  final VoidCallback? onTap;
  final Widget? trailing;

  const SubspeciesTile({
    super.key,
    required this.subspecies,
    this.speciesName,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final photoPath = subspecies.photoPath;

    final titleText = '${subspecies.subspeciesName}${subspecies.brand != null && subspecies.brand!.isNotEmpty ? " (${subspecies.brand})" : ""}';
    final subtitleText = subspecies.barcode != null && subspecies.barcode!.isNotEmpty
        ? '${AppStrings.barcodeLabel}: ${subspecies.barcode}'
        : (subspecies.notes ?? '');

    return Card(
      margin: const EdgeInsets.only(bottom: 6),
      elevation: 1.0,
      child: ListTile(
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        onTap: onTap,
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            width: 40,
            height: 40,
            child: FutureBuilder<String>(
              future: photoPath != null && photoPath.isNotEmpty
                  ? ref.read(fileStorageServiceProvider).getAbsolutePath(photoPath)
                  : Future.value(''),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.isNotEmpty && File(snapshot.data!).existsSync()) {
                  return Image.file(
                    File(snapshot.data!),
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => SpeciesTextBadgeAvatar(
                      speciesName: speciesName ?? subspecies.subspeciesName,
                      size: 40,
                    ),
                  );
                }
                return SpeciesTextBadgeAvatar(
                  speciesName: speciesName ?? subspecies.subspeciesName,
                  size: 40,
                );
              },
            ),
          ),
        ),
        title: Text(
          titleText,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
        subtitle: subtitleText.isNotEmpty
            ? Text(
                subtitleText,
                style: TextStyle(fontSize: 11, color: theme.colorScheme.secondary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            : null,
        trailing: trailing,
      ),
    );
  }
}
