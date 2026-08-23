# PWMS Subspecies, Brand Variants & Visual Hierarchy Specification

This document details the subspecies and brand variant system, structural subgroup constraints, taxonomy auto-fill (`ProductLookupService`), photo resolution fallback, and visual hierarchy inversion in **Platinum World Management System (PWMS)**.

---

## 1. Conceptual Architecture: Species vs. Subspecies

In PWMS, item definitions are split into a 2-tier hierarchy:

1. **Especie (Catalog Definition)**: High-level category or model template stored in `CatalogTable` (e.g. `"Pila AA"`, `"Televisor"`, `"Gato"`, `"Manzana"`).
2. **Subespecie / Variante de Marca (Subspecies Definition)**: Concrete variant or product model stored in `SubspeciesTable` (e.g. `"Duracell Ultra"`, `"Energizer Max"`, `"Bravia 4K 55"`, `"Pancho"`, `"Mino"`).

```mermaid
graph TD
    Species["Especie (CatalogItem: Televisor)"]
    
    Species --> Sub1["Subespecie 1: Bravia 4K (Marca: Sony, Barcode: 12345)"]
    Species --> Sub2["Subespecie 2: OLED C3 (Marca: LG, Barcode: 67890)"]
    
    Sub1 --> Inst1["Instancia en Mundo 1 (Ubicación: Sala)"]
    Sub2 --> Inst2["Instancia en Mundo 2 (Ubicación: Habitación)"]
```

---

## 2. 4NF Database Schema (`SubspeciesTable`)

Subspecies are normalized in a dedicated 1:N relational table:

| Column | Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `id` | `Text` | Primary Key | Unique UUID string |
| `speciesId` | `Text` | FK -> `CatalogTable.id` | Foreign key referencing species |
| `subspeciesName` | `Text` | NOT NULL | Subspecies or variant name |
| `brand` | `Text` | Nullable | Brand name (Allowed for `Objeto` and `Documento`) |
| `barcode` | `Text` | Nullable | Barcode / QR string (Allowed for `Objeto` and `Documento`) |
| `photoPath` | `Text` | Nullable | Relative path to subspecies main photo |
| `notes` | `Text` | Nullable | Specific variant notes (e.g., "Edición especial") |
| `createdAt` | `DateTime` | NOT NULL | Creation timestamp |

---

## 3. Structural Constraints Across Entity Subgroups

Brand and Barcode attributes are strictly constrained by entity subgroup type:

| Subgroup Type | Brand & Barcode Allowed | Multi-Unit Magnitudes | Always Unique |
| :--- | :---: | :---: | :---: |
| **Objeto** | ✅ Yes | ✅ Yes | Optional |
| **Ser Vivo** | ❌ Stripped automatically | ✅ Yes | Optional |
| **Documento** | ✅ Yes | ❌ No | ✅ Always Unique |
| **Proyecto** | ❌ Stripped automatically | ❌ No | ✅ Always Unique |
| **Recuerdo** | ❌ Stripped automatically | ❌ No | ✅ Always Unique |

*When saving a subspecies for subgroups that do not support brand and barcode (`Ser Vivo`, `Proyecto`, `Recuerdo`), `saveSubspecies` automatically strips `brand` and `barcode` to `null`.*

---

## 4. Subspecies Registration & Product Taxonomy Intelligence

When registering or editing a subspecies via `AddEditSubspeciesModal`:

1. **Barcode Scan & Auto-Fill**: Scanning or entering a barcode triggers `ProductLookupService.lookupByBarcode()`.
2. **Taxonomy & Brand Matching**: The system checks `BrandDictionary` and `ProductTaxonomyDictionary` to infer brand name, subspecies title, perishability status, and suggested magnitude units.
3. **Dedicated Modal (`AddEditSubspeciesModal`)**: Provides isolated fields for variant title, brand, barcode, photo, and notes.

---

## 5. Main Photo Resolution & Fallback Logic

When rendering any instance or tile, image resolution follows this strict hierarchy of precedence:

1. **First attached image of the instance**: If the specific instance has image attachments, the first attached image (`fileType == 'image'` or image extension) takes highest priority.
2. **Subspecies photo**: If no instance image attachment exists, use `subspecies.photoPath` if present.
3. **Species main photo**: If `subspecies.photoPath` is null, fall back to `species.mainPhotoPath`.
4. **Default icon**: If no image is found, returns `null` and the UI renders the default species badge/avatar icon (`SpeciesTextBadgeAvatar`).

Implemented in `resolveEffectiveEntityPhotoPathWithRepo` ([`entity_photo_helper.dart`](file:///Users/hakkindavid/Documents/GitHub/PlatinumWorldManagementSystem/lib/src/features/entities/domain/entity_photo_helper.dart)).

---

## 6. UI Visual Hierarchy Inversion Rule

To provide maximum clarity to the user, **subspecies information is presented as the primary identity**, while the species serves as secondary context:

### 6.1 Detail Views (`SpeciesDetailView` & `EntityDetailScreen`)
- **Primary Title**: Subspecies name (e.g. `"Bravia 4K 55"`).
- **Secondary Context Badge**: Displays general species name and type (e.g. `Especie: Televisor (Objeto)`).

### 6.2 Instance Tiles (`EntityTile`, Recent Instances on `HomeScreen`)
- Displays subspecies photo, subspecies name, brand, barcode, and location trajectory without duplicating barcode legends when null.

---

## 7. Deletion Protection Rules

1. **Subspecies with Active Instances**: A subspecies cannot be deleted if any `WorldEntity` references `subspeciesId == sub.id`.
2. **Single Subspecies Rule**: The last remaining subspecies of a species cannot be deleted. Every species MUST maintain at least 1 valid subspecies.
3. **Creation Fallback**: If a species is created without adding draft subspecies, the creation dialog asks for confirmation to include the default `"Genérica"` subspecies in the creation payload (never generated as a database trigger).

