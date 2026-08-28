import 'package:flutter/material.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import 'package:platinum_world_management_system/src/core/constants/app_technical_strings.dart';
import 'package:platinum_world_management_system/src/core/constants/units_registry.dart';
import 'package:platinum_world_management_system/src/core/domain/domain_rules.dart';
import 'package:platinum_world_management_system/src/core/domain/property_data_type.dart';
import 'package:platinum_world_management_system/src/core/providers/providers.dart';
import 'package:platinum_world_management_system/src/core/widgets/app_toast.dart';
import 'package:platinum_world_management_system/src/core/widgets/app_wheel_picker.dart';
import '../../../catalog/domain/species_magnitude.dart';
import '../../../entities/domain/instance_magnitude.dart';
import '../audit_rule_strategy.dart';
import 'audit_rule_helper.dart';

/// Strategy 1: Unidad de Medida No Reconocida o Inválida
class InvalidUnitSymbolStrategy implements IAuditRuleStrategy {
  const InvalidUnitSymbolStrategy();

  @override
  AuditCardType get cardType => AuditCardType.invalidUnitSymbol;

  @override
  String get ruleId => AppTechnicalStrings.ruleUnitInvalidSymbol;

  @override
  AuditCategory get category => AuditCategory.integrity;

  @override
  Future<List<AuditCardData>> evaluate(AuditEvaluationContext context) async {
    final cards = <AuditCardData>[];

    // 1. Auditar magnitudes a nivel de Especie
    for (final species in context.allCatalog) {
      final invalidSpeciesMags = species.magnitudes.where((sm) =>
          sm.unitSymbol != null &&
          sm.unitSymbol!.trim().isNotEmpty &&
          !UnitsRegistry.isKnownUnit(sm.unitSymbol)).toList();

      for (final sm in invalidSpeciesMags) {
        cards.add(AuditRuleHelper.forSpecies(
          id: AppTechnicalStrings.prefixInvUnit + species.id + AppTechnicalStrings.dash + sm.propertyName,
          type: AuditCardType.invalidUnitSymbol,
          title: AppStrings.invalidUnitSymbolTitle,
          subtitle: AppStrings.invalidUnitSymbolSubtitle(species.name, sm.propertyName, sm.unitSymbol!),
          question: AppStrings.invalidUnitSymbolQuestion(sm.propertyName, sm.unitSymbol!),
          icon: Icons.straighten,
          themeColor: Colors.purple,
          species: species,
          confirmLabel: AppStrings.confirmKeepUnitAction,
          fixLabel: AppStrings.fixChangeUnitAction,
          confirmToastMessage: AppStrings.invalidUnitRetained,
          onFix: (ctx, ref) async {
            final picked = await AppWheelPicker.show<String>(
              ctx,
              items: UnitsRegistry.allSiUnits,
              initialValue: UnitsRegistry.allSiUnits.first,
              labelBuilder: (u) => u,
              title: AppStrings.selectNewUnitPrompt,
            );

            if (picked != null && picked.isNotEmpty) {
              final catalogRepo = ref.read(catalogRepositoryProvider);
              final freshSpecies = await catalogRepo.getCatalogItemById(species.id) ?? species;
              final updatedMags = freshSpecies.magnitudes.map((m) {
                if (m.propertyName.trim().toLowerCase() == sm.propertyName.trim().toLowerCase()) {
                  return m.copyWith(
                    unitSymbol: picked,
                    dataType: DomainRules.suggestDataTypeForUnit(picked).code,
                  );
                }
                return m;
              }).toList();

              await catalogRepo.saveCatalogItem(freshSpecies.copyWith(magnitudes: updatedMags));
              if (ctx.mounted) {
                AppToast.showSuccess(ctx, AppStrings.unitUpdatedSuccess);
              }
              return true;
            }
            return false;
          },
        ));
      }
    }

    // 2. Auditar magnitudes a nivel de Instancia
    for (final entity in context.allEntities.take(30)) {
      final invalidEntityMags = entity.magnitudes.where((im) =>
          im.unitSymbol != null &&
          im.unitSymbol!.trim().isNotEmpty &&
          !UnitsRegistry.isKnownUnit(im.unitSymbol)).toList();

      for (final im in invalidEntityMags) {
        final species = context.allCatalog.where((c) => c.id == entity.speciesId).firstOrNull;
        final displayName = AuditRuleHelper.getEntityDisplayName(context, entity);

        cards.add(AuditRuleHelper.forEntity(
          id: AppTechnicalStrings.prefixInvUnit + im.id,
          type: AuditCardType.invalidUnitSymbol,
          title: AppStrings.invalidUnitSymbolTitle,
          subtitle: AppStrings.invalidUnitSymbolSubtitle(displayName, im.propertyName, im.unitSymbol!),
          question: AppStrings.invalidUnitSymbolQuestion(im.propertyName, im.unitSymbol!),
          icon: Icons.straighten,
          themeColor: Colors.purple,
          entity: entity,
          species: species,
          confirmLabel: AppStrings.confirmKeepUnitAction,
          fixLabel: AppStrings.fixChangeUnitAction,
          confirmToastMessage: AppStrings.invalidUnitRetained,
          onFix: (ctx, ref) async {
            final picked = await AppWheelPicker.show<String>(
              ctx,
              items: UnitsRegistry.allSiUnits,
              initialValue: UnitsRegistry.allSiUnits.first,
              labelBuilder: (u) => u,
              title: AppStrings.selectNewUnitPrompt,
            );

            if (picked != null && picked.isNotEmpty) {
              final entityRepo = ref.read(entityRepositoryProvider);
              final freshEntity = await entityRepo.getEntityById(entity.id) ?? entity;
              final updatedMags = freshEntity.magnitudes.map((m) {
                if (m.id == im.id || m.propertyName.trim().toLowerCase() == im.propertyName.trim().toLowerCase()) {
                  return m.copyWith(
                    unitSymbol: picked,
                    dataType: DomainRules.suggestDataTypeForUnit(picked).code,
                  );
                }
                return m;
              }).toList();

              await entityRepo.saveEntity(freshEntity.copyWith(magnitudes: updatedMags));
              if (ctx.mounted) {
                AppToast.showSuccess(ctx, AppStrings.unitUpdatedSuccess);
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

/// Strategy 2: Incongruencia en Unidades Enteras / Conteo Discreto
class IntegerUnitIncongruityStrategy implements IAuditRuleStrategy {
  const IntegerUnitIncongruityStrategy();

  @override
  AuditCardType get cardType => AuditCardType.integerUnitIncongruity;

  @override
  String get ruleId => AppTechnicalStrings.ruleUnitIntegerIncongruity;

  @override
  AuditCategory get category => AuditCategory.integrity;

  @override
  Future<List<AuditCardData>> evaluate(AuditEvaluationContext context) async {
    final cards = <AuditCardData>[];

    // 1. Especies con unidad entera pero tipo real, o especies únicas con unidad entera
    for (final species in context.allCatalog) {
      final incongruousMags = species.magnitudes.where((sm) {
        if (sm.unitSymbol == null) return false;
        final isIntUnit = DomainRules.isIntegerUnit(sm.unitSymbol);
        if (!isIntUnit) return false;
        final isWrongType = sm.dataType != AppTechnicalStrings.datatypeIntegerLower;
        final isUniqueViolation = species.isUnique;
        return isWrongType || isUniqueViolation;
      }).toList();

      for (final sm in incongruousMags) {
        cards.add(AuditRuleHelper.forSpecies(
          id: AppTechnicalStrings.prefixIntUnit + species.id + AppTechnicalStrings.dash + sm.propertyName,
          type: AuditCardType.integerUnitIncongruity,
          title: AppStrings.integerUnitIncongruityTitle,
          subtitle: AppStrings.integerUnitIncongruitySubtitle(species.name, sm.propertyName, sm.unitSymbol ?? AppTechnicalStrings.empty),
          question: AppStrings.integerUnitIncongruityQuestion(sm.propertyName, sm.unitSymbol ?? AppTechnicalStrings.empty),
          icon: Icons.pin_outlined,
          themeColor: Colors.deepOrange,
          species: species,
          confirmLabel: AppStrings.confirmKeepValueAction,
          fixLabel: AppStrings.fixNormalizeIntegerAction,
          confirmToastMessage: AppStrings.attributesSkipped,
          onFix: (ctx, ref) async {
            final catalogRepo = ref.read(catalogRepositoryProvider);
            final freshSpecies = await catalogRepo.getCatalogItemById(species.id) ?? species;
            final updatedMags = freshSpecies.magnitudes.map((m) {
              if (m.propertyName.trim().toLowerCase() == sm.propertyName.trim().toLowerCase()) {
                if (freshSpecies.isUnique) {
                  return m.copyWith(unitSymbol: null, dataType: AppTechnicalStrings.datatypeRealLower);
                }
                return m.copyWith(dataType: AppTechnicalStrings.datatypeIntegerLower);
              }
              return m;
            }).toList();

            await catalogRepo.saveCatalogItem(freshSpecies.copyWith(magnitudes: updatedMags));
            if (ctx.mounted) {
              AppToast.showSuccess(ctx, AppStrings.integerUnitNormalizedSuccess);
            }
            return true;
          },
        ));
      }
    }

    // 2. Instancias con unidad entera pero tipo real o valor decimal con residuo
    for (final entity in context.allEntities.take(30)) {
      final incongruousEntityMags = entity.magnitudes.where((im) {
        if (im.unitSymbol == null) return false;
        final isIntUnit = DomainRules.isIntegerUnit(im.unitSymbol);
        if (!isIntUnit) return false;
        final isWrongType = im.dataType != AppTechnicalStrings.datatypeIntegerLower;
        final hasDecimals = im.magnitudeValue != null && im.magnitudeValue != im.magnitudeValue!.roundToDouble();
        return isWrongType || hasDecimals;
      }).toList();

      for (final im in incongruousEntityMags) {
        final species = context.allCatalog.where((c) => c.id == entity.speciesId).firstOrNull;
        final displayName = AuditRuleHelper.getEntityDisplayName(context, entity);

        cards.add(AuditRuleHelper.forEntity(
          id: AppTechnicalStrings.prefixIntUnit + im.id,
          type: AuditCardType.integerUnitIncongruity,
          title: AppStrings.integerUnitIncongruityTitle,
          subtitle: AppStrings.integerUnitIncongruitySubtitle(displayName, im.propertyName, im.unitSymbol ?? AppTechnicalStrings.empty),
          question: AppStrings.integerUnitIncongruityQuestion(im.propertyName, im.unitSymbol ?? AppTechnicalStrings.empty),
          icon: Icons.pin_outlined,
          themeColor: Colors.deepOrange,
          entity: entity,
          species: species,
          confirmLabel: AppStrings.confirmKeepValueAction,
          fixLabel: AppStrings.fixNormalizeIntegerAction,
          confirmToastMessage: AppStrings.attributesSkipped,
          onFix: (ctx, ref) async {
            final entityRepo = ref.read(entityRepositoryProvider);
            final freshEntity = await entityRepo.getEntityById(entity.id) ?? entity;
            final updatedMags = freshEntity.magnitudes.map((m) {
              if (m.id == im.id || m.propertyName.trim().toLowerCase() == im.propertyName.trim().toLowerCase()) {
                return m.copyWith(
                  dataType: AppTechnicalStrings.datatypeIntegerLower,
                  magnitudeValue: m.magnitudeValue?.roundToDouble(),
                );
              }
              return m;
            }).toList();

            await entityRepo.saveEntity(freshEntity.copyWith(magnitudes: updatedMags));
            if (ctx.mounted) {
              AppToast.showSuccess(ctx, AppStrings.integerUnitNormalizedSuccess);
            }
            return true;
          },
        ));
      }
    }

    return cards;
  }
}

/// Strategy 3: Propiedad No Numérica con Unidad de Medida
class NonNumericWithUnitStrategy implements IAuditRuleStrategy {
  const NonNumericWithUnitStrategy();

  @override
  AuditCardType get cardType => AuditCardType.nonNumericWithUnit;

  @override
  String get ruleId => AppTechnicalStrings.ruleUnitNonNumericWithUnit;

  @override
  AuditCategory get category => AuditCategory.integrity;

  @override
  Future<List<AuditCardData>> evaluate(AuditEvaluationContext context) async {
    final cards = <AuditCardData>[];

    // 1. Especies
    for (final species in context.allCatalog) {
      final nonNumericWithUnitMags = species.magnitudes.where((sm) =>
          !PropertyDataType.fromCode(sm.dataType).isNumeric &&
          sm.unitSymbol != null &&
          sm.unitSymbol!.trim().isNotEmpty).toList();

      for (final sm in nonNumericWithUnitMags) {
        cards.add(AuditRuleHelper.forSpecies(
          id: AppTechnicalStrings.prefixNonNumUnit + species.id + AppTechnicalStrings.dash + sm.propertyName,
          type: AuditCardType.nonNumericWithUnit,
          title: AppStrings.nonNumericWithUnitTitle,
          subtitle: AppStrings.nonNumericWithUnitSubtitle(species.name, sm.propertyName, sm.dataType, sm.unitSymbol!),
          question: AppStrings.nonNumericWithUnitQuestion(sm.propertyName, sm.dataType),
          icon: Icons.text_fields_outlined,
          themeColor: Colors.blueGrey,
          species: species,
          confirmLabel: AppStrings.confirmKeepUnitAction,
          fixLabel: AppStrings.fixRemoveUnitAction,
          confirmToastMessage: AppStrings.attributesSkipped,
          onFix: (ctx, ref) async {
            final catalogRepo = ref.read(catalogRepositoryProvider);
            final freshSpecies = await catalogRepo.getCatalogItemById(species.id) ?? species;
            final updatedMags = freshSpecies.magnitudes.map((m) {
              if (m.propertyName.trim().toLowerCase() == sm.propertyName.trim().toLowerCase()) {
                return m.copyWith(unitSymbol: null);
              }
              return m;
            }).toList();

            await catalogRepo.saveCatalogItem(freshSpecies.copyWith(magnitudes: updatedMags));
            if (ctx.mounted) {
              AppToast.showSuccess(ctx, AppStrings.unitRemovedSuccess);
            }
            return true;
          },
        ));
      }
    }

    // 2. Instancias
    for (final entity in context.allEntities.take(30)) {
      final nonNumericWithUnitMags = entity.magnitudes.where((im) =>
          !PropertyDataType.fromCode(im.dataType).isNumeric &&
          im.unitSymbol != null &&
          im.unitSymbol!.trim().isNotEmpty).toList();

      for (final im in nonNumericWithUnitMags) {
        final species = context.allCatalog.where((c) => c.id == entity.speciesId).firstOrNull;
        final displayName = AuditRuleHelper.getEntityDisplayName(context, entity);

        cards.add(AuditRuleHelper.forEntity(
          id: AppTechnicalStrings.prefixNonNumUnit + im.id,
          type: AuditCardType.nonNumericWithUnit,
          title: AppStrings.nonNumericWithUnitTitle,
          subtitle: AppStrings.nonNumericWithUnitSubtitle(displayName, im.propertyName, im.dataType, im.unitSymbol!),
          question: AppStrings.nonNumericWithUnitQuestion(im.propertyName, im.dataType),
          icon: Icons.text_fields_outlined,
          themeColor: Colors.blueGrey,
          entity: entity,
          species: species,
          confirmLabel: AppStrings.confirmKeepUnitAction,
          fixLabel: AppStrings.fixRemoveUnitAction,
          confirmToastMessage: AppStrings.attributesSkipped,
          onFix: (ctx, ref) async {
            final entityRepo = ref.read(entityRepositoryProvider);
            final freshEntity = await entityRepo.getEntityById(entity.id) ?? entity;
            final updatedMags = freshEntity.magnitudes.map((m) {
              if (m.id == im.id || m.propertyName.trim().toLowerCase() == im.propertyName.trim().toLowerCase()) {
                return m.copyWith(unitSymbol: null);
              }
              return m;
            }).toList();

            await entityRepo.saveEntity(freshEntity.copyWith(magnitudes: updatedMags));
            if (ctx.mounted) {
              AppToast.showSuccess(ctx, AppStrings.unitRemovedSuccess);
            }
            return true;
          },
        ));
      }
    }

    return cards;
  }
}

/// Strategy 4: Magnitud con Valor Negativo Inválido
class NegativeMagnitudeViolationStrategy implements IAuditRuleStrategy {
  const NegativeMagnitudeViolationStrategy();

  @override
  AuditCardType get cardType => AuditCardType.negativeMagnitudeViolation;

  @override
  String get ruleId => AppTechnicalStrings.ruleUnitNegativeMagnitudeViolation;

  @override
  AuditCategory get category => AuditCategory.integrity;

  @override
  Future<List<AuditCardData>> evaluate(AuditEvaluationContext context) async {
    final cards = <AuditCardData>[];

    for (final entity in context.allEntities.take(30)) {
      final negativeMags = entity.magnitudes.where((im) {
        if (im.magnitudeValue == null || im.magnitudeValue! >= 0) return false;
        final def = UnitsRegistry.getDefinition(im.unitSymbol);
        return !def.allowNegatives;
      }).toList();

      for (final im in negativeMags) {
        final species = context.allCatalog.where((c) => c.id == entity.speciesId).firstOrNull;
        final displayName = AuditRuleHelper.getEntityDisplayName(context, entity);

        cards.add(AuditRuleHelper.forEntity(
          id: AppTechnicalStrings.prefixNegMag + im.id,
          type: AuditCardType.negativeMagnitudeViolation,
          title: AppStrings.negativeMagnitudeViolationTitle,
          subtitle: AppStrings.negativeMagnitudeViolationSubtitle(
            displayName,
            im.propertyName,
            im.magnitudeValue ?? 0.0,
            im.unitSymbol ?? AppTechnicalStrings.empty,
          ),
          question: AppStrings.negativeMagnitudeViolationQuestion(im.propertyName),
          icon: Icons.remove_circle_outline,
          themeColor: Colors.redAccent,
          entity: entity,
          species: species,
          confirmLabel: AppStrings.confirmKeepValueAction,
          fixLabel: AppStrings.fixCorrectValueAction,
          confirmToastMessage: AppStrings.valueKept,
          onFix: (ctx, ref) async {
            final enteredValue = await AuditRuleHelper.showTextInputDialog(
              ctx,
              title: AppStrings.correctPropertyTitle(im.propertyName),
              labelText: im.propertyName,
              initialValue: AppTechnicalStrings.valZero,
              suffixText: im.unitSymbol,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            );

            if (enteredValue != null && enteredValue.isNotEmpty) {
              final parsed = double.tryParse(enteredValue) ?? 0.0;
              final nonNegative = parsed < 0 ? 0.0 : parsed;
              final entityRepo = ref.read(entityRepositoryProvider);
              final freshEntity = await entityRepo.getEntityById(entity.id) ?? entity;
              final updatedMags = freshEntity.magnitudes.map((m) {
                if (m.id == im.id || m.propertyName.trim().toLowerCase() == im.propertyName.trim().toLowerCase()) {
                  return m.copyWith(magnitudeValue: nonNegative);
                }
                return m;
              }).toList();

              await entityRepo.saveEntity(freshEntity.copyWith(magnitudes: updatedMags));
              if (ctx.mounted) {
                AppToast.showSuccess(ctx, AppStrings.negativeValueCorrectedSuccess);
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

/// Strategy 5: Nombre de Propiedad Genérico Desalineado de la Sugerencia Estándar
class PropertyNameSuggestionIncongruityStrategy implements IAuditRuleStrategy {
  const PropertyNameSuggestionIncongruityStrategy();

  @override
  AuditCardType get cardType => AuditCardType.propertyNameSuggestionIncongruity;

  @override
  String get ruleId => AppTechnicalStrings.ruleUnitPropertyNameSuggestionIncongruity;

  @override
  AuditCategory get category => AuditCategory.integrity;

  @override
  Future<List<AuditCardData>> evaluate(AuditEvaluationContext context) async {
    final cards = <AuditCardData>[];

    for (final species in context.allCatalog) {
      final genericMags = species.magnitudes.where((sm) {
        if (sm.unitSymbol == null || !UnitsRegistry.isKnownUnit(sm.unitSymbol)) return false;
        final cleanProp = sm.propertyName.trim().toLowerCase();
        final isGeneric = cleanProp.isEmpty || AppTechnicalStrings.genericPropertyNamesSet.contains(cleanProp);
        final suggested = DomainRules.suggestPropertyNameForUnit(sm.unitSymbol!);
        return isGeneric && suggested.toLowerCase() != cleanProp;
      }).toList();

      for (final sm in genericMags) {
        final suggested = DomainRules.suggestPropertyNameForUnit(sm.unitSymbol!);
        cards.add(AuditRuleHelper.forSpecies(
          id: AppTechnicalStrings.prefixPropSug + species.id + AppTechnicalStrings.dash + sm.propertyName,
          type: AuditCardType.propertyNameSuggestionIncongruity,
          title: AppStrings.propertyNameSuggestionIncongruityTitle,
          subtitle: AppStrings.propertyNameSuggestionIncongruitySubtitle(species.name, sm.propertyName, suggested, sm.unitSymbol!),
          question: AppStrings.propertyNameSuggestionIncongruityQuestion(sm.propertyName, suggested, sm.unitSymbol!),
          icon: Icons.auto_fix_high,
          themeColor: Colors.indigo,
          species: species,
          confirmLabel: AppStrings.confirmKeepNameAction,
          fixLabel: AppStrings.fixRenamePropertyAction,
          confirmToastMessage: AppStrings.attributesSkipped,
          onFix: (ctx, ref) async {
            final catalogRepo = ref.read(catalogRepositoryProvider);
            final freshSpecies = await catalogRepo.getCatalogItemById(species.id) ?? species;
            final updatedMags = freshSpecies.magnitudes.map((m) {
              if (m.propertyName.trim().toLowerCase() == sm.propertyName.trim().toLowerCase()) {
                return m.copyWith(propertyName: suggested);
              }
              return m;
            }).toList();

            await catalogRepo.saveCatalogItem(freshSpecies.copyWith(magnitudes: updatedMags));
            if (ctx.mounted) {
              AppToast.showSuccess(ctx, AppStrings.propertyNameRenamedSuccess);
            }
            return true;
          },
        ));
      }
    }

    return cards;
  }
}
