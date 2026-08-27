import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:platinum_world_management_system/src/core/providers/providers.dart';
import 'package:platinum_world_management_system/src/core/widgets/app_toast.dart';
import '../../../catalog/domain/catalog_item.dart';
import '../../../catalog/domain/subspecies.dart';
import '../../../catalog/presentation/species_tile.dart';
import '../../../catalog/presentation/standard_media_picker_sheet.dart';
import '../../../catalog/presentation/subspecies_tile.dart';
import '../../../entities/domain/entity_display_helper.dart';
import '../../../entities/domain/world_entity.dart';
import '../../../entities/presentation/instance_preview_card.dart';
import '../../../locations/domain/location_path_helper.dart';
import '../../../locations/presentation/location_or_container_correction_sheet.dart';
import '../audit_rule_strategy.dart';

/// Helper utility for creating [AuditCardData] instances and handling common
/// audit resolution actions across Control Center strategies.
class AuditRuleHelper {
  const AuditRuleHelper._();

  /// Creates a standard confirmation callback that displays a toast message.
  static Future<bool> Function(BuildContext, WidgetRef) confirmWithToast(String message) {
    return (ctx, ref) async {
      if (ctx.mounted) {
        AppToast.showSuccess(ctx, message);
      }
      return true;
    };
  }

  /// Builds a standard display name for an entity using evaluation context.
  static String getEntityDisplayName(AuditEvaluationContext context, WorldEntity entity) {
    return EntityDisplayHelper.getDisplayName(
      entity: entity,
      catalogItems: context.allCatalog,
      subspeciesList: context.allSubspecies,
    );
  }

  /// Builds the effective location breadcrumb for an entity.
  static LocationBreadcrumb getEntityBreadcrumb(AuditEvaluationContext context, WorldEntity entity) {
    return LocationPathHelper.buildEffectiveBreadcrumb(
      entityId: entity.id,
      effectiveLocationId: entity.locationId,
      allEntities: context.allEntities,
      allRelations: context.allRelations,
      allNodes: context.allLocations,
      catalogItems: context.allCatalog,
      subspeciesList: context.allSubspecies,
    );
  }

  /// Shows the location or container correction sheet for an entity.
  static Future<bool> openLocationCorrection(
    BuildContext ctx,
    WidgetRef ref, {
    required String entityId,
    WorldEntity? fallback,
  }) async {
    final freshEntity = await ref.read(entityRepositoryProvider).getEntityById(entityId) ?? fallback;
    if (freshEntity == null) return false;
    return await LocationOrContainerCorrectionSheet.show(ctx, entity: freshEntity);
  }

  /// Helper to create an [AuditCardData] for an entity.
  /// Automatically sets [InstancePreviewCard] as the default tile.
  static AuditCardData forEntity({
    required String id,
    required AuditCardType type,
    required String title,
    required String subtitle,
    required String question,
    required IconData icon,
    required Color themeColor,
    required WorldEntity entity,
    CatalogItem? species,
    Subspecies? subspecies,
    Widget? tile,
    String? confirmToastMessage,
    Future<bool> Function(BuildContext, WidgetRef)? onConfirm,
    required Future<bool> Function(BuildContext, WidgetRef) onFix,
  }) {
    assert(confirmToastMessage != null || onConfirm != null, 'Either confirmToastMessage or onConfirm must be provided');
    return AuditCardData(
      id: id,
      type: type,
      title: title,
      subtitle: subtitle,
      question: question,
      icon: icon,
      themeColor: themeColor,
      entity: entity,
      species: species,
      subspecies: subspecies,
      tile: tile ?? InstancePreviewCard(entity: entity),
      onConfirm: onConfirm ?? confirmWithToast(confirmToastMessage!),
      onFix: onFix,
    );
  }

  /// Helper to create an [AuditCardData] for a species.
  /// Automatically sets [SpeciesTile] as the default tile.
  static AuditCardData forSpecies({
    required String id,
    required AuditCardType type,
    required String title,
    required String subtitle,
    required String question,
    required IconData icon,
    required Color themeColor,
    required CatalogItem species,
    Widget? tile,
    String? confirmToastMessage,
    Future<bool> Function(BuildContext, WidgetRef)? onConfirm,
    required Future<bool> Function(BuildContext, WidgetRef) onFix,
  }) {
    assert(confirmToastMessage != null || onConfirm != null, 'Either confirmToastMessage or onConfirm must be provided');
    return AuditCardData(
      id: id,
      type: type,
      title: title,
      subtitle: subtitle,
      question: question,
      icon: icon,
      themeColor: themeColor,
      species: species,
      tile: tile ?? SpeciesTile(species: species),
      onConfirm: onConfirm ?? confirmWithToast(confirmToastMessage!),
      onFix: onFix,
    );
  }

