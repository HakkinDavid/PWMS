import 'package:flutter/material.dart';

enum TemplateViewKind {
  contents,
  documents,
  parts,
  details,
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
  final bool isContainer;
  final bool isPlace;
  final bool hasQuantity;
  final bool canBeInContainer;
  final TemplateViewKind primaryView;
  final List<EntityActionType> allowedActions;
  final List<String> validRelationTypes;
  final List<String> commonUnits;

  const EntityTemplate({
    required this.typeName,
    required this.icon,
    this.isContainer = false,
    this.isPlace = false,
    this.hasQuantity = false,
    this.canBeInContainer = true,
    required this.primaryView,
    required this.allowedActions,
    required this.validRelationTypes,
    this.commonUnits = const [],
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
    'Lugar': EntityTemplate(
      typeName: 'Lugar',
      icon: Icons.place,
      isPlace: true,
      isContainer: true,
      hasQuantity: false,
      canBeInContainer: false,
      primaryView: TemplateViewKind.contents,
      allowedActions: [
        EntityActionType.edit,
        EntityActionType.relate,
        EntityActionType.addPhoto,
        EntityActionType.addFile,
        EntityActionType.delete,
      ],
      validRelationTypes: ['PARTE_DE', 'DOCUMENTA'],
    ),
    'Contenedor': EntityTemplate(
      typeName: 'Contenedor',
      icon: Icons.inventory_2,
      isContainer: true,
      isPlace: false,
      hasQuantity: false,
      canBeInContainer: true,
      primaryView: TemplateViewKind.contents,
      allowedActions: [
        EntityActionType.move,
        EntityActionType.edit,
        EntityActionType.relate,
        EntityActionType.addPhoto,
        EntityActionType.addFile,
        EntityActionType.delete,
      ],
      validRelationTypes: ['GUARDADO_EN', 'PERTENECE_A', 'PARTE_DE'],
    ),
    'Objeto / Herramienta': EntityTemplate(
      typeName: 'Objeto / Herramienta',
      icon: Icons.build,
      isContainer: false,
      isPlace: false,
      hasQuantity: true,
      canBeInContainer: true,
      primaryView: TemplateViewKind.details,
      allowedActions: EntityActionType.values,
      validRelationTypes: ['GUARDADO_EN', 'PERTENECE_A', 'PARTE_DE', 'USA', 'DOCUMENTA'],
      commonUnits: ['piezas', 'unidades', 'kg', 'litros', 'metros'],
    ),
    'Documento': EntityTemplate(
      typeName: 'Documento',
      icon: Icons.description,
      isContainer: false,
      isPlace: false,
      hasQuantity: false,
      canBeInContainer: true,
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
    'Proyecto / Idea': EntityTemplate(
      typeName: 'Proyecto / Idea',
      icon: Icons.lightbulb,
      isContainer: false,
      isPlace: false,
      hasQuantity: false,
      canBeInContainer: false,
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
      isContainer: false,
      isPlace: false,
      hasQuantity: false,
      canBeInContainer: true,
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
    // Fallback matching for legacy or custom types
    final clean = typeName.toLowerCase();
    if (clean.contains('lugar')) return _templates['Lugar']!;
    if (clean.contains('caja') || clean.contains('contenedor') || clean.contains('estante')) return _templates['Contenedor']!;
    if (clean.contains('doc')) return _templates['Documento']!;
    if (clean.contains('proyect') || clean.contains('idea')) return _templates['Proyecto / Idea']!;
    if (clean.contains('recuerdo')) return _templates['Recuerdo']!;

    return _templates['Objeto / Herramienta']!;
  }

  static bool isContainer(String typeName) {
    return getTemplate(typeName).isContainer;
  }

  static bool isPlace(String typeName) {
    return getTemplate(typeName).isPlace;
  }

  static bool hasQuantity(String typeName) {
    return getTemplate(typeName).hasQuantity;
  }

  static bool canBeInContainer(String typeName) {
    return getTemplate(typeName).canBeInContainer;
  }
}
