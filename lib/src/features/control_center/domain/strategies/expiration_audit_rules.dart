import 'package:flutter/material.dart';
import 'package:platinum_world_management_system/src/core/domain/property_data_type.dart';
import 'package:platinum_world_management_system/src/core/providers/providers.dart';
import 'package:platinum_world_management_system/src/core/widgets/app_toast.dart';
import 'package:uuid/uuid.dart';
import '../../../entities/domain/entity_display_helper.dart';
import '../../../entities/domain/instance_magnitude.dart';
import '../../../entities/presentation/instance_preview_card.dart';
import '../audit_rule_strategy.dart';

/// Strategy 1: Perecederos sin Fecha de Caducidad
class PerishableMissingExpirationStrategy implements IAuditRuleStrategy {
  const PerishableMissingExpirationStrategy();

  @override
  AuditCardType get cardType => AuditCardType.perishableMissingExpiration;

  @override
  String get ruleId => 'expiration_perishable_missing_expiration';

  @override
  Future<List<AuditCardData>> evaluate(AuditEvaluationContext context) async {
    final perishableMissingExp = context.allEntities.where((e) {
      final sp = context.allCatalog.where((c) => c.id == e.speciesId).firstOrNull;
      return (sp != null && !sp.isNonPerishable && e.expirationDate == null);
    }).take(8);

    final cards = <AuditCardData>[];
    for (final entity in perishableMissingExp) {
      final species = context.allCatalog.where((c) => c.id == entity.speciesId).firstOrNull;
      final displayName = EntityDisplayHelper.getDisplayName(
        entity: entity,
        catalogItems: context.allCatalog,
        subspeciesList: context.allSubspecies,
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
        onConfirm: (ctx, ref) async {
          if (ctx.mounted) {
            AppToast.showSuccess(ctx, 'Fecha de caducidad omitida.');
          }
          return true;
        },
        onFix: (ctx, ref) async {
          final defaultDays = species?.defaultShelfLifeDays ?? 30;
          final suggestedDate = DateTime.now().add(Duration(days: defaultDays));

          final picked = await showDatePicker(
            context: ctx,
            initialDate: suggestedDate,
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
            helpText: 'Selecciona Fecha de Caducidad',
          );

          if (picked != null) {
            final freshEntity = await ref.read(entityRepositoryProvider).getEntityById(entity.id) ?? entity;
            await ref.read(entityRepositoryProvider).saveEntity(freshEntity.copyWith(expirationDate: picked));
            if (ctx.mounted) {
              AppToast.showSuccess(ctx, 'Fecha de caducidad actualizada.');
            }
            return true;
          }
          return false;
        },
      ));
    }
    return cards;
  }
}

/// Strategy 2: No Perecederos con Fecha de Caducidad
class NonPerishableWithExpirationStrategy implements IAuditRuleStrategy {
  const NonPerishableWithExpirationStrategy();

  @override
  AuditCardType get cardType => AuditCardType.nonPerishableWithExpiration;

  @override
  String get ruleId => 'expiration_non_perishable_with_expiration';

  @override
  Future<List<AuditCardData>> evaluate(AuditEvaluationContext context) async {
    final nonPerishableWithExp = context.allEntities.where((e) {
      final sp = context.allCatalog.where((c) => c.id == e.speciesId).firstOrNull;
      return (sp != null && sp.isNonPerishable && e.expirationDate != null);
    }).take(8);

    final cards = <AuditCardData>[];
    for (final entity in nonPerishableWithExp) {
      final species = context.allCatalog.where((c) => c.id == entity.speciesId).firstOrNull;
      final displayName = EntityDisplayHelper.getDisplayName(
        entity: entity,
        catalogItems: context.allCatalog,
        subspeciesList: context.allSubspecies,
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
        onConfirm: (ctx, ref) async {
          if (ctx.mounted) {
            AppToast.showSuccess(ctx, 'Caducidad conservada.');
          }
          return true;
        },
        onFix: (ctx, ref) async {
          final freshEntity = await ref.read(entityRepositoryProvider).getEntityById(entity.id) ?? entity;
          await ref.read(entityRepositoryProvider).saveEntity(freshEntity.copyWith(expirationDate: null));
          if (ctx.mounted) {
            AppToast.showSuccess(ctx, 'Fecha de caducidad eliminada.');
          }
          return true;
        },
      ));
    }
    return cards;
  }
}

