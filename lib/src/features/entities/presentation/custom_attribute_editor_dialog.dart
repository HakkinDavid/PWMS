import 'package:flutter/material.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';

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

  void _removeAttribute(String key) {
    setState(() {
      _attributes.remove(key);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
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
        TextButton(onPressed: () => Navigator.pop(context), child: const Text(AppStrings.cancel)),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, _attributes),
          child: const Text(AppStrings.save),
        ),
      ],
    );
  }
}
