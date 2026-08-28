import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import 'package:platinum_world_management_system/src/core/constants/app_technical_strings.dart';

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
      id: AppTechnicalStrings.presetTableEntities,
      title: AppStrings.sqlPresetInstances,
      category: SqlPresetCategory.tables,
      query: AppTechnicalStrings.sqlQueryPresetTableEntities,
    ),
    SqlPreset(
      id: AppTechnicalStrings.presetTableCatalog,
      title: AppStrings.tabCatalog,
      category: SqlPresetCategory.tables,
      query: AppTechnicalStrings.sqlQueryPresetTableCatalog,
    ),
    SqlPreset(
      id: AppTechnicalStrings.presetTableSubspecies,
      title: AppStrings.subspeciesCategory,
      category: SqlPresetCategory.tables,
      query: AppTechnicalStrings.sqlQueryPresetTableSubspecies,
    ),
    SqlPreset(
      id: AppTechnicalStrings.presetTableLocations,
      title: AppStrings.tabLocations,
      category: SqlPresetCategory.tables,
      query: AppTechnicalStrings.sqlQueryPresetTableLocations,
    ),
    SqlPreset(
      id: AppTechnicalStrings.presetTableInstanceMagnitudes,
      title: AppStrings.instanceMagnitudesCategory,
      category: SqlPresetCategory.tables,
      query: AppTechnicalStrings.sqlQueryPresetTableInstanceMagnitudes,
    ),

    // 2. Contenedores y Relaciones
    SqlPreset(
      id: AppTechnicalStrings.presetContainersAll,
      title: AppStrings.containersCategory,
      category: SqlPresetCategory.containers,
      query: AppTechnicalStrings.sqlQueryPresetContainersAll,
    ),
    SqlPreset(
      id: AppTechnicalStrings.presetContainedItemsAll,
      title: AppStrings.sqlPresetContainedItems,
      category: SqlPresetCategory.containers,
      query: AppTechnicalStrings.sqlQueryPresetContainedItemsAll,
    ),
    SqlPreset(
      id: AppTechnicalStrings.presetNonContainedItemsAll,
      title: AppStrings.sqlPresetNonContainedItems,
      category: SqlPresetCategory.containers,
      query: AppTechnicalStrings.sqlQueryPresetNonContainedItemsAll,
    ),
    SqlPreset(
      id: AppTechnicalStrings.presetNonContainedWithContainedSpecies,
      title: AppStrings.sqlPresetNonContainedWithContainedSpecies,
      category: SqlPresetCategory.containers,
      query: AppTechnicalStrings.sqlQueryPresetNonContainedWithContainedSpecies,
    ),
    SqlPreset(
      id: AppTechnicalStrings.presetContainedWithNonContainedSpecies,
      title: AppStrings.sqlPresetContainedWithNonContainedSpecies,
      category: SqlPresetCategory.containers,
      query: AppTechnicalStrings.sqlQueryPresetContainedWithNonContainedSpecies,
    ),

    // 3. Anomalías y Auditoría de Integridad
    SqlPreset(
      id: AppTechnicalStrings.presetAuditOrphanEntities,
      title: AppStrings.sqlPresetOrphanEntities,
      category: SqlPresetCategory.audit,
      query: AppTechnicalStrings.sqlQueryPresetAuditOrphanEntities,
    ),
    SqlPreset(
      id: AppTechnicalStrings.presetAuditLocationConflict,
      title: AppStrings.sqlPresetLocationConflict,
      category: SqlPresetCategory.audit,
      query: AppTechnicalStrings.sqlQueryPresetAuditLocationConflict,
    ),
    SqlPreset(
      id: AppTechnicalStrings.presetAuditSelfReferencing,
      title: AppStrings.sqlPresetSelfReferencingRelations,
      category: SqlPresetCategory.audit,
      query: AppTechnicalStrings.sqlQueryPresetAuditSelfReferencing,
    ),
    SqlPreset(
      id: AppTechnicalStrings.presetAuditMutualContainment,
      title: AppStrings.sqlPresetMutualContainment,
      category: SqlPresetCategory.audit,
      query: AppTechnicalStrings.sqlQueryPresetAuditMutualContainment,
    ),
    SqlPreset(
      id: AppTechnicalStrings.presetAuditUniquenessViolation,
      title: AppStrings.sqlPresetUniquenessViolation,
      category: SqlPresetCategory.audit,
      query: AppTechnicalStrings.sqlQueryPresetAuditUniquenessViolation,
    ),
    SqlPreset(
      id: AppTechnicalStrings.presetAuditUninstantiatedSpecies,
      title: AppStrings.sqlPresetUninstantiatedSpecies,
      category: SqlPresetCategory.audit,
      query: AppTechnicalStrings.sqlQueryPresetAuditUninstantiatedSpecies,
    ),
    SqlPreset(
      id: AppTechnicalStrings.presetAuditUninstantiatedSubspecies,
      title: AppStrings.sqlPresetUninstantiatedSubspecies,
      category: SqlPresetCategory.audit,
      query: AppTechnicalStrings.sqlQueryPresetAuditUninstantiatedSubspecies,
    ),
    SqlPreset(
      id: AppTechnicalStrings.presetAuditSubgroupRuleViolation,
      title: AppStrings.sqlPresetSubgroupRuleViolation,
      category: SqlPresetCategory.audit,
      query: AppTechnicalStrings.sqlQueryPresetAuditSubgroupRuleViolation,
    ),

    // 4. Caducidad y Magnitudes
    SqlPreset(
      id: AppTechnicalStrings.presetExpExpiredEntities,
      title: AppStrings.sqlPresetExpiredEntities,
      category: SqlPresetCategory.expirationAndMagnitudes,
      query: AppTechnicalStrings.sqlQueryPresetExpExpiredEntities,
    ),
    SqlPreset(
      id: AppTechnicalStrings.presetExpPerishableMissingExpiration,
      title: AppStrings.sqlPresetPerishableMissingExpiration,
      category: SqlPresetCategory.expirationAndMagnitudes,
      query: AppTechnicalStrings.sqlQueryPresetExpPerishableMissingExpiration,
    ),
    SqlPreset(
      id: AppTechnicalStrings.presetExpNonPerishableWithExpiration,
      title: AppStrings.sqlPresetNonPerishableWithExpiration,
      category: SqlPresetCategory.expirationAndMagnitudes,
      query: AppTechnicalStrings.sqlQueryPresetExpNonPerishableWithExpiration,
    ),
    SqlPreset(
      id: AppTechnicalStrings.presetMagAnomalousMagnitudes,
      title: AppStrings.sqlPresetAnomalousMagnitudes,
      category: SqlPresetCategory.expirationAndMagnitudes,
      query: AppTechnicalStrings.sqlQueryPresetMagAnomalousMagnitudes,
    ),
    SqlPreset(
      id: AppTechnicalStrings.presetMagMissingMandatoryMagnitudes,
      title: AppStrings.sqlPresetMissingMandatoryMagnitudes,
      category: SqlPresetCategory.expirationAndMagnitudes,
      query: AppTechnicalStrings.sqlQueryPresetMagMissingMandatoryMagnitudes,
    ),
  ];
}