/// Strategy 3: Magnitudes de Especie Faltantes en Instancia
class MissingMandatoryMagnitudesStrategy implements IAuditRuleStrategy {
  const MissingMandatoryMagnitudesStrategy();

  @override
  AuditCardType get cardType => AuditCardType.missingMandatoryMagnitudes;

  @override
  String get ruleId => 'expiration_missing_mandatory_magnitudes';

  @override
  Future<List<AuditCardData>> evaluate(AuditEvaluationContext context) async {
    final cards = <AuditCardData>[];

    for (final entity in context.allEntities) {
      final species = context.allCatalog.where((c) => c.id == entity.speciesId).firstOrNull;
      if (species != null && species.magnitudes.isNotEmpty) {
        final missingMags = species.magnitudes.where((sm) =>
            !entity.magnitudes.any((im) => im.propertyName.trim().toLowerCase() == sm.propertyName.trim().toLowerCase())).toList();

        for (final missingProp in missingMags) {
          final displayName = EntityDisplayHelper.getDisplayName(
            entity: entity,
            catalogItems: context.allCatalog,
            subspeciesList: context.allSubspecies,
          );

          final unitSuffix = (missingProp.unitSymbol != null && missingProp.unitSymbol!.isNotEmpty)
              ? ' (${missingProp.unitSymbol})'
              : '';

          cards.add(AuditCardData(
            id: 'miss_mag_${entity.id}_${missingProp.propertyName}',
            type: AuditCardType.missingMandatoryMagnitudes,
            title: 'Magnitud Faltante: ${missingProp.propertyName}',
            subtitle: '$displayName • Especie define: ${missingProp.propertyName}$unitSuffix',
            question: 'La instancia "$displayName" no tiene registrada la magnitud "${missingProp.propertyName}" definida en su especie "${species.name}". ¿Deseas asignarle un valor?',
            icon: Icons.straighten,
            themeColor: Colors.teal,
            entity: entity,
            species: species,
            tile: InstancePreviewCard(entity: entity),
            onConfirm: (ctx, ref) async {
              if (ctx.mounted) {
                AppToast.showSuccess(ctx, 'Magnitud omitida.');
              }
              return true;
            },
            onFix: (ctx, ref) async {
              final propType = PropertyDataType.fromCode(missingProp.dataType);
              InstanceMagnitude? newMag;

              if (propType == PropertyDataType.boolean) {
                final boolVal = await showDialog<bool>(
                  context: ctx,
                  builder: (dialogCtx) => AlertDialog(
                    title: Text('Asignar ${missingProp.propertyName}'),
                    content: Text('Selecciona el valor booleano para "${missingProp.propertyName}":'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(dialogCtx, null), child: const Text('Cancelar')),
                      OutlinedButton(
                        onPressed: () => Navigator.pop(dialogCtx, false),
                        child: const Text('No (Falso)'),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(dialogCtx, true),
                        child: const Text('Sí (Verdadero)'),
                      ),
                    ],
                  ),
                );

                if (boolVal != null) {
                  newMag = InstanceMagnitude(
                    id: const Uuid().v4(),
                    instanceId: entity.id,
                    propertyName: missingProp.propertyName,
                    dataType: 'boolean',
                    stringValue: boolVal ? 'true' : 'false',
                    magnitudeValue: boolVal ? 1.0 : 0.0,
                  );
                }
              } else {
                final controller = TextEditingController();
                final enteredValue = await showDialog<String>(
                  context: ctx,
                  builder: (dialogCtx) => AlertDialog(
                    title: Text('Asignar ${missingProp.propertyName}'),
                    content: TextField(
                      controller: controller,
                      autofocus: true,
                      keyboardType: propType == PropertyDataType.integer
                          ? TextInputType.number
                          : propType == PropertyDataType.string
                              ? TextInputType.text
                              : const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: missingProp.propertyName,
                        suffixText: missingProp.unitSymbol,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(dialogCtx, null), child: const Text('Cancelar')),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(dialogCtx, controller.text.trim()),
                        child: const Text('Guardar'),
                      ),
                    ],
                  ),
                );

                if (enteredValue != null && enteredValue.isNotEmpty) {
                  if (propType == PropertyDataType.string) {
                    newMag = InstanceMagnitude(
                      id: const Uuid().v4(),
                      instanceId: entity.id,
                      propertyName: missingProp.propertyName,
                      dataType: 'string',
                      stringValue: enteredValue,
                      magnitudeValue: 0.0,
                    );
                  } else if (propType == PropertyDataType.integer) {
                    final intVal = int.tryParse(enteredValue) ?? 0;
                    newMag = InstanceMagnitude(
                      id: const Uuid().v4(),
                      instanceId: entity.id,
                      propertyName: missingProp.propertyName,
                      dataType: 'integer',
                      magnitudeValue: intVal.toDouble(),
                      unitSymbol: missingProp.unitSymbol,
                    );
                  } else {
                    final numVal = double.tryParse(enteredValue) ?? 0.0;
                    newMag = InstanceMagnitude(
                      id: const Uuid().v4(),
                      instanceId: entity.id,
                      propertyName: missingProp.propertyName,
                      dataType: 'real',
                      magnitudeValue: numVal,
                      unitSymbol: missingProp.unitSymbol,
                    );
                  }
                }
              }

              if (newMag != null) {
                final freshEntity = await ref.read(entityRepositoryProvider).getEntityById(entity.id) ?? entity;
                final List<InstanceMagnitude> currentMags = List.from(freshEntity.magnitudes);
                final existingIdx = currentMags.indexWhere(
                  (m) => m.propertyName.trim().toLowerCase() == missingProp.propertyName.trim().toLowerCase(),
                );

                if (existingIdx >= 0) {
                  currentMags[existingIdx] = newMag;
                } else {
                  currentMags.add(newMag);
                }

                await ref.read(entityRepositoryProvider).saveEntity(freshEntity.copyWith(magnitudes: currentMags));
                if (ctx.mounted) {
                  AppToast.showSuccess(ctx, 'Propiedad "${missingProp.propertyName}" registrada.');
                }
                return true;
              }
              return false;
            },
          ));
        }
      }
    }
    return cards;
  }
}

