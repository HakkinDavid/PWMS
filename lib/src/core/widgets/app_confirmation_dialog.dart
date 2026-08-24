import 'package:flutter/material.dart';
import '../constants/app_strings.dart';

class AppConfirmationDialog {
  AppConfirmationDialog._();

  /// Shows a customizable confirmation dialog and returns true if confirmed, false otherwise.
  static Future<bool> show({
    required BuildContext context,
    required String title,
    required String message,
    String confirmLabel = AppStrings.confirm,
    String cancelLabel = AppStrings.cancel,
    bool isDestructive = false,
    IconData? icon,
    Color? iconColor,
  }) async {
    final theme = Theme.of(context);

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: !isDestructive,
      builder: (ctx) => AlertDialog(
        icon: icon != null
            ? Icon(
                icon,
                size: 32,
                color: iconColor ?? (isDestructive ? Colors.redAccent : theme.colorScheme.primary),
              )
            : null,
        title: Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          textAlign: icon != null ? TextAlign.center : TextAlign.start,
        ),
        content: Text(
          message,
          style: theme.textTheme.bodyMedium,
          textAlign: icon != null ? TextAlign.center : TextAlign.start,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(cancelLabel),
          ),
          ElevatedButton(
            style: isDestructive
                ? ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                  )
                : null,
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(confirmLabel),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  /// Specialized confirmation dialog when unsaved changes are detected.
  /// Returns `true` if the user chooses to discard changes, `false` to keep editing.
  static Future<bool> showDiscardChangesDialog(BuildContext context) async {
    return show(
      context: context,
      title: AppStrings.unsavedChangesTitle,
      message: AppStrings.unsavedChangesMessage,
      confirmLabel: AppStrings.discardChangesAction,
      cancelLabel: AppStrings.keepEditingAction,
      isDestructive: true,
      icon: Icons.warning_amber_rounded,
      iconColor: Colors.amber.shade800,
    );
  }

  /// Specialized dialog for destructive deletions.
  static Future<bool> showDeleteConfirmation({
    required BuildContext context,
    required String title,
    required String message,
  }) async {
    return show(
      context: context,
      title: title,
      message: message,
      confirmLabel: AppStrings.delete,
      cancelLabel: AppStrings.cancel,
      isDestructive: true,
      icon: Icons.delete_outline,
      iconColor: Colors.redAccent,
    );
  }
}
