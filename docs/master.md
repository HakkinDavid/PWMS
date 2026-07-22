# PWMS — Platinum World Management System

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

- objetos físicos
- herramientas
- consumibles
- documentos
- infraestructura digital
- vehículos
- animales
- proyectos
- recuerdos
- ideas
- sueños
- lugares
- personas relevantes

Internamente todos son entidades.

La interfaz jamás debe exponer este detalle.

El usuario nunca debe sentir que administra registros.

Debe sentir que administra su mundo.

---

# 2. Objetivos del MVP

El MVP NO intenta resolver todos los casos de uso imaginables.

El objetivo del MVP es demostrar que el modelo funciona.

Al terminar esta iteración el usuario debe poder:

• crear entidades

• encontrarlas rápidamente

• moverlas

• relacionarlas

• adjuntar fotografías

• registrar eventos automáticamente

• organizar su mundo mediante lugares

Todo lo demás queda fuera del alcance.

---

# 3. Filosofía

Toda decisión debe respetar estos principios.

## Offline First

La aplicación funciona completamente sin Internet.

Internet únicamente sirve para enriquecer información.

Nunca es requisito para utilizar el sistema.

---

## Local First

Toda la información pertenece al usuario.

No existe dependencia de servicios externos.

SQLite es la fuente de verdad.

---

## Fricción mínima

Registrar una entidad nueva debe tomar menos tiempo que recordar hacerlo después.

Si una funcionalidad aumenta significativamente el tiempo de captura, probablemente está mal diseñada.

---

## Progresive Information

Registrar una entidad no requiere completar toda su información.

Debe poder crearse únicamente con:

- nombre

o

- fotografía

o

- código de barras

Toda la información restante puede añadirse posteriormente.

---

## El sistema trabaja para el usuario

Nunca al revés.

El usuario realiza acciones.

El sistema registra automáticamente el historial.

---

# 4. Tecnologías

Flutter

Material 3

Riverpod

Go Router

Drift (SQLite)

Freezed

JSON Serializable

Arquitectura limpia

Repositorio local de archivos

No utilizar Firebase.

No utilizar bases de datos remotas.

No utilizar servicios cloud.

---

# 5. Modelo conceptual

Internamente todo es una entidad.

Una entidad puede representar cualquier cosa.

Ejemplos:

Linterna

Caja

Habitación

Servidor

Dominio DNS

Gallina

Sueño

Proyecto

Documento

Fotografía

Idea

Las entidades pueden relacionarse entre sí.

Las entidades pueden contener otras entidades.

Las entidades pueden poseer archivos.

Las entidades pueden poseer fotografías.

Las entidades pueden registrar eventos.

---

# 6. Lo que el usuario percibe

El usuario nunca ve:

Entidad

Contenedor

CRUD

Repositorio

Modelo

UUID

Colección

Tabla

El usuario únicamente ve conceptos del mundo real.

Lugar

Caja

Herramienta

Documento

Animal

Proyecto

Idea

Recuerdo

---

# 7. MVP

El MVP contiene únicamente los siguientes módulos.

## Home

Pantalla inicial.

Incluye:

barra de búsqueda

acciones rápidas

entidades recientes

actividad reciente

colecciones

---

## Entidades

Crear

Editar

Eliminar

Fotografía principal

Archivos adjuntos

Notas

Etiquetas

Relaciones

---

## Lugares

Crear lugares.

Mover entidades entre lugares.

Visualizar ubicación actual.

---

## Relaciones

Relacionar entidades.

Ejemplos.

Esta batería pertenece a esta linterna.

Este documento pertenece a este proyecto.

Esta fotografía pertenece a este viaje.

---

## Historial

Registrar automáticamente:

creación

edición

movimiento

adjuntos

relaciones

No existe captura manual de eventos.

---

## Búsqueda

Debe buscar por:

nombre

alias

etiquetas

notas

ubicación

tipo

Debe responder en tiempo real.

---

## Fotografías

Captura desde cámara.

Selección desde galería.

Miniaturas.

Archivo original almacenado fuera de SQLite.

---

# 8. Fuera del MVP

NO implementar.

Sincronización.

Usuarios múltiples.

Automatizaciones.

Plugins.

IA local.

OCR.

Reconocimiento visual.

Recordatorios.

Calendario.

Notificaciones.

Escaneo NFC.

Versionado.

Enriquecimiento por Internet.

Dashboard complejo.

Widgets.

Exportaciones avanzadas.

Todo esto pertenece a versiones futuras.

---

# 9. Restricciones

NO construir un explorador de archivos.

NO construir un CRUD administrativo.

NO utilizar tablas como interfaz principal.

NO utilizar listas infinitas como navegación principal.

NO crear formularios largos.

NO asumir que todos los objetos son contenedores.

NO obligar al usuario a completar información innecesaria.

---

# 10. Flujo principal

Escenario:

Registrar una nueva herramienta.

Usuario abre la aplicación.

Presiona "+".

Selecciona fotografía.

Escribe nombre.

Selecciona ubicación.

Guardar.

Tiempo esperado:

menos de 30 segundos.

---

Escenario:

Encontrar una herramienta.

Abrir aplicación.

Escribir "multímetro".

Seleccionar resultado.

Ver ubicación.

Tiempo esperado:

menos de 5 segundos.

---

Escenario:

Mover una herramienta.

Abrir herramienta.

Presionar "Mover".

Elegir nuevo lugar.

Guardar.

El historial se registra automáticamente.

---

# 11. Criterios de éxito

El MVP será aceptado únicamente si:

✓ Registrar una entidad requiere menos de 30 segundos.

✓ Encontrar cualquier entidad requiere menos de 5 segundos.

✓ Cambiar una entidad de lugar requiere menos de 10 segundos.

✓ Toda modificación importante genera historial automáticamente.

✓ La aplicación funciona completamente sin Internet.

✓ La aplicación nunca se percibe como un CRUD administrativo.

Si alguno de estos puntos falla, el MVP debe considerarse incompleto.

---

# 12. Instrucciones para el agente

El agente NO debe inventar funcionalidades.

El agente NO debe modificar la experiencia de usuario descrita.

El agente debe priorizar simplicidad sobre cantidad de funcionalidades.

Si una decisión de implementación requiere interpretar la intención del producto, debe detenerse y solicitar una aclaración en lugar de asumir un comportamiento.

El objetivo de esta iteración NO es construir un producto terminado.

El objetivo es construir una base sólida, agradable de utilizar y fácil de extender en versiones posteriores.