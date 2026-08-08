import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/providers.dart';
import '../../catalog/domain/catalog_item.dart';
import '../../catalog/domain/subspecies.dart';
import 'i_entity_repository.dart';

/// Helper to resolve the effective display photo path for an entity instance or group.
/// Resolution priority:
/// 1. Subspecies photo (`subspecies.photoPath`) if present.
/// 2. Species main photo (`species.mainPhotoPath`) if present.
/// 3. First attached image of the specific instance (`instanceId`), if present.
/// 4. Returns null if no image is found.
Future<String?> resolveEffectiveEntityPhotoPath(
  WidgetRef ref, {
  Subspecies? subspecies,
  CatalogItem? species,
  String? instanceId,
}) {
  return resolveEffectiveEntityPhotoPathWithRepo(
    ref.read(entityRepositoryProvider),
    subspecies: subspecies,
    species: species,
    instanceId: instanceId,
  );
}

Future<String?> resolveEffectiveEntityPhotoPathWithRepo(
  IEntityRepository entityRepo, {
  Subspecies? subspecies,
  CatalogItem? species,
  String? instanceId,
}) async {
  if (subspecies?.photoPath != null && subspecies!.photoPath!.trim().isNotEmpty) {
    return subspecies.photoPath;
  }
  if (species?.mainPhotoPath != null && species!.mainPhotoPath!.trim().isNotEmpty) {
    return species.mainPhotoPath;
  }
  if (instanceId != null && instanceId.isNotEmpty) {
    final attachments = await entityRepo.getAttachmentsForInstance(instanceId);
    final imageAttachment = attachments.where((a) {
      if (a.fileType == 'image') return true;
      final path = a.filePath.toLowerCase();
      return path.endsWith('.jpg') ||
          path.endsWith('.jpeg') ||
          path.endsWith('.png') ||
          path.endsWith('.webp') ||
          path.endsWith('.heic') ||
          path.endsWith('.bmp');
    }).firstOrNull;
    if (imageAttachment != null) {
      return imageAttachment.filePath;
    }
  }
  return null;
}
