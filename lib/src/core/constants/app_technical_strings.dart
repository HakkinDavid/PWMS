import '../../features/catalog/domain/taxonomy/generated_species_registry.dart';
import '../../features/catalog/domain/taxonomy/product_taxonomy_dictionary.dart';
import 'units_registry.dart';

/// Centralized technical strings and constants for the PWMS codebase.
///
/// Contains routes, database table/column names, SQL keywords and pragmas,
/// date/time format patterns, storage directories and extensions, network MIME types
/// and headers, notification channels and action payloads, regex patterns, JSON keys,
/// database data types, and common delimiters.
class AppTechnicalStrings {


  AppTechnicalStrings._();

  // ---------------------------------------------------------------------------
  // Routes
  // ---------------------------------------------------------------------------
  static const root = '/';
  static const catalog = '/catalog';
  static const catalogDetail = '/catalog/:id';
  static const catalogPrefix = '/catalog/';
  static const locations = '/locations';
  static const entities = '/entities';
  static const entityDetail = '/entities/:id';
  static const entityDetailLegacy = '/entity/:id';
  static const entityPrefix = '/entity/';
  static const controlCenter = '/control-center';
  static const settings = '/settings';
  static const search = '/search';
  static const register = '/register';
  static const inventory = '/inventory';
  static const notifications = '/notifications';
  static const history = '/history';
  static const paramId = 'id';
  static const paramFocusNodeId = 'focusNodeId';
  static const paramLocationId = 'locationId';
  static const paramContainerId = 'containerId';
  static const paramSpeciesId = 'speciesId';
  static const paramFilter = 'filter';
  static const paramQ = 'q';
  static const paramScope = 'scope';
  static const paramStartInCreateSpecies = 'startInCreateSpecies';
  static const paramInitialLocationId = 'initialLocationId';
  static const currencyMxn = 'MXN';
  static const sourceTypeEntity = 'entity';
  static const sourceTypeSpecies = 'species';
  static const sourceTypeSubspecies = 'subspecies';
  static const iconBuild = 'build';

  // ---------------------------------------------------------------------------
  // Database Tables & Columns
  // ---------------------------------------------------------------------------
  static const dbName = 'pwms_database';
  static const tableCatalog = 'catalog';
  static const tableSpecies = 'species';
  static const tableSubspecies = 'subspecies';
  static const tableEntities = 'entities';
  static const tableLocations = 'locations';
  static const tableRelations = 'relations';
  static const tableRequirements = 'speciesRequirements';
  static const tableAttachments = 'attachments';
  static const tableAttributes = 'entity_custom_attributes';
  static const tableActivityLogs = 'activity_logs';
  static const tableSqlPresets = 'sql_presets';
  static const tableAppSettings = 'appSettings';
  static const tableNotifications = 'notifications';
  static const tableHistoryEvents = 'historyEvents';
  static const tableCustomTemplates = 'customTemplates';
  static const tableInstanceLocations = 'instanceLocations';
  static const tableSpeciesMagnitudes = 'speciesMagnitudes';
  static const tableInstanceMagnitudes = 'instanceMagnitudes';
  static const tableIgnoredAuditCards = 'ignored_audit_cards';

  static const refSourceRelations = 'sourceRelations';
  static const refTargetRelations = 'targetRelations';

  static const colId = 'id';
  static const colName = 'name';
  static const colType = 'type';
  static const colCreatedAt = 'created_at';
  static const colUpdatedAt = 'updated_at';
  static const colSpeciesId = 'species_id';
  static const colSubspeciesId = 'subspecies_id';
  static const colLocationId = 'location_id';
  static const colParentLocationId = 'parent_location_id';
  static const colDescription = 'description';
  static const colNotes = 'notes';
  static const colExpirationDate = 'expiration_date';
  static const colSourceEntityId = 'source_entity_id';
  static const colTargetEntityId = 'target_entity_id';
  static const colRelationType = 'relation_type';
  static const colInstanceId = 'instance_id';
  static const colEntityId = 'entity_id';
  static const colEntityA = 'entity_a';
  static const colEntityB = 'entity_b';
  static const colPropertyName = 'property_name';
  static const colDataType = 'data_type';
  static const colMagnitudeValue = 'magnitude_value';
  static const colUnitSymbol = 'unit_symbol';
  static const colBrand = 'brand';
  static const colBarcode = 'barcode';
  static const colSubspeciesName = 'subspecies_name';
  static const colIsUnique = 'is_unique';
  static const colIsNonPerishable = 'is_non_perishable';
  static const colDirectLocationId = 'direct_location_id';
  static const colContainerId = 'container_id';
  static const colSpecies = 'species';
  static const colSpeciesName = 'species_name';
  static const colInstanceCount = 'instance_count';

  // Relation Types
  static const relGuardadoEn = 'GUARDADO_EN';
  static const relPerteneceA = 'PERTENECE_A';
  static const relNecesita = 'NECESITA';
  static const relParteDe = 'PARTE_DE';

  // ---------------------------------------------------------------------------
  // SQL
  // ---------------------------------------------------------------------------
  static const pragmaForeignKeysOn = 'PRAGMA foreign_keys = ON;';
  static const pragmaForeignKeysOff = 'PRAGMA foreign_keys = OFF;';
  static const pragmaIntegrityCheck = 'PRAGMA integrity_check;';
  static const pragmaQuickCheck = 'PRAGMA quick_check;';
  static const sqlMigration3To4CleanInstanceLocations = '''
DELETE FROM instance_locations_table
WHERE instance_id IN (
  SELECT source_entity_id FROM relations_table
  WHERE relation_type IN ('GUARDADO_EN', 'PARTE_DE')
);
''';
  static const sqlMigration3To4CleanEntitiesLocation = '''
UPDATE entities_table
SET location_id = NULL
WHERE id IN (
  SELECT source_entity_id FROM relations_table
  WHERE relation_type IN ('GUARDADO_EN', 'PARTE_DE')
);
''';

  // SQL Keywords
  static const sqlKeywordSelect = 'SELECT';
  static const sqlKeywordInsert = 'INSERT';
  static const sqlKeywordUpdate = 'UPDATE';
  static const sqlKeywordDelete = 'DELETE';
  static const sqlKeywordDrop = 'DROP';
  static const sqlKeywordAlter = 'ALTER';
  static const sqlKeywordCreate = 'CREATE';
  static const sqlKeywordReplace = 'REPLACE';
  static const sqlKeywordTruncate = 'TRUNCATE';
  static const sqlKeywordLimit = 'LIMIT';
  static const sqlNull = 'NULL';

  static const List<String> sqlForbiddenKeywords = [
    sqlKeywordInsert,
    sqlKeywordUpdate,
    sqlKeywordDelete,
    sqlKeywordDrop,
    sqlKeywordAlter,
    sqlKeywordCreate,
    sqlKeywordReplace,
    sqlKeywordTruncate,
  ];

  static const sqlDefaultSearchSample = 'SELECT * FROM catalog_table LIMIT 20;';

  // SQL Preset IDs
  static const presetTableCatalog = 'table_catalog';
  static const presetTableSubspecies = 'table_subspecies';
  static const presetTableEntities = 'table_entities';
  static const presetTableLocations = 'table_locations';
  static const presetTableInstanceMagnitudes = 'table_instance_magnitudes';
  static const presetContainersAll = 'containers_all';
  static const presetContainedItemsAll = 'contained_items_all';
  static const presetNonContainedItemsAll = 'non_contained_items_all';
  static const presetNonContainedWithContainedSpecies = 'non_contained_with_contained_species';
  static const presetContainedWithNonContainedSpecies = 'contained_with_non_contained_species';
  static const presetAuditOrphanEntities = 'audit_orphan_entities';
  static const presetAuditLocationConflict = 'audit_location_conflict';
  static const presetAuditSelfReferencing = 'audit_self_referencing';
  static const presetAuditMutualContainment = 'audit_mutual_containment';
  static const presetAuditUniquenessViolation = 'audit_uniqueness_violation';
  static const presetAuditUninstantiatedSpecies = 'audit_uninstantiated_species';
  static const presetAuditUninstantiatedSubspecies = 'audit_uninstantiated_subspecies';
  static const presetAuditSubgroupRuleViolation = 'audit_subgroup_rule_violation';
  static const presetExpExpiredEntities = 'exp_expired_entities';
  static const presetExpPerishableMissingExpiration = 'exp_perishable_missing_expiration';
  static const presetExpNonPerishableWithExpiration = 'exp_non_perishable_with_expiration';
  static const presetMagAnomalousMagnitudes = 'mag_anomalous_magnitudes';
  static const presetMagMissingMandatoryMagnitudes = 'mag_missing_mandatory_magnitudes';

  // SQL Preset Queries
  static const sqlQueryPresetTableCatalog = 'SELECT id, name, type, is_unique FROM catalog_table;';
  static const sqlQueryPresetTableSubspecies = 'SELECT id, species_id, subspecies_name, brand, barcode FROM subspecies_table;';
  static const sqlQueryPresetTableEntities = 'SELECT id, species_id, subspecies_id, location_id, notes FROM entities_table;';
  static const sqlQueryPresetTableLocations = 'SELECT id, name, parent_location_id, description FROM locations_table;';
  static const sqlQueryPresetTableInstanceMagnitudes = 'SELECT instance_id, property_name, data_type, magnitude_value, unit_symbol FROM instance_magnitudes_table;';
  static const sqlQueryPresetContainersAll = "SELECT DISTINCT e.id, c.name, e.location_id FROM entities_table e JOIN relations_table r ON e.id = r.target_entity_id JOIN catalog_table c ON e.species_id = c.id WHERE r.relation_type = 'GUARDADO_EN';";
  static const sqlQueryPresetContainedItemsAll = "SELECT DISTINCT e.id, c.name, s.subspecies_name, r.target_entity_id AS container_id, e.location_id FROM entities_table e JOIN relations_table r ON e.id = r.source_entity_id JOIN catalog_table c ON e.species_id = c.id LEFT JOIN subspecies_table s ON e.subspecies_id = s.id WHERE r.relation_type = 'GUARDADO_EN';";
  static const sqlQueryPresetNonContainedItemsAll = "SELECT e.id, c.name, s.subspecies_name, e.location_id FROM entities_table e JOIN catalog_table c ON e.species_id = c.id LEFT JOIN subspecies_table s ON e.subspecies_id = s.id WHERE e.id NOT IN (SELECT source_entity_id FROM relations_table WHERE relation_type = 'GUARDADO_EN');";
  static const sqlQueryPresetNonContainedWithContainedSpecies = "SELECT e.id, c.name, s.subspecies_name, e.location_id FROM entities_table e JOIN catalog_table c ON e.species_id = c.id LEFT JOIN subspecies_table s ON e.subspecies_id = s.id WHERE e.id NOT IN (SELECT source_entity_id FROM relations_table WHERE relation_type = 'GUARDADO_EN') AND e.species_id IN (SELECT DISTINCT e2.species_id FROM entities_table e2 JOIN relations_table r ON e2.id = r.source_entity_id WHERE r.relation_type = 'GUARDADO_EN');";
  static const sqlQueryPresetContainedWithNonContainedSpecies = "SELECT e.id, c.name, s.subspecies_name, r.target_entity_id AS container_id, e.location_id FROM entities_table e JOIN relations_table r ON e.id = r.source_entity_id JOIN catalog_table c ON e.species_id = c.id LEFT JOIN subspecies_table s ON e.subspecies_id = s.id WHERE r.relation_type = 'GUARDADO_EN' AND e.species_id IN (SELECT DISTINCT e2.species_id FROM entities_table e2 WHERE e2.id NOT IN (SELECT source_entity_id FROM relations_table WHERE relation_type = 'GUARDADO_EN'));";
  static const sqlQueryPresetAuditOrphanEntities = "SELECT e.id, c.name, s.subspecies_name, e.created_at FROM entities_table e JOIN catalog_table c ON e.species_id = c.id LEFT JOIN subspecies_table s ON e.subspecies_id = s.id WHERE e.location_id IS NULL AND e.id NOT IN (SELECT source_entity_id FROM relations_table WHERE relation_type = 'GUARDADO_EN');";
  static const sqlQueryPresetAuditLocationConflict = "SELECT e.id, c.name, e.location_id AS direct_location_id, r.target_entity_id AS container_id FROM entities_table e JOIN relations_table r ON e.id = r.source_entity_id JOIN catalog_table c ON e.species_id = c.id WHERE r.relation_type = 'GUARDADO_EN' AND e.location_id IS NOT NULL;";
  static const sqlQueryPresetAuditSelfReferencing = 'SELECT id, source_entity_id, target_entity_id, relation_type, created_at FROM relations_table WHERE source_entity_id = target_entity_id;';
  static const sqlQueryPresetAuditMutualContainment = "SELECT r1.source_entity_id AS entity_a, r1.target_entity_id AS entity_b FROM relations_table r1 JOIN relations_table r2 ON r1.source_entity_id = r2.target_entity_id AND r1.target_entity_id = r2.source_entity_id WHERE r1.relation_type = 'GUARDADO_EN' AND r2.relation_type = 'GUARDADO_EN';";
  static const sqlQueryPresetAuditUniquenessViolation = 'SELECT c.id AS species_id, c.name AS species_name, s.id AS subspecies_id, s.subspecies_name, COUNT(e.id) AS instance_count FROM catalog_table c JOIN subspecies_table s ON c.id = s.species_id JOIN entities_table e ON e.species_id = c.id AND e.subspecies_id = s.id WHERE c.is_unique = 1 GROUP BY c.id, c.name, s.id, s.subspecies_name HAVING COUNT(e.id) > 1;';
  static const sqlQueryPresetAuditUninstantiatedSpecies = 'SELECT c.id, c.name, c.type, c.created_at FROM catalog_table c LEFT JOIN entities_table e ON c.id = e.species_id WHERE e.id IS NULL;';
  static const sqlQueryPresetAuditUninstantiatedSubspecies = 'SELECT s.id, c.name AS species, s.subspecies_name, s.brand FROM subspecies_table s JOIN catalog_table c ON s.species_id = c.id LEFT JOIN entities_table e ON s.id = e.subspecies_id WHERE e.id IS NULL;';
  static const sqlQueryPresetAuditSubgroupRuleViolation = "SELECT s.id, c.name, c.type, s.brand, s.barcode FROM subspecies_table s JOIN catalog_table c ON s.species_id = c.id WHERE c.type NOT IN ('Objeto', 'Documento') AND (s.brand IS NOT NULL OR s.barcode IS NOT NULL);";
  static const sqlQueryPresetExpExpiredEntities = "SELECT e.id, c.name, s.subspecies_name, e.expiration_date, e.location_id FROM entities_table e JOIN catalog_table c ON e.species_id = c.id LEFT JOIN subspecies_table s ON e.subspecies_id = s.id WHERE e.expiration_date IS NOT NULL AND datetime(e.expiration_date) < datetime('now');";
  static const sqlQueryPresetExpPerishableMissingExpiration = 'SELECT e.id, c.name, s.subspecies_name, e.location_id FROM entities_table e JOIN catalog_table c ON e.species_id = c.id LEFT JOIN subspecies_table s ON e.subspecies_id = s.id WHERE c.is_non_perishable = 0 AND e.expiration_date IS NULL;';
  static const sqlQueryPresetExpNonPerishableWithExpiration = 'SELECT e.id, c.name, s.subspecies_name, e.expiration_date FROM entities_table e JOIN catalog_table c ON e.species_id = c.id LEFT JOIN subspecies_table s ON e.subspecies_id = s.id WHERE c.is_non_perishable = 1 AND e.expiration_date IS NOT NULL;';
  static const sqlQueryPresetMagAnomalousMagnitudes = 'SELECT m.instance_id, c.name, m.property_name, m.magnitude_value, m.unit_symbol FROM instance_magnitudes_table m JOIN entities_table e ON m.instance_id = e.id JOIN catalog_table c ON e.species_id = c.id WHERE m.magnitude_value <= 0;';
  static const sqlQueryPresetMagMissingMandatoryMagnitudes = 'SELECT e.id AS entity_id, c.name AS species, sm.property_name, sm.unit_symbol FROM entities_table e JOIN catalog_table c ON e.species_id = c.id JOIN species_magnitudes_table sm ON c.id = sm.species_id LEFT JOIN instance_magnitudes_table im ON e.id = im.instance_id AND sm.property_name = im.property_name WHERE im.id IS NULL;';

  // ---------------------------------------------------------------------------
  // DateTime Formats
  // ---------------------------------------------------------------------------
  static const iso8601 = 'yyyy-MM-ddTHH:mm:ss';
  static const dateOnly = 'yyyy-MM-dd';
  static const dateTimeDisplay = 'yyyy-MM-dd HH:mm';
  static const timeOnly = 'HH:mm';
  static const dateSlash = 'dd/MM/yyyy';

  // ---------------------------------------------------------------------------
  // Storage & Files
  // ---------------------------------------------------------------------------
  static const dirBackups = 'backups';
  static const dirPhotos = 'photos';
  static const dirAttachments = 'attachments';
  static const dirMedia = 'pwms_media';
  static const dirProductImages = 'product_images';
  static const extDb = '.db';
  static const extSqlite = '.sqlite';
  static const extZip = '.zip';
  static const extJson = '.json';
  static const extPng = '.png';
  static const extJpg = '.jpg';
  static const extJpeg = '.jpeg';
  static const extPdf = '.pdf';
  static const extWebp = '.webp';
  static const extHeic = '.heic';
  static const extBmp = '.bmp';
  static const extPngClean = 'png';
  static const extJpgClean = 'jpg';
  static const extJpegClean = 'jpeg';
  static const extWebpClean = 'webp';
  static const extHeicClean = 'heic';
  static const extBmpClean = 'bmp';
  static const extPdfClean = 'pdf';
  static const extZipClean = 'zip';
  static const extJsonClean = 'json';
  static const extFileClean = 'file';
  static const fileTypeImage = 'image';
  static const fileTypePdf = 'pdf';
  static const fileTypeDoc = 'doc';
  static const fileTypeFile = 'file';
  static const mediaSourceCamera = 'camera';
  static const mediaSourceGallery = 'gallery';
  static const mediaSourceWeb = 'web';
  static const mediaSourceFile = 'file';
  static const mediaSourceNumismatic = 'numismatic';
  static const sideAnverso = 'anverso';
  static const sideReverso = 'reverso';
  static const sideAmbos = 'ambos';
  static const actionReplace = 'replace';
  static const actionRename = 'rename';
  static const actionOpen = 'open';
  static const actionOpenExternally = 'open_externally';
  static const actionShare = 'share';
  static const genericSubspeciesLower = 'genérica';
  static const dbFileName = 'world_database.sqlite';
  static const backupManifestFile = 'manifest.json';
  static const backupDatabaseFileName = 'database.json';
  static const backupFilePrefix = 'pwms_backup_';
  static const dirFilesPrefix = 'files/';
  static const slashFilesPrefix = '/files/';
  static const macOsMetadataDir = '__MACOSX';
  static const dotUnderscore = '._';
  static const indentTwoSpaces = '  ';
  static const emptyJsonMap = '{}';
  static const emptyJsonList = '[]';
  static const schemeFile = 'file://';
  static const schemeHttp = 'http://';
  static const schemeHttps = 'https://';
  static const prefixAssets = 'assets/';

  // ---------------------------------------------------------------------------
  // Network
  // ---------------------------------------------------------------------------
  static const mimeJson = 'application/json';
  static const mimeZip = 'application/zip';
  static const mimeOctetStream = 'application/octet-stream';
  static const headerContentType = 'Content-Type';
  static const headerUserAgent = 'User-Agent';

  // ---------------------------------------------------------------------------
  // Notifications
  // ---------------------------------------------------------------------------
  static const channelId = 'pwms_notifications_channel';
  static const channelName = 'PWMS Notifications';
  static const payloadEntityId = 'entity_id';
  static const actionSnooze = 'ACTION_SNOOZE';
  static const notifTypeExpired = 'expired';
  static const notifTypeExpiringSoon = 'expiring_soon';
  static const notifTypeUnsatisfiedNeed = 'unsatisfied_need';
  static const notifStatusActive = 'active';
  static const notifStatusSnoozed = 'snoozed';
  static const notifStatusDismissed = 'dismissed';
  static const notifTargetTypeEntity = 'entity';
  static const notifTargetTypeSpecies = 'species';

  // ---------------------------------------------------------------------------
  // Regex Patterns
  // ---------------------------------------------------------------------------
  static const digitsOnly = r'^[0-9]+$';
  static const isoDatePattern = r'^\d{4}-\d{2}-\d{2}$';
  static const decimalPattern = r'^\d+(\.\d+)?$';
  static const regexWordBoundary = r'\b';
  static const regexMonedaNote = r'Moneda:\s*([^|]+)';
  static const regexMaterialNote = r'Material:\s*([^|]+)';
  static const regexMetalNote = r'Metal:\s*([^|]+)';
  static const regexGradoNote = r'Grado:\s*([^|\n]+)';
  static const regexNonVersionChars = r'[^0-9.]';

  // ---------------------------------------------------------------------------
  // JSON Keys
  // ---------------------------------------------------------------------------
  static const keyVersion = 'version';
  static const keyExportedAt = 'exportedAt';
  static const keyTables = 'tables';
  static const keyData = 'data';
  static const keyMetadata = 'metadata';
  static const keyParentLocationId = 'parentLocationId';
  static const keyIcon = 'icon';
  static const keyCreatedAt = 'createdAt';
  static const keyMainPhotoPath = 'mainPhotoPath';
  static const keyCustomAttributes = 'customAttributes';
  static const keyIsUnique = 'isUnique';
  static const keyIsNonPerishable = 'isNonPerishable';
  static const keyDefaultShelfLifeDays = 'defaultShelfLifeDays';
  static const keyWarningDaysBeforeExpiration = 'warningDaysBeforeExpiration';
  static const keySpeciesId = 'speciesId';
  static const keySubspeciesName = 'subspeciesName';
  static const keyBrand = 'brand';
  static const keyBarcode = 'barcode';
  static const keyPhotoPath = 'photoPath';
  static const keyPropertyName = 'propertyName';
  static const keyDataType = 'dataType';
  static const keyUnitSymbol = 'unitSymbol';
  static const keySubspeciesId = 'subspeciesId';
  static const keyLocationId = 'locationId';
  static const keyExpirationDate = 'expirationDate';
  static const keyUpdatedAt = 'updatedAt';
  static const keyInstanceId = 'instanceId';
  static const keyMagnitudeValue = 'magnitudeValue';
  static const keyStringValue = 'stringValue';
  static const keySourceEntityId = 'sourceEntityId';
  static const keyTargetEntityId = 'targetEntityId';
  static const keyRelationType = 'relationType';
  static const keyFilePath = 'filePath';
  static const keyFileName = 'fileName';
  static const keyFileType = 'fileType';
  static const keyEntityId = 'entityId';
  static const keyEventType = 'eventType';
  static const keyTimestamp = 'timestamp';
  static const keyTypeName = 'typeName';
  static const keyIconName = 'iconName';
  static const keyCommonUnits = 'commonUnits';
  static const keySourceId = 'sourceId';
  static const keySourceType = 'sourceType';
  static const keyRequiredSpeciesId = 'requiredSpeciesId';
  static const keyRequiredQuantity = 'requiredQuantity';
  static const keyTitle = 'title';
  static const keySubtitle = 'subtitle';
  static const keyMessage = 'message';
  static const keyTargetId = 'targetId';
  static const keyTargetType = 'targetType';
  static const keyCardId = 'cardId';
  static const keyRuleId = 'ruleId';
  static const keyStatus = 'status';
  static const keySnoozedUntil = 'snoozedUntil';
  static const keyKey = 'key';
  static const keyValue = 'value';
  static const keySchemaVersion = 'schemaVersion';
  static const keyVersionCheck = 'versionCheck';
  static const keyName = 'name';
  static const keyType = 'type';
  static const keyDetails = 'details';
  static const keyFrom = 'from';
  static const keyTo = 'to';
  static const keyFile = 'file';
  static const keySource = 'source';
  static const keyTarget = 'target';
  static const keyQuantity = 'quantity';
  static const keyUnit = 'unit';
  static const keyCount = 'count';
  static const keyEntityIds = 'entityIds';
  static const keyNewSpecies = 'newSpecies';
  static const keyTargetSpecies = 'targetSpecies';
  static const keySpeciesName = 'speciesName';
  static const keyParent = 'parent';
  static const keyTotalRecords = 'totalRecords';
  static const keyOriginDate = 'originDate';
  static const keyRuleTitle = 'ruleTitle';
  static const keyRelationId = 'relationId';
  static const keyAttachmentId = 'attachmentId';
  static const categoryAuditLower = 'audit';
  static const typeMigration = 'migration';

  // ---------------------------------------------------------------------------
  // Data Types
  // ---------------------------------------------------------------------------
  static const typeReal = 'REAL';
  static const typeInteger = 'INTEGER';
  static const typeText = 'TEXT';
  static const typeBoolean = 'BOOLEAN';

