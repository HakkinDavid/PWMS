# PWMS — Platinum World Management System Documentation

Welcome to the comprehensive documentation suite for **Platinum World Management System (PWMS)**. PWMS is a personal, offline-first digital twin application built with Flutter, Riverpod, GoRouter, and Drift (SQLite).

---

## Documentation Index & Sitemap

Below is the complete sitemap of the technical documentation for PWMS located in the `docs/` directory:

| Document | Topic & Focus |
| :--- | :--- |
| 📘 [master.md](file:///Users/hakkindavid/Documents/GitHub/PlatinumWorldManagementSystem/docs/master.md) | **Product Vision & MVP Philosophy**: High-level specification, offline-first philosophy, user perception, and core design principles. |
| 🏗️ [architecture.md](file:///Users/hakkindavid/Documents/GitHub/PlatinumWorldManagementSystem/docs/architecture.md) | **System Architecture**: Clean Architecture, state management (Riverpod), routing (GoRouter), database persistence (Drift), notification layer (`AppToast`), and file storage. |
| 🗄️ [data_model.md](file:///Users/hakkindavid/Documents/GitHub/PlatinumWorldManagementSystem/docs/data_model.md) | **4NF Database Schema & Domain Models**: Normalized database tables (12 Drift tables), relational foreign keys, Freezed domain entities, and data mappings. |
| 🏷️ [subspecies_and_brands.md](file:///Users/hakkindavid/Documents/GitHub/PlatinumWorldManagementSystem/docs/subspecies_and_brands.md) | **Subspecies & Brand Variants**: Hierarchical subspecies system, brand/barcode constraints, photo fallback resolution, and UI visual hierarchy inversion. |
| 📏 [domain_rules.md](file:///Users/hakkindavid/Documents/GitHub/PlatinumWorldManagementSystem/docs/domain_rules.md) | **Domain Rules & Single Source of Truth**: Single source of truth (`DomainRules`), strict unit validations, active instance deletion protections, integer formatting, and entity subgroup rules. |
| 🌳 [location_graph.md](file:///Users/hakkindavid/Documents/GitHub/PlatinumWorldManagementSystem/docs/location_graph.md) | **Location Graph & Spatial Hierarchy**: Global graph structure, recursive item counting, anti-cycling rules, container indicator `@`, and breadcrumb path generation. |
| 🔀 [directed_relations.md](file:///Users/hakkindavid/Documents/GitHub/PlatinumWorldManagementSystem/docs/directed_relations.md) | **Directed Entity Relations & Requirements**: Directed relationships (`DOCUMENTA`, `PARTE_DE`, `PERTENECE_A`, `USA`, `GUARDADO_EN`), interactive vertical graph, catalog requirements (`NECESITA`), and edit-scoped modal. |
| ⚖️ [magnitudes_and_units.md](file:///Users/hakkindavid/Documents/GitHub/PlatinumWorldManagementSystem/docs/magnitudes_and_units.md) | **Physical Magnitudes & Multi-Unit System**: 4NF multi-unit magnitude properties, complete SI unit catalog, SI property name prepopulation suggestions, dynamic controls, and wheel pickers. |
| 🎨 [navigation_and_ui.md](file:///Users/hakkindavid/Documents/GitHub/PlatinumWorldManagementSystem/docs/navigation_and_ui.md) | **UI & Navigation Architecture**: `MainShellScreen`, persistent tab builder, modal sheet workflows (`RegisterObjectModal`, `SpeciesFormModal`), `AppToast` notification system, PNG alpha transparency, and `BoxFit.contain` photo preview. |
| 🔤 [strings.md](file:///Users/hakkindavid/Documents/GitHub/PlatinumWorldManagementSystem/docs/strings.md) | **Centralization of Application Strings**: Single source of truth (`AppStrings`), Spanish technical terminology, and prohibition of hardcoded string literals or embedded symbols. |

---

## Core System Architecture Overview

```mermaid
graph TD
    User["User Interface (UI Layer)"] --> Shell["MainShellScreen (GoRouter IndexedStack)"]
    Shell --> Tabs["Bottom Navigation Tabs (Home, Entities, Locations, Catalog)"]
    Shell --> FloatingSearch["Floating Search Button & Screen (/search)"]
    
    Tabs --> StateManager["State Management (Riverpod Providers)"]
    StateManager --> CoreDomain["Single Source of Truth (DomainRules & EntityTemplateRegistry)"]
    StateManager --> Infrastructure["Repository Layer (EntityRepo, CatalogRepo, LocationRepo, RelationRepo)"]
    
    Infrastructure --> Database["4NF SQLite Database (Drift ORM - 12 Tables)"]
    Infrastructure --> Storage["Local File Storage Service (Photos & Attachments)"]
```

---

## Key System Directives & Rules

1. **4NF Database Normalization**:
   - Physical magnitude properties are stored in 1:N relational tables (`SpeciesMagnitudesTable` and `InstanceMagnitudesTable`).
   - No primary `quantity` or `unit` columns exist on `CatalogTable` or `EntitiesTable`.
2. **Subspecies & Brand Hierarchy**:
   - Every catalog species has 1 or more subspecies. If no draft subspecies are added upon species creation, a default `"Genérica"` subspecies is created.
   - UI visual hierarchy is inverted: Subspecies name is the primary title (`Bravia 4K`), while general species name is presented as secondary context (`Especie: Televisor (Objeto)`).
3. **Active Instance Deletion Protection**:
   - Neither species nor subspecies can be deleted if active world instances exist in `EntitiesTable`. Both database operations (`deleteCatalogItem`, `deleteSubspecies`) and UI action buttons strictly enforce this restriction.
   - A species' last remaining subspecies cannot be deleted.
4. **Single Source of Truth (`DomainRules`)**:
   - All validation logic, unit compatibility rules, SI property name suggestions, and integer magnitude display formatting (`5` instead of `5.0`) are centralized in [DomainRules](file:///Users/hakkindavid/Documents/GitHub/PlatinumWorldManagementSystem/lib/src/core/domain/domain_rules.dart).
5. **Toast Notification System (`AppToast`)**:
   - User feedback messages, error alerts, and restriction warnings use [AppToast](file:///Users/hakkindavid/Documents/GitHub/PlatinumWorldManagementSystem/lib/src/core/widgets/app_toast.dart) for clean, high-priority non-intrusive overlays.
6. **Edit-Scoped Relation & Attachment Actions**:
   - Creating, editing, or deleting directed entity relations and attaching files can ONLY be performed when in **Edit Mode**.
7. **Alpha Transparency & Photo Fitting**:
   - All thumbnail and photo cards use `BoxFit.contain` with transparent backgrounds to render PNG/WebP images with alpha channels without opaque boxes.
