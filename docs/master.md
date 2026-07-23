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
- consumibles y magnitudes físicas relacionales 4NF
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

- crear especies y gestionar sus subespecies/marcas
- instanciar elementos en el mundo
- encontrarlos rápidamente mediante búsqueda en tiempo real
- moverlos entre nodos del grafo de ubicaciones
- relacionarlos mediante vínculos dirigidos (`PARTE_DE`, `DOCUMENTA`, `PERTENECE_A`, `USA`, `GUARDADO_EN`)
- establecer requisitos de dependencia (`NECESITA`)
- adjuntar fotografías y documentos
- registrar eventos de auditoría automáticamente
- organizar su mundo mediante el grafo espacial jerárquico

Todo lo demás queda fuera del alcance.

---

# 3. Filosofía del Sistema

Toda decisión debe respetar estos principios.

## Offline First
La aplicación funciona completamente sin Internet.
Internet únicamente sirve para enriquecer información.
Nunca es requisito para utilizar el sistema.

## Local First
Toda la información pertenece al usuario.
No existe dependencia de servicios externos.
SQLite (`AppDatabase` Drift) es la fuente de verdad.

## Fricción mínima
Registrar una entidad nueva toma menos de 30 segundos.
Información progresiva con foto, nombre o código de barras sin formularios infinitos.

## El sistema trabaja para el usuario
El usuario realiza acciones.
El sistema registra automáticamente el historial en `HistoryEventsTable`.

---

# 4. Arquitectura y Tecnologías

- **Flutter** & Material 3 (Modo Oscuro)
- **Riverpod** para inyección de dependencias y estado reactivo
- **GoRouter** (`StatefulShellRoute.indexedStack`)
- **Drift (SQLite)** con 12 tablas en Cuarta Forma Normal (4NF)
- **Freezed** & JSON Serializable para modelos inmutables de dominio
- **AppToast** para notificaciones flotantes de estado
- **FileStorageService** para gestión local de medios en disco

---

# 5. Estructura de Subgrupos y Restricciones

| Subgrupo | Marca y Código de Barras | Magnitudes Multiunidad | Siempre Único |
| :--- | :---: | :---: | :---: |
| **Objeto** | ✅ Sí | ✅ Sí | Opcional |
| **Ser Vivo** | ❌ Descartado automáticamente | ✅ Sí | Opcional |
| **Documento** | ❌ Descartado automáticamente | ❌ No | ✅ Siempre Único |
| **Proyecto** | ❌ Descartado automáticamente | ❌ No | ✅ Siempre Único |
| **Recuerdo** | ❌ Descartado automáticamente | ❌ No | ✅ Siempre Único |

---

# 6. Jerarquía de Subespecies e Inversión Visual

- Cada especie del catálogo posee 1 o más subespecies. Si no se agregan subespecies al crear la especie, se genera automáticamente una subespecie `"Genérica"`.
- Las pantallas de detalle y tiles destacan el nombre de la subespecie como título principal (`Bravia 4K 55`), y presentan la especie como contexto secundario (`Especie: Televisor (Objeto)`).

---

# 7. Criterios de Éxito Cumplidos

✓ Registrar una entidad requiere menos de 30 segundos.
✓ Encontrar cualquier entidad requiere menos de 5 segundos.
✓ Cambiar una entidad de lugar requiere menos de 10 segundos.
✓ Toda modificación genera historial automáticamente.
✓ Protección de eliminación activa de especies y subespecies con instancias registradas.
✓ Funciona 100% sin conexión a Internet.