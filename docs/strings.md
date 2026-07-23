# Centralización de Cadenas de Texto y Política de Interfaz de Usuario (PWMS)

Este documento establece la arquitectura, estándares normativos y registro del trabajo realizado para la centralización completa de todas las cadenas de texto del proyecto **PWMS (Platinum World Management System)**.

---

## 1. Arquitectura de Centralización

### Única Fuente de Verdad (`Single Source of Truth`)
Todas las cadenas de texto legibles para el usuario final (títulos, mensajes de error, etiquetas de formulario, sugerencias, notificaciones, opciones de menú, categorías y descripciones) se encuentran estrictamente centralizadas en:

```
lib/src/core/constants/app_strings.dart
```

### Regla Fundamental de Implementación
Está **estrictamente prohibido** incrustar cadenas de texto literales (*hardcoded strings*) dentro de componentes visuales (`Widget`), hojas desplegables (`ModalBottomSheet`), cuadros de diálogo (`AlertDialog`), delegados de búsqueda o clases de infraestructura (`Repository`). Toda referencia textual debe realizarse mediante constantes estáticas de `AppStrings`.

*Identificadores técnicos, esquemas SQL de Drift, rutas de GoRouter, tipos de relación de base de datos (`GUARDADO_EN`, `PERTENECE_A`, etc.) y rutas de archivos son la única excepción y permanecen definidos en sus respectivas capas.*

---

## 2. Reglas Normativas para las Cadenas de Texto

### 2.1. Puntuación y Capitalización Uniforme
1. **Mensajes, Descripciones y Prompts**: Toda frase completa, notificación de error o instrucción en cuadros de diálogo debe comenzar con mayúscula y finalizar obligatoriamente con un punto (`.`).
   - *Correcto*: `"Esta ubicación no contiene objetos ni sububicaciones."`
   - *Incorrecto*: `"Esta ubicación no contiene objetos ni sububicaciones"`
2. **Etiquetas, Botones y Títulos**: Los títulos de sección, etiquetas de campos de texto, nombres de pestañas y botones de acción utilizan mayúscula inicial sin punto final.
   - *Correcto*: `"Guardar cambios"`, `"Código de barras"`, `"Especie única"`
   - *Incorrecto*: `"Guardar cambios."`, `"código de barras"`

### 2.2. Español Profesional y Eliminación de Anglicismos
Todas las cadenas del sistema se expresan en un español técnico, profesional y depurado. Se prohíbe el uso de anglicismos no adaptados:

| Anglicismo no permitido | Término estandarizado en PWMS |
| :--- | :--- |
| *Barcode* | **Código de barras** |
| *WheelPicker* | **Rueda de selección** |
| *Draft* | **Borrador** |
| *Group* | **Grupo** |
| *Feedback* | **Comentarios** |
| *Helper* | **Asistente** |
| *Header / Badge* | **Encabezado / Distintivo** |

### 2.3. Estandarización Terminológica
Para garantizar coherencia semántica en toda la aplicación, los siguientes términos están normados de manera institucional:

- **Especie**: Definición o plantilla maestra del catálogo.
- **Subespecie**: Variante o marca comercial derivada de una especie.
- **Instancia**: Objeto o elemento físico/abstracto registrado en el mundo.
- **Ubicación**: Nodo jerárquico del grafo espacial.
- **Grafo**: Red visual e interactiva de ubicaciones y relaciones.
- **Requisito**: Relación de dependencia o necesidad (`NECESITA`).
- **Relación / Vínculo**: Conexión semántica dirigida entre dos instancias.
- **Demografía mayoritaria**: Grupo de instancias que comparten características idénticas dentro de un conjunto.

### 2.4. Prohibición de Símbolos Embebidos en Cadenas
Está **estrictamente prohibido** incrustar caracteres de formateo visual, viñetas o símbolos decorativos (`+`, `-`, `#`, `➔`, `•`, etc.) directamente dentro de las constantes de texto. 

- **Justificación**: Las señales visuales y decorativas son responsabilidad exclusiva de los componentes visuales de Flutter (`Icon`, `Chip`, `ListTile`, etc.).
- **Ejemplos de corrección**:
  - *Antes*: `'+ Subespecie'` $\rightarrow$ *Ahora*: `'Crear subespecie'`
  - *Antes*: `'Estantería #3'` $\rightarrow$ *Ahora*: `'Estantería 3'`
  - *Antes*: `'(Origen ➔ Destino)'` $\rightarrow$ *Ahora*: `'de origen a destino'`
  - *Antes*: `'• Toque corto en -/+'` $\rightarrow$ *Ahora*: `'El toque corto en los botones de ajuste resta o suma una unidad.'`

---

## 3. Resumen del Trabajo Realizado

### Archivos Refactorizados (46 archivos bajo `lib/`)
Se realizó la auditoría, extracción y refactorización completa en las siguientes áreas:

1. **Capa Core**: [lib/main.dart](file:///Users/hakkindavid/Documents/GitHub/PlatinumWorldManagementSystem/lib/main.dart), [app_strings.dart](file:///Users/hakkindavid/Documents/GitHub/PlatinumWorldManagementSystem/lib/src/core/constants/app_strings.dart), `app_wheel_picker.dart`, `integer_wheel_picker.dart`.
2. **Módulo de Catálogo**: `catalog_repository.dart`, `catalog_screen.dart`, `requirements_section_widget.dart`, `species_detail_screen.dart`, `species_detail_view.dart`, `species_form_modal.dart`, `species_tile.dart`, `subspecies_section_widget.dart`.
3. **Módulo de Entidades e Instancias**: `entity_repository.dart`, `entity_template.dart`, `container_contents_view.dart`, `custom_attribute_editor_dialog.dart`, `custom_template_editor_sheet.dart`, `edit_entity_sheet.dart`, `effective_group_tile.dart`, `entities_tab.dart`, `entity_detail_screen.dart`, `entity_tile.dart`, `grouped_instance_detail_sheet.dart`, `instance_preview_card.dart`, `instantiate_species_sheet.dart`, `photo_viewer_dialog.dart`, `quantity_operation_helper.dart`, `register_object_modal.dart`.
4. **Módulo de Ubicaciones y Lugares**: `location_repository.dart`, `location_tree_picker.dart`, `locations_graph_screen.dart`, `move_entity_sheet.dart`.
5. **Módulo de Relaciones y Grafo**: `create_relation_modal.dart`, `interactive_entity_graph_widget.dart`.
6. **Módulo de Búsqueda e Historial**: `search_screen.dart`, `history_tab.dart`, `home_screen.dart`.

### Verificación y Calidad de Código
- **Analizador Estático (`flutter analyze`)**: 0 errores y 0 advertencias.
- **Suite de Pruebas (`flutter test`)**: 100% de las pruebas unitarias y de widgets aprobadas.
