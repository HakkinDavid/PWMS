import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import 'package:platinum_world_management_system/src/core/constants/app_technical_strings.dart';
import 'numismatic_camera_capture_view.dart';
import 'web_image_picker_dialog.dart';

class NumismaticScanOption {
  final bool isCoin;
  final String missingSide; // 'anverso', 'reverso', or 'ambos'
  final File? existingObverseFile;
  final File? existingReverseFile;

  const NumismaticScanOption({
    required this.isCoin,
    required this.missingSide,
    this.existingObverseFile,
    this.existingReverseFile,
  });
}

class SelectedMediaResult {
  final File? file;
  final String? relativeStoredPath;
  final String fileName;
  final String fileType; // 'image', 'pdf', 'doc', etc.
  final String source; // 'camera', 'gallery', 'web', 'file', 'numismatic'

  const SelectedMediaResult({
    this.file,
    this.relativeStoredPath,
    required this.fileName,
    required this.fileType,
    required this.source,
  });
}

class StandardMediaPickerSheet extends StatelessWidget {
  final String? title;
  final String? webSearchQuery;
  final bool allowDocuments;
  final bool showNumismaticObverse;
  final bool showNumismaticReverse;
  final bool isCoin;
  final File? existingObverseFile;
  final File? existingReverseFile;
  final NumismaticScanOption? numismaticOption;

  const StandardMediaPickerSheet({
    super.key,
    this.title,
    this.webSearchQuery,
    this.allowDocuments = true,
    this.showNumismaticObverse = false,
    this.showNumismaticReverse = false,
    this.isCoin = true,
    this.existingObverseFile,
    this.existingReverseFile,
    this.numismaticOption,
  });

