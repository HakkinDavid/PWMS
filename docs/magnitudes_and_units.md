# PWMS Physical Magnitudes, Multi-Unit System & SI Catalog

This document details the multi-unit magnitude system, dynamic `+` / `-` property controls, wheel pickers, integer formatting, complete SI unit catalog, and prepopulated property name suggestions in **Platinum World Management System (PWMS)**.

---

## 1. Physical Magnitudes Architecture

Physical properties of items in PWMS (such as mass, volume, length, counts, dimensions, prices, digital storage) are modeled in 4NF relational tables (`SpeciesMagnitudesTable` and `InstanceMagnitudesTable`).

### Key Properties:
- `propertyName`: String identifier (e.g. `"Masa"`, `"Longitud"`, `"Volumen"`, `"Precio"`).
- `magnitudeValue`: Numeric double value (e.g. `10.5`, `100.0`).
- `unitSymbol`: Standardized unit string (e.g. `"kg"`, `"m"`, `"L"`, `"unidad"`, `"$"`).

---

## 2. Complete SI & Metric Unit Catalog (`UnitsRegistry`)

The application supports a complete SI unit catalog categorized into 13 domain areas:

1. **Conteo Discreto (`allowDecimals: false`)**: `unidades`, `piezas`, `unidad`.
2. **Masa**: `t`, `kg`, `g`, `mg`.
3. **Longitud**: `km`, `m`, `cm`, `mm`.
4. **Volumen**: `m³`, `cm³`, `L`, `mL`.
5. **Superficie**: `km²`, `m²`, `cm²`.
6. **Tiempo**: `s`, `min`, `h`.
7. **Electricidad & Magnetismo**: `A`, `mA`, `V`, `mV`, `kV`, `Ω`.
8. **Temperatura**: `K`, `°C`, `°F`.
9. **Sustancia & Luz**: `mol`, `cd`.
10. **Fuerza & Presión**: `N`, `kN`, `Pa`, `kPa`, `bar`.
11. **Energía & Potencia**: `J`, `kJ`, `cal`, `W`, `kW`, `MW`, `Hz`, `kHz`, `MHz`, `GHz`.
12. **Almacenamiento Digital**: `B`, `KB`, `MB`, `GB`, `TB`.
13. **Financiero**: `$`, `USD`, `MXN`, `EUR`.

---

## 3. SI Unit Property Name Auto-Suggestions

When adding a property magnitude row in `SpeciesFormModal`, `DomainRules.suggestPropertyNameForUnit` prepopulates the property name based on the selected unit:

```dart
expect(DomainRules.suggestPropertyNameForUnit('kg'), equals('Masa'));
expect(DomainRules.suggestPropertyNameForUnit('L'), equals('Volumen'));
expect(DomainRules.suggestPropertyNameForUnit('m'), equals('Longitud'));
expect(DomainRules.suggestPropertyNameForUnit('$'), equals('Precio'));
```

---

## 4. Dynamic `+` / `-` Multi-Unit Controls in `SpeciesFormModal`

When creating or editing a species in [SpeciesFormModal](file:///Users/hakkindavid/Documents/GitHub/PlatinumWorldManagementSystem/lib/src/features/catalog/presentation/species_form_modal.dart), users can dynamically manage multiple unit properties:

- **`+ Agregar unidad de medida`**: Opens a dialog to define property name (prepopulated automatically), initial value, and unit symbol from allowed unit choices.
- **`- Eliminar unidad de medida`**: Instantly removes a magnitude property row.

---

## 5. Universal Cupertino Wheel Pickers

All dropdown pickers across PWMS have been replaced with smooth, touch-friendly **Cupertino Wheel Pickers**:

- **`AppWheelPicker`**: Generic Cupertino picker sheet used for choosing units, template species, relationship types, and domain categories.
- **`IntegerWheelPicker`**: Wheel picker tailored for integer magnitude adjustments (e.g., changing quantity counts from `0` to `100`).

---

## 6. Total Elimination of Hardcoded Default Magnitudes

- **Zero Auto-Injection**: When creating a species or instantiating an entity without explicitly adding magnitude properties, `magnitudes` remains an **empty list** (`[]`).
- **No Hardcoded Defaults**: The system never auto-injects default `"unidad"` or `"Cantidad"` rows.
