import 'package:flutter/material.dart';

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
      title: const Text('Atributos Personalizados'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_attributes.isEmpty)
              const Text('Sin atributos personalizados definidos.', style: TextStyle(fontSize: 13, color: Colors.grey))
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
            Text('Agregar Atributo', style: theme.textTheme.labelLarge),
            const SizedBox(height: 8),
            TextField(
              controller: _keyController,
              decoration: const InputDecoration(
                labelText: 'Nombre del atributo',
                hintText: 'Ej. Voltaje, Garantía, Color...',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _valController,
              decoration: const InputDecoration(
                labelText: 'Valor del atributo',
                hintText: 'Ej. 220V, 2 años, Rojo...',
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: _addAttribute,
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Añadir'),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, _attributes),
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
