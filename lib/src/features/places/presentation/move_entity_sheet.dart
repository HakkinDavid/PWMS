import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/providers/providers.dart';
import '../../entities/domain/world_entity.dart';

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
  String? _selectedDestinationId;
  bool _isDestinationContainer = false;
  bool _isMoving = false;
  final _newPlaceController = TextEditingController();
  bool _creatingNewPlace = false;

  @override
  void initState() {
    super.initState();
    _selectedDestinationId = widget.entity.parentEntityId ?? widget.entity.placeId;
  }

  @override
  void dispose() {
    _newPlaceController.dispose();
    super.dispose();
  }

  Future<void> _createNewPlace() async {
    final name = _newPlaceController.text.trim();
    if (name.isEmpty) return;

    final placeId = const Uuid().v4();
    final newPlaceEntity = WorldEntity(
      id: placeId,
      name: name,
      type: 'Lugar',
      isPlace: true,
      isContainer: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await ref.read(entityListProvider.notifier).saveEntity(newPlaceEntity);
    await ref.read(activityLoggerServiceProvider).logEntityCreated(placeId, name, 'Lugar');

    setState(() {
      _selectedDestinationId = placeId;
      _isDestinationContainer = false;
      _creatingNewPlace = false;
      _newPlaceController.clear();
    });
  }

  Future<void> _confirmMove() async {
    setState(() => _isMoving = true);

    try {
      final repo = ref.read(entityRepositoryProvider);
      final places = await ref.read(placeRepositoryProvider).getAllPlaces();
      final allEntities = await repo.getAllEntities();

      String oldLocationName = 'Sin ubicación';
      if (widget.entity.placeId != null) {
        final p = places.where((x) => x.id == widget.entity.placeId).firstOrNull;
        if (p != null) oldLocationName = p.name;
      } else if (widget.entity.parentEntityId != null) {
        final e = allEntities.where((x) => x.id == widget.entity.parentEntityId).firstOrNull;
        if (e != null) oldLocationName = e.name;
      }

      String newLocationName = 'Sin ubicación';
      String? newPlaceId;
      String? newParentId;

      if (_selectedDestinationId != null) {
        if (_isDestinationContainer) {
          newParentId = _selectedDestinationId;
          final targetEnt = allEntities.where((e) => e.id == _selectedDestinationId).firstOrNull;
          if (targetEnt != null) {
            newLocationName = targetEnt.name;
            newPlaceId = targetEnt.placeId;
          }
        } else {
          newPlaceId = _selectedDestinationId;
          final p = places.where((x) => x.id == _selectedDestinationId).firstOrNull;
          if (p != null) newLocationName = p.name;
        }
      }

      // Execute cascade move
      await repo.moveEntity(widget.entity.id, newPlaceId: newPlaceId, newParentId: newParentId);

      // Log movement history
      await ref.read(activityLoggerServiceProvider).logEntityMoved(
            widget.entity.id,
            widget.entity.name,
            oldLocationName,
            newLocationName,
          );

      ref.read(entityListProvider.notifier).loadEntities();

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ubicación de "${widget.entity.name}" actualizada a "$newLocationName"'),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al trasladar: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isMoving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final placesState = ref.watch(placeListProvider);
    final entitiesState = ref.watch(entityListProvider);
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
            'Trasladar "${widget.entity.name}"',
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Selecciona el lugar o contenedor donde estará ubicado este elemento.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),

          if (_creatingNewPlace) ...[
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _newPlaceController,
                    autofocus: true,
                    decoration: const InputDecoration(
                      labelText: 'Nuevo lugar',
                      hintText: 'Ej. Taller, Armario principal...',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  icon: const Icon(Icons.check),
                  onPressed: _createNewPlace,
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => setState(() => _creatingNewPlace = false),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ] else ...[
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => setState(() => _creatingNewPlace = true),
                icon: const Icon(Icons.add_location_alt_outlined),
                label: const Text('Crear nuevo lugar'),
              ),
            ),
          ],

          Flexible(
            child: ListView(
              shrinkWrap: true,
              children: [
                ListTile(
                  title: const Text('Sin Ubicación'),
                  leading: Icon(
                    _selectedDestinationId == null ? Icons.radio_button_checked : Icons.radio_button_off,
                    color: _selectedDestinationId == null ? theme.colorScheme.primary : theme.disabledColor,
                  ),
                  onTap: () => setState(() {
                    _selectedDestinationId = null;
                    _isDestinationContainer = false;
                  }),
                ),

                // Registered Places Section
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 12, bottom: 4),
                  child: Text('Lugares', style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.primary)),
                ),
                placesState.when(
                  data: (places) => Column(
                    children: places.map((p) {
                      final isSel = _selectedDestinationId == p.id && !_isDestinationContainer;
                      return ListTile(
                        title: Text(p.name),
                        leading: Icon(
                          isSel ? Icons.radio_button_checked : Icons.radio_button_off,
                          color: isSel ? theme.colorScheme.primary : theme.disabledColor,
                        ),
                        onTap: () => setState(() {
                          _selectedDestinationId = p.id;
                          _isDestinationContainer = false;
                        }),
                      );
                    }).toList(),
                  ),
                  loading: () => const CircularProgressIndicator(),
                  error: (err, _) => Text('Error: $err'),
                ),

                // Registered Containers Section (Caja, Estante, Maletín)
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 12, bottom: 4),
                  child: Text('Contenedores (Cajas, Estantes, Maletines)', style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.secondary)),
                ),
                entitiesState.when(
                  data: (entities) {
                    final containers = entities.where((e) => e.id != widget.entity.id && (e.isContainer || e.isPlace)).toList();
                    if (containers.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.only(left: 16, top: 4, bottom: 8),
                        child: Text('No hay contenedores registrados aún.', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      );
                    }
                    return Column(
                      children: containers.map((c) {
                        final isSel = _selectedDestinationId == c.id && _isDestinationContainer;
                        return ListTile(
                          title: Text('${c.name} (${c.type})'),
                          leading: Icon(
                            isSel ? Icons.radio_button_checked : Icons.radio_button_off,
                            color: isSel ? theme.colorScheme.secondary : theme.disabledColor,
                          ),
                          onTap: () => setState(() {
                            _selectedDestinationId = c.id;
                            _isDestinationContainer = true;
                          }),
                        );
                      }).toList(),
                    );
                  },
                  loading: () => const CircularProgressIndicator(),
                  error: (err, _) => Text('Error: $err'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
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
