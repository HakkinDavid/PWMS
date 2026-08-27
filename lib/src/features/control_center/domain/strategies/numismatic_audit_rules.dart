import 'dart:io';
import 'package:flutter/material.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import 'package:platinum_world_management_system/src/core/providers/providers.dart';
import 'package:platinum_world_management_system/src/core/widgets/app_toast.dart';
import 'package:platinum_world_management_system/src/core/widgets/app_wheel_picker.dart';
import 'package:uuid/uuid.dart';
import '../../../catalog/domain/numismatic_data_helper.dart';
import '../../../entities/domain/attachment.dart';
import '../../../entities/domain/instance_magnitude.dart';
import '../../../entities/infrastructure/entity_repository.dart';
import '../audit_rule_strategy.dart';
import 'audit_rule_helper.dart';

/// Strategy 1: Subespecies Numismáticas Duplicadas
class NumismaticDuplicateSubspeciesStrategy implements IAuditRuleStrategy {
  const NumismaticDuplicateSubspeciesStrategy();

  @override
  AuditCardType get cardType => AuditCardType.numismaticDuplicateSubspecies;

  @override
  String get ruleId => 'numismatic_duplicate_subspecies';

  @override
  Future<List<AuditCardData>> evaluate(AuditEvaluationContext context) async {
    final duplicateSubGroups = NumismaticDataHelper.findDuplicateSubspeciesGroups(context.allSubspecies);
    final cards = <AuditCardData>[];

    for (final entry in duplicateSubGroups.entries) {
      final canonicalSub = entry.value.first;
      final parentSpecies = context.allCatalog.where((c) => c.id == canonicalSub.speciesId).firstOrNull;
      if (parentSpecies != null && NumismaticDataHelper.isNumismaticSpecies(parentSpecies)) {
        final dupCount = entry.value.length;
        cards.add(AuditRuleHelper.forSubspecies(
          id: 'numis_dup_${canonicalSub.id}',
          type: AuditCardType.numismaticDuplicateSubspecies,
          title: 'Subespecies Numismáticas Duplicadas',
          subtitle: '${canonicalSub.subspeciesName} • $dupCount subespecies idénticas en ${parentSpecies.name}',
          question: 'Existen $dupCount subespecies registradas para "${canonicalSub.subspeciesName}". ¿Deseas fusionarlas y reasignar sus piezas a una sola subespecie canónica?',
          icon: Icons.filter_none,
          themeColor: Colors.deepOrange,
          subspecies: canonicalSub,
          species: parentSpecies,
          confirmToastMessage: 'Subespecies duplicadas conservadas sin cambios.',
          onFix: (ctx, ref) async {
            final confirm = await AuditRuleHelper.showConfirmationDialog(
              ctx,
              title: 'Fusionar Subespecies Duplicadas',
              content: '¿Deseas consolidar las $dupCount subespecies de "${canonicalSub.subspeciesName}" en una sola subespecie y reasignar todas las instancias existentes?',
              confirmLabel: 'Fusionar y Reasignar',
            );

            if (confirm) {
              await NumismaticDataHelper.mergeDuplicateSubspecies(
                catalogRepo: ref.read(catalogRepositoryProvider),
                entityRepo: ref.read(entityRepositoryProvider),
                canonicalSubspecies: canonicalSub,
                duplicateSubspeciesList: entry.value,
              );
              if (ctx.mounted) {
                AppToast.showSuccess(ctx, 'Subespecies duplicadas fusionadas con éxito.');
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

/// Strategy 2: Incongruencias entre Subespecie e Instancia Numismática
class NumismaticSubspeciesIncongruityStrategy implements IAuditRuleStrategy {
  const NumismaticSubspeciesIncongruityStrategy();

  @override
  AuditCardType get cardType => AuditCardType.numismaticSubspeciesIncongruity;

  @override
  String get ruleId => 'numismatic_subspecies_incongruity';

  @override
  Future<List<AuditCardData>> evaluate(AuditEvaluationContext context) async {
    final cards = <AuditCardData>[];

    for (final entity in context.allEntities) {
      final species = context.allCatalog.where((c) => c.id == entity.speciesId).firstOrNull;
      if (species != null && NumismaticDataHelper.isNumismaticSpecies(species) && entity.subspeciesId != null) {
        final sub = context.allSubspecies.where((s) => s.id == entity.subspeciesId).firstOrNull;
        if (sub != null) {
          final displayName = AuditRuleHelper.getEntityDisplayName(context, entity);

          final issueMsg = NumismaticDataHelper.checkInstanceSubspeciesCongruence(
            subspecies: sub,
            instance: entity,
          );

          if (issueMsg != null) {
            cards.add(AuditRuleHelper.forEntity(
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
              confirmToastMessage: 'Incongruencia omitida.',
              onFix: (ctx, ref) async {
                final action = await showDialog<String>(
                  context: ctx,
                  builder: (dialogCtx) => AlertDialog(
                    title: const Text('Corregir Incongruencia Numismática'),
                    content: Text('Sincronizar información para "$displayName":\n\n$issueMsg'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(dialogCtx, 'cancel'), child: const Text('Cancelar')),
                      OutlinedButton(
                        onPressed: () => Navigator.pop(dialogCtx, 'subspecies'),
                        child: const Text('Actualizar Subespecie según la Instancia'),
                      ),
                    ],
                  ),
                );

                if (action == 'subspecies') {
                  final freshEntity = await ref.read(entityRepositoryProvider).getEntityById(entity.id) ?? entity;
                  final freshSub = await ref.read(catalogRepositoryProvider).getSubspeciesById(sub.id) ?? sub;
                  final updatedSub = await NumismaticDataHelper.repairSubspeciesFromInstance(
                    catalogRepo: ref.read(catalogRepositoryProvider),
                    entityRepo: ref.read(entityRepositoryProvider),
                    subspecies: freshSub,
                    instance: freshEntity,
                  );
                  await NumismaticDataHelper.repairAttachmentFileNames(
                    catalogRepo: ref.read(catalogRepositoryProvider),
                    entityRepo: ref.read(entityRepositoryProvider),
                    subspecies: updatedSub,
                    instance: freshEntity,
                  );
                  if (ctx.mounted) {
                    AppToast.showSuccess(ctx, 'Subespecie y adjuntos sincronizados con éxito.');
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
    return cards;
  }
}

/// Strategy 3: Nombres de Archivo de Adjuntos Desincronizados
class NumismaticAttachmentIncongruityStrategy implements IAuditRuleStrategy {
  const NumismaticAttachmentIncongruityStrategy();

  @override
  AuditCardType get cardType => AuditCardType.numismaticAttachmentIncongruity;

  @override
  String get ruleId => 'numismatic_attachment_incongruity';

  @override
  Future<List<AuditCardData>> evaluate(AuditEvaluationContext context) async {
    final cards = <AuditCardData>[];

    for (final entity in context.allEntities) {
      final species = context.allCatalog.where((c) => c.id == entity.speciesId).firstOrNull;
      if (species != null && NumismaticDataHelper.isNumismaticSpecies(species) && entity.subspeciesId != null) {
        final sub = context.allSubspecies.where((s) => s.id == entity.subspeciesId).firstOrNull;
        if (sub != null) {
          final displayName = AuditRuleHelper.getEntityDisplayName(context, entity);

          final instanceAttachments = (context.db != null)
              ? await EntityRepository(context.db).getAttachmentsForInstance(entity.id)
              : <Attachment>[];
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
              cards.add(AuditRuleHelper.forEntity(
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
                confirmToastMessage: AppStrings.attachmentNameRetainedSuccess,
                onFix: (ctx, ref) async {
                  final freshEntity = await ref.read(entityRepositoryProvider).getEntityById(entity.id) ?? entity;
                  final freshSub = await ref.read(catalogRepositoryProvider).getSubspeciesById(sub.id) ?? sub;
                  await NumismaticDataHelper.repairAttachmentFileNames(
                    catalogRepo: ref.read(catalogRepositoryProvider),
                    entityRepo: ref.read(entityRepositoryProvider),
                    subspecies: freshSub,
                    instance: freshEntity,
                  );
                  if (ctx.mounted) {
                    AppToast.showSuccess(ctx, AppStrings.attachmentRenamedSuccess);
                  }
                  return true;
                },
              ));
            }
          }
        }
      }
    }
    return cards;
  }
}

/// Strategy 4: Magnitudes Numismáticas Faltantes
class NumismaticMissingMagnitudesStrategy implements IAuditRuleStrategy {
  const NumismaticMissingMagnitudesStrategy();

  @override
  AuditCardType get cardType => AuditCardType.numismaticMissingMagnitudes;

  @override
  String get ruleId => 'numismatic_missing_magnitudes';

  @override
  Future<List<AuditCardData>> evaluate(AuditEvaluationContext context) async {
    final cards = <AuditCardData>[];

    for (final entity in context.allEntities) {
      final species = context.allCatalog.where((c) => c.id == entity.speciesId).firstOrNull;
      if (species != null && NumismaticDataHelper.isNumismaticSpecies(species) && entity.subspeciesId != null) {
        final sub = context.allSubspecies.where((s) => s.id == entity.subspeciesId).firstOrNull;
        if (sub != null) {
          final displayName = AuditRuleHelper.getEntityDisplayName(context, entity);

          final instAttrs = NumismaticDataHelper.extractAttributesFromInstance(entity);
          final missingMags = <String>[];
          if (instAttrs.faceValueNumber == null) missingMags.add(AppStrings.nominalValuePropertyName);
          if (instAttrs.year == null) missingMags.add(AppStrings.mintagePropertyName);
          if (instAttrs.currencyName == null) missingMags.add(AppStrings.currencyPropertyName);

          if (missingMags.isNotEmpty) {
            cards.add(AuditRuleHelper.forEntity(
              id: 'numis_mag_${entity.id}',
              type: AuditCardType.numismaticMissingMagnitudes,
              title: AppStrings.incompleteNumismaticMagnitudesTitle,
              subtitle: '$displayName • Faltan: ${missingMags.join(", ")}',
              question: 'La instancia "$displayName" no tiene registradas las magnitudes (${missingMags.join(", ")}). ¿Deseas autocompletarlas desde el título de la subespecie?',
              icon: Icons.fact_check_outlined,
              themeColor: Colors.blueGrey,
              entity: entity,
              subspecies: sub,
              species: species,
              confirmToastMessage: AppStrings.magnitudesRetainedSuccess,
              onFix: (ctx, ref) async {
                final parsedSub = NumismaticDataHelper.parseSubspeciesName(sub.subspeciesName);
                final freshEntity = await ref.read(entityRepositoryProvider).getEntityById(entity.id) ?? entity;
                final freshInstAttrs = NumismaticDataHelper.extractAttributesFromInstance(freshEntity);
                final List<InstanceMagnitude> currentMags = List.from(freshEntity.magnitudes);

                if (parsedSub.faceValueNumber != null && freshInstAttrs.faceValueNumber == null) {
                  currentMags.add(InstanceMagnitude(
                    id: const Uuid().v4(),
                    instanceId: freshEntity.id,
                    propertyName: AppStrings.nominalValuePropertyName,
                    dataType: 'real',
                    magnitudeValue: parsedSub.faceValueNumber!,
                  ));
                }

                if (parsedSub.year != null && freshInstAttrs.year == null && double.tryParse(parsedSub.year!) != null) {
                  currentMags.add(InstanceMagnitude(
                    id: const Uuid().v4(),
                    instanceId: freshEntity.id,
                    propertyName: AppStrings.mintagePropertyName,
                    dataType: 'integer',
                    magnitudeValue: double.parse(parsedSub.year!),
                    unitSymbol: 'año',
                  ));
                }

                if (parsedSub.currencyName != null && freshInstAttrs.currencyName == null) {
                  currentMags.add(InstanceMagnitude(
                    id: const Uuid().v4(),
                    instanceId: freshEntity.id,
                    propertyName: AppStrings.currencyPropertyName,
                    dataType: 'string',
                    stringValue: parsedSub.currencyName,
                  ));
                }

                final updatedEntity = freshEntity.copyWith(magnitudes: currentMags);
                await ref.read(entityRepositoryProvider).saveEntity(updatedEntity);

                if (ctx.mounted) {
                  AppToast.showSuccess(ctx, AppStrings.numismaticMagnitudesAutoFilledSuccess);
                }
                return true;
              },
            ));
          }
        }
      }
    }
    return cards;
  }
}

/// Strategy 5: Atributos Opcionales Vacíos (ej. Grado de Conservación)
class EmptyDataAuditStrategy implements IAuditRuleStrategy {
  const EmptyDataAuditStrategy();

  @override
  AuditCardType get cardType => AuditCardType.emptyDataAudit;

  @override
  String get ruleId => 'numismatic_empty_data_audit';

  @override
  Future<List<AuditCardData>> evaluate(AuditEvaluationContext context) async {
    final cards = <AuditCardData>[];

    for (final entity in context.allEntities) {
      final species = context.allCatalog.where((c) => c.id == entity.speciesId).firstOrNull;
      if (species != null && NumismaticDataHelper.isNumismaticSpecies(species) && entity.subspeciesId != null) {
        final sub = context.allSubspecies.where((s) => s.id == entity.subspeciesId).firstOrNull;
        if (sub != null) {
          final displayName = AuditRuleHelper.getEntityDisplayName(context, entity);

          final instAttrs = NumismaticDataHelper.extractAttributesFromInstance(entity);
          if (instAttrs.grade == null || instAttrs.grade!.trim().isEmpty) {
            cards.add(AuditRuleHelper.forEntity(
              id: 'numis_empty_grade_${entity.id}',
              type: AuditCardType.emptyDataAudit,
              title: AppStrings.emptyGradeDataTitle,
              subtitle: '$displayName • Grado de conservación sin asignar',
              question: 'La pieza "$displayName" no tiene especificado su estado o grado de conservación. ¿Deseas asignarle un grado ahora?',
              icon: Icons.star_outline,
              themeColor: Colors.amber.shade800,
              entity: entity,
              subspecies: sub,
              species: species,
              confirmToastMessage: AppStrings.gradeRetainedEmptySuccess,
              onFix: (ctx, ref) async {
                final chosenGrade = await AppWheelPicker.show<String>(
                  ctx,
                  items: NumismaticDataHelper.grades,
                  initialValue: NumismaticDataHelper.grades.first,
                  labelBuilder: (g) => g,
                  title: AppStrings.assignGradeTitle,
                );

                if (chosenGrade != null && chosenGrade.isNotEmpty) {
                  final freshEntity = await ref.read(entityRepositoryProvider).getEntityById(entity.id) ?? entity;
                  final List<InstanceMagnitude> currentMags = List.from(freshEntity.magnitudes);
                  final existingGradeIdx = currentMags.indexWhere((m) => m.propertyName == AppStrings.gradePropertyName);
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
                      instanceId: freshEntity.id,
                      propertyName: AppStrings.gradePropertyName,
                      dataType: 'string',
                      stringValue: chosenGrade,
                    ));
                  }

                  final updatedEntity = freshEntity.copyWith(magnitudes: currentMags);
                  await ref.read(entityRepositoryProvider).saveEntity(updatedEntity);

                  if (ctx.mounted) {
                    AppToast.showSuccess(ctx, 'Grado de conservación actualizado a "$chosenGrade".');
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
    return cards;
  }
}

