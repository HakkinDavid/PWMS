import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/providers/providers.dart';
import '../domain/custom_template.dart';

class CustomTemplateEditorSheet extends ConsumerStatefulWidget {
  const CustomTemplateEditorSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
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
  final String _selectedIcon = 'build';
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _unitsController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    setState(() => _isSaving = true);

    try {
      final unitsStr = _unitsController.text.trim();
      final unitsList = unitsStr.isNotEmpty
          ? unitsStr.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList()
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
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppStrings.templateSavedSuccess)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${AppStrings.errorPrefix}$e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
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
          const SizedBox(height: 16),
          Text(AppStrings.templateCustomCreate, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),

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
    );
  }
}