  // ---------------------------------------------------------------------------
  // Delimiters & Separators
  // ---------------------------------------------------------------------------
  static const dot = '.';
  static const comma = ',';
  static const commaSpace = ', ';
  static const slash = '/';
  static const dash = '-';
  static const colon = ':';
  static const colonSpace = ': ';
  static const space = ' ';
  static const bulletSeparator = ' • ';
  static const pipe = '|';
  static const greaterThanWithSpaces = ' > ';
  static const greaterThanTrailing = ' >';
  static const atSignWithSpaces = ' @ ';
  static const atSignTrailing = ' @';
  static const arrowRight = ' ➔ ';
  static const androidDefaultNotificationIcon = '@mipmap/ic_launcher';
  static const notifChannelPwms = 'pwms_notifications';
  static const empty = '';

  // Icon Keyword Constants (for LocationTile & icons)
  static const iconKeywordHome = 'home';
  static const iconKeywordCasa = 'casa';
  static const iconKeywordRoom = 'room';
  static const iconKeywordCuarto = 'cuarto';
  static const iconKeywordHabitacion = 'habitacion';
  static const iconKeywordBox = 'box';
  static const iconKeywordCaja = 'caja';
  static const iconKeywordContenedor = 'contenedor';
  static const iconKeywordFolder = 'folder';
  static const iconKeywordCarpeta = 'carpeta';
  static const iconKeywordStore = 'store';
  static const iconKeywordBodega = 'bodega';
  static const iconKeywordAlmacen = 'almacen';
  static const iconKeywordShelf = 'shelf';
  static const iconKeywordEstante = 'estante';
  static const iconKeywordArmario = 'armario';

  // Logger Constants and Dynamic Helpers
  static const logPrefixLevel5 = '🚨 ';
  static const logPrefixLevel4 = '‼️ ';
  static const logPrefixLevel3 = '📌 ';
  static const logPrefixLevel2 = '⚠️ ';
  static const logPrefixLevel1 = 'ⓘ ';
  static const logPrefixLevel0 = '   ';
  static const logSeparatorChar = '—';
  static String logDivider([int length = 70]) => logSeparatorChar * length;
  static String logCallerInfo(String caller) => '[$caller] ';
  static String formatLogEntry(String prefix, String callerInfo, Object? message) => '$prefix$callerInfo$message';
  static String formatLogError(Object? message, [Object? error]) => error != null ? 'ERROR: $message ($error)' : 'ERROR: $message';

  // Route and Storage Dynamic Helpers
  static String entityDetailPath(String id) => '$entityPrefix$id';
  static String catalogDetailPath(String id) => '$catalogPrefix$id';
  static String backupArchiveFilePath(String filename) => '$dirFilesPrefix$filename';
  static String backupZipFileName(String timestamp) => '$backupFilePrefix$timestamp$extZip';
  static String fileNameWithExtension(String name, String ext) => '$name$ext';
  static String withDotPrefix(String ext) => ext.startsWith(dot) ? ext : '$dot$ext';

  // Breadcrumb, Formatting & Model Helpers
  static String formatBreadcrumbFullPath(String ancestorPath, String targetName) => ancestorPath.isNotEmpty ? '$ancestorPath $targetName' : targetName;
  static String formatBreadcrumbAncestorPath(List<String> ancestors) => '${ancestors.join(greaterThanWithSpaces)}$greaterThanTrailing';
  static String formatEffectiveBreadcrumbAncestor(String physicalPath) => '$physicalPath$atSignTrailing';
  static String formatEntityWithNotes(String baseName, String notes) => '$baseName ($notes)';
  static String formatAppUpdateInfo({required bool available, required String current, String? latest}) => 'AppUpdateInfo(available: $available, current: $current, latest: $latest)';
  static String formatInt(int value) => value.toString();

  // ---------------------------------------------------------------------------
  // Relation Types (additional)
  // ---------------------------------------------------------------------------
  static const relDocumenta = 'DOCUMENTA';
  static const relUsa = 'USA';

  // ---------------------------------------------------------------------------
  // Entity Type Keyword Aliases (for fallback matching in EntityTemplateRegistry)
  // ---------------------------------------------------------------------------
  static const entityTypeKeywordSerVivo = 'ser vivo';
  static const entityTypeKeywordMascota = 'mascota';
  static const entityTypeKeywordPlanta = 'planta';
  static const entityTypeKeywordDoc = 'doc';
  static const entityTypeKeywordProyect = 'proyect';
  static const entityTypeKeywordIdea = 'idea';
  static const entityTypeKeywordRecuerdo = 'recuerdo';

  // ---------------------------------------------------------------------------
  // Notification ID Key Builders
  // ---------------------------------------------------------------------------
  static String notifKeyExpired(String entityId) => 'expired_$entityId';
  static String notifKeyExpiringSoon(String entityId) => 'expiring_soon_$entityId';
  static String notifKeyUnsatisfiedNeed(String speciesId) => 'unsatisfied_need_$speciesId';
  static String notifKeyFromNotification(String type, String targetId) => '${type}_$targetId';
  static String compositeId(String a, String b) => '${a}_$b';
  static String compositeKey(String a, String b) => '${a}_$b';
  static String wordBoundaryKeywordPattern(String keyword) => '$regexWordBoundary$keyword$regexWordBoundary';
  static String labelWithColon(String label) => '$label$colonSpace';

  // Control Center Audit Rules
  // ---------------------------------------------------------------------------
  static const ruleCatalogUninstantiatedSubspecies = 'catalog_uninstantiated_subspecies';
  static const ruleCatalogUniquenessViolation = 'catalog_uniqueness_violation';
  static const ruleCatalogSubgroupRuleViolation = 'catalog_subgroup_rule_violation';
  static const ruleCatalogUninstantiatedSpecies = 'catalog_uninstantiated_species';
  static const ruleCatalogIncompleteSpeciesInfo = 'catalog_incomplete_species_info';
  static const ruleCatalogRemoteImageAudit = 'catalog_remote_image_audit';
  static const ruleRelationalOrphanEntity = 'relational_orphan_entity';
  static const ruleRelationalLocationConflict = 'relational_location_conflict';
  static const ruleRelationalCyclicContainment = 'relational_cyclic_containment';
  static const ruleRelationalOwnershipCheck = 'relational_ownership_check';
  static const ruleRelationalLocationVerification = 'relational_location_verification';
  static const ruleExpirationPerishableMissingExpiration = 'expiration_perishable_missing_expiration';
  static const ruleExpirationNonPerishableWithExpiration = 'expiration_non_perishable_with_expiration';
  static const ruleExpirationMissingMandatoryMagnitudes = 'expiration_missing_mandatory_magnitudes';
  static const ruleExpirationAnomalousMagnitude = 'expiration_anomalous_magnitude';
  static const ruleNumismaticDuplicateSubspecies = 'numismatic_duplicate_subspecies';
  static const ruleNumismaticSubspeciesIncongruity = 'numismatic_subspecies_incongruity';
  static const ruleNumismaticAttachmentIncongruity = 'numismatic_attachment_incongruity';
  static const ruleNumismaticMissingMagnitudes = 'numismatic_missing_magnitudes';
  static const ruleNumismaticEmptyDataAudit = 'numismatic_empty_data_audit';
  static const ruleUnitInvalidSymbol = 'unit_invalid_symbol';
  static const ruleUnitIntegerIncongruity = 'unit_integer_incongruity';
  static const ruleUnitNonNumericWithUnit = 'unit_non_numeric_with_unit';
  static const ruleUnitNegativeMagnitudeViolation = 'unit_negative_magnitude_violation';
  static const ruleUnitPropertyNameSuggestionIncongruity = 'unit_property_name_suggestion_incongruity';
  static const ruleGovernanceDuplicateSpecies = 'governance_duplicate_species';
  static const ruleGovernanceDuplicatePhoto = 'governance_duplicate_photo';
  static const ruleGovernanceSpeciesWithoutSubspecies = 'governance_species_without_subspecies';
  static const ruleGovernanceUnlinkedInstances = 'governance_unlinked_instances';
  static const ruleGovernanceAnomalousExpiration = 'governance_anomalous_expiration';

  // ---------------------------------------------------------------------------
  // Action Identifiers & Dialog Returns
  // ---------------------------------------------------------------------------
  static const actionCancel = 'cancel';
  static const actionKeep = 'keep';
  static const actionDelete = 'delete';
  static const actionEdit = 'edit';
  static const actionSeparate = 'separate';
  static const actionMove = 'move';
  static const actionMakeNotUnique = 'make_not_unique';
  static const actionDeleteDuplicates = 'delete_duplicates';
  static const actionInstantiate = 'instantiate';
  static const actionKeepContainer = 'keep_container';
  static const actionKeepDirect = 'keep_direct';
  static const actionReassign = 'reassign';
  static const actionLocation = 'location';
  static const actionSubspecies = 'subspecies';
  static const actionRemoveUnit = 'remove_unit';
  static const actionChangeUnit = 'change_unit';
  static const actionSetNull = 'set_null';
  static const actionEnterValue = 'enter_value';
  static const actionMerge = 'merge';
  static const actionCreateSeparate = 'create_separate';
  static const actionCascadeDelete = 'cascade_delete';

  // ---------------------------------------------------------------------------
  // Audit Card ID Prefixes
  // ---------------------------------------------------------------------------
  static const prefixSub = 'sub_';
  static const prefixUniqViol = 'uniq_viol_';
  static const prefixSubgroupViol = 'subgroup_viol_';
  static const prefixUninstSp = 'uninst_sp_';
  static const prefixSpecInc = 'spec_inc_';
  static const prefixSpecRemote = 'spec_remote_';
  static const prefixSubRemote = 'sub_remote_';
  static const prefixOrphan = 'orphan_';
  static const prefixConflict = 'conflict_';
  static const prefixCirc = 'circ_';
  static const prefixOwn = 'own_';
  static const prefixLocVerif = 'loc_verif_';
  static const prefixNoExp = 'no_exp_';
  static const prefixUnneededExp = 'unneeded_exp_';
  static const prefixMissMag = 'miss_mag_';
  static const prefixAnomMag = 'anom_mag_';
  static const prefixNumisDup = 'numis_dup_';
  static const prefixNumisInc = 'numis_inc_';
  static const prefixNumisAtt = 'numis_att_';
  static const prefixNumisMag = 'numis_mag_';
  static const prefixNumisEmptyGrade = 'numis_empty_grade_';
  static const prefixInvUnit = 'inv_unit_';
  static const prefixIntUnit = 'int_unit_';
  static const prefixNonNumUnit = 'non_num_unit_';
  static const prefixNegMag = 'neg_mag_';
  static const prefixPropSug = 'prop_sug_';
  static const prefixDupSp = 'dup_sp_';
  static const prefixDupPhoto = 'dup_photo_';
  static const prefixNoSub = 'no_sub_';
  static const prefixUnlink = 'unlink_';
  static const prefixAnomExp = 'anom_exp_';

  // ---------------------------------------------------------------------------
  // Lowercase Data Types & Technical Values
  // ---------------------------------------------------------------------------
  static const datatypeBooleanLower = 'boolean';
  static const datatypeStringLower = 'string';
  static const datatypeIntegerLower = 'integer';
  static const datatypeRealLower = 'real';
  static const boolTrue = 'true';
  static const boolFalse = 'false';
  static const valZero = '0';
  static const valOne = '1';
  static const valSiWithAccent = 'sí';
  static const valSiWithoutAccent = 'si';
  static const genericPropNamePropiedad = 'propiedad';
  static const genericPropNameValor = 'valor';
  static const genericPropNameDefault = 'default';
  static const genericPropNameItem = 'item';
  static const genericPropNameSinNombre = 'sin nombre';
  static const Set<String> genericPropertyNamesSet = {
    genericPropNamePropiedad,
    genericPropNameValor,
    genericPropNameDefault,
    genericPropNameItem,
    genericPropNameSinNombre,
  };
  static const exceptionPrefix = 'Exception: ';
  static const anversoParensLower = '(anverso)';
  static const anversoLower = 'anverso';
  static const reversoLower = 'reverso';
  static const assertConfirmToastOrOnConfirm = 'Either confirmToastMessage or onConfirm must be provided';

  // ---------------------------------------------------------------------------
  // Camera, Image Processing, Events & UI Keys
  // ---------------------------------------------------------------------------
  static const modeCoin = 'coin';
  static const modeBanknote = 'banknote';
  static const digitsWithDecimalFilter = r'[0-9.]';
  static const imageFileExtensionsRegex = r'\.(jpg|jpeg|png)$';
  static const extCroppedJpg = '_cropped.jpg';
  static const categoryAll = 'all';
  static const categoryEntity = 'entity';
  static const categorySpecies = 'species';
  static const categoryLocation = 'location';
  static const categoryRelation = 'relation';
  static const categoryBackup = 'backup';
  static const categorySystem = 'system';

  static const eventTypeCreation = 'creation';
  static const eventTypeEdition = 'edition';
  static const eventTypeDeletion = 'deletion';
  static const eventTypeMovement = 'movement';
  static const eventTypeAttachment = 'attachment';
  static const eventTypeAttachmentRemoved = 'attachment_removed';
  static const eventTypeRelation = 'relation';
  static const eventTypeRelationRemoved = 'relation_removed';
  static const eventTypePhotoChanged = 'photo_changed';
  static const eventTypePhotoRemoved = 'photo_removed';
  static const eventTypeConsumption = 'consumption';
  static const eventTypeSpeciesCreation = 'species_creation';
  static const eventTypeSpeciesEdition = 'species_edition';
  static const eventTypeSpeciesDeletion = 'species_deletion';
  static const eventTypeSpeciesMerge = 'species_merge';
  static const eventTypeSubspeciesCreation = 'subspecies_creation';
  static const eventTypeSubspeciesSeparation = 'subspecies_separation';
  static const eventTypeSubspeciesMovement = 'subspecies_movement';
  static const eventTypeSubspeciesDeletion = 'subspecies_deletion';
  static const eventTypeLocationCreation = 'location_creation';
  static const eventTypeLocationEdition = 'location_edition';
  static const eventTypeLocationMovement = 'location_movement';
  static const eventTypeLocationDeletion = 'location_deletion';
  static const eventTypeBackupExport = 'backup_export';
  static const eventTypeBackupRestore = 'backup_restore';
  static const eventTypeAuditFix = 'audit_fix';
  static const eventTypeBatchDeletion = 'batch_deletion';

  static const eventCreation = eventTypeCreation;
  static const eventEdition = eventTypeEdition;
  static const eventDeletion = eventTypeDeletion;
  static const eventMovement = eventTypeMovement;
  static const eventAttachment = eventTypeAttachment;
  static const eventAttachmentRemoved = eventTypeAttachmentRemoved;
  static const eventRelation = eventTypeRelation;
  static const eventRelationRemoved = eventTypeRelationRemoved;
  static const eventPhotoChanged = eventTypePhotoChanged;
  static const eventPhotoRemoved = eventTypePhotoRemoved;
  static const eventConsumption = eventTypeConsumption;
  static const unassignedLocationId = '__UNASSIGNED__';
  static const keyCoinTargetingStack = 'coin_targeting_stack';
  static const keyCoinReticleContainer = 'coin_reticle_container';
  static const keyBanknoteTargetingStack = 'banknote_targeting_stack';
  static const keyBanknoteReticleContainer = 'banknote_reticle_container';
  static String locTileKey(String id) => 'loc_tile_$id';

  // ---------------------------------------------------------------------------
  // App Settings Keys
  // ---------------------------------------------------------------------------
  static const keyGeminiApiKey = 'gemini_api_key';
  static const keyNumistaApiKey = 'numista_api_key';
  static const keyLastNumismaticLocationMode = 'last_numismatic_location_mode';
  static const keyLastNumismaticLocationId = 'last_numismatic_location_id';
  static const keyLastNumismaticContainerEntityId = 'last_numismatic_container_entity_id';
  static const keyNumismaticTorchEnabled = 'numismatic_torch_enabled';
  static const keyNumismaticExposureOffset = 'numismatic_exposure_offset';
  static const keyNumismaticDefaultMode = 'numismatic_default_mode';
  static const keyNumismaticZoomLevel = 'numismatic_zoom_level';

  // ---------------------------------------------------------------------------
  // Updater & Platform Channels
  // ---------------------------------------------------------------------------
  static const channelUpdater = 'dev.bonsanbec.pwms/updater';
  static const callerAppUpdateService = 'AppUpdateService';
  static const defaultInitialAppVersion = '1.0.0';
  static const methodIsUpdateAvailable = 'isUpdateAvailable';
  static const methodUpdateApp = 'updateApp';
  static const keyAvailable = 'available';
  static const keyLatestVersion = 'latest_version';
  static const keyChangelog = 'changelog';
  static const keyApkUrl = 'apk_url';
  static const versionPrefix = 'v';
  static const questionMark = '?';
  static const fontFamilyMonospace = 'monospace';

  // ---------------------------------------------------------------------------
  // SI & Measurement Units
  // ---------------------------------------------------------------------------
  static const unitTonne = 't';
  static const unitKg = 'kg';
  static const unitGram = 'g';
  static const unitMg = 'mg';
  static const unitKm = 'km';
  static const unitMeter = 'm';
  static const unitCm = 'cm';
  static const unitMm = 'mm';
  static const unitCubicMeter = 'm³';
  static const unitCubicCm = 'cm³';
  static const unitLiter = 'L';
  static const unitMl = 'mL';
  static const unitSqKm = 'km²';
  static const unitSqMeter = 'm²';
  static const unitSqCm = 'cm²';
  static const unitSecond = 's';
  static const unitMinute = 'min';
  static const unitHour = 'h';
  static const unitYear = 'año';
  static const unitAmpere = 'A';
  static const unitMilliampere = 'mA';
  static const unitVolt = 'V';
  static const unitMillivolt = 'mV';
  static const unitKilovolt = 'kV';
  static const unitOhm = 'Ω';
  static const unitKelvin = 'K';
  static const unitCelsius = '°C';
  static const unitFahrenheit = '°F';
  static const unitMole = 'mol';
  static const unitCandela = 'cd';
  static const unitNewton = 'N';
  static const unitKilonewton = 'kN';
  static const unitPascal = 'Pa';
  static const unitKilopascal = 'kPa';
  static const unitBar = 'bar';
  static const unitJoule = 'J';
  static const unitKilojoule = 'kJ';
  static const unitCalorie = 'cal';
  static const unitWatt = 'W';
  static const unitKilowatt = 'kW';
  static const unitMegawatt = 'MW';
  static const unitHertz = 'Hz';
  static const unitKilohertz = 'kHz';
  static const unitMegahertz = 'MHz';
  static const unitGigahertz = 'GHz';
  static const unitByte = 'B';
  static const unitKb = 'KB';
  static const unitMb = 'MB';
  static const unitGb = 'GB';
  static const unitTb = 'TB';
  static const unitDollar = '\$';
  static const unitUsd = 'USD';
  static const unitMxn = 'MXN';
  static const unitEur = 'EUR';
  static const unitEsp = 'ESP';
  static const unitUnidad = 'unidad';
  static const unitPiezas = 'piezas';

  // ---------------------------------------------------------------------------
  // Data Type Aliases
  // ---------------------------------------------------------------------------
  static const datatypeEntero = 'entero';
  static const datatypeInt = 'int';
  static const datatypeTexto = 'texto';
  static const datatypeText = 'text';
  static const datatypeBooleano = 'booleano';
  static const datatypeBool = 'bool';
  static const datatypeDouble = 'double';
  static const datatypeFloat = 'float';
  static const datatypeNumeroReal = 'número real';

  // ---------------------------------------------------------------------------
  // Singularizer Suffixes
  // ---------------------------------------------------------------------------
  static const suffixIones = 'iones';
  static const suffixIon = 'ión';
  static const suffixAnes = 'anes';
  static const suffixAn = 'án';
  static const suffixEnes = 'enes';
  static const suffixEn = 'én';
  static const suffixCes = 'ces';
  static const suffixZ = 'z';
  static const suffixLes = 'les';
  static const suffixRes = 'res';
  static const suffixDes = 'des';
  static const suffixNes = 'nes';
  static const suffixEs = 'es';
  static const suffixTes = 'tes';
  static const suffixQues = 'ques';
  static const suffixGues = 'gues';
  static const suffixSes = 'ses';
  static const suffixS = 's';
  static const suffixSs = 'ss';
  static const suffixIs = 'is';
  static const suffixUs = 'us';

  // ---------------------------------------------------------------------------
  // Delimiters & Separators
  // ---------------------------------------------------------------------------
  static const pipeWithSpaces = ' | ';
  static const dashWithSpaces = ' - ';
  static const openParen = '(';
  static const closeParen = ')';
  static const openParenSpace = ' (';
  static const closeParenOpenParen = ') (';
  static const closeParenDot = ').';
  static const underscore = '_';
  static const doubleQuote = '"';
  static const singleQuote = "'";
  static const amp = '&';
  static const wordBoundary = r'\b';

  // ---------------------------------------------------------------------------
  // Numismatics Parser Keywords & Patterns
  // ---------------------------------------------------------------------------
  static const numisCoinKeyword = 'moneda';
  static const numisBanknoteKeyword = 'billete';
  static const numisNumismaticKeyword = 'numismátic';
  static const regexIllegalFileNameChars = r'[\\/:*?"<>|]';
  static const regexParenthesizedEndYear = r'\(([^)]+)\)\s*$';
  static const regexSpaceMexicanos = r'\s+mexicanos?';
  static const regexSpaceEstadounidenses = r'\s+estadounidenses?';
  static const regexSpaceCanadienses = r'\s+canadienses?';
  static const regexSpaceColombianos = r'\s+colombianos?';
  static const regexSpaceChilenos = r'\s+chilenos?';
  static const regexSpaceArgentinos = r'\s+argentinos?';
  static const regexSpaceCubanos = r'\s+cubanos?';
  static const regexSpaceDominicanos = r'\s+dominicanos?';

  // ---------------------------------------------------------------------------
  // Product Lookup Endpoints, Keys & Regexes
  // ---------------------------------------------------------------------------
  static const isbnPrefix978 = '978';
  static const isbnPrefix979 = '979';
  static const endpointGoogleBooksIsbn = 'https://www.googleapis.com/books/v1/volumes?q=isbn:';
  static const endpointOpenLibraryIsbnPrefix = 'https://openlibrary.org/api/books?bibkeys=ISBN:';
  static const endpointOpenLibraryIsbnSuffix = '&format=json&jscmd=data';
  static const endpointOpenFactsPrefix = 'https://';
  static const endpointOpenFactsProductPath = '/api/v2/product/';
  static const endpointOpenFactsProductExt = '.json';
  static const endpointUpcItemDbLookup = 'https://api.upcitemdb.com/prod/trial/lookup?upc=';
  static const endpointDuckDuckGoHtml = 'https://html.duckduckgo.com/html/?q=';
  static const endpointDuckDuckGoSearch = 'https://duckduckgo.com/?q=';
  static const endpointDuckDuckGoImageSearch = 'https://duckduckgo.com/i.js?q=';
  static const endpointDuckDuckGoImageParams = '&o=json&vqd=';
  static const endpointWikiCommonsSearch = 'https://en.wikipedia.org/w/api.php?action=query&format=json&prop=pageimages&piprop=original&generator=search&gsrsearch=';
  static const endpointWikiCommonsLimit = '&gsrlimit=8';

  static const domainOpenFoodFacts = 'world.openfoodfacts.org';
  static const domainOpenBeautyFacts = 'world.openbeautyfacts.org';
  static const domainOpenProductsFacts = 'world.openproductsfacts.org';
  static const domainOpenPetFoodFacts = 'world.openpetfoodfacts.org';

  static const userAgentDesktop = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36';

  static const keyItems = 'items';
  static const keyVolumeInfo = 'volumeInfo';
  static const keyAuthors = 'authors';
  static const keyPublisher = 'publisher';
  static const keyImageLinks = 'imageLinks';
  static const keyThumbnail = 'thumbnail';
  static const keySmallThumbnail = 'smallThumbnail';
  static const keyCover = 'cover';
  static const keyLarge = 'large';
  static const keyMedium = 'medium';
  static const keyProduct = 'product';
  static const keyProductName = 'product_name';
  static const keyProductNameEs = 'product_name_es';
  static const keyAbbreviatedProductName = 'abbreviated_product_name';
  static const keyBrands = 'brands';
  static const keyCategories = 'categories';
  static const keyGenericName = 'generic_name';
  static const keyCategory = 'category';
  static const keyImages = 'images';
  static const keyImageFrontUrl = 'image_front_url';
  static const keyImageFrontLargeUrl = 'image_front_large_url';
  static const keyImageUrl = 'image_url';
  static const keyNutrition = 'nutrition';
  static const keyIngredients = 'ingredients';
  static const keyResults = 'results';
  static const keyImage = 'image';
  static const keyQuery = 'query';
  static const keyPages = 'pages';
  static const keyOriginal = 'original';
  static const prefixIsbnKey = 'ISBN:';

