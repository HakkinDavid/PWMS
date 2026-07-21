import 'package:flutter/material.dart';
import '../../../../core/domain/entities/entity.dart';
import '../../../../core/domain/entities/entity_id.dart';
import '../controllers/world_explorer_controller.dart';

/// Modal Único y Unificado de Registro de Entidades en PWMS.
///
/// Provee selección explícita de Ubicación Destino y Tipo Semántico (menos de 30 segundos).
class UnifiedRegisterModal extends StatefulWidget {
  final WorldExplorerController controller;
  final EntityId? initialParentId;

  const UnifiedRegisterModal({
    super.key,
    required this.controller,
    this.initialParentId,
  });

  @override
  State<UnifiedRegisterModal> createState() => _UnifiedRegisterModalState();
}

class _UnifiedRegisterModalState extends State<UnifiedRegisterModal> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String _selectedKind = 'object';
  EntityId? _selectedParentId;
  List<Entity> _availableContainers = [];
  bool _isLoadingContainers = true;
  bool _isSubmitting = false;

  final _kinds = const [
    {'id': 'space', 'label': 'Espacio / Lugar', 'icon': Icons.roofing_rounded},
    {'id': 'container', 'label': 'Contenedor / Caja', 'icon': Icons.inventory_2_rounded},
    {'id': 'object', 'label': 'Objeto / Pertenencia', 'icon': Icons.build_rounded},
    {'id': 'document', 'label': 'Documento / Archivo', 'icon': Icons.description_rounded},
    {'id': 'resource', 'label': 'Recurso / Vivo', 'icon': Icons.local_florist_rounded},
  ];

  @override
  void initState() {
    super.initState();
    _selectedParentId = widget.initialParentId;
    _loadContainers();
  }

  Future<void> _loadContainers() async {
    setState(() => _isLoadingContainers = true);
    final allWithLoc = widget.controller.recentEntities;
    _availableContainers = allWithLoc.map((e) => e.entity).toList();
    setState(() => _isLoadingContainers = false);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    final success = await widget.controller.registerEntity(
      name: _nameController.text,
      kind: _selectedKind,
      description: _descriptionController.text.isNotEmpty ? _descriptionController.text : null,
      parentId: _selectedParentId,
    );

    if (mounted) {
      setState(() => _isSubmitting = false);
      if (success) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(
        left: 24.0,
        right: 24.0,
        top: 24.0,
        bottom: bottomInset + 24.0,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.add_box_rounded,
                      color: theme.colorScheme.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Registrar en mi Mundo',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Captura unificada (<30 segundos)',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Selector de Tipo Semántico (1 toque)
              Text(
                '1. Tipo de elemento *',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _kinds.map((k) {
                    final isSelected = _selectedKind == k['id'];
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        avatar: Icon(
                          k['icon'] as IconData,
                          size: 18,
                          color: isSelected
                              ? theme.colorScheme.onPrimary
                              : theme.colorScheme.primary,
                        ),
                        label: Text(k['label'] as String),
                        selected: isSelected,
                        selectedColor: theme.colorScheme.primary,
                        labelStyle: TextStyle(
                          color: isSelected
                              ? theme.colorScheme.onPrimary
                              : theme.colorScheme.onSurface,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        onSelected: (selected) {
                          if (selected) {
                            setState(() => _selectedKind = k['id'] as String);
                          }
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),

              // Selector Explícito de Ubicación Destino
              Text(
                '2. Ubicación / Contenedor Destino *',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              _isLoadingContainers
                  ? const LinearProgressIndicator()
                  : DropdownButtonFormField<EntityId?>(
                      initialValue: _selectedParentId,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.location_on_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        filled: true,
                      ),
                      items: [
                        const DropdownMenuItem<EntityId?>(
                          value: null,
                          child: Text('[Raíz del Mundo] (Sin contenedor padre)'),
                        ),
                        ..._availableContainers.map(
                          (c) => DropdownMenuItem<EntityId?>(
                            value: c.id,
                            child: Text('📍 ${c.name}'),
                          ),
                        ),
                      ],
                      onChanged: (val) => setState(() => _selectedParentId = val),
                    ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _nameController,
                autofocus: true,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: '3. Nombre o concepto *',
                  hintText: 'Ej. Garaje, Caja A1, Taladro Bosch, Pasaporte...',
                  prefixIcon: const Icon(Icons.label_outline_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  filled: true,
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Ingresa un nombre para el elemento';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _descriptionController,
                textCapitalization: TextCapitalization.sentences,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'Notas / Detalles (Opcional)',
                  hintText: 'Detalles adicionales...',
                  prefixIcon: const Icon(Icons.notes_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  filled: true,
                ),
              ),
              const SizedBox(height: 22),
              ElevatedButton.icon(
                onPressed: _isSubmitting ? null : _submit,
                icon: _isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2.5),
                      )
                    : const Icon(Icons.check_rounded),
                label: Text(_isSubmitting ? 'Guardando...' : 'Guardar Elemento'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
