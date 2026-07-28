import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/providers/providers.dart';
import '../../../core/widgets/app_toast.dart';
import '../domain/effective_entity_group.dart';

class QuantityAdjustmentSheet extends ConsumerStatefulWidget {
  final EffectiveEntityGroup group;

  const QuantityAdjustmentSheet({
    super.key,
    required this.group,
  });

  static Future<void> show(BuildContext context, EffectiveEntityGroup group) async {
    // CORRECCIÓN 1: Especies únicas y grupos heterogéneos NO pueden abrir este sheet bajo ningún concepto.
    final catalogList = context.findAncestorWidgetOfExactType<ProviderScope>() != null
        ? null
        : null; // Se valida dentro del widget o mediante provider

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => QuantityAdjustmentSheet(group: group),
    );
  }

  @override
  ConsumerState<QuantityAdjustmentSheet> createState() => _QuantityAdjustmentSheetState();
}

class _QuantityAdjustmentSheetState extends ConsumerState<QuantityAdjustmentSheet> {
  late int _currentPopulation;
  late TextEditingController _countController;

  @override
  void initState() {
    super.initState();
    _currentPopulation = widget.group.population;
    _countController = TextEditingController(text: _currentPopulation.toString());
  }

  @override
  void dispose() {
    _countController.dispose();
    super.dispose();
  }

  void _increment() {
    setState(() {
      _currentPopulation++;
      _countController.text = _currentPopulation.toString();
    });
  }

  void _decrement() {
    if (_currentPopulation > 1) {
      setState(() {
        _currentPopulation--;
        _countController.text = _currentPopulation.toString();
      });
    }
  }

  Future<void> _handleSave() async {
    final newCount = int.tryParse(_countController.text.trim()) ?? _currentPopulation;
    if (newCount == widget.group.population) {
      Navigator.pop(context);
      return;
    }

    final diff = newCount - widget.group.population;
    final entityRepo = ref.read(entityRepositoryProvider);

    try {
      if (diff > 0) {
        // Clonar exactamente la primera instancia del grupo homogéneo
        final sampleEntity = widget.group.entities.first;
        final catalogRepo = ref.read(catalogRepositoryProvider);
        final species = await catalogRepo.getCatalogItemById(widget.group.speciesId);

        DateTime? newExpDate = sampleEntity.expirationDate;
        if (species != null && !species.isNonPerishable) {
          final pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now().add(Duration(days: species.defaultShelfLifeDays ?? 30)),
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(const Duration(days: 3650)),
            helpText: 'Selecciona la fecha de caducidad de las nuevas instancias',
          );
          if (pickedDate != null) {
            newExpDate = pickedDate;
          }
        }

        final Map<String, double> existingMags = {
          for (var m in sampleEntity.magnitudes) m.propertyName: m.magnitudeValue
        };

        await entityRepo.instantiateOrMerge(
          widget.group.speciesId,
          widget.group.effectiveLocationId,
          diff.toDouble(),
          subspeciesId: sampleEntity.subspeciesId,
          notes: sampleEntity.notes,
          customMagnitudeValues: existingMags.isNotEmpty ? existingMags : null,
          expirationDate: newExpDate,
        );
      } else if (diff < 0) {
        final removeCount = diff.abs();
        final idsToRemove = widget.group.entities.take(removeCount).map((e) => e.id).toList();
        await entityRepo.deleteEntitiesBatch(idsToRemove);
      }

      // Invalidar proveedores para refresco instantáneo
      ref.invalidate(entityListProvider);
      ref.invalidate(catalogListProvider);

      if (mounted) {
        Navigator.pop(context);
        AppToast.showSuccess(context, 'Población actualizada correctamente a $newCount.');
      }
    } catch (e) {
      if (mounted) {
        AppToast.showError(context, 'Error ajustando población: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUnique = widget.group.speciesId.contains('unique'); // Safety fallback
    final isHomogeneous = widget.group.isHomogeneous;

    // Validación de seguridad: no permitir ajustar si es heterogéneo o único
    if (!isHomogeneous) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.amber, size: 48),
            const SizedBox(height: 12),
            const Text(
              'Ajuste No Disponible',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            const Text(
              'No es posible ajustar la población directamente en grupos heterogéneos. Abre la vista dedicada de grupo para gestionar cada instancia individualmente.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Entendido'),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.withAlpha(80),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Ajustar Población',
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Grupo Homogéneo (${widget.group.population} actuales)',
            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 24),

          // Contador Cómodo
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton.filledTonal(
                iconSize: 32,
                onPressed: _decrement,
                icon: const Icon(Icons.remove),
              ),
              const SizedBox(width: 20),
              SizedBox(
                width: 100,
                child: TextField(
                  controller: _countController,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                  onChanged: (val) {
                    final parsed = int.tryParse(val);
                    if (parsed != null && parsed > 0) {
                      _currentPopulation = parsed;
                    }
                  },
                ),
              ),
              const SizedBox(width: 20),
              IconButton.filled(
                iconSize: 32,
                onPressed: _increment,
                icon: const Icon(Icons.add),
              ),
            ],
          ),

          const SizedBox(height: 32),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _handleSave,
                  child: const Text('Guardar'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