  /// Helper to create an [AuditCardData] for a subspecies.
  /// Automatically sets [SubspeciesTile] as the default tile.
  static AuditCardData forSubspecies({
    required String id,
    required AuditCardType type,
    required String title,
    required String subtitle,
    required String question,
    required IconData icon,
    required Color themeColor,
    required Subspecies subspecies,
    CatalogItem? species,
    String? speciesName,
    Widget? tile,
    String? confirmToastMessage,
    Future<bool> Function(BuildContext, WidgetRef)? onConfirm,
    required Future<bool> Function(BuildContext, WidgetRef) onFix,
  }) {
    assert(confirmToastMessage != null || onConfirm != null, 'Either confirmToastMessage or onConfirm must be provided');
    return AuditCardData(
      id: id,
      type: type,
      title: title,
      subtitle: subtitle,
      question: question,
      icon: icon,
      themeColor: themeColor,
      subspecies: subspecies,
      species: species,
      tile: tile ?? SubspeciesTile(subspecies: subspecies, speciesName: speciesName ?? species?.name),
      onConfirm: onConfirm ?? confirmWithToast(confirmToastMessage!),
      onFix: onFix,
    );
  }

  /// Generic helper to create an [AuditCardData] with optional toast on confirm.
  static AuditCardData createCard({
    required String id,
    required AuditCardType type,
    required String title,
    required String subtitle,
    required String question,
    required IconData icon,
    required Color themeColor,
    required Widget tile,
    CatalogItem? species,
    Subspecies? subspecies,
    WorldEntity? entity,
    String? confirmToastMessage,
    Future<bool> Function(BuildContext, WidgetRef)? onConfirm,
    required Future<bool> Function(BuildContext, WidgetRef) onFix,
  }) {
    assert(confirmToastMessage != null || onConfirm != null, 'Either confirmToastMessage or onConfirm must be provided');
    return AuditCardData(
      id: id,
      type: type,
      title: title,
      subtitle: subtitle,
      question: question,
      icon: icon,
      themeColor: themeColor,
      species: species,
      subspecies: subspecies,
      entity: entity,
      tile: tile,
      onConfirm: onConfirm ?? confirmWithToast(confirmToastMessage!),
      onFix: onFix,
    );
  }

  /// Displays a simple confirmation dialog with Cancel and Action buttons.
  static Future<bool> showConfirmationDialog(
    BuildContext context, {
    required String title,
    required String content,
    required String confirmLabel,
    bool isDestructive = false,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogCtx, false), child: const Text('Cancelar')),
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx, true),
            child: Text(
              confirmLabel,
              style: TextStyle(
                color: isDestructive ? Colors.redAccent : null,
                fontWeight: isDestructive ? null : FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
    return result == true;
  }

  /// Displays a dialog with a text field for entering or editing single values.
  static Future<String?> showTextInputDialog(
    BuildContext context, {
    required String title,
    required String labelText,
    String? initialValue,
    String? suffixText,
    TextInputType keyboardType = TextInputType.text,
  }) async {
    final controller = TextEditingController(text: initialValue);
    return await showDialog<String>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            labelText: labelText,
            suffixText: suffixText,
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogCtx, null), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogCtx, controller.text.trim()),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  /// Resolves a remote image by attempting to download it or prompting the user with the media picker sheet.
  /// Calls [onSave] with the new relative path if resolved.
  static Future<bool> resolveRemoteImage({
    required BuildContext context,
    required WidgetRef ref,
    required String remoteUrl,
    required String displayName,
    required Future<void> Function(String relativePath) onSave,
  }) async {
    final lookupService = ref.read(productLookupServiceProvider);
    final fileStorage = ref.read(fileStorageServiceProvider);
    final localTempPath = await lookupService.downloadAndSaveImage(remoteUrl);
    if (localTempPath != null) {
      final relPath = await fileStorage.saveFile(localTempPath);
      await onSave(relPath);
      if (context.mounted) {
        AppToast.showSuccess(context, 'Imagen descargada y guardada localmente con éxito.');
      }
      return true;
    } else {
      if (context.mounted) {
        AppToast.showError(context, 'No se pudo descargar automáticamente la imagen. Puedes seleccionarla mediante el selector de medios.');
        final picked = await StandardMediaPickerSheet.show(
          context,
          title: 'Foto de $displayName',
          webSearchQuery: displayName,
          allowDocuments: false,
        );
        if (picked != null) {
          final relPath = picked.file != null
              ? await fileStorage.saveFile(picked.file!.path)
              : picked.relativeStoredPath;
          if (relPath != null) {
            await onSave(relPath);
            return true;
          }
        }
        return false;
      }
    }
    return false;
  }
}
