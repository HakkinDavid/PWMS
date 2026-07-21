import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
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
  bool _isContainer = false;
  bool _isPlace = false;

  @override
  void dispose() {
    _nameController.dispose();
    _unitsController.dispose();
    super.dispose();
  }

  Future<void> _saveTemplate() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    final units = _unitsController.text
        .split(',')
        .map((u) => u.trim())
        .where((u) => u.isNotEmpty)
        .toList();

    final template = CustomTemplate(
      id: const Uuid().v4(),
      typeName: name,
      iconName: _isPlace ? 'place' : (_isContainer ? 'inventory_2' : 'category'),
      isContainer: _isContainer,
      isPlace: _isPlace,
      commonUnits: units,
      createdAt: DateTime.now(),
    );

    await ref.read(entityRepositoryProvider).saveCustomTemplate(template);

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Plantilla "$name" creada exitosamente'),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );
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
          Text(
            'Crear Nueva Plantilla o Tipo',
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          TextField(
            controller: _nameController,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Nombre de la plantilla / tipo',
              hintText: 'Ej. Componente Electrónico, Medicamento, Instrumento...',
              prefixIcon: Icon(Icons.style),
            ),
          ),
          const SizedBox(height: 12),

          TextField(
            controller: _unitsController,
            decoration: const InputDecoration(
              labelText: 'Unidades de medida personalizadas (coma)',
              hintText: 'Ej. cajas, amperios, litros, rollos',
              prefixIcon: Icon(Icons.straighten),
            ),
          ),
          const SizedBox(height: 12),

          SwitchListTile(
            title: const Text('¿Es un Contenedor? (Puede contener elementos)'),
            value: _isContainer,
            onChanged: (val) => setState(() => _isContainer = val),
          ),
          SwitchListTile(
            title: const Text('¿Es un Lugar del Mundo?'),
            value: _isPlace,
            onChanged: (val) => setState(() => _isPlace = val),
          ),

          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _saveTemplate,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text('Guardar Plantilla', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
