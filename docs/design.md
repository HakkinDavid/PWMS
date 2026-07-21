# Platinum World Management System (PWMS) — Documento de Diseño

## 👁️ Visión y Filosofía

El **Platinum World Management System (PWMS)** es una plataforma integral de gestión del mundo personal (físico y digital).

Su objetivo **no** es ser un inventario genérico, un ERP ni un gestor de notas. Su propósito es construir una representación digital coherente, auditable y evolutiva del entorno del usuario, reduciendo a cero la carga cognitiva de recordar la ubicación, estado o contexto de cualquier elemento.

---

## 💡 Principios de Diseño

1. **El Sistema Trabaja para el Usuario**: Toda funcionalidad debe responder a la pregunta: *¿Esto reduce o aumenta la carga cognitiva del usuario?* Si la aumenta, se descarta.
2. **Offline & Local First**: La base de datos SQLite y los archivos administrados residen en el dispositivo del usuario bajo su control absoluto.
3. **Entity First**: No existen clases rígidas. Todo elemento (herramienta, vehículo, animal, persona, habitación, pasaporte, recuerdo, proyecto) es una `Entity` universal.
4. **Interacción Basada en Acciones (No CRUD)**: El usuario interactúa mediante verbos cotidianos: **Abrir, Mover, Contener, Buscar, Explorar**.
5. **Captura Ultra-Rápida (< 30 Segundos)**: Incorporar un objeto al sistema debe requerir información mínima inicial y cero fricción.
6. **Metodología Guiada por JTBD (Job to Be Done)**: Los incrementos de software no se miden en abstracciones técnicas, sino en experiencias completas entregadas que aportan utilidad cotidiana inmediata.

---

## 🎨 Arquitectura de la Interfaz y Experiencia (UX)

### 1. Pantalla Principal: "Mi Mundo" (`HomeScreen`)
Es el punto de entrada principal del usuario al abrir la aplicación:
* **Búsqueda Global Destacada**: Permite iniciar la búsqueda inmediatamente.
* **Acciones Rápida**: Acceso directo al modal de captura rápida (<30s) y al Explorador del Mundo.
* **Entidades Recientes**: Listado ordenado por actividad reciente mostrando badges de ubicación física explícita.

### 2. Explorador del Mundo (`WorldExplorerScreen`)
* **Miga de Pan de Ubicación (Breadcrumbs Bar)**: Visualización dinámica de la jerarquía (ej. `Mundo > Casa > Garaje > Caja A1`) permitiendo saltos hacia arriba con un toque.
* **Canvas de Entidades**: Representación visual de contenedores con sus conteos de elementos interiores.

### 3. Vista Principal "Entidad" (`EntityDetailScreen`)
* Muestra los atributos de la entidad, un distintivo interactivo de ubicación física e historial de elementos contenidos.

---

## 🛠️ Modelo Conceptual

* **`Entity`**: Identificador inmutable permanente `EntityId`, referencia opcional a `TemplateId`, referencia a contenedor `parentId` y mapa de atributos dinámicos `AttributeKey` ➔ `AttributeValue`.
* **`DomainEvent`**: Eventos inmutables de auditoría registrados de forma transparente en SQLite.