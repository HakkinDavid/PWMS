import 'package:flutter/material.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import '../../../core/widgets/app_confirmation_dialog.dart';

class CustomAttributeEditorDialog extends StatefulWidget {
  final Map<String, dynamic> initialAttributes;

  const CustomAttributeEditorDialog({super.key, required this.initialAttributes});

  static Future<Map<String, dynamic>?> show(
    BuildContext context, {
    required Map<String, dynamic> initialAttributes,
  }) {
    return showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => CustomAttributeEditorDialog(initialAttributes: initialAttributes),
    );
  }

  @override
  State<CustomAttributeEditorDialog> createState() => _CustomAttributeEditorDialogState();
}

class _CustomAttributeEditorDialogState extends State<CustomAttributeEditorDialog> {
  late Map<String, dynamic> _attributes;
  final _keyController = TextEditingController();
  final _valController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _attributes = Map<String, dynamic>.from(widget.initialAttributes);
  }

  @override
  void dispose() {
    _keyController.dispose();
    _valController.dispose();
    super.dispose();
  }

  bool _forceClose = false;

  bool _hasUnsavedChanges() {
    if (_keyController.text.trim().isNotEmpty || _valController.text.trim().isNotEmpty) return true;
    if (_attributes.length != widget.initialAttributes.length) return true;
    for (final entry in _attributes.entries) {
      if (widget.initialAttributes[entry.key] != entry.value) return true;
    }
    return false;
  }

  Future<bool> _requestClose() async {
    if (_hasUnsavedChanges()) {
      final discard = await AppConfirmationDialog.showDiscardChangesDialog(context);
      if (!discard) return false;
    }
    _forceClose = true;
    return true;
  }

  void _addAttribute() {
    final k = _keyController.text.trim();
    final v = _valController.text.trim();
    if (k.isNotEmpty && v.isNotEmpty) {
      setState(() {
        _attributes[k] = v;
        _keyController.clear();
        _valController.clear();
      });
    }
  }

  Future<void> _removeAttribute(String key) async {
    final confirm = await AppConfirmationDialog.showDeleteConfirmation(
      context: context,
      title: AppStrings.confirmRemoveAttributeTitle,
      message: AppStrings.confirmRemoveAttributeMessage(key),
    );
    if (confirm && mounted) {
      setState(() {
        _attributes.remove(key);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final dialog = AlertDialog(
      title: const Text(AppStrings.customAttributesTitle),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_attributes.isEmpty)
              const Text(AppStrings.noCustomAttributesDefined, style: TextStyle(fontSize: 13, color: Colors.grey))
            else
              Column(
                children: _attributes.entries.map((entry) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(entry.key, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(entry.value.toString()),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 18),
                      onPressed: () => _removeAttribute(entry.key),
                    ),
                  );
                }).toList(),
              ),
            const Divider(height: 24),
            Text(AppStrings.addAttributeTitle, style: theme.textTheme.labelLarge),
            const SizedBox(height: 8),
            TextField(
              controller: _keyController,
              decoration: const InputDecoration(
                labelText: AppStrings.attributeNameLabel,
                hintText: AppStrings.attributeNameHint,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _valController,
              decoration: const InputDecoration(
                labelText: AppStrings.attributeValueLabel,
                hintText: AppStrings.attributeValueHint,
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: _addAttribute,
                icon: const Icon(Icons.add, size: 16),
                label: const Text(AppStrings.addShort),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () async {
            final canClose = await _requestClose();
            if (canClose && mounted) {
              Navigator.pop(context);
            }
          },
          child: const Text(AppStrings.cancel),
        ),
        ElevatedButton(
          onPressed: () {
            _forceClose = true;
            Navigator.pop(context, _attributes);
          },
          child: const Text(AppStrings.save),
        ),
      ],
    );

    return PopScope(
      canPop: _forceClose,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final canClose = await _requestClose();
        if (canClose && mounted) {
          Navigator.of(context).pop();
        }
      },
      child: dialog,
    );
  }
}
