# Roadmap de Producto: Épicas, Historias de Usuario y JTBD

## Platinum World Management System (PWMS)

---

## 🎯 Metodología de Planificación

El desarrollo de PWMS se planifica mediante **Jobs to Be Done (JTBD)**. Cada incremento de desarrollo resuelve un problema real del usuario entregando una experiencia completa de extremo a extremo con criterios de aceptación demostrables.

---

## 🗺️ Roadmap de Épicas

```
┌───────────────────────────────────────────────────────────────────┐
│ ÉPICA 1: CONOCER MI MUNDO (En Progreso - Incrementos 1 y 2)      │
│  - Captura Rápida de Entidades (<30s)             [COMPLETADA]   │
│  - JTBD: Encontrar cualquier objeto en <10s        [COMPLETADA]   │
│  - Pantalla de Inicio "Mi Mundo"                  [COMPLETADA]   │
│  - Explorador y Miga de Pan                       [COMPLETADA]   │
│  - Acción Mover Entidad entre Contenedores        [COMPLETADA]   │
└───────────────────────────────────────────────────────────────────┘
                                  │
                                  ▼
┌───────────────────────────────────────────────────────────────────┐
│ ÉPICA 2: ENRIQUECER MI MUNDO (Siguiente Fase)                      │
│  - Fotografiar y adjuntar archivos multimedias                    │
│  - Plantillas de atributos y unidades de medida                   │
│  - Relaciones libres entre entidades (ej. "prestado a", "usa")     │
└───────────────────────────────────────────────────────────────────┘
                                  │
                                  ▼
┌───────────────────────────────────────────────────────────────────┐
│ ÉPICA 3: MANTENER Y ACCIONAR EL MUNDO                             │
│  - Consumir inventario y reabastecimiento                         │
│  - Mantenimientos y alertas de vencimiento                        │
└───────────────────────────────────────────────────────────────────┘
```

---

## 📖 Épica 1: Conocer mi mundo

### Job to Be Done Principal
> **"Cuando necesito un objeto o documento de mi vida cotidiana, quiero localizar su ubicación exacta en menos de 10 segundos desde mi teléfono, para dejar de depender de mi memoria y evitar perder tiempo buscando a ciegas."**

---

### Historias de Usuario y Criterios de Aceptación

#### 📖 Historia 1.1: Captura Rápida de Entidades
**Como** usuario  
**Quiero** registrar cualquier entidad de mi mundo en menos de 30 segundos  
**Para** incorporar rápidamente elementos a mi sistema sin fricción.

**Criterios de Aceptación**:
- [x] El modal de captura rápida se despliega con 1 toque desde cualquier pantalla.
- [x] Solo requiere el nombre o concepto para guardar.
- [x] El registro se completa en menos de 30 segundos.
- [x] Funciona 100% offline y persiste en SQLite local.

---

#### 📖 Historia 1.2: Pantalla de Inicio "Mi Mundo"
**Como** usuario  
**Quiero** ingresar a una pantalla principal que organice "Mi Mundo"  
**Para** tener accesos rápidos a búsquedas, acciones frecuentes, entidades recientes y navegación.

**Criterios de Aceptación**:
- [x] Al abrir la app, la vista inicial es la pantalla "Mi Mundo".
- [x] Barra de búsqueda global destacada en la parte superior.
- [x] Botones de acción rápida ("Registrar Entidad", "Explorar Mundo").
- [x] Listado de "Entidades Recientes" con badges de ubicación.

---

#### 📖 Historia 1.3: Localizador Inmediato de Ubicación mediante Búsqueda Global
**Como** usuario  
**Quiero** escribir el nombre de cualquier entidad en la búsqueda global y ver su ubicación exacta de forma instantánea  
**Para** saber exactamente dónde se encuentra físicamente en menos de 10 segundos.

**Criterios de Aceptación**:
- [x] La búsqueda responde de forma percibida como instantánea al escribir.
- [x] Cada resultado despliega la ruta completa de ubicación (ej. `📍 Casa > Garaje > Caja A1`).
- [x] Seleccionar el resultado permite abrir la **Entidad** o navegar al contenedor.

---

#### 📖 Historia 1.4: Explorador de Jerarquía y Contención
**Como** usuario  
**Quiero** navegar por los contenedores y espacios de mi mundo  
**Para** explorar naturalmente lo que hay dentro de cada lugar o caja.

**Criterios de Aceptación**:
- [x] Muestra contenedores con distintivo de cantidad de elementos interiores (ej. `📁 Caja A1 (8 elementos)`).
- [x] Barra dinámica de miga de pan (Breadcrumbs) que permite saltar a cualquier nivel superior con un toque.
- [x] Entrar a un contenedor despliega su contenido interior.

---

#### 📖 Historia 1.5: Acción Mover Entidades entre Contenedores
**Como** usuario  
**Quiero** reubicar cualquier entidad mediante la acción "Mover a..."  
**Para** mantener el estado digital de mi mundo sincronizado con mis movimientos físicos reales.

**Criterios de Aceptación**:
- [x] Opción de acción "Mover a..." con selector interactivo del árbol de contenedores.
- [x] Cambio de ubicación inmediato en 2 toques.
- [x] Validación contra ciclos (previene mover un contenedor dentro de sí mismo).
- [x] Registro silencioso de la operación auditable (`entity_moved`) en SQLite.
