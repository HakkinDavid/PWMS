import 'package:flutter/material.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';

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
    'GUARDADO_EN',
    'PERTENECE_A',
    'PARTE_DE',
    'DOCUMENTA',
    'USA',
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
      validRelationTypes: ['GUARDADO_EN', 'PERTENECE_A', 'PARTE_DE', 'USA', 'DOCUMENTA'],
    ),
    AppStrings.typeLivingBeing: EntityTemplate(
      typeName: AppStrings.typeLivingBeing,
      icon: Icons.pets,
      hasQuantity: true,
      hasBarcodeAndBrand: false,
      isAlwaysUnique: false,
      primaryView: TemplateViewKind.details,
      allowedActions: EntityActionType.values,
      validRelationTypes: ['GUARDADO_EN', 'PERTENECE_A', 'PARTE_DE', 'USA', 'DOCUMENTA'],
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
      validRelationTypes: ['DOCUMENTA', 'GUARDADO_EN', 'PERTENECE_A'],
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
      validRelationTypes: ['PARTE_DE', 'DOCUMENTA', 'USA'],
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
      validRelationTypes: ['PERTENECE_A', 'GUARDADO_EN'],
    ),
  };

  static EntityTemplate getTemplate(String typeName) {
    const map = _templates;
    if (map.containsKey(typeName)) {
      return map[typeName]!;
    }
    final clean = typeName.toLowerCase();
    if (clean.contains('ser vivo') || clean.contains('mascota') || clean.contains('planta')) return map[AppStrings.typeLivingBeing]!;
    if (clean.contains('doc')) return map[AppStrings.typeDocument]!;
    if (clean.contains('proyect') || clean.contains('idea')) return map[AppStrings.typeProject]!;
    if (clean.contains('recuerdo')) return map[AppStrings.typeMemory]!;

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