  static const tokenVqd = 'vqd';

  static const regexDuckDuckGoResultLink = r'<a class="result__a"[^>]*>(.*?)<\/a>';
  static const regexHtmlTags = r'<[^>]*>';
  static const regexVqdDoubleQuotes = r'vqd="([^"]+)"';
  static const regexVqdSingleQuotes = r"vqd=([^'\s]+)";

  static const extSvg = '.svg';
  static const extAvif = '.avif';
  static const dataImagePrefix = 'data:image';
  static const httpPrefix = 'http';
  static const httpProtocol = 'http:';
  static const httpsProtocol = 'https:';
  static const htmlEntityQuot = '&quot;';
  static const htmlEntityAmp = '&amp;';
  static const htmlEntityApos = '&#39;';
  static const siteDuckDuckGo = 'duckduckgo';

  // ---------------------------------------------------------------------------
  // Perishability Inference Engine — Regexes
  // ---------------------------------------------------------------------------
  static const regexGs1ParenExpiration = r'\((?:17|15)\)(\d{2})(\d{2})(\d{2})';
  static const regexGs1StructuredExpiration = r'^(?:01\d{14})?(?:17|15)(\d{2})(\d{2})(\d{2})';
  static const regexGs1StripSpacesDashes = r'[\s\-]';

  // ---------------------------------------------------------------------------
  // Perishability Inference Engine — Non-perishable keywords (technology)
  // ---------------------------------------------------------------------------
  static const List<String> nonPerishableKeywordsElectronics = [
    'monitor', 'teclado', 'mouse', 'ratón', 'celular', 'smartphone', 'iphone', 'samsung',
    'laptop', 'computadora', 'cable', 'cargador', 'audífonos', 'headset', 'pantalla', 'tv',
    'televisión', 'martillo', 'destornillador', 'tornillo', 'taladro', 'herramienta',
    'mueble', 'silla', 'mesa', 'escritorio', 'estante', 'camisa', 'pantalón', 'zapato',
    'tenis', 'ropa', 'vestido', 'libro', 'cuaderno', 'libreta', 'pluma', 'bolígrafo',
    'vaso', 'taza', 'plato', 'sartén', 'olla', 'mochila', 'bolsa',
  ];

  // ---------------------------------------------------------------------------
  // Perishability Inference Engine — Perishable keyword groups
  // ---------------------------------------------------------------------------
  static const List<String> perishableKeywordsDairy = [
    'leche', 'lait', 'milk', 'yogur', 'yogurt', 'queso', 'crema', 'mantequilla', 'kefir',
  ];
  static const List<String> perishableKeywordsBakery = [
    'pan', 'bread', 'torta', 'pastel', 'galleta', 'panqueque', 'donas',
  ];
  static const List<String> perishableKeywordsFruitVeg = [
    'manzana', 'plátano', 'banana', 'jitomate', 'tomate', 'lechuga',
    'aguacate', 'fresa', 'uva', 'fruta', 'verdura',
  ];
  static const List<String> perishableKeywordsMeat = [
    'carne', 'pollo', 'pescado', 'jamón', 'salchicha', 'pavo', 'tocino', 'meat', 'chicken',
  ];
  static const List<String> perishableKeywordsBeverages = [
    'jugo', 'zumo', 'juice', 'batido', 'cerveza', 'beer',
  ];
  static const List<String> perishableKeywordsPharmacy = [
    'medicamento', 'jarabe', 'pastillas', 'antibiótico', 'suero', 'medicina', 'pharmacy',
  ];
  static const List<String> perishableKeywordsCanned = [
    'atún en lata', 'enlatado', 'conserva', 'mermelada', 'canned',
  ];

  // ---------------------------------------------------------------------------
  // Taxonomy Chain — Regex Patterns for NLP Cleanup
  // ---------------------------------------------------------------------------
  static const regexUnitsStrip = r'\b\d+(\.\d+)?\s*(ml|l|g|kg|gb|tb|mb|hz|v|w|in|mm|cm|m|k|p|fps)\b';
  static const regexYearNumberStrip = r'\b\d{2,4}[a-z]*\b';
  static const regexNonAlphaNumeric = r'[^\w\s\u00C0-\u017F]';
  static const regexMultipleSpaces = r'\s+';
  static const taxonomyDepartmentGeneral = 'General';

  // ---------------------------------------------------------------------------
  // Numismatic Domain Rules — Technical Keys
  // ---------------------------------------------------------------------------
  static const numisGenericSubspeciesKind = 'genérica';
  static String numisSubspeciesKey(String speciesId, String normTitle) => '${speciesId}_$normTitle';
  static const extJpgNoExt = 'jpg';

  // ---------------------------------------------------------------------------
  // Camera Capture — Technical Keys
  // ---------------------------------------------------------------------------
  static const camSideAnverso = 'anverso';
  static const camSideReverso = 'reverso';
  static const camExtCroppedJpg = '_cropped.jpg';
  static const camRegexImageExt = r'\.(jpg|jpeg|png)$';
  static const defaultInitialQuantity = '1';

  // ---------------------------------------------------------------------------
  // Effective Entity Group
  // ---------------------------------------------------------------------------
  static const prefixContainer = 'container_';
  static const keyRoot = 'root';
  static const keyGeneric = 'generic';
  static String containerEntityKey(String entityId) => '$prefixContainer$entityId';
  static String magnitudePropertySignature(String propertyName, String displayValue) => '$propertyName:$displayValue';
  static String entityGroupKey(String speciesId, String? locId, String subId, String magSig, String notesKey) =>
      '${speciesId}_${locId ?? keyRoot}_${subId}_${magSig}_$notesKey';
  static String relationKey(String id, String sourceId, String targetId, String type) =>
      '${id}_${sourceId}_${targetId}_$type';
  static String requirementKey(String id, String speciesId, double quantity, String? notes) =>
      '${id}_${speciesId}_${quantity}_${notes ?? empty}';
  static String propertyNameWithUnitKey(String name, String? unit) =>
      '${name}_${unit ?? empty}';
}




/// Organized namespace for Routes.
abstract final class AppTechnicalRoutes {
  static const root = AppTechnicalStrings.root;
  static const catalog = AppTechnicalStrings.catalog;
  static const catalogDetail = AppTechnicalStrings.catalogDetail;
  static const catalogPrefix = AppTechnicalStrings.catalogPrefix;
  static const locations = AppTechnicalStrings.locations;
  static const entities = AppTechnicalStrings.entities;
  static const entityDetail = AppTechnicalStrings.entityDetail;
  static const entityDetailLegacy = AppTechnicalStrings.entityDetailLegacy;
  static const entityPrefix = AppTechnicalStrings.entityPrefix;
  static const controlCenter = AppTechnicalStrings.controlCenter;
  static const settings = AppTechnicalStrings.settings;
  static const search = AppTechnicalStrings.search;
  static const register = AppTechnicalStrings.register;
  static const inventory = AppTechnicalStrings.inventory;
  static const notifications = AppTechnicalStrings.notifications;
  static const history = AppTechnicalStrings.history;
  static const paramId = AppTechnicalStrings.paramId;
  static const paramFocusNodeId = AppTechnicalStrings.paramFocusNodeId;
  static const paramLocationId = AppTechnicalStrings.paramLocationId;
  static const paramContainerId = AppTechnicalStrings.paramContainerId;
  static const paramSpeciesId = AppTechnicalStrings.paramSpeciesId;
  static const paramFilter = AppTechnicalStrings.paramFilter;
  static const paramQ = AppTechnicalStrings.paramQ;
  static const paramScope = AppTechnicalStrings.paramScope;
  static const paramInitialLocationId = AppTechnicalStrings.paramInitialLocationId;
  static const paramStartInCreateSpecies = AppTechnicalStrings.paramStartInCreateSpecies;
  static String entityDetailPath(String id) => AppTechnicalStrings.entityDetailPath(id);
  static String catalogDetailPath(String id) => AppTechnicalStrings.catalogDetailPath(id);
}

/// Organized namespace for Database Tables, Columns and Relations.
abstract final class AppTechnicalDb {
  static const tableSpecies = AppTechnicalStrings.tableSpecies;
  static const tableSubspecies = AppTechnicalStrings.tableSubspecies;
  static const tableEntities = AppTechnicalStrings.tableEntities;
  static const tableLocations = AppTechnicalStrings.tableLocations;
  static const tableRelations = AppTechnicalStrings.tableRelations;
  static const tableRequirements = AppTechnicalStrings.tableRequirements;
  static const tableAttachments = AppTechnicalStrings.tableAttachments;
  static const tableAttributes = AppTechnicalStrings.tableAttributes;
  static const tableActivityLogs = AppTechnicalStrings.tableActivityLogs;
  static const tableSqlPresets = AppTechnicalStrings.tableSqlPresets;
  static const tableAppSettings = AppTechnicalStrings.tableAppSettings;
  static const tableNotifications = AppTechnicalStrings.tableNotifications;
  static const tableSpeciesMagnitudes = AppTechnicalStrings.tableSpeciesMagnitudes;
  static const tableInstanceMagnitudes = AppTechnicalStrings.tableInstanceMagnitudes;
  static const tableInstanceLocations = AppTechnicalStrings.tableInstanceLocations;
  static const tableHistoryEvents = AppTechnicalStrings.tableHistoryEvents;
  static const tableCustomTemplates = AppTechnicalStrings.tableCustomTemplates;
  static const tableIgnoredAuditCards = AppTechnicalStrings.tableIgnoredAuditCards;


  static const colId = AppTechnicalStrings.colId;
  static const colName = AppTechnicalStrings.colName;
  static const colType = AppTechnicalStrings.colType;
  static const colCreatedAt = AppTechnicalStrings.colCreatedAt;
  static const colUpdatedAt = AppTechnicalStrings.colUpdatedAt;
  static const colSpeciesId = AppTechnicalStrings.colSpeciesId;
  static const colSubspeciesId = AppTechnicalStrings.colSubspeciesId;
  static const colLocationId = AppTechnicalStrings.colLocationId;
  static const colParentLocationId = AppTechnicalStrings.colParentLocationId;
  static const colDescription = AppTechnicalStrings.colDescription;
  static const colNotes = AppTechnicalStrings.colNotes;
  static const colExpirationDate = AppTechnicalStrings.colExpirationDate;
  static const colSourceEntityId = AppTechnicalStrings.colSourceEntityId;
  static const colTargetEntityId = AppTechnicalStrings.colTargetEntityId;
  static const colRelationType = AppTechnicalStrings.colRelationType;
  static const colInstanceId = AppTechnicalStrings.colInstanceId;
  static const colEntityId = AppTechnicalStrings.colEntityId;
  static const colEntityA = AppTechnicalStrings.colEntityA;
  static const colEntityB = AppTechnicalStrings.colEntityB;
  static const colPropertyName = AppTechnicalStrings.colPropertyName;
  static const colDataType = AppTechnicalStrings.colDataType;
  static const colMagnitudeValue = AppTechnicalStrings.colMagnitudeValue;
  static const colUnitSymbol = AppTechnicalStrings.colUnitSymbol;
  static const colBrand = AppTechnicalStrings.colBrand;
  static const colBarcode = AppTechnicalStrings.colBarcode;
  static const colSubspeciesName = AppTechnicalStrings.colSubspeciesName;
  static const colIsUnique = AppTechnicalStrings.colIsUnique;
  static const colIsNonPerishable = AppTechnicalStrings.colIsNonPerishable;
  static const colDirectLocationId = AppTechnicalStrings.colDirectLocationId;
  static const colContainerId = AppTechnicalStrings.colContainerId;
  static const colSpecies = AppTechnicalStrings.colSpecies;
  static const colSpeciesName = AppTechnicalStrings.colSpeciesName;
  static const colInstanceCount = AppTechnicalStrings.colInstanceCount;

  static const relGuardadoEn = AppTechnicalStrings.relGuardadoEn;
  static const relPerteneceA = AppTechnicalStrings.relPerteneceA;
  static const relNecesita = AppTechnicalStrings.relNecesita;
  static const relParteDe = AppTechnicalStrings.relParteDe;
}

/// Organized namespace for SQL Pragmas and Statements.
abstract final class AppTechnicalSql {
  static const pragmaForeignKeysOn = AppTechnicalStrings.pragmaForeignKeysOn;
  static const pragmaForeignKeysOff = AppTechnicalStrings.pragmaForeignKeysOff;
  static const pragmaIntegrityCheck = AppTechnicalStrings.pragmaIntegrityCheck;
  static const pragmaQuickCheck = AppTechnicalStrings.pragmaQuickCheck;
  static const keywordSelect = AppTechnicalStrings.sqlKeywordSelect;
  static const keywordInsert = AppTechnicalStrings.sqlKeywordInsert;
  static const keywordUpdate = AppTechnicalStrings.sqlKeywordUpdate;
  static const keywordDelete = AppTechnicalStrings.sqlKeywordDelete;
  static const keywordDrop = AppTechnicalStrings.sqlKeywordDrop;
  static const keywordAlter = AppTechnicalStrings.sqlKeywordAlter;
  static const keywordCreate = AppTechnicalStrings.sqlKeywordCreate;
  static const keywordReplace = AppTechnicalStrings.sqlKeywordReplace;
  static const keywordTruncate = AppTechnicalStrings.sqlKeywordTruncate;
  static const keywordLimit = AppTechnicalStrings.sqlKeywordLimit;
  static const nullValue = AppTechnicalStrings.sqlNull;
  static const forbiddenKeywords = AppTechnicalStrings.sqlForbiddenKeywords;
  static const defaultSearchSample = AppTechnicalStrings.sqlDefaultSearchSample;
}

/// Organized namespace for DateTime Formats.
abstract final class AppTechnicalDateTimeFormats {
  static const iso8601 = AppTechnicalStrings.iso8601;
  static const dateOnly = AppTechnicalStrings.dateOnly;
  static const dateTimeDisplay = AppTechnicalStrings.dateTimeDisplay;
  static const timeOnly = AppTechnicalStrings.timeOnly;
  static const dateSlash = AppTechnicalStrings.dateSlash;
}

/// Organized namespace for Storage Directories and File Extensions.
abstract final class AppTechnicalStorage {
  static const dirBackups = AppTechnicalStrings.dirBackups;
  static const dirPhotos = AppTechnicalStrings.dirPhotos;
  static const dirAttachments = AppTechnicalStrings.dirAttachments;
  static const dirMedia = AppTechnicalStrings.dirMedia;
  static const dirProductImages = AppTechnicalStrings.dirProductImages;
  static const extDb = AppTechnicalStrings.extDb;
  static const extSqlite = AppTechnicalStrings.extSqlite;
  static const extZip = AppTechnicalStrings.extZip;
  static const extJson = AppTechnicalStrings.extJson;
  static const extPng = AppTechnicalStrings.extPng;
  static const extJpg = AppTechnicalStrings.extJpg;
  static const extJpeg = AppTechnicalStrings.extJpeg;
  static const extPdf = AppTechnicalStrings.extPdf;
  static const dbFileName = AppTechnicalStrings.dbFileName;
  static const backupDatabaseFileName = AppTechnicalStrings.backupDatabaseFileName;
  static const backupManifestFile = AppTechnicalStrings.backupManifestFile;
  static const schemeFile = AppTechnicalStrings.schemeFile;
  static const schemeHttp = AppTechnicalStrings.schemeHttp;
  static const schemeHttps = AppTechnicalStrings.schemeHttps;
  static const prefixAssets = AppTechnicalStrings.prefixAssets;
}

/// Organized namespace for Network MIME Types and Headers.
abstract final class AppTechnicalNetwork {
  static const mimeJson = AppTechnicalStrings.mimeJson;
  static const mimeZip = AppTechnicalStrings.mimeZip;
  static const mimeOctetStream = AppTechnicalStrings.mimeOctetStream;
  static const headerContentType = AppTechnicalStrings.headerContentType;
  static const headerUserAgent = AppTechnicalStrings.headerUserAgent;
}

/// Organized namespace for Notification Channels, Payloads, Types, and Actions.
abstract final class AppTechnicalNotifications {
  static const channelId = AppTechnicalStrings.channelId;
  static const channelName = AppTechnicalStrings.channelName;
  static const payloadEntityId = AppTechnicalStrings.payloadEntityId;
  static const actionSnooze = AppTechnicalStrings.actionSnooze;
  static const notifTypeExpired = AppTechnicalStrings.notifTypeExpired;
  static const notifTypeExpiringSoon = AppTechnicalStrings.notifTypeExpiringSoon;
  static const notifTypeUnsatisfiedNeed = AppTechnicalStrings.notifTypeUnsatisfiedNeed;
  static const notifStatusActive = AppTechnicalStrings.notifStatusActive;
  static const notifStatusSnoozed = AppTechnicalStrings.notifStatusSnoozed;
  static const notifStatusDismissed = AppTechnicalStrings.notifStatusDismissed;
  static const notifTargetTypeEntity = AppTechnicalStrings.notifTargetTypeEntity;
  static const notifTargetTypeSpecies = AppTechnicalStrings.notifTargetTypeSpecies;
}

/// Organized namespace for Regular Expression Patterns.
abstract final class AppTechnicalRegexPatterns {
  static const digitsOnly = AppTechnicalStrings.digitsOnly;
  static const isoDatePattern = AppTechnicalStrings.isoDatePattern;
  static const decimalPattern = AppTechnicalStrings.decimalPattern;
  static const regexWordBoundary = AppTechnicalStrings.regexWordBoundary;
}

/// Organized namespace for JSON Schema Keys.
abstract final class AppTechnicalJsonKeys {
  static const keyVersion = AppTechnicalStrings.keyVersion;
  static const keyExportedAt = AppTechnicalStrings.keyExportedAt;
  static const keyTables = AppTechnicalStrings.keyTables;
  static const keyData = AppTechnicalStrings.keyData;
  static const keyMetadata = AppTechnicalStrings.keyMetadata;
  static const keyParentLocationId = AppTechnicalStrings.keyParentLocationId;
  static const keyIcon = AppTechnicalStrings.keyIcon;
  static const keyCreatedAt = AppTechnicalStrings.keyCreatedAt;
  static const keyMainPhotoPath = AppTechnicalStrings.keyMainPhotoPath;
  static const keyCustomAttributes = AppTechnicalStrings.keyCustomAttributes;
  static const keyIsUnique = AppTechnicalStrings.keyIsUnique;
  static const keyIsNonPerishable = AppTechnicalStrings.keyIsNonPerishable;
  static const keyDefaultShelfLifeDays = AppTechnicalStrings.keyDefaultShelfLifeDays;
  static const keyWarningDaysBeforeExpiration = AppTechnicalStrings.keyWarningDaysBeforeExpiration;
  static const keySpeciesId = AppTechnicalStrings.keySpeciesId;
  static const keySubspeciesName = AppTechnicalStrings.keySubspeciesName;
  static const keyBrand = AppTechnicalStrings.keyBrand;
  static const keyBarcode = AppTechnicalStrings.keyBarcode;
  static const keyPhotoPath = AppTechnicalStrings.keyPhotoPath;
  static const keyPropertyName = AppTechnicalStrings.keyPropertyName;
  static const keyDataType = AppTechnicalStrings.keyDataType;
  static const keyUnitSymbol = AppTechnicalStrings.keyUnitSymbol;
  static const keySubspeciesId = AppTechnicalStrings.keySubspeciesId;
  static const keyLocationId = AppTechnicalStrings.keyLocationId;
  static const keyExpirationDate = AppTechnicalStrings.keyExpirationDate;
  static const keyUpdatedAt = AppTechnicalStrings.keyUpdatedAt;
  static const keyInstanceId = AppTechnicalStrings.keyInstanceId;
  static const keyMagnitudeValue = AppTechnicalStrings.keyMagnitudeValue;
  static const keyStringValue = AppTechnicalStrings.keyStringValue;
  static const keySourceEntityId = AppTechnicalStrings.keySourceEntityId;
  static const keyTargetEntityId = AppTechnicalStrings.keyTargetEntityId;
  static const keyRelationType = AppTechnicalStrings.keyRelationType;
  static const keyFilePath = AppTechnicalStrings.keyFilePath;
  static const keyFileName = AppTechnicalStrings.keyFileName;
  static const keyFileType = AppTechnicalStrings.keyFileType;
  static const keyEntityId = AppTechnicalStrings.keyEntityId;
  static const keyEventType = AppTechnicalStrings.keyEventType;
  static const keyTimestamp = AppTechnicalStrings.keyTimestamp;
  static const keyTypeName = AppTechnicalStrings.keyTypeName;
  static const keyIconName = AppTechnicalStrings.keyIconName;
  static const keyCommonUnits = AppTechnicalStrings.keyCommonUnits;
  static const keySourceId = AppTechnicalStrings.keySourceId;
  static const keySourceType = AppTechnicalStrings.keySourceType;
  static const keyRequiredSpeciesId = AppTechnicalStrings.keyRequiredSpeciesId;
  static const keyRequiredQuantity = AppTechnicalStrings.keyRequiredQuantity;
  static const keyTitle = AppTechnicalStrings.keyTitle;
  static const keySubtitle = AppTechnicalStrings.keySubtitle;
  static const keyMessage = AppTechnicalStrings.keyMessage;
  static const keyTargetId = AppTechnicalStrings.keyTargetId;
  static const keyTargetType = AppTechnicalStrings.keyTargetType;
  static const keyCardId = AppTechnicalStrings.keyCardId;
  static const keyRuleId = AppTechnicalStrings.keyRuleId;
  static const keyStatus = AppTechnicalStrings.keyStatus;
  static const keySnoozedUntil = AppTechnicalStrings.keySnoozedUntil;
  static const keyKey = AppTechnicalStrings.keyKey;
  static const keyValue = AppTechnicalStrings.keyValue;
  static const keySchemaVersion = AppTechnicalStrings.keySchemaVersion;
  static const keyVersionCheck = AppTechnicalStrings.keyVersionCheck;
}

/// Organized namespace for Database Data Types.
abstract final class AppTechnicalDataTypes {
  static const typeReal = AppTechnicalStrings.typeReal;
  static const typeInteger = AppTechnicalStrings.typeInteger;
  static const typeText = AppTechnicalStrings.typeText;
  static const typeBoolean = AppTechnicalStrings.typeBoolean;
}

