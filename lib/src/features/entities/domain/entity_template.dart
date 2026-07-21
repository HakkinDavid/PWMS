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
  final TemplateViewKind primaryView;
  final List<EntityActionType> allowedActions;
  final List<String> validRelationTypes;
  final List<String> commonUnits;

  const EntityTemplate({
    required this.typeName,
    required this.icon,
    this.hasQuantity = false,
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
    'Objeto / Herramienta': EntityTemplate(
      typeName: 'Objeto / Herramienta',
      icon: Icons.build,
      hasQuantity: true,
      primaryView: TemplateViewKind.details,
      allowedActions: EntityActionType.values,
      validRelationTypes: ['GUARDADO_EN', 'PERTENECE_A', 'PARTE_DE', 'USA', 'DOCUMENTA'],
      commonUnits: ['piezas', 'unidades', 'kg', 'litros', 'metros'],
    ),
    'Documento': EntityTemplate(
      typeName: 'Documento',
      icon: Icons.description,
      hasQuantity: false,
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
      hasQuantity: false,
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
    if (clean.contains('doc')) return _templates['Documento']!;
    if (clean.contains('proyect') || clean.contains('idea')) return _templates['Proyecto / Idea']!;
    if (clean.contains('recuerdo')) return _templates['Recuerdo']!;

    return _templates['Objeto / Herramienta']!;
  }

  static bool hasQuantity(String typeName) {
    return getTemplate(typeName).hasQuantity;
  }
}
