import 'package:flutter/material.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import 'package:platinum_world_management_system/src/core/constants/app_technical_strings.dart';

enum TemplateViewKind {
  details,
  documents,
  notesAndMedia,
}

enum EntityActionType {
  move,
  consume,
  edit,
  relate,
  addFile,
  addPhoto,
  delete,
}

class EntityTemplate {
  final String typeName;
  final IconData icon;
  final bool hasQuantity;
  final bool hasBarcodeAndBrand;
  final bool isAlwaysUnique;
  final TemplateViewKind primaryView;
  final List<EntityActionType> allowedActions;
  final List<String> validRelationTypes;

  const EntityTemplate({
    required this.typeName,
    required this.icon,
    this.hasQuantity = false,
    this.hasBarcodeAndBrand = true,
    this.isAlwaysUnique = false,
    required this.primaryView,
    required this.allowedActions,
    required this.validRelationTypes,
  });
}

class EntityTemplateRegistry {
  EntityTemplateRegistry._();

  static const List<String> directedRelationTypes = [
    AppTechnicalStrings.relPerteneceA,
    AppTechnicalStrings.relParteDe,
    AppTechnicalStrings.relDocumenta,
    AppTechnicalStrings.relUsa,
  ];

  static const Map<String, EntityTemplate> _templates = {
    AppStrings.typeObject: EntityTemplate(
      typeName: AppStrings.typeObject,
      icon: Icons.category,
      hasQuantity: true,
      hasBarcodeAndBrand: true,
      isAlwaysUnique: false,
      primaryView: TemplateViewKind.details,
      allowedActions: EntityActionType.values,
      validRelationTypes: [
        AppTechnicalStrings.relPerteneceA,
        AppTechnicalStrings.relParteDe,
        AppTechnicalStrings.relUsa,
        AppTechnicalStrings.relDocumenta,
      ],
    ),
    AppStrings.typeLivingBeing: EntityTemplate(
      typeName: AppStrings.typeLivingBeing,
      icon: Icons.pets,
      hasQuantity: true,
      hasBarcodeAndBrand: false,
      isAlwaysUnique: false,
      primaryView: TemplateViewKind.details,
      allowedActions: EntityActionType.values,
      validRelationTypes: [
        AppTechnicalStrings.relPerteneceA,
        AppTechnicalStrings.relParteDe,
        AppTechnicalStrings.relUsa,
        AppTechnicalStrings.relDocumenta,
      ],
    ),
    AppStrings.typeDocument: EntityTemplate(
      typeName: AppStrings.typeDocument,
      icon: Icons.description,
      hasQuantity: false,
      hasBarcodeAndBrand: true,
      isAlwaysUnique: true,
      primaryView: TemplateViewKind.documents,
      allowedActions: [
        EntityActionType.move,
        EntityActionType.edit,
        EntityActionType.relate,
        EntityActionType.addPhoto,
        EntityActionType.addFile,
        EntityActionType.delete,
      ],
      validRelationTypes: [
        AppTechnicalStrings.relDocumenta,
        AppTechnicalStrings.relPerteneceA,
      ],
    ),
    AppStrings.typeProject: EntityTemplate(
      typeName: AppStrings.typeProject,
      icon: Icons.lightbulb,
      hasQuantity: false,
      hasBarcodeAndBrand: false,
      isAlwaysUnique: true,
      primaryView: TemplateViewKind.notesAndMedia,
      allowedActions: [
        EntityActionType.edit,
        EntityActionType.relate,
        EntityActionType.addPhoto,
        EntityActionType.addFile,
        EntityActionType.delete,
      ],
      validRelationTypes: [
        AppTechnicalStrings.relParteDe,
        AppTechnicalStrings.relDocumenta,
        AppTechnicalStrings.relUsa,
      ],
    ),
    AppStrings.typeMemory: EntityTemplate(
      typeName: AppStrings.typeMemory,
      icon: Icons.star,
      hasQuantity: false,
      hasBarcodeAndBrand: false,
      isAlwaysUnique: true,
      primaryView: TemplateViewKind.notesAndMedia,
      allowedActions: [
        EntityActionType.move,
        EntityActionType.edit,
        EntityActionType.relate,
        EntityActionType.addPhoto,
        EntityActionType.addFile,
        EntityActionType.delete,
      ],
      validRelationTypes: [
        AppTechnicalStrings.relPerteneceA,
      ],
    ),
  };

  static EntityTemplate getTemplate(String typeName) {
    const map = _templates;
    if (map.containsKey(typeName)) {
      return map[typeName]!;
    }
    final clean = typeName.toLowerCase();
    if (clean.contains(AppTechnicalStrings.entityTypeKeywordSerVivo) ||
        clean.contains(AppTechnicalStrings.entityTypeKeywordMascota) ||
        clean.contains(AppTechnicalStrings.entityTypeKeywordPlanta)) {
      return map[AppStrings.typeLivingBeing]!;
    }
    if (clean.contains(AppTechnicalStrings.entityTypeKeywordDoc)) return map[AppStrings.typeDocument]!;
    if (clean.contains(AppTechnicalStrings.entityTypeKeywordProyect) ||
        clean.contains(AppTechnicalStrings.entityTypeKeywordIdea)) {
      return map[AppStrings.typeProject]!;
    }
    if (clean.contains(AppTechnicalStrings.entityTypeKeywordRecuerdo)) return map[AppStrings.typeMemory]!;

    return map[AppStrings.typeObject]!;
  }

  static bool hasQuantity(String typeName) {
    return getTemplate(typeName).hasQuantity;
  }

  static bool isAlwaysUnique(String typeName) {
    return getTemplate(typeName).isAlwaysUnique;
  }

  static bool hasBarcodeAndBrand(String typeName) {
    return getTemplate(typeName).hasBarcodeAndBrand;
  }
}