/// Organized namespace for Delimiters.
abstract final class AppTechnicalDelimiters {
  static const dot = AppTechnicalStrings.dot;
  static const comma = AppTechnicalStrings.comma;
  static const commaSpace = AppTechnicalStrings.commaSpace;
  static const slash = AppTechnicalStrings.slash;
  static const dash = AppTechnicalStrings.dash;
  static const colon = AppTechnicalStrings.colon;
  static const colonSpace = AppTechnicalStrings.colonSpace;
  static const space = AppTechnicalStrings.space;
  static const bulletSeparator = AppTechnicalStrings.bulletSeparator;
  static const greaterThanWithSpaces = AppTechnicalStrings.greaterThanWithSpaces;
  static const greaterThanTrailing = AppTechnicalStrings.greaterThanTrailing;
  static const atSignWithSpaces = AppTechnicalStrings.atSignWithSpaces;
  static const atSignTrailing = AppTechnicalStrings.atSignTrailing;
  static const empty = AppTechnicalStrings.empty;
}
/// Organized namespace for SI & Unit Constants and Definitions.
abstract final class AppTechnicalUnits {
  static const unitTonne = AppTechnicalStrings.unitTonne;
  static const unitKg = AppTechnicalStrings.unitKg;
  static const unitGram = AppTechnicalStrings.unitGram;
  static const unitMg = AppTechnicalStrings.unitMg;
  static const unitKm = AppTechnicalStrings.unitKm;
  static const unitMeter = AppTechnicalStrings.unitMeter;
  static const unitCm = AppTechnicalStrings.unitCm;
  static const unitMm = AppTechnicalStrings.unitMm;
  static const unitCubicMeter = AppTechnicalStrings.unitCubicMeter;
  static const unitCubicCm = AppTechnicalStrings.unitCubicCm;
  static const unitLiter = AppTechnicalStrings.unitLiter;
  static const unitMl = AppTechnicalStrings.unitMl;
  static const unitSqKm = AppTechnicalStrings.unitSqKm;
  static const unitSqMeter = AppTechnicalStrings.unitSqMeter;
  static const unitSqCm = AppTechnicalStrings.unitSqCm;
  static const unitSecond = AppTechnicalStrings.unitSecond;
  static const unitMinute = AppTechnicalStrings.unitMinute;
  static const unitHour = AppTechnicalStrings.unitHour;
  static const unitYear = AppTechnicalStrings.unitYear;
  static const unitAmpere = AppTechnicalStrings.unitAmpere;
  static const unitMilliampere = AppTechnicalStrings.unitMilliampere;
  static const unitVolt = AppTechnicalStrings.unitVolt;
  static const unitMillivolt = AppTechnicalStrings.unitMillivolt;
  static const unitKilovolt = AppTechnicalStrings.unitKilovolt;
  static const unitOhm = AppTechnicalStrings.unitOhm;
  static const unitKelvin = AppTechnicalStrings.unitKelvin;
  static const unitCelsius = AppTechnicalStrings.unitCelsius;
  static const unitFahrenheit = AppTechnicalStrings.unitFahrenheit;
  static const unitMole = AppTechnicalStrings.unitMole;
  static const unitCandela = AppTechnicalStrings.unitCandela;
  static const unitNewton = AppTechnicalStrings.unitNewton;
  static const unitKilonewton = AppTechnicalStrings.unitKilonewton;
  static const unitPascal = AppTechnicalStrings.unitPascal;
  static const unitKilopascal = AppTechnicalStrings.unitKilopascal;
  static const unitBar = AppTechnicalStrings.unitBar;
  static const unitJoule = AppTechnicalStrings.unitJoule;
  static const unitKilojoule = AppTechnicalStrings.unitKilojoule;
  static const unitCalorie = AppTechnicalStrings.unitCalorie;
  static const unitWatt = AppTechnicalStrings.unitWatt;
  static const unitKilowatt = AppTechnicalStrings.unitKilowatt;
  static const unitMegawatt = AppTechnicalStrings.unitMegawatt;
  static const unitHertz = AppTechnicalStrings.unitHertz;
  static const unitKilohertz = AppTechnicalStrings.unitKilohertz;
  static const unitMegahertz = AppTechnicalStrings.unitMegahertz;
  static const unitGigahertz = AppTechnicalStrings.unitGigahertz;
  static const unitByte = AppTechnicalStrings.unitByte;
  static const unitKb = AppTechnicalStrings.unitKb;
  static const unitMb = AppTechnicalStrings.unitMb;
  static const unitGb = AppTechnicalStrings.unitGb;
  static const unitTb = AppTechnicalStrings.unitTb;
  static const unitDollar = AppTechnicalStrings.unitDollar;
  static const unitUsd = AppTechnicalStrings.unitUsd;
  static const unitMxn = AppTechnicalStrings.unitMxn;
  static const unitEur = AppTechnicalStrings.unitEur;
  static const unitEsp = AppTechnicalStrings.unitEsp;
  static const unitUnidad = AppTechnicalStrings.unitUnidad;

  static const Map<String, SIUnitDefinition> definitions = {
    // Conteo Discreto
    unitUnidad: SIUnitDefinition(symbol: unitUnidad, allowDecimals: false),

    // Masa
    unitTonne: SIUnitDefinition(symbol: unitTonne, allowDecimals: true),
    unitKg: SIUnitDefinition(symbol: unitKg, allowDecimals: true),
    unitGram: SIUnitDefinition(symbol: unitGram, allowDecimals: true),
    unitMg: SIUnitDefinition(symbol: unitMg, allowDecimals: true),

    // Longitud
    unitKm: SIUnitDefinition(symbol: unitKm, allowDecimals: true),
    unitMeter: SIUnitDefinition(symbol: unitMeter, allowDecimals: true),
    unitCm: SIUnitDefinition(symbol: unitCm, allowDecimals: true),
    unitMm: SIUnitDefinition(symbol: unitMm, allowDecimals: true),

    // Volumen
    unitCubicMeter: SIUnitDefinition(symbol: unitCubicMeter, allowDecimals: true),
    unitCubicCm: SIUnitDefinition(symbol: unitCubicCm, allowDecimals: true),
    unitLiter: SIUnitDefinition(symbol: unitLiter, allowDecimals: true),
    unitMl: SIUnitDefinition(symbol: unitMl, allowDecimals: true),

    // Superficie
    unitSqKm: SIUnitDefinition(symbol: unitSqKm, allowDecimals: true),
    unitSqMeter: SIUnitDefinition(symbol: unitSqMeter, allowDecimals: true),
    unitSqCm: SIUnitDefinition(symbol: unitSqCm, allowDecimals: true),

    // Tiempo
    unitSecond: SIUnitDefinition(symbol: unitSecond, allowDecimals: true),
    unitMinute: SIUnitDefinition(symbol: unitMinute, allowDecimals: true),
    unitHour: SIUnitDefinition(symbol: unitHour, allowDecimals: true),
    unitYear: SIUnitDefinition(symbol: unitYear, allowDecimals: false),

    // Electricidad y Magnetismo
    unitAmpere: SIUnitDefinition(symbol: unitAmpere, allowDecimals: true),
    unitMilliampere: SIUnitDefinition(symbol: unitMilliampere, allowDecimals: true),
    unitVolt: SIUnitDefinition(symbol: unitVolt, allowDecimals: true),
    unitMillivolt: SIUnitDefinition(symbol: unitMillivolt, allowDecimals: true),
    unitKilovolt: SIUnitDefinition(symbol: unitKilovolt, allowDecimals: true),
    unitOhm: SIUnitDefinition(symbol: unitOhm, allowDecimals: true),

    // Temperatura
    unitKelvin: SIUnitDefinition(symbol: unitKelvin, allowDecimals: true),
    unitCelsius: SIUnitDefinition(symbol: unitCelsius, allowDecimals: true),
    unitFahrenheit: SIUnitDefinition(symbol: unitFahrenheit, allowDecimals: true),

    // Cantidad de sustancia e Intensidad luminosa
    unitMole: SIUnitDefinition(symbol: unitMole, allowDecimals: true),
    unitCandela: SIUnitDefinition(symbol: unitCandela, allowDecimals: true),

    // Fuerza y Presión
    unitNewton: SIUnitDefinition(symbol: unitNewton, allowDecimals: true),
    unitKilonewton: SIUnitDefinition(symbol: unitKilonewton, allowDecimals: true),
    unitPascal: SIUnitDefinition(symbol: unitPascal, allowDecimals: true),
    unitKilopascal: SIUnitDefinition(symbol: unitKilopascal, allowDecimals: true),
    unitBar: SIUnitDefinition(symbol: unitBar, allowDecimals: true),

    // Energía, Potencia y Frecuencia
    unitJoule: SIUnitDefinition(symbol: unitJoule, allowDecimals: true),
    unitKilojoule: SIUnitDefinition(symbol: unitKilojoule, allowDecimals: true),
    unitCalorie: SIUnitDefinition(symbol: unitCalorie, allowDecimals: true),
    unitWatt: SIUnitDefinition(symbol: unitWatt, allowDecimals: true),
    unitKilowatt: SIUnitDefinition(symbol: unitKilowatt, allowDecimals: true),
    unitMegawatt: SIUnitDefinition(symbol: unitMegawatt, allowDecimals: true),
    unitHertz: SIUnitDefinition(symbol: unitHertz, allowDecimals: true),
    unitKilohertz: SIUnitDefinition(symbol: unitKilohertz, allowDecimals: true),
    unitMegahertz: SIUnitDefinition(symbol: unitMegahertz, allowDecimals: true),
    unitGigahertz: SIUnitDefinition(symbol: unitGigahertz, allowDecimals: true),

    // Almacenamiento Digital
    unitByte: SIUnitDefinition(symbol: unitByte, allowDecimals: true),
    unitKb: SIUnitDefinition(symbol: unitKb, allowDecimals: true),
    unitMb: SIUnitDefinition(symbol: unitMb, allowDecimals: true),
    unitGb: SIUnitDefinition(symbol: unitGb, allowDecimals: true),
    unitTb: SIUnitDefinition(symbol: unitTb, allowDecimals: true),

    // Financiero y Monetario
    unitDollar: SIUnitDefinition(symbol: unitDollar, allowDecimals: true),
    unitUsd: SIUnitDefinition(symbol: unitUsd, allowDecimals: true),
    unitMxn: SIUnitDefinition(symbol: unitMxn, allowDecimals: true),
    unitEur: SIUnitDefinition(symbol: unitEur, allowDecimals: true),
    unitEsp: SIUnitDefinition(symbol: unitEsp, allowDecimals: true),
  };

  static const List<String> discreteUnits = [unitUnidad];
  static const List<String> massUnits = [unitTonne, unitKg, unitGram, unitMg];
  static const List<String> lengthUnits = [unitKm, unitMeter, unitCm, unitMm];
  static const List<String> volumeUnits = [unitCubicMeter, unitCubicCm, unitLiter, unitMl];
  static const List<String> areaUnits = [unitSqKm, unitSqMeter, unitSqCm];
  static const List<String> timeUnits = [unitSecond, unitMinute, unitHour, unitYear];
  static const List<String> electricalUnits = [unitAmpere, unitMilliampere, unitVolt, unitMillivolt, unitKilovolt, unitOhm];
  static const List<String> temperatureUnits = [unitKelvin, unitCelsius, unitFahrenheit];
  static const List<String> substanceAndLightUnits = [unitMole, unitCandela];
  static const List<String> forceAndPressureUnits = [unitNewton, unitKilonewton, unitPascal, unitKilopascal, unitBar];
  static const List<String> energyAndPowerUnits = [unitJoule, unitKilojoule, unitCalorie, unitWatt, unitKilowatt, unitMegawatt, unitHertz, unitKilohertz, unitMegahertz, unitGigahertz];
  static const List<String> digitalUnits = [unitByte, unitKb, unitMb, unitGb, unitTb];
  static const List<String> financialUnits = [unitDollar, unitUsd, unitMxn, unitEur, unitEsp];

  static List<String> get allSiUnits => [
        ...discreteUnits,
        ...massUnits,
        ...lengthUnits,
        ...volumeUnits,
        ...areaUnits,
        ...timeUnits,
        ...electricalUnits,
        ...temperatureUnits,
        ...substanceAndLightUnits,
        ...forceAndPressureUnits,
        ...energyAndPowerUnits,
        ...digitalUnits,
        ...financialUnits,
      ];
}

/// Organized namespace for Spanish Singularizer Linguistic Rules & Mappings.
abstract final class AppTechnicalSpanishSingularizer {
  static const Map<String, String> explicitPluralToSingular = {
    'audífonos': 'Audífono',
      'audifonos': 'Audífono',
      'tomates': 'Tomate',
      'jabones': 'Jabón',
      'papas': 'Papa',
      'galletas': 'Galleta',
      'chocolates': 'Chocolate',
      'limpiadores': 'Limpiador',
      'detergentes': 'Detergente',
      'suavizantes': 'Suavizante',
      'desinfectantes': 'Desinfectante',
      'cables': 'Cable',
      'cargadores': 'Cargador',
      'adaptadores': 'Adaptador',
      'monitores': 'Monitor',
      'televisores': 'Televisor',
      'pantallas': 'Pantalla',
      'impresoras': 'Impresora',
      'bocinas': 'Bocina',
      'auriculares': 'Auricular',
      'dulces': 'Dulce',
      'botanas': 'Botana',
      'refrescos': 'Refresco',
      'jugos': 'Jugo',
      'cervezas': 'Cerveza',
      'vinos': 'Vino',
      'licores': 'Licor',
      'pastas': 'Pasta',
      'salsas': 'Salsa',
      'aceites': 'Aceite',
      'sartenes': 'Sartén',
      'ollas': 'Olla',
      'vasos': 'Vaso',
      'tazas': 'Taza',
      'herramientas': 'Herramienta',
      'taladros': 'Taladro',
      'martillos': 'Martillo',
      'pinzas': 'Pinza',
      'llaves': 'Llave',
      'tenis': 'Tenis',
      'zapatos': 'Zapato',
      'botas': 'Bota',
      'playeras': 'Playera',
      'camisas': 'Camisa',
      'pantalones': 'Pantalón',
      'sudaderas': 'Sudadera',
      'pañales': 'Pañal',
      'panales': 'Pañal',
      'toallitas': 'Toallita',
      'juguetes': 'Juguete',
      'muñecas': 'Muñeca',
      'croquetas': 'Croqueta',
      'cuadernos': 'Cuaderno',
      'plumas': 'Pluma',
      'marcadores': 'Marcador',
      'carpetas': 'Carpeta',
      'libros': 'Libro',
      'lápices': 'Lápiz',
      'lapices': 'Lápiz',
      'luces': 'Luz',
      'peces': 'Pez',
      'nueces': 'Nuez',
  };

  static const Set<String> invariableNouns = {
    'tenis', 'paraguas', 'abrelatas', 'sacapuntas', 'cortauñas',
      'crisis', 'virus', 'atlas', 'análisis', 'oasis', 'status', 'campus'
  };
}

/// Organized namespace for Brand Dictionaries and Product Family Mappings.
abstract final class AppTechnicalBrands {
  static const List<String> allBrands = [
    // Electrónica, Cómputo y Fotografía
    'Samsung', 'Dell', 'Gigabyte', 'Logitech', 'Sony', 'Apple', 'Asus', 'HP', 'Lenovo',
    'LG', 'Nvidia', 'AMD', 'Microsoft', 'Intel', 'Acer', 'MSI', 'Corsair', 'Razer',
    'HyperX', 'Kingston', 'Western Digital', 'Seagate', 'SanDisk', 'Crucial', 'EVGA',
    'Zotac', 'ASRock', 'TP-Link', 'Netgear', 'Linksys', 'Canon', 'Nikon', 'Fujifilm',
    'GoPro', 'DJI', 'Bose', 'Sennheiser', 'Audio-Technica', 'JBL', 'Sonos', 'Anker',
    'Belkin', 'Baseus', 'UGreen', 'Xiaomi', 'Motorola', 'Huawei', 'OnePlus', 'Google',
    'Realme', 'Oppo', 'Vivo', 'TCL', 'Hisense', 'Vizio', 'BenQ', 'ViewSonic', 'AOC',

    // Gaming y Consolas
    'PlayStation', 'Xbox', 'Nintendo', 'Steam Deck', 'SteelSeries', 'Turtle Beach',
    'Astro', 'Scuf', '8BitDo', 'HORI', 'Redragon', 'Cougar', 'Thermaltake',

    // Cuidado Personal, Salud, Belleza y Farmacia
    'NeilMed', 'Dove', 'Colgate', 'Nivea', 'Palmolive', 'Pantene', 'Head & Shoulders',
    'L\'Oréal', 'Garnier', 'Neutrogena', 'Cetaphil', 'CeraVe', 'Rexona', 'Axe',
    'Old Spice', 'Gillette', 'Oral-B', 'Sensodyne', 'Listerine', 'Vicks', 'Bayer',
    'Tylenol', 'Advil', 'Genomma Lab', 'Caprice', 'Savilé', 'Sedal', 'Eucerin',
    'Avène', 'La Roche-Posay', 'Maybelline', 'MAC', 'Revlon', 'Natura', 'Avon',

    // Alimentos, Bebidas y Abarrotes
    'Coca-Cola', 'Pepsi', 'Nestlé', 'Nescafé', 'Bimbo', 'Sabritas', 'Barcel', 'Gamesa',
    'Marinela', 'Knorr', 'Herdez', 'La Costeña', 'Del Monte', 'McCormick', 'Alpura',
    'Lala', 'Nutri', 'Danone', 'Activia', 'Yakult', 'Sigma', 'Fud', 'Sabori', 'San Rafael',
    'Zwan', 'Bafar', 'Great Value', 'Member\'s Mark', 'Kirkland', 'Kellogg\'s', 'Quaker',
    'M&M\'s', 'Snickers', 'Milky Way', 'Hershey\'s', 'Ferrero', 'Kinder', 'Corona',
    'Victoria', 'Modelo', 'Heineken', 'Tecate', 'Dos Equis', 'Jack Daniel\'s', 'Red Bull',
    'Monster', 'Electrolit', 'Gatorade', 'Bonafont', 'Epura', 'Ciel',

    // Hogar, Limpieza y Electrodomésticos
    'Ninja', 'Oster', 'Black+Decker', 'Hamilton Beach', 'T-fal', 'Cuisinart', 'KitchenAid',
    'NutriBullet', 'Mabe', 'Whirlpool', 'Maytag', 'Frigidaire', 'Electrolux', 'Dyson',
    'iRobot', 'Clorox', 'Fabuloso', 'Pinol', 'Ariel', 'Ace', 'Downy', 'Suavitel', 'Salvo',
    'Dawn', 'Lysol', 'Scotch-Brite', 'Sani-Stik', 'Regio', 'Pétalo', 'Kleenex', 'Charmin',

    // Herramientas, Ferretería y Automotriz
    'DeWalt', 'Milwaukee', 'Makita', 'Bosch', 'Craftsman', 'Stanley', 'Truper', 'Pretul',
    'Ryobi', 'Black & Decker', 'Dremel', 'Stihl', 'Husqvarna', 'Castrol', 'Mobil',
    'Pennzoil', 'Valvoline', 'Motul', 'Bardahl', 'Prestone', 'STP', 'Turtle Wax',
    'Meguiar\'s', 'Michelin', 'Bridgestone', 'Goodyear', 'Continental', 'Pirelli',

    // Ropa, Calzado y Deportes
    'Nike', 'Adidas', 'Puma', 'Under Armour', 'Reebok', 'Asics', 'New Balance', 'Skechers',
    'Vans', 'Converse', 'Levi\'s', 'Tommy Hilfiger', 'Calvin Klein', 'Zara', 'H&M',
    'Gap', 'Columbia', 'The North Face', 'Patagonia', 'Oakley', 'Ray-Ban',

    // Bebés, Juguetes y Mascotas
    'Pampers', 'Huggies', 'Fisher-Price', 'Lego', 'Hasbro', 'Mattel', 'Nerf', 'Barbie',
    'Hot Wheels', 'Pedigree', 'Whiskas', 'Purina', 'Royal Canin', 'Pro Plan', 'Cat Chow',
  ];

  static const Map<String, String> productFamilyToBrand = {
    'dualsense': 'PlayStation',
    'dualshock': 'PlayStation',
    'airpods': 'Apple',
    'macbook': 'Apple',
    'ipad': 'Apple',
    'iphone': 'Apple',
    'galaxy': 'Samsung',
    'thinkpad': 'Lenovo',
    'ideapad': 'Lenovo',
    'alienware': 'Dell',
  };

  static const Map<String, String> accentReplacements = {
    'á': 'a',
    'é': 'e',
    'í': 'i',
    'ó': 'o',
    'ú': 'u',
    'Á': 'A',
    'É': 'E',
    'Í': 'I',
    'Ó': 'O',
    'Ú': 'U',
  };
}

