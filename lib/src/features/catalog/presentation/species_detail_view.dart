import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_filex/open_filex.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import 'package:platinum_world_management_system/src/core/constants/app_technical_strings.dart';
import '../../../core/providers/providers.dart';
import '../../../core/widgets/app_confirmation_dialog.dart';
import '../../../core/widgets/app_toast.dart';
import '../../entities/domain/attachment.dart';
import '../../entities/domain/entity_photo_helper.dart';
import '../../entities/domain/entity_template.dart';
import '../../entities/presentation/entity_photo_thumbnail.dart';
import '../domain/catalog_item.dart';
import '../domain/numismatic_data_helper.dart';
import '../domain/subspecies.dart';
import 'numismatic_camera_capture_view.dart';
import 'standard_media_picker_sheet.dart';

class SpeciesDetailView extends ConsumerWidget {
  final CatalogItem species;
  final Subspecies? subspecies;
  final String? customTitle;
  final String? instanceId;
  final Widget? instanceSpecificsHeader;
  final Widget? instanceSpecificsFooter;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final bool showAttachmentAction;
  final List<Attachment>? workingInstanceAttachments;
  final ValueChanged<List<Attachment>>? onInstanceAttachmentsChanged;
  final List<Attachment>? workingSpeciesAttachments;
  final ValueChanged<List<Attachment>>? onSpeciesAttachmentsChanged;

  const SpeciesDetailView({
    super.key,
    required this.species,
    this.subspecies,
    this.customTitle,
    this.instanceId,
    this.instanceSpecificsHeader,
    this.instanceSpecificsFooter,
    this.actions,
    this.floatingActionButton,
    this.showAttachmentAction = false,
    this.workingInstanceAttachments,
    this.onInstanceAttachmentsChanged,
    this.workingSpeciesAttachments,
    this.onSpeciesAttachmentsChanged,
  });

  void _invalidateAllRelatedProviders(WidgetRef ref, String speciesId, String? instanceId) {
    ref.invalidate(speciesAttachmentsProvider(speciesId));
    if (instanceId != null && instanceId.isNotEmpty) {
      ref.invalidate(instanceAttachmentsProvider(instanceId));
    }
    ref.invalidate(entityListProvider);
    ref.invalidate(catalogListProvider);
    ref.invalidate(recentEntitiesProvider);
    ref.invalidate(subspeciesListProvider);
    ref.invalidate(searchResultsProvider);
  }

  Future<void> _handleAddAttachment(
    BuildContext context,
    WidgetRef ref,
    String speciesId, {
    String? instanceId,
    List<Attachment>? currentAttachments,
  }) async {
    final isNumismatic = NumismaticDataHelper.isNumismaticSpecies(species);
    final isInstanceLevel = instanceId != null && instanceId.isNotEmpty;

    bool showObverseScan = false;
    bool showReverseScan = false;
    bool isCoin = true;

    // Punto 37: No debe de haber opciones numismáticas de adjuntos a nivel especie
    // Punto 36: En Instancia, deben de ser dos distintas opciones condicionales (anverso faltante y reverso faltante)
    if (isNumismatic && isInstanceLevel) {
      isCoin = NumismaticDataHelper.isCoin(species);
      final targetAttachments = currentAttachments ?? [];
      final hasObverse = targetAttachments.any((a) => a.fileName.toLowerCase().contains(AppTechnicalStrings.sideAnverso));
      final hasReverse = targetAttachments.any((a) => a.fileName.toLowerCase().contains(AppTechnicalStrings.sideReverso));

      showObverseScan = !hasObverse;
      showReverseScan = !hasReverse;
    }

    final result = await StandardMediaPickerSheet.show(
      context,
      title: isInstanceLevel ? AppStrings.attachToInstanceAction : AppStrings.attachToSpeciesAction,
      webSearchQuery: subspecies?.subspeciesName ?? species.name,
      showNumismaticObverse: showObverseScan,
      showNumismaticReverse: showReverseScan,
      isCoin: isCoin,
    );

    if (result == null) return;

    final storage = ref.read(fileStorageServiceProvider);

    try {
      String savedRelativePath;
      String finalFileName = result.fileName;

      if (result.file != null) {
        savedRelativePath = await storage.saveFile(result.file!.path);

        if (isNumismatic && isInstanceLevel && result.source == AppTechnicalStrings.mediaSourceNumismatic) {
          final side = result.fileName.toLowerCase().contains(AppTechnicalStrings.sideReverso) || (!showObverseScan && showReverseScan)
              ? AppTechnicalStrings.sideReverso
              : AppTechnicalStrings.sideAnverso;
          final ext = result.file!.path.contains(AppTechnicalStrings.dot) ? result.file!.path.split(AppTechnicalStrings.dot).last : AppTechnicalStrings.extJpgClean;

          finalFileName = NumismaticDataHelper.buildAttachmentFileName(
            subspeciesName: subspecies?.subspeciesName ?? species.name,
            instanceId: instanceId,
            side: side,
            extension: ext,
          );
        }
      } else if (result.relativeStoredPath != null) {
        savedRelativePath = result.relativeStoredPath!;
      } else {
        return;
      }

      final attachment = Attachment(
        id: const Uuid().v4(),
        speciesId: speciesId,
        instanceId: instanceId,
        filePath: savedRelativePath,
        fileName: finalFileName,
        fileType: result.fileType,
        createdAt: DateTime.now(),
      );

      if (isInstanceLevel && onInstanceAttachmentsChanged != null && workingInstanceAttachments != null) {
        onInstanceAttachmentsChanged!([...workingInstanceAttachments!, attachment]);
        if (context.mounted) {
          AppToast.showSuccess(context, AppStrings.attachmentAddedToEditing);
        }
      } else if (!isInstanceLevel && onSpeciesAttachmentsChanged != null && workingSpeciesAttachments != null) {
        onSpeciesAttachmentsChanged!([...workingSpeciesAttachments!, attachment]);
        if (context.mounted) {
          AppToast.showSuccess(context, AppStrings.attachmentAddedToEditing);
        }
      } else {
        await ref.read(entityRepositoryProvider).addAttachment(attachment);
        _invalidateAllRelatedProviders(ref, speciesId, instanceId);

        if (context.mounted) {
          AppToast.showSuccess(context, AppStrings.attachmentAddedSuccessfully);
        }
      }
    } catch (e) {
      if (context.mounted) {
        AppToast.showError(
          context,
          e.toString().replaceAll(AppTechnicalStrings.exceptionPrefix, AppTechnicalStrings.empty),
        );
      }
    }
  }

