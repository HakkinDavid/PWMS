import 'package:platinum_world_management_system/src/core/database/app_database.dart';
import '../../../entities/domain/world_entity.dart';
import '../../../entities/domain/i_entity_repository.dart';
import '../../infrastructure/catalog_repository.dart';
import '../catalog_item.dart';
import '../subspecies.dart';
import 'rules/numismatic_outlier_detector.dart';
import 'rules/numismatic_standardization_service.dart';
import 'rules/numismatic_migration_service.dart';

export 'rules/numismatic_outlier_detector.dart'
    show
        NumismaticEmissionOutlierType,
        NumismaticEmissionOutlier,
        NumismaticCongruenceIssue,
        NumismaticOutlierDetector;
export 'rules/numismatic_standardization_service.dart'
    show NumismaticStandardizationService;
export 'rules/numismatic_migration_service.dart'
    show NumismaticMigrationService;

/// Facade maintaining 100% backward compatibility with existing domain rule invocations,
/// delegating internally to specialized modular numismatic services.
class NumismaticDomainRules {
  NumismaticDomainRules._();

  /// Checks if instance magnitudes match the currency subspecies and canonical standardization.
  static String? checkInstanceSubspeciesCongruence({
    required Subspecies subspecies,
    required WorldEntity instance,
  }) =>
      NumismaticOutlierDetector.checkInstanceSubspeciesCongruence(
        subspecies: subspecies,
        instance: instance,
      );

  /// Identifies duplicate currency subspecies under the same species (e.g. 'MXN' and 'Pesos Mexicanos').
  static Map<String, List<Subspecies>> findDuplicateSubspeciesGroups(
          List<Subspecies> subspeciesList) =>
      NumismaticStandardizationService.findDuplicateSubspeciesGroups(subspeciesList);

  /// Repairs subspecies title, instance magnitudes & attachment file names to strict canonical standards.
  static Future<Subspecies> repairSubspeciesFromInstance({
    required CatalogRepository catalogRepo,
    required IEntityRepository entityRepo,
    required Subspecies subspecies,
    required WorldEntity instance,
  }) =>
      NumismaticStandardizationService.repairSubspeciesFromInstance(
        catalogRepo: catalogRepo,
        entityRepo: entityRepo,
        subspecies: subspecies,
        instance: instance,
      );

  /// Merges duplicate subspecies into a canonical subspecies. Reassigns entities and deletes duplicates.
  static Future<void> mergeDuplicateSubspecies({
    required CatalogRepository catalogRepo,
    required IEntityRepository entityRepo,
    required Subspecies canonicalSubspecies,
    required List<Subspecies> duplicateSubspeciesList,
  }) =>
      NumismaticMigrationService.mergeDuplicateSubspecies(
        catalogRepo: catalogRepo,
        entityRepo: entityRepo,
        canonicalSubspecies: canonicalSubspecies,
        duplicateSubspeciesList: duplicateSubspeciesList,
      );

  /// Renames attachment files and updates database records to match current canonical instance derived name.
  static Future<void> repairAttachmentFileNames({
    required CatalogRepository catalogRepo,
    required IEntityRepository entityRepo,
    required Subspecies subspecies,
    required WorldEntity instance,
  }) =>
      NumismaticStandardizationService.repairAttachmentFileNames(
        catalogRepo: catalogRepo,
        entityRepo: entityRepo,
        subspecies: subspecies,
        instance: instance,
      );

  /// Repairs, consolidates and standardizes numismatic records in bulk after database import or migration.
  static Future<void> repairAndStandardizeImportedData(AppDatabase db) =>
      NumismaticMigrationService.repairAndStandardizeImportedData(db);

  /// Analyzes an instance against historical emission matrix rules and returns detected outliers.
  static List<NumismaticEmissionOutlier> checkEmissionOutliers({
    required WorldEntity instance,
    CatalogItem? species,
  }) =>
      NumismaticOutlierDetector.checkEmissionOutliers(
        instance: instance,
        species: species,
      );

  /// Repairs a detected emission outlier on an instance entity and updates repository.
  static Future<WorldEntity> repairEmissionOutlier({
    required IEntityRepository entityRepo,
    required CatalogRepository catalogRepo,
    required WorldEntity instance,
    required NumismaticEmissionOutlier outlier,
    String? customValue,
  }) =>
      NumismaticStandardizationService.repairEmissionOutlier(
        entityRepo: entityRepo,
        catalogRepo: catalogRepo,
        instance: instance,
        outlier: outlier,
        customValue: customValue,
      );
}
