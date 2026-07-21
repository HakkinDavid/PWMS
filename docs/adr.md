# Architecture Decision Record (ADR-001)

## Platinum World Management System (PWMS)

### Estado
**Aceptado y Actualizado.**

Este documento establece las decisiones arquitectónicas fundamentales sobre las que se construye y evoluciona el Platinum World Management System (PWMS).

---

## 🎯 Objetivo Arquitectónico y Filosofía

Construir un sistema de gestión integral del mundo personal que sea:
* **Offline First & Local First**
* **Orientado a Reducir Carga Cognitiva** (Interacción impulsada por Acciones en lugar de formularios CRUD)
* **Desarrollo Guiado por JTBD (Job to Be Done)**: Cada incremento entrega una experiencia de extremo a extremo que el usuario valora cotidianamente.
* **Evolutivo por Décadas**: Dominio independiente de la tecnología y extensible sin recompilación.

---

## 🏛️ Decisiones Arquitectónicas

### Decisión 1: El Dominio es Puro e Independiente de la Tecnología
El modelo de dominio vive en Dart puro. No conoce ni depende de:
* Flutter (`import 'package:flutter/...'` está estrictamente prohibido en el dominio)
* SQLite / motores de base de datos
* Servicios HTTP / APIs de red

---

### Decisión 2: Estructura del Proyecto Feature-First con `core/` Compartido
En lugar de una división puramente horizontal global (`lib/domain/`, `lib/infrastructure/`), el código se organiza por funcionalidades independientes (*Feature-First*):
```
lib/
├── core/
│   ├── domain/        (Entidad universal, Eventos, Repositorios base, Value Objects)
│   └── infrastructure/ (Conexión SQLite multiplataforma)
└── features/
    ├── home/           (Pantalla de Inicio "Mi Mundo")
    └── entity_management/ (Dominio específico, Casos de uso, SQLite repositories, Screens)
```

---

### Decisión 3: Entidades Ultra-Universales (Sin Clases Rígidas)
No existen clases heredadas como `Tool`, `Animal`, `Vehicle` o `Document`.
Cualquier concepto del mundo personal es representado por un Agregado `Entity` inmutable que contiene:
* `EntityId id` (Identidad permanente inmutable UUID)
* `TemplateId? templateId` (Opcional)
* `EntityId? parentId` (Mecanismo de contención V1)
* `Map<AttributeKey, AttributeValue> attributes` (Atributos dinámicos tipados)

---

### Decisión 4: Ausencia de Enums Compilados (Tipos Basados en Datos)
Conceptos como tipos de relación (`RelationTypeId`) o tipos de acción/operación (`ActionTypeId`) no se representan con `enum` compilados de Dart. Se representan mediante Value Objects dinámicos configurables como datos en tiempo de ejecución.

---

### Decisión 5: Contención V1 como Decisión de Infraestructura
Se utiliza `parentId` como mecanismo de contención inicial por su simplicidad y eficiencia en SQLite. Esta es una decisión de implementación de V1 y **no** representa una restricción permanente del dominio (el resto del sistema no asume que la contención sea exclusivamente un árbol único rígido).

---

### Decisión 6: Persistencia SQLite Local-First
SQLite es el motor de persistencia principal para metadatos y eventos.
* Atributos dinámicos codificados como JSON en SQLite.
* Los repositorios desacoplan totalmente el dominio de los métodos de SQLite.
* En el entorno de pruebas unitarias, se utilizan repositorios en memoria (`InMemoryEntityRepository`).

---

### Decisión 7: Auditoría Silenciosa mediante Eventos de Dominio
Cada movimiento (`MoveEntityUseCase`) o registro (`RegisterEntityUseCase`) genera de forma silenciosa e ininterrumpida un `DomainEvent` guardado en la tabla `events` de SQLite para auditoría e historial futuro.

---

### Decisión 8: Calidad de Interfaz como Requisito Funcional
No se aceptan interfaces temporales ni provisionales. Cada incremento debe entregar pantallas pulidas con el sistema de diseño Esmeralda Platino (Material 3), soporte para tema oscuro/claro y micro-interacciones fluidas.