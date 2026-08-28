# PWMS Domain Rules & Single Source of Truth Specification

This document details the domain rules, standardized terminology, validation matrices, active instance deletion protections, perishability status rules, effective entity groupings, and SI unit property suggestions implemented in `DomainRules` ([domain_rules.dart](file:///Users/hakkindavid/Documents/GitHub/PlatinumWorldManagementSystem/lib/src/core/domain/domain_rules.dart)) and `EntityTemplateRegistry` ([entity_template.dart](file:///Users/hakkindavid/Documents/GitHub/PlatinumWorldManagementSystem/lib/src/features/entities/domain/entity_template.dart)).

---

## 1. Single Source of Truth Architecture

To prevent scattered validations, UI inconsistencies, or conflicting business logic, **100% of domain rules and constraints derive from a single source of truth**:

- **Domain Rules Enforcement**: Centralized in `DomainRules`.
- **Subgroup Specifications & Capabilities**: Centralized in `EntityTemplateRegistry`.
- **Product Taxonomy & Perishability Deduction**: Centralized in `ProductTaxonomyService` & `PerishabilityInferenceEngine`.

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

Entity subgroup types have standard recommended structural traits:

| Subgroup | Barcode & Brand | Multi-Unit Magnitudes | Perishability Allowed | Always Unique |
| :--- | :---: | :---: | :---: | :---: |
| **Objeto** | ✅ Standard | ✅ Yes | ✅ Perishable or Non-Perishable | Optional |
| **Ser Vivo** | ⚠️ Exception Confirmation | ✅ Yes | ✅ Perishable or Non-Perishable | Optional |
| **Documento** | ✅ Standard | ❌ No | ❌ Non-Perishable only | ✅ Always Unique |
| **Proyecto** | ⚠️ Exception Confirmation | ❌ No | ❌ Non-Perishable only | ✅ Always Unique |
| **Recuerdo** | ⚠️ Exception Confirmation | ❌ No | ❌ Non-Perishable only | ✅ Always Unique |

*Deviations (e.g. assigning a brand to a `Ser Vivo` or `Proyecto`) are permitted if explicitly confirmed by the user in an immediate interactive confirmation dialog or audited via the Control Center (`SubgroupRuleViolationStrategy`).*

---

## 4. Perishability & Expiration Domain Rules

1. **Perishability Status**:
   - Products marked as `isNonPerishable == true` ignore shelf life and do not accept expiration dates.
   - Perishable items (`isNonPerishable == false`) store `defaultShelfLifeDays` and `warningDaysBeforeExpiration`.
2. **Instance Expiration Dates**:
   - Instantiated entities of perishable species compute initial suggested `expirationDate = createdAt + defaultShelfLifeDays` (editable by user).
   - Expiration dates can be adjusted per instance or per batch.
3. **Automated Alert Triggers & Audit Strategies**:
   - Entities whose `expirationDate` is past `DateTime.now()` generate `'expired'` alerts in `NotificationsTable`.
   - Entities whose remaining shelf life is within `warningDaysBeforeExpiration` generate `'expiring_soon'` alerts in `NotificationsTable`.
   - Incongruous or anomalous dates (> 2 years in the past or > 20 years in the future) are audited via `AnomalousExpirationStrategy` in the Control Center.

---

## 5. Deletion & Taxonomy Governance Rules (Species & Subspecies)

1. **Active Instance Resolution**:
   - Deleting a species or subspecies that has active instances triggers an immediate interactive resolution dialog presenting 3 options:
     1. **Cancel / Retract**: Abort deletion.
     2. **Reassign Instances**: Select an existing target species or subspecies to transfer active instances before deletion.
     3. **Cascade Delete**: Permanently delete the species/subspecies along with all associated instances, magnitudes, locations, attachments, and relations in a single atomic transaction (`cascadeEntities: true`).
2. **Single Subspecies Resolution**:
   - Deleting the only subspecies of a species is allowed after user confirmation (`deleteOnlySubspeciesTitle`), leaving the species as a clean template in the catalog until new variants are added or audited by `SpeciesWithoutSubspeciesStrategy`.
3. **Taxonomy Separation & Movement**:
   - When separating or moving all subspecies out of a species, the origin species is preserved in the catalog as a template, never silently deleted.
4. **Homonyms & Shared Media Governance**:
   - Creating homonymous species names or reusing photo paths presents immediate confirmation dialogs (Create Separate vs. Merge, Reuse Photo vs. Choose Another) and is audited in CC via `DuplicateSpeciesStrategy` and `DuplicatePhotoStrategy`.

---

## 6. Integer Unit Formatting & Display Rules

### 6.1 Whole Number Display Requirement
Integer magnitude values (such as count units `"unidad"`, `"unidades"`, `"piezas"`) **MUST ALWAYS** format without trailing decimals (`5`, `1`, `0`), never with `.0`.

```dart
static String formatMagnitude(double value, String? unitSymbol) {
  if (isIntegerUnit(unitSymbol) || value == value.roundToDouble()) {
    return value.toInt().toString();
  }
  return value.toString();
}
```

### 6.2 Integer Counting Units Detection
```dart
static bool isIntegerUnit(String? unitSymbol) {
  if (unitSymbol == null || unitSymbol.isEmpty) return false;
  return !UnitsRegistry.allowsDecimals(unitSymbol);
}
```

---

## 7. Effective Entity Grouping Rules (`EffectiveEntityGroup`)

To avoid UI clutter when multiple physical instances share identical traits:

1. **Grouping Criteria**: Instances with the exact same `speciesId`, `subspeciesId`, and `effectiveLocationId` are aggregated into an `EffectiveEntityGroup`.
2. **Display Tile (`EffectiveGroupTile`)**: Displays combined total count, species name, subspecies name, location breadcrumb, and primary magnitude.
3. **Grouped Detail Inspector (`GroupedInstanceDetailScreen`)**: Tapping an effective group tile navigates to `/grouped-instance-detail`, allowing users to inspect individual physical instances or perform batch operations (moving, adjusting quantities, or deleting).

---

## 8. SI Unit Prepopulated Property Name Suggestions

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

## 9. Unique Species Rules

- **Evaluated Per Subspecies**: Subspecies allow multiple unique items under a unique species (e.g. if species `"Gato"` is unique, `"Pancho"` and `"Mino"` can coexist as distinct single instances).
- **Batch Modifier Lock**: Quantity operation buttons (`- / +`, wheel pickers) are disabled for unique species instances.

