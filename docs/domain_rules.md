# PWMS Domain Rules & Single Source of Truth Specification

This document details the domain rules, standardized terminology, validation matrices, and formatting rules implemented in `DomainRules` ([domain_rules.dart](file:///Users/hakkindavid/Documents/GitHub/PlatinumWorldManagementSystem/lib/src/core/domain/domain_rules.dart)) and `EntityTemplateRegistry` ([entity_template.dart](file:///Users/hakkindavid/Documents/GitHub/PlatinumWorldManagementSystem/lib/src/features/entities/domain/entity_template.dart)).

---

## 1. Single Source of Truth Architecture

To prevent scattered validations, UI inconsistencies, or conflicting business logic, **100% of domain rules and constraints derive from a single source of truth**:

- **Domain Rules Enforcement**: Centralized in `DomainRules`.
- **Subgroup Specifications & Capabilities**: Centralized in `EntityTemplateRegistry`.

---

## 2. Standardized Terminology

The codebase and user interface strictly enforce unambiguous domain terms:

| Term | Domain Concept | Description |
| :--- | :--- | :--- |
| **Especie** | Catalog Definition Item | Master catalog template in `CatalogTable` defining standard attributes, brands, and properties. |
| **Instancia** | Physical World Entity | Concrete entity in `EntitiesTable` residing at a specific location node in the world. |
| **Objeto** | Subgroup Type | A specific subgroup category of species representing physical items/tools. |
| **Ser Vivo** | Subgroup Type | Biological entities (animals, plants). |
| **Documento** | Subgroup Type | Unique document items. |
| **Proyecto** | Subgroup Type | Unique project entities. |
| **Recuerdo** | Subgroup Type | Unique memory or idea items. |

---

## 3. Subgroup Matrix & Capabilities

Different entity subgroup types have strict structural constraints enforced across UI and repository logic:

| Subgroup | Barcode & Brand | Multi-Unit Magnitudes | Always Unique |
| :--- | :---: | :---: | :---: |
| **Objeto** | ✅ Yes | ✅ Yes | Optional |
| **Ser Vivo** | ✅ Yes | ✅ Yes | Optional |
| **Documento** | ❌ No | ❌ No | ✅ Always Unique |
| **Proyecto** | ❌ No | ❌ No | ✅ Always Unique |
| **Recuerdo** | ❌ No | ❌ No | ✅ Always Unique |

---

## 4. Integer Unit Formatting & Display Rules

### 4.1 Whole Number Display Requirement
Integer magnitude values (such as count units `"unidad"`) **MUST ALWAYS** format without trailing decimals (`5`, `1`, `0`), never with `.0`.

```dart
static String formatMagnitude(double value, String? unitSymbol) {
  if (unitSymbol != null && isIntegerUnit(unitSymbol)) {
    return value.toInt().toString();
  }
  if (value == value.roundToDouble()) {
    return value.toInt().toString();
  }
  return value.toString();
}
```

### 4.2 Integer Counting Units Consolidation
All integer counting units (`pieza`, `paquete`, `juego`, `caja`) are unified into the standardized symbol `"unidad"`.

```dart
static bool isIntegerUnit(String unitSymbol) {
  final lower = unitSymbol.toLowerCase().trim();
  return lower == 'unidad' || lower == 'piezas' || lower == 'pza';
}
```

---

## 5. Unique Species Rules

- **Uniqueness Constraint**: If a species is marked as unique (`isUnique == true`), the system forbids associating it with the integer counting unit `"unidad"`.
- **Single World Instance**: A unique species can only have at most 1 active instance in the world. Once instantiated, the "Instanciar" button is disabled on `SpeciesTile`.

```dart
static bool isUnitAllowedForSpecies({
  required String unitSymbol,
  required bool isUnique,
}) {
  if (isUnique && isIntegerUnit(unitSymbol)) {
    return false; // Unique species CANNOT have counting units
  }
  return true;
}
```
