import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:uuid/uuid.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/providers/providers.dart';
import '../../entities/domain/attachment.dart';
import '../../entities/domain/entity_template.dart';
import '../domain/catalog_item.dart';

class SpeciesDetailView extends ConsumerWidget {
  final CatalogItem species;
  final Widget? instanceSpecificsHeader;
  final Widget? instanceSpecificsFooter;
  final List<Widget>? actions;

  const SpeciesDetailView({
    super.key,
    required this.species,
    this.instanceSpecificsHeader,
    this.instanceSpecificsFooter,
    this.actions,
  });

  Future<void> _pickAndAddDocument(WidgetRef ref, String speciesId) async {
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

      await ref.read(entityRepositoryProvider).addAttachment(attachment);
      ref.invalidate(speciesAttachmentsProvider(speciesId));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final template = EntityTemplateRegistry.getTemplate(species.type);
    final attachmentsAsync = ref.watch(speciesAttachmentsProvider(species.id));

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 260.0,
          floating: false,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              species.name,
              style: const TextStyle(
                shadows: [Shadow(color: Colors.black87, blurRadius: 8)],
              ),
            ),
            background: FutureBuilder<String>(
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
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        theme.colorScheme.primary,
                        theme.colorScheme.secondary,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      template.icon,
                      size: 80,
                      color: Colors.white.withAlpha(150),
                    ),
                  ),
                );
              },
            ),
          ),
          actions: actions,
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Identity Badges (Brand, Type, Barcode)
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withAlpha(40),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: theme.colorScheme.primary.withAlpha(100)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(template.icon, size: 16, color: theme.colorScheme.primary),
                          const SizedBox(width: 6),
                          Text(
                            species.type,
                            style: TextStyle(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (species.brand != null && species.brand!.isNotEmpty)
                      Chip(
                        avatar: const Icon(Icons.branding_watermark, size: 14),
                        label: Text(species.brand!),
                      ),
                    if (species.barcode != null && species.barcode!.isNotEmpty)
                      Chip(
                        avatar: const Icon(Icons.qr_code_scanner, size: 14),
                        label: Text(species.barcode!),
                      ),
                  ],
                ),
                const SizedBox(height: 16),

                // Instance Specific Header (Location Node & Quantity controls if embedded in EntityDetailScreen)
                if (instanceSpecificsHeader != null) ...[
                  instanceSpecificsHeader!,
                  const SizedBox(height: 20),
                ],

                // Technical Description
                if (species.description != null && species.description!.isNotEmpty) ...[
                  Text(AppStrings.masterDescription, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(species.description!, style: theme.textTheme.bodyMedium),
                  const SizedBox(height: 24),
                ],

                // Instance Specific Footer (Notes / Serial)
                if (instanceSpecificsFooter != null) ...[
                  instanceSpecificsFooter!,
                  const SizedBox(height: 20),
                ],

                // Attach File Action Button
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _pickAndAddDocument(ref, species.id),
                        icon: const Icon(Icons.attach_file),
                        label: const Text(AppStrings.attachFile),
                        style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Species Attachments List
                Text(AppStrings.attachmentsTitle, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                attachmentsAsync.when(
                  data: (attachments) {
                    if (attachments.isEmpty) {
                      return const Text(AppStrings.emptyAttachments, style: TextStyle(color: Colors.grey));
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: attachments.length,
                      itemBuilder: (context, idx) {
                        final att = attachments[idx];
                        return ListTile(
                          leading: Icon(att.fileType == 'image' ? Icons.image : Icons.picture_as_pdf),
                          title: Text(att.fileName),
                          trailing: IconButton(
                            icon: const Icon(Icons.open_in_new),
                            onPressed: () async {
                              final path = await ref.read(fileStorageServiceProvider).getAbsolutePath(att.filePath);
                              await OpenFile.open(path);
                            },
                          ),
                        );
                      },
                    );
                  },
                  loading: () => const CircularProgressIndicator(),
                  error: (err, _) => Text('Error: $err'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
