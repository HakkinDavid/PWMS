import 'dart:io';
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
import '../../catalog/domain/numismatic_data_helper.dart';
import '../../catalog/presentation/web_image_picker_dialog.dart';
import '../../entities/domain/instance_magnitude.dart';
import 'package:uuid/uuid.dart';

enum AuditCardType {
  uninstantiatedSubspecies,
  locationVerification,
  ownershipCheck,
  expirationAudit,
  orphanEntity,
  incompleteSpeciesInfo,
  remoteImageAudit,
  numismaticSubspeciesIncongruity,
  numismaticDuplicateSubspecies,
  numismaticAttachmentIncongruity,
  numismaticMissingMagnitudes,
  emptyDataAudit,
  locationConflict,
  cyclicContainment,
  uniquenessViolation,
  perishableMissingExpiration,
  nonPerishableWithExpiration,
  subgroupRuleViolation,
  missingMandatoryMagnitudes,
  uninstantiatedSpecies,
  anomalousMagnitude,
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
            title: 'Subespecie sin instancias',
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
                  title: const Text('Confirmar subespecie'),
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

      // 2. Anomalía: Instancia huérfana (sin ubicación directa ni contenedor)
      final orphanEntities = entitiesList.where((e) =>
        e.locationId == null &&
        !relationsList.any((r) => r.sourceEntityId == e.id && r.relationType == 'GUARDADO_EN')
      ).take(10);
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
          title: 'Instancia sin ubicación ni contenedor',
          subtitle: '$displayName • Ubicación efectiva: ${breadcrumb.fullPath}',
          question: 'La instancia "$displayName" no tiene ubicación física ni contenedor asignado. ¿Asignarle una ubicación o contenedor ahora?',
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

      // 2.1 Conflicto de Ubicación (Guardado en contenedor pero con ubicación directa)
      final conflictEntities = entitiesList.where((e) {
        if (e.locationId == null) return false;
        return relationsList.any((r) => r.sourceEntityId == e.id && r.relationType == 'GUARDADO_EN');
      }).take(8);