  Future<void> _handleReplaceAttachment(
    BuildContext context,
    WidgetRef ref,
    Attachment att,
  ) async {
    final isNumismatic = NumismaticDataHelper.isNumismaticSpecies(species);
    final fileNameLower = att.fileName.toLowerCase();
    final isInstanceLevel = att.instanceId != null && att.instanceId!.isNotEmpty;
    final isNumismaticSide = isNumismatic && isInstanceLevel && (fileNameLower.contains(AppTechnicalStrings.sideAnverso) || fileNameLower.contains(AppTechnicalStrings.sideReverso));

    try {
      if (isNumismaticSide) {
        // Direct jump to numismatic camera with side preselected and hideSideSelector: true (Punto 33)
        final side = fileNameLower.contains(AppTechnicalStrings.sideReverso) ? AppTechnicalStrings.sideReverso : AppTechnicalStrings.sideAnverso;
        final isCoin = NumismaticDataHelper.isCoin(species);

        final capturedFile = await NumismaticCameraCaptureView.show(
          context,
          isCoin: isCoin,
          targetSide: side,
          hideSideSelector: true,
        );

        if (capturedFile != null && context.mounted) {
          final shouldReplace = await AppConfirmationDialog.show(
            context: context,
            title: AppStrings.confirmReplaceAttachmentTitle,
            message: AppStrings.confirmReplaceAttachmentNamedMessage(att.fileName),
            confirmLabel: AppStrings.replaceAction,
            cancelLabel: AppStrings.cancel,
            icon: Icons.sync,
          );
          if (!shouldReplace || !context.mounted) return;

          final storage = ref.read(fileStorageServiceProvider);
          final savedRelativePath = await storage.saveFile(capturedFile.path);
          final updated = att.copyWith(filePath: savedRelativePath, fileType: AppTechnicalStrings.fileTypeImage);

          if (isInstanceLevel && onInstanceAttachmentsChanged != null && workingInstanceAttachments != null) {
            final updatedList = workingInstanceAttachments!.map((a) => a.id == att.id ? updated : a).toList();
            onInstanceAttachmentsChanged!(updatedList);
            if (context.mounted) {
              AppToast.showSuccess(context, AppStrings.numismaticAttachmentModifiedInEditing);
            }
          } else if (!isInstanceLevel && onSpeciesAttachmentsChanged != null && workingSpeciesAttachments != null) {
            final updatedList = workingSpeciesAttachments!.map((a) => a.id == att.id ? updated : a).toList();
            onSpeciesAttachmentsChanged!(updatedList);
            if (context.mounted) {
              AppToast.showSuccess(context, AppStrings.numismaticAttachmentModifiedInEditing);
            }
          } else {
            await ref.read(entityRepositoryProvider).replaceAttachmentFile(
                  att.id,
                  capturedFile.path,
                  newFileType: AppTechnicalStrings.fileTypeImage,
                );

            _invalidateAllRelatedProviders(ref, att.speciesId, att.instanceId);

            if (context.mounted) {
              AppToast.showSuccess(context, AppStrings.numismaticAttachmentUpdatedSuccessfully);
            }
          }
        }
        return;
      }

      // Standard media picker for non-numismatic or general attachments
      final result = await StandardMediaPickerSheet.show(
        context,
        title: AppStrings.replaceAttachmentTitle(att.fileName),
        webSearchQuery: subspecies?.subspeciesName ?? species.name,
      );

      if (result == null || !context.mounted) return;

      final newName = result.fileName;
      final shouldReplace = await AppConfirmationDialog.show(
        context: context,
        title: AppStrings.confirmReplaceAttachmentTitle,
        message: AppStrings.confirmReplaceAttachmentRenamedMessage(att.fileName, newName),
        confirmLabel: AppStrings.replaceAction,
        cancelLabel: AppStrings.cancel,
        icon: Icons.sync,
      );
      if (!shouldReplace || !context.mounted) return;

      String? newRelativePath;
      String? absPathToReplace;
      if (result.file != null) {
        newRelativePath = await ref.read(fileStorageServiceProvider).saveFile(result.file!.path);
        absPathToReplace = result.file!.path;
      } else if (result.relativeStoredPath != null) {
        newRelativePath = result.relativeStoredPath;
        absPathToReplace = await ref.read(fileStorageServiceProvider).getAbsolutePath(result.relativeStoredPath!);
      }

      if (newRelativePath == null) return;

      final updated = att.copyWith(
        filePath: newRelativePath,
        fileName: result.fileName,
        fileType: result.fileType,
      );

      if (isInstanceLevel && onInstanceAttachmentsChanged != null && workingInstanceAttachments != null) {
        final updatedList = workingInstanceAttachments!.map((a) => a.id == att.id ? updated : a).toList();
        onInstanceAttachmentsChanged!(updatedList);
        if (context.mounted) {
          AppToast.showSuccess(context, AppStrings.attachmentModifiedInEditing);
        }
      } else if (!isInstanceLevel && onSpeciesAttachmentsChanged != null && workingSpeciesAttachments != null) {
        final updatedList = workingSpeciesAttachments!.map((a) => a.id == att.id ? updated : a).toList();
        onSpeciesAttachmentsChanged!(updatedList);
        if (context.mounted) {
          AppToast.showSuccess(context, AppStrings.attachmentModifiedInEditing);
        }
      } else {
        await ref.read(entityRepositoryProvider).replaceAttachmentFile(
              att.id,
              absPathToReplace!,
              newFileName: result.fileName,
              newFileType: result.fileType,
            );

        _invalidateAllRelatedProviders(ref, att.speciesId, att.instanceId);

        if (context.mounted) {
          AppToast.showSuccess(context, AppStrings.attachmentReplacedSuccessfully);
        }
      }
    } catch (e) {
      if (context.mounted) {
        AppToast.showError(context, AppStrings.replaceAttachmentError(e.toString()));
      }
    }
  }

