import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_filex/open_filex.dart';
import 'package:uuid/uuid.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/providers/providers.dart';
import '../../../core/widgets/app_toast.dart';
import '../../entities/domain/attachment.dart';
import '../../entities/domain/entity_template.dart';
import '../domain/catalog_item.dart';

import '../domain/subspecies.dart';

class SpeciesDetailView extends ConsumerWidget {
  final CatalogItem species;
  final Subspecies? subspecies;
  final Widget? instanceSpecificsHeader;
  final Widget? instanceSpecificsFooter;
  final List<Widget>? actions;
  final bool showAttachmentAction;

  const SpeciesDetailView({
    super.key,
    required this.species,
    this.subspecies,
    this.instanceSpecificsHeader,
    this.instanceSpecificsFooter,
    this.actions,
    this.showAttachmentAction = false,
  });

  Future<void> _pickAndAddDocument(BuildContext context, WidgetRef ref, String speciesId) async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      final file = result.files.single;
      final storage = ref.read(fileStorageServiceProvider);
      final savedRelativePath = await storage.saveFile(file.path!);

      final attachment = Attachment(
        id: const Uuid().v4(),
        speciesId: speciesId,
        filePath: savedRelativePath,
        fileName: file.name,
        fileType: file.extension ?? 'doc',
        createdAt: DateTime.now(),
      );