      for (final entity in conflictEntities) {
        final species = speciesList.where((c) => c.id == entity.speciesId).firstOrNull;
        final containerRel = relationsList.where((r) => r.sourceEntityId == entity.id && r.relationType == 'GUARDADO_EN').first;
        final containerEntity = entitiesList.where((e) => e.id == containerRel.targetEntityId).firstOrNull;
        final containerSpecies = speciesList.where((c) => c.id == containerEntity?.speciesId).firstOrNull;
        final containerName = containerSpecies?.name ?? 'Contenedor';
        final directLoc = locationNodes.where((l) => l.id == entity.locationId).firstOrNull;
        final directLocName = directLoc?.name ?? 'Ubicación directa';

        final displayName = EntityDisplayHelper.getDisplayName(
          entity: entity,
          catalogItems: speciesList,
          subspeciesList: subspeciesList,
        );

        cards.add(AuditCardData(
          id: 'conflict_${entity.id}',
          type: AuditCardType.locationConflict,
          title: 'Conflicto de Ubicación en Contenedor',
          subtitle: '$displayName • En: $containerName & $directLocName',
          question: 'La instancia "$displayName" está guardada en "$containerName" pero también tiene asignada la ubicación directa "$directLocName". ¿Cómo deseas resolver la redundancia?',
          icon: Icons.alt_route,
          themeColor: Colors.purpleAccent,
          entity: entity,
          species: species,
          tile: InstancePreviewCard(entity: entity),
          onConfirm: (context, ref) async {
            if (context.mounted) {
              AppToast.showSuccess(context, 'Conflicto de ubicación omitido.');
            }
            return true;
          },
          onFix: (context, ref) async {
            final choice = await showDialog<String>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Resolver ubicación'),
                content: Text(
                  'El elemento "$displayName" tiene doble asignación:\n\n'
                  '• Contenedor: $containerName\n'
                  '• Ubicación directa: $directLocName\n\n'
                  '¿Cómo deseas resolverlo?'
                ),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(ctx, 'cancel'), child: const Text('Cancelar')),
                  OutlinedButton(
                    onPressed: () => Navigator.pop(ctx, 'keep_container'),
                    child: const Text('Solo en Contenedor'),
                  ),
                  OutlinedButton(
                    onPressed: () => Navigator.pop(ctx, 'keep_direct'),
                    child: const Text('Solo Ubicación Directa'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(ctx, 'reassign'),
                    child: const Text('Reasignar'),
                  ),
                ],
              ),
            );

            if (choice == 'keep_container') {
              await entityRepo.saveEntity(entity.copyWith(locationId: null));
              if (context.mounted) {
                AppToast.showSuccess(context, 'Ubicación directa removida. Conservado en contenedor.');
              }
              return true;
            } else if (choice == 'keep_direct') {
              await relationRepo.deleteRelation(containerRel.id);
              if (context.mounted) {
                AppToast.showSuccess(context, 'Elemento retirado del contenedor.');
              }
              return true;
            } else if (choice == 'reassign') {
              return await LocationOrContainerCorrectionSheet.show(context, entity: entity);
            }
            return false;
          },
        ));
      }

      // 2.2 Relaciones Circulares o Auto-Referencias
      final circularRels = relationsList.where((r) {
        if (r.sourceEntityId == r.targetEntityId) return true;
        if (r.relationType == 'GUARDADO_EN') {
          return relationsList.any((r2) =>
              r2.sourceEntityId == r.targetEntityId &&
              r2.targetEntityId == r.sourceEntityId &&
              r2.relationType == 'GUARDADO_EN');
        }
        return false;
      }).toList();

      for (final rel in circularRels) {
        final sourceEnt = entitiesList.where((e) => e.id == rel.sourceEntityId).firstOrNull;
        final targetEnt = entitiesList.where((e) => e.id == rel.targetEntityId).firstOrNull;
        final sourceSp = speciesList.where((c) => c.id == sourceEnt?.speciesId).firstOrNull;
        final targetSp = speciesList.where((c) => c.id == targetEnt?.speciesId).firstOrNull;

        cards.add(AuditCardData(
          id: 'circ_${rel.id}',
          type: AuditCardType.cyclicContainment,
          title: 'Relación circular',
          subtitle: '${sourceSp?.name ?? "Origen"} ➔ ${targetSp?.name ?? "Destino"} (${rel.relationType})',
          question: 'Se detectó una relación circular o auto-referencia inválida entre "${sourceSp?.name}" y "${targetSp?.name}". ¿Deseas eliminar la relación conflictiva?',
          icon: Icons.loop,
          themeColor: Colors.redAccent,
          entity: sourceEnt,
          species: sourceSp,
          tile: sourceEnt != null ? InstancePreviewCard(entity: sourceEnt) : const SizedBox.shrink(),
          onConfirm: (context, ref) async {
            if (context.mounted) {
              AppToast.showSuccess(context, 'Relación circular conservada.');
            }
            return true;
          },
          onFix: (context, ref) async {
            final confirm = await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Eliminar relación inválida'),
                content: const Text('¿Confirmas que deseas eliminar esta relación conflictiva?'),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    child: const Text('Eliminar Relación', style: TextStyle(color: Colors.redAccent)),
                  ),
                ],
              ),
            );

            if (confirm == true) {
              await relationRepo.deleteRelation(rel.id);
              if (context.mounted) {
                AppToast.showSuccess(context, 'Relación conflictiva eliminada.');
              }
              return true;
            }
            return false;
          },
        ));
      }

      // 2.3 Violación de Regla de Especie Única (evaluada por subespecie)
      for (final sp in speciesList.where((c) => c.isUnique)) {
        final spSubspecies = subspeciesList.where((s) => s.speciesId == sp.id).toList();
        for (final sub in spSubspecies) {
          final matchingInstances = entitiesList.where((e) => e.speciesId == sp.id && e.subspeciesId == sub.id).toList();
          if (matchingInstances.length > 1) {
            cards.add(AuditCardData(
              id: 'uniq_viol_${sub.id}',
              type: AuditCardType.uniquenessViolation,
              title: 'Subespecie única duplicada',
              subtitle: '${sub.subspeciesName} • ${sp.name} (${matchingInstances.length} instancias)',
              question: 'La subespecie "${sub.subspeciesName}" de la especie única "${sp.name}" tiene ${matchingInstances.length} instancias físicas duplicadas. ¿Cómo deseas proceder?',
              icon: Icons.content_copy,
              themeColor: Colors.deepOrangeAccent,
              species: sp,
              subspecies: sub,
              tile: SubspeciesTile(subspecies: sub, speciesName: sp.name),
              onConfirm: (context, ref) async {
                if (context.mounted) {
                  AppToast.showSuccess(context, 'Duplicidad de subespecie omitida.');
                }
                return true;
              },
              onFix: (context, ref) async {
                final choice = await showDialog<String>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Resolver unicidad'),
                    content: Text(
                      'La subespecie "${sub.subspeciesName}" de la especie única "${sp.name}" tiene ${matchingInstances.length} instancias.\n\n'
                      '¿Deseas permitir múltiples instancias convirtiendo la especie en No Única o eliminar los duplicados de esta subespecie?'
                    ),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(ctx, 'cancel'), child: const Text('Cancelar')),
                      OutlinedButton(
                        onPressed: () => Navigator.pop(ctx, 'make_not_unique'),
                        child: const Text('Convertir a No Única'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, 'delete_duplicates'),
                        child: const Text('Eliminar Duplicados', style: TextStyle(color: Colors.redAccent)),
                      ),
                    ],
                  ),
                );

                if (choice == 'make_not_unique') {
                  await catalogRepo.saveCatalogItem(sp.copyWith(isUnique: false));
                  if (context.mounted) {
                    AppToast.showSuccess(context, 'Especie configurada como No Única.');
                  }
                  return true;
                } else if (choice == 'delete_duplicates') {
                  for (int i = 1; i < matchingInstances.length; i++) {
                    await entityRepo.deleteEntity(matchingInstances[i].id);
                  }
                  if (context.mounted) {
                    AppToast.showSuccess(context, 'Instancias duplicadas eliminadas. Se conservó 1 instancia.');
                  }
                  return true;
                }
                return false;
              },
            ));
          }
        }
      }

      // 2.4 Perecederos sin Fecha de Caducidad
      final perishableMissingExp = entitiesList.where((e) {
        final sp = speciesList.where((c) => c.id == e.speciesId).firstOrNull;
        return (sp != null && !sp.isNonPerishable && e.expirationDate == null);
      }).take(8);

      for (final entity in perishableMissingExp) {
        final species = speciesList.where((c) => c.id == entity.speciesId).firstOrNull;
        final displayName = EntityDisplayHelper.getDisplayName(
          entity: entity,
          catalogItems: speciesList,
          subspeciesList: subspeciesList,
        );

        cards.add(AuditCardData(
          id: 'no_exp_${entity.id}',
          type: AuditCardType.perishableMissingExpiration,
          title: 'Perecedero sin Caducidad',
          subtitle: '$displayName • Especie: ${species?.name ?? ""}',
          question: 'La especie "${species?.name}" es perecedera pero la instancia "$displayName" no tiene fecha de caducidad. ¿Deseas asignársela?',
          icon: Icons.event_busy,
          themeColor: Colors.amber.shade700,
          entity: entity,
          species: species,
          tile: InstancePreviewCard(entity: entity),
          onConfirm: (context, ref) async {
            if (context.mounted) {
              AppToast.showSuccess(context, 'Fecha de caducidad omitida.');
            }
            return true;
          },
          onFix: (context, ref) async {
            final defaultDays = species?.defaultShelfLifeDays ?? 30;
            final suggestedDate = DateTime.now().add(Duration(days: defaultDays));

            final picked = await showDatePicker(
              context: context,
              initialDate: suggestedDate,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              helpText: 'Selecciona Fecha de Caducidad',
            );

            if (picked != null) {
              await entityRepo.saveEntity(entity.copyWith(expirationDate: picked));
              if (context.mounted) {
                AppToast.showSuccess(context, 'Fecha de caducidad actualizada.');
              }
              return true;
            }
            return false;
          },
        ));
      }

      // 2.5 No Perecederos con Fecha de Caducidad
      final nonPerishableWithExp = entitiesList.where((e) {
        final sp = speciesList.where((c) => c.id == e.speciesId).firstOrNull;
        return (sp != null && sp.isNonPerishable && e.expirationDate != null);
      }).take(8);

      for (final entity in nonPerishableWithExp) {
        final species = speciesList.where((c) => c.id == entity.speciesId).firstOrNull;
        final displayName = EntityDisplayHelper.getDisplayName(
          entity: entity,
          catalogItems: speciesList,
          subspeciesList: subspeciesList,
        );

        cards.add(AuditCardData(
          id: 'unneeded_exp_${entity.id}',
          type: AuditCardType.nonPerishableWithExpiration,
          title: 'No Perecedero con Caducidad',
          subtitle: '$displayName • Caducidad asignada: ${entity.expirationDate.toString().substring(0, 10)}',
          question: 'La especie "${species?.name}" está marcada como NO perecedera pero "$displayName" tiene caducidad registrada. ¿Deseas remover la fecha?',
          icon: Icons.event_repeat,
          themeColor: Colors.blueGrey,
          entity: entity,
          species: species,
          tile: InstancePreviewCard(entity: entity),
          onConfirm: (context, ref) async {
            if (context.mounted) {
              AppToast.showSuccess(context, 'Caducidad conservada.');
            }
            return true;
          },
          onFix: (context, ref) async {
            await entityRepo.saveEntity(entity.copyWith(expirationDate: null));
            if (context.mounted) {
              AppToast.showSuccess(context, 'Fecha de caducidad eliminada.');
            }
            return true;
          },
        ));
      }

      // 2.6 Infracción de Reglas de Subgrupo (Marca/Código en no-Objetos)
      final invalidSubspecies = subspeciesList.where((sub) {
        final sp = speciesList.where((c) => c.id == sub.speciesId).firstOrNull;
        return sp != null && sp.type != 'Objeto' && ((sub.brand != null && sub.brand!.isNotEmpty) || (sub.barcode != null && sub.barcode!.isNotEmpty));
      }).take(8);

      for (final sub in invalidSubspecies) {
        final sp = speciesList.where((c) => c.id == sub.speciesId).firstOrNull;

        cards.add(AuditCardData(
          id: 'subgroup_viol_${sub.id}',
          type: AuditCardType.subgroupRuleViolation,
          title: 'Infracción de Regla de Subgrupo',
          subtitle: '${sub.subspeciesName} • Tipo: ${sp?.type ?? ""}',
          question: 'El subgrupo "${sp?.type}" no permite marca ni código de barras. ¿Deseas limpiar estos atributos?',
          icon: Icons.rule_folder_outlined,
          themeColor: Colors.deepPurpleAccent,
          subspecies: sub,
          species: sp,
          tile: SubspeciesTile(subspecies: sub, speciesName: sp?.name ?? ''),
          onConfirm: (context, ref) async {
            if (context.mounted) {
              AppToast.showSuccess(context, 'Atributos omitidos.');
            }
            return true;
          },
          onFix: (context, ref) async {
            final updatedSub = sub.copyWith(brand: null, barcode: null);
            await catalogRepo.saveSubspecies(updatedSub);
            if (context.mounted) {
              AppToast.showSuccess(context, 'Marca y código de barras removidos.');
            }
            return true;
          },
        ));
      }

      // 2.7 Especies en Catálogo sin Instancias
      final uninstantiatedSpecies = speciesList.where((sp) {
        return !entitiesList.any((e) => e.speciesId == sp.id);
      }).take(8);

      for (final sp in uninstantiatedSpecies) {
        cards.add(AuditCardData(
          id: 'uninst_sp_${sp.id}',
          type: AuditCardType.uninstantiatedSpecies,
          title: 'Especie sin Instancias en el Mundo',
          subtitle: '${sp.name} (${sp.type})',
          question: 'La especie "${sp.name}" no tiene ninguna instancia física registrada. ¿Deseas crear una instancia o eliminar la especie?',
          icon: Icons.category_outlined,
          themeColor: Colors.brown,
          species: sp,
          tile: SpeciesTile(species: sp),
          onConfirm: (context, ref) async {
            if (context.mounted) {
              AppToast.showSuccess(context, 'Especie conservada en catálogo.');
            }
            return true;
          },
          onFix: (context, ref) async {
            final choice = await showDialog<String>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text('Gestionar "${sp.name}"'),
                content: const Text('¿Qué acción deseas realizar con esta especie?'),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(ctx, 'cancel'), child: const Text('Cancelar')),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pop(ctx, 'instantiate'),
                    icon: const Icon(Icons.add),
                    label: const Text('Crear Instancia'),
                  ),
                  TextButton.icon(
                    onPressed: () => Navigator.pop(ctx, 'delete'),
                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                    label: const Text('Eliminar Especie', style: TextStyle(color: Colors.redAccent)),
                  ),
                ],
              ),
            );

            if (choice == 'instantiate') {
              await InstantiateSpeciesSheet.show(context, species: sp);
              final afterCount = (await entityRepo.getAllEntities()).where((e) => e.speciesId == sp.id).length;
              return afterCount > 0;
            } else if (choice == 'delete') {
              try {
                await catalogRepo.deleteCatalogItem(sp.id);
                if (context.mounted) {
                  AppToast.showSuccess(context, 'Especie eliminada del catálogo.');
                }
                return true;
              } catch (e) {
                if (context.mounted) {
                  AppToast.showError(context, e.toString().replaceAll('Exception: ', ''));
                }
              }
            }
            return false;
          },
        ));
      }

      // 2.8 Magnitudes de Especie Faltantes en Instancia
      for (final entity in entitiesList.take(20)) {
        final species = speciesList.where((c) => c.id == entity.speciesId).firstOrNull;
        if (species != null && species.magnitudes.isNotEmpty) {
          final missingMags = species.magnitudes.where((sm) =>
              !entity.magnitudes.any((im) => im.propertyName.toLowerCase() == sm.propertyName.toLowerCase())).toList();

          if (missingMags.isNotEmpty) {
            final missingProp = missingMags.first;
            final displayName = EntityDisplayHelper.getDisplayName(
              entity: entity,
              catalogItems: speciesList,
              subspeciesList: subspeciesList,
            );

            cards.add(AuditCardData(
              id: 'miss_mag_${entity.id}_${missingProp.propertyName}',
              type: AuditCardType.missingMandatoryMagnitudes,
              title: 'Magnitud Faltante: ${missingProp.propertyName}',
              subtitle: '$displayName • Especie requiere: ${missingProp.propertyName} (${missingProp.unitSymbol ?? ""})',
              question: 'La instancia "$displayName" no tiene registrada la propiedad "${missingProp.propertyName}". ¿Deseas asignarle un valor?',
              icon: Icons.straighten,
              themeColor: Colors.teal,
              entity: entity,
              species: species,
              tile: InstancePreviewCard(entity: entity),
              onConfirm: (context, ref) async {
                if (context.mounted) {
                  AppToast.showSuccess(context, 'Magnitud omitida.');
                }
                return true;
              },
              onFix: (context, ref) async {
                final controller = TextEditingController();
                final enteredValue = await showDialog<String>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text('Asignar ${missingProp.propertyName}'),
                    content: TextField(
                      controller: controller,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: missingProp.propertyName,
                        suffixText: missingProp.unitSymbol,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(ctx, null), child: const Text('Cancelar')),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(ctx, controller.text.trim()),
                        child: const Text('Guardar'),
                      ),
                    ],
                  ),
                );

                if (enteredValue != null && enteredValue.isNotEmpty) {
                  final numVal = double.tryParse(enteredValue) ?? 0.0;
                  final newMag = InstanceMagnitude(
                    id: const Uuid().v4(),
                    instanceId: entity.id,
                    propertyName: missingProp.propertyName,
                    dataType: missingProp.dataType,
                    magnitudeValue: numVal,
                    unitSymbol: missingProp.unitSymbol,
                  );
                  final updatedMags = List<InstanceMagnitude>.from(entity.magnitudes)..add(newMag);
                  await entityRepo.saveEntity(entity.copyWith(magnitudes: updatedMags));
                  if (context.mounted) {
                    AppToast.showSuccess(context, 'Propiedad "${missingProp.propertyName}" registrada.');
                  }
                  return true;
                }
                return false;
              },
            ));
          }
        }
      }

      // 2.9 Magnitud con Valor No Positivo
      for (final entity in entitiesList.take(20)) {
        final anomalousMags = entity.magnitudes.where((m) => m.magnitudeValue <= 0 && m.dataType == 'real').toList();
        for (final mag in anomalousMags) {
          final species = speciesList.where((c) => c.id == entity.speciesId).firstOrNull;
          final displayName = EntityDisplayHelper.getDisplayName(
            entity: entity,
            catalogItems: speciesList,
            subspeciesList: subspeciesList,
          );

          cards.add(AuditCardData(
            id: 'anom_mag_${mag.id}',
            type: AuditCardType.anomalousMagnitude,
            title: 'Magnitud con Valor No Positivo',
            subtitle: '$displayName • ${mag.propertyName}: ${mag.magnitudeValue} ${mag.unitSymbol ?? ""}',
            question: 'La magnitud "${mag.propertyName}" tiene un valor de ${mag.magnitudeValue}. ¿Deseas corregir este valor?',
            icon: Icons.exposure_zero,
            themeColor: Colors.orange,
            entity: entity,
            species: species,
            tile: InstancePreviewCard(entity: entity),
            onConfirm: (context, ref) async {
              if (context.mounted) {
                AppToast.showSuccess(context, 'Valor conservado.');
              }
              return true;
            },
            onFix: (context, ref) async {
              final controller = TextEditingController(text: mag.magnitudeValue.toString());
              final enteredValue = await showDialog<String>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text('Corregir ${mag.propertyName}'),
                  content: TextField(
                    controller: controller,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: mag.propertyName,
                      suffixText: mag.unitSymbol,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx, null), child: const Text('Cancelar')),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(ctx, controller.text.trim()),
                      child: const Text('Guardar'),
                    ),
                  ],
                ),
              );

              if (enteredValue != null && enteredValue.isNotEmpty) {
                final numVal = double.tryParse(enteredValue) ?? 0.0;
                final updatedMags = entity.magnitudes.map((m) =>
                    m.id == mag.id ? m.copyWith(magnitudeValue: numVal) : m).toList();
                await entityRepo.saveEntity(entity.copyWith(magnitudes: updatedMags));
                if (context.mounted) {
                  AppToast.showSuccess(context, 'Valor de "${mag.propertyName}" actualizado a $numVal.');
                }
                return true;
              }
              return false;
            },
          ));
        }
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
          title: '¿Has movido este objeto?',
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

      // 5.1 Especies con Imágenes Remotas (HTTP / HTTPS)
      final remoteImageSpecies = speciesList.where((c) =>
        c.mainPhotoPath != null &&
        (c.mainPhotoPath!.startsWith('http://') || c.mainPhotoPath!.startsWith('https://'))
      );
      for (final sp in remoteImageSpecies) {
        cards.add(AuditCardData(
          id: 'spec_remote_${sp.id}',
          type: AuditCardType.remoteImageAudit,
          title: 'Imagen de Especie No Local (URL Remota)',
          subtitle: '${sp.name} (${sp.type}) • Imagen en Internet',
          question: 'La especie "${sp.name}" tiene una imagen referenciada desde una URL remota de Internet. ¿Deseas descargarla y guardarla localmente en el dispositivo para tenerla offline y respaldable?',
          icon: Icons.cloud_download_outlined,
          themeColor: Colors.indigoAccent,
          species: sp,
          tile: SpeciesTile(species: sp),
          onConfirm: (context, ref) async {
            if (context.mounted) {
              AppToast.showSuccess(context, 'Imagen remota conservada sin descargar.');
            }
            return true;
          },
          onFix: (context, ref) async {
            final lookupService = ref.read(productLookupServiceProvider);
            final fileStorage = ref.read(fileStorageServiceProvider);
            final localTempPath = await lookupService.downloadAndSaveImage(sp.mainPhotoPath!);
            if (localTempPath != null) {
              final relPath = await fileStorage.saveFile(localTempPath);
              final updatedSp = sp.copyWith(mainPhotoPath: relPath);
              await catalogRepo.saveCatalogItem(updatedSp);
              ref.read(catalogListProvider.notifier).loadCatalog();
              if (context.mounted) {
                AppToast.showSuccess(context, 'Imagen descargada y guardada localmente con éxito.');
              }
              return true;
            } else {
              if (context.mounted) {
                AppToast.showError(context, 'No se pudo descargar automáticamente la imagen. Puedes seleccionarla en la web.');
                final picked = await WebImagePickerDialog.show(
                  context,
                  searchQuery: sp.name,
                  targetSpecies: sp,
                );
                return picked != null;
              }
            }
            return false;
          },
        ));
      }

      // 5.2 Subespecies con Imágenes Remotas (HTTP / HTTPS)
      final remoteImageSubspecies = subspeciesList.where((s) =>
        s.photoPath != null &&
        (s.photoPath!.startsWith('http://') || s.photoPath!.startsWith('https://'))
      );
      for (final sub in remoteImageSubspecies) {
        final parentSpecies = speciesList.where((c) => c.id == sub.speciesId).firstOrNull;
        cards.add(AuditCardData(
          id: 'sub_remote_${sub.id}',
          type: AuditCardType.remoteImageAudit,
          title: 'Imagen de Subespecie No Local (URL Remota)',
          subtitle: '${sub.subspeciesName} • ${parentSpecies?.name ?? ""}',
          question: 'La subespecie "${sub.subspeciesName}" tiene una imagen referenciada desde una URL remota de Internet. ¿Deseas descargarla y guardarla localmente en el dispositivo?',
          icon: Icons.cloud_download_outlined,
          themeColor: Colors.indigo,
          subspecies: sub,
          species: parentSpecies,
          tile: SubspeciesTile(subspecies: sub, speciesName: parentSpecies?.name ?? ''),
          onConfirm: (context, ref) async {
            if (context.mounted) {
              AppToast.showSuccess(context, 'Imagen remota conservada sin descargar.');
            }
            return true;
          },
          onFix: (context, ref) async {
            final lookupService = ref.read(productLookupServiceProvider);
            final fileStorage = ref.read(fileStorageServiceProvider);
            final localTempPath = await lookupService.downloadAndSaveImage(sub.photoPath!);
            if (localTempPath != null) {
              final relPath = await fileStorage.saveFile(localTempPath);
              final updatedSub = sub.copyWith(photoPath: relPath);
              await catalogRepo.saveSubspecies(updatedSub);
              ref.invalidate(subspeciesListProvider);
              if (context.mounted) {
                AppToast.showSuccess(context, 'Imagen descargada y guardada localmente con éxito.');
              }
              return true;
            } else {
              if (context.mounted) {
                AppToast.showError(context, 'No se pudo descargar automáticamente la imagen. Puedes seleccionarla en la web.');
                final picked = await WebImagePickerDialog.show(
                  context,
                  searchQuery: sub.subspeciesName,
                  targetSubspecies: sub,
                );
                return picked != null;
              }
            }
            return false;
          },
        ));
      }

      // 6. Auditoría Numismática: Subespecies duplicadas
      final duplicateSubGroups = NumismaticDataHelper.findDuplicateSubspeciesGroups(subspeciesList);
      for (final entry in duplicateSubGroups.entries) {
        final canonicalSub = entry.value.first;
        final parentSpecies = speciesList.where((c) => c.id == canonicalSub.speciesId).firstOrNull;
        if (parentSpecies != null && NumismaticDataHelper.isNumismaticSpecies(parentSpecies)) {
          final dupCount = entry.value.length;
          cards.add(AuditCardData(
            id: 'numis_dup_${canonicalSub.id}',
            type: AuditCardType.numismaticDuplicateSubspecies,
            title: 'Subespecies Numismáticas Duplicadas',
            subtitle: '${canonicalSub.subspeciesName} • $dupCount subespecies idénticas en ${parentSpecies.name}',
            question: 'Existen $dupCount subespecies registradas para "${canonicalSub.subspeciesName}". ¿Deseas fusionarlas y reasignar sus piezas a una sola subespecie canónica?',
            icon: Icons.filter_none,
            themeColor: Colors.deepOrange,
            subspecies: canonicalSub,
            species: parentSpecies,
            tile: SubspeciesTile(subspecies: canonicalSub, speciesName: parentSpecies.name),
            onConfirm: (context, ref) async {
              if (context.mounted) {
                AppToast.showSuccess(context, 'Subespecies duplicadas conservadas sin cambios.');
              }
              return true;
            },
            onFix: (context, ref) async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Fusionar Subespecies Duplicadas'),
                  content: Text('¿Deseas consolidar las $dupCount subespecies de "${canonicalSub.subspeciesName}" en una sola subespecie y reasignar todas las instancias existentes?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text('Fusionar y Reasignar', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                await NumismaticDataHelper.mergeDuplicateSubspecies(
                  catalogRepo: catalogRepo,
                  entityRepo: entityRepo,
                  canonicalSubspecies: canonicalSub,
                  duplicateSubspeciesList: entry.value,
                );
                if (context.mounted) {
                  AppToast.showSuccess(context, 'Subespecies duplicadas fusionadas con éxito.');
                }
                return true;
              }
              return false;
            },
          ));
        }
      }

      // 7. Auditoría Numismática: Incongruencias entre Subespecie e Instancias, Nombres de Adjuntos y Magnitudes Incompletas
      for (final entity in entitiesList) {
        final species = speciesList.where((c) => c.id == entity.speciesId).firstOrNull;
        if (species != null && NumismaticDataHelper.isNumismaticSpecies(species) && entity.subspeciesId != null) {
          final sub = subspeciesList.where((s) => s.id == entity.subspeciesId).firstOrNull;
          if (sub != null) {
            final displayName = EntityDisplayHelper.getDisplayName(
              entity: entity,
              catalogItems: speciesList,
              subspeciesList: subspeciesList,
            );

            // A) Check Incongruence (subspecies title/notes vs instance magnitudes)
            final issueMsg = NumismaticDataHelper.checkInstanceSubspeciesCongruence(
              subspecies: sub,
              instance: entity,
            );

            if (issueMsg != null) {
              cards.add(AuditCardData(
                id: 'numis_inc_${entity.id}',
                type: AuditCardType.numismaticSubspeciesIncongruity,
                title: 'Incongruencia en Datos Numismáticos',
                subtitle: '$displayName • Subespecie: ${sub.subspeciesName}',
                question: '$issueMsg ¿Deseas actualizar la subespecie con los valores reales de la instancia?',
                icon: Icons.currency_exchange,
                themeColor: Colors.purple,
                entity: entity,
                subspecies: sub,
                species: species,
                tile: InstancePreviewCard(entity: entity),
                onConfirm: (context, ref) async {
                  if (context.mounted) {
                    AppToast.showSuccess(context, 'Incongruencia omitida.');
                  }
                  return true;
                },
                onFix: (context, ref) async {
                  final action = await showDialog<String>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Corregir Incongruencia Numismática'),
                      content: Text('Sincronizar información para "$displayName":\n\n$issueMsg'),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(ctx, 'cancel'), child: const Text('Cancelar')),
                        OutlinedButton(
                          onPressed: () => Navigator.pop(ctx, 'subspecies'),
                          child: const Text('Actualizar Subespecie según la Instancia'),
                        ),
                      ],
                    ),
                  );

                  if (action == 'subspecies') {
                    final updatedSub = await NumismaticDataHelper.repairSubspeciesFromInstance(
                      catalogRepo: catalogRepo,
                      entityRepo: entityRepo,
                      subspecies: sub,
                      instance: entity,
                    );
                    await NumismaticDataHelper.repairAttachmentFileNames(
                      catalogRepo: catalogRepo,
                      entityRepo: entityRepo,
                      subspecies: updatedSub,
                      instance: entity,
                    );
                    if (context.mounted) {
                      AppToast.showSuccess(context, 'Subespecie y adjuntos sincronizados con éxito.');
                    }
                    return true;
                  }
                  return false;
                },
              ));
            }

            // B) Check Attachments Filename Congruence
            final instanceAttachments = await entityRepo.getAttachmentsForInstance(entity.id);
            for (final att in instanceAttachments) {
              final isObverse = att.fileName.toLowerCase().contains('(anverso)') || att.fileName.toLowerCase().contains('anverso');
              final side = isObverse ? 'anverso' : 'reverso';
              final file = File(att.filePath);
              final ext = file.path.contains('.') ? file.path.split('.').last : 'jpg';

              final expectedName = NumismaticDataHelper.buildAttachmentFileName(
                subspeciesName: sub.subspeciesName,
                instanceId: entity.id,
                side: side,
                extension: ext,
              );

              if (att.fileName != expectedName) {
                cards.add(AuditCardData(
                  id: 'numis_att_${att.id}',
                  type: AuditCardType.numismaticAttachmentIncongruity,
                  title: 'Nombre de Adjunto Desincronizado',
                  subtitle: '$displayName • Actual: ${att.fileName}',
                  question: 'El adjunto "${att.fileName}" no coincide con el título actual de la subespecie "${sub.subspeciesName}". ¿Renombrar archivo a "$expectedName"?',
                  icon: Icons.attachment,
                  themeColor: Colors.indigo,
                  entity: entity,
                  subspecies: sub,
                  species: species,
                  tile: InstancePreviewCard(entity: entity),
                  onConfirm: (context, ref) async {
                    if (context.mounted) {
                      AppToast.showSuccess(context, 'Nombre de adjunto mantenido.');
                    }
                    return true;
                  },
                  onFix: (context, ref) async {
                    await NumismaticDataHelper.repairAttachmentFileNames(
                      catalogRepo: catalogRepo,
                      entityRepo: entityRepo,
                      subspecies: sub,
                      instance: entity,
                    );
                    if (context.mounted) {
                      AppToast.showSuccess(context, 'Archivo adjunto renombrado correctamente.');
                    }
                    return true;
                  },
                ));
              }
            }

            // C) Check Missing Required Magnitudes
            final instAttrs = NumismaticDataHelper.extractAttributesFromInstance(entity);
            final missingMags = <String>[];
            if (instAttrs.faceValueNumber == null) missingMags.add('Valor nominal');
            if (instAttrs.year == null) missingMags.add('Acuñación');
            if (instAttrs.currencyName == null) missingMags.add('Divisa');

            if (missingMags.isNotEmpty) {
              cards.add(AuditCardData(
                id: 'numis_mag_${entity.id}',
                type: AuditCardType.numismaticMissingMagnitudes,
                title: 'Magnitudes Numismáticas Incompletas',
                subtitle: '$displayName • Faltan: ${missingMags.join(", ")}',
                question: 'La instancia "$displayName" no tiene registradas las magnitudes (${missingMags.join(", ")}). ¿Deseas autocompletarlas desde el título de la subespecie?',
                icon: Icons.fact_check_outlined,
                themeColor: Colors.blueGrey,
                entity: entity,
                subspecies: sub,
                species: species,
                tile: InstancePreviewCard(entity: entity),
                onConfirm: (context, ref) async {
                  if (context.mounted) {
                    AppToast.showSuccess(context, 'Magnitudes mantenidas sin cambios.');
                  }
                  return true;
                },
                onFix: (context, ref) async {
                  final parsedSub = NumismaticDataHelper.parseSubspeciesName(sub.subspeciesName);
                  final List<InstanceMagnitude> currentMags = List.from(entity.magnitudes);

                  if (parsedSub.faceValueNumber != null && instAttrs.faceValueNumber == null) {
                    currentMags.add(InstanceMagnitude(
                      id: const Uuid().v4(),
                      instanceId: entity.id,
                      propertyName: 'Valor nominal',
                      dataType: 'real',
                      magnitudeValue: parsedSub.faceValueNumber!,
                    ));
                  }

                  if (parsedSub.year != null && instAttrs.year == null && double.tryParse(parsedSub.year!) != null) {
                    currentMags.add(InstanceMagnitude(
                      id: const Uuid().v4(),
                      instanceId: entity.id,
                      propertyName: 'Acuñación',
                      dataType: 'integer',
                      magnitudeValue: double.parse(parsedSub.year!),
                      unitSymbol: 'año',
                    ));
                  }

                  if (parsedSub.currencyName != null && instAttrs.currencyName == null) {
                    currentMags.add(InstanceMagnitude(
                      id: const Uuid().v4(),
                      instanceId: entity.id,
                      propertyName: 'Divisa',
                      dataType: 'string',
                      stringValue: parsedSub.currencyName,
                    ));
                  }

                  final updatedEntity = entity.copyWith(magnitudes: currentMags);
                  await entityRepo.saveEntity(updatedEntity);

                  if (context.mounted) {
                    AppToast.showSuccess(context, 'Magnitudes numismáticas autocompletadas.');
                  }
                  return true;
                },
              ));
            }

            // D) Check Empty Optional Data / Attributes (such as Grado)
            if (instAttrs.grade == null || instAttrs.grade!.trim().isEmpty) {
              cards.add(AuditCardData(
                id: 'numis_empty_grade_${entity.id}',
                type: AuditCardType.emptyDataAudit,
                title: 'Dato Numismático Vacío: Grado',
                subtitle: '$displayName • Grado de conservación sin asignar',
                question: 'La pieza "$displayName" no tiene especificado su estado o grado de conservación. ¿Deseas asignarle un grado ahora?',
                icon: Icons.star_outline,
                themeColor: Colors.amber.shade800,
                entity: entity,
                subspecies: sub,
                species: species,
                tile: InstancePreviewCard(entity: entity),
                onConfirm: (context, ref) async {
                  if (context.mounted) {
                    AppToast.showSuccess(context, 'Grado de conservación mantenido vacío.');
                  }
                  return true;
                },
                onFix: (context, ref) async {
                  final chosenGrade = await showDialog<String>(
                    context: context,
                    builder: (ctx) {
                      String? currentVal = NumismaticDataHelper.grades.first;
                      return StatefulBuilder(
                        builder: (context, setState) {
                          return AlertDialog(
                            title: const Text('Asignar Grado de Conservación'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Selecciona el estado de conservación para "$displayName":',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                const SizedBox(height: 16),
                                DropdownButtonFormField<String>(
                                  value: currentVal,
                                  isExpanded: true,
                                  decoration: const InputDecoration(
                                    labelText: 'Grado de Conservación',
                                    prefixIcon: Icon(Icons.grade),
                                    border: OutlineInputBorder(),
                                  ),
                                  items: NumismaticDataHelper.grades.map((g) => DropdownMenuItem(
                                    value: g,
                                    child: Text(g, overflow: TextOverflow.ellipsis),
                                  )).toList(),
                                  onChanged: (val) {
                                    if (val != null) setState(() => currentVal = val);
                                  },
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, null),
                                child: const Text('Cancelar'),
                              ),
                              ElevatedButton(
                                onPressed: () => Navigator.pop(ctx, currentVal),
                                child: const Text('Guardar Grado'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );

                  if (chosenGrade != null && chosenGrade.isNotEmpty) {
                    final List<InstanceMagnitude> currentMags = List.from(entity.magnitudes);
                    final existingGradeIdx = currentMags.indexWhere((m) => m.propertyName == 'Grado');
                    if (existingGradeIdx >= 0) {
                      currentMags[existingGradeIdx] = currentMags[existingGradeIdx].copyWith(
                        dataType: 'string',
                        stringValue: chosenGrade,
                        unitSymbol: null,
                        magnitudeValue: 0.0,
                      );
                    } else {
                      currentMags.add(InstanceMagnitude(
                        id: const Uuid().v4(),
                        instanceId: entity.id,
                        propertyName: 'Grado',
                        dataType: 'string',
                        stringValue: chosenGrade,
                      ));
                    }

                    final updatedEntity = entity.copyWith(magnitudes: currentMags);
                    await entityRepo.saveEntity(updatedEntity);

                    if (context.mounted) {
                      AppToast.showSuccess(context, 'Grado de conservación actualizado a "$chosenGrade".');
                    }
                    return true;
                  }
                  return false;
                },
              ));
            }
          }
        }
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

