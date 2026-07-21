import 'package:flutter/material.dart';

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
  final bool hasMonetaryValue;
  final bool hasBarcodeAndBrand;
  final bool isAlwaysUnique;
  final TemplateViewKind primaryView;
  final List<EntityActionType> allowedActions;
  final List<String> validRelationTypes;

  const EntityTemplate({
    required this.typeName,
    required this.icon,
    this.hasQuantity = false,
    this.hasMonetaryValue = true,
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
    'Objeto': EntityTemplate(
      typeName: 'Objeto',
      icon: Icons.category,
      hasQuantity: true,
      hasMonetaryValue: true,
      hasBarcodeAndBrand: true,
      isAlwaysUnique: false,
      primaryView: TemplateViewKind.details,
      allowedActions: EntityActionType.values,
      validRelationTypes: ['GUARDADO_EN', 'PERTENECE_A', 'PARTE_DE', 'USA', 'DOCUMENTA'],
    ),
    'Ser vivo': EntityTemplate(
      typeName: 'Ser vivo',
      icon: Icons.pets,
      hasQuantity: true,
      hasMonetaryValue: true,
      hasBarcodeAndBrand: false,
      isAlwaysUnique: false,
      primaryView: TemplateViewKind.details,
      allowedActions: EntityActionType.values,
      validRelationTypes: ['GUARDADO_EN', 'PERTENECE_A', 'PARTE_DE', 'USA', 'DOCUMENTA'],
    ),
    'Documento': EntityTemplate(
      typeName: 'Documento',
      icon: Icons.description,
      hasQuantity: false,
      hasMonetaryValue: false,
      hasBarcodeAndBrand: false,
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
    'Proyecto': EntityTemplate(
      typeName: 'Proyecto',
      icon: Icons.lightbulb,
      hasQuantity: false,
      hasMonetaryValue: true,
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
    'Recuerdo': EntityTemplate(
      typeName: 'Recuerdo',
      icon: Icons.star,
      hasQuantity: false,
      hasMonetaryValue: false,
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
    if (_templates.containsKey(typeName)) {
      return _templates[typeName]!;
    }
    final clean = typeName.toLowerCase();
    if (clean.contains('ser vivo') || clean.contains('mascota') || clean.contains('planta')) return _templates['Ser vivo']!;
    if (clean.contains('doc')) return _templates['Documento']!;
    if (clean.contains('proyect') || clean.contains('idea')) return _templates['Proyecto']!;
    if (clean.contains('recuerdo')) return _templates['Recuerdo']!;

    return _templates['Objeto']!;
  }

  static bool hasQuantity(String typeName) {
    return getTemplate(typeName).hasQuantity;
  }

  static bool isAlwaysUnique(String typeName) {
    return getTemplate(typeName).isAlwaysUnique;
  }
}