/// Strategy 4: Magnitud con Valor No Positivo
class AnomalousMagnitudeStrategy implements IAuditRuleStrategy {
  const AnomalousMagnitudeStrategy();

  @override
  AuditCardType get cardType => AuditCardType.anomalousMagnitude;

  @override
  String get ruleId => 'expiration_anomalous_magnitude';

  @override
  Future<List<AuditCardData>> evaluate(AuditEvaluationContext context) async {
    final cards = <AuditCardData>[];

    for (final entity in context.allEntities.take(20)) {
      final anomalousMags = entity.magnitudes.where((m) => m.magnitudeValue <= 0 && m.dataType == 'real').toList();
      for (final mag in anomalousMags) {
        final species = context.allCatalog.where((c) => c.id == entity.speciesId).firstOrNull;
        final displayName = EntityDisplayHelper.getDisplayName(
          entity: entity,
          catalogItems: context.allCatalog,
          subspeciesList: context.allSubspecies,
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
          onConfirm: (ctx, ref) async {
            if (ctx.mounted) {
              AppToast.showSuccess(ctx, 'Valor conservado.');
            }
            return true;
          },
          onFix: (ctx, ref) async {
            final controller = TextEditingController(text: mag.magnitudeValue.toString());
            final enteredValue = await showDialog<String>(
              context: ctx,
              builder: (dialogCtx) => AlertDialog(
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
                  TextButton(onPressed: () => Navigator.pop(dialogCtx, null), child: const Text('Cancelar')),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(dialogCtx, controller.text.trim()),
                    child: const Text('Guardar'),
                  ),
                ],
              ),
            );

            if (enteredValue != null && enteredValue.isNotEmpty) {
              final numVal = double.tryParse(enteredValue) ?? 0.0;
              final freshEntity = await ref.read(entityRepositoryProvider).getEntityById(entity.id) ?? entity;
              final updatedMags = freshEntity.magnitudes.map((m) =>
                  (m.id == mag.id || m.propertyName.trim().toLowerCase() == mag.propertyName.trim().toLowerCase())
                      ? m.copyWith(magnitudeValue: numVal)
                      : m).toList();
              await ref.read(entityRepositoryProvider).saveEntity(freshEntity.copyWith(magnitudes: updatedMags));
              if (ctx.mounted) {
                AppToast.showSuccess(ctx, 'Valor de "${mag.propertyName}" actualizado a $numVal.');
              }
              return true;
            }
            return false;
          },
        ));
      }
    }
    return cards;
  }
}