  Future<void> _handleRenameAttachment(
    BuildContext context,
    WidgetRef ref,
    Attachment att,
  ) async {
    final controller = TextEditingController(text: att.fileName);

    final newName = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(AppStrings.renameAttachmentTitle),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: AppStrings.fileNameLabel,
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(AppStrings.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              final val = controller.text.trim();
              if (val.isNotEmpty) {
                Navigator.pop(ctx, val);
              }
            },
            child: const Text(AppStrings.save),
          ),
        ],
      ),
    );

    if (newName != null && newName.isNotEmpty && newName != att.fileName) {
      try {
        final updated = att.copyWith(fileName: newName);
        final isInstanceLevel = att.instanceId != null && att.instanceId!.isNotEmpty;

        if (isInstanceLevel && onInstanceAttachmentsChanged != null && workingInstanceAttachments != null) {
          final updatedList = workingInstanceAttachments!.map((a) => a.id == att.id ? updated : a).toList();
          onInstanceAttachmentsChanged!(updatedList);
          if (context.mounted) {
            AppToast.showSuccess(context, AppStrings.nameUpdatedInEditing);
          }
        } else if (!isInstanceLevel && onSpeciesAttachmentsChanged != null && workingSpeciesAttachments != null) {
          final updatedList = workingSpeciesAttachments!.map((a) => a.id == att.id ? updated : a).toList();
          onSpeciesAttachmentsChanged!(updatedList);
          if (context.mounted) {
            AppToast.showSuccess(context, AppStrings.nameUpdatedInEditing);
          }
        } else {
          await ref.read(entityRepositoryProvider).updateAttachment(updated);
          _invalidateAllRelatedProviders(ref, att.speciesId, att.instanceId);
          if (context.mounted) {
            AppToast.showSuccess(context, AppStrings.nameUpdatedSuccessfully);
          }
        }
      } catch (e) {
        if (context.mounted) {
          AppToast.showError(context, AppStrings.renameError(e.toString()));
        }
      }
    }
  }

  Future<void> _openExternally(BuildContext context, WidgetRef ref, Attachment att) async {
    final storage = ref.read(fileStorageServiceProvider);
    final absPath = await storage.getAbsolutePath(att.filePath);
    final file = File(absPath);

    if (!file.existsSync()) {
      if (context.mounted) {
        AppToast.showError(context, AppStrings.physicalFileNotFoundInStorage);
      }
      return;
    }

    try {
      final result = await OpenFilex.open(absPath);
      if (result.type != ResultType.done && result.message.isNotEmpty && context.mounted) {
        AppToast.showError(context, AppStrings.errorOpeningFile(result.message));
      }
    } catch (e) {
      if (context.mounted) {
        AppToast.showError(context, AppStrings.errorOpeningFile(e.toString()));
      }
    }
  }

  Future<void> _shareAttachment(BuildContext context, WidgetRef ref, Attachment att) async {
    final storage = ref.read(fileStorageServiceProvider);
    final absPath = await storage.getAbsolutePath(att.filePath);
    final file = File(absPath);

    if (!file.existsSync()) {
      if (context.mounted) {
        AppToast.showError(context, AppStrings.physicalFileNotFoundInStorage);
      }
      return;
    }

    try {
      await Share.shareXFiles(
        [XFile(absPath, name: att.fileName)],
        text: att.fileName,
      );
    } catch (e) {
      if (context.mounted) {
        AppToast.showError(context, AppStrings.errorSharingFile(e.toString()));
      }
    }
  }

  Future<void> _openAttachment(BuildContext context, WidgetRef ref, Attachment att) async {
    final storage = ref.read(fileStorageServiceProvider);
    final absPath = await storage.getAbsolutePath(att.filePath);
    final file = File(absPath);

    if (!file.existsSync()) {
      if (context.mounted) {
        AppToast.showError(context, AppStrings.physicalFileNotFoundInStorage);
      }
      return;
    }

    final isImage = att.fileType == AppTechnicalStrings.fileTypeImage ||
        [
          AppTechnicalStrings.extJpg,
          AppTechnicalStrings.extJpeg,
          AppTechnicalStrings.extPng,
          AppTechnicalStrings.extWebp,
          AppTechnicalStrings.extHeic,
          AppTechnicalStrings.extBmp,
        ].any((ext) => att.filePath.toLowerCase().endsWith(ext));

    if (isImage) {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (ctx) => Dialog(
            backgroundColor: Colors.black,
            insetPadding: EdgeInsets.zero,
            child: SafeArea(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  InteractiveViewer(
                    child: Image.file(
                      file,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Center(
                        child: Icon(Icons.broken_image_outlined, color: Colors.white70, size: 48),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white, size: 24),
                            tooltip: AppStrings.close,
                            onPressed: () => Navigator.pop(ctx),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              att.fileName,
                              style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.open_in_new, color: Colors.white, size: 22),
                            tooltip: AppStrings.openExternallyTooltip,
                            onPressed: () => _openExternally(context, ref, att),
                          ),
                          IconButton(
                            icon: const Icon(Icons.share, color: Colors.white, size: 22),
                            tooltip: AppStrings.shareAttachmentTooltip,
                            onPressed: () => _shareAttachment(context, ref, att),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    } else {
      await _openExternally(context, ref, att);
    }
  }

  Future<void> _confirmAndDeleteAttachment(BuildContext context, WidgetRef ref, Attachment att) async {
    final confirmed = await AppConfirmationDialog.showDeleteConfirmation(
      context: context,
      title: AppStrings.deleteAttachmentAction,
      message: AppStrings.confirmDeleteAttachmentPrompt(att.fileName),
    );

    if (confirmed == true) {
      try {
        final isInstanceLevel = att.instanceId != null && att.instanceId!.isNotEmpty;

        if (isInstanceLevel && onInstanceAttachmentsChanged != null && workingInstanceAttachments != null) {
          final updatedList = workingInstanceAttachments!.where((a) => a.id != att.id).toList();
          onInstanceAttachmentsChanged!(updatedList);
          if (context.mounted) {
            AppToast.showSuccess(context, AppStrings.attachmentRemovedFromEditing);
          }
        } else if (!isInstanceLevel && onSpeciesAttachmentsChanged != null && workingSpeciesAttachments != null) {
          final updatedList = workingSpeciesAttachments!.where((a) => a.id != att.id).toList();
          onSpeciesAttachmentsChanged!(updatedList);
          if (context.mounted) {
            AppToast.showSuccess(context, AppStrings.attachmentRemovedFromEditing);
          }
        } else {
          await ref.read(entityRepositoryProvider).deleteAttachment(att.id);
          _invalidateAllRelatedProviders(ref, att.speciesId, att.instanceId);
          if (context.mounted) {
            AppToast.showSuccess(context, AppStrings.attachmentDeletedSuccessfully);
          }
        }
      } catch (e) {
        if (context.mounted) {
          AppToast.showError(context, AppStrings.deleteError(e.toString()));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final template = EntityTemplateRegistry.getTemplate(species.type);
    final speciesAttachmentsAsync = ref.watch(speciesAttachmentsProvider(species.id));
    final instanceAttachmentsAsync = instanceId != null && instanceId!.isNotEmpty
        ? ref.watch(instanceAttachmentsProvider(instanceId!))
        : null;

    final isCustomSubspecies = subspecies != null && subspecies!.subspeciesName.toLowerCase() != AppTechnicalStrings.genericSubspeciesLower;

    final headerTitle = customTitle ?? (isCustomSubspecies
        ? AppStrings.subspeciesNameWithBrand(subspecies!.subspeciesName, subspecies!.brand)
        : species.name);

    final bottomPadding = MediaQuery.paddingOf(context).bottom + (floatingActionButton != null ? 88.0 : 28.0);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          headerTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: actions,
      ),
      floatingActionButton: floatingActionButton,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: bottomPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Photo Box Preview Card with Subspecies Fallback to Species Photo / Instance Attachment
              Center(
                child: InkWell(
                  onTap: () async {
                    final resolvedPhotoFuture = resolveEffectiveEntityPhotoPath(
                      ref,
                      subspecies: subspecies,
                      species: species,
                      instanceId: instanceId,
                    );
                    final relPath = await resolvedPhotoFuture;
                    if (relPath != null && relPath.isNotEmpty && context.mounted) {
                      final storage = ref.read(fileStorageServiceProvider);
                      final absPath = await storage.getAbsolutePath(relPath);
                      final file = File(absPath);
                      if (file.existsSync() && context.mounted) {
                        final photoTitle = subspecies?.subspeciesName ?? species.name;
                        showDialog(
                          context: context,
                          builder: (ctx) => Dialog(
                            backgroundColor: Colors.black,
                            insetPadding: EdgeInsets.zero,
                            child: SafeArea(
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  InteractiveViewer(
                                    child: Image.file(
                                      file,
                                      fit: BoxFit.contain,
                                      errorBuilder: (_, __, ___) => const Center(
                                        child: Icon(Icons.broken_image_outlined, color: Colors.white70, size: 48),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 8,
                                    left: 8,
                                    right: 8,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.black54,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.close, color: Colors.white, size: 24),
                                            tooltip: AppStrings.close,
                                            onPressed: () => Navigator.pop(ctx),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              photoTitle,
                                              style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.open_in_new, color: Colors.white, size: 22),
                                            tooltip: AppStrings.openExternallyTooltip,
                                            onPressed: () async {
                                              try {
                                                final res = await OpenFilex.open(absPath);
                                                if (res.type != ResultType.done && res.message.isNotEmpty && context.mounted) {
                                                  AppToast.showError(context, AppStrings.errorOpeningFile(res.message));
                                                }
                                              } catch (e) {
                                                if (context.mounted) {
                                                  AppToast.showError(context, AppStrings.errorOpeningFile(e.toString()));
                                                }
                                              }
                                            },
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.share, color: Colors.white, size: 22),
                                            tooltip: AppStrings.shareAttachmentTooltip,
                                            onPressed: () async {
                                              try {
                                                await Share.shareXFiles([XFile(absPath, name: photoTitle)], text: photoTitle);
                                              } catch (e) {
                                                if (context.mounted) {
                                                  AppToast.showError(context, AppStrings.errorSharingFile(e.toString()));
                                                }
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                    }
                  },
                  borderRadius: BorderRadius.circular(20),
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
                    child: EntityPhotoThumbnail(
                      species: species,
                      subspecies: subspecies,
                      instanceId: instanceId,
                      size: 140,
                      borderRadius: BorderRadius.circular(18),
                      useTextBadgeFallback: false,
                      fallbackIcon: template.icon,
                      fit: BoxFit.contain,
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
                    Chip(
                      visualDensity: VisualDensity.compact,
                      avatar: Icon(template.icon, size: 12),
                      label: Text(species.type, style: const TextStyle(fontSize: 11)),
                    ),
                    if (isCustomSubspecies) ...[
                      Chip(
                        visualDensity: VisualDensity.compact,
                        avatar: const Icon(Icons.style_outlined, size: 12),
                        label: Text(
                          AppStrings.speciesPrefix(species.name),
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                      if (subspecies!.barcode != null)
                        Chip(
                          visualDensity: VisualDensity.compact,
                          avatar: const Icon(Icons.qr_code, size: 12),
                          label: Text(AppStrings.barcodeWithColon(subspecies!.barcode!), style: const TextStyle(fontSize: 11)),
                        ),
                    ] else if (subspecies?.barcode != null) ...[
                      Chip(
                        visualDensity: VisualDensity.compact,
                        avatar: const Icon(Icons.qr_code, size: 12),
                        label: Text(AppStrings.barcodeWithColon(subspecies!.barcode!), style: const TextStyle(fontSize: 11)),
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
                            ? AppStrings.nonPerishable
                            : AppStrings.perishableWithShelfLife(species.defaultShelfLifeDays),
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

              // Display ALL 4NF Multiple Magnitude Property Schemas (only in species view, not in instance view)
              if (species.magnitudes.isNotEmpty && (instanceId == null || instanceId!.isEmpty)) ...[
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
                            final unitOrType = (mag.unitSymbol != null && mag.unitSymbol!.trim().isNotEmpty)
                                ? mag.unitSymbol!.trim()
                                : mag.dataType;
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                children: [
                                  const Icon(Icons.straighten, size: 14, color: Colors.grey),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      AppStrings.propertyWithUnitOrType(mag.propertyName, unitOrType),
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
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

              // Instance Specific Footer
              if (instanceSpecificsFooter != null) ...[
                instanceSpecificsFooter!,
                const SizedBox(height: 14),
              ],

              // UNIFIED ATTACHMENTS SECTION
              if (instanceId != null && instanceId!.isNotEmpty) ...[
                // Unified card for Instance View (Showing Species + Instance attachments together)
                _buildUnifiedInstanceAttachments(
                  context,
                  ref,
                  speciesAttachmentsAsync: speciesAttachmentsAsync,
                  instanceAttachmentsAsync: instanceAttachmentsAsync!,
                ),
              ] else ...[
                // Species View Attachments
                _UnifiedAttachmentGroupWidget(
                  title: AppStrings.attachmentsTitle,
                  attachments: workingSpeciesAttachments ?? speciesAttachmentsAsync.asData?.value ?? [],
                  isEditing: showAttachmentAction,
                  isInstanceView: false,
                  onAdd: () => _handleAddAttachment(
                    context,
                    ref,
                    species.id,
                    instanceId: null,
                    currentAttachments: workingSpeciesAttachments ?? speciesAttachmentsAsync.asData?.value ?? [],
                  ),
                  onOpen: (att) => _openAttachment(context, ref, att),
                  onOpenExternally: (att) => _openExternally(context, ref, att),
                  onShare: (att) => _shareAttachment(context, ref, att),
                  onReplace: (att) => _handleReplaceAttachment(context, ref, att),
                  onRename: (att) => _handleRenameAttachment(context, ref, att),
                  onDelete: (att) => _confirmAndDeleteAttachment(context, ref, att),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUnifiedInstanceAttachments(
    BuildContext context,
    WidgetRef ref, {
    required AsyncValue<List<Attachment>> speciesAttachmentsAsync,
    required AsyncValue<List<Attachment>> instanceAttachmentsAsync,
  }) {
    final speciesAtts = speciesAttachmentsAsync.asData?.value ?? [];
    final instanceAtts = workingInstanceAttachments ?? instanceAttachmentsAsync.asData?.value ?? [];

    if (workingInstanceAttachments == null && (speciesAttachmentsAsync.isLoading || instanceAttachmentsAsync.isLoading)) {
      return const Center(child: CircularProgressIndicator());
    }

    final unifiedList = <Attachment>[...instanceAtts, ...speciesAtts];

    return _UnifiedAttachmentGroupWidget(
      title: AppStrings.attachmentsTitle,
      attachments: unifiedList,
      isEditing: showAttachmentAction,
      isInstanceView: true,
      onAdd: () => _handleAddAttachment(
        context,
        ref,
        species.id,
        instanceId: instanceId,
        currentAttachments: instanceAtts,
      ),
      onOpen: (att) => _openAttachment(context, ref, att),
      onOpenExternally: (att) => _openExternally(context, ref, att),
      onShare: (att) => _shareAttachment(context, ref, att),
      onReplace: (att) => _handleReplaceAttachment(context, ref, att),
      onRename: (att) => _handleRenameAttachment(context, ref, att),
      onDelete: (att) => _confirmAndDeleteAttachment(context, ref, att),
    );
  }
}

class _UnifiedAttachmentGroupWidget extends StatelessWidget {
  final String title;
  final List<Attachment> attachments;
  final bool isEditing;
  final bool isInstanceView;
  final VoidCallback onAdd;
  final Function(Attachment) onOpen;
  final Function(Attachment) onOpenExternally;
  final Function(Attachment) onShare;
  final Function(Attachment) onReplace;
  final Function(Attachment) onRename;
  final Function(Attachment) onDelete;

  const _UnifiedAttachmentGroupWidget({
    required this.title,
    required this.attachments,
    required this.isEditing,
    required this.isInstanceView,
    required this.onAdd,
    required this.onOpen,
    required this.onOpenExternally,
    required this.onShare,
    required this.onReplace,
    required this.onRename,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              children: [
                Icon(
                  Icons.folder_open,
                  size: 18,
                  color: theme.colorScheme.primary,
                ),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withAlpha(25),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    attachments.length.toString(),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Add button if in editing mode
            if (isEditing) ...[
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: onAdd,
                  icon: const Icon(Icons.add_photo_alternate_outlined, size: 16),
                  label: Text(
                    isInstanceView ? AppStrings.addAttachmentToThisInstance : AppStrings.attachFile,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],

            // Empty state or list
            if (attachments.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  AppStrings.emptyAttachments,
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: attachments.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, idx) {
                  final att = attachments[idx];
                  final isSpeciesLevel = att.instanceId == null || att.instanceId!.isEmpty;
                  final isEditable = isEditing && (!isInstanceView || !isSpeciesLevel);

                  final isImage = att.fileType == AppTechnicalStrings.fileTypeImage ||
                      [
                        AppTechnicalStrings.extJpg,
                        AppTechnicalStrings.extJpeg,
                        AppTechnicalStrings.extPng,
                        AppTechnicalStrings.extWebp,
                        AppTechnicalStrings.extHeic,
                        AppTechnicalStrings.extBmp,
                      ].any((ext) => att.filePath.toLowerCase().endsWith(ext));

                  return _AttachmentListTile(
                    key: ValueKey(att.id),
                    attachment: att,
                    isInstanceView: isInstanceView,
                    isEditable: isEditable,
                    isImage: isImage,
                    onOpen: () => onOpen(att),
                    onOpenExternally: () => onOpenExternally(att),
                    onShare: () => onShare(att),
                    onReplace: () => onReplace(att),
                    onRename: () => onRename(att),
                    onDelete: () => onDelete(att),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _AttachmentListTile extends ConsumerStatefulWidget {
  final Attachment attachment;
  final bool isInstanceView;
  final bool isEditable;
  final bool isImage;
  final VoidCallback onOpen;
  final VoidCallback onOpenExternally;
  final VoidCallback onShare;
  final VoidCallback onReplace;
  final VoidCallback onRename;
  final VoidCallback onDelete;

  const _AttachmentListTile({
    super.key,
    required this.attachment,
    required this.isInstanceView,
    required this.isEditable,
    required this.isImage,
    required this.onOpen,
    required this.onOpenExternally,
    required this.onShare,
    required this.onReplace,
    required this.onRename,
    required this.onDelete,
  });

  @override
  ConsumerState<_AttachmentListTile> createState() => _AttachmentListTileState();
}

class _AttachmentListTileState extends ConsumerState<_AttachmentListTile> {
  late Future<String> _absPathFuture;

  @override
  void initState() {
    super.initState();
    _absPathFuture = ref.read(fileStorageServiceProvider).getAbsolutePath(widget.attachment.filePath);
  }

  @override
  void didUpdateWidget(covariant _AttachmentListTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.attachment.filePath != widget.attachment.filePath) {
      _absPathFuture = ref.read(fileStorageServiceProvider).getAbsolutePath(widget.attachment.filePath);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final att = widget.attachment;
    final isSpeciesLevel = att.instanceId == null || att.instanceId!.isEmpty;

    return FutureBuilder<String>(
      future: _absPathFuture,
      builder: (context, snapshot) {
        final isResolving = snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData;
        final absPath = snapshot.data ?? AppTechnicalStrings.empty;
        final fileExists = absPath.isNotEmpty && File(absPath).existsSync();

        return ListTile(
          dense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          leading: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: isResolving
                  ? theme.colorScheme.surfaceContainerHighest.withAlpha(50)
                  : (fileExists
                      ? (widget.isImage ? Colors.blue.withAlpha(20) : Colors.amber.withAlpha(20))
                      : Colors.red.withAlpha(20)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: isResolving
                  ? const Icon(Icons.attach_file, color: Colors.grey, size: 20)
                  : (!fileExists
                      ? const Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 20)
                      : (widget.isImage
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                File(absPath),
                                fit: BoxFit.cover,
                                width: 38,
                                height: 38,
                                errorBuilder: (_, __, ___) => const Icon(Icons.image, size: 20, color: Colors.blue),
                              ),
                            )
                          : const Icon(Icons.picture_as_pdf, color: Colors.amber, size: 20))),
            ),
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  att.fileName,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: (isResolving || fileExists) ? null : Colors.red.shade700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (widget.isInstanceView) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                  decoration: BoxDecoration(
                    color: isSpeciesLevel
                        ? theme.colorScheme.primary.withAlpha(25)
                        : Colors.teal.withAlpha(25),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: isSpeciesLevel
                          ? theme.colorScheme.primary.withAlpha(90)
                          : Colors.teal.withAlpha(90),
                    ),
                  ),
                  child: Text(
                    isSpeciesLevel ? AppStrings.speciesLabel : AppStrings.instanceLabel,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: isSpeciesLevel ? theme.colorScheme.primary : Colors.teal.shade800,
                    ),
                  ),
                ),
              ],
            ],
          ),
          subtitle: isResolving
              ? const SizedBox.shrink()
              : (fileExists
                  ? Text(
                      att.createdAt.toString().split(AppTechnicalStrings.dot).first,
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    )
                  : const Text(
                      AppStrings.physicalFileNotFound,
                      style: TextStyle(fontSize: 11, color: Colors.redAccent, fontWeight: FontWeight.bold),
                    )),
          onTap: widget.onOpen,
          trailing: PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, size: 18),
            tooltip: AppStrings.attachmentOptionsTooltip,
            onSelected: (value) {
              switch (value) {
                case AppTechnicalStrings.actionOpen:
                  widget.onOpen();
                  break;
                case AppTechnicalStrings.actionOpenExternally:
                  widget.onOpenExternally();
                  break;
                case AppTechnicalStrings.actionShare:
                  widget.onShare();
                  break;
                case AppTechnicalStrings.actionReplace:
                  widget.onReplace();
                  break;
                case AppTechnicalStrings.actionRename:
                  widget.onRename();
                  break;
                case AppTechnicalStrings.actionDelete:
                  widget.onDelete();
                  break;
              }
            },
            itemBuilder: (ctx) => [
              if (!widget.isEditable) ...[
                const PopupMenuItem(
                  value: AppTechnicalStrings.actionOpenExternally,
                  child: Row(
                    children: [
                      Icon(Icons.open_in_new, size: 16, color: Colors.blueAccent),
                      SizedBox(width: 8),
                      Text(AppStrings.openExternallyAction, style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: AppTechnicalStrings.actionShare,
                  child: Row(
                    children: [
                      Icon(Icons.share, size: 16, color: Colors.teal),
                      SizedBox(width: 8),
                      Text(AppStrings.shareAction, style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ],
              if (widget.isEditable) ...[
                const PopupMenuItem(
                  value: AppTechnicalStrings.actionReplace,
                  child: Row(
                    children: [
                      Icon(Icons.sync, size: 16, color: Colors.blue),
                      SizedBox(width: 8),
                      Text(AppStrings.replaceFileAction, style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: AppTechnicalStrings.actionRename,
                  child: Row(
                    children: [
                      Icon(Icons.edit_outlined, size: 16, color: Colors.amber),
                      SizedBox(width: 8),
                      Text(AppStrings.renameAction, style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: AppTechnicalStrings.actionDelete,
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline, size: 16, color: Colors.redAccent),
                      SizedBox(width: 8),
                      Text(AppStrings.delete, style: TextStyle(fontSize: 12, color: Colors.redAccent)),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
