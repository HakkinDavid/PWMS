import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/providers/providers.dart';
import '../../entities/domain/world_entity.dart';
import '../../locations/domain/location_node.dart';

class MoveEntitySheet extends ConsumerStatefulWidget {
  final WorldEntity entity;

  const MoveEntitySheet({super.key, required this.entity});

  static Future<void> show(BuildContext context, WorldEntity entity) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => MoveEntitySheet(entity: entity),
    );
  }

  @override
  ConsumerState<MoveEntitySheet> createState() => _MoveEntitySheetState();
}

class _MoveEntitySheetState extends ConsumerState<MoveEntitySheet> {
  String? _selectedLocationId;
  bool _creatingNewLocation = false;
  final _newLocationController = TextEditingController();
  bool _isMoving = false;

  @override
  void initState() {
    super.initState();
    _selectedLocationId = widget.entity.locationId;
  }

  @override
  void dispose() {
    _newLocationController.dispose();
    super.dispose();
  }

  Future<void> _createNewLocation() async {
    final name = _newLocationController.text.trim();
    if (name.isEmpty) return;

    final id = const Uuid().v4();
    final node = LocationNode(
      id: id,
      name: name,
      createdAt: DateTime.now(),
    );

    await ref.read(locationNodeListProvider.notifier).saveNode(node);
    setState(() {
      _selectedLocationId = id;
      _creatingNewLocation = false;
      _newLocationController.clear();
    });
  }

  Future<void> _confirmMove() async {
    setState(() => _isMoving = true);
    try {
      await ref.read(entityRepositoryProvider).moveEntity(widget.entity.id, _selectedLocationId);

      final catalogItems = ref.read(catalogListProvider).asData?.value ?? [];
      final species = catalogItems.where((c) => c.id == widget.entity.speciesId).firstOrNull;
      final name = species?.name ?? 'Objeto';

      await ref.read(activityLoggerServiceProvider).logEntityMoved(
            widget.entity.id,
            name,
            'Ubicación previa',
            'Nueva ubicación en Grafo',
          );

      ref.read(entityListProvider.notifier).loadEntities();

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('"$name" trasladado exitosamente en el Grafo'),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al mover: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isMoving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final locationsState = ref.watch(locationNodeListProvider);
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
            'Trasladar en el Grafo',
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          Text('Selecciona la nueva ubicación o contenedor:', style: theme.textTheme.labelLarge),
          const SizedBox(height: 8),

          locationsState.when(
            data: (nodes) {
              return DropdownButtonFormField<String?>(
                initialValue: _selectedLocationId,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.account_tree_outlined),
                ),
                items: [
                  const DropdownMenuItem<String?>(value: null, child: Text('Mundo (Raíz)')),
                  ...nodes.map((n) => DropdownMenuItem<String?>(value: n.id, child: Text(n.name))),
                ],
                onChanged: (val) => setState(() => _selectedLocationId = val),
              );
            },
            loading: () => const CircularProgressIndicator(),
            error: (err, _) => Text('Error: $err'),
          ),
          const SizedBox(height: 12),

          if (!_creatingNewLocation)
            TextButton.icon(
              onPressed: () => setState(() => _creatingNewLocation = true),
              icon: const Icon(Icons.add_location_alt_outlined),
              label: const Text('Crear nueva ubicación sobre la marcha'),
            )
          else ...[
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _newLocationController,
                    autofocus: true,
                    decoration: const InputDecoration(
                      labelText: AppStrings.locationNameLabel,
                      hintText: AppStrings.locationNameHint,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.check_circle, color: Colors.green),
                  onPressed: _createNewLocation,
                ),
                IconButton(
                  icon: const Icon(Icons.cancel_outlined, color: Colors.grey),
                  onPressed: () => setState(() => _creatingNewLocation = false),
                ),
              ],
            ),
          ],

          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _isMoving ? null : _confirmMove,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: _isMoving
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Confirmar Traslado', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
