import 'dart:io';
import 'package:flutter/material.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import '../domain/world_entity.dart';

class PhotoViewerDialog extends StatelessWidget {
  final WorldEntity entity;
  final String imagePath;
  final VoidCallback onChangePhoto;
  final VoidCallback onDeletePhoto;

  const PhotoViewerDialog({
    super.key,
    required this.entity,
    required this.imagePath,
    required this.onChangePhoto,
    required this.onDeletePhoto,
  });

  static void show(
    BuildContext context, {
    required WorldEntity entity,
    required String imagePath,
    required VoidCallback onChangePhoto,
    required VoidCallback onDeletePhoto,
  }) {
    showDialog(
      context: context,
      builder: (_) => PhotoViewerDialog(
        entity: entity,
        imagePath: imagePath,
        onChangePhoto: onChangePhoto,
        onDeletePhoto: onDeletePhoto,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      backgroundColor: Colors.black,
      insetPadding: EdgeInsets.zero,
      child: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            InteractiveViewer(
              child: File(imagePath).existsSync()
                  ? Image.file(
                      File(imagePath),
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Center(child: Text(AppStrings.photoNotAvailable, style: TextStyle(color: Colors.white))),
                    )
                  : const Center(child: Text(AppStrings.photoNotAvailable, style: TextStyle(color: Colors.white))),
            ),
            Positioned(
              top: 16,
              left: 16,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 28),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      onChangePhoto();
                    },
                    icon: const Icon(Icons.photo_camera),
                    label: const Text(AppStrings.changePhotoAction),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      onDeletePhoto();
                    },
                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                    label: const Text(AppStrings.delete, style: TextStyle(color: Colors.redAccent)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.redAccent),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