/// Organized namespace for Product Taxonomy Categories.
abstract final class AppTechnicalTaxonomy {
  static const List<CategoryDefinition> definitions = [
    // -------------------------------------------------------------------------
    // 1. ELECTRÓNICA, CÓMPUTO Y COMPONENTES (Especies Atómicas en Singular)
    // -------------------------------------------------------------------------
    CategoryDefinition(
      generalSpeciesName: 'Tarjeta de Video',
      department: 'Electrónica y Cómputo',
      keywords: ['rtx', 'gtx', 'radeon', 'gpu', 'graphics card', 'tarjeta de video', 'tarjeta grafica', 'tarjeta gráfica', 'gddr6', 'gddr6x'],
      regexPatterns: [r'\b(rtx|gtx)\s*\d{3,4}\b', r'\brx\s*\d{3,4}\b'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Procesador',
      department: 'Electrónica y Cómputo',
      keywords: ['ryzen', 'core i3', 'core i5', 'core i7', 'core i9', 'cpu', 'procesador', 'intel core', 'threadripper'],
      regexPatterns: [r'\bi[3579]-\d{4,5}[a-z]*\b', r'\bryzen\s*[3579]\b'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Tarjeta Madre',
      department: 'Electrónica y Cómputo',
      keywords: ['motherboard', 'tarjeta madre', 'placa base', 'am4', 'am5', 'lga1700', 'b550', 'b650', 'z790', 'x670'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Memoria RAM',
      department: 'Electrónica y Cómputo',
      keywords: ['ddr4', 'ddr5', 'memoria ram', 'ram kit', 'sodimm', 'dimm'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Disco Sólido',
      department: 'Electrónica y Cómputo',
      keywords: ['ssd', 'nvme', 'm.2', 'disco solido', 'disco sólido', 'solid state drive'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Disco Duro',
      department: 'Electrónica y Cómputo',
      keywords: ['disco duro', 'hard drive', 'hdd', 'disco externo'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Fuente de Poder',
      department: 'Electrónica y Cómputo',
      keywords: ['fuente de poder', 'power supply', 'psu', '80 plus', 'modular psu'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Gabinete PC',
      department: 'Electrónica y Cómputo',
      keywords: ['pc case', 'gabinete pc', 'chasis pc', 'mid tower', 'full tower'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Enfriamiento PC',
      department: 'Electrónica y Cómputo',
      keywords: ['liquid cooler', 'disipador', 'fan pc', 'ventilador pc', 'aio cooler', 'water cooling'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Monitor',
      department: 'Electrónica y Cómputo',
      keywords: ['monitor', 'pantalla', 'display', 'curved monitor', 'gaming monitor', 'hz monitor'],
      regexPatterns: [r'\b\d{2}"\s*monitor\b', r'\b\d{2}-inch\b'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Laptop',
      department: 'Electrónica y Cómputo',
      keywords: ['laptop', 'notebook', 'macbook', 'portatil', 'portátil', 'chromebook', 'ultrabook', 'thinkpad', 'zenbook', 'ideapad', 'pavilion'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Computadora de Escritorio',
      department: 'Electrónica y Cómputo',
      keywords: ['desktop', 'computadora de escritorio', 'all in one', 'imac', 'pc armadas', 'workstation'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Smartphone',
      department: 'Electrónica y Cómputo',
      keywords: ['galaxy a', 'galaxy s', 'iphone', 'pixel', 'smartphone', 'celular', 'telefono', 'teléfono', 'xiaomi redmi', 'motorola edge'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Tablet',
      department: 'Electrónica y Cómputo',
      keywords: ['ipad', 'galaxy tab', 'tablet', 'tableta', 'kindle', 'surface pro'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Televisor',
      department: 'Electrónica y Cómputo',
      keywords: ['smart tv', 'televisor', 'television', 'televisión', 'oled tv', 'qled tv', '4k tv', 'roku tv'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Audífono',
      department: 'Electrónica y Cómputo',
      keywords: ['headphone', 'headset', 'audifono', 'audífono', 'audifonos', 'audífonos', 'earbuds', 'airpods', 'auriculares', 'in-ear', 'over-ear'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Bocina',
      department: 'Electrónica y Cómputo',
      keywords: ['bocina', 'speaker', 'soundbar', 'barra de sonido', 'bocina bluetooth', 'altavoz'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Mouse',
      department: 'Electrónica y Cómputo',
      keywords: ['mouse', 'raton', 'ratón', 'mouse gamer', 'mouse inalambrico'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Teclado',
      department: 'Electrónica y Cómputo',
      keywords: ['keyboard', 'teclado', 'keychron', 'teclado mecanico', 'teclado mecánico', 'teclado gamer'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Cámara',
      department: 'Electrónica y Cómputo',
      keywords: ['cámara', 'camara', 'camera', 'dslr', 'mirrorless', 'webcam', 'camara web', 'gopro', 'action cam'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Impresora',
      department: 'Electrónica y Cómputo',
      keywords: ['impresora', 'printer', 'laserjet', 'ecotank', 'multifuncional', 'impresora 3d', '3d printer'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Router',
      department: 'Electrónica y Cómputo',
      keywords: ['router', 'switch red', 'modem', 'módem', 'repetidor wifi', 'mesh wifi', 'access point'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Cable',
      department: 'Electrónica y Cómputo',
      keywords: ['cable hdmi', 'cable usb', 'cable ethernet', 'cable lightning'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Cargador',
      department: 'Electrónica y Cómputo',
      keywords: ['cargador', 'power bank', 'bateria portable', 'adaptador de corriente'],
    ),

    // -------------------------------------------------------------------------
    // 2. VIDEOJUEGOS Y CONSOLAS
    // -------------------------------------------------------------------------
    CategoryDefinition(
      generalSpeciesName: 'Control de Videojuegos',
      department: 'Videojuegos',
      keywords: ['gamepad', 'controller', 'joy-con', 'controlador', 'control ps5', 'control xbox', 'volante gamer', 'joystick'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Consola de Videojuegos',
      department: 'Videojuegos',
      keywords: ['playstation', 'xbox', 'nintendo switch', 'ps5', 'ps4', 'xbox series', 'steam deck'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Videojuego',
      department: 'Videojuegos',
      keywords: ['juego ps5', 'juego xbox', 'juego nintendo', 'videojuego', 'game disc', 'cartucho nintendo'],
    ),

    // -------------------------------------------------------------------------
    // 3. CUIDADO PERSONAL, SALUD Y BELLEZA (Atómicas Singular)
    // -------------------------------------------------------------------------
    CategoryDefinition(
      generalSpeciesName: 'Lavado Nasal',
      department: 'Salud y Cuidado Personal',
      keywords: ['saline', 'nasal', 'rinse', 'solucion salina nasal', 'lavado nasal'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Medicina',
      department: 'Salud y Cuidado Personal',
      keywords: ['farmacia', 'salud', 'medicina', 'antihistaminico', 'analgesico', 'jarabe', 'pastilla', 'vitamina'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Jabón',
      department: 'Salud y Cuidado Personal',
      keywords: ['jabon', 'jabón', 'body wash', 'jabon liquido', 'jabon barra', 'jabon de tocador', 'jabon corporal'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Champú',
      department: 'Salud y Cuidado Personal',
      keywords: ['shampoo', 'champu', 'champú', 'acondicionador', 'tratamiento capilar'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Pasta Dental',
      department: 'Salud y Cuidado Personal',
      keywords: ['pasta dental', 'crema dental', 'dentrifico'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Cepillo Dental',
      department: 'Salud y Cuidado Personal',
      keywords: ['cepillo de dientes', 'cepillo dental', 'hilo dental', 'enjuague bucal'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Crema Corporal',
      department: 'Salud y Cuidado Personal',
      keywords: ['crema corporal', 'crema humectante', 'locion corporal'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Crema Facial',
      department: 'Salud y Cuidado Personal',
      keywords: ['crema facial', 'suero facial', 'bloqueador solar', 'protector solar'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Desodorante',
      department: 'Salud y Cuidado Personal',
      keywords: ['desodorante', 'antitraspirante', 'antiperspirant', 'roll-on', 'desodorante aerosol'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Perfume',
      department: 'Salud y Cuidado Personal',
      keywords: ['perfume', 'locion', 'loción', 'fragancia', 'eau de parfum', 'eau de toilette', 'body spray'],
    ),

    // -------------------------------------------------------------------------
    // 4. ALIMENTOS Y ABARROTES (Explosión de Especies Atómicas en Singular)
    // -------------------------------------------------------------------------
    CategoryDefinition(
      generalSpeciesName: 'Refresco',
      department: 'Alimentos y Abarrotes',
      keywords: ['coca cola', 'refresco', 'soda', 'pepsi', 'sprite', 'fanta', 'sidral', 'jarrito'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Leche',
      department: 'Alimentos y Abarrotes',
      keywords: ['leche', 'lala', 'alpura', 'nutrileche', 'leche entera', 'leche descremada', 'leche deslactosada'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Huevo',
      department: 'Alimentos y Abarrotes',
      keywords: ['huevo', 'huevos', 'huevo blanco', 'huevo rojo', 'cartera de huevo'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Queso',
      department: 'Alimentos y Abarrotes',
      keywords: ['queso', 'queso panela', 'queso oaxaca', 'queso manchego', 'queso amarillo'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Yogurt',
      department: 'Alimentos y Abarrotes',
      keywords: ['yogurt', 'yogur', 'yogurt griego'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Mantequilla',
      department: 'Alimentos y Abarrotes',
      keywords: ['mantequilla', 'margarina'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Puré de Tomate',
      department: 'Alimentos y Abarrotes',
      keywords: ['pure de tomate', 'puré de tomate', 'tomate molido', 'tomate en pasta'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Tomate',
      department: 'Alimentos y Abarrotes',
      keywords: ['tomate', 'jitomate', 'tomate saladette'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Azúcar',
      department: 'Alimentos y Abarrotes',
      keywords: ['azucar', 'azúcar', 'azucar estandar', 'azucar refinada'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Harina',
      department: 'Alimentos y Abarrotes',
      keywords: ['harina', 'harina de trigo', 'harina de maiz', 'massa'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Arroz',
      department: 'Alimentos y Abarrotes',
      keywords: ['arroz', 'arroz blanco', 'arroz grano largo'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Frijol',
      department: 'Alimentos y Abarrotes',
      keywords: ['frijol', 'frijoles', 'frijol negro', 'frijol pinto', 'frijol peruano'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Aceite Comestible',
      department: 'Alimentos y Abarrotes',
      keywords: ['aceite comestible', 'aceite vegetal', 'aceite de oliva'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Salsa',
      department: 'Alimentos y Abarrotes',
      keywords: ['salsa', 'salsa botanera', 'salsa picante', 'salsa de chile'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Dulce de Chile',
      department: 'Alimentos y Abarrotes',
      keywords: ['chile en polvo', 'dulce de chile', 'polvo picante'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Agua Embotellada',
      department: 'Alimentos y Abarrotes',
      keywords: ['agua purificada', 'agua mineral', 'agua natural', 'garrafon de agua'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Jugo',
      department: 'Alimentos y Abarrotes',
      keywords: ['jugo', 'n nectar', 'néctar', 'jugo de naranja', 'jugo jumex', 'del valle'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Cerveza',
      department: 'Alimentos y Abarrotes',
      keywords: ['cerveza', 'corona', 'modelos', 'victoria', 'heineken', 'tecate'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Café',
      department: 'Alimentos y Abarrotes',
      keywords: ['nescafe', 'nescafé', 'cafe', 'café', 'cafe molido', 'cafe soluble'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Té',
      department: 'Alimentos y Abarrotes',
      keywords: ['té', 'te verde', 'te negro', 'te helado', 'lipton'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Papa Frita',
      department: 'Alimentos y Abarrotes',
      keywords: ['papas fritas', 'sabritas', 'barcel', 'chips', 'ruffles', 'doritos'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Galleta',
      department: 'Alimentos y Abarrotes',
      keywords: ['galleta', 'galletas', 'gamesa', 'marias', 'oreo', 'chokis'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Chocolate',
      department: 'Alimentos y Abarrotes',
      keywords: ['chocolate', 'chocolates', 'carlos v', 'hershey', 'm&m', 'snickers'],
    ),

    // -------------------------------------------------------------------------
    // 5. HOGAR Y LIMPIEZA (Especies Atómicas Singular)
    // -------------------------------------------------------------------------
    CategoryDefinition(
      generalSpeciesName: 'Cloro',
      department: 'Hogar y Limpieza',
      keywords: ['cloro', 'clorox', 'blanqueador', 'cloralex'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Detergente',
      department: 'Hogar y Limpieza',
      keywords: ['detergente', 'ariel', 'ace', 'fabuloso', 'detergente liquido', 'detergente polvo'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Suavizante',
      department: 'Hogar y Limpieza',
      keywords: ['suavizante', 'downy', 'suavitel', 'ensueño'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Lavavajillas',
      department: 'Hogar y Limpieza',
      keywords: ['salvo', 'dawn', 'lavatrastes', 'jabon liquido loza', 'lavavajillas'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Desinfectante',
      department: 'Hogar y Limpieza',
      keywords: ['lysol', 'pinol', 'desinfectante', 'limpiador multiusos'],
    ),

    // -------------------------------------------------------------------------
    // 6. FERRETERÍA Y HERRAMIENTAS (Especies Atómicas Singular)
    // -------------------------------------------------------------------------
    CategoryDefinition(
      generalSpeciesName: 'Taladro',
      department: 'Herramientas',
      keywords: ['taladro', 'rotomartillo', 'atornillador electrico'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Esmeriladora',
      department: 'Herramientas',
      keywords: ['esmeriladora', 'pulidora', 'esmeril'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Sierra',
      department: 'Herramientas',
      keywords: ['sierra circular', 'sierra caladora', 'sierra de banco'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Martillo',
      department: 'Herramientas',
      keywords: ['martillo', 'marro'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Destornillador',
      department: 'Herramientas',
      keywords: ['destornillador', 'desarmador'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Aceite de Motor',
      department: 'Automotriz',
      keywords: ['aceite de motor', 'aceite sintético', 'castrol', 'mobil 1', 'valvoline'],
    ),
  ];
}

/// Organized namespace for Precompiled Taxonomy Species Registry Items.
abstract final class AppTechnicalTaxonomyRegistry {
  static const List<CompiledSpeciesItem> items = [
    CompiledSpeciesItem(species: 'Taladro', department: 'Herramientas', keywords: ['taladro', 'taladro']),
    CompiledSpeciesItem(species: 'Rotomartillo', department: 'Herramientas', keywords: ['rotomartillo', 'rotomartillo']),
    CompiledSpeciesItem(species: 'Esmeriladora', department: 'Herramientas', keywords: ['esmeriladora', 'esmeriladora']),
    CompiledSpeciesItem(species: 'Sierra Circular', department: 'Herramientas', keywords: ['sierra circular', 'sierra', 'circular']),
    CompiledSpeciesItem(species: 'Sierra Caladora', department: 'Herramientas', keywords: ['sierra caladora', 'sierra', 'caladora']),
    CompiledSpeciesItem(species: 'Sierra de Banco', department: 'Herramientas', keywords: ['sierra de banco', 'sierra', 'banco']),
    CompiledSpeciesItem(species: 'Lijadora', department: 'Herramientas', keywords: ['lijadora', 'lijadora']),
    CompiledSpeciesItem(species: 'Atornillador', department: 'Herramientas', keywords: ['atornillador', 'atornillador']),
    CompiledSpeciesItem(species: 'Martillo', department: 'Herramientas', keywords: ['martillo', 'martillo']),
    CompiledSpeciesItem(species: 'Marro', department: 'Herramientas', keywords: ['marro', 'marro']),
    CompiledSpeciesItem(species: 'Destornillador', department: 'Herramientas', keywords: ['destornillador', 'destornillador']),
    CompiledSpeciesItem(species: 'Desarmador', department: 'Herramientas', keywords: ['desarmador', 'desarmador']),
    CompiledSpeciesItem(species: 'Pinza', department: 'Herramientas', keywords: ['pinza', 'pinza']),
    CompiledSpeciesItem(species: 'Llave Perica', department: 'Herramientas', keywords: ['llave perica', 'llave', 'perica']),
    CompiledSpeciesItem(species: 'Llave Española', department: 'Herramientas', keywords: ['llave española', 'llave', 'española']),
    CompiledSpeciesItem(species: 'Llave Allen', department: 'Herramientas', keywords: ['llave allen', 'llave', 'allen']),
    CompiledSpeciesItem(species: 'Llave Combinada', department: 'Herramientas', keywords: ['llave combinada', 'llave', 'combinada']),
    CompiledSpeciesItem(species: 'Llave de Estriada', department: 'Herramientas', keywords: ['llave de estriada', 'llave', 'estriada']),
    CompiledSpeciesItem(species: 'Flexómetro', department: 'Herramientas', keywords: ['flexómetro', 'flexómetro']),
    CompiledSpeciesItem(species: 'Cinta Métrica', department: 'Herramientas', keywords: ['cinta métrica', 'cinta', 'métrica']),
    CompiledSpeciesItem(species: 'Nivel de Gota', department: 'Herramientas', keywords: ['nivel de gota', 'nivel', 'gota']),
    CompiledSpeciesItem(species: 'Nivel Laser', department: 'Herramientas', keywords: ['nivel laser', 'nivel', 'laser']),
    CompiledSpeciesItem(species: 'Cautín', department: 'Herramientas', keywords: ['cautín', 'cautín']),
    CompiledSpeciesItem(species: 'Pistola de Silicona', department: 'Herramientas', keywords: ['pistola de silicona', 'pistola', 'silicona']),
    CompiledSpeciesItem(species: 'Compresor de Aire', department: 'Herramientas', keywords: ['compresor de aire', 'compresor', 'aire']),
    CompiledSpeciesItem(species: 'Caja de Herramienta', department: 'Herramientas', keywords: ['caja de herramienta', 'caja', 'herramienta']),
    CompiledSpeciesItem(species: 'Organizador de Herramienta', department: 'Herramientas', keywords: ['organizador de herramienta', 'organizador', 'herramienta']),
    CompiledSpeciesItem(species: 'Tornillo', department: 'Herramientas', keywords: ['tornillo', 'tornillo']),
    CompiledSpeciesItem(species: 'Tuerca', department: 'Herramientas', keywords: ['tuerca', 'tuerca']),
    CompiledSpeciesItem(species: 'Rondana', department: 'Herramientas', keywords: ['rondana', 'rondana']),
    CompiledSpeciesItem(species: 'Clavo', department: 'Herramientas', keywords: ['clavo', 'clavo']),
    CompiledSpeciesItem(species: 'Taquete', department: 'Herramientas', keywords: ['taquete', 'taquete']),
    CompiledSpeciesItem(species: 'Pija', department: 'Herramientas', keywords: ['pija', 'pija']),
    CompiledSpeciesItem(species: 'Broca', department: 'Herramientas', keywords: ['broca', 'broca']),
    CompiledSpeciesItem(species: 'Lija', department: 'Herramientas', keywords: ['lija', 'lija']),
    CompiledSpeciesItem(species: 'Cinta Aislar', department: 'Herramientas', keywords: ['cinta aislar', 'cinta', 'aislar']),
    CompiledSpeciesItem(species: 'Cinta Canela', department: 'Herramientas', keywords: ['cinta canela', 'cinta', 'canela']),
    CompiledSpeciesItem(species: 'Carretilla', department: 'Herramientas', keywords: ['carretilla', 'carretilla']),
    CompiledSpeciesItem(species: 'Pala', department: 'Herramientas', keywords: ['pala', 'pala']),
    CompiledSpeciesItem(species: 'Pico', department: 'Herramientas', keywords: ['pico', 'pico']),
    CompiledSpeciesItem(species: 'Rastrillo', department: 'Salud y Cuidado Personal', keywords: ['rastrillo', 'rastrillo']),
    CompiledSpeciesItem(species: 'Machete', department: 'Herramientas', keywords: ['machete', 'machete']),
    CompiledSpeciesItem(species: 'Cincel', department: 'Herramientas', keywords: ['cincel', 'cincel']),
    CompiledSpeciesItem(species: 'Arco de Segueta', department: 'Herramientas', keywords: ['arco de segueta', 'arco', 'segueta']),
    CompiledSpeciesItem(species: 'Segueta', department: 'Herramientas', keywords: ['segueta', 'segueta']),
    CompiledSpeciesItem(species: 'Prensa C', department: 'Herramientas', keywords: ['prensa c', 'prensa']),
    CompiledSpeciesItem(species: 'Cuchilla', department: 'Herramientas', keywords: ['cuchilla', 'cuchilla']),
    CompiledSpeciesItem(species: 'Navaja', department: 'Herramientas', keywords: ['navaja', 'navaja']),
    CompiledSpeciesItem(species: 'Cortador de Azulejo', department: 'Herramientas', keywords: ['cortador de azulejo', 'cortador', 'azulejo']),
    CompiledSpeciesItem(species: 'Esmeril de Banco', department: 'Herramientas', keywords: ['esmeril de banco', 'esmeril', 'banco']),
    CompiledSpeciesItem(species: 'Soldadora', department: 'Herramientas', keywords: ['soldadora', 'soldadora']),
    CompiledSpeciesItem(species: 'Careta de Soldar', department: 'Herramientas', keywords: ['careta de soldar', 'careta', 'soldar']),
    CompiledSpeciesItem(species: 'Mascarilla Respiradora', department: 'Herramientas', keywords: ['mascarilla respiradora', 'mascarilla', 'respiradora']),
    CompiledSpeciesItem(species: 'Guantes de Trabajo', department: 'Herramientas', keywords: ['guantes de trabajo', 'guantes', 'trabajo']),
    CompiledSpeciesItem(species: 'Casco de Seguridad', department: 'Herramientas', keywords: ['casco de seguridad', 'casco', 'seguridad']),
    CompiledSpeciesItem(species: 'Chaleco Reflejante', department: 'Herramientas', keywords: ['chaleco reflejante', 'chaleco', 'reflejante']),
    CompiledSpeciesItem(species: 'Gafas de Protección', department: 'Herramientas', keywords: ['gafas de protección', 'gafas', 'protección']),
    CompiledSpeciesItem(species: 'Aceite de Motor', department: 'Automotriz', keywords: ['aceite de motor', 'aceite', 'motor']),
    CompiledSpeciesItem(species: 'Anticongelante', department: 'Automotriz', keywords: ['anticongelante', 'anticongelante']),
    CompiledSpeciesItem(species: 'Líquido de Frenos', department: 'Automotriz', keywords: ['líquido de frenos', 'líquido', 'frenos']),
    CompiledSpeciesItem(species: 'Líquido de Dirección', department: 'Automotriz', keywords: ['líquido de dirección', 'líquido', 'dirección']),
    CompiledSpeciesItem(species: 'Aditivo de Motor', department: 'Automotriz', keywords: ['aditivo de motor', 'aditivo', 'motor']),
    CompiledSpeciesItem(species: 'Aditivo de Gasolina', department: 'Automotriz', keywords: ['aditivo de gasolina', 'aditivo', 'gasolina']),
    CompiledSpeciesItem(species: 'Llanta', department: 'Automotriz', keywords: ['llanta', 'llanta']),
    CompiledSpeciesItem(species: 'Neumático', department: 'Automotriz', keywords: ['neumático', 'neumático']),
    CompiledSpeciesItem(species: 'Batería de Auto', department: 'Automotriz', keywords: ['batería de auto', 'batería', 'auto']),
    CompiledSpeciesItem(species: 'Cargador de Batería Auto', department: 'Automotriz', keywords: ['cargador de batería auto', 'cargador', 'batería', 'auto']),
    CompiledSpeciesItem(species: 'Funda de Auto', department: 'Automotriz', keywords: ['funda de auto', 'funda', 'auto']),
    CompiledSpeciesItem(species: 'Tapete de Auto', department: 'Automotriz', keywords: ['tapete de auto', 'tapete', 'auto']),
    CompiledSpeciesItem(species: 'Filtro de Aceite', department: 'Automotriz', keywords: ['filtro de aceite', 'filtro', 'aceite']),
    CompiledSpeciesItem(species: 'Filtro de Aire', department: 'Automotriz', keywords: ['filtro de aire', 'filtro', 'aire']),
    CompiledSpeciesItem(species: 'Filtro de Gasolina', department: 'Automotriz', keywords: ['filtro de gasolina', 'filtro', 'gasolina']),
    CompiledSpeciesItem(species: 'Bujía', department: 'Automotriz', keywords: ['bujía', 'bujía']),
    CompiledSpeciesItem(species: 'Limpiaparabrisa', department: 'Automotriz', keywords: ['limpiaparabrisa', 'limpiaparabrisa']),
    CompiledSpeciesItem(species: 'Gato Hidráulico', department: 'Automotriz', keywords: ['gato hidráulico', 'gato', 'hidráulico']),
    CompiledSpeciesItem(species: 'Torre de Soporte Auto', department: 'Automotriz', keywords: ['torre de soporte auto', 'torre', 'soporte', 'auto']),
    CompiledSpeciesItem(species: 'Amortiguador', department: 'Automotriz', keywords: ['amortiguador', 'amortiguador']),
    CompiledSpeciesItem(species: 'Pastilla de Freno', department: 'Automotriz', keywords: ['pastilla de freno', 'pastilla', 'freno']),
    CompiledSpeciesItem(species: 'Disco de Freno', department: 'Automotriz', keywords: ['disco de freno', 'disco', 'freno']),
    CompiledSpeciesItem(species: 'Bomba de Agua Auto', department: 'Automotriz', keywords: ['bomba de agua auto', 'bomba', 'agua', 'auto']),
    CompiledSpeciesItem(species: 'Bomba de Gasolina', department: 'Automotriz', keywords: ['bomba de gasolina', 'bomba', 'gasolina']),
    CompiledSpeciesItem(species: 'Radiador', department: 'Automotriz', keywords: ['radiador', 'radiador']),
    CompiledSpeciesItem(species: 'Faro Auto', department: 'Automotriz', keywords: ['faro auto', 'faro', 'auto']),
    CompiledSpeciesItem(species: 'Calavera Auto', department: 'Automotriz', keywords: ['calavera auto', 'calavera', 'auto']),
    CompiledSpeciesItem(species: 'Pluma Limpiaparabrisa', department: 'Automotriz', keywords: ['pluma limpiaparabrisa', 'pluma', 'limpiaparabrisa']),
    CompiledSpeciesItem(species: 'Cera para Auto', department: 'Automotriz', keywords: ['cera para auto', 'cera', 'para', 'auto']),
    CompiledSpeciesItem(species: 'Shampoo para Auto', department: 'Automotriz', keywords: ['shampoo para auto', 'shampoo', 'para', 'auto']),
    CompiledSpeciesItem(species: 'Grasa Automotriz', department: 'Automotriz', keywords: ['grasa automotriz', 'grasa', 'automotriz']),
    CompiledSpeciesItem(species: 'Sensor de Oxígeno', department: 'Automotriz', keywords: ['sensor de oxígeno', 'sensor', 'oxígeno']),
    CompiledSpeciesItem(species: 'Alternador', department: 'Automotriz', keywords: ['alternador', 'alternador']),
    CompiledSpeciesItem(species: 'Marcha Auto', department: 'Automotriz', keywords: ['marcha auto', 'marcha', 'auto']),
    CompiledSpeciesItem(species: 'Tubo de PVC', department: 'Plomería y Pintura', keywords: ['tubo de pvc', 'tubo', 'pvc']),
    CompiledSpeciesItem(species: 'Tubo de Cobre', department: 'Plomería y Pintura', keywords: ['tubo de cobre', 'tubo', 'cobre']),
    CompiledSpeciesItem(species: 'Tubo CPVC', department: 'Plomería y Pintura', keywords: ['tubo cpvc', 'tubo', 'cpvc']),
    CompiledSpeciesItem(species: 'Tubo Galvanizado', department: 'Plomería y Pintura', keywords: ['tubo galvanizado', 'tubo', 'galvanizado']),
    CompiledSpeciesItem(species: 'Válvula de Paso', department: 'Plomería y Pintura', keywords: ['válvula de paso', 'válvula', 'paso']),
    CompiledSpeciesItem(species: 'Válvula Check', department: 'Plomería y Pintura', keywords: ['válvula check', 'válvula', 'check']),
    CompiledSpeciesItem(species: 'Llave de Agua', department: 'Plomería y Pintura', keywords: ['llave de agua', 'llave', 'agua']),
    CompiledSpeciesItem(species: 'Cinta Teflon', department: 'Plomería y Pintura', keywords: ['cinta teflon', 'cinta', 'teflon']),
    CompiledSpeciesItem(species: 'Pintura Vinílica', department: 'Plomería y Pintura', keywords: ['pintura vinílica', 'pintura', 'vinílica']),
    CompiledSpeciesItem(species: 'Pintura Esmalte', department: 'Plomería y Pintura', keywords: ['pintura esmalte', 'pintura', 'esmalte']),
    CompiledSpeciesItem(species: 'Pintura en Aerosol', department: 'Plomería y Pintura', keywords: ['pintura en aerosol', 'pintura', 'aerosol']),
    CompiledSpeciesItem(species: 'Brocha', department: 'Plomería y Pintura', keywords: ['brocha', 'brocha']),
    CompiledSpeciesItem(species: 'Rodillo', department: 'Plomería y Pintura', keywords: ['rodillo', 'rodillo']),
    CompiledSpeciesItem(species: 'Sellador', department: 'Plomería y Pintura', keywords: ['sellador', 'sellador']),
    CompiledSpeciesItem(species: 'Silicona', department: 'Plomería y Pintura', keywords: ['silicona', 'silicona']),
    CompiledSpeciesItem(species: 'Impermeabilizante', department: 'Plomería y Pintura', keywords: ['impermeabilizante', 'impermeabilizante']),
    CompiledSpeciesItem(species: 'Fregadero', department: 'Plomería y Pintura', keywords: ['fregadero', 'fregadero']),
    CompiledSpeciesItem(species: 'Mezcladora', department: 'Plomería y Pintura', keywords: ['mezcladora', 'mezcladora']),
    CompiledSpeciesItem(species: 'Regadera', department: 'Plomería y Pintura', keywords: ['regadera', 'regadera']),
    CompiledSpeciesItem(species: 'Cespól', department: 'Plomería y Pintura', keywords: ['cespól', 'cespól']),
    CompiledSpeciesItem(species: 'Empaque', department: 'Plomería y Pintura', keywords: ['empaque', 'empaque']),
    CompiledSpeciesItem(species: 'Conector PVC', department: 'Plomería y Pintura', keywords: ['conector pvc', 'conector', 'pvc']),
    CompiledSpeciesItem(species: 'Codo PVC', department: 'Plomería y Pintura', keywords: ['codo pvc', 'codo', 'pvc']),
    CompiledSpeciesItem(species: 'Tee PVC', department: 'Plomería y Pintura', keywords: ['tee pvc', 'tee', 'pvc']),
    CompiledSpeciesItem(species: 'Pegamento PVC', department: 'Plomería y Pintura', keywords: ['pegamento pvc', 'pegamento', 'pvc']),
    CompiledSpeciesItem(species: 'Calentador de Agua', department: 'Plomería y Pintura', keywords: ['calentador de agua', 'calentador', 'agua']),
    CompiledSpeciesItem(species: 'Boiler', department: 'Plomería y Pintura', keywords: ['boiler', 'boiler']),
    CompiledSpeciesItem(species: 'Bomba de Agua', department: 'Plomería y Pintura', keywords: ['bomba de agua', 'bomba', 'agua']),
    CompiledSpeciesItem(species: 'Tinaco', department: 'Plomería y Pintura', keywords: ['tinaco', 'tinaco']),
    CompiledSpeciesItem(species: 'Cisterna', department: 'Plomería y Pintura', keywords: ['cisterna', 'cisterna']),
    CompiledSpeciesItem(species: 'Tarjeta de Video', department: 'Electrónica y Cómputo', keywords: ['tarjeta de video', 'tarjeta', 'video']),
    CompiledSpeciesItem(species: 'Procesador', department: 'Electrónica y Cómputo', keywords: ['procesador', 'procesador']),
    CompiledSpeciesItem(species: 'Tarjeta Madre', department: 'Electrónica y Cómputo', keywords: ['tarjeta madre', 'tarjeta', 'madre']),
    CompiledSpeciesItem(species: 'Memoria RAM', department: 'Electrónica y Cómputo', keywords: ['memoria ram', 'memoria', 'ram']),
    CompiledSpeciesItem(species: 'Disco Sólido', department: 'Electrónica y Cómputo', keywords: ['disco sólido', 'disco', 'sólido']),
    CompiledSpeciesItem(species: 'Disco Duro', department: 'Electrónica y Cómputo', keywords: ['disco duro', 'disco', 'duro']),
    CompiledSpeciesItem(species: 'Fuente de Poder', department: 'Electrónica y Cómputo', keywords: ['fuente de poder', 'fuente', 'poder']),
    CompiledSpeciesItem(species: 'Gabinete PC', department: 'Electrónica y Cómputo', keywords: ['gabinete pc', 'gabinete']),
    CompiledSpeciesItem(species: 'Disipador', department: 'Electrónica y Cómputo', keywords: ['disipador', 'disipador']),
    CompiledSpeciesItem(species: 'Ventilador PC', department: 'Electrónica y Cómputo', keywords: ['ventilador pc', 'ventilador']),
    CompiledSpeciesItem(species: 'Monitor', department: 'Electrónica y Cómputo', keywords: ['monitor', 'monitor']),
    CompiledSpeciesItem(species: 'Laptop', department: 'Electrónica y Cómputo', keywords: ['laptop', 'laptop']),
    CompiledSpeciesItem(species: 'Computadora de Escritorio', department: 'Electrónica y Cómputo', keywords: ['computadora de escritorio', 'computadora', 'escritorio']),
    CompiledSpeciesItem(species: 'Smartphone', department: 'Electrónica y Cómputo', keywords: ['smartphone', 'smartphone']),
    CompiledSpeciesItem(species: 'Tablet', department: 'Electrónica y Cómputo', keywords: ['tablet', 'tablet']),
    CompiledSpeciesItem(species: 'Televisor', department: 'Electrónica y Cómputo', keywords: ['televisor', 'televisor']),
    CompiledSpeciesItem(species: 'Audífono', department: 'Electrónica y Cómputo', keywords: ['audífono', 'audífono']),
    CompiledSpeciesItem(species: 'Bocina', department: 'Electrónica y Cómputo', keywords: ['bocina', 'bocina']),
    CompiledSpeciesItem(species: 'Barra de Sonido', department: 'Electrónica y Cómputo', keywords: ['barra de sonido', 'barra', 'sonido']),
    CompiledSpeciesItem(species: 'Mouse', department: 'Electrónica y Cómputo', keywords: ['mouse', 'mouse']),
    CompiledSpeciesItem(species: 'Teclado', department: 'Electrónica y Cómputo', keywords: ['teclado', 'teclado']),
    CompiledSpeciesItem(species: 'Cámara', department: 'Electrónica y Cómputo', keywords: ['cámara', 'cámara']),
    CompiledSpeciesItem(species: 'Webcam', department: 'Electrónica y Cómputo', keywords: ['webcam', 'webcam']),
    CompiledSpeciesItem(species: 'Dron', department: 'Electrónica y Cómputo', keywords: ['dron', 'dron']),
    CompiledSpeciesItem(species: 'Impresora', department: 'Electrónica y Cómputo', keywords: ['impresora', 'impresora']),
    CompiledSpeciesItem(species: 'Escáner', department: 'Electrónica y Cómputo', keywords: ['escáner', 'escáner']),
    CompiledSpeciesItem(species: 'Router', department: 'Electrónica y Cómputo', keywords: ['router', 'router']),
    CompiledSpeciesItem(species: 'Switch de Red', department: 'Electrónica y Cómputo', keywords: ['switch de red', 'switch', 'red']),
    CompiledSpeciesItem(species: 'Módem', department: 'Electrónica y Cómputo', keywords: ['módem', 'módem']),
    CompiledSpeciesItem(species: 'Cable HDMI', department: 'Electrónica y Cómputo', keywords: ['cable hdmi', 'cable', 'hdmi']),
    CompiledSpeciesItem(species: 'Cable USB', department: 'Electrónica y Cómputo', keywords: ['cable usb', 'cable', 'usb']),
    CompiledSpeciesItem(species: 'Cable Ethernet', department: 'Electrónica y Cómputo', keywords: ['cable ethernet', 'cable', 'ethernet']),
    CompiledSpeciesItem(species: 'Cargador', department: 'Electrónica y Cómputo', keywords: ['cargador', 'cargador']),
    CompiledSpeciesItem(species: 'Batería Portátil', department: 'Electrónica y Cómputo', keywords: ['batería portátil', 'batería', 'portátil']),
    CompiledSpeciesItem(species: 'Hub USB', department: 'Electrónica y Cómputo', keywords: ['hub usb', 'hub', 'usb']),
    CompiledSpeciesItem(species: 'Micrófono', department: 'Electrónica y Cómputo', keywords: ['micrófono', 'micrófono']),
    CompiledSpeciesItem(species: 'Silla Gamer', department: 'Electrónica y Cómputo', keywords: ['silla gamer', 'silla', 'gamer']),
    CompiledSpeciesItem(species: 'Volante Gamer', department: 'Electrónica y Cómputo', keywords: ['volante gamer', 'volante', 'gamer']),
    CompiledSpeciesItem(species: 'Proyector', department: 'Electrónica y Cómputo', keywords: ['proyector', 'proyector']),
    CompiledSpeciesItem(species: 'Servidor', department: 'Electrónica y Cómputo', keywords: ['servidor', 'servidor']),
    CompiledSpeciesItem(species: 'Antena Wifi', department: 'Electrónica y Cómputo', keywords: ['antena wifi', 'antena', 'wifi']),
    CompiledSpeciesItem(species: 'Disco Externo', department: 'Electrónica y Cómputo', keywords: ['disco externo', 'disco', 'externo']),
    CompiledSpeciesItem(species: 'Lápiz Óptico', department: 'Electrónica y Cómputo', keywords: ['lápiz óptico', 'lápiz', 'óptico']),
    CompiledSpeciesItem(species: 'Procesador de Audio', department: 'Electrónica y Cómputo', keywords: ['procesador de audio', 'procesador', 'audio']),
    CompiledSpeciesItem(species: 'Mezcladora de Audio', department: 'Electrónica y Cómputo', keywords: ['mezcladora de audio', 'mezcladora', 'audio']),
    CompiledSpeciesItem(species: 'Amplificador', department: 'Electrónica y Cómputo', keywords: ['amplificador', 'amplificador']),
    CompiledSpeciesItem(species: 'Lector de Código de Barra', department: 'Electrónica y Cómputo', keywords: ['lector de código de barra', 'lector', 'código', 'barra']),
    CompiledSpeciesItem(species: 'No-Break', department: 'Electrónica y Cómputo', keywords: ['no-break', 'no-break']),
    CompiledSpeciesItem(species: 'Regulador de Voltaje', department: 'Electrónica y Cómputo', keywords: ['regulador de voltaje', 'regulador', 'voltaje']),
    CompiledSpeciesItem(species: 'Control de Videojuegos', department: 'Videojuegos', keywords: ['control de videojuegos', 'control', 'videojuegos']),
    CompiledSpeciesItem(species: 'Consola de Videojuegos', department: 'Videojuegos', keywords: ['consola de videojuegos', 'consola', 'videojuegos']),
    CompiledSpeciesItem(species: 'Videojuego', department: 'Videojuegos', keywords: ['videojuego', 'videojuego']),
    CompiledSpeciesItem(species: 'Tarjeta de Prepago', department: 'Videojuegos', keywords: ['tarjeta de prepago', 'tarjeta', 'prepago']),
    CompiledSpeciesItem(species: 'Gafas de Realidad Virtual', department: 'Videojuegos', keywords: ['gafas de realidad virtual', 'gafas', 'realidad', 'virtual']),
    CompiledSpeciesItem(species: 'Base de Carga', department: 'Videojuegos', keywords: ['base de carga', 'base', 'carga']),
    CompiledSpeciesItem(species: 'Funda de Consola', department: 'Videojuegos', keywords: ['funda de consola', 'funda', 'consola']),
    CompiledSpeciesItem(species: 'Timón Gamer', department: 'Videojuegos', keywords: ['timón gamer', 'timón', 'gamer']),
    CompiledSpeciesItem(species: 'Palanca de Cambio Gamer', department: 'Videojuegos', keywords: ['palanca de cambio gamer', 'palanca', 'cambio', 'gamer']),
    CompiledSpeciesItem(species: 'Grip de Controller', department: 'Videojuegos', keywords: ['grip de controller', 'grip', 'controller']),
    CompiledSpeciesItem(species: 'Jabón', department: 'Salud y Cuidado Personal', keywords: ['jabón', 'jabón']),
    CompiledSpeciesItem(species: 'Champú', department: 'Salud y Cuidado Personal', keywords: ['champú', 'champú']),
    CompiledSpeciesItem(species: 'Acondicionador', department: 'Salud y Cuidado Personal', keywords: ['acondicionador', 'acondicionador']),
    CompiledSpeciesItem(species: 'Pasta Dental', department: 'Salud y Cuidado Personal', keywords: ['pasta dental', 'pasta', 'dental']),
    CompiledSpeciesItem(species: 'Cepillo Dental', department: 'Salud y Cuidado Personal', keywords: ['cepillo dental', 'cepillo', 'dental']),
    CompiledSpeciesItem(species: 'Hilo Dental', department: 'Salud y Cuidado Personal', keywords: ['hilo dental', 'hilo', 'dental']),
    CompiledSpeciesItem(species: 'Enjuague Bucal', department: 'Salud y Cuidado Personal', keywords: ['enjuague bucal', 'enjuague', 'bucal']),
    CompiledSpeciesItem(species: 'Crema Corporal', department: 'Salud y Cuidado Personal', keywords: ['crema corporal', 'crema', 'corporal']),
    CompiledSpeciesItem(species: 'Crema Facial', department: 'Salud y Cuidado Personal', keywords: ['crema facial', 'crema', 'facial']),
    CompiledSpeciesItem(species: 'Bloqueador Solar', department: 'Salud y Cuidado Personal', keywords: ['bloqueador solar', 'bloqueador', 'solar']),
    CompiledSpeciesItem(species: 'Desodorante', department: 'Salud y Cuidado Personal', keywords: ['desodorante', 'desodorante']),
    CompiledSpeciesItem(species: 'Antitraspirante', department: 'Salud y Cuidado Personal', keywords: ['antitraspirante', 'antitraspirante']),
    CompiledSpeciesItem(species: 'Rasuradora', department: 'Salud y Cuidado Personal', keywords: ['rasuradora', 'rasuradora']),
    CompiledSpeciesItem(species: 'Espuma de Afeitar', department: 'Salud y Cuidado Personal', keywords: ['espuma de afeitar', 'espuma', 'afeitar']),
    CompiledSpeciesItem(species: 'Perfume', department: 'Salud y Cuidado Personal', keywords: ['perfume', 'perfume']),
    CompiledSpeciesItem(species: 'Loción', department: 'Salud y Cuidado Personal', keywords: ['loción', 'loción']),
    CompiledSpeciesItem(species: 'Maquillaje', department: 'Salud y Cuidado Personal', keywords: ['maquillaje', 'maquillaje']),
    CompiledSpeciesItem(species: 'Labial', department: 'Salud y Cuidado Personal', keywords: ['labial', 'labial']),
    CompiledSpeciesItem(species: 'Rímel', department: 'Salud y Cuidado Personal', keywords: ['rímel', 'rímel']),
    CompiledSpeciesItem(species: 'Esmalte de Uña', department: 'Salud y Cuidado Personal', keywords: ['esmalte de uña', 'esmalte', 'uña']),
    CompiledSpeciesItem(species: 'Lavado Nasal', department: 'Salud y Cuidado Personal', keywords: ['lavado nasal', 'lavado', 'nasal']),
    CompiledSpeciesItem(species: 'Solución Salina', department: 'Salud y Cuidado Personal', keywords: ['solución salina', 'solución', 'salina']),
    CompiledSpeciesItem(species: 'Medicina', department: 'Salud y Cuidado Personal', keywords: ['medicina', 'medicina']),
    CompiledSpeciesItem(species: 'Analgésico', department: 'Salud y Cuidado Personal', keywords: ['analgésico', 'analgésico']),
    CompiledSpeciesItem(species: 'Antihistamínico', department: 'Salud y Cuidado Personal', keywords: ['antihistamínico', 'antihistamínico']),
    CompiledSpeciesItem(species: 'Vitamina', department: 'Salud y Cuidado Personal', keywords: ['vitamina', 'vitamina']),
    CompiledSpeciesItem(species: 'Jarabe', department: 'Salud y Cuidado Personal', keywords: ['jarabe', 'jarabe']),
    CompiledSpeciesItem(species: 'Termómetro', department: 'Salud y Cuidado Personal', keywords: ['termómetro', 'termómetro']),
    CompiledSpeciesItem(species: 'Curita', department: 'Salud y Cuidado Personal', keywords: ['curita', 'curita']),
    CompiledSpeciesItem(species: 'Algodón', department: 'Salud y Cuidado Personal', keywords: ['algodón', 'algodón']),
    CompiledSpeciesItem(species: 'Alcohol Etílico', department: 'Salud y Cuidado Personal', keywords: ['alcohol etílico', 'alcohol', 'etílico']),
    CompiledSpeciesItem(species: 'Oxímetro', department: 'Salud y Cuidado Personal', keywords: ['oxímetro', 'oxímetro']),
    CompiledSpeciesItem(species: 'Baumanómetro', department: 'Salud y Cuidado Personal', keywords: ['baumanómetro', 'baumanómetro']),
    CompiledSpeciesItem(species: 'Glucómetro', department: 'Salud y Cuidado Personal', keywords: ['glucómetro', 'glucómetro']),
    CompiledSpeciesItem(species: 'Jeringa', department: 'Salud y Cuidado Personal', keywords: ['jeringa', 'jeringa']),
    CompiledSpeciesItem(species: 'Gasa', department: 'Salud y Cuidado Personal', keywords: ['gasa', 'gasa']),
    CompiledSpeciesItem(species: 'Venda', department: 'Salud y Cuidado Personal', keywords: ['venda', 'venda']),
    CompiledSpeciesItem(species: 'Suero Oral', department: 'Salud y Cuidado Personal', keywords: ['suero oral', 'suero', 'oral']),
    CompiledSpeciesItem(species: 'Pastilla', department: 'Salud y Cuidado Personal', keywords: ['pastilla', 'pastilla']),
    CompiledSpeciesItem(species: 'Cápsula', department: 'Salud y Cuidado Personal', keywords: ['cápsula', 'cápsula']),
    CompiledSpeciesItem(species: 'Pomada', department: 'Salud y Cuidado Personal', keywords: ['pomada', 'pomada']),
    CompiledSpeciesItem(species: 'Gel Antibacterial', department: 'Salud y Cuidado Personal', keywords: ['gel antibacterial', 'gel', 'antibacterial']),
    CompiledSpeciesItem(species: 'Cortaúña', department: 'Salud y Cuidado Personal', keywords: ['cortaúña', 'cortaúña']),
    CompiledSpeciesItem(species: 'Cera Depilatoria', department: 'Salud y Cuidado Personal', keywords: ['cera depilatoria', 'cera', 'depilatoria']),
    CompiledSpeciesItem(species: 'Secadora de Cabello', department: 'Salud y Cuidado Personal', keywords: ['secadora de cabello', 'secadora', 'cabello']),
    CompiledSpeciesItem(species: 'Plancha de Cabello', department: 'Salud y Cuidado Personal', keywords: ['plancha de cabello', 'plancha', 'cabello']),
    CompiledSpeciesItem(species: 'Leche', department: 'Alimentos y Abarrotes', keywords: ['leche', 'leche']),
    CompiledSpeciesItem(species: 'Huevo', department: 'Alimentos y Abarrotes', keywords: ['huevo', 'huevo']),
    CompiledSpeciesItem(species: 'Queso', department: 'Alimentos y Abarrotes', keywords: ['queso', 'queso']),
    CompiledSpeciesItem(species: 'Yogurt', department: 'Alimentos y Abarrotes', keywords: ['yogurt', 'yogurt']),
    CompiledSpeciesItem(species: 'Mantequilla', department: 'Alimentos y Abarrotes', keywords: ['mantequilla', 'mantequilla']),
    CompiledSpeciesItem(species: 'Margarina', department: 'Alimentos y Abarrotes', keywords: ['margarina', 'margarina']),
    CompiledSpeciesItem(species: 'Crema de Leche', department: 'Alimentos y Abarrotes', keywords: ['crema de leche', 'crema', 'leche']),
    CompiledSpeciesItem(species: 'Puré de Tomate', department: 'Alimentos y Abarrotes', keywords: ['puré de tomate', 'puré', 'tomate']),
    CompiledSpeciesItem(species: 'Tomate', department: 'Alimentos y Abarrotes', keywords: ['tomate', 'tomate']),
    CompiledSpeciesItem(species: 'Jitomate', department: 'Alimentos y Abarrotes', keywords: ['jitomate', 'jitomate']),
    CompiledSpeciesItem(species: 'Cebolla', department: 'Alimentos y Abarrotes', keywords: ['cebolla', 'cebolla']),
    CompiledSpeciesItem(species: 'Papa', department: 'Alimentos y Abarrotes', keywords: ['papa', 'papa']),
    CompiledSpeciesItem(species: 'Aguacate', department: 'Alimentos y Abarrotes', keywords: ['aguacate', 'aguacate']),
    CompiledSpeciesItem(species: 'Limón', department: 'Alimentos y Abarrotes', keywords: ['limón', 'limón']),
    CompiledSpeciesItem(species: 'Manzana', department: 'Alimentos y Abarrotes', keywords: ['manzana', 'manzana']),
    CompiledSpeciesItem(species: 'Plátano', department: 'Alimentos y Abarrotes', keywords: ['plátano', 'plátano']),
    CompiledSpeciesItem(species: 'Naranja', department: 'Alimentos y Abarrotes', keywords: ['naranja', 'naranja']),
    CompiledSpeciesItem(species: 'Uva', department: 'Alimentos y Abarrotes', keywords: ['uva', 'uva']),
    CompiledSpeciesItem(species: 'Fresa', department: 'Alimentos y Abarrotes', keywords: ['fresa', 'fresa']),
    CompiledSpeciesItem(species: 'Melón', department: 'Alimentos y Abarrotes', keywords: ['melón', 'melón']),
    CompiledSpeciesItem(species: 'Sandía', department: 'Alimentos y Abarrotes', keywords: ['sandía', 'sandía']),
    CompiledSpeciesItem(species: 'Papaya', department: 'Alimentos y Abarrotes', keywords: ['papaya', 'papaya']),
    CompiledSpeciesItem(species: 'Piña', department: 'Alimentos y Abarrotes', keywords: ['piña', 'piña']),
    CompiledSpeciesItem(species: 'Mango', department: 'Alimentos y Abarrotes', keywords: ['mango', 'mango']),
    CompiledSpeciesItem(species: 'Azúcar', department: 'Alimentos y Abarrotes', keywords: ['azúcar', 'azúcar']),
    CompiledSpeciesItem(species: 'Harina', department: 'Alimentos y Abarrotes', keywords: ['harina', 'harina']),
    CompiledSpeciesItem(species: 'Arroz', department: 'Alimentos y Abarrotes', keywords: ['arroz', 'arroz']),
    CompiledSpeciesItem(species: 'Frijol', department: 'Alimentos y Abarrotes', keywords: ['frijol', 'frijol']),
    CompiledSpeciesItem(species: 'Maíz', department: 'Alimentos y Abarrotes', keywords: ['maíz', 'maíz']),
    CompiledSpeciesItem(species: 'Lenteja', department: 'Alimentos y Abarrotes', keywords: ['lenteja', 'lenteja']),
    CompiledSpeciesItem(species: 'Garbanzo', department: 'Alimentos y Abarrotes', keywords: ['garbanzo', 'garbanzo']),
    CompiledSpeciesItem(species: 'Aceite Comestible', department: 'Alimentos y Abarrotes', keywords: ['aceite comestible', 'aceite', 'comestible']),
    CompiledSpeciesItem(species: 'Salsa', department: 'Alimentos y Abarrotes', keywords: ['salsa', 'salsa']),
    CompiledSpeciesItem(species: 'Salsa de Chile', department: 'Alimentos y Abarrotes', keywords: ['salsa de chile', 'salsa', 'chile']),
    CompiledSpeciesItem(species: 'Dulce de Chile', department: 'Alimentos y Abarrotes', keywords: ['dulce de chile', 'dulce', 'chile']),
    CompiledSpeciesItem(species: 'Atún', department: 'Alimentos y Abarrotes', keywords: ['atún', 'atún']),
    CompiledSpeciesItem(species: 'Sardina', department: 'Alimentos y Abarrotes', keywords: ['sardina', 'sardina']),
    CompiledSpeciesItem(species: 'Chiles en Lata', department: 'Alimentos y Abarrotes', keywords: ['chiles en lata', 'chiles', 'lata']),
    CompiledSpeciesItem(species: 'Elote en Lata', department: 'Alimentos y Abarrotes', keywords: ['elote en lata', 'elote', 'lata']),
    CompiledSpeciesItem(species: 'Sopa en Lata', department: 'Alimentos y Abarrotes', keywords: ['sopa en lata', 'sopa', 'lata']),
    CompiledSpeciesItem(species: 'Papa Frita', department: 'Alimentos y Abarrotes', keywords: ['papa frita', 'papa', 'frita']),
    CompiledSpeciesItem(species: 'Galleta', department: 'Alimentos y Abarrotes', keywords: ['galleta', 'galleta']),
    CompiledSpeciesItem(species: 'Chocolate', department: 'Alimentos y Abarrotes', keywords: ['chocolate', 'chocolate']),
    CompiledSpeciesItem(species: 'Dulce', department: 'Alimentos y Abarrotes', keywords: ['dulce', 'dulce']),
    CompiledSpeciesItem(species: 'Palomita', department: 'Alimentos y Abarrotes', keywords: ['palomita', 'palomita']),
    CompiledSpeciesItem(species: 'Cereal', department: 'Alimentos y Abarrotes', keywords: ['cereal', 'cereal']),
    CompiledSpeciesItem(species: 'Pan Blanco', department: 'Alimentos y Abarrotes', keywords: ['pan blanco', 'pan', 'blanco']),
    CompiledSpeciesItem(species: 'Pan Dulce', department: 'Alimentos y Abarrotes', keywords: ['pan dulce', 'pan', 'dulce']),
    CompiledSpeciesItem(species: 'Tortilla', department: 'Alimentos y Abarrotes', keywords: ['tortilla', 'tortilla']),
    CompiledSpeciesItem(species: 'Jamón', department: 'Alimentos y Abarrotes', keywords: ['jamón', 'jamón']),
    CompiledSpeciesItem(species: 'Salchicha', department: 'Alimentos y Abarrotes', keywords: ['salchicha', 'salchicha']),
    CompiledSpeciesItem(species: 'Tocino', department: 'Alimentos y Abarrotes', keywords: ['tocino', 'tocino']),
    CompiledSpeciesItem(species: 'Chorizo', department: 'Alimentos y Abarrotes', keywords: ['chorizo', 'chorizo']),
    CompiledSpeciesItem(species: 'Carne de R', department: 'Alimentos y Abarrotes', keywords: ['carne de r', 'carne']),
    CompiledSpeciesItem(species: 'Carne de Cerdo', department: 'Alimentos y Abarrotes', keywords: ['carne de cerdo', 'carne', 'cerdo']),
    CompiledSpeciesItem(species: 'Pollo', department: 'Alimentos y Abarrotes', keywords: ['pollo', 'pollo']),
    CompiledSpeciesItem(species: 'Pescado', department: 'Alimentos y Abarrotes', keywords: ['pescado', 'pescado']),
    CompiledSpeciesItem(species: 'Camarón', department: 'Alimentos y Abarrotes', keywords: ['camarón', 'camarón']),
    CompiledSpeciesItem(species: 'Cereal de Trigo', department: 'Alimentos y Abarrotes', keywords: ['cereal de trigo', 'cereal', 'trigo']),
    CompiledSpeciesItem(species: 'Avena', department: 'Alimentos y Abarrotes', keywords: ['avena', 'avena']),
    CompiledSpeciesItem(species: 'Miel', department: 'Alimentos y Abarrotes', keywords: ['miel', 'miel']),
    CompiledSpeciesItem(species: 'Mayonesa', department: 'Alimentos y Abarrotes', keywords: ['mayonesa', 'mayonesa']),
    CompiledSpeciesItem(species: 'Mostaza', department: 'Alimentos y Abarrotes', keywords: ['mostaza', 'mostaza']),
    CompiledSpeciesItem(species: 'Cátsup', department: 'Alimentos y Abarrotes', keywords: ['cátsup', 'cátsup']),
    CompiledSpeciesItem(species: 'Vinagre', department: 'Alimentos y Abarrotes', keywords: ['vinagre', 'vinagre']),
    CompiledSpeciesItem(species: 'Mermelada', department: 'Alimentos y Abarrotes', keywords: ['mermelada', 'mermelada']),
    CompiledSpeciesItem(species: 'Crema de Cacahuate', department: 'Alimentos y Abarrotes', keywords: ['crema de cacahuate', 'crema', 'cacahuate']),
    CompiledSpeciesItem(species: 'Sopa de Pasta', department: 'Alimentos y Abarrotes', keywords: ['sopa de pasta', 'sopa', 'pasta']),
    CompiledSpeciesItem(species: 'Puré de Papa', department: 'Alimentos y Abarrotes', keywords: ['puré de papa', 'puré', 'papa']),
    CompiledSpeciesItem(species: 'Aceituna', department: 'Alimentos y Abarrotes', keywords: ['aceituna', 'aceituna']),
    CompiledSpeciesItem(species: 'Pepinillos', department: 'Alimentos y Abarrotes', keywords: ['pepinillos', 'pepinillos']),
    CompiledSpeciesItem(species: 'Refresco', department: 'Bebidas', keywords: ['refresco', 'refresco']),
    CompiledSpeciesItem(species: 'Agua Embotellada', department: 'Bebidas', keywords: ['agua embotellada', 'agua', 'embotellada']),
    CompiledSpeciesItem(species: 'Agua Mineral', department: 'Bebidas', keywords: ['agua mineral', 'agua', 'mineral']),
    CompiledSpeciesItem(species: 'Jugo', department: 'Bebidas', keywords: ['jugo', 'jugo']),
    CompiledSpeciesItem(species: 'Néctar', department: 'Bebidas', keywords: ['néctar', 'néctar']),
    CompiledSpeciesItem(species: 'Bebida Energética', department: 'Bebidas', keywords: ['bebida energética', 'bebida', 'energética']),
    CompiledSpeciesItem(species: 'Bebida Deportiva', department: 'Bebidas', keywords: ['bebida deportiva', 'bebida', 'deportiva']),
    CompiledSpeciesItem(species: 'Cerveza', department: 'Bebidas', keywords: ['cerveza', 'cerveza']),
    CompiledSpeciesItem(species: 'Vino', department: 'Bebidas', keywords: ['vino', 'vino']),
    CompiledSpeciesItem(species: 'Tequila', department: 'Bebidas', keywords: ['tequila', 'tequila']),
    CompiledSpeciesItem(species: 'Whisky', department: 'Bebidas', keywords: ['whisky', 'whisky']),
    CompiledSpeciesItem(species: 'Ron', department: 'Bebidas', keywords: ['ron', 'ron']),
    CompiledSpeciesItem(species: 'Vodka', department: 'Bebidas', keywords: ['vodka', 'vodka']),
    CompiledSpeciesItem(species: 'Mezcal', department: 'Bebidas', keywords: ['mezcal', 'mezcal']),
    CompiledSpeciesItem(species: 'Brandy', department: 'Bebidas', keywords: ['brandy', 'brandy']),
    CompiledSpeciesItem(species: 'Ginebra', department: 'Bebidas', keywords: ['ginebra', 'ginebra']),
    CompiledSpeciesItem(species: 'Café', department: 'Bebidas', keywords: ['café', 'café']),
    CompiledSpeciesItem(species: 'Té', department: 'Bebidas', keywords: ['té']),
    CompiledSpeciesItem(species: 'Malteada', department: 'Bebidas', keywords: ['malteada', 'malteada']),
    CompiledSpeciesItem(species: 'Sidra', department: 'Bebidas', keywords: ['sidra', 'sidra']),
    CompiledSpeciesItem(species: 'Licor de Café', department: 'Bebidas', keywords: ['licor de café', 'licor', 'café']),
    CompiledSpeciesItem(species: 'Cloro', department: 'Hogar y Limpieza', keywords: ['cloro', 'cloro']),
    CompiledSpeciesItem(species: 'Detergente', department: 'Hogar y Limpieza', keywords: ['detergente', 'detergente']),
    CompiledSpeciesItem(species: 'Suavizante', department: 'Hogar y Limpieza', keywords: ['suavizante', 'suavizante']),
    CompiledSpeciesItem(species: 'Lavavajilla', department: 'Hogar y Limpieza', keywords: ['lavavajilla', 'lavavajilla']),
    CompiledSpeciesItem(species: 'Desinfectante', department: 'Hogar y Limpieza', keywords: ['desinfectante', 'desinfectante']),
    CompiledSpeciesItem(species: 'Limpiacristal', department: 'Hogar y Limpieza', keywords: ['limpiacristal', 'limpiacristal']),
    CompiledSpeciesItem(species: 'Limpiador Multiusos', department: 'Hogar y Limpieza', keywords: ['limpiador multiusos', 'limpiador', 'multiusos']),
    CompiledSpeciesItem(species: 'Jabón Trast', department: 'Hogar y Limpieza', keywords: ['jabón trast', 'jabón', 'trast']),
    CompiledSpeciesItem(species: 'Escoba', department: 'Hogar y Limpieza', keywords: ['escoba', 'escoba']),
    CompiledSpeciesItem(species: 'Trapeador', department: 'Hogar y Limpieza', keywords: ['trapeador', 'trapeador']),
    CompiledSpeciesItem(species: 'Recogedor', department: 'Hogar y Limpieza', keywords: ['recogedor', 'recogedor']),
    CompiledSpeciesItem(species: 'Cubeta', department: 'Hogar y Limpieza', keywords: ['cubeta', 'cubeta']),
    CompiledSpeciesItem(species: 'Fibra de Limpieza', department: 'Hogar y Limpieza', keywords: ['fibra de limpieza', 'fibra', 'limpieza']),
    CompiledSpeciesItem(species: 'Papel Higiénico', department: 'Hogar y Limpieza', keywords: ['papel higiénico', 'papel', 'higiénico']),
    CompiledSpeciesItem(species: 'Servilleta', department: 'Hogar y Limpieza', keywords: ['servilleta', 'servilleta']),
    CompiledSpeciesItem(species: 'Toalla de Papel', department: 'Hogar y Limpieza', keywords: ['toalla de papel', 'toalla', 'papel']),
    CompiledSpeciesItem(species: 'Bolsa de Basura', department: 'Hogar y Limpieza', keywords: ['bolsa de basura', 'bolsa', 'basura']),
    CompiledSpeciesItem(species: 'Refrigerador', department: 'Hogar y Limpieza', keywords: ['refrigerador', 'refrigerador']),
    CompiledSpeciesItem(species: 'Lavadora', department: 'Hogar y Limpieza', keywords: ['lavadora', 'lavadora']),
    CompiledSpeciesItem(species: 'Secadora', department: 'Hogar y Limpieza', keywords: ['secadora', 'secadora']),
    CompiledSpeciesItem(species: 'Estufa', department: 'Hogar y Limpieza', keywords: ['estufa', 'estufa']),
    CompiledSpeciesItem(species: 'Horno', department: 'Hogar y Limpieza', keywords: ['horno', 'horno']),
    CompiledSpeciesItem(species: 'Microonda', department: 'Hogar y Limpieza', keywords: ['microonda', 'microonda']),
    CompiledSpeciesItem(species: 'Licuadora', department: 'Hogar y Limpieza', keywords: ['licuadora', 'licuadora']),
    CompiledSpeciesItem(species: 'Freidora de Aire', department: 'Hogar y Limpieza', keywords: ['freidora de aire', 'freidora', 'aire']),
    CompiledSpeciesItem(species: 'Cafetera', department: 'Hogar y Limpieza', keywords: ['cafetera', 'cafetera']),
    CompiledSpeciesItem(species: 'Batidora', department: 'Hogar y Limpieza', keywords: ['batidora', 'batidora']),
    CompiledSpeciesItem(species: 'Tostadora', department: 'Hogar y Limpieza', keywords: ['tostadora', 'tostadora']),
    CompiledSpeciesItem(species: 'Aspiradora', department: 'Hogar y Limpieza', keywords: ['aspiradora', 'aspiradora']),
    CompiledSpeciesItem(species: 'Sartén', department: 'Hogar y Limpieza', keywords: ['sartén', 'sartén']),
    CompiledSpeciesItem(species: 'Olla', department: 'Hogar y Limpieza', keywords: ['olla', 'olla']),
    CompiledSpeciesItem(species: 'Vajilla', department: 'Hogar y Limpieza', keywords: ['vajilla', 'vajilla']),
    CompiledSpeciesItem(species: 'Vaso', department: 'Hogar y Limpieza', keywords: ['vaso', 'vaso']),
    CompiledSpeciesItem(species: 'Taza', department: 'Hogar y Limpieza', keywords: ['taza', 'taza']),
    CompiledSpeciesItem(species: 'Plato', department: 'Hogar y Limpieza', keywords: ['plato', 'plato']),
    CompiledSpeciesItem(species: 'Cuchillo de Cocina', department: 'Hogar y Limpieza', keywords: ['cuchillo de cocina', 'cuchillo', 'cocina']),
    CompiledSpeciesItem(species: 'Tenedor', department: 'Hogar y Limpieza', keywords: ['tenedor', 'tenedor']),
    CompiledSpeciesItem(species: 'Cuchara', department: 'Hogar y Limpieza', keywords: ['cuchara', 'cuchara']),
    CompiledSpeciesItem(species: 'Foco', department: 'Hogar y Limpieza', keywords: ['foco', 'foco']),
    CompiledSpeciesItem(species: 'Lámpara', department: 'Hogar y Limpieza', keywords: ['lámpara', 'lámpara']),
    CompiledSpeciesItem(species: 'Manta', department: 'Hogar y Limpieza', keywords: ['manta', 'manta']),
    CompiledSpeciesItem(species: 'Almohada', department: 'Hogar y Limpieza', keywords: ['almohada', 'almohada']),
    CompiledSpeciesItem(species: 'Colchón', department: 'Hogar y Limpieza', keywords: ['colchón', 'colchón']),
    CompiledSpeciesItem(species: 'Sábana', department: 'Hogar y Limpieza', keywords: ['sábana', 'sábana']),
    CompiledSpeciesItem(species: 'Cama', department: 'Hogar y Limpieza', keywords: ['cama', 'cama']),
    CompiledSpeciesItem(species: 'Ventilador', department: 'Hogar y Limpieza', keywords: ['ventilador', 'ventilador']),
    CompiledSpeciesItem(species: 'Aire Acondicionado', department: 'Hogar y Limpieza', keywords: ['aire acondicionado', 'aire', 'acondicionado']),
    CompiledSpeciesItem(species: 'Plancha de Ropa', department: 'Hogar y Limpieza', keywords: ['plancha de ropa', 'plancha', 'ropa']),
    CompiledSpeciesItem(species: 'Burro de Planchar', department: 'Hogar y Limpieza', keywords: ['burro de planchar', 'burro', 'planchar']),
    CompiledSpeciesItem(species: 'Tenis', department: 'Ropa y Calzado', keywords: ['tenis', 'tenis']),
    CompiledSpeciesItem(species: 'Zapato', department: 'Ropa y Calzado', keywords: ['zapato', 'zapato']),
    CompiledSpeciesItem(species: 'Bota', department: 'Ropa y Calzado', keywords: ['bota', 'bota']),
    CompiledSpeciesItem(species: 'Sandalia', department: 'Ropa y Calzado', keywords: ['sandalia', 'sandalia']),
    CompiledSpeciesItem(species: 'Playera', department: 'Ropa y Calzado', keywords: ['playera', 'playera']),
    CompiledSpeciesItem(species: 'Camisa', department: 'Ropa y Calzado', keywords: ['camisa', 'camisa']),
    CompiledSpeciesItem(species: 'Pantalón', department: 'Ropa y Calzado', keywords: ['pantalón', 'pantalón']),
    CompiledSpeciesItem(species: 'Jean', department: 'Ropa y Calzado', keywords: ['jean', 'jean']),
    CompiledSpeciesItem(species: 'Chamarra', department: 'Ropa y Calzado', keywords: ['chamarra', 'chamarra']),
    CompiledSpeciesItem(species: 'Sudadera', department: 'Ropa y Calzado', keywords: ['sudadera', 'sudadera']),
    CompiledSpeciesItem(species: 'Vestido', department: 'Ropa y Calzado', keywords: ['vestido', 'vestido']),
    CompiledSpeciesItem(species: 'Short', department: 'Ropa y Calzado', keywords: ['short', 'short']),
    CompiledSpeciesItem(species: 'Calcetín', department: 'Ropa y Calzado', keywords: ['calcetín', 'calcetín']),
    CompiledSpeciesItem(species: 'Interior', department: 'Ropa y Calzado', keywords: ['interior', 'interior']),
    CompiledSpeciesItem(species: 'Cinturón', department: 'Ropa y Calzado', keywords: ['cinturón', 'cinturón']),
    CompiledSpeciesItem(species: 'Gorra', department: 'Ropa y Calzado', keywords: ['gorra', 'gorra']),
    CompiledSpeciesItem(species: 'Sombrero', department: 'Ropa y Calzado', keywords: ['sombrero', 'sombrero']),
    CompiledSpeciesItem(species: 'Bufanda', department: 'Ropa y Calzado', keywords: ['bufanda', 'bufanda']),
    CompiledSpeciesItem(species: 'Guant', department: 'Ropa y Calzado', keywords: ['guant', 'guant']),
    CompiledSpeciesItem(species: 'Traje de Baño', department: 'Ropa y Calzado', keywords: ['traje de baño', 'traje', 'baño']),
    CompiledSpeciesItem(species: 'Alimento para Perro', department: 'Mascotas', keywords: ['alimento para perro', 'alimento', 'para', 'perro']),
    CompiledSpeciesItem(species: 'Alimento para Gato', department: 'Mascotas', keywords: ['alimento para gato', 'alimento', 'para', 'gato']),
    CompiledSpeciesItem(species: 'Premio para Mascota', department: 'Mascotas', keywords: ['premio para mascota', 'premio', 'para', 'mascota']),
    CompiledSpeciesItem(species: 'Arena para Gato', department: 'Mascotas', keywords: ['arena para gato', 'arena', 'para', 'gato']),
    CompiledSpeciesItem(species: 'Plato para Mascota', department: 'Mascotas', keywords: ['plato para mascota', 'plato', 'para', 'mascota']),
    CompiledSpeciesItem(species: 'Juguete para Mascota', department: 'Mascotas', keywords: ['juguete para mascota', 'juguete', 'para', 'mascota']),
    CompiledSpeciesItem(species: 'Collar para Perro', department: 'Mascotas', keywords: ['collar para perro', 'collar', 'para', 'perro']),
    CompiledSpeciesItem(species: 'Pechera', department: 'Mascotas', keywords: ['pechera', 'pechera']),
    CompiledSpeciesItem(species: 'Correa', department: 'Mascotas', keywords: ['correa', 'correa']),
    CompiledSpeciesItem(species: 'Cama para Perro', department: 'Mascotas', keywords: ['cama para perro', 'cama', 'para', 'perro']),
    CompiledSpeciesItem(species: 'Rascador para Gato', department: 'Mascotas', keywords: ['rascador para gato', 'rascador', 'para', 'gato']),
    CompiledSpeciesItem(species: 'Shampoo para Perro', department: 'Mascotas', keywords: ['shampoo para perro', 'shampoo', 'para', 'perro']),
    CompiledSpeciesItem(species: 'Pañal', department: 'Bebés', keywords: ['pañal', 'pañal']),
    CompiledSpeciesItem(species: 'Toallita Húmeda', department: 'Bebés', keywords: ['toallita húmeda', 'toallita', 'húmeda']),
    CompiledSpeciesItem(species: 'Fórmula Infantil', department: 'Bebés', keywords: ['fórmula infantil', 'fórmula', 'infantil']),
    CompiledSpeciesItem(species: 'Biberón', department: 'Bebés', keywords: ['biberón', 'biberón']),
    CompiledSpeciesItem(species: 'Chupón', department: 'Bebés', keywords: ['chupón', 'chupón']),
    CompiledSpeciesItem(species: 'Carriola', department: 'Bebés', keywords: ['carriola', 'carriola']),
    CompiledSpeciesItem(species: 'Cuna', department: 'Bebés', keywords: ['cuna', 'cuna']),
    CompiledSpeciesItem(species: 'Silla de Bebé', department: 'Bebés', keywords: ['silla de bebé', 'silla', 'bebé']),
    CompiledSpeciesItem(species: 'Esterilizador de Biberoón', department: 'Bebés', keywords: ['esterilizador de biberoón', 'esterilizador', 'biberoón']),
    CompiledSpeciesItem(species: 'Mordedera', department: 'Bebés', keywords: ['mordedera', 'mordedera']),
    CompiledSpeciesItem(species: 'Juguete', department: 'Juguetes', keywords: ['juguete', 'juguete']),
    CompiledSpeciesItem(species: 'Lego', department: 'Juguetes', keywords: ['lego', 'lego']),
    CompiledSpeciesItem(species: 'Figura de Acción', department: 'Juguetes', keywords: ['figura de acción', 'figura', 'acción']),
    CompiledSpeciesItem(species: 'Muñeca', department: 'Juguetes', keywords: ['muñeca', 'muñeca']),
    CompiledSpeciesItem(species: 'Juego de Mesa', department: 'Juguetes', keywords: ['juego de mesa', 'juego', 'mesa']),
    CompiledSpeciesItem(species: 'Peluche', department: 'Juguetes', keywords: ['peluche', 'peluche']),
    CompiledSpeciesItem(species: 'Pista de Carrera', department: 'Juguetes', keywords: ['pista de carrera', 'pista', 'carrera']),
    CompiledSpeciesItem(species: 'Montable', department: 'Juguetes', keywords: ['montable', 'montable']),
    CompiledSpeciesItem(species: 'Triciclo', department: 'Juguetes', keywords: ['triciclo', 'triciclo']),
    CompiledSpeciesItem(species: 'Patín', department: 'Juguetes', keywords: ['patín', 'patín']),
    CompiledSpeciesItem(species: 'Rompecabeza', department: 'Juguetes', keywords: ['rompecabeza', 'rompecabeza']),
    CompiledSpeciesItem(species: 'Pistola de Juguete', department: 'Juguetes', keywords: ['pistola de juguete', 'pistola', 'juguete']),
    CompiledSpeciesItem(species: 'Cuaderno', department: 'Oficina y Papelería', keywords: ['cuaderno', 'cuaderno']),
    CompiledSpeciesItem(species: 'Libreta', department: 'Oficina y Papelería', keywords: ['libreta', 'libreta']),
    CompiledSpeciesItem(species: 'Pluma', department: 'Oficina y Papelería', keywords: ['pluma', 'pluma']),
    CompiledSpeciesItem(species: 'Bolígrafo', department: 'Oficina y Papelería', keywords: ['bolígrafo', 'bolígrafo']),
    CompiledSpeciesItem(species: 'Lápiz', department: 'Oficina y Papelería', keywords: ['lápiz', 'lápiz']),
    CompiledSpeciesItem(species: 'Marcador', department: 'Oficina y Papelería', keywords: ['marcador', 'marcador']),
    CompiledSpeciesItem(species: 'Carpeta', department: 'Oficina y Papelería', keywords: ['carpeta', 'carpeta']),
    CompiledSpeciesItem(species: 'Hoja de Papel', department: 'Oficina y Papelería', keywords: ['hoja de papel', 'hoja', 'papel']),
    CompiledSpeciesItem(species: 'Grapa', department: 'Oficina y Papelería', keywords: ['grapa', 'grapa']),
    CompiledSpeciesItem(species: 'Tijera', department: 'Oficina y Papelería', keywords: ['tijera', 'tijera']),
    CompiledSpeciesItem(species: 'Mochila', department: 'Oficina y Papelería', keywords: ['mochila', 'mochila']),
    CompiledSpeciesItem(species: 'Libro', department: 'Oficina y Papelería', keywords: ['libro', 'libro']),
    CompiledSpeciesItem(species: 'Calculadora', department: 'Oficina y Papelería', keywords: ['calculadora', 'calculadora']),
    CompiledSpeciesItem(species: 'Engrapadora', department: 'Oficina y Papelería', keywords: ['engrapadora', 'engrapadora']),
    CompiledSpeciesItem(species: 'Cinta Adhesiva', department: 'Oficina y Papelería', keywords: ['cinta adhesiva', 'cinta', 'adhesiva']),
    CompiledSpeciesItem(species: 'Regla', department: 'Oficina y Papelería', keywords: ['regla', 'regla']),
    CompiledSpeciesItem(species: 'Sacapunta', department: 'Oficina y Papelería', keywords: ['sacapunta', 'sacapunta']),
    CompiledSpeciesItem(species: 'Goma de Borrar', department: 'Oficina y Papelería', keywords: ['goma de borrar', 'goma', 'borrar']),
    CompiledSpeciesItem(species: 'Folder', department: 'Oficina y Papelería', keywords: ['folder', 'folder']),
    CompiledSpeciesItem(species: 'Mancuerna', department: 'Deportes', keywords: ['mancuerna', 'mancuerna']),
    CompiledSpeciesItem(species: 'Tapete de Yoga', department: 'Deportes', keywords: ['tapete de yoga', 'tapete', 'yoga']),
    CompiledSpeciesItem(species: 'Balón de Fútbol', department: 'Deportes', keywords: ['balón de fútbol', 'balón', 'fútbol']),
    CompiledSpeciesItem(species: 'Balón de Basquetbol', department: 'Deportes', keywords: ['balón de basquetbol', 'balón', 'basquetbol']),
    CompiledSpeciesItem(species: 'Balón de Voleibol', department: 'Deportes', keywords: ['balón de voleibol', 'balón', 'voleibol']),
    CompiledSpeciesItem(species: 'Bicicleta', department: 'Deportes', keywords: ['bicicleta', 'bicicleta']),
    CompiledSpeciesItem(species: 'Casco de Bicicleta', department: 'Deportes', keywords: ['casco de bicicleta', 'casco', 'bicicleta']),
    CompiledSpeciesItem(species: 'Cuerda para Saltar', department: 'Deportes', keywords: ['cuerda para saltar', 'cuerda', 'para', 'saltar']),
    CompiledSpeciesItem(species: 'Raqueta', department: 'Deportes', keywords: ['raqueta', 'raqueta']),
    CompiledSpeciesItem(species: 'Guantes de Box', department: 'Deportes', keywords: ['guantes de box', 'guantes', 'box']),
    CompiledSpeciesItem(species: 'Banda de Resistencia', department: 'Deportes', keywords: ['banda de resistencia', 'banda', 'resistencia']),
  ];
}

/// Organized namespace for Numismatics Data Tables and Canonical Resolutions.
abstract final class AppTechnicalNumismatics {
  static const numismaticSpeciesNames = ['Moneda', 'Billete'];

  static const Map<String, String> currencyMap = {
    // 1. México
    'MXN': 'Pesos Mexicanos',
    'MXP': 'Pesos Mexicanos Antiguos',
    // 2. Norteamérica
    'USD': 'Dólares Estadounidenses',
    'CAD': 'Dólares Canadienses',
    // 3. Centroamérica y Caribe
    'GTQ': 'Quetzales Guatemaltecos',
    'BZD': 'Dólares Beliceños',
    'SVC': 'Colones Salvadoreños',
    'HNL': 'Lempiras Hondureños',
    'NIO': 'Córdobas Nicaragüenses',
    'CRC': 'Colones Costarricenses',
    'PAB': 'Balboas Panameños',
    'CUP': 'Pesos Cubanos',
    'CUC': 'Pesos Cubanos Convertibles',
    'DOP': 'Pesos Dominicanos',
    'HTG': 'Gourdes Haitianos',
    'JMD': 'Dólares Jamaicanos',
    'BSD': 'Dólares Bahameños',
    'AWG': 'Florines Arubeños',
    'ANG': 'Florines Antillanos Holandeses',
    'XCD': 'Dólares del Caribe Oriental',
    'KYD': 'Dólares de las Islas Caimán',
    'BBD': 'Dólares de Barbados',
    'TTD': 'Dólares de Trinidad y Tobago',
    // 4. Sudamérica
    'COP': 'Pesos Colombianos',
    'VES': 'Bolívares Soberanos Venezolanos',
    'VED': 'Bolívares Soberanos Digitales Venezolanos',
    'PEN': 'Soles Peruanos',
    'BRL': 'Reales Brasileños',
    'BOB': 'Bolivianos',
    'CLP': 'Pesos Chilenos',
    'ARS': 'Pesos Argentinos',
    'UYU': 'Pesos Uruguayos',
    'PYG': 'Guaraníes Paraguayos',
    'GYD': 'Dólares Guyaneses',
    'SRD': 'Dólares Surinameses',
    'FKP': 'Libras de las Islas Malvinas',
    // 5. Europa
    'ESP': 'Pesetas Españolas',
    'EUR': 'Euros',
    'GBP': 'Libras Esterlinas',
    'CHF': 'Francos Suizos',
    'SEK': 'Coronas Suecas',
    'NOK': 'Coronas Noruegas',
    'DKK': 'Coronas Danesas',
    'PLN': 'Zlotys Polacos',
    'CZK': 'Coronas Checas',
    'HUF': 'Forintos Húngaros',
    'RON': 'Leus Rumanos',
    'BGN': 'Levs Búlgaros',
    'RSD': 'Dinares Serbios',
    'HRK': 'Kunas Croatas',
    'BAM': 'Marcos Convertibles de Bosnia-Herzegovina',
    'ALL': 'Leks Albaneses',
    'MKD': 'Denares Macedonios',
    'RUB': 'Rublos Rusos',
    'UAH': 'Grivnas Ucranianas',
    'BYN': 'Rublos Bielorrusos',
    'MDL': 'Leus Moldavos',
    'TRY': 'Liras Turcas',
    'GIP': 'Libras de Gibraltar',
    'ISK': 'Coronas Islandesas',
    // 6. Asia y Medio Oriente
    'JPY': 'Yenes Japoneses',
    'CNY': 'Yuanes Chinos',
    'KRW': 'Wones Surcoreanos',
    'KPW': 'Wones Norcoreanos',
    'TWD': 'Nuevos Dólares Taiwaneses',
    'HKD': 'Dólares de Hong Kong',
    'MOP': 'Patacas de Macao',
    'PHP': 'Pesos Filipinos',
    'INR': 'Rupias Indias',
    'IDR': 'Rupias Indonesias',
    'MYR': 'Ringgits Malayos',
    'SGD': 'Dólares de Singapur',
    'THB': 'Bahts Tailandeses',
    'VND': 'Dongs Vietnamitas',
    'KHR': 'Rieles Camboyanos',
    'LAK': 'Kips Laosianos',
    'MMK': 'Kyats Birmanos',
    'BDT': 'Takas Bangladesíes',
    'PKR': 'Rupias Pakistaníes',
    'LKR': 'Rupias de Sri Lanka',
    'NPR': 'Rupias Nepalíes',
    'BTN': 'Ngultrums Butaneses',
    'MVR': 'Rupias Maldivas',
    'AFN': 'Afganis',
    'ILS': 'Nuevos Shekels Israelíes',
    'JOD': 'Dinares Jordanos',
    'LBP': 'Libras Libanesas',
    'SYP': 'Libras Sirias',
    'IQD': 'Dinares Iraquíes',
    'IRR': 'Riales Iraníes',
    'SAR': 'Riyales Saudíes',
    'AED': 'Dírhams de los EAU',
    'QAR': 'Riyales Cataríes',
    'BHD': 'Dinares Bahreiníes',
    'KWD': 'Dinares Kuwaitíes',
    'OMR': 'Riales Omaníes',
    'YER': 'Riales Yemeníes',
    'AMD': 'Drams Armenios',
    'AZN': 'Manats Azerbaiyanos',
    'GEL': 'Laris Georgianos',
    'KZT': 'Tenges Kazajos',
    'KGS': 'Soms Kirguises',
    'TJS': 'Somonis Tayikos',
    'TMT': 'Manats Turcomanos',
    'UZS': 'Soms Uzbekos',
    'MNT': 'Tugriks Mongolios',
    // 7. Oceanía
    'AUD': 'Dólares Australianos',
    'NZD': 'Dólares Neozelandeses',
    'FJD': 'Dólares Fiyianos',
    'PGK': 'Kinas de Papúa Nueva Guinea',
    'SBD': 'Dólares de las Islas Salomón',
    'VUV': 'Vatus Vanuatuenses',
    'WST': 'Talas Samoanos',
    'TOP': 'Paangas Tonganos',
    'XPF': 'Francos CFP',
    // 8. África
    'EGP': 'Libras Egipcias',
    'ZAR': 'Rands Sudafricanos',
    'NGN': 'Nairas Nigerianas',
    'MAD': 'Dírhams Marroquíes',
    'DZD': 'Dinares Argelinos',
    'TND': 'Dinares Tunecinos',
    'LYD': 'Dinares Libios',
    'KES': 'Chelines Kenianos',
    'ETB': 'Birrs Etíopes',
    'GHS': 'Cedis Ghaneses',
    'XOF': 'Francos CFA de África Occidental',
    'XAF': 'Francos CFA de África Central',
    'MUR': 'Rupias Mauricianas',
    'BWP': 'Pulas Botsuanas',
    'NAD': 'Dólares Namibios',
    'TZS': 'Chelines Tanzanos',
    'UGX': 'Chelines Ugandeses',
    'AOA': 'Kwanzas Angoleños',
    'MZN': 'Meticales Mozambiqueños',
    'ZMW': 'Kwanzas Zambianos',
    'ZWL': 'Dólares Zimbabuenses',
    'SZL': 'Lilangeni Suazis',
    'LSL': 'Lotis Lesotenses',
    'BIF': 'Francos Burundeses',
    'CVE': 'Escudos Caboverdianos',
    'KMF': 'Francos Comorenses',
    'CDF': 'Francos Congoleños',
    'DJF': 'Francos Yibutianos',
    'ERN': 'Nakfas Eritreos',
    'GMD': 'Dalasis Gambianos',
    'GNF': 'Francos Guineanos',
    'LRD': 'Dólares Liberianos',
    'MGA': 'Ariarys Malgaches',
    'MWK': 'Kwachas Malauís',
    'MRU': 'Ouguiyas Mauritanas',
    'RWF': 'Francos Ruandeses',
    'STN': 'Dobras Santotomenses',
    'SCR': 'Rupias Seychellesas',
    'SLE': 'Leones Sierraleoneses',
    'SLL': 'Leones Sierraleoneses Antiguos',
    'SOS': 'Chelines Somalíes',
    'SDG': 'Libras Sudanesas',
    'SSP': 'Libras Sursudanesas',
  };

  static const List<String> countries = [
    // 1. México
    'México',
    // 2. Norteamérica
    'Estados Unidos', 'Canadá', 'Bermudas', 'Groenlandia',
    // 3. Centroamérica y Caribe
    'Guatemala', 'Belice', 'El Salvador', 'Honduras', 'Nicaragua', 'Costa Rica', 'Panamá',
    'Cuba', 'Puerto Rico', 'República Dominicana', 'Haití', 'Jamaica', 'Bahamas',
    'Aruba', 'Curazao', 'Antigua y Barbuda', 'Barbados', 'Dominica', 'Granada',
    'San Cristóbal y Nieves', 'Santa Lucía', 'San Vicente y las Granadinas', 'Trinidad y Tobago', 'Islas Caimán',
    // 4. Sudamérica
    'Colombia', 'Venezuela', 'Ecuador', 'Perú', 'Brasil', 'Bolivia', 'Chile', 'Argentina',
    'Paraguay', 'Uruguay', 'Guyana', 'Surinam', 'Islas Malvinas',
    // 5. Europa
    'España', 'Unión Europea', 'Reino Unido', 'Francia', 'Alemania', 'Italia', 'Portugal', 'Suiza',
    'Bélgica', 'Países Bajos', 'Irlanda', 'Austria', 'Ciudad del Vaticano', 'San Marino', 'Andorra',
    'Dinamarca', 'Noruega', 'Suecia', 'Finlandia', 'Islandia', 'Polonia', 'República Checa',
    'Eslovaquia', 'Hungría', 'Rumanía', 'Bulgaria', 'Grecia', 'Chipre', 'Turquía', 'Rusia', 'Ucrania',
    'Bielorrusia', 'Moldavia', 'Lituania', 'Letonia', 'Estonia', 'Albania', 'Bosnia y Herzegovina',
    'Croacia', 'Eslovenia', 'Macedonia del Norte', 'Montenegro', 'Serbia', 'Gibraltar',
    'Islas Feroe', 'Liechtenstein', 'Luxemburgo', 'Mónaco', 'Malta',
    // 6. Asia y Medio Oriente
    'Japón', 'China', 'Corea del Sur', 'Corea del Norte', 'Taiwán', 'Hong Kong', 'Macao', 'Filipinas',
    'India', 'Indonesia', 'Malasia', 'Singapur', 'Tailandia', 'Vietnam', 'Camboya', 'Laos',
    'Birmania (Myanmar)', 'Bangladés', 'Pakistán', 'Sri Lanka', 'Nepal', 'Bután', 'Maldivas',
    'Afganistán', 'Israel', 'Palestina', 'Jordania', 'Líbano', 'Siria', 'Irak', 'Irán', 'Arabia Saudita',
    'Emiratos Árabes Unidos', 'Catar', 'Baréin', 'Kuwait', 'Omán', 'Yemen', 'Armenia',
    'Azerbaiyán', 'Georgia', 'Kazajistán', 'Kirguistán', 'Tayikistán', 'Turkmenistán', 'Uzbekistán',
    'Brunéi', 'Mongolia', 'Timor Oriental',
    // 7. Oceanía
    'Australia', 'Nueva Zelanda', 'Fiyi', 'Islas Cook', 'Islas Marshall', 'Islas Salomón',
    'Micronesia', 'Nauru', 'Nueva Caledonia', 'Palaos', 'Papúa Nueva Guinea', 'Polinesia Francesa',
    'Samoa', 'Tonga', 'Tuvalu', 'Vanuatu', 'Kiribati',
    // 8. África
    'Egipto', 'Marruecos', 'Argelia', 'Túnez', 'Libia', 'Sudáfrica', 'Nigeria', 'Kenia', 'Etiopía',
    'Angola', 'Benín', 'Botsuana', 'Burkina Faso', 'Burundi', 'Cabo Verde', 'Camerún', 'Chad',
    'Comoras', 'Costa de Marfil', 'Eritrea', 'Esuatini (Suazilandia)', 'Gabón', 'Gambia', 'Ghana',
    'Guinea', 'Guinea Ecuatorial', 'Guinea-Bisáu', 'Lesoto', 'Liberia', 'Madagascar', 'Malaui',
    'Malí', 'Mauricio', 'Mauritania', 'Mozambique', 'Namibia', 'Níger', 'República Centroafricana',
    'República del Congo', 'República Democrática del Congo', 'Ruanda', 'Santo Tomé y Príncipe',
    'Senegal', 'Seychelles', 'Sierra Leona', 'Somalia', 'Sudán', 'Sudán del Sur', 'Tanzania',
    'Togo', 'Uganda', 'Yibuti', 'Zambia', 'Zimbabue',
    // 9. Otro
    'Otro',
  ];

  static const Map<String, List<String>> countryToCurrenciesMap = {
    // 1. México
    'México': ['MXN', 'MXP'],
    // 2. Norteamérica
    'Estados Unidos': ['USD'],
    'Canadá': ['CAD'],
    // 3. Centroamérica y Caribe
    'Guatemala': ['GTQ'],
    'Belice': ['BZD'],
    'El Salvador': ['SVC', 'USD'],
    'Honduras': ['HNL'],
    'Nicaragua': ['NIO'],
    'Costa Rica': ['CRC'],
    'Panamá': ['PAB', 'USD'],
    'Cuba': ['CUP', 'CUC'],
    'Puerto Rico': ['USD'],
    'República Dominicana': ['DOP'],
    'Haití': ['HTG'],
    'Jamaica': ['JMD'],
    'Bahamas': ['BSD'],
    'Aruba': ['AWG'],
    'Curazao': ['ANG'],
    'Bermudas': ['USD', 'GBP'],
    'Antigua y Barbuda': ['XCD'],
    'Barbados': ['BBD'],
    'Dominica': ['XCD'],
    'Granada': ['XCD'],
    'San Cristóbal y Nieves': ['XCD'],
    'Santa Lucía': ['XCD'],
    'San Vicente y las Granadinas': ['XCD'],
    'Trinidad y Tobago': ['TTD'],
    'Islas Caimán': ['KYD'],
    // 4. Sudamérica
    'Colombia': ['COP'],
    'Venezuela': ['VES', 'VED'],
    'Ecuador': ['USD'],
    'Perú': ['PEN'],
    'Brasil': ['BRL'],
    'Bolivia': ['BOB'],
    'Chile': ['CLP'],
    'Argentina': ['ARS'],
    'Paraguay': ['PYG'],
    'Uruguay': ['UYU'],
    'Guyana': ['GYD'],
    'Surinam': ['SRD'],
    'Islas Malvinas': ['FKP', 'GBP'],
    // 5. Europa
    'España': ['EUR', 'ESP'],
    'Unión Europea': ['EUR'],
    'Reino Unido': ['GBP'],
    'Francia': ['EUR'],
    'Alemania': ['EUR'],
    'Italia': ['EUR'],
    'Portugal': ['EUR'],
    'Suiza': ['CHF'],
    'Bélgica': ['EUR'],
    'Países Bajos': ['EUR'],
    'Irlanda': ['EUR'],
    'Austria': ['EUR'],
    'Ciudad del Vaticano': ['EUR'],
    'San Marino': ['EUR'],
    'Andorra': ['EUR'],
    'Dinamarca': ['DKK'],
    'Noruega': ['NOK'],
    'Suecia': ['SEK'],
    'Finlandia': ['EUR'],
    'Islandia': ['ISK'],
    'Polonia': ['PLN'],
    'República Checa': ['CZK'],
    'Eslovaquia': ['EUR'],
    'Hungría': ['HUF'],
    'Rumanía': ['RON'],
    'Bulgaria': ['BGN'],
    'Grecia': ['EUR'],
    'Chipre': ['EUR'],
    'Turquía': ['TRY'],
    'Rusia': ['RUB'],
    'Ucrania': ['UAH'],
    'Bielorrusia': ['BYN'],
    'Moldavia': ['MDL'],
    'Lituania': ['EUR'],
    'Letonia': ['EUR'],
    'Estonia': ['EUR'],
    'Albania': ['ALL'],
    'Bosnia y Herzegovina': ['BAM'],
    'Croacia': ['EUR', 'HRK'],
    'Eslovenia': ['EUR'],
    'Macedonia del Norte': ['MKD'],
    'Montenegro': ['EUR'],
    'Serbia': ['RSD'],
    'Gibraltar': ['GIP', 'GBP'],
    'Groenlandia': ['DKK'],
    'Islas Feroe': ['DKK'],
    'Liechtenstein': ['CHF'],
    'Luxemburgo': ['EUR'],
    'Mónaco': ['EUR'],
    'Malta': ['EUR'],
    // 6. Asia y Medio Oriente
    'Japón': ['JPY'],
    'China': ['CNY'],
    'Corea del Sur': ['KRW'],
    'Corea del Norte': ['KPW'],
    'Taiwán': ['TWD'],
    'Hong Kong': ['HKD'],
    'Macao': ['MOP'],
    'Filipinas': ['PHP'],
    'India': ['INR'],
    'Indonesia': ['IDR'],
    'Malasia': ['MYR'],
    'Singapur': ['SGD'],
    'Tailandia': ['THB'],
    'Vietnam': ['VND'],
    'Camboya': ['KHR', 'USD'],
    'Laos': ['LAK'],
    'Birmania (Myanmar)': ['MMK'],
    'Bangladés': ['BDT'],
    'Pakistán': ['PKR'],
    'Sri Lanka': ['LKR'],
    'Nepal': ['NPR'],
    'Bután': ['BTN', 'INR'],
    'Maldivas': ['MVR'],
    'Afganistán': ['AFN'],
    'Israel': ['ILS'],
    'Palestina': ['ILS', 'JOD', 'USD'],
    'Jordania': ['JOD'],
    'Líbano': ['LBP', 'USD'],
    'Siria': ['SYP'],
    'Irak': ['IQD'],
    'Irán': ['IRR'],
    'Arabia Saudita': ['SAR'],
    'Emiratos Árabes Unidos': ['AED'],
    'Catar': ['QAR'],
    'Baréin': ['BHD'],
    'Kuwait': ['KWD'],
    'Omán': ['OMR'],
    'Yemen': ['YER'],
    'Armenia': ['AMD'],
    'Azerbaiyán': ['AZN'],
    'Georgia': ['GEL'],
    'Kazajistán': ['KZT'],
    'Kirguistán': ['KGS', 'UZS'],
    'Tayikistán': ['TJS'],
    'Turkmenistán': ['TMT'],
    'Uzbekistán': ['UZS'],
    'Brunéi': ['SGD'],
    'Mongolia': ['MNT'],
    'Timor Oriental': ['USD'],
    // 7. Oceanía
    'Australia': ['AUD'],
    'Nueva Zelanda': ['NZD'],
    'Fiyi': ['FJD'],
    'Islas Cook': ['NZD'],
    'Islas Marshall': ['USD'],
    'Islas Salomón': ['SBD'],
    'Micronesia': ['USD'],
    'Nauru': ['AUD'],
    'Nueva Caledonia': ['XPF'],
    'Palaos': ['USD'],
    'Papúa Nueva Guinea': ['PGK'],
    'Polinesia Francesa': ['XPF'],
    'Samoa': ['WST'],
    'Tonga': ['TOP'],
    'Tuvalu': ['AUD'],
    'Vanuatu': ['VUV'],
    'Kiribati': ['AUD'],
    // 8. África
    'Egipto': ['EGP'],
    'Marruecos': ['MAD'],
    'Argelia': ['DZD'],
    'Túnez': ['TND'],
    'Libia': ['LYD'],
    'Sudáfrica': ['ZAR'],
    'Nigeria': ['NGN'],
    'Kenia': ['KES'],
    'Etiopía': ['ETB'],
    'Angola': ['AOA'],
    'Benín': ['XOF'],
    'Botsuana': ['BWP'],
    'Burkina Faso': ['XOF'],
    'Burundi': ['BIF'],
    'Cabo Verde': ['CVE'],
    'Camerún': ['XAF'],
    'Chad': ['XAF'],
    'Comoras': ['KMF'],
    'Costa de Marfil': ['XOF'],
    'Eritrea': ['ERN'],
    'Esuatini (Suazilandia)': ['SZL', 'ZAR'],
    'Gabón': ['XAF'],
    'Gambia': ['GMD'],
    'Ghana': ['GHS'],
    'Guinea': ['GNF'],
    'Guinea Ecuatorial': ['XAF'],
    'Guinea-Bisáu': ['XOF'],
    'Lesoto': ['LSL', 'ZAR'],
    'Liberia': ['LRD', 'USD'],
    'Madagascar': ['MGA'],
    'Malaui': ['MWK'],
    'Malí': ['XOF'],
    'Mauricio': ['MUR'],
    'Mauritania': ['MRU'],
    'Mozambique': ['MZN'],
    'Namibia': ['NAD', 'ZAR'],
    'Níger': ['XOF'],
    'República Centroafricana': ['XAF'],
    'República del Congo': ['XAF'],
    'República Democrática del Congo': ['CDF'],
    'Ruanda': ['RWF'],
    'Santo Tomé y Príncipe': ['STN'],
    'Senegal': ['XOF'],
    'Seychelles': ['SCR'],
    'Sierra Leona': ['SLE', 'SLL'],
    'Somalia': ['SOS'],
    'Sudán': ['SDG'],
    'Sudán del Sur': ['SSP'],
    'Tanzania': ['TZS'],
    'Togo': ['XOF'],
    'Uganda': ['UGX'],
    'Yibuti': ['DJF'],
    'Zambia': ['ZMW'],
    'Zimbabue': ['ZWL', 'USD'],
  };

  static const countryOther = 'Otro';

  static const List<String> denominations = [
    '1', '2', '5', '10', '20', '50', '100', '200', '500', '1000', '2000', '5000', 'Otro',
  ];

  static const List<String> grades = [
    'Sin circular', 'Excelente', 'Muy buena', 'Buena', 'Regular',
  ];

  static const List<String> coinMaterials = [
    'Cuproníquel', 'Plata', 'Bronce', 'Oro', 'Latón', 'Aluminio', 'Bimetálica', 'Acero', 'Papel',
  ];

  static const List<String> specialEditionReasons = [
    'Conmemorativa', 'Prueba de acuñación', 'Error de impresión', 'Serie limitada',
    'Aniversario', 'Emisión de cambio de régimen', 'Otro',
  ];

  static const Map<String, String> currencySingularReplacements = {
    'Pesos': 'Peso',
    'Dólares': 'Dólar',
    'Dolares': 'Dólar',
    'Soles': 'Sol',
    'Euros': 'Euro',
    'Libras': 'Libra',
    'Quetzales': 'Quetzal',
    'Florines': 'Florín',
    'Colones': 'Colón',
    'Pesetas': 'Peseta',
    'Mexicanos': 'Mexicano',
    'Estadounidenses': 'Estadounidense',
    'Canadienses': 'Canadiense',
    'Colombianos': 'Colombiano',
    'Chilenos': 'Chileno',
    'Argentinos': 'Argentino',
    'Cubanos': 'Cubano',
    'Dominicanos': 'Dominicano',
  };

  static const Map<String, String> normalizeCurrencyReplacements = {
    'pesos': 'peso',
    'dólares': 'dólar',
    'dolares': 'dólar',
    'soles': 'sol',
    'euros': 'euro',
    'libras': 'libra',
  };

  static const Map<String, String> regexNationalityReplacements = {
    AppTechnicalStrings.regexSpaceMexicanos: ' mexicano',
    AppTechnicalStrings.regexSpaceEstadounidenses: ' estadounidense',
    AppTechnicalStrings.regexSpaceCanadienses: ' canadiense',
    AppTechnicalStrings.regexSpaceColombianos: ' colombiano',
    AppTechnicalStrings.regexSpaceChilenos: ' chileno',
    AppTechnicalStrings.regexSpaceArgentinos: ' argentino',
    AppTechnicalStrings.regexSpaceCubanos: ' cubano',
    AppTechnicalStrings.regexSpaceDominicanos: ' dominicano',
  };

  static const Map<String, int> gradeKeywords = {
    'fdc': 0,
    'unc': 0,
    'sin circular': 0,
    'ebc': 1,
    'xf': 1,
    'excelente': 1,
    'mbc': 2,
    'vf': 2,
    'muy buena': 2,
    'bc': 3,
    'buena': 3,
    'mc': 4,
    'regular': 4,
  };

  static const Map<String, String> materialKeywords = {
    'cuproníquel': 'Cuproníquel',
    'cuproniquel': 'Cuproníquel',
    'cu-ni': 'Cuproníquel',
    'plata': 'Plata',
    'silver': 'Plata',
    'bronce': 'Bronce',
    'bronze': 'Bronce',
    'oro': 'Oro',
    'gold': 'Oro',
    'latón': 'Latón',
    'laton': 'Latón',
    'brass': 'Latón',
    'aluminio': 'Aluminio',
    'aluminum': 'Aluminio',
    'bimetálica': 'Bimetálica',
    'bimetalica': 'Bimetálica',
    'bimetal': 'Bimetálica',
    'acero': 'Acero',
    'steel': 'Acero',
    'papel': 'Papel',
    'paper': 'Papel',
  };

  static const Map<String, int> specialEditionKeywords = {
    'conmemorativa': 0,
    'commemorative': 0,
    'proof': 1,
    'prueba': 1,
    'error': 2,
    'impresión': 2,
    'impresion': 2,
    'limitada': 3,
    'numeración': 3,
    'numeracion': 3,
    'aniversario': 4,
    'histórico': 4,
    'historico': 4,
    'régimen': 5,
    'regimen': 5,
    'cambio': 5,
  };
}

/// Organized namespace for Product Lookup Service Constants.
abstract final class AppTechnicalProductLookup {
  static const List<String> openFactsDomains = [
    AppTechnicalStrings.domainOpenFoodFacts,
    AppTechnicalStrings.domainOpenBeautyFacts,
    AppTechnicalStrings.domainOpenProductsFacts,
    AppTechnicalStrings.domainOpenPetFoodFacts,
  ];
}