      try {
        await ref.read(entityRepositoryProvider).addAttachment(attachment);
        ref.invalidate(speciesAttachmentsProvider(speciesId));
      } catch (e) {
        if (context.mounted) {
          AppToast.showError(
            context,
            e.toString().replaceAll('Exception: ', ''),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final template = EntityTemplateRegistry.getTemplate(species.type);
    final attachmentsAsync = ref.watch(speciesAttachmentsProvider(species.id));
    final effectivePhotoPath = subspecies?.resolvePhotoPath(species.mainPhotoPath) ?? species.mainPhotoPath;

    final isCustomSubspecies = subspecies != null && subspecies!.subspeciesName.toLowerCase() != 'genérica';

    final headerTitle = isCustomSubspecies
        ? '${subspecies!.subspeciesName}${subspecies!.brand != null ? " (${subspecies!.brand})" : ""}'
        : species.name;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          headerTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: actions,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Photo Box Preview Card with Subspecies Fallback to Species Photo
              Center(
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: theme.dividerColor, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(20),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: FutureBuilder<String>(
                      future: effectivePhotoPath != null && effectivePhotoPath.isNotEmpty
                          ? ref.read(fileStorageServiceProvider).getAbsolutePath(effectivePhotoPath)
                          : Future.value(''),
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data!.isNotEmpty && File(snapshot.data!).existsSync()) {
                          return Image.file(
                            File(snapshot.data!),
                            fit: BoxFit.contain,
                          );
                        }
                        return Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                theme.colorScheme.primary.withAlpha(180),
                                theme.colorScheme.secondary.withAlpha(180),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              template.icon,
                              size: 54,
                              color: Colors.white,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Badges (Type, Species Context, Barcode, Uniqueness)
              Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withAlpha(30),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: theme.colorScheme.primary.withAlpha(90)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(template.icon, size: 14, color: theme.colorScheme.primary),
                          const SizedBox(width: 4),
                          Text(
                            species.type,
                            style: TextStyle(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isCustomSubspecies) ...[
                      Chip(
                        visualDensity: VisualDensity.compact,
                        avatar: const Icon(Icons.public, size: 12),
                        label: Text(
                          'Especie: ${species.name}',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                      if (subspecies!.barcode != null)
                        Chip(
                          visualDensity: VisualDensity.compact,
                          avatar: const Icon(Icons.qr_code, size: 12),
                          label: Text('${AppStrings.barcodeLabel}: ${subspecies!.barcode}', style: const TextStyle(fontSize: 11)),
                        ),
                    ] else if (subspecies?.barcode != null) ...[
                      Chip(
                        visualDensity: VisualDensity.compact,
                        avatar: const Icon(Icons.qr_code, size: 12),
                        label: Text('${AppStrings.barcodeLabel}: ${subspecies!.barcode}', style: const TextStyle(fontSize: 11)),
                      ),
                    ],
                    if (species.isUnique)
                      const Chip(
                        visualDensity: VisualDensity.compact,
                        avatar: Icon(Icons.star, size: 12, color: Colors.amber),
                        label: Text(AppStrings.isUniqueLabel, style: TextStyle(fontSize: 11)),
                      ),
                    Chip(
                      visualDensity: VisualDensity.compact,
                      avatar: Icon(
                        species.isNonPerishable ? Icons.shield_outlined : Icons.timer_outlined,
                        size: 12,
                        color: species.isNonPerishable ? Colors.green : Colors.orange,
                      ),
                      label: Text(
                        species.isNonPerishable
                            ? 'Imperecedero'
                            : 'Perecedero${species.defaultShelfLifeDays != null ? " (${species.defaultShelfLifeDays} días de vida útil)" : ""}',
                        style: TextStyle(
                          fontSize: 11,
                          color: species.isNonPerishable ? Colors.green.shade800 : Colors.orange.shade900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Display ALL 4NF Multiple Magnitude Property Schemas
              if (species.magnitudes.isNotEmpty) ...[
                Card(
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.registeredPropertiesAndMagnitudes,
                          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: species.magnitudes.length,
                          itemBuilder: (ctx, idx) {
                            final mag = species.magnitudes[idx];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                children: [
                                  const Icon(Icons.straighten, size: 14, color: Colors.grey),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${mag.propertyName} (${mag.unitSymbol})',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Instance Specific Header
              if (instanceSpecificsHeader != null) ...[
                instanceSpecificsHeader!,
                const SizedBox(height: 14),
              ],

              // Technical Description
              if (species.description != null && species.description!.trim().isNotEmpty) ...[
                Text(AppStrings.masterDescription, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(species.description!, style: theme.textTheme.bodyMedium),
                const SizedBox(height: 16),
              ],

              // Instance Specific Footer
              if (instanceSpecificsFooter != null) ...[
                instanceSpecificsFooter!,
                const SizedBox(height: 14),
              ],

              // Attach File Action Button (Point 3: Only shown if showAttachmentAction == true, i.e. in Edit mode!)
              if (showAttachmentAction) ...[
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _pickAndAddDocument(context, ref, species.id),
                        icon: const Icon(Icons.attach_file, size: 16),
                        label: const Text(AppStrings.attachFile),
                        style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 10)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],

              // Species Attachments List
              attachmentsAsync.when(
                data: (attachments) {
                  if (attachments.isEmpty) {
                    if (!showAttachmentAction) return const SizedBox.shrink();
                    return const Text(AppStrings.emptyAttachments, style: TextStyle(color: Colors.grey, fontSize: 12));
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppStrings.attachmentsTitle, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: attachments.length,
                        itemBuilder: (context, idx) {
                          final att = attachments[idx];
                          final isInstanceAttachment = att.instanceId != null && att.instanceId!.isNotEmpty;

                          return ListTile(
                            dense: true,
                            leading: Icon(att.fileType == 'image' ? Icons.image : Icons.picture_as_pdf, size: 20),
                            title: Text(att.fileName, style: const TextStyle(fontSize: 13)),
                            subtitle: isInstanceAttachment
                                ? const Row(
                                    children: [
                                      Icon(Icons.inventory_2, size: 12, color: Colors.amber),
                                      SizedBox(width: 4),
                                      Text('Adjunto propio de Instancia', style: TextStyle(fontSize: 11, color: Colors.amber)),
                                    ],
                                  )
                                : null,
                            trailing: IconButton(
                              icon: const Icon(Icons.open_in_new, size: 18),
                              onPressed: () async {
                                final path = await ref.read(fileStorageServiceProvider).getAbsolutePath(att.filePath);
                                await OpenFilex.open(path);
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
                loading: () => const CircularProgressIndicator(),
                error: (err, _) => Text('${AppStrings.errorPrefix}$err'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
