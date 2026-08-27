import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import 'package:platinum_world_management_system/src/core/constants/app_technical_strings.dart';
import '../../../core/providers/providers.dart';
import '../../../core/widgets/app_confirmation_dialog.dart';
import '../../../core/widgets/app_toast.dart';
import '../domain/custom_template.dart';

class CustomTemplateEditorSheet extends ConsumerStatefulWidget {
  const CustomTemplateEditorSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const CustomTemplateEditorSheet(),
    );
  }

  @override
  ConsumerState<CustomTemplateEditorSheet> createState() => _CustomTemplateEditorSheetState();
}

class _CustomTemplateEditorSheetState extends ConsumerState<CustomTemplateEditorSheet> {
  final _nameController = TextEditingController();
  final _unitsController = TextEditingController();
  final String _selectedIcon = AppTechnicalStrings.iconBuild;
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _unitsController.dispose();
    super.dispose();
  }

  bool _forceClose = false;

  bool _hasUnsavedChanges() {
    return _nameController.text.trim().isNotEmpty || _unitsController.text.trim().isNotEmpty;
  }

  Future<bool> _requestClose() async {
    if (_hasUnsavedChanges()) {
      final discard = await AppConfirmationDialog.showDiscardChangesDialog(context);
      if (!discard) return false;
    }
    _forceClose = true;
    return true;
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    setState(() => _isSaving = true);

    try {
      final unitsStr = _unitsController.text.trim();
      final unitsList = unitsStr.isNotEmpty
          ? unitsStr.split(AppTechnicalStrings.comma).map((e) => e.trim()).where((e) => e.isNotEmpty).toList()
          : <String>[];

      final template = CustomTemplate(
        id: const Uuid().v4(),
        typeName: name,
        iconName: _selectedIcon,
        commonUnits: unitsList,
        createdAt: DateTime.now(),
      );

      await ref.read(entityRepositoryProvider).saveCustomTemplate(template);

      if (mounted) {
        _forceClose = true;
        Navigator.pop(context);
        AppToast.showSuccess(context, AppStrings.templateSavedSuccess);
      }
    } catch (e) {
      if (mounted) {
        AppToast.showError(context, AppStrings.errorWithDetails(e));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final mediaQuery = MediaQuery.of(context);
    final bottomPadding = mediaQuery.viewInsets.bottom > 0
        ? mediaQuery.viewInsets.bottom + 20
        : mediaQuery.padding.bottom + 20;

    return PopScope(
      canPop: _forceClose,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final canClose = await _requestClose();
        if (canClose && mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 16,
          bottom: bottomPadding,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.withAlpha(100),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    AppStrings.templateCustomCreate,
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  tooltip: AppStrings.close,
                  onPressed: () async {
                    final canClose = await _requestClose();
                    if (canClose && mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _nameController,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: AppStrings.templateNameLabel,
                hintText: AppStrings.templateExamplesHint,
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _unitsController,
              decoration: const InputDecoration(
                labelText: AppStrings.templateUnitsHintLabel,
                hintText: AppStrings.templateUnitsExamples,
              ),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: _isSaving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(AppStrings.saveTemplateAction, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
