import 'package:flutter/material.dart';

/// Helper visual que asigna íconos, etiquetas y colores según el tipo semántico (`kind`) de la entidad.
class EntityKindHelper {
  static IconData getIcon(String kind, {bool isContainer = false}) {
    if (isContainer && kind != 'space') return Icons.inventory_2_rounded;

    switch (kind.toLowerCase()) {
      case 'space':
        return Icons.roofing_rounded;
      case 'container':
        return Icons.inventory_2_rounded;
      case 'document':
        return Icons.description_rounded;
      case 'resource':
        return Icons.local_florist_rounded;
      case 'object':
      default:
        return Icons.build_rounded;
    }
  }

  static String getLabel(String kind) {
    switch (kind.toLowerCase()) {
      case 'space':
        return 'Espacio';
      case 'container':
        return 'Contenedor';
      case 'document':
        return 'Documento';
      case 'resource':
        return 'Recurso';
      case 'object':
      default:
        return 'Objeto';
    }
  }

  static Color getColor(String kind, ThemeData theme) {
    switch (kind.toLowerCase()) {
      case 'space':
        return theme.colorScheme.tertiary;
      case 'container':
        return theme.colorScheme.primary;
      case 'document':
        return const Color( // Naranja cálido
          0xFFD97706,
        );
      case 'resource':
        return const Color( // Verde Esmeralda
          0xFF059669,
        );
      case 'object':
      default:
        return theme.colorScheme.secondary;
    }
  }

  static Color getContainerColor(String kind, ThemeData theme) {
    switch (kind.toLowerCase()) {
      case 'space':
        return theme.colorScheme.tertiaryContainer;
      case 'container':
        return theme.colorScheme.primaryContainer;
      case 'document':
        return const Color(0xFFFEF3C7);
      case 'resource':
        return const Color(0xFFD1FAE5);
      case 'object':
      default:
        return theme.colorScheme.secondaryContainer;
    }
  }
}
