import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/providers.dart';
import '../../../core/widgets/app_toast.dart';
import '../../catalog/domain/catalog_item.dart';
import '../../catalog/domain/subspecies.dart';
import '../../catalog/presentation/species_form_modal.dart';
import '../../entities/domain/world_entity.dart';
import '../../entities/presentation/instantiate_species_sheet.dart';
import '../../locations/presentation/location_tree_picker.dart';

enum AuditCardType {
  uninstantiatedSubspecies,
  locationVerification,
  ownershipCheck,
  expirationAudit,
  orphanEntity,
  incompleteSpeciesInfo,
}

class AuditCardData {
  final String id;
  final AuditCardType type;
  final String title;
  final String subtitle;
  final String question;
  final IconData icon;
  final Color themeColor;
  final CatalogItem? species;
  final Subspecies? subspecies;
  final WorldEntity? entity;
  final Future<void> Function(BuildContext context, WidgetRef ref) onConfirm; // ✅
  final Future<void> Function(BuildContext context, WidgetRef ref) onFix; // ❌

  AuditCardData({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.question,
    required this.icon,
    required this.themeColor,
    this.species,
    this.subspecies,
    this.entity,
    required this.onConfirm,
    required this.onFix,
  });
}

class ControlCenterScreen extends ConsumerStatefulWidget {
  const ControlCenterScreen({super.key});

  @override
  ConsumerState<ControlCenterScreen> createState() => _ControlCenterScreenState();
}

