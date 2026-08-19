import 'app_database.dart';

/// Interface for post-processors executed after database import or migration.
abstract class IDataMigrationPostProcessor {
  Future<void> processAfterImport(AppDatabase db);
}
