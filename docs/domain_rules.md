# PWMS Domain Rules & Single Source of Truth Specification

This document details the domain rules, standardized terminology, validation matrices, active instance deletion protections, and SI unit property suggestions implemented in `DomainRules` ([domain_rules.dart](file:///Users/hakkindavid/Documents/GitHub/PlatinumWorldManagementSystem/lib/src/core/domain/domain_rules.dart)) and `EntityTemplateRegistry` ([entity_template.dart](file:///Users/hakkindavid/Documents/GitHub/PlatinumWorldManagementSystem/lib/src/features/entities/domain/entity_template.dart)).

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
| **Especie** | Catalog Definition Item | Master catalog template in `CatalogTable` defining standard attributes and magnitudes. |
| **Subespecie** | Variant or Brand | Concrete model variant or product brand in `SubspeciesTable` linked to a species. |
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
| **Ser Vivo** | ❌ Stripped automatically | ✅ Yes | Optional |
| **Documento** | ❌ Stripped automatically | ❌ No | ✅ Always Unique |
| **Proyecto** | ❌ Stripped automatically | ❌ No | ✅ Always Unique |
| **Recuerdo** | ❌ Stripped automatically | ❌ No | ✅ Always Unique |

---

## 4. Deletion Protection Rules (Species & Subspecies)

1. **Active Instance Protection**:
   - Neither a species nor a subspecies can be deleted if active instances exist in `EntitiesTable`.
   - `CatalogRepository.deleteCatalogItem` and `CatalogRepository.deleteSubspecies` check for matching rows in `EntitiesTable` and throw an exception if present.
   - UI action buttons in `SpeciesDetailScreen` and `SubspeciesSectionWidget` disable delete buttons when instances exist and display `AppToast.showRestriction`.
2. **Single Subspecies Rule**:
   - The last remaining subspecies of a species cannot be deleted.

---

## 5. Integer Unit Formatting & Display Rules

### 5.1 Whole Number Display Requirement
Integer magnitude values (such as count units `"unidad"`, `"unidades"`, `"piezas"`) **MUST ALWAYS** format without trailing decimals (`5`, `1`, `0`), never with `.0`.

```dart
static String formatMagnitude(double value, String? unitSymbol) {
  if (isIntegerUnit(unitSymbol) || value == value.roundToDouble()) {
    return value.toInt().toString();
  }
  return value.toString();
}
```

### 5.2 Integer Counting Units Detection
```dart
static bool isIntegerUnit(String? unitSymbol) {
  if (unitSymbol == null || unitSymbol.isEmpty) return false;
  return !UnitsRegistry.allowsDecimals(unitSymbol);
}
```

---

## 6. SI Unit Prepopulated Property Name Suggestions

When adding a magnitude property row, `DomainRules.suggestPropertyNameForUnit` automatically suggests the property name based on the unit chosen:

- **`kg`, `g`, `mg`, `t`** $\rightarrow$ `"Masa"`
- **`L`, `mL`, `m³`, `cm³`** $\rightarrow$ `"Volumen"`
- **`m`, `cm`, `mm`, `km`** $\rightarrow$ `"Longitud"`
- **`m²`, `cm²`, `km²`** $\rightarrow$ `"Superficie"`
- **`s`, `min`, `h`** $\rightarrow$ `"Tiempo"`
- **`A`, `mA`** $\rightarrow$ `"Corriente eléctrica"`
- **`V`, `mV`, `kV`** $\rightarrow$ `"Voltaje"`
- **`Ω`** $\rightarrow$ `"Resistencia"`
- **`K`, `°C`, `°F`** $\rightarrow$ `"Temperatura"`
- **`N`, `kN`** $\rightarrow$ `"Fuerza"`
- **`Pa`, `kPa`, `bar`** $\rightarrow$ `"Presión"`
- **`J`, `kJ`, `cal`** $\rightarrow$ `"Energía"`
- **`W`, `kW`, `MW`** $\rightarrow$ `"Potencia"`
- **`Hz`, `kHz`, `MHz`, `GHz`** $\rightarrow$ `"Frecuencia"`
- **`B`, `KB`, `MB`, `GB`, `TB`** $\rightarrow$ `"Almacenamiento"`
- **`$`, `USD`, `MXN`, `EUR`** $\rightarrow$ `"Precio"`
- **`unidades`, `piezas`, `unidad`** $\rightarrow$ `"Cantidad"`

---

## 7. Unique Species Rules

- **Evaluated Per Subspecies**: Subspecies allow multiple unique items under a unique species (e.g. if species `"Gato"` is unique, `"Pancho"` and `"Mino"` can coexist as distinct single instances).
- **Batch Modifier Lock**: Quantity operation buttons (`- / +`, wheel pickers) are disabled for unique species instances.