class _ControlCenterScreenState extends ConsumerState<ControlCenterScreen> {
  List<AuditCardData> _cards = [];
  bool _isLoading = true;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _generateAuditCards();
  }

  Future<void> _generateAuditCards() async {
    setState(() => _isLoading = true);

    try {
      final catalogRepo = ref.read(catalogRepositoryProvider);
      final entityRepo = ref.read(entityRepositoryProvider);
      final locationRepo = ref.read(locationRepositoryProvider);

      final speciesList = await catalogRepo.getAllCatalogItems();
      final subspeciesList = await catalogRepo.getAllSubspecies();
      final entitiesList = await entityRepo.getAllEntities();
      final locationNodes = await locationRepo.getAllNodes();

      final List<AuditCardData> cards = [];

      // 1. Anomalía: Subespecie sin instancias
      for (final sub in subspeciesList) {
        final instanceCount = entitiesList.where((e) => e.subspeciesId == sub.id).length;
        if (instanceCount == 0 && sub.subspeciesName.toLowerCase() != 'genérica') {
          final parentSpecies = speciesList.where((c) => c.id == sub.speciesId).firstOrNull;

          cards.add(AuditCardData(
            id: 'sub_${sub.id}',
            type: AuditCardType.uninstantiatedSubspecies,
            title: 'Subespecie sin Instancia',
            subtitle: '${sub.subspeciesName} ${sub.brand != null ? "(${sub.brand})" : ""} • Especie: ${parentSpecies?.name ?? "Desconocida"}',
            question: 'No existe ninguna instancia de esta subespecie registrada. ¿Es correcto?',
            icon: Icons.unarchive_outlined,
            themeColor: Colors.amber,
            subspecies: sub,
            species: parentSpecies,
            onConfirm: (context, ref) async {
              // Confirmar -> Eliminar o Mantener Subespecie
              final delete = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Confirmar Subespecie'),
                  content: Text('¿Deseas eliminar la subespecie "${sub.subspeciesName}" de tu catálogo o mantenerla?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Mantener')),
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text('Eliminar Subespecie', style: TextStyle(color: Colors.redAccent)),
                    ),
                  ],
                ),
              );

              if (delete == true) {
                try {
                  await catalogRepo.deleteSubspecies(sub.id);
                  AppToast.showSuccess(context, 'Subespecie eliminada.');
                } catch (e) {
                  AppToast.showError(context, e.toString().replaceAll('Exception: ', ''));
                }
              }
            },
            onFix: (context, ref) async {
              // Abrir menú para instanciar
              if (parentSpecies != null) {
                await InstantiateSpeciesSheet.show(
                  context,
                  species: parentSpecies,
                  initialSubspecies: sub,
                );
              }
            },
          ));
        }
      }

      // 2. Anomalía: Instancia huérfana (sin ubicación asignada)
      final orphanEntities = entitiesList.where((e) => e.locationId == null).take(10);
      for (final entity in orphanEntities) {
        final species = speciesList.where((c) => c.id == entity.speciesId).firstOrNull;
        cards.add(AuditCardData(
          id: 'orphan_${entity.id}',
          type: AuditCardType.orphanEntity,
          title: 'Instancia sin Ubicación',
          subtitle: 'Especie: ${species?.name ?? "Objeto"} • ID: ${entity.id.substring(0, 8)}',
          question: 'Esta instancia no tiene una ubicación física asignada. ¿Asignarle ubicación ahora?',
          icon: Icons.wrong_location_outlined,
          themeColor: Colors.orangeAccent,
          entity: entity,
          species: species,
          onConfirm: (context, ref) async {
            // ✅ Dejar sin ubicación por ahora
            AppToast.showSuccess(context, 'Ubicación mantenida como no asignada.');
          },
          onFix: (context, ref) async {
            // ❌ Abrir selector de árbol de ubicación
            final result = await LocationTreePicker.show(context);
            if (result != null) {
              final updated = entity.copyWith(locationId: result.locationId);
              await entityRepo.saveEntity(updated);
              AppToast.showSuccess(context, 'Ubicación asignada correctamente.');
            }
          },
        ));
      }

      // 3. Auditoría de Posesión y Conservación (Muestra aleatoria de instancias para verificar conservado)
      final sampleEntities = (entitiesList.toList()..shuffle()).take(8);
      for (final entity in sampleEntities) {
        final species = speciesList.where((c) => c.id == entity.speciesId).firstOrNull;
        final locNode = locationNodes.where((n) => n.id == entity.locationId).firstOrNull;

        cards.add(AuditCardData(
          id: 'own_${entity.id}',
          type: AuditCardType.ownershipCheck,
          title: 'Verificación de Inventario',
          subtitle: '${species?.name ?? "Objeto"} • Ubicación: ${locNode?.name ?? "Sin ubicación"}',
          question: '¿Aún conservas esta instancia en tu inventario?',
          icon: Icons.inventory_outlined,
          themeColor: Colors.blueAccent,
          entity: entity,
          species: species,
          onConfirm: (context, ref) async {
            // ✅ Sí la conservo
            AppToast.showSuccess(context, 'Instancia confirmada en inventario.');
          },
          onFix: (context, ref) async {
            // ❌ No la conservo -> Dar de baja / eliminar
            final confirm = await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Dar de Baja Instancia'),
                content: Text('¿Confirmas que deseas eliminar del inventario esta instancia de "${species?.name ?? "Objeto"}"?'),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    child: const Text('Eliminar Instancia', style: TextStyle(color: Colors.redAccent)),
                  ),
                ],
              ),
            );

            if (confirm == true) {
              await entityRepo.deleteEntity(entity.id);
              AppToast.showSuccess(context, 'Instancia dada de baja.');
            }
          },
        ));
      }

      // 4. Verificación Periódica de Ubicación
      final locationCheckSample = (entitiesList.where((e) => e.locationId != null).toList()..shuffle()).take(6);
      for (final entity in locationCheckSample) {
        final species = speciesList.where((c) => c.id == entity.speciesId).firstOrNull;
        final locNode = locationNodes.where((n) => n.id == entity.locationId).firstOrNull;

        cards.add(AuditCardData(
          id: 'loc_verif_${entity.id}',
          type: AuditCardType.locationVerification,
          title: 'Confirmación de Ubicación',
          subtitle: '${species?.name ?? "Objeto"} • Ubicación registrada: ${locNode?.name ?? "Desconocida"}',
          question: '¿La ubicación actual sigue siendo exactamente "${locNode?.name ?? "Desconocida"}"?',
          icon: Icons.edit_location_alt_outlined,
          themeColor: Colors.teal,
          entity: entity,
          species: species,
          onConfirm: (context, ref) async {
            // ✅ Ubicación correcta
            AppToast.showSuccess(context, 'Ubicación confirmada.');
          },
          onFix: (context, ref) async {
            // ❌ Modificar ubicación
            final result = await LocationTreePicker.show(context, initialSelectedId: entity.locationId);
            if (result != null) {
              final updated = entity.copyWith(locationId: result.locationId);
              await entityRepo.saveEntity(updated);
              AppToast.showSuccess(context, 'Ubicación actualizada.');
            }
          },
        ));
      }

      // 5. Especie con información incompleta (sin foto o sin descripción)
      final incompleteSpecies = speciesList.where((c) => (c.mainPhotoPath == null || c.mainPhotoPath!.isEmpty)).take(5);
      for (final sp in incompleteSpecies) {
        cards.add(AuditCardData(
          id: 'spec_inc_${sp.id}',
          type: AuditCardType.incompleteSpeciesInfo,
          title: 'Especie sin Imagen Principal',
          subtitle: '${sp.name} (${sp.type})',
          question: 'Esta especie no tiene una imagen principal asignada. ¿Deseas agregarle una foto o buscarla en Internet?',
          icon: Icons.add_a_photo_outlined,
          themeColor: Colors.purpleAccent,
          species: sp,
          onConfirm: (context, ref) async {
            // ✅ Omitir por ahora
            AppToast.showSuccess(context, 'Información omitida por el momento.');
          },
          onFix: (context, ref) async {
            // ❌ Abrir modal de editar especie
            await SpeciesFormModal.show(context, initialSpecies: sp);
          },
        ));
      }

      if (mounted) {
        setState(() {
          _cards = cards;
          _currentIndex = 0;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        AppToast.showError(context, 'Error al cargar tarjetas de control: $e');
      }
    }
  }

  void _advanceCard() {
    if (_currentIndex < _cards.length - 1) {
      setState(() => _currentIndex++);
    } else {
      setState(() => _cards = []);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.style_outlined, color: Colors.amber),
            SizedBox(width: 8),
            Text('Centro de Control & Salud de Datos', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Regenerar Revisiones',
            onPressed: _generateAuditCards,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _cards.isEmpty
              ? _buildEmptyState(theme)
              : _buildCardStack(theme),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.verified_outlined, size: 80, color: Colors.green),
            const SizedBox(height: 20),
            Text(
              '¡Salud de datos 100% verificada!',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              'No se detectaron anomalías ni inconsistencias en tu inventario. Tu mundo PWMS está perfectamente estructurado.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _generateAuditCards,
              icon: const Icon(Icons.autorenew),
              label: const Text('Realizar Nueva Auditoría'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardStack(ThemeData theme) {
    final card = _cards[_currentIndex];
    final progress = (_currentIndex + 1) / _cards.length;

    return Column(
      children: [
        LinearProgressIndicator(value: progress, minHeight: 6, backgroundColor: Colors.grey.withAlpha(40)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Revisión ${_currentIndex + 1} de ${_cards.length}',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
              ),
              Chip(
                visualDensity: VisualDensity.compact,
                label: Text('${_cards.length - _currentIndex} pendientes', style: const TextStyle(fontSize: 11)),
              ),
            ],
          ),
        ),

        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Dismissible(
                key: Key(card.id),
                direction: DismissDirection.horizontal,
                onDismissed: (direction) async {
                  if (direction == DismissDirection.endToStart) {
                    // Swipe left -> Action ❌
                    await card.onFix(context, ref);
                  } else {
                    // Swipe right -> Confirm ✅
                    await card.onConfirm(context, ref);
                  }
                  ref.invalidate(entityListProvider);
                  ref.invalidate(catalogListProvider);
                  ref.invalidate(subspeciesListProvider);
                  _advanceCard();
                },
                background: _buildSwipeBackground(
                  color: Colors.green.shade700,
                  icon: Icons.check_circle_outline,
                  label: 'CONFIRMAR / CORRECTO ✅',
                  alignment: Alignment.centerLeft,
                ),
                secondaryBackground: _buildSwipeBackground(
                  color: Colors.orange.shade800,
                  icon: Icons.build_circle_outlined,
                  label: 'CORREGIR / ACCIÓN ❌',
                  alignment: Alignment.centerRight,
                ),
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: card.themeColor.withAlpha(100), width: 2),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Card Header
                        Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: card.themeColor.withAlpha(30),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(card.icon, size: 42, color: card.themeColor),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              card.title,
                              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              card.subtitle,
                              style: const TextStyle(color: Colors.grey, fontSize: 13),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),

                        // Card Question
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: theme.dividerColor),
                          ),
                          child: Text(
                            card.question,
                            style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        // Card Action Buttons (Quick Tap or Swipe)
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  await card.onConfirm(context, ref);
                                  ref.invalidate(entityListProvider);
                                  ref.invalidate(catalogListProvider);
                                  ref.invalidate(subspeciesListProvider);
                                  _advanceCard();
                                },
                                icon: const Icon(Icons.check_circle),
                                label: const Text('Correcto ✅'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green.shade700,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  await card.onFix(context, ref);
                                  ref.invalidate(entityListProvider);
                                  ref.invalidate(catalogListProvider);
                                  ref.invalidate(subspeciesListProvider);
                                  _advanceCard();
                                },
                                icon: const Icon(Icons.build_circle),
                                label: const Text('Corregir ❌'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange.shade800,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSwipeBackground({
    required Color color,
    required IconData icon,
    required String label,
    required Alignment alignment,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      alignment: alignment,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }
}
