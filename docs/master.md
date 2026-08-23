# PWMS — Platinum World Management System (Master Specification)

Version: MVP 1.0

---

# 1. Objetivo

PWMS es una aplicación personal, offline-first y autocontenida cuyo propósito es convertirse en el gemelo digital del mundo del usuario.

No es un inventario.

No es un gestor documental.

No es un ERP.

No es una base de conocimiento tradicional.

Es un sistema unificado para registrar, consultar y relacionar cualquier elemento relevante de la vida del usuario.

Ejemplos:

- objetos físicos y herramientas
- marcas y variantes comerciales (subespecies)
- consumibles, perecederos y magnitudes físicas relacionales 4NF
- documentos y proyectos únicos
- infraestructura digital y vehículos
- seres vivos y plantas
- recuerdos, ideas y sueños
- lugares e infraestructuras espaciales

Internamente todos son entidades.

La interfaz jamás debe exponer este detalle.

El usuario nunca debe sentir que administra registros.

Debe sentir que administra su mundo.

---

# 2. Objetivos del MVP

El MVP NO intenta resolver todos los casos de uso imaginables.

El objetivo del MVP es demostrar que el modelo relacional normalizado funciona.

Al terminar esta iteración el usuario puede:

- crear especies y gestionar sus subespecies/marcas con auto-completado taxonómico
- instanciar elementos en el mundo con seguimiento opcional de caducidad
- encontrarlos rápidamente mediante el buscador unificado `InventoryFinderScreen` y búsqueda en tiempo real
- moverlos entre nodos del grafo de ubicaciones mediante cortina desplegable `TopCurtainLocationSheet`
- relacionarlos mediante vínculos dirigidos (`PARTE_DE`, `DOCUMENTA`, `PERTENECE_A`, `USA`, `GUARDADO_EN`)
- establecer requisitos de dependencia (`NECESITA`) con alertas automáticas de falta de insumos
- adjuntar fotografías y documentos
- recibir alertas de notificaciones del sistema (`NotificationsTable`) para productos caducados o por vencer
- exportar e importar respaldos completos de la base de datos de manera segura (`DatabaseBackupService`)
- registrar eventos de auditoría automáticamente
- organizar su mundo mediante el grafo espacial jerárquico

Todo lo demás queda fuera del alcance.

---

# 3. Filosofía del Sistema

Toda decisión debe respetar estos principios.

## Offline First
La aplicación funciona completamente sin Internet.
Internet únicamente sirve para enriquecer información o buscar imágenes públicas.
Nunca es requisito para utilizar el sistema.

## Local First
Toda la información pertenece al usuario.
No existe dependencia de servicios externos.
SQLite (`AppDatabase` Drift) es la fuente de verdad.

## Fricción mínima
Registrar una entidad nueva toma menos de 30 segundos.
Información progresiva con foto, auto-completado por escaneo de código de barras o taxonomía inteligente sin formularios infinitos.

## El sistema trabaja para el usuario
El usuario realiza acciones.
El sistema registra automáticamente el historial en `HistoryEventsTable` y notificaciones reactivas en `NotificationsTable`.

---

# 4. Arquitectura y Tecnologías

- **Flutter** & Material 3 (Modo Oscuro)
- **Riverpod** para inyección de dependencias y estado reactivo
- **GoRouter** (`StatefulShellRoute.indexedStack` en 3 pestañas principales)
- **Drift (SQLite)** con 13 tablas en Cuarta Forma Normal (4NF)
- **Freezed** & JSON Serializable para modelos inmutables de dominio
- **AppToast** y **NotificationsScreen** para notificaciones flotantes y reactivas del sistema
- **DatabaseBackupService** para exportación e importación segura de datos en JSON
- **FileStorageService** para gestión local de medios en disco

---

# 5. Estructura de Subgrupos y Restricciones

| Subgrupo | Marca y Código de Barras | Magnitudes Multiunidad | Perecedero | Siempre Único |
| :--- | :---: | :---: | :---: | :---: |
| **Objeto** | ✅ Sí | ✅ Sí | ✅ Sí (Opcional) | Opcional |
| **Ser Vivo** | ❌ Descartado automáticamente | ✅ Sí | ✅ Sí (Opcional) | Opcional |
| **Documento** | ✅ Sí | ❌ No | ❌ No perecedero | ✅ Siempre Único |
| **Proyecto** | ❌ Descartado automáticamente | ❌ No | ❌ No perecedero | ✅ Siempre Único |
| **Recuerdo** | ❌ Descartado automáticamente | ❌ No | ❌ No perecedero | ✅ Siempre Único |

---

# 6. Jerarquía de Subespecies e Inversión Visual

- Cada especie del catálogo posee 1 o más subespecies. Si no se agregan subespecies al crear la especie, el formulario muestra un diálogo de confirmación para crear la subespecie `"Genérica"` dentro del payload de guardado.
- Las pantallas de detalle y tiles destacan el nombre de la subespecie como título principal (`Bravia 4K 55`), y presentan la especie como contexto secundario (`Especie: Televisor (Objeto)`).

---

# 7. Criterios de Éxito Cumplidos

✓ Registrar una entidad requiere menos de 30 segundos (acelerado con auto-llenado por código de barras).
✓ Encontrar cualquier entidad requiere menos de 5 segundos.
✓ Cambiar una entidad de lugar requiere menos de 10 segundos.
✓ Toda modificación genera historial automáticamente.
✓ Alertas de expiración y faltante de requisitos notificadas de forma persistente.
✓ Respaldo y restauración de la base de datos realizable localmente en un toque.
✓ Protección de eliminación activa de especies y subespecies con instancias registradas.
✓ Funciona 100% sin conexión a Internet.