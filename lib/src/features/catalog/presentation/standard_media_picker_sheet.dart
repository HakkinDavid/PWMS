import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import '../../../core/constants/app_strings.dart';
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
  final NumismaticScanOption? numismaticOption;

  const StandardMediaPickerSheet({
    super.key,
    this.title,
    this.webSearchQuery,
    this.allowDocuments = true,
    this.numismaticOption,
  });

  static Future<SelectedMediaResult?> show(
    BuildContext context, {
    String? title,
    String? webSearchQuery,
    bool allowDocuments = true,
    NumismaticScanOption? numismaticOption,
  }) {
    return showModalBottomSheet<SelectedMediaResult?>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StandardMediaPickerSheet(
        title: title,
        webSearchQuery: webSearchQuery,
        allowDocuments: allowDocuments,
        numismaticOption: numismaticOption,
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
          fileType: 'image',
          source: 'camera',
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
          fileType: 'image',
          source: 'gallery',
        ),
      );
    }
  }

  Future<void> _handleWebSearch(BuildContext context) async {
    final query = webSearchQuery?.trim() ?? '';
    final relPath = await WebImagePickerDialog.show(context, searchQuery: query);
    if (relPath != null && relPath.isNotEmpty && context.mounted) {
      final fileName = p.basename(relPath);
      Navigator.pop(
        context,
        SelectedMediaResult(
          relativeStoredPath: relPath,
          fileName: fileName,
          fileType: 'image',
          source: 'web',
        ),
      );
    }
  }

  Future<void> _handleFilePicker(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null && context.mounted) {
      final picked = result.files.single;
      final file = File(picked.path!);
      final ext = picked.extension?.toLowerCase() ?? 'file';
      final isImg = ['jpg', 'jpeg', 'png', 'webp', 'heic', 'bmp'].contains(ext);

      Navigator.pop(
        context,
        SelectedMediaResult(
          file: file,
          fileName: picked.name,
          fileType: isImg ? 'image' : ext,
          source: 'file',
        ),
      );
    }
  }

  Future<void> _handleNumismaticScan(BuildContext context, NumismaticScanOption opt) async {
    final side = opt.missingSide == 'ambos' ? 'anverso' : opt.missingSide;
    final file = await NumismaticCameraCaptureView.show(
      context,
      isCoin: opt.isCoin,
      targetSide: side,
      existingObverseFile: opt.existingObverseFile,
      existingReverseFile: opt.existingReverseFile,
    );

    if (file != null && context.mounted) {
      final fileName = p.basename(file.path);
      Navigator.pop(
        context,
        SelectedMediaResult(
          file: file,
          fileName: fileName,
          fileType: 'image',
          source: 'numismatic',
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasNumismaticOption = numismaticOption != null;

    return Container(
      decoration: BoxDecoration(
        color: theme.dialogBackgroundColor,
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
                      title ?? 'Seleccionar o Capturar Adjunto',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Divider(height: 1),

              // Conditional Numismatic Scan Option
              if (hasNumismaticOption) ...[
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.amber.withAlpha(35),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      numismaticOption!.isCoin ? Icons.circle_outlined : Icons.crop_landscape,
                      color: Colors.amber.shade800,
                      size: 22,
                    ),
                  ),
                  title: Text(
                    numismaticOption!.missingSide == 'anverso'
                        ? 'Escanear Anverso (Cámara Numismática HD)'
                        : (numismaticOption!.missingSide == 'reverso'
                            ? 'Escanear Reverso (Cámara Numismática HD)'
                            : 'Escanear Pieza Numismática (HD)'),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Retícula guiada, corrección de exposición y recorte centrado para ${numismaticOption!.isCoin ? "moneda" : "billete"}.',
                    style: const TextStyle(fontSize: 11),
                  ),
                  onTap: () => _handleNumismaticScan(context, numismaticOption!),
                ),
                const Divider(height: 1),
              ],

              // Standard Camera
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text(AppStrings.takePhoto),
                subtitle: const Text('Captura estándar con la cámara', style: TextStyle(fontSize: 11)),
                onTap: () => _handleCamera(context),
              ),

              // Gallery
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text(AppStrings.chooseGallery),
                subtitle: const Text('Elegir imagen de la galería de fotos', style: TextStyle(fontSize: 11)),
                onTap: () => _handleGallery(context),
              ),

              // Web Search
              ListTile(
                leading: const Icon(Icons.travel_explore),
                title: const Text('Buscar en la web'),
                subtitle: Text(
                  webSearchQuery != null && webSearchQuery!.isNotEmpty
                      ? 'Búsqueda sugerida: "$webSearchQuery"'
                      : 'Buscar imágenes online por nombre',
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
                  title: const Text('Explorador de archivos'),
                  subtitle: const Text('Seleccionar PDF, documento o archivo local', style: TextStyle(fontSize: 11)),
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
