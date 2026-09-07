import 'app_database.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/numismatics/numismatic_backup_post_processor.dart';
import 'package:platinum_world_management_system/src/features/history/application/history_migration_post_processor.dart';

/// Interface for post-processors executed after database import or migration.
abstract class IDataMigrationPostProcessor {
  Future<void> process(AppDatabase db);
}

/// Central registry managing and coordinating all database post-processors
/// during both runtime database initialization/migration and backup restore.
class DataMigrationRegistry {
  DataMigrationRegistry._();

  static const List<IDataMigrationPostProcessor> defaultPostProcessors = [
    NumismaticMigrationPostProcessor(),
    HistoryMigrationPostProcessor(),
  ];

  static Future<void> runAll(AppDatabase db, [List<IDataMigrationPostProcessor>? processors]) async {
    final list = processors ?? defaultPostProcessors;
    for (final processor in list) {
      await processor.process(db);
    }
  }
}
