import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/providers/providers.dart';
import '../../entities/domain/world_entity.dart';
import '../../places/domain/place.dart';

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
  String? _selectedPlaceId;
  bool _isMoving = false;
  final _newPlaceController = TextEditingController();
  bool _creatingNewPlace = false;

  @override
  void initState() {
    super.initState();
    _selectedPlaceId = widget.entity.placeId;
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
    final newPlace = Place(
      id: placeId,
      name: name,
      createdAt: DateTime.now(),
    );

    await ref.read(placeListProvider.notifier).savePlace(newPlace);
    setState(() {
      _selectedPlaceId = placeId;
      _creatingNewPlace = false;
      _newPlaceController.clear();
    });
  }

  Future<void> _confirmMove() async {
    if (_selectedPlaceId == widget.entity.placeId) {
      Navigator.pop(context);
      return;
    }

    setState(() => _isMoving = true);

    try {
      final places = await ref.read(placeRepositoryProvider).getAllPlaces();
      final now = DateTime.now();
      final oldPlace = places.firstWhere(
        (p) => p.id == widget.entity.placeId,
        orElse: () => Place(id: '', name: 'Sin ubicación', createdAt: now),
      );
      final newPlace = places.firstWhere(
        (p) => p.id == _selectedPlaceId,
        orElse: () => Place(id: '', name: 'Sin ubicación', createdAt: now),
      );

      final updatedEntity = widget.entity.copyWith(
        placeId: _selectedPlaceId,
        updatedAt: DateTime.now(),
      );

      await ref.read(entityListProvider.notifier).saveEntity(updatedEntity);

      // Auto log movement history
      await ref.read(activityLoggerServiceProvider).logEntityMoved(
            widget.entity.id,
            widget.entity.name,
            oldPlace.name,
            newPlace.name,
          );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ubicación de "${widget.entity.name}" actualizada a "${newPlace.name}"'),
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
            'Selecciona o crea el nuevo lugar donde se encuentra este elemento.',
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

          placesState.when(
            data: (places) {
              return Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    ListTile(
                      title: const Text('Sin Ubicación'),
                      leading: Icon(
                        _selectedPlaceId == null ? Icons.radio_button_checked : Icons.radio_button_off,
                        color: _selectedPlaceId == null ? theme.colorScheme.primary : theme.disabledColor,
                      ),
                      onTap: () => setState(() => _selectedPlaceId = null),
                    ),
                    ...places.map((p) => ListTile(
                          title: Text(p.name),
                          subtitle: p.description != null ? Text(p.description!) : null,
                          leading: Icon(
                            _selectedPlaceId == p.id ? Icons.radio_button_checked : Icons.radio_button_off,
                            color: _selectedPlaceId == p.id ? theme.colorScheme.primary : theme.disabledColor,
                          ),
                          onTap: () => setState(() => _selectedPlaceId = p.id),
                        )),
                  ],
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Text('Error: $err'),
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
