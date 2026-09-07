import 'package:platinum_world_management_system/src/core/database/app_database.dart';
import 'package:platinum_world_management_system/src/core/database/data_migration_post_processor.dart';
import 'numismatic_domain_rules.dart';

class NumismaticMigrationPostProcessor implements IDataMigrationPostProcessor {
  const NumismaticMigrationPostProcessor();

  @override
  Future<void> process(AppDatabase db) async {
    await NumismaticDomainRules.repairAndStandardizeImportedData(db);
  }
}

typedef NumismaticBackupPostProcessor = NumismaticMigrationPostProcessor;
