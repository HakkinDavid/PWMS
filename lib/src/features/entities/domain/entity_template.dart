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
  final TemplateViewKind primaryView;
  final List<EntityActionType> allowedActions;
  final List<String> validRelationTypes;
  final List<String> commonUnits;

  const EntityTemplate({
    required this.typeName,
    required this.icon,
    this.isContainer = false,
    this.isPlace = false,
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
      primaryView: TemplateViewKind.contents,
      allowedActions: [
        EntityActionType.move,
        EntityActionType.edit,
        EntityActionType.relate,
        EntityActionType.addPhoto,
        EntityActionType.addFile,
        EntityActionType.delete,
      ],
      validRelationTypes: ['GUARDADO_EN', 'PERTENECE_A', 'USA'],
    ),
    'Caja / Contenedor': EntityTemplate(
      typeName: 'Caja / Contenedor',
      icon: Icons.inventory_2,
      isContainer: true,
      primaryView: TemplateViewKind.contents,
      allowedActions: [
        EntityActionType.move,
        EntityActionType.consume,
        EntityActionType.edit,
        EntityActionType.relate,
        EntityActionType.addPhoto,
        EntityActionType.addFile,
        EntityActionType.delete,
      ],
      validRelationTypes: ['GUARDADO_EN', 'PERTENECE_A', 'USA', 'PARTE_DE'],
      commonUnits: ['piezas', 'unidades', 'cajas', 'kg'],
    ),
    'Herramienta': EntityTemplate(
      typeName: 'Herramienta',
      icon: Icons.build,
      primaryView: TemplateViewKind.details,
      allowedActions: [
        EntityActionType.move,
        EntityActionType.consume,
        EntityActionType.edit,
        EntityActionType.relate,
        EntityActionType.addPhoto,
        EntityActionType.addFile,
        EntityActionType.delete,
      ],
      validRelationTypes: ['GUARDADO_EN', 'PERTENECE_A', 'USA', 'DOCUMENTA'],
      commonUnits: ['piezas', 'juegos', 'unidades'],
    ),
    'Documento': EntityTemplate(
      typeName: 'Documento',
      icon: Icons.description,
      primaryView: TemplateViewKind.documents,
      allowedActions: [
        EntityActionType.move,
        EntityActionType.edit,
        EntityActionType.relate,
        EntityActionType.addFile,
        EntityActionType.delete,
      ],
      validRelationTypes: ['DOCUMENTA', 'PERTENECE_A', 'GUARDADO_EN'],
      commonUnits: ['folios', 'hojas', 'copias'],
    ),
    'Vehículo': EntityTemplate(
      typeName: 'Vehículo',
      icon: Icons.directions_car,
      isContainer: true,
      primaryView: TemplateViewKind.parts,
      allowedActions: [
        EntityActionType.move,
        EntityActionType.edit,
        EntityActionType.relate,
        EntityActionType.addPhoto,
        EntityActionType.addFile,
        EntityActionType.delete,
      ],
      validRelationTypes: ['PARTE_DE', 'PERTENECE_A', 'DOCUMENTA', 'USA'],
    ),
    'Animal': EntityTemplate(
      typeName: 'Animal',
      icon: Icons.pets,
      primaryView: TemplateViewKind.notesAndMedia,
      allowedActions: [
        EntityActionType.move,
        EntityActionType.edit,
        EntityActionType.relate,
        EntityActionType.addPhoto,
        EntityActionType.addFile,
        EntityActionType.delete,
      ],
      validRelationTypes: ['PERTENECE_A', 'DOCUMENTA'],
    ),
    'Proyecto': EntityTemplate(
      typeName: 'Proyecto',
      icon: Icons.work,
      primaryView: TemplateViewKind.documents,
      allowedActions: [
        EntityActionType.edit,
        EntityActionType.relate,
        EntityActionType.addPhoto,
        EntityActionType.addFile,
        EntityActionType.delete,
      ],
      validRelationTypes: ['PARTE_DE', 'DOCUMENTA', 'USA'],
    ),
    'Idea': EntityTemplate(
      typeName: 'Idea',
      icon: Icons.lightbulb,
      primaryView: TemplateViewKind.notesAndMedia,
      allowedActions: [
        EntityActionType.edit,
        EntityActionType.relate,
        EntityActionType.addPhoto,
        EntityActionType.addFile,
        EntityActionType.delete,
      ],
      validRelationTypes: ['PARTE_DE', 'DOCUMENTA'],
    ),
    'Recuerdo': EntityTemplate(
      typeName: 'Recuerdo',
      icon: Icons.star,
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
    return _templates[typeName] ??
        EntityTemplate(
          typeName: typeName,
          icon: Icons.category,
          primaryView: TemplateViewKind.details,
          allowedActions: EntityActionType.values,
          validRelationTypes: directedRelationTypes,
        );
  }

  static bool isContainer(String typeName) {
    return getTemplate(typeName).isContainer || typeName.toLowerCase().contains('caja') || typeName.toLowerCase().contains('contenedor');
  }

  static bool isPlace(String typeName) {
    return getTemplate(typeName).isPlace || typeName.toLowerCase().contains('lugar');
  }
}
