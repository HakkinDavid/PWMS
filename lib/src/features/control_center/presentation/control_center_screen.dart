import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/providers.dart';
import '../../../core/widgets/app_toast.dart';
import '../../catalog/domain/catalog_item.dart';
import '../../catalog/domain/subspecies.dart';
import '../../catalog/presentation/species_form_modal.dart';
import '../../catalog/presentation/species_tile.dart';
import '../../catalog/presentation/subspecies_tile.dart';
import '../../entities/domain/entity_display_helper.dart';
import '../../entities/domain/world_entity.dart';
import '../../entities/presentation/instance_preview_card.dart';
import '../../entities/presentation/instantiate_species_sheet.dart';
import '../../locations/domain/location_path_helper.dart';
import '../../locations/presentation/location_or_container_correction_sheet.dart';

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
  final Widget tile;
  final CatalogItem? species;
  final Subspecies? subspecies;
  final WorldEntity? entity;
  final Future<bool> Function(BuildContext context, WidgetRef ref) onConfirm;
  final Future<bool> Function(BuildContext context, WidgetRef ref) onFix;

  AuditCardData({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.question,
    required this.icon,
    required this.themeColor,
    required this.tile,
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
      final relationRepo = ref.read(relationRepositoryProvider);

      final speciesList = await catalogRepo.getAllCatalogItems();
      final subspeciesList = await catalogRepo.getAllSubspecies();
      final entitiesList = await entityRepo.getAllEntities();
      final locationNodes = await locationRepo.getAllNodes();
      final relationsList = await relationRepo.getAllRelations();

      final List<AuditCardData> cards = [];

      // 1. Anomalía: Subespecie sin instancias
      for (final sub in subspeciesList) {
        final instanceCount = entitiesList.where((e) => e.subspeciesId == sub.id).length;
        if (instanceCount == 0 && sub.subspeciesName.toLowerCase() != 'genérica') {
          final parentSpecies = speciesList.where((c) => c.id == sub.speciesId).firstOrNull;
          final subNameStr = '${sub.subspeciesName}${sub.brand != null && sub.brand!.isNotEmpty ? " (${sub.brand})" : ""}';

          cards.add(AuditCardData(
            id: 'sub_${sub.id}',
            type: AuditCardType.uninstantiatedSubspecies,
            title: 'Subespecie sin Instancia',
            subtitle: '$subNameStr • Especie: ${parentSpecies?.name ?? "Desconocida"}',
            question: 'No existe ninguna instancia registrada para la subespecie "$subNameStr". ¿Deseas mantenerla o eliminarla?',
            icon: Icons.unarchive_outlined,
            themeColor: Colors.amber,
            subspecies: sub,
            species: parentSpecies,
            onConfirm: (context, ref) async {
              final choice = await showDialog<String>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Confirmar Subespecie'),
                  content: Text('¿Deseas mantener la subespecie "$subNameStr" en tu catálogo o eliminarla?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx, 'cancel'), child: const Text('Cancelar')),
                    TextButton(onPressed: () => Navigator.pop(ctx, 'keep'), child: const Text('Mantener')),
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, 'delete'),
                      child: const Text('Eliminar Subespecie', style: TextStyle(color: Colors.redAccent)),
                    ),
                  ],
                ),
              );

              if (choice == 'keep') {
                if (context.mounted) {
                  AppToast.showSuccess(context, 'Subespecie mantenida.');
                }
                return true;
              } else if (choice == 'delete') {
                try {
                  await catalogRepo.deleteSubspecies(sub.id);
                  if (context.mounted) {
                    AppToast.showSuccess(context, 'Subespecie eliminada.');
                  }
                  return true;
                } catch (e) {
                  if (context.mounted) {
                    AppToast.showError(context, e.toString().replaceAll('Exception: ', ''));
                  }
                  return false;
                }
              }
              return false;
            },
            onFix: (context, ref) async {
              if (parentSpecies != null) {
                final countBefore = (await entityRepo.getAllEntities())
                    .where((e) => e.subspeciesId == sub.id).length;

                await InstantiateSpeciesSheet.show(
                  context,
                  species: parentSpecies,
                  initialSubspecies: sub,
                );

                final countAfter = (await entityRepo.getAllEntities())
                    .where((e) => e.subspeciesId == sub.id).length;

                return countAfter > countBefore;
              }
              return false;
            },
            tile: SubspeciesTile(
              subspecies: sub,
              speciesName: parentSpecies?.name,
            ),
          ));
        }
      }

      // 2. Anomalía: Instancia huérfana (sin ubicación asignada)
      final orphanEntities = entitiesList.where((e) => e.locationId == null).take(10);
      for (final entity in orphanEntities) {
        final species = speciesList.where((c) => c.id == entity.speciesId).firstOrNull;
        final displayName = EntityDisplayHelper.getDisplayName(
          entity: entity,
          catalogItems: speciesList,
          subspeciesList: subspeciesList,
        );

        final breadcrumb = LocationPathHelper.buildEffectiveBreadcrumb(
          entityId: entity.id,
          effectiveLocationId: entity.locationId,
          allEntities: entitiesList,
          allRelations: relationsList,
          allNodes: locationNodes,
          catalogItems: speciesList,
          subspeciesList: subspeciesList,
        );

        cards.add(AuditCardData(
          id: 'orphan_${entity.id}',
          type: AuditCardType.orphanEntity,
          title: 'Instancia sin Ubicación',
          subtitle: '$displayName • Ubicación efectiva: ${breadcrumb.fullPath}',
          question: 'La instancia "$displayName" no tiene ubicación física asignada. ¿Asignarle una ubicación o contenedor ahora?',
          icon: Icons.wrong_location_outlined,
          themeColor: Colors.orangeAccent,
          entity: entity,
          species: species,
          tile: InstancePreviewCard(entity: entity),
          onConfirm: (context, ref) async {
            if (context.mounted) {
              AppToast.showSuccess(context, 'Ubicación mantenida como no asignada.');
            }
            return true;
          },
          onFix: (context, ref) async {
            return await LocationOrContainerCorrectionSheet.show(context, entity: entity);
          },
        ));
      }

      // 3. Auditoría de Posesión y Conservación
      final sampleEntities = (entitiesList.toList()..shuffle()).take(8);
      for (final entity in sampleEntities) {
        final species = speciesList.where((c) => c.id == entity.speciesId).firstOrNull;
        final displayName = EntityDisplayHelper.getDisplayName(
          entity: entity,
          catalogItems: speciesList,
          subspeciesList: subspeciesList,
        );

        final breadcrumb = LocationPathHelper.buildEffectiveBreadcrumb(
          entityId: entity.id,
          effectiveLocationId: entity.locationId,
          allEntities: entitiesList,
          allRelations: relationsList,
          allNodes: locationNodes,
          catalogItems: speciesList,
          subspeciesList: subspeciesList,
        );

        cards.add(AuditCardData(
          id: 'own_${entity.id}',
          type: AuditCardType.ownershipCheck,
          title: 'Verificación de Inventario',
          subtitle: '$displayName • Ubicación efectiva: ${breadcrumb.fullPath}',
          question: '¿Aún conservas la instancia "$displayName" en su ubicación efectiva "${breadcrumb.fullPath}"?',
          icon: Icons.inventory_outlined,
          themeColor: Colors.blueAccent,
          entity: entity,
          species: species,
          tile: InstancePreviewCard(entity: entity),
          onConfirm: (context, ref) async {
            if (context.mounted) {
              AppToast.showSuccess(context, 'Instancia confirmada en inventario.');
            }
            return true;
          },
          onFix: (context, ref) async {
            // Requisito 2: Al elegir corregir cuando se pregunta si se conserva un elemento,
            // permitir elegir entre corregir ubicación o eliminar.
            final choice = await showDialog<String>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Corregir Instancia'),
                content: Text('¿Qué acción deseas realizar sobre la instancia "$displayName"?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, 'cancel'),
                    child: const Text('Cancelar'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => Navigator.pop(ctx, 'location'),
                    icon: const Icon(Icons.edit_location_alt_outlined),
                    label: const Text('Corregir Ubicación / Contenedor'),
                  ),
                  TextButton.icon(
                    onPressed: () => Navigator.pop(ctx, 'delete'),
                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                    label: const Text('Eliminar de Inventario', style: TextStyle(color: Colors.redAccent)),
                  ),
                ],
              ),
            );

            if (choice == 'location') {
              return await LocationOrContainerCorrectionSheet.show(context, entity: entity);
            } else if (choice == 'delete') {
              final confirmDelete = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Dar de Baja Instancia'),
                  content: Text('¿Confirmas que deseas eliminar del inventario esta instancia de "$displayName"?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text('Eliminar Instancia', style: TextStyle(color: Colors.redAccent)),
                    ),
                  ],
                ),
              );

              if (confirmDelete == true) {
                await entityRepo.deleteEntity(entity.id);
                if (context.mounted) {
                  AppToast.showSuccess(context, 'Instancia dada de baja.');
                }
                return true;
              }
            }

            return false;
          },
        ));
      }

      // 4. Verificación Periódica de Ubicación
      final locationCheckSample = (entitiesList.where((e) => e.locationId != null).toList()..shuffle()).take(6);
      for (final entity in locationCheckSample) {
        final species = speciesList.where((c) => c.id == entity.speciesId).firstOrNull;
        final displayName = EntityDisplayHelper.getDisplayName(
          entity: entity,
          catalogItems: speciesList,
          subspeciesList: subspeciesList,
        );

        final breadcrumb = LocationPathHelper.buildEffectiveBreadcrumb(
          entityId: entity.id,
          effectiveLocationId: entity.locationId,
          allEntities: entitiesList,
          allRelations: relationsList,
          allNodes: locationNodes,
          catalogItems: speciesList,
          subspeciesList: subspeciesList,
        );

        cards.add(AuditCardData(
          id: 'loc_verif_${entity.id}',
          type: AuditCardType.locationVerification,
          title: 'Confirmación de Ubicación',
          subtitle: '$displayName • Ubicación registrada: ${breadcrumb.fullPath}',
          question: '¿La ubicación efectiva actual de "$displayName" sigue siendo exactamente "${breadcrumb.fullPath}"?',
          icon: Icons.edit_location_alt_outlined,
          themeColor: Colors.teal,
          entity: entity,
          species: species,
          tile: InstancePreviewCard(entity: entity),
          onConfirm: (context, ref) async {
            if (context.mounted) {
              AppToast.showSuccess(context, 'Ubicación confirmada.');
            }
            return true;
          },
          onFix: (context, ref) async {
            return await LocationOrContainerCorrectionSheet.show(context, entity: entity);
          },
        ));
      }

      // 5. Especie con información incompleta
      final incompleteSpecies = speciesList.where((c) => (c.mainPhotoPath == null || c.mainPhotoPath!.isEmpty)).take(5);
      for (final sp in incompleteSpecies) {
        cards.add(AuditCardData(
          id: 'spec_inc_${sp.id}',
          type: AuditCardType.incompleteSpeciesInfo,
          title: 'Especie sin Imagen Principal',
          subtitle: '${sp.name} (${sp.type})',
          question: 'La especie "${sp.name}" no tiene una imagen principal asignada. ¿Deseas agregarle una foto o buscarla en Internet?',
          icon: Icons.add_a_photo_outlined,
          themeColor: Colors.purpleAccent,
          species: sp,
          tile: SpeciesTile(species: sp),
          onConfirm: (context, ref) async {
            if (context.mounted) {
              AppToast.showSuccess(context, 'Información omitida por el momento.');
            }
            return true;
          },
          onFix: (context, ref) async {
            final result = await SpeciesFormModal.show(context, initialSpecies: sp);
            return result != null;
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
            Icon(Icons.style_outlined, color: Colors.white),
            SizedBox(width: 8),
            Flexible(
              child: Text(
                'Centro de Control y Salud de Datos',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
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
                confirmDismiss: (direction) async {
                  if (direction == DismissDirection.endToStart) {
                    return await card.onFix(context, ref);
                  } else {
                    return await card.onConfirm(context, ref);
                  }
                },
                onDismissed: (direction) {
                  ref.invalidate(entityListProvider);
                  ref.invalidate(catalogListProvider);
                  ref.invalidate(subspeciesListProvider);
                  ref.invalidate(relationListProvider);
                  _advanceCard();
                },
                background: _buildSwipeBackground(
                  color: Colors.blue.shade700,
                  icon: Icons.check_circle_outline,
                  label: 'CORRECTO',
                  alignment: Alignment.centerLeft,
                ),
                secondaryBackground: _buildSwipeBackground(
                  color: Colors.red.shade800,
                  icon: Icons.build_circle_outlined,
                  label: 'CORREGIR',
                  alignment: Alignment.centerRight,
                ),
                child: Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: card.themeColor.withAlpha(100), width: 2),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Header Icon and Audit Title
                          Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: card.themeColor.withAlpha(30),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(card.icon, size: 28, color: card.themeColor),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                card.title,
                                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, fontSize: 15),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),

                          // Reusable Tile Widget (InstancePreviewCard, SubspeciesTile, or SpeciesTile)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6.0),
                            child: card.tile,
                          ),

                          // Card Question Box
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: theme.cardColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: theme.dividerColor),
                            ),
                            child: Text(
                              card.question,
                              style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600, fontSize: 12),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Action buttons for explicit tapping
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () async {
                                    final ok = await card.onConfirm(context, ref);
                                    if (ok) {
                                      ref.invalidate(entityListProvider);
                                      ref.invalidate(catalogListProvider);
                                      ref.invalidate(subspeciesListProvider);
                                      ref.invalidate(relationListProvider);
                                      _advanceCard();
                                    }
                                  },
                                  icon: const Icon(Icons.check_circle_outline, color: Colors.green, size: 18),
                                  label: const Text('CORRECTO', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Colors.green),
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () async {
                                    final ok = await card.onFix(context, ref);
                                    if (ok) {
                                      ref.invalidate(entityListProvider);
                                      ref.invalidate(catalogListProvider);
                                      ref.invalidate(subspeciesListProvider);
                                      ref.invalidate(relationListProvider);
                                      _advanceCard();
                                    }
                                  },
                                  icon: const Icon(Icons.build_circle_outlined, size: 18),
                                  label: const Text('CORREGIR', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: card.themeColor,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 10),
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

