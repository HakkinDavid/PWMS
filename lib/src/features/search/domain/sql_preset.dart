import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';

enum SqlPresetCategory {
  all,
  tables,
  containers,
  audit,
  expirationAndMagnitudes,
}

extension SqlPresetCategoryX on SqlPresetCategory {
  String get displayName {
    switch (this) {
      case SqlPresetCategory.all:
        return AppStrings.sqlCategoryAll;
      case SqlPresetCategory.tables:
        return AppStrings.sqlCategoryTables;
      case SqlPresetCategory.containers:
        return AppStrings.sqlCategoryContainers;
      case SqlPresetCategory.audit:
        return AppStrings.sqlCategoryAudit;
      case SqlPresetCategory.expirationAndMagnitudes:
        return AppStrings.sqlCategoryExpirationMagnitudes;
    }
  }
}

class SqlPreset {
  final String id;
  final String title;
  final SqlPresetCategory category;
  final String query;

  const SqlPreset({
    required this.id,
    required this.title,
    required this.category,
    required this.query,
  });

  static const List<SqlPreset> defaultPresets = [
    // 1. Tablas Base
    SqlPreset(
      id: 'table_catalog',
      title: AppStrings.tabCatalog,
      category: SqlPresetCategory.tables,
      query: 'SELECT id, name, type, is_unique FROM catalog_table;',
    ),
    SqlPreset(
      id: 'table_subspecies',
      title: AppStrings.subspeciesCategory,
      category: SqlPresetCategory.tables,
      query: 'SELECT id, species_id, subspecies_name, brand, barcode FROM subspecies_table;',
    ),
    SqlPreset(
      id: 'table_entities',
      title: AppStrings.sqlPresetInstances,
      category: SqlPresetCategory.tables,
      query: 'SELECT id, species_id, subspecies_id, location_id, notes FROM entities_table;',
    ),
    SqlPreset(
      id: 'table_locations',
      title: AppStrings.tabLocations,
      category: SqlPresetCategory.tables,
      query: 'SELECT id, name, parent_location_id, description FROM locations_table;',
    ),
    SqlPreset(
      id: 'table_instance_magnitudes',
      title: AppStrings.instanceMagnitudesCategory,
      category: SqlPresetCategory.tables,
      query: 'SELECT instance_id, property_name, data_type, magnitude_value, unit_symbol FROM instance_magnitudes_table;',
    ),

    // 2. Contenedores y Relaciones
    SqlPreset(
      id: 'containers_all',
      title: AppStrings.containersCategory,
      category: SqlPresetCategory.containers,
      query: "SELECT DISTINCT e.id, c.name, e.location_id FROM entities_table e JOIN relations_table r ON e.id = r.target_entity_id JOIN catalog_table c ON e.species_id = c.id WHERE r.relation_type = 'GUARDADO_EN';",
    ),
    SqlPreset(
      id: 'contained_items_all',
      title: AppStrings.sqlPresetContainedItems,
      category: SqlPresetCategory.containers,
      query: "SELECT DISTINCT e.id, c.name, s.subspecies_name, r.target_entity_id AS container_id, e.location_id FROM entities_table e JOIN relations_table r ON e.id = r.source_entity_id JOIN catalog_table c ON e.species_id = c.id LEFT JOIN subspecies_table s ON e.subspecies_id = s.id WHERE r.relation_type = 'GUARDADO_EN';",
    ),
    SqlPreset(
      id: 'non_contained_items_all',
      title: AppStrings.sqlPresetNonContainedItems,
      category: SqlPresetCategory.containers,
      query: "SELECT e.id, c.name, s.subspecies_name, e.location_id FROM entities_table e JOIN catalog_table c ON e.species_id = c.id LEFT JOIN subspecies_table s ON e.subspecies_id = s.id WHERE e.id NOT IN (SELECT source_entity_id FROM relations_table WHERE relation_type = 'GUARDADO_EN');",
    ),
    SqlPreset(
      id: 'non_contained_with_contained_species',
      title: AppStrings.sqlPresetNonContainedWithContainedSpecies,
      category: SqlPresetCategory.containers,
      query: "SELECT e.id, c.name, s.subspecies_name, e.location_id FROM entities_table e JOIN catalog_table c ON e.species_id = c.id LEFT JOIN subspecies_table s ON e.subspecies_id = s.id WHERE e.id NOT IN (SELECT source_entity_id FROM relations_table WHERE relation_type = 'GUARDADO_EN') AND e.species_id IN (SELECT DISTINCT e2.species_id FROM entities_table e2 JOIN relations_table r ON e2.id = r.source_entity_id WHERE r.relation_type = 'GUARDADO_EN');",
    ),
    SqlPreset(
      id: 'contained_with_non_contained_species',
      title: AppStrings.sqlPresetContainedWithNonContainedSpecies,
      category: SqlPresetCategory.containers,
      query: "SELECT e.id, c.name, s.subspecies_name, r.target_entity_id AS container_id, e.location_id FROM entities_table e JOIN relations_table r ON e.id = r.source_entity_id JOIN catalog_table c ON e.species_id = c.id LEFT JOIN subspecies_table s ON e.subspecies_id = s.id WHERE r.relation_type = 'GUARDADO_EN' AND e.species_id IN (SELECT DISTINCT e2.species_id FROM entities_table e2 WHERE e2.id NOT IN (SELECT source_entity_id FROM relations_table WHERE relation_type = 'GUARDADO_EN'));",
    ),

    // 3. Anomalías y Auditoría de Integridad
    SqlPreset(
      id: 'audit_orphan_entities',
      title: AppStrings.sqlPresetOrphanEntities,
      category: SqlPresetCategory.audit,
      query: "SELECT e.id, c.name, s.subspecies_name, e.created_at FROM entities_table e JOIN catalog_table c ON e.species_id = c.id LEFT JOIN subspecies_table s ON e.subspecies_id = s.id WHERE e.location_id IS NULL AND e.id NOT IN (SELECT source_entity_id FROM relations_table WHERE relation_type = 'GUARDADO_EN');",
    ),
    SqlPreset(
      id: 'audit_location_conflict',
      title: AppStrings.sqlPresetLocationConflict,
      category: SqlPresetCategory.audit,
      query: "SELECT e.id, c.name, e.location_id AS direct_location_id, r.target_entity_id AS container_id FROM entities_table e JOIN relations_table r ON e.id = r.source_entity_id JOIN catalog_table c ON e.species_id = c.id WHERE r.relation_type = 'GUARDADO_EN' AND e.location_id IS NOT NULL;",
    ),
    SqlPreset(
      id: 'audit_self_referencing',
      title: AppStrings.sqlPresetSelfReferencingRelations,
      category: SqlPresetCategory.audit,
      query: 'SELECT id, source_entity_id, target_entity_id, relation_type, created_at FROM relations_table WHERE source_entity_id = target_entity_id;',
    ),
    SqlPreset(
      id: 'audit_mutual_containment',
      title: AppStrings.sqlPresetMutualContainment,
      category: SqlPresetCategory.audit,
      query: "SELECT r1.source_entity_id AS entity_a, r1.target_entity_id AS entity_b FROM relations_table r1 JOIN relations_table r2 ON r1.source_entity_id = r2.target_entity_id AND r1.target_entity_id = r2.source_entity_id WHERE r1.relation_type = 'GUARDADO_EN' AND r2.relation_type = 'GUARDADO_EN';",
    ),
    SqlPreset(
      id: 'audit_uniqueness_violation',
      title: AppStrings.sqlPresetUniquenessViolation,
      category: SqlPresetCategory.audit,
      query: 'SELECT c.id AS species_id, c.name AS species_name, s.id AS subspecies_id, s.subspecies_name, COUNT(e.id) AS instance_count FROM catalog_table c JOIN subspecies_table s ON c.id = s.species_id JOIN entities_table e ON e.species_id = c.id AND e.subspecies_id = s.id WHERE c.is_unique = 1 GROUP BY c.id, c.name, s.id, s.subspecies_name HAVING COUNT(e.id) > 1;',
    ),
    SqlPreset(
      id: 'audit_uninstantiated_species',
      title: AppStrings.sqlPresetUninstantiatedSpecies,
      category: SqlPresetCategory.audit,
      query: 'SELECT c.id, c.name, c.type, c.created_at FROM catalog_table c LEFT JOIN entities_table e ON c.id = e.species_id WHERE e.id IS NULL;',
    ),
    SqlPreset(
      id: 'audit_uninstantiated_subspecies',
      title: AppStrings.sqlPresetUninstantiatedSubspecies,
      category: SqlPresetCategory.audit,
      query: 'SELECT s.id, c.name AS species, s.subspecies_name, s.brand FROM subspecies_table s JOIN catalog_table c ON s.species_id = c.id LEFT JOIN entities_table e ON s.id = e.subspecies_id WHERE e.id IS NULL;',
    ),
    SqlPreset(
      id: 'audit_subgroup_rule_violation',
      title: AppStrings.sqlPresetSubgroupRuleViolation,
      category: SqlPresetCategory.audit,
      query: "SELECT s.id, c.name, c.type, s.brand, s.barcode FROM subspecies_table s JOIN catalog_table c ON s.species_id = c.id WHERE c.type NOT IN ('Objeto', 'Documento') AND (s.brand IS NOT NULL OR s.barcode IS NOT NULL);",
    ),

    // 4. Caducidad y Magnitudes
    SqlPreset(
      id: 'exp_expired_entities',
      title: AppStrings.sqlPresetExpiredEntities,
      category: SqlPresetCategory.expirationAndMagnitudes,
      query: "SELECT e.id, c.name, s.subspecies_name, e.expiration_date, e.location_id FROM entities_table e JOIN catalog_table c ON e.species_id = c.id LEFT JOIN subspecies_table s ON e.subspecies_id = s.id WHERE e.expiration_date IS NOT NULL AND datetime(e.expiration_date) < datetime('now');",
    ),
    SqlPreset(
      id: 'exp_perishable_missing_expiration',
      title: AppStrings.sqlPresetPerishableMissingExpiration,
      category: SqlPresetCategory.expirationAndMagnitudes,
      query: 'SELECT e.id, c.name, s.subspecies_name, e.location_id FROM entities_table e JOIN catalog_table c ON e.species_id = c.id LEFT JOIN subspecies_table s ON e.subspecies_id = s.id WHERE c.is_non_perishable = 0 AND e.expiration_date IS NULL;',
    ),
    SqlPreset(
      id: 'exp_non_perishable_with_expiration',
      title: AppStrings.sqlPresetNonPerishableWithExpiration,
      category: SqlPresetCategory.expirationAndMagnitudes,
      query: 'SELECT e.id, c.name, s.subspecies_name, e.expiration_date FROM entities_table e JOIN catalog_table c ON e.species_id = c.id LEFT JOIN subspecies_table s ON e.subspecies_id = s.id WHERE c.is_non_perishable = 1 AND e.expiration_date IS NOT NULL;',
    ),
    SqlPreset(
      id: 'mag_anomalous_magnitudes',
      title: AppStrings.sqlPresetAnomalousMagnitudes,
      category: SqlPresetCategory.expirationAndMagnitudes,
      query: 'SELECT m.instance_id, c.name, m.property_name, m.magnitude_value, m.unit_symbol FROM instance_magnitudes_table m JOIN entities_table e ON m.instance_id = e.id JOIN catalog_table c ON e.species_id = c.id WHERE m.magnitude_value <= 0;',
    ),
    SqlPreset(
      id: 'mag_missing_mandatory_magnitudes',
      title: AppStrings.sqlPresetMissingMandatoryMagnitudes,
      category: SqlPresetCategory.expirationAndMagnitudes,
      query: 'SELECT e.id AS entity_id, c.name AS species, sm.property_name, sm.unit_symbol FROM entities_table e JOIN catalog_table c ON e.species_id = c.id JOIN species_magnitudes_table sm ON c.id = sm.species_id LEFT JOIN instance_magnitudes_table im ON e.id = im.instance_id AND sm.property_name = im.property_name WHERE im.id IS NULL;',
    ),
  ];
}