  static Future<SelectedMediaResult?> show(
    BuildContext context, {
    String? title,
    String? webSearchQuery,
    bool allowDocuments = true,
    bool showNumismaticObverse = false,
    bool showNumismaticReverse = false,
    bool isCoin = true,
    File? existingObverseFile,
    File? existingReverseFile,
    NumismaticScanOption? numismaticOption,
  }) {
    final bool obverse = showNumismaticObverse ||
        (numismaticOption != null && (numismaticOption.missingSide == AppTechnicalStrings.sideAnverso || numismaticOption.missingSide == AppTechnicalStrings.sideAmbos));
    final bool reverse = showNumismaticReverse ||
        (numismaticOption != null && (numismaticOption.missingSide == AppTechnicalStrings.sideReverso || numismaticOption.missingSide == AppTechnicalStrings.sideAmbos));
    final bool coin = numismaticOption?.isCoin ?? isCoin;
    final File? obvFile = numismaticOption?.existingObverseFile ?? existingObverseFile;
    final File? revFile = numismaticOption?.existingReverseFile ?? existingReverseFile;

    return showModalBottomSheet<SelectedMediaResult?>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StandardMediaPickerSheet(
        title: title,
        webSearchQuery: webSearchQuery,
        allowDocuments: allowDocuments,
        showNumismaticObverse: obverse,
        showNumismaticReverse: reverse,
        isCoin: coin,
        existingObverseFile: obvFile,
        existingReverseFile: revFile,
      ),
    );
  }

  Future<void> _handleCamera(BuildContext context) async {
    final picker = ImagePicker();
    final xfile = await picker.pickImage(source: ImageSource.camera, imageQuality: 90);
    if (xfile != null && context.mounted) {
      final file = File(xfile.path);
      final fileName = p.basename(xfile.path);
      Navigator.pop(
        context,
        SelectedMediaResult(
          file: file,
          fileName: fileName,
          fileType: AppTechnicalStrings.fileTypeImage,
          source: AppTechnicalStrings.mediaSourceCamera,
        ),
      );
    }
  }

  Future<void> _handleGallery(BuildContext context) async {
    final picker = ImagePicker();
    final xfile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 90);
    if (xfile != null && context.mounted) {
      final file = File(xfile.path);
      final fileName = p.basename(xfile.path);
      Navigator.pop(
        context,
        SelectedMediaResult(
          file: file,
          fileName: fileName,
          fileType: AppTechnicalStrings.fileTypeImage,
          source: AppTechnicalStrings.mediaSourceGallery,
        ),
      );
    }
  }

  Future<void> _handleWebSearch(BuildContext context) async {
    final query = webSearchQuery?.trim() ?? AppTechnicalStrings.empty;
    final relPath = await WebImagePickerDialog.show(context, searchQuery: query);
    if (relPath != null && relPath.isNotEmpty && context.mounted) {
      final fileName = p.basename(relPath);
      Navigator.pop(
        context,
        SelectedMediaResult(
          relativeStoredPath: relPath,
          fileName: fileName,
          fileType: AppTechnicalStrings.fileTypeImage,
          source: AppTechnicalStrings.mediaSourceWeb,
        ),
      );
    }
  }

  Future<void> _handleFilePicker(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null && context.mounted) {
      final picked = result.files.single;
      final file = File(picked.path!);
      final ext = picked.extension?.toLowerCase() ?? AppTechnicalStrings.extFileClean;
      final isImg = [
        AppTechnicalStrings.extJpgClean,
        AppTechnicalStrings.extJpegClean,
        AppTechnicalStrings.extPngClean,
        AppTechnicalStrings.extWebpClean,
        AppTechnicalStrings.extHeicClean,
        AppTechnicalStrings.extBmpClean,
      ].contains(ext);

      Navigator.pop(
        context,
        SelectedMediaResult(
          file: file,
          fileName: picked.name,
          fileType: isImg ? AppTechnicalStrings.fileTypeImage : ext,
          source: AppTechnicalStrings.mediaSourceFile,
        ),
      );
    }
  }

  Future<void> _handleNumismaticSideScan(BuildContext context, String side) async {
    final file = await NumismaticCameraCaptureView.show(
      context,
      isCoin: isCoin,
      targetSide: side,
      existingObverseFile: existingObverseFile,
      existingReverseFile: existingReverseFile,
      hideSideSelector: true,
    );

    if (file != null && context.mounted) {
      final fileName = p.basename(file.path);
      Navigator.pop(
        context,
        SelectedMediaResult(
          file: file,
          fileName: fileName,
          fileType: AppTechnicalStrings.fileTypeImage,
          source: AppTechnicalStrings.mediaSourceNumismatic,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.dialogTheme.backgroundColor ?? theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Center(
                child: Container(
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.withAlpha(90),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Text(
                      title ?? AppStrings.selectOrCaptureAttachmentTitle,
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Divider(height: 1),

              // Conditional Numismatic Obverse Scan Option
              if (showNumismaticObverse) ...[
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.amber.withAlpha(35),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      isCoin ? Icons.circle_outlined : Icons.crop_landscape,
                      color: Colors.amber.shade800,
                      size: 22,
                    ),
                  ),
                  title: const Text(
                    AppStrings.scanObverseTitle,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    AppStrings.numismaticObverseSubtitle(isCoin ? AppStrings.coinWord : AppStrings.banknoteWord),
                    style: const TextStyle(fontSize: 11),
                  ),
                  onTap: () => _handleNumismaticSideScan(context, AppTechnicalStrings.sideAnverso),
                ),
                const Divider(height: 1),
              ],

              // Conditional Numismatic Reverse Scan Option
              if (showNumismaticReverse) ...[
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.amber.withAlpha(35),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      isCoin ? Icons.circle_outlined : Icons.crop_landscape,
                      color: Colors.amber.shade800,
                      size: 22,
                    ),
                  ),
                  title: const Text(
                    AppStrings.scanReverseTitle,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    AppStrings.numismaticReverseSubtitle(isCoin ? AppStrings.coinWord : AppStrings.banknoteWord),
                    style: const TextStyle(fontSize: 11),
                  ),
                  onTap: () => _handleNumismaticSideScan(context, AppTechnicalStrings.sideReverso),
                ),
                const Divider(height: 1),
              ],

              // Standard Camera
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text(AppStrings.takePhoto),
                subtitle: const Text(AppStrings.standardCameraCapture, style: TextStyle(fontSize: 11)),
                onTap: () => _handleCamera(context),
              ),

              // Gallery
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text(AppStrings.chooseGallery),
                subtitle: const Text(AppStrings.chooseFromGallery, style: TextStyle(fontSize: 11)),
                onTap: () => _handleGallery(context),
              ),

              // Web Search
              ListTile(
                leading: const Icon(Icons.travel_explore),
                title: const Text(AppStrings.searchWeb),
                subtitle: Text(
                  webSearchQuery != null && webSearchQuery!.isNotEmpty
                      ? AppStrings.suggestedSearchQuery(webSearchQuery!)
                      : AppStrings.searchOnlineImagesByName,
                  style: const TextStyle(fontSize: 11),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () => _handleWebSearch(context),
              ),

              // Documents / File Picker
              if (allowDocuments) ...[
                ListTile(
                  leading: const Icon(Icons.attach_file),
                  title: const Text(AppStrings.fileExplorer),
                  subtitle: const Text(AppStrings.selectPdfOrDocument, style: TextStyle(fontSize: 11)),
                  onTap: () => _handleFilePicker(context),
                ),
              ],

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
