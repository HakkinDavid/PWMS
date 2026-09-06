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
  static const expirations = '/expirations';
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
  static const paramTargetEntityId = 'targetEntityId';
  static const currencyMxn = 'MXN';
  static const localeEs = 'es';
  static const dateFormatMonthYear = 'MMMM yyyy';
  static const dateFormatFullDate = 'EEEE, d MMMM yyyy';
  static const keyConsumedAt = 'consumedAt';
  static const actionKeyConsume = 'consume';
  static const actionKeyEditDate = 'editDate';
  static const actionKeyLocate = 'locate';
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
  static String containerLevelKey(String joinedPath) => 'cont_$joinedPath';
  static String locationLevelKey(String? locationId) => 'loc_${locationId ?? unassignedLocationId}';
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
  static const ruleNumismaticEmissionOutlier = 'numismatic_emission_outlier';
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
  static const actionSplit = 'split';
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
  static const prefixNumisOutlier = 'numis_outlier_';
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
  static const propNombreLower = 'nombre';
  static const propNameLower = 'name';
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
  static const eventTypeSubspeciesSplit = 'subspecies_split';
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
  static const keyInventoryViewMode = 'inventory_view_mode';
  static const keyCatalogViewMode = 'catalog_view_mode';

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
  static const magPaisWithAccent = 'País';
  static const magPaisWithoutAccent = 'Pais';
  static const magPaisLower = 'país';
  static const magPaisWithoutAccentLower = 'pais';
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
  static const keyOriginalName = 'original_name';
  static const keyMovedCount = 'moved_count';
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
  static const expirations = AppTechnicalStrings.expirations;
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
  static const paramTargetEntityId = AppTechnicalStrings.paramTargetEntityId;
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

  /// Comprehensive map of modern and historical currency codes to full Spanish currency names (plural).
  static const Map<String, String> currencyMap = {
    // 1. España e Hispanoamérica histórica y moderna (1500s - presente)
    'REAL': 'Reales Españoles',
    'ESC': 'Escudos Españoles',
    'MRV': 'Maravedís',
    'ESP': 'Pesetas Españolas',
    'RDV': 'Reales de Vellón',
    'MXN': 'Pesos Mexicanos',
    'MXP': 'Pesos Mexicanos Antiguos',
    'MXR': 'Reales Mexicanos Coloniales e Imperiales',
    'MXE': 'Escudos Mexicanos de Oro',
    'ARS': 'Pesos Argentinos',
    'ARA': 'Australes Argentinos',
    'ARL': 'Pesos Ley Argentinos',
    'ARM': 'Pesos Moneda Nacional Argentinos',
    'ARP': 'Pesos Argentinos (1983-1985)',
    'BOB': 'Bolivianos',
    'BOP': 'Pesos Bolivianos',
    'BOS': 'Soles y Bolivianos Antiguos',
    'BRL': 'Reales Brasileños',
    'BRR': 'Cruzeiros Reales Brasileños',
    'BRE': 'Cruzeiros Brasileños (1990-1993)',
    'BRN': 'Cruzados Nuevos Brasileños',
    'BRC': 'Cruzados Brasileños',
    'BRB': 'Cruzeiros Brasileños Antiguos',
    'BRS': 'Reales Brasileños Históricos (Réis)',
    'CLP': 'Pesos Chilenos',
    'CLE': 'Escudos Chilenos',
    'CLF': 'Pesos Chilenos Antiguos',
    'COP': 'Pesos Colombianos',
    'COP_HIST': 'Reales y Pesos Colombianos Antiguos',
    'CRC': 'Colones Costarricenses',
    'CRC_HIST': 'Reales y Pesos Costarricenses Antiguos',
    'CUP': 'Pesos Cubanos',
    'CUC': 'Pesos Cubanos Convertibles',
    'DOP': 'Pesos Dominicanos',
    'DOP_HIST': 'Reales y Francos Dominicanos Antiguos',
    'GTQ': 'Quetzales Guatemaltecos',
    'GTQ_HIST': 'Reales y Pesos Guatemaltecos Antiguos',
    'GTH_CENT': 'Reales y Pesos Federales Centroamericanos',
    'HNL': 'Lempiras Hondureños',
    'HNL_HIST': 'Reales y Pesos Hondureños Antiguos',
    'HTG': 'Gourdes Haitianos',
    'HTG_HIST': 'Escudos y Reales Haitianos Antiguos',
    'NIO': 'Córdobas Nicaragüenses',
    'NIO_HIST': 'Reales y Pesos Nicaragüenses Antiguos',
    'PAB': 'Balboas Panameños',
    'PEN': 'Soles Peruanos',
    'PEI': 'Intis Peruanos',
    'PEH': 'Soles de Oro Peruanos',
    'PER': 'Reales y Pesos Peruanos Antiguos',
    'PYG': 'Guaraníes Paraguayos',
    'PYP': 'Pesos y Reales Paraguayos Antiguos',
    'SVC': 'Colones Salvadoreños',
    'SVC_HIST': 'Reales y Pesos Salvadoreños Antiguos',
    'UYU': 'Pesos Uruguayos',
    'UYP': 'Pesos Uruguayos Antiguos',
    'VES': 'Bolívares Soberanos Venezolanos',
    'VED': 'Bolívares Soberanos Digitales Venezolanos',
    'VEF': 'Bolívares Fuertes Venezolanos',
    'VEB': 'Bolívares Venezolanos Históricos',
    'VEN': 'Venezolanos (Moneda)',
    'VES_HIST': 'Reales y Pesos Venezolanos Antiguos',

    // 2. Norteamérica y Caribe
    'USD': 'Dólares Estadounidenses',
    'USC': 'Dólares Continentales de EE.UU.',
    'CSA': 'Dólares Confederados',
    'HWI': 'Dólares de Hawái',
    'CAD': 'Dólares Canadienses',
    'CAD_HIST': 'Libras y Farthings Canadienses Antiguos',
    'NFL': 'Dólares y Libras de Terranova',
    'BZD': 'Dólares Beliceños',
    'JMD': 'Dólares Jamaicanos',
    'JMD_HIST': 'Libras Jamaicanas',
    'BSD': 'Dólares Bahameños',
    'BBD': 'Dólares de Barbados',
    'TTD': 'Dólares de Trinidad y Tobago',
    'KYD': 'Dólares de las Islas Caimán',
    'XCD': 'Dólares del Caribe Oriental',
    'AWG': 'Florines Arubeños',
    'ANG': 'Florines Antillanos Holandeses',
    'DWI': 'Dólares y Rigsdaler de las Indias Occidentales Danesas',
    'FKP': 'Libras de las Islas Malvinas',
    'GYD': 'Dólares Guyaneses',
    'SRD': 'Dólares Surinameses',
    'SRG': 'Florines Surinameses',

    // 3. Europa (1500s - presente)
    'EUR': 'Euros',
    'GBP': 'Libras Esterlinas',
    'GBP_OLD': 'Libras, Chelines y Peniques Británicos (pre-decimal)',
    'SCO': 'Libras y Chelines Escoceses',
    'FRF': 'Francos Franceses',
    'LVT': 'Libras Tornesas (Livres Tournois)',
    'ECU': 'Écus Franceses (Escudos Franceses)',
    'LDO': 'Luises de Oro Franceses (Louis d\'or)',
    'DEM': 'Marcos Alemanes',
    'DDM': 'Marcos de la RDA (Alemania Oriental)',
    'RKM': 'Reichsmark Alemanes',
    'RTM': 'Rentenmark Alemanes',
    'PRM': 'Papiermark Alemanes',
    'FRG': 'Marcos de Oro Alemanes (Goldmark)',
    'GTH': 'Táleros Germánicos (Thaler)',
    'GGL': 'Florines Alemanes (Gulden)',
    'CHF': 'Francos Suizos',
    'CHF_HIST': 'Francos y Batzen Suizos Cantonales',
    'ITL': 'Liras Italianas',
    'VEC': 'Ducados, Zecchinos y Liras Venecianas',
    'GEN': 'Liras y Luigini Genoveses',
    'PST': 'Escudos y Baioccos Pontificios',
    'VAL': 'Liras Vaticanas',
    'SML': 'Liras de San Marino',
    'NPL': 'Ducados, Piastras y Carlini Napolitanos',
    'TOS': 'Liras y Francesconi Toscanos',
    'SAR_HIST': 'Liras Sardas',
    'MIL': 'Liras Milanesas',
    'MLT_ORD': 'Escudos y Tari de la Orden de Malta',
    'MTL': 'Liras Maltesas',
    'ATS': 'Chelines Austriacos',
    'ATH': 'Coronas Austrohúngaras (Krone)',
    'ATG': 'Florines Austrohúngaros (Gulden)',
    'MTT': 'Táleros de María Teresa',
    'NLG': 'Florines Neerlandeses',
    'NLG_HIST': 'Ducatones, Daalders y Stuivers Neerlandeses',
    'BEF': 'Francos Belgas',
    'LUF': 'Francos Luxemburgueses',
    'PTE': 'Escudos Portugueses',
    'POR': 'Reales Portugueses (Réis)',
    'GRD': 'Dracmas Griegas',
    'PHX': 'Fénix Griegos',
    'IEP': 'Libras Irlandesas',
    'FIM': 'Marcos Finlandeses',
    'SEK': 'Coronas Suecas',
    'SEK_HIST': 'Riksdaler Suecos',
    'NOK': 'Coronas Noruegas',
    'NOK_HIST': 'Speciedaler Noruegos',
    'DKK': 'Coronas Danesas',
    'DKK_HIST': 'Rigsdaler Daneses',
    'ISK': 'Coronas Islandesas',
    'GIP': 'Libras de Gibraltar',
    'RUB': 'Rublos Rusos',
    'RUR': 'Rublos Rusos Zaristas / Pre-1998',
    'SUR': 'Rublos Soviéticos',
    'UAH': 'Grivnas Ucranianas',
    'BYN': 'Rublos Bielorrusos',
    'MDL': 'Leus Moldavos',
    'PRB': 'Rublos de Transnistria',
    'PLN': 'Zlotys Polacos',
    'PLZ': 'Zlotys Polacos Antiguos',
    'PLX': 'Zlotys y Grosz Polacos Históricos',
    'CZK': 'Coronas Checas',
    'CSK': 'Coronas Checoslovacas',
    'BOM': 'Coronas de Bohemia y Moravia',
    'SKK': 'Coronas Eslovacas',
    'HUF': 'Forintos Húngaros',
    'HUP': 'Pengos Húngaros (Pengő)',
    'HUK': 'Coronas Húngaras (Korona)',
    'RON': 'Leus Rumanos',
    'ROL': 'Leus Rumanos Antiguos',
    'BGN': 'Levs Búlgaros',
    'BGL': 'Levs Búlgaros Antiguos',
    'RSD': 'Dinares Serbios',
    'YUD': 'Dinares Yugoslavos',
    'HRK': 'Kunas Croatas',
    'HRD': 'Dinares Croatas',
    'BAM': 'Marcos Convertibles de Bosnia-Herzegovina',
    'ALL': 'Leks Albaneses',
    'MKD': 'Denares Macedonios',
    'TRY': 'Liras Turcas',
    'OTE': 'Piastras, Kurus y Akces Otomanos',
    'CYP': 'Liras Chipriotas',

    // 4. Asia, Medio Oriente y Cáucaso (1500s - presente)
    'JPY': 'Yenes Japoneses',
    'JPN_EDO': 'Mon, Ryo y Koban Japoneses (Edo)',
    'CNY': 'Yuanes Chinos',
    'CHN_QING': 'Wen y Taels de la Dinastía Qing',
    'CHN_REP': 'Yuanes de la República de China (Dragón/Yuan Shikai)',
    'MCK': 'Yuanes de Manchukuo',
    'TIB': 'Tanggas y Sangs Tibetanos',
    'KRW': 'Wones Surcoreanos',
    'KPW': 'Wones Norcoreanos',
    'KOR_JOSEON': 'Mun y Yang de Joseon',
    'TWD': 'Nuevos Dólares Taiwaneses',
    'HKD': 'Dólares de Hong Kong',
    'MOP': 'Patacas de Macao',
    'PHP': 'Pesos Filipinos',
    'PHP_HIST': 'Reales y Pesos Filipinos Coloniales',
    'INR': 'Rupias Indias',
    'IND_MUG': 'Mohurs y Rupias del Imperio Mogol',
    'IND_EIC': 'Rupias de la Compañía Británica de las Indias Orientales',
    'IND_BRIT': 'Rupias de la India Británica',
    'IND_POR': 'Rupias y Tangas de la India Portuguesa',
    'IND_FR': 'Rupias y Fanos de la India Francesa',
    'IDR': 'Rupias Indonesias',
    'NID': 'Florines de las Indias Neerlandesas (VOC/Gulden)',
    'MYR': 'Ringgits Malayos',
    'STR': 'Dólares de los Asentamientos de los Estrechos',
    'MAL': 'Dólares de Malaya y Borneo',
    'SGD': 'Dólares de Singapur',
    'BND': 'Dólares de Brunéi',
    'THB': 'Bahts Tailandeses',
    'THB_HIST': 'Ticals y Fuangs Siameses Antiguos',
    'VND': 'Dongs Vietnamitas',
    'FIC': 'Piastras de Comercio de Indochina Francesa',
    'ANN': 'Sapèques y Dong de Annam',
    'KHR': 'Rieles Camboyanos',
    'LAK': 'Kips Laosianos',
    'MMK': 'Kyats Birmanos',
    'MMK_HIST': 'Kyats y Peacock Rupees Birmanos Antiguos',
    'BDT': 'Takas Bangladesíes',
    'PKR': 'Rupias Pakistaníes',
    'LKR': 'Rupias de Sri Lanka',
    'CEY': 'Rupias y Rixdollars de Ceilán',
    'NPR': 'Rupias Nepalíes',
    'BTN': 'Ngultrums Butaneses',
    'MVR': 'Rupias Maldivas',
    'AFN': 'Afganis',
    'AFG_HIST': 'Rupias y Kranes Afganos Antiguos',
    'IRR': 'Riales Iraníes',
    'PER_HIST': 'Tomán, Qiran y Shahi Persas',
    'IQD': 'Dinares Iraquíes',
    'SYP': 'Libras Sirias',
    'LBP': 'Libras Libanesas',
    'JOD': 'Dinares Jordanos',
    'ILS': 'Nuevos Shekels Israelíes',
    'PAL': 'Libras Palestinas (Mandato Británico)',
    'SAR': 'Riyales Saudíes',
    'HEJ': 'Riyales de Hiyaz',
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

    // 5. Oceanía (1500s - presente)
    'AUD': 'Dólares Australianos',
    'AUP': 'Libras Australianas',
    'NZD': 'Dólares Neozelandeses',
    'NZP': 'Libras Neozelandesas',
    'FJD': 'Dólares Fiyianos',
    'PGK': 'Kinas de Papúa Nueva Guinea',
    'SBD': 'Dólares de las Islas Salomón',
    'VUV': 'Vatus Vanuatuenses',
    'WST': 'Talas Samoanos',
    'TOP': 'Paangas Tonganos',
    'XPF': 'Francos CFP',

    // 6. África (1500s - presente)
    'EGP': 'Libras Egipcias',
    'EGY_HIST': 'Piastras y Milliemes Egipcios Históricos',
    'ZAR': 'Rands Sudafricanos',
    'ZAR_HIST': 'Libras y Florines Sudafricanos / Transvaal',
    'NGN': 'Nairas Nigerianas',
    'NGA_HIST': 'Libras de África Occidental / Nigeria',
    'BIA': 'Libras de Biafra',
    'MAD': 'Dírhams Marroquíes',
    'MAD_HIST': 'Riyales y Mazunas Marroquíes',
    'DZD': 'Dinares Argelinos',
    'ALG_HIST': 'Francos Argelinos',
    'TND': 'Dinares Tunecinos',
    'TUN_HIST': 'Francos y Piastras Tunecinas',
    'LYD': 'Dinares Libios',
    'LYB_HIST': 'Liras y Piastras Libias',
    'KES': 'Chelines Kenianos',
    'EAS': 'Chelines de África Oriental (East African Shilling)',
    'ETB': 'Birrs Etíopes',
    'ETB_HIST': 'Talari de Menelik y Gersh Etíopes',
    'GHS': 'Cedis Ghaneses',
    'GHA_HIST': 'Libras de la Costa de Oro',
    'XOF': 'Francos CFA de África Occidental',
    'XAF': 'Francos CFA de África Central',
    'MUR': 'Rupias Mauricianas',
    'BWP': 'Pulas Botsuanas',
    'NAD': 'Dólares Namibios',
    'TZS': 'Chelines Tanzanos',
    'ZNZ': 'Rupias y Ryales de Zanzíbar',
    'UGX': 'Chelines Ugandeses',
    'AOA': 'Kwanzas Angoleños',
    'ANG_POR': 'Escudos y Reis Angoleños Portugueses',
    'MZN': 'Meticales Mozambiqueños',
    'MOZ_POR': 'Escudos y Reis Mozambiqueños Portugueses',
    'ZMW': 'Kwanzas Zambianos',
    'ZWL': 'Dólares Zimbabuenses',
    'RHO': 'Libras y Dólares de Rodesia',
    'SZL': 'Lilangeni Suazis',
    'LSL': 'Lotis Lesotenses',
    'BIF': 'Francos Burundeses',
    'CVE': 'Escudos Caboverdianos',
    'KMF': 'Francos Comorenses',
    'CDF': 'Francos Congoleños',
    'ZAI': 'Zaires Congoleños',
    'KAT': 'Francos de Katanga',
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

  /// Comprehensive list of sovereign states, overseas territories, and historical issuing entities from 1500s to date.
  static const List<String> countries = [
    // 1. México y Mesoamérica Histórica
    'México',
    'Virreinato de Nueva España',
    'Imperio Mexicano (Primer y Segundo Imperio)',
    'República de Texas',
    'República de Yucatán',

    // 2. Norteamérica
    'Estados Unidos',
    'Estados Confederados de América',
    'Trece Colonias Británicas de América',
    'Reino de Hawái',
    'Canadá',
    'Terranova (Newfoundland)',
    'Provincias de la América Británica',
    'Bermudas',
    'Groenlandia',
    'San Pedro y Miquelón',

    // 3. Centroamérica y Caribe
    'Guatemala',
    'Belice',
    'El Salvador',
    'Honduras',
    'Nicaragua',
    'Costa Rica',
    'Panamá',
    'Provincias Unidas del Centro de América',
    'Cuba',
    'Puerto Rico',
    'República Dominicana',
    'Haití',
    'Jamaica',
    'Bahamas',
    'Barbados',
    'Trinidad y Tobago',
    'Curazao',
    'Aruba',
    'San Martín',
    'Antillas Neerlandesas',
    'Indias Occidentales Danesas',
    'Indias Occidentales Británicas',
    'Antigua y Barbuda',
    'Dominica',
    'Granada',
    'San Cristóbal y Nieves',
    'Santa Lucía',
    'San Vicente y las Granadinas',
    'Islas Caimán',
    'Islas Vírgenes Británicas',
    'Islas Vírgenes de EE.UU.',
    'Islas Turcas y Caicos',
    'Anguila',
    'Montserrat',
    'Guadalupe',
    'Martinica',

    // 4. Sudamérica
    'Colombia',
    'Gran Colombia',
    'Estados Unidos de Colombia',
    'República de la Nueva Granada',
    'Confederación Granadina',
    'Virreinato de Nueva Granada',
    'Venezuela',
    'Ecuador',
    'Perú',
    'Virreinato del Perú',
    'Confederación Perú-Boliviana',
    'Bolivia',
    'Brasil',
    'Imperio del Brasil',
    'Brasil Colonial Portugués',
    'Chile',
    'Capitanía General de Chile',
    'Argentina',
    'Provincias Unidas del Río de la Plata',
    'Confederación Argentina',
    'Estado de Buenos Aires',
    'Virreinato del Río de la Plata',
    'Paraguay',
    'Uruguay',
    'Guyana',
    'Surinam',
    'Guayana Francesa',
    'Islas Malvinas',

    // 5. Europa
    'España',
    'Corona de Castilla',
    'Corona de Aragón',
    'Reino de Navarra',
    'Unión Europea',
    'Reino Unido',
    'Reino de Inglaterra',
    'Reino de Escocia',
    'Reino de Irlanda',
    'Irlanda',
    'Francia',
    'Reino de Francia',
    'Primer Imperio Francés',
    'Segundo Imperio Francés',
    'Francia de Vichy',
    'Países Bajos',
    'Países Bajos Españoles',
    'Países Bajos Austriacos',
    'Bélgica',
    'Luxemburgo',
    'Sacro Imperio Romano Germánico',
    'Confederación del Rin',
    'Confederación Germánica',
    'Confederación de Alemania del Norte',
    'Imperio Alemán',
    'República de Weimar',
    'Tercer Reich Alemán',
    'República Democrática Alemana (RDA)',
    'República Federal de Alemania',
    'Reino de Prusia',
    'Reino de Baviera',
    'Reino de Sajonia',
    'Reino de Wurtemberg',
    'Reino de Hannover',
    'Gran Ducado de Baden',
    'Estados Alemanes Históricos',
    'Austria',
    'Imperio Austriaco',
    'Imperio Austrohúngaro',
    'Hungría',
    'Reino de Hungría',
    'República Checa',
    'Eslovaquia',
    'Checoslovaquia',
    'Reino de Bohemia',
    'Protectorado de Bohemia y Moravia',
    'Suiza',
    'Cantones Suizos Históricos',
    'Liechtenstein',
    'Italia',
    'Reino de Italia',
    'Estados Pontificios',
    'Ciudad del Vaticano',
    'República de Venecia',
    'República de Génova',
    'Reino de las Dos Sicilias',
    'Reino de Nápoles',
    'Reino de Sicilia',
    'Reino de Cerdeña',
    'Gran Ducado de Toscana',
    'Ducado de Milán',
    'Ducado de Parma',
    'Ducado de Módena',
    'República de Lucca',
    'San Marino',
    'Orden Soberana y Militar de Malta',
    'Malta',
    'Mónaco',
    'Andorra',
    'Portugal',
    'Reino de Portugal',
    'Dinamarca',
    'Reino de Dinamarca-Noruega',
    'Noruega',
    'Suecia',
    'Imperio Sueco',
    'Finlandia',
    'Gran Ducado de Finlandia',
    'Islandia',
    'Polonia',
    'Mancomunidad Polaco-Lituana',
    'Zarato de Polonia',
    'Gran Ducado de Varsovia',
    'Lituania',
    'Gran Ducado de Lituania',
    'Letonia',
    'Estonia',
    'Bielorrusia',
    'Ucrania',
    'República Popular Ucraniana',
    'Moldavia',
    'Transnistria',
    'Rumanía',
    'Principados Danubianos',
    'Bulgaria',
    'Grecia',
    'Reino de Grecia',
    'Chipre',
    'Albania',
    'Yugoslavia',
    'Serbia y Montenegro',
    'Serbia',
    'Croacia',
    'Estado Independiente de Croacia',
    'Eslovenia',
    'Bosnia y Herzegovina',
    'Montenegro',
    'Macedonia del Norte',
    'Kosovo',
    'Gibraltar',
    'Jersey',
    'Guernesey',
    'Isla de Man',
    'Islas Feroe',
    'Svalbard',
    'Rusia',
    'Zarato de Rusia',
    'Imperio Ruso',
    'Unión Soviética (URSS)',

    // 6. Medio Oriente y Cáucaso
    'Imperio Otomano',
    'Turquía',
    'Imperio Persa (Safávida / Qajar / Pahlaví)',
    'Irán',
    'Irak',
    'Reino de Irak',
    'Siria',
    'Líbano',
    'Jordania',
    'Emirato de Transjordania',
    'Israel',
    'Palestina',
    'Mandato Británico de Palestina',
    'Arabia Saudita',
    'Reino de Hiyaz',
    'Yemen',
    'Omán',
    'Emiratos Árabes Unidos',
    'Estados de la Tregua',
    'Catar',
    'Baréin',
    'Kuwait',
    'Armenia',
    'Azerbaiyán',
    'Georgia',

    // 7. Asia Central, Oriental y Meridional
    'China',
    'Dinastía Ming',
    'Dinastía Qing',
    'República de China (1912-1949)',
    'Manchukuo',
    'Tíbet',
    'Taiwán',
    'Hong Kong',
    'Macao',
    'Japón',
    'Shogunato Tokugawa (Período Edo)',
    'Imperio del Japón',
    'Corea',
    'Dinastía Joseon',
    'Imperio Coreano',
    'Corea del Sur',
    'Corea del Norte',
    'Mongolia',
    'India',
    'Imperio Mogol',
    'Compañía Británica de las Indias Orientales',
    'Raj Británico',
    'Estados Principescos de la India',
    'India Portuguesa',
    'India Francesa',
    'Pakistán',
    'Bangladés',
    'Sri Lanka (Ceilán)',
    'Nepal',
    'Bután',
    'Maldivas',
    'Afganistán',
    'Imperio Durrani',
    'Kazajistán',
    'Uzbekistán',
    'Turkmenistán',
    'Kirguistán',
    'Tayikistán',

    // 8. Sudeste Asiático
    'Filipinas',
    'Capitanía General de Filipinas',
    'Indonesia',
    'Indias Orientales Neerlandesas (VOC)',
    'Malasia',
    'Asentamientos de los Estrechos',
    'Malaya Británica',
    'Sarawak',
    'Borneo Septentrional Británico',
    'Singapur',
    'Brunéi',
    'Tailandia (Siam)',
    'Birmania (Myanmar)',
    'Vietnam',
    'Imperio de Annam',
    'Indochina Francesa',
    'Camboya',
    'Laos',
    'Timor Oriental',

    // 9. Oceanía
    'Australia',
    'Nueva Zelanda',
    'Fiyi',
    'Papúa Nueva Guinea',
    'Islas Salomón',
    'Vanuatu (Nuevas Hébridas)',
    'Samoa',
    'Samoa Americana',
    'Tonga',
    'Tuvalu',
    'Kiribati',
    'Nauru',
    'Micronesia',
    'Islas Marshall',
    'Palaos',
    'Islas Cook',
    'Niue',
    'Polinesia Francesa',
    'Nueva Caledonia',

    // 10. África
    'Egipto',
    'Jedivato / Sultanato / Reino de Egipto',
    'Marruecos',
    'Sultanato de Marruecos',
    'Protectorado Francés de Marruecos',
    'Protectorado Español de Marruecos',
    'Argelia',
    'Argelia Francesa',
    'Túnez',
    'Libia',
    'Libia Italiana',
    'Sudán',
    'Sudán Anglo-Egipcio',
    'Sudán del Sur',
    'Etiopía (Abisinia)',
    'Eritrea',
    'Eritrea Italiana',
    'Yibuti (Somalia Francesa)',
    'Somalia',
    'Somalia Británica',
    'Somalia Italiana',
    'Somalilandia',
    'Kenia',
    'Uganda',
    'Tanzania',
    'Sultanato de Zanzíbar',
    'África Oriental Alemana',
    'Tanganica',
    'Sudáfrica',
    'República de Sudáfrica (Transvaal)',
    'Estado Libre de Orange',
    'Colonia del Cabo',
    'Colonia de Natal',
    'Unión Sudafricana',
    'Namibia (África del Sudoeste)',
    'Botsuana (Bechuanalandia)',
    'Zimbabue (Rodesia)',
    'Zambia (Rodesia del Norte)',
    'Malaui (Nyasalandia)',
    'Mozambique',
    'Angola',
    'República Democrática del Congo',
    'Estado Libre del Congo',
    'Congo Belga',
    'Katanga',
    'Zaire',
    'República del Congo',
    'Gabón',
    'Camerún',
    'República Centroafricana',
    'Chad',
    'Guinea Ecuatorial (Guinea Española)',
    'Nigeria',
    'Biafra',
    'Ghana (Costa de Oro)',
    'Costa de Marfil',
    'Liberia',
    'Sierra Leona',
    'Guinea',
    'Guinea-Bisáu',
    'Senegal',
    'Gambia',
    'Malí (Sudán Francés)',
    'Níger',
    'Burkina Faso (Alto Volta)',
    'Benín (Dahomey)',
    'Togo',
    'Mauritania',
    'Sáhara Occidental (Sáhara Español)',
    'Cabo Verde',
    'Santo Tomé y Príncipe',
    'Madagascar',
    'Mauricio',
    'Seychelles',
    'Comoras',
    'Ruanda',
    'Burundi',
    'Lesoto (Basutolandia)',
    'Esuatini (Suazilandia)',

    // 11. Otro
    'Otro',
  ];

  /// Maps sovereign country and historical issuing entity names to their primary ISO & historical currency codes.
  static const Map<String, List<String>> countryToCurrenciesMap = {
    // México y Mesoamérica
    'México': ['MXN', 'MXP', 'MXR', 'MXE'],
    'Virreinato de Nueva España': ['REAL', 'ESC', 'MRV', 'MXR', 'MXE'],
    'Imperio Mexicano (Primer y Segundo Imperio)': ['MXR', 'MXE', 'MXP'],
    'República de Texas': ['USD'],
    'República de Yucatán': ['REAL', 'MXR'],

    // Norteamérica
    'Estados Unidos': ['USD', 'USC'],
    'Estados Confederados de América': ['CSA', 'USD'],
    'Trece Colonias Británicas de América': ['GBP_OLD', 'REAL', 'USC'],
    'Reino de Hawái': ['HWI', 'USD'],
    'Canadá': ['CAD', 'CAD_HIST'],
    'Terranova (Newfoundland)': ['NFL', 'CAD'],
    'Provincias de la América Británica': ['CAD_HIST', 'GBP_OLD'],
    'Bermudas': ['USD', 'GBP'],
    'Groenlandia': ['DKK'],
    'San Pedro y Miquelón': ['EUR', 'FRF'],

    // Centroamérica y Caribe
    'Guatemala': ['GTQ', 'GTQ_HIST', 'REAL'],
    'Belice': ['BZD', 'GBP_OLD'],
    'El Salvador': ['SVC', 'SVC_HIST', 'USD', 'REAL'],
    'Honduras': ['HNL', 'HNL_HIST', 'REAL'],
    'Nicaragua': ['NIO', 'NIO_HIST', 'REAL'],
    'Costa Rica': ['CRC', 'CRC_HIST', 'REAL'],
    'Panamá': ['PAB', 'USD', 'COP'],
    'Provincias Unidas del Centro de América': ['GTH_CENT', 'REAL'],
    'Cuba': ['CUP', 'CUC', 'REAL', 'USD'],
    'Puerto Rico': ['USD', 'ESP', 'REAL'],
    'República Dominicana': ['DOP', 'DOP_HIST', 'REAL'],
    'Haití': ['HTG', 'HTG_HIST'],
    'Jamaica': ['JMD', 'JMD_HIST', 'GBP_OLD'],
    'Bahamas': ['BSD', 'GBP_OLD'],
    'Barbados': ['BBD', 'GBP_OLD'],
    'Trinidad y Tobago': ['TTD', 'GBP_OLD'],
    'Curazao': ['ANG', 'NLG'],
    'Aruba': ['AWG', 'ANG', 'NLG'],
    'San Martín': ['ANG', 'EUR'],
    'Antillas Neerlandesas': ['ANG', 'NLG'],
    'Indias Occidentales Danesas': ['DWI', 'DKK_HIST'],
    'Indias Occidentales Británicas': ['XCD', 'GBP_OLD'],
    'Antigua y Barbuda': ['XCD'],
    'Dominica': ['XCD'],
    'Granada': ['XCD'],
    'San Cristóbal y Nieves': ['XCD'],
    'Santa Lucía': ['XCD'],
    'San Vicente y las Granadinas': ['XCD'],
    'Islas Caimán': ['KYD'],
    'Islas Vírgenes Británicas': ['USD'],
    'Islas Vírgenes de EE.UU.': ['USD', 'DWI'],
    'Islas Turcas y Caicos': ['USD'],
    'Anguila': ['XCD'],
    'Montserrat': ['XCD'],
    'Guadalupe': ['EUR', 'FRF'],
    'Martinica': ['EUR', 'FRF'],

    // Sudamérica
    'Colombia': ['COP', 'COP_HIST', 'REAL'],
    'Gran Colombia': ['COP_HIST', 'REAL'],
    'Estados Unidos de Colombia': ['COP_HIST', 'REAL'],
    'República de la Nueva Granada': ['COP_HIST', 'REAL'],
    'Confederación Granadina': ['COP_HIST', 'REAL'],
    'Virreinato de Nueva Granada': ['REAL', 'ESC', 'MRV'],
    'Venezuela': ['VES', 'VED', 'VEF', 'VEB', 'VEN', 'VES_HIST', 'REAL'],
    'Ecuador': ['USD', 'REAL'],
    'Perú': ['PEN', 'PEI', 'PEH', 'PER', 'REAL'],
    'Virreinato del Perú': ['REAL', 'ESC', 'MRV'],
    'Confederación Perú-Boliviana': ['PER', 'BOS', 'REAL'],
    'Bolivia': ['BOB', 'BOP', 'BOS', 'REAL'],
    'Brasil': ['BRL', 'BRR', 'BRE', 'BRN', 'BRC', 'BRB', 'BRS'],
    'Imperio del Brasil': ['BRS'],
    'Brasil Colonial Portugués': ['POR', 'BRS'],
    'Chile': ['CLP', 'CLE', 'CLF', 'REAL'],
    'Capitanía General de Chile': ['REAL', 'ESC', 'MRV'],
    'Argentina': ['ARS', 'ARA', 'ARL', 'ARM', 'ARP', 'REAL'],
    'Provincias Unidas del Río de la Plata': ['REAL', 'ARM'],
    'Confederación Argentina': ['REAL', 'ARM'],
    'Estado de Buenos Aires': ['ARM', 'REAL'],
    'Virreinato del Río de la Plata': ['REAL', 'ESC', 'MRV'],
    'Paraguay': ['PYG', 'PYP', 'REAL'],
    'Uruguay': ['UYU', 'UYP', 'REAL'],
    'Guyana': ['GYD', 'GBP_OLD'],
    'Surinam': ['SRD', 'SRG', 'NLG'],
    'Guayana Francesa': ['EUR', 'FRF'],
    'Islas Malvinas': ['FKP', 'GBP'],

    // Europa
    'España': ['EUR', 'ESP', 'REAL', 'ESC', 'MRV', 'RDV'],
    'Corona de Castilla': ['REAL', 'ESC', 'MRV', 'RDV'],
    'Corona de Aragón': ['REAL', 'ESC', 'MRV'],
    'Reino de Navarra': ['REAL', 'MRV'],
    'Unión Europea': ['EUR'],
    'Reino Unido': ['GBP', 'GBP_OLD'],
    'Reino de Inglaterra': ['GBP_OLD'],
    'Reino de Escocia': ['SCO', 'GBP_OLD'],
    'Reino de Irlanda': ['GBP_OLD', 'IEP'],
    'Irlanda': ['EUR', 'IEP'],
    'Francia': ['EUR', 'FRF', 'LVT', 'ECU', 'LDO'],
    'Reino de Francia': ['LVT', 'ECU', 'LDO'],
    'Primer Imperio Francés': ['FRF'],
    'Segundo Imperio Francés': ['FRF'],
    'Francia de Vichy': ['FRF'],
    'Países Bajos': ['EUR', 'NLG', 'NLG_HIST'],
    'Países Bajos Españoles': ['REAL', 'ESC', 'NLG_HIST'],
    'Países Bajos Austriacos': ['NLG_HIST', 'ATG'],
    'Bélgica': ['EUR', 'BEF'],
    'Luxemburgo': ['EUR', 'LUF'],
    'Sacro Imperio Romano Germánico': ['GTH', 'GGL', 'ATH', 'ATG'],
    'Confederación del Rin': ['GTH', 'GGL', 'FRF'],
    'Confederación Germánica': ['GTH', 'GGL'],
    'Confederación de Alemania del Norte': ['GTH'],
    'Imperio Alemán': ['FRG'],
    'República de Weimar': ['RKM', 'RTM', 'PRM'],
    'Tercer Reich Alemán': ['RKM'],
    'República Democrática Alemana (RDA)': ['DDM'],
    'República Federal de Alemania': ['DEM', 'EUR'],
    'Reino de Prusia': ['GTH', 'FRG'],
    'Reino de Baviera': ['GGL', 'GTH', 'FRG'],
    'Reino de Sajonia': ['GTH', 'FRG'],
    'Reino de Wurtemberg': ['GGL', 'FRG'],
    'Reino de Hannover': ['GTH', 'FRG'],
    'Gran Ducado de Baden': ['GGL', 'FRG'],
    'Estados Alemanes Históricos': ['GTH', 'GGL', 'FRG'],
    'Austria': ['EUR', 'ATS'],
    'Imperio Austriaco': ['ATG', 'MTT', 'GTH'],
    'Imperio Austrohúngaro': ['ATH', 'ATG', 'MTT'],
    'Hungría': ['HUF', 'HUP', 'HUK'],
    'Reino de Hungría': ['HUK', 'ATG', 'HUF'],
    'República Checa': ['CZK'],
    'Eslovaquia': ['EUR', 'SKK'],
    'Checoslovaquia': ['CSK'],
    'Reino de Bohemia': ['GTH', 'ATH', 'ATG'],
    'Protectorado de Bohemia y Moravia': ['BOM'],
    'Suiza': ['CHF', 'CHF_HIST'],
    'Cantones Suizos Históricos': ['CHF_HIST'],
    'Liechtenstein': ['CHF'],
    'Italia': ['EUR', 'ITL'],
    'Reino de Italia': ['ITL'],
    'Estados Pontificios': ['PST', 'VAL'],
    'Ciudad del Vaticano': ['EUR', 'VAL', 'PST'],
    'República de Venecia': ['VEC'],
    'República de Génova': ['GEN'],
    'Reino de las Dos Sicilias': ['NPL'],
    'Reino de Nápoles': ['NPL'],
    'Reino de Sicilia': ['NPL'],
    'Reino de Cerdeña': ['SAR_HIST', 'ITL'],
    'Gran Ducado de Toscana': ['TOS'],
    'Ducado de Milán': ['MIL'],
    'Ducado de Parma': ['ITL', 'FRF'],
    'Ducado de Módena': ['ITL'],
    'República de Lucca': ['ITL'],
    'San Marino': ['EUR', 'SML'],
    'Orden Soberana y Militar de Malta': ['MLT_ORD'],
    'Malta': ['EUR', 'MTL', 'MLT_ORD', 'GBP_OLD'],
    'Mónaco': ['EUR', 'FRF'],
    'Andorra': ['EUR', 'ESP', 'FRF'],
    'Portugal': ['EUR', 'PTE', 'POR'],
    'Reino de Portugal': ['POR'],
    'Dinamarca': ['DKK', 'DKK_HIST'],
    'Reino de Dinamarca-Noruega': ['DKK_HIST', 'NOK_HIST'],
    'Noruega': ['NOK', 'NOK_HIST'],
    'Suecia': ['SEK', 'SEK_HIST'],
    'Imperio Sueco': ['SEK_HIST'],
    'Finlandia': ['EUR', 'FIM', 'RUB'],
    'Gran Ducado de Finlandia': ['FIM', 'RUR'],
    'Islandia': ['ISK', 'DKK_HIST'],
    'Polonia': ['PLN', 'PLZ', 'PLX'],
    'Mancomunidad Polaco-Lituana': ['PLX'],
    'Zarato de Polonia': ['PLX', 'RUR'],
    'Gran Ducado de Varsovia': ['PLX', 'FRF'],
    'Lituania': ['EUR', 'PLX', 'RUR'],
    'Gran Ducado de Lituania': ['PLX'],
    'Letonia': ['EUR', 'RUR'],
    'Estonia': ['EUR', 'RUR', 'SEK_HIST'],
    'Bielorrusia': ['BYN', 'SUR', 'RUR'],
    'Ucrania': ['UAH', 'SUR', 'RUR'],
    'República Popular Ucraniana': ['UAH', 'RUR'],
    'Moldavia': ['MDL', 'SUR', 'ROL'],
    'Transnistria': ['PRB'],
    'Rumanía': ['RON', 'ROL'],
    'Principados Danubianos': ['ROL', 'OTE'],
    'Bulgaria': ['BGN', 'BGL', 'OTE'],
    'Grecia': ['EUR', 'GRD', 'PHX', 'OTE'],
    'Reino de Grecia': ['GRD', 'PHX'],
    'Chipre': ['EUR', 'CYP', 'OTE', 'GBP_OLD'],
    'Albania': ['ALL', 'OTE'],
    'Yugoslavia': ['YUD'],
    'Serbia y Montenegro': ['YUD', 'EUR', 'RSD'],
    'Serbia': ['RSD', 'YUD', 'OTE'],
    'Croacia': ['EUR', 'HRK', 'HRD', 'YUD'],
    'Estado Independiente de Croacia': ['HRK'],
    'Eslovenia': ['EUR', 'YUD', 'ATH'],
    'Bosnia y Herzegovina': ['BAM', 'YUD', 'ATH', 'OTE'],
    'Montenegro': ['EUR', 'YUD', 'OTE'],
    'Macedonia del Norte': ['MKD', 'YUD', 'OTE'],
    'Kosovo': ['EUR', 'RSD', 'YUD'],
    'Gibraltar': ['GIP', 'GBP'],
    'Jersey': ['GBP', 'GBP_OLD'],
    'Guernesey': ['GBP', 'GBP_OLD'],
    'Isla de Man': ['GBP', 'GBP_OLD'],
    'Islas Feroe': ['DKK'],
    'Svalbard': ['NOK', 'RUB'],
    'Rusia': ['RUB', 'RUR', 'SUR'],
    'Zarato de Rusia': ['RUR'],
    'Imperio Ruso': ['RUR'],
    'Unión Soviética (URSS)': ['SUR'],

    // Medio Oriente y Cáucaso
    'Imperio Otomano': ['OTE'],
    'Turquía': ['TRY', 'OTE'],
    'Imperio Persa (Safávida / Qajar / Pahlaví)': ['PER_HIST', 'IRR'],
    'Irán': ['IRR', 'PER_HIST'],
    'Irak': ['IQD', 'OTE'],
    'Reino de Irak': ['IQD'],
    'Siria': ['SYP', 'OTE', 'FRF'],
    'Líbano': ['LBP', 'USD', 'OTE', 'FRF'],
    'Jordania': ['JOD', 'PAL', 'OTE'],
    'Emirato de Transjordania': ['PAL', 'JOD'],
    'Israel': ['ILS', 'PAL'],
    'Palestina': ['ILS', 'JOD', 'USD', 'PAL'],
    'Mandato Británico de Palestina': ['PAL'],
    'Arabia Saudita': ['SAR', 'HEJ', 'OTE'],
    'Reino de Hiyaz': ['HEJ', 'OTE'],
    'Yemen': ['YER', 'OTE', 'MTT'],
    'Omán': ['OMR', 'INR', 'MTT'],
    'Emiratos Árabes Unidos': ['AED', 'INR'],
    'Estados de la Tregua': ['INR', 'AED'],
    'Catar': ['QAR', 'INR'],
    'Baréin': ['BHD', 'INR'],
    'Kuwait': ['KWD', 'INR'],
    'Armenia': ['AMD', 'SUR', 'RUR'],
    'Azerbaiyán': ['AZN', 'SUR', 'RUR'],
    'Georgia': ['GEL', 'SUR', 'RUR'],

    // Asia Central, Oriental y Meridional
    'China': ['CNY', 'CHN_QING', 'CHN_REP'],
    'Dinastía Ming': ['CHN_QING'],
    'Dinastía Qing': ['CHN_QING'],
    'República de China (1912-1949)': ['CHN_REP'],
    'Manchukuo': ['MCK'],
    'Tíbet': ['TIB'],
    'Taiwán': ['TWD', 'JPY', 'CHN_REP'],
    'Hong Kong': ['HKD', 'GBP_OLD'],
    'Macao': ['MOP', 'POR'],
    'Japón': ['JPY', 'JPN_EDO'],
    'Shogunato Tokugawa (Período Edo)': ['JPN_EDO'],
    'Imperio del Japón': ['JPY'],
    'Corea': ['KOR_JOSEON'],
    'Dinastía Joseon': ['KOR_JOSEON'],
    'Imperio Coreano': ['KOR_JOSEON', 'KRW'],
    'Corea del Sur': ['KRW'],
    'Corea del Norte': ['KPW'],
    'Mongolia': ['MNT', 'CHN_QING'],
    'India': ['INR', 'IND_BRIT', 'IND_EIC', 'IND_MUG'],
    'Imperio Mogol': ['IND_MUG'],
    'Compañía Británica de las Indias Orientales': ['IND_EIC'],
    'Raj Británico': ['IND_BRIT'],
    'Estados Principescos de la India': ['INR', 'IND_BRIT'],
    'India Portuguesa': ['IND_POR', 'POR'],
    'India Francesa': ['IND_FR', 'FRF'],
    'Pakistán': ['PKR', 'IND_BRIT'],
    'Bangladés': ['BDT', 'PKR', 'IND_BRIT'],
    'Sri Lanka (Ceilán)': ['LKR', 'CEY', 'GBP_OLD'],
    'Nepal': ['NPR'],
    'Bután': ['BTN', 'INR'],
    'Maldivas': ['MVR'],
    'Afganistán': ['AFN', 'AFG_HIST'],
    'Imperio Durrani': ['AFG_HIST'],
    'Kazajistán': ['KZT', 'SUR', 'RUR'],
    'Uzbekistán': ['UZS', 'SUR', 'RUR'],
    'Turkmenistán': ['TMT', 'SUR', 'RUR'],
    'Kirguistán': ['KGS', 'UZS', 'SUR', 'RUR'],
    'Tayikistán': ['TJS', 'SUR', 'RUR'],

    // Sudeste Asiático
    'Filipinas': ['PHP', 'PHP_HIST', 'REAL', 'USD'],
    'Capitanía General de Filipinas': ['REAL', 'ESC', 'PHP_HIST'],
    'Indonesia': ['IDR', 'NID'],
    'Indias Orientales Neerlandesas (VOC)': ['NID', 'NLG'],
    'Malasia': ['MYR', 'STR', 'MAL'],
    'Asentamientos de los Estrechos': ['STR', 'GBP_OLD'],
    'Malaya Británica': ['MAL', 'STR'],
    'Sarawak': ['MAL', 'STR'],
    'Borneo Septentrional Británico': ['MAL', 'STR'],
    'Singapur': ['SGD', 'STR', 'MAL'],
    'Brunéi': ['BND', 'SGD', 'MAL'],
    'Tailandia (Siam)': ['THB', 'THB_HIST'],
    'Birmania (Myanmar)': ['MMK', 'MMK_HIST', 'IND_BRIT'],
    'Vietnam': ['VND', 'FIC', 'ANN'],
    'Imperio de Annam': ['ANN', 'FIC'],
    'Indochina Francesa': ['FIC', 'FRF'],
    'Camboya': ['KHR', 'USD', 'FIC'],
    'Laos': ['LAK', 'FIC'],
    'Timor Oriental': ['USD', 'POR'],

    // Oceanía
    'Australia': ['AUD', 'AUP', 'GBP_OLD'],
    'Nueva Zelanda': ['NZD', 'NZP', 'GBP_OLD'],
    'Fiyi': ['FJD', 'GBP_OLD'],
    'Papúa Nueva Guinea': ['PGK', 'AUD'],
    'Islas Salomón': ['SBD', 'AUD'],
    'Vanuatu (Nuevas Hébridas)': ['VUV', 'FRF', 'GBP_OLD'],
    'Samoa': ['WST', 'NZD'],
    'Samoa Americana': ['USD'],
    'Tonga': ['TOP', 'GBP_OLD'],
    'Tuvalu': ['AUD'],
    'Kiribati': ['AUD'],
    'Nauru': ['AUD'],
    'Micronesia': ['USD'],
    'Islas Marshall': ['USD'],
    'Palaos': ['USD'],
    'Islas Cook': ['NZD'],
    'Niue': ['NZD'],
    'Polinesia Francesa': ['XPF'],
    'Nueva Caledonia': ['XPF'],

    // África
    'Egipto': ['EGP', 'EGY_HIST', 'OTE'],
    'Jedivato / Sultanato / Reino de Egipto': ['EGY_HIST', 'EGP', 'OTE'],
    'Marruecos': ['MAD', 'MAD_HIST', 'FRF', 'ESP'],
    'Sultanato de Marruecos': ['MAD_HIST', 'REAL'],
    'Protectorado Francés de Marruecos': ['MAD', 'FRF'],
    'Protectorado Español de Marruecos': ['ESP', 'MAD'],
    'Argelia': ['DZD', 'ALG_HIST', 'FRF', 'OTE'],
    'Argelia Francesa': ['ALG_HIST', 'FRF'],
    'Túnez': ['TND', 'TUN_HIST', 'FRF', 'OTE'],
    'Libia': ['LYD', 'LYB_HIST', 'ITL', 'OTE'],
    'Libia Italiana': ['ITL', 'LYB_HIST'],
    'Sudán': ['SDG', 'EGP', 'EGY_HIST'],
    'Sudán Anglo-Egipcio': ['EGP', 'SDG'],
    'Sudán del Sur': ['SSP', 'SDG'],
    'Etiopía (Abisinia)': ['ETB', 'ETB_HIST', 'MTT'],
    'Eritrea': ['ERN', 'ETB', 'ITL'],
    'Eritrea Italiana': ['ITL', 'MTT'],
    'Yibuti (Somalia Francesa)': ['DJF', 'FRF'],
    'Somalia': ['SOS', 'EAS', 'ITL', 'GBP_OLD'],
    'Somalia Británica': ['EAS', 'INR', 'GBP_OLD'],
    'Somalia Italiana': ['ITL', 'SOS'],
    'Somalilandia': ['SOS'],
    'Kenia': ['KES', 'EAS', 'GBP_OLD'],
    'Uganda': ['UGX', 'EAS', 'GBP_OLD'],
    'Tanzania': ['TZS', 'EAS', 'ZNZ'],
    'Sultanato de Zanzíbar': ['ZNZ', 'INR', 'MTT'],
    'África Oriental Alemana': ['RKM', 'EAS'],
    'Tanganica': ['EAS'],
    'Sudáfrica': ['ZAR', 'ZAR_HIST', 'GBP_OLD'],
    'República de Sudáfrica (Transvaal)': ['ZAR_HIST', 'GBP_OLD'],
    'Estado Libre de Orange': ['ZAR_HIST', 'GBP_OLD'],
    'Colonia del Cabo': ['GBP_OLD', 'ZAR_HIST'],
    'Colonia de Natal': ['GBP_OLD', 'ZAR_HIST'],
    'Unión Sudafricana': ['ZAR_HIST', 'GBP_OLD'],
    'Namibia (África del Sudoeste)': ['NAD', 'ZAR', 'RKM'],
    'Botsuana (Bechuanalandia)': ['BWP', 'ZAR'],
    'Zimbabue (Rodesia)': ['ZWL', 'RHO', 'USD', 'GBP_OLD'],
    'Zambia (Rodesia del Norte)': ['ZMW', 'RHO', 'GBP_OLD'],
    'Malaui (Nyasalandia)': ['MWK', 'RHO', 'GBP_OLD'],
    'Mozambique': ['MZN', 'MOZ_POR', 'POR'],
    'Angola': ['AOA', 'ANG_POR', 'POR'],
    'República Democrática del Congo': ['CDF', 'ZAI', 'BEF'],
    'Estado Libre del Congo': ['BEF', 'CDF'],
    'Congo Belga': ['BEF', 'CDF'],
    'Katanga': ['KAT', 'CDF'],
    'Zaire': ['ZAI'],
    'República del Congo': ['XAF', 'FRF'],
    'Gabón': ['XAF', 'FRF'],
    'Camerún': ['XAF', 'FRF'],
    'República Centroafricana': ['XAF', 'FRF'],
    'Chad': ['XAF', 'FRF'],
    'Guinea Ecuatorial (Guinea Española)': ['XAF', 'ESP'],
    'Nigeria': ['NGN', 'NGA_HIST', 'GBP_OLD'],
    'Biafra': ['BIA'],
    'Ghana (Costa de Oro)': ['GHS', 'GHA_HIST', 'GBP_OLD'],
    'Costa de Marfil': ['XOF', 'FRF'],
    'Liberia': ['LRD', 'USD'],
    'Sierra Leona': ['SLE', 'SLL', 'GBP_OLD'],
    'Guinea': ['GNF', 'FRF'],
    'Guinea-Bisáu': ['XOF', 'POR'],
    'Senegal': ['XOF', 'FRF'],
    'Gambia': ['GMD', 'GBP_OLD'],
    'Malí (Sudán Francés)': ['XOF', 'FRF'],
    'Níger': ['XOF', 'FRF'],
    'Burkina Faso (Alto Volta)': ['XOF', 'FRF'],
    'Benín (Dahomey)': ['XOF', 'FRF'],
    'Togo': ['XOF', 'FRF'],
    'Mauritania': ['MRU', 'XOF', 'FRF'],
    'Sáhara Occidental (Sáhara Español)': ['ESP', 'MAD'],
    'Cabo Verde': ['CVE', 'POR'],
    'Santo Tomé y Príncipe': ['STN', 'POR'],
    'Madagascar': ['MGA', 'FRF'],
    'Mauricio': ['MUR', 'GBP_OLD', 'FRF'],
    'Seychelles': ['SCR', 'GBP_OLD'],
    'Comoras': ['KMF', 'FRF'],
    'Ruanda': ['RWF', 'BEF'],
    'Burundi': ['BIF', 'BEF'],
    'Lesoto (Basutolandia)': ['LSL', 'ZAR'],
    'Esuatini (Suazilandia)': ['SZL', 'ZAR'],
  };

  static const countryOther = 'Otro';

  static const List<String> denominations = [
    '1/4', '1/2', '1', '2', '2 1/2', '4', '5', '8', '10', '20', '25', '50', '100', '200', '500', '1000', '2000', '5000', 'Otro',
  ];

  static const List<String> grades = [
    'Sin circular', 'Excelente', 'Muy buena', 'Buena', 'Regular', 'Otro',
  ];

  /// Comprehensive canonical list of metallic and non-metallic coin compositions from 1500s to date.
  static const List<String> coinMaterials = [
    // Metales preciosos y grupo del platino
    'Plata',
    'Oro',
    'Platino',
    'Paladio',
    'Rodio',
    'Rutenio',
    'Electro (Electrum)',
    // Metales base y aleaciones tradicionales
    'Cobre',
    'Cuproníquel',
    'Bronce',
    'Bronce de aluminio',
    'Bronce fosforoso',
    'Latón',
    'Níquel-Latón',
    'Latón dorado (Tombac)',
    'Níquel',
    'Alpaca (Plata alemana)',
    'Oro nórdico',
    'Billón (Vellón)',
    'Zinc',
    'Zamak',
    'Plomo',
    'Estaño',
    'Peltre',
    'Hierro',
    'Acero',
    'Acero inoxidable',
    'Acero bañado en cobre',
    'Acero bañado en níquel',
    'Acero bañado en latón',
    'Acero bañado en bronce',
    'Acero bañado en zinc',
    'Cobre bañado en plata',
    'Cobre bañado en níquel',
    'Aluminio',
    'Aluminio-Magnesio (Magnalio)',
    'Aluminio-Bronce',
    'Titanio',
    'Niobio',
    'Tántalo',
    // Composiciones bimetálicas y trimetálicas
    'Bimetálica',
    'Trimetálica',
    // Materiales de necesidad, emergencia, Notgeld y polímeros
    'Papel',
    'Cartón',
    'Porcelana',
    'Cerámica',
    'Fibra prensada',
    'Plástico',
    'Polímero',
    'Vidrio',
    'Cuero',
    'Madera',
    'Otro',
  ];

  static const List<String> specialEditionReasons = [
    'Conmemorativa', 'Prueba de acuñación', 'Error de impresión', 'Serie limitada',
    'Aniversario', 'Emisión de cambio de régimen', 'Otro',
  ];

  /// Maps plural currency nouns and nationalities to their singular standard representation.
  static const Map<String, String> currencySingularReplacements = {
    // Monedas
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
    'Reales': 'Real',
    'Escudos': 'Escudo',
    'Maravedís': 'Maravedí',
    'Maravedis': 'Maravedí',
    'Táleros': 'Tálero',
    'Taler': 'Tálero',
    'Francos': 'Franco',
    'Ducados': 'Ducado',
    'Luises': 'Luis',
    'Écus': 'Écu',
    'Zecchinos': 'Zecchino',
    'Piastras': 'Piastra',
    'Coronas': 'Corona',
    'Marcos': 'Marco',
    'Rublos': 'Rublo',
    'Dinares': 'Dinar',
    'Dracmas': 'Dracma',
    'Levs': 'Lev',
    'Leus': 'Leu',
    'Kunas': 'Kuna',
    'Leks': 'Lek',
    'Denares': 'Denar',
    'Grivnas': 'Grivna',
    'Mohurs': 'Mohur',
    'Rupias': 'Rupia',
    'Chelines': 'Chelín',
    'Peniques': 'Penique',
    'Guineas': 'Guinea',
    'Soberanos': 'Soberano',
    'Riyales': 'Riyal',
    'Riales': 'Rial',
    'Dírhams': 'Dírham',
    'Dirhams': 'Dírham',
    'Shekels': 'Shekel',
    'Kips': 'Kip',
    'Dongs': 'Dong',
    'Rieles': 'Riel',
    'Kyats': 'Kyat',
    'Takas': 'Taka',
    'Ngultrums': 'Ngultrum',
    'Afganis': 'Afgani',
    'Yuanes': 'Yuan',
    'Yenes': 'Yen',
    'Wones': 'Won',
    'Bahts': 'Baht',
    'Ringgits': 'Ringgit',
    'Patacas': 'Pataca',
    'Kinas': 'Kina',
    'Vatus': 'Vatu',
    'Talas': 'Tala',
    'Paangas': 'Paanga',
    'Nairas': 'Naira',
    'Cedis': 'Cedi',
    'Pulas': 'Pula',
    'Kwanzas': 'Kwanza',
    'Kwachas': 'Kwacha',
    'Meticales': 'Metical',
    'Dobras': 'Dobra',
    'Nakfas': 'Nakfa',
    'Dalasis': 'Dalasi',
    'Ariarys': 'Ariary',
    'Ouguiyas': 'Ouguiya',
    'Leones': 'León',
    'Gourdes': 'Gourde',
    'Balboas': 'Balboa',
    'Centavos': 'Centavo',
    'Australes': 'Austral',
    'Intis': 'Inti',
    'Venezolanos': 'Venezolano',
    'Bolívares': 'Bolívar',
    'Bolivares': 'Bolívar',
    'Guaraníes': 'Guaraní',
    'Guaranies': 'Guaraní',
    'Somonis': 'Somoni',
    'Manats': 'Manat',
    'Laris': 'Lari',
    'Tenges': 'Tenge',
    'Soms': 'Som',
    'Tugriks': 'Tugrik',
    'Pengos': 'Pengo',
    // Nacionalidades / Adjetivos
    'Mexicanos': 'Mexicano',
    'Estadounidenses': 'Estadounidense',
    'Canadienses': 'Canadiense',
    'Colombianos': 'Colombiano',
    'Chilenos': 'Chileno',
    'Argentinos': 'Argentino',
    'Cubanos': 'Cubano',
    'Dominicanos': 'Dominicano',
    'Españoles': 'Español',
    'Alemanes': 'Alemán',
    'Franceses': 'Francés',
    'Británicos': 'Británico',
    'Britanicos': 'Británico',
    'Italianos': 'Italiano',
    'Austriacos': 'Austriaco',
    'Austrohúngaros': 'Austrohúngaro',
    'Austrohungaros': 'Austrohúngaro',
    'Neerlandeses': 'Neerlandés',
    'Portugueses': 'Portugués',
    'Griegos': 'Griego',
    'Irlandeses': 'Irlandés',
    'Suecos': 'Sueco',
    'Noruegos': 'Noruego',
    'Daneses': 'Danés',
    'Rusos': 'Ruso',
    'Polacos': 'Polaco',
    'Checos': 'Checo',
    'Checoslovacos': 'Checoslovaco',
    'Eslovacos': 'Eslovaco',
    'Húngaros': 'Húngaro',
    'Hungaros': 'Húngaro',
    'Rumanos': 'Rumano',
    'Búlgaros': 'Búlgaro',
    'Bulgaros': 'Búlgaro',
    'Serbios': 'Serbio',
    'Yugoslavos': 'Yugoslavo',
    'Croatas': 'Croata',
    'Turcos': 'Turco',
    'Otomanos': 'Otomano',
    'Chinos': 'Chino',
    'Japoneses': 'Japonés',
    'Coreanos': 'Coreano',
    'Indios': 'Indio',
    'Egipcios': 'Egipcio',
    'Sudafricanos': 'Sudafricano',
    'Brasileños': 'Brasileño',
    'Brasilenos': 'Brasileño',
    'Peruanos': 'Peruano',
    'Bolivianos': 'Boliviano',
    'Guatemaltecos': 'Guatemalteco',
    'Salvadoreños': 'Salvadoreño',
    'Salvadorenos': 'Salvadoreño',
    'Hondureños': 'Hondureño',
    'Hondurenos': 'Hondureño',
    'Nicaragüenses': 'Nicaragüense',
    'Nicaraguenses': 'Nicaragüense',
    'Costarricenses': 'Costarricense',
    'Panameños': 'Panameño',
    'Panamenos': 'Panameño',
    'Uruguayos': 'Uruguayo',
    'Paraguayos': 'Paraguayo',
    'Haitianos': 'Haitiano',
    'Jamaicanos': 'Jamaicano',
    'Germánicos': 'Germánico',
    'Germanicos': 'Germánico',
    'Imperiales': 'Imperial',
    'Coloniales': 'Colonial',
    'Federales': 'Federal',
    'Cantonales': 'Cantonal',
    'Nacionales': 'Nacional',
    'Antiguos': 'Antiguo',
  };

  static const Map<String, String> normalizeCurrencyReplacements = {
    'pesos': 'peso',
    'dólares': 'dólar',
    'dolares': 'dólar',
    'soles': 'sol',
    'euros': 'euro',
    'libras': 'libra',
    'reales': 'real',
    'escudos': 'escudo',
    'maravedís': 'maravedí',
    'maravedis': 'maravedí',
    'francos': 'franco',
    'marcos': 'marco',
    'rublos': 'rublo',
    'dinares': 'dinar',
    'dracmas': 'dracma',
    'florines': 'florín',
    'táleros': 'tálero',
    'taleros': 'tálero',
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
    'cupronickel': 'Cuproníquel',
    'cobre-níquel': 'Cuproníquel',
    'cobre-niquel': 'Cuproníquel',
    'copper-nickel': 'Cuproníquel',
    'plata': 'Plata',
    'silver': 'Plata',
    'argentum': 'Plata',
    'ag': 'Plata',
    'oro': 'Oro',
    'gold': 'Oro',
    'aurum': 'Oro',
    'au': 'Oro',
    'platino': 'Platino',
    'platinum': 'Platino',
    'pt': 'Platino',
    'paladio': 'Paladio',
    'palladium': 'Paladio',
    'pd': 'Paladio',
    'rodio': 'Rodio',
    'rhodium': 'Rodio',
    'rutenio': 'Rutenio',
    'ruthenium': 'Rutenio',
    'electro': 'Electro (Electrum)',
    'electrum': 'Electro (Electrum)',
    'cobre': 'Cobre',
    'copper': 'Cobre',
    'cu': 'Cobre',
    'bronce': 'Bronce',
    'bronze': 'Bronce',
    'bronce de aluminio': 'Bronce de aluminio',
    'aluminium bronze': 'Bronce de aluminio',
    'aluminum bronze': 'Bronce de aluminio',
    'aluminio-bronce': 'Aluminio-Bronce',
    'bronce fosforoso': 'Bronce fosforoso',
    'phosphor bronze': 'Bronce fosforoso',
    'latón': 'Latón',
    'laton': 'Latón',
    'brass': 'Latón',
    'níquel-latón': 'Níquel-Latón',
    'niquel-laton': 'Níquel-Latón',
    'nickel-brass': 'Níquel-Latón',
    'tombac': 'Latón dorado (Tombac)',
    'tombak': 'Latón dorado (Tombac)',
    'latón dorado': 'Latón dorado (Tombac)',
    'níquel': 'Níquel',
    'niquel': 'Níquel',
    'nickel': 'Níquel',
    'ni': 'Níquel',
    'alpaca': 'Alpaca (Plata alemana)',
    'plata alemana': 'Alpaca (Plata alemana)',
    'german silver': 'Alpaca (Plata alemana)',
    'nickel silver': 'Alpaca (Plata alemana)',
    'maillechort': 'Alpaca (Plata alemana)',
    'melchior': 'Alpaca (Plata alemana)',
    'oro nórdico': 'Oro nórdico',
    'oro nordico': 'Oro nórdico',
    'nordic gold': 'Oro nórdico',
    'billón': 'Billón (Vellón)',
    'billon': 'Billón (Vellón)',
    'vellón': 'Billón (Vellón)',
    'vellon': 'Billón (Vellón)',
    'zinc': 'Zinc',
    'cinc': 'Zinc',
    'zn': 'Zinc',
    'zamak': 'Zamak',
    'zamac': 'Zamak',
    'plomo': 'Plomo',
    'lead': 'Plomo',
    'pb': 'Plomo',
    'estaño': 'Estaño',
    'estano': 'Estaño',
    'tin': 'Estaño',
    'sn': 'Estaño',
    'peltre': 'Peltre',
    'pewter': 'Peltre',
    'hierro': 'Hierro',
    'iron': 'Hierro',
    'fe': 'Hierro',
    'acero': 'Acero',
    'steel': 'Acero',
    'acero inoxidable': 'Acero inoxidable',
    'stainless steel': 'Acero inoxidable',
    'acero bañado en cobre': 'Acero bañado en cobre',
    'copper-plated steel': 'Acero bañado en cobre',
    'acero bañado en níquel': 'Acero bañado en níquel',
    'nickel-plated steel': 'Acero bañado en níquel',
    'acero bañado en latón': 'Acero bañado en latón',
    'brass-plated steel': 'Acero bañado en latón',
    'acero bañado en bronce': 'Acero bañado en bronce',
    'bronze-plated steel': 'Acero bañado en bronce',
    'acero bañado en zinc': 'Acero bañado en zinc',
    'zinc-plated steel': 'Acero bañado en zinc',
    'acero galvanizado': 'Acero bañado en zinc',
    'aluminio': 'Aluminio',
    'aluminum': 'Aluminio',
    'aluminium': 'Aluminio',
    'al': 'Aluminio',
    'aluminio-magnesio': 'Aluminio-Magnesio (Magnalio)',
    'magnalio': 'Aluminio-Magnesio (Magnalio)',
    'magnalium': 'Aluminio-Magnesio (Magnalio)',
    'titanio': 'Titanio',
    'titanium': 'Titanio',
    'ti': 'Titanio',
    'niobio': 'Niobio',
    'niobium': 'Niobio',
    'nb': 'Niobio',
    'tántalo': 'Tántalo',
    'tantalo': 'Tántalo',
    'tantalum': 'Tántalo',
    'ta': 'Tántalo',
    'bimetálica': 'Bimetálica',
    'bimetalica': 'Bimetálica',
    'bimetal': 'Bimetálica',
    'bimetallic': 'Bimetálica',
    'trimetálica': 'Trimetálica',
    'trimetalica': 'Trimetálica',
    'trimetallic': 'Trimetálica',
    'papel': 'Papel',
    'paper': 'Papel',
    'cartón': 'Cartón',
    'carton': 'Cartón',
    'porcelana': 'Porcelana',
    'porcelain': 'Porcelana',
    'cerámica': 'Cerámica',
    'ceramica': 'Cerámica',
    'ceramic': 'Cerámica',
    'fibra prensada': 'Fibra prensada',
    'fibra': 'Fibra prensada',
    'fiber': 'Fibra prensada',
    'plástico': 'Plástico',
    'plastico': 'Plástico',
    'plastic': 'Plástico',
    'polímero': 'Polímero',
    'polimero': 'Polímero',
    'polymer': 'Polímero',
    'vidrio': 'Vidrio',
    'glass': 'Vidrio',
    'cuero': 'Cuero',
    'leather': 'Cuero',
    'madera': 'Madera',
    'wood': 'Madera',
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

  static const List<NumismaticEmissionRuleData> emissionRules = [
    // =========================================================================
    // 1. MÉXICO Y EMISORES HISTÓRICOS MEXICANOS
    // =========================================================================

    // 1.1 Virreinato de Nueva España (1536–1821)
    // Ref: Banco de México - Historia de la moneda colonial novohispana:
    // https://www.banxico.org.mx/billetes-y-monedas/virreinato-historia-moneda-b.html
    // Ref: Numista - Colonial Mexico (1535-1821):
    // https://en.numista.com/catalogue/mexico-colonial-1.html
    NumismaticEmissionRuleData(
      country: 'Virreinato de Nueva España',
      minYear: 1536,
      maxYear: 1821,
      validCurrencies: ['MXR', 'REAL', 'MXE', 'ESC', 'MRV'],
      defaultCurrency: 'MXR',
      denominations: ['1/16', '1/8', '1/4', '1/2', '1', '2', '4', '8'],
      denominationMaterials: {
        '1/16': 'Cobre',  // Tlaco colonial novohispano (1/16 de real)
        '1/8': 'Cobre',   // Octavo de real novohispano en cobre
        '1/4': 'Plata',   // Cuartilla de real (Carlos y Juana / Fernando VII)
        '1/2': 'Plata',   // Medio real de plata (Macuquina, Columnario, De Busto)
        '1': 'Plata',     // 1 real de plata
        '2': 'Plata',     // 2 reales de plata / Peseta novohispana
        '4': 'Plata',     // 4 reales de plata / Tostón
        '8': 'Plata',     // 8 reales de plata / Real de a 8 / Peso Fuerte
      },
    ),

    // 1.2 Primer Imperio Mexicano - Agustín de Iturbide (1822–1823)
    // Ref: Numista - First Mexican Empire (1821-1823):
    // https://en.numista.com/catalogue/mexico-first-empire-1.html
    // Ref: Banco de México - Monedas del Primer Imperio:
    // https://www.banxico.org.mx/billetes-y-monedas/primer-imperio-mexicano.html
    NumismaticEmissionRuleData(
      country: 'Imperio Mexicano (Primer y Segundo Imperio)',
      minYear: 1822,
      maxYear: 1823,
      validCurrencies: ['MXR', 'MXE'],
      defaultCurrency: 'MXR',
      denominations: ['1/8', '1/4', '1/2', '1', '2', '4', '8'],
      denominationMaterials: {
        '1/8': 'Cobre',   // Octavo de real de Iturbide
        '1/4': 'Cobre',   // Cuartilla provisional de cobre
        '1/2': 'Plata',   // Medio real de plata de Iturbide
        '1': 'Plata',     // 1 real de plata de Iturbide
        '2': 'Plata',     // 2 reales de plata de Iturbide
        '4': 'Oro',       // 4 escudos de oro de Iturbide
        '8': 'Plata',     // 8 reales de plata de Iturbide (y 8 escudos de oro)
      },
    ),

    // 1.3 Segundo Imperio Mexicano - Maximiliano de Habsburgo (1864–1867)
    // Ref: Numista - Second Mexican Empire (1864-1867):
    // https://en.numista.com/catalogue/mexico-second-empire-1.html
    // Ref: Banco de México - Monedas del Segundo Imperio:
    // https://www.banxico.org.mx/billetes-y-monedas/segundo-imperio-mexicano.html
    NumismaticEmissionRuleData(
      country: 'Imperio Mexicano (Primer y Segundo Imperio)',
      minYear: 1864,
      maxYear: 1867,
      validCurrencies: ['MXP', 'MXR'],
      defaultCurrency: 'MXP',
      denominations: ['0.01', '0.05', '0.10', '0.50', '1', '20', '1', '5', '10', '50'],
      denominationMaterials: {
        '0.01': 'Cobre',  // 1 centavo de cobre (1864-1867)
        '0.05': 'Plata',  // 5 centavos de plata (1866-1867)
        '0.10': 'Plata',  // 10 centavos de plata (1866-1867)
        '0.50': 'Plata',  // 50 centavos de plata (1866-1867)
        '1': 'Plata',     // 1 peso de plata de Maximiliano (1866-1867)
        '5': 'Plata',     // 5 centavos
        '10': 'Plata',    // 10 centavos
        '50': 'Plata',    // 50 centavos
        '20': 'Oro',      // 20 pesos de oro de Maximiliano (1866)
      },
    ),

    // 1.4 México - Período Virreinal novohispano (1536–1821)
    // Ref: Numista - Mexico Colonial: https://en.numista.com/catalogue/mexico-colonial-1.html
    NumismaticEmissionRuleData(
      country: 'México',
      minYear: 1536,
      maxYear: 1821,
      validCurrencies: ['MXR', 'MXE', 'REAL', 'ESC'],
      defaultCurrency: 'MXR',
      denominations: ['1/16', '1/8', '1/4', '1/2', '1', '2', '4', '8'],
      denominationMaterials: {
        '1/16': 'Cobre',
        '1/8': 'Cobre',
        '1/4': 'Plata',
        '1/2': 'Plata',
        '1': 'Plata',
        '2': 'Plata',
        '4': 'Plata',
        '8': 'Plata',
      },
    ),

    // 1.5 México - Primer Imperio (1822–1823)
    // Ref: Numista - First Mexican Empire: https://en.numista.com/catalogue/mexico-first-empire-1.html
    NumismaticEmissionRuleData(
      country: 'México',
      minYear: 1822,
      maxYear: 1823,
      validCurrencies: ['MXR', 'MXE'],
      defaultCurrency: 'MXR',
      denominations: ['1/8', '1/4', '1/2', '1', '2', '4', '8'],
      denominationMaterials: {
        '1/8': 'Cobre',
        '1/4': 'Cobre',
        '1/2': 'Plata',
        '1': 'Plata',
        '2': 'Plata',
        '4': 'Oro',
        '8': 'Plata',
      },
    ),

    // 1.6 México - Primera República y República Centralista (1823–1863)
    // Ref: Numista - Mexican Republic - First Republic (1823-1863):
    // https://en.numista.com/catalogue/mexico-first-republic-1.html
    // Ref: Banco de México - Sistema de reales republicanos (Águila de Perfil y Resplandor):
    // https://www.banxico.org.mx/billetes-y-monedas/primeras-emisiones-republican.html
    NumismaticEmissionRuleData(
      country: 'México',
      minYear: 1823,
      maxYear: 1863,
      validCurrencies: ['MXR', 'MXE'],
      defaultCurrency: 'MXR',
      denominations: ['1/16', '1/8', '1/4', '1/2', '1', '2', '4', '8'],
      denominationMaterials: {
        '1/16': 'Cobre',  // Tlaco republicano (1/16 real)
        '1/8': 'Cobre',   // Octavo republicano (1/8 real)
        '1/4': 'Cobre',   // Cuartilla republicana de cobre (y plata)
        '1/2': 'Plata',   // Medio real de plata republicano
        '1': 'Plata',     // 1 real de plata republicano
        '2': 'Plata',     // 2 reales de plata republicano
        '4': 'Plata',     // 4 reales de plata republicano
        '8': 'Plata',     // 8 reales de plata Resplandor (Cap and Rays)
      },
    ),

    // 1.7 México - Segundo Imperio (1864–1867)
    // Ref: Numista - Second Mexican Empire: https://en.numista.com/catalogue/mexico-second-empire-1.html
    NumismaticEmissionRuleData(
      country: 'México',
      minYear: 1864,
      maxYear: 1867,
      validCurrencies: ['MXP', 'MXR'],
      defaultCurrency: 'MXP',
      denominations: ['0.01', '0.05', '0.10', '0.50', '1', '20', '1', '5', '10', '50'],
      denominationMaterials: {
        '0.01': 'Cobre',
        '0.05': 'Plata',
        '0.10': 'Plata',
        '0.50': 'Plata',
        '1': 'Plata',
        '5': 'Plata',
        '10': 'Plata',
        '50': 'Plata',
        '20': 'Oro',
      },
    ),

    // 1.8 México - República Restaurada y Porfiriato (Balanza y Resplandor Decimal 1868–1904)
    // Ref: Numista - Republic of Mexico - Decimal Pesos (1868-1905):
    // https://en.numista.com/catalogue/mexico-republic-decimal-1.html
    // Ref: Banco de México - Historia del Peso Decimal:
    // https://www.banxico.org.mx/billetes-y-monedas/republica-restaurada-porfiri.html
    NumismaticEmissionRuleData(
      country: 'México',
      minYear: 1868,
      maxYear: 1904,
      validCurrencies: ['MXP', 'MXE', 'MXR'],
      defaultCurrency: 'MXP',
      denominations: [
        '0.01', '0.02', '0.05', '0.10', '0.20', '0.25', '0.50', '1', '2.5', '5', '10', '20',
        '1', '2', '5', '10', '20', '25', '50', '100', '8',
      ],
      denominationMaterials: {
        '0.01': 'Cobre',  // 1 centavo de cobre/bronce
        '0.02': 'Cobre',  // 2 centavos de cobre
        '0.05': 'Plata',  // 5 centavos de plata (y níquel 1882-1883)
        '0.10': 'Plata',  // 10 centavos de plata
        '0.20': 'Plata',  // 20 centavos de plata
        '0.25': 'Plata',  // 25 centavos de plata Balanza
        '0.50': 'Plata',  // 50 centavos de plata Balanza / Resplandor
        '1': 'Plata',     // 1 peso Balanza (1869-1873) y Fuerte Resplandor (1873-1904)
        '2': 'Cobre',     // 2 centavos
        '2.5': 'Oro',     // 2 1/2 pesos de oro
        '5': 'Oro',       // 5 pesos de oro (Hidalgo / Escudo)
        '10': 'Oro',      // 10 pesos de oro
        '20': 'Oro',      // 20 pesos de oro
        '25': 'Plata',    // 25 centavos
        '50': 'Plata',    // 50 centavos
        '100': 'Plata',   // 100 centavos / 1 Peso
        '8': 'Plata',     // 8 Reales Resplandor (coexistente hasta 1897)
      },
    ),

    // 1.9 México - Siglo XX (Reforma Monetaria de 1905 hasta 1969)
    // Ref: Numista - United Mexican States (1905-1969):
    // https://en.numista.com/catalogue/mexico-united-states-1905-1.html
    // Ref: Banco de México - Monedas de plata y oro del siglo XX:
    // https://www.banxico.org.mx/billetes-y-monedas/monedas-plata-oro-siglo-xx.html
    NumismaticEmissionRuleData(
      country: 'México',
      minYear: 1905,
      maxYear: 1969,
      validCurrencies: ['MXP'],
      defaultCurrency: 'MXP',
      denominations: [
        '0.01', '0.02', '0.05', '0.10', '0.20', '0.25', '0.50', '1', '2', '2.5', '5', '10', '20', '25', '50', '100',
        '1', '2', '5', '10', '20', '25', '50', '100',
      ],
      denominationMaterials: {
        '0.01': 'Bronce',       // 1 centavo de bronce
        '0.02': 'Bronce',       // 2 centavos de bronce (1905-1941)
        '0.05': 'Bronce',       // 5 centavos bronce Josefita (1942-1955) y latón (1954-1969)
        '0.10': 'Latón',        // 10 centavos latón / bronce / cuproníquel
        '0.20': 'Bronce',       // 20 centavos Pirámide de Teotihuacán de bronce (1943-1971)
        '0.25': 'Cuproníquel',  // 25 centavos Balanza de cuproníquel (1950-1953)
        '0.50': 'Cuproníquel',  // 50 centavos Cuauhtémoc cuproníquel (1964-1969) / plata
        '1': 'Plata',           // 1 peso plata Resplandor / Morelos Tepalcate (.100)
        '2': 'Oro',             // 2 pesos de oro (1919-1948)
        '2.5': 'Oro',           // 2.5 pesos de oro Hidalgo (1918-1948)
        '5': 'Plata',           // 5 pesos plata (Cuauhtémoc, Hidalgo, Ferrocarril, Constitución, Carranza)
        '10': 'Plata',          // 10 pesos plata (Hidalgo, Constitución, Madero)
        '20': 'Oro',            // 20 pesos de oro Azteca (1917-1959)
        '25': 'Plata',          // 25 pesos de plata conmemorativa Juegos Olímpicos México 68
        '50': 'Oro',            // 50 pesos de oro Centenario (1921-1947)
        '100': 'Plata',
      },
      commemorativeDenominations: {'5', '10', '25'},
      defaultCommemorativeReason: 'Conmemorativa',
    ),

    // 1.10 México - Siglo XX (Devaluación e Inflación 1970–1992)
    // Ref: Banco de México - Monedas metálicas desmonetizadas de la unidad anterior (Pesos):
    // https://www.banxico.org.mx/billetes-y-monedas/monedas-desmonetizadas-unida.html
    // Ref: Numista - Mexico (1970-1992):
    // https://en.numista.com/catalogue/mexico-united-states-1905-2.html
    NumismaticEmissionRuleData(
      country: 'México',
      minYear: 1970,
      maxYear: 1992,
      validCurrencies: ['MXP'],
      defaultCurrency: 'MXP',
      denominations: ['0.05', '0.10', '0.20', '0.50', '1', '5', '10', '20', '50', '100', '200', '500', '1000', '5000'],
      denominationMaterials: {
        '0.05': 'Latón',               // 5 centavos Josefita latón
        '0.10': 'Cuproníquel',         // 10 centavos Mazorca cuproníquel
        '0.20': 'Bronce',              // 20 centavos Madero bronce/cuproníquel
        '0.50': 'Cuproníquel',         // 50 centavos Cuauhtémoc cuproníquel
        '1': 'Cuproníquel',            // 1 peso Morelos cuproníquel (1970-1983) / acero (1984-1987)
        '5': 'Cuproníquel',            // 5 pesos Vicente Guerrero (1971-1978) / Quetzalcóatl (1980-1985)
        '10': 'Cuproníquel',           // 10 pesos Hidalgo heptagonal (1974-1985)
        '20': 'Cuproníquel',           // 20 pesos Cultura Maya (1980-1984) / Latón Victoria (1985-1990)
        '50': 'Cuproníquel',           // 50 pesos Coyolxauhqui (1982-1984) / Acero Juárez (1984-1992)
        '100': 'Bronce de aluminio',   // 100 pesos Venustiano Carranza (1984-1992)
        '200': 'Cuproníquel',          // 200 pesos conmemorativa 175 Aniv Independencia/75 Aniv Revolución (1985), Mundial 86
        '500': 'Cuproníquel',          // 500 pesos Francisco I. Madero (1986-1992)
        '1000': 'Bronce de aluminio',  // 1000 pesos Sor Juana Inés de la Cruz (1988-1992)
        '5000': 'Cuproníquel',         // 5000 pesos Cincuentenario Expropiación Petrolera (1988)
      },
      commemorativeDenominations: {'200', '5000'},
      defaultCommemorativeReason: 'Conmemorativa',
    ),

    // 1.11 México - Nuevos Pesos (N$ grabados físicamente 1992–1995)
    // Ref: Banco de México - Familia B (Nuevos Pesos en proceso de retiro):
    // https://www.banxico.org.mx/billetes-y-monedas/familia-b-proceso-retiro-ban.html
    // Ref: Numista - Mexico Nuevos Pesos (1992-1995):
    // https://en.numista.com/catalogue/mexico-united-states-1905-3.html
    NumismaticEmissionRuleData(
      country: 'México',
      minYear: 1992,
      maxYear: 1995,
      validCurrencies: ['MXN'],
      defaultCurrency: 'MXN',
      denominations: ['0.05', '0.10', '0.20', '0.50', '1', '2', '5', '10', '20', '50'],
      denominationMaterials: {
        '0.05': 'Acero inoxidable',
        '0.10': 'Acero inoxidable',
        '0.20': 'Bronce de aluminio',
        '0.50': 'Bronce de aluminio',
        '1': 'Bimetálica',  // Centro bronce-aluminio, anillo acero inoxidable
        '2': 'Bimetálica',  // Centro bronce-aluminio, anillo acero inoxidable
        '5': 'Bimetálica',  // Centro bronce-aluminio, anillo acero inoxidable
        '10': 'Bimetálica', // Centro plata .925, anillo bronce de aluminio (Piedra del Sol)
        '20': 'Bimetálica', // Centro plata .925, anillo bronce de aluminio (Miguel Hidalgo)
        '50': 'Bimetálica', // Centro plata .925, anillo bronce de aluminio (Niños Héroes)
      },
      commemorativeDenominations: {'0.05', '0.10', '0.20', '0.50', '1', '2', '5', '10', '20', '50'},
      defaultCommemorativeReason: 'Emisión de cambio de régimen',
    ),

    // 1.12 México - Pesos Modernos (Familia C, C1 y D grabados físicamente 1996–presente)
    // Ref: Banco de México - Familia C y C1 en circulación:
    // https://www.banxico.org.mx/billetes-y-monedas/familia-c-circulacion-banco-m.html
    // Ref: Banco de México - Monedas conmemorativas de 20 pesos Familia C y C1:
    // https://www.banxico.org.mx/billetes-y-monedas/monedas-20-pesos-conmemorati.html
    // Ref: Numista - Mexico Modern Pesos (1996-date):
    // https://en.numista.com/catalogue/mexico-united-states-1905-4.html
    NumismaticEmissionRuleData(
      country: 'México',
      minYear: 1996,
      maxYear: 2100,
      validCurrencies: ['MXN'],
      defaultCurrency: 'MXN',
      denominations: ['0.05', '0.10', '0.20', '0.50', '1', '2', '5', '10', '20', '50', '100'],
      denominationMaterials: {
        '0.05': 'Acero inoxidable',
        '0.10': 'Acero inoxidable',
        '0.20': 'Acero inoxidable', // Bronce de aluminio (1996-2009) / Acero inoxidable (2009+)
        '0.50': 'Acero inoxidable', // Bronce de aluminio (1996-2009) / Acero inoxidable (2009+)
        '1': 'Bimetálica',          // Centro bronce-aluminio, anillo acero inoxidable
        '2': 'Bimetálica',          // Centro bronce-aluminio, anillo acero inoxidable
        '5': 'Bimetálica',          // Centro bronce-aluminio, anillo acero inoxidable (y conmemorativas 2008-2010)
        '10': 'Bimetálica',         // Centro alpaca plateada, anillo bronce-aluminio
        '20': 'Bimetálica',         // Centro alpaca plateada, anillo bronce-aluminio (Familia C y C1 dodecagonal)
        '50': 'Bimetálica',
        '100': 'Bimetálica',        // Centro plata .925, anillo bronce de aluminio (Estados de la República 2003-2007)
      },
      commemorativeDenominations: {'5', '20', '100'},
      defaultCommemorativeReason: 'Conmemorativa',
    ),

    // =========================================================================
    // 2. ESTADOS UNIDOS DE AMÉRICA
    // =========================================================================

    // 2.1 Estados Unidos - Período Continental y Pre-Federal (1775–1791)
    // Ref: Numista - United States - Pre-Federal (1776-1791):
    // https://en.numista.com/catalogue/united-states-pre-federal-1.html
    // Ref: US Mint - History of the US Mint:
    // https://www.usmint.gov/learn/history/overview-history-of-the-us-mint
    NumismaticEmissionRuleData(
      country: 'Estados Unidos',
      minYear: 1775,
      maxYear: 1791,
      validCurrencies: ['USC', 'USD'],
      defaultCurrency: 'USC',
      denominations: ['1/6', '1/3', '1/2', '1', '2', '3', '4', '5', '8', '20'],
      denominationMaterials: {
        '1': 'Plata', // Continental Dollar (1776 plata/peltre/latón)
        '8': 'Plata', // Spanish Milled Dollar (8 Reales de curso legal en EE.UU.)
      },
    ),

    // 2.2 Estados Unidos - Era Clásica de Metales Preciosos (Coinage Act 1792–1964)
    // Ref: US Mint - Coin Specifications & Classic Commemorative Program (1892-1954):
    // https://www.usmint.gov/learn/coin-and-medal-programs/commemorative-coins
    // Ref: Numista - United States - Federal Republic (1792-1964):
    // https://en.numista.com/catalogue/united-states-1.html
    NumismaticEmissionRuleData(
      country: 'Estados Unidos',
      minYear: 1792,
      maxYear: 1964,
      validCurrencies: ['USD'],
      defaultCurrency: 'USD',
      denominations: [
        '0.005', '0.01', '0.02', '0.03', '0.05', '0.10', '0.20', '0.25', '0.50', '1', '2.5', '3', '4', '5', '10', '20', '50',
      ],
      denominationMaterials: {
        '0.005': 'Cobre',       // Half Cent (1793-1857)
        '0.01': 'Cobre',        // Large Cent (1793-1857) / Indian Head / Lincoln Cent de bronce
        '0.02': 'Bronce',       // Two-Cent piece (1864-1873)
        '0.03': 'Plata',        // Three-Cent silver (1851-1873) / Cuproníquel (1865-1889)
        '0.05': 'Cuproníquel',  // Half Dime plata (1794-1873) / 5 Cents Nickel (1866+)
        '0.10': 'Plata',        // Dime plata .900 (Draped Bust, Seated Liberty, Barber, Mercury, Roosevelt)
        '0.20': 'Plata',        // Twenty-Cent piece plata (1875-1878)
        '0.25': 'Plata',        // Quarter Dollar plata .900 (Standing Liberty, Washington)
        '0.50': 'Plata',        // Half Dollar plata .900 (Walking Liberty, Franklin, Kennedy 1964)
        '1': 'Plata',           // Silver Dollar .900 (Morgan, Peace) / Gold Dollar (1849-1889)
        '2.5': 'Oro',           // Quarter Eagle $2.50 oro
        '3': 'Oro',             // Three-Dollar piece $3 oro (1854-1889)
        '4': 'Oro',             // Stella $4 oro (1879-1880)
        '5': 'Oro',             // Half Eagle $5 oro
        '10': 'Oro',            // Eagle $10 oro
        '20': 'Oro',            // Double Eagle $20 oro (Liberty Head, Saint-Gaudens)
        '50': 'Oro',            // Panama-Pacific $50 conmemorativa de oro (1915)
      },
      commemorativeDenominations: {'0.50', '1', '2.5', '50'},
      defaultCommemorativeReason: 'Conmemorativa',
    ),

    // 2.3 Estados Unidos - Era Clad y Contemporánea (1965–presente)
    // Ref: US Mint - Modern Coin Specifications:
    // https://www.usmint.gov/learn/coin-and-medal-programs/coin-specifications
    // Ref: Numista - United States - Modern (1965-date):
    // https://en.numista.com/catalogue/united-states-2.html
    NumismaticEmissionRuleData(
      country: 'Estados Unidos',
      minYear: 1965,
      maxYear: 2100,
      validCurrencies: ['USD'],
      defaultCurrency: 'USD',
      denominations: ['0.01', '0.05', '0.10', '0.25', '0.50', '1'],
      denominationMaterials: {
        '0.01': 'Zinc',         // Zinc bañado en cobre (desde 1982) / Bronce (1965-1982)
        '0.05': 'Cuproníquel',  // Jefferson Nickel (75% Cobre, 25% Níquel)
        '0.10': 'Cuproníquel',  // Roosevelt Dime clad (cuproníquel sobre núcleo de cobre)
        '0.25': 'Cuproníquel',  // Washington Quarter clad (50 State Quarters, National Parks, American Women)
        '0.50': 'Cuproníquel',  // Kennedy Half Dollar clad (40% plata 1965-1970; cuproníquel 1971+)
        '1': 'Latón',           // Latón de manganeso (Sacagawea, Presidenciales, Innovación Americana)
      },
      commemorativeDenominations: {'0.25', '0.50', '1'},
      defaultCommemorativeReason: 'Conmemorativa',
    ),

    // =========================================================================
    // 3. ESPAÑA Y UNIÓN EUROPEA
    // =========================================================================

    // 3.1 España - Antiguo Régimen y Monarquía Hispánica (1500–1868)
    // Ref: Real Casa de la Moneda - FNMT Historia: https://www.fnmt.es/museo/historia
    // Ref: Numista - Spain - Real (1497-1833): https://en.numista.com/catalogue/spain-1.html
    // Ref: Numista - Spain - Escudo & Decimal (1833-1868): https://en.numista.com/catalogue/spain-2.html
    NumismaticEmissionRuleData(
      country: 'España',
      minYear: 1500,
      maxYear: 1868,
      validCurrencies: ['REAL', 'ESC', 'MRV', 'RDV'],
      defaultCurrency: 'REAL',
      denominations: ['1/16', '1/8', '1/4', '1/2', '1', '2', '4', '8'],
      denominationMaterials: {
        '1/16': 'Cobre',  // Maravedís (1, 2 maravedís)
        '1/8': 'Cobre',   // Ochavo / 4 maravedís
        '1/4': 'Plata',   // Cuartillo de real
        '1/2': 'Plata',   // Medio real de plata
        '1': 'Plata',     // 1 real de plata / Escudo de oro
        '2': 'Plata',     // 2 reales / Doblón de oro de 2 escudos
        '4': 'Plata',     // 4 reales / Medio peso / 4 escudos
        '8': 'Plata',     // 8 reales / Real de a 8 / Onza de oro de 8 escudos
      },
    ),

    // 3.2 España - Época de la Peseta (1869–2001)
    // Ref: Banco de España - Billetes y monedas en pesetas:
    // https://www.bde.es/wbe/es/para-ciudadanos/billetes-y-monedas/pesetas/
    // Ref: Numista - Spain - Peseta (1868-2001):
    // https://en.numista.com/catalogue/spain-peseta-1.html
    NumismaticEmissionRuleData(
      country: 'España',
      minYear: 1869,
      maxYear: 2001,
      validCurrencies: ['ESP'],
      defaultCurrency: 'ESP',
      denominations: [
        '0.01', '0.02', '0.05', '0.10', '0.25', '0.50', '1', '2', '2.5', '5', '10', '25', '50', '100', '200', '500', '2000',
      ],
      denominationMaterials: {
        '0.01': 'Bronce',
        '0.02': 'Bronce',
        '0.05': 'Aluminio',           // 5 céntimos aluminio franquista / bronce
        '0.10': 'Aluminio',           // 10 céntimos aluminio
        '0.25': 'Cuproníquel',        // 25 céntimos con taladro (1925/1927/1934)
        '0.50': 'Cuproníquel',        // 50 céntimos cuproníquel con taladro / plata
        '1': 'Bronce de aluminio',    // 1 peseta "La Rubia" (1944-1975) / Aluminio (1982-2001)
        '2': 'Aluminio',              // 2 pesetas aluminio (1982-1984)
        '2.5': 'Bronce de aluminio',  // 2.50 pesetas (1953)
        '5': 'Cuproníquel',           // Duro de cuproníquel (1957-1988) / Bronce de aluminio (1989-2001)
        '10': 'Cuproníquel',          // 10 pesetas cuproníquel
        '25': 'Cuproníquel',          // 25 pesetas con taladro y motivos autonómicos
        '50': 'Cuproníquel',          // 50 pesetas Flor de España
        '100': 'Bronce de aluminio',  // 100 pesetas Juan Carlos I / Plata 1966
        '200': 'Cuproníquel',         // 200 pesetas cuproníquel
        '500': 'Bronce de aluminio',  // 500 pesetas bronce de aluminio
        '2000': 'Plata',              // 2000 pesetas conmemorativas de plata (1994-2001)
      },
      commemorativeDenominations: {'2000'},
      defaultCommemorativeReason: 'Conmemorativa',
    ),

    // 3.3 España - Época del Euro (grabadas físicamente 1999–presente)
    // Ref: Banco Central Europeo - Monedas de Euro de España:
    // https://www.ecb.europa.eu/euro/coins/html/es.es.html
    // Ref: Real Casa de la Moneda - FNMT Monedas de Colección y 2€ Conmemorativos:
    // https://www.fnmt.es/coleccionista/monedas-2-euros
    // Ref: Numista - Spain - Euro (1999-date):
    // https://en.numista.com/catalogue/spain-euro-1.html
    NumismaticEmissionRuleData(
      country: 'España',
      minYear: 1999,
      maxYear: 2100,
      validCurrencies: ['EUR'],
      defaultCurrency: 'EUR',
      denominations: ['0.01', '0.02', '0.05', '0.10', '0.20', '0.50', '1', '2', '10', '12', '20', '30', '40'],
      denominationMaterials: {
        '0.01': 'Acero bañado en cobre',
        '0.02': 'Acero bañado en cobre',
        '0.05': 'Acero bañado en cobre',
        '0.10': 'Oro nórdico',
        '0.20': 'Oro nórdico',
        '0.50': 'Oro nórdico',
        '1': 'Bimetálica',  // Núcleo cuproníquel, anillo latón de níquel
        '2': 'Bimetálica',  // Núcleo latón de níquel, anillo cuproníquel (y series anuales conmemorativas)
        '10': 'Plata',      // Monedas de colección de 10€ plata
        '12': 'Plata',      // Monedas de colección de 12€ plata
        '20': 'Plata',      // Monedas de colección de 20€ plata
        '30': 'Plata',      // Monedas de colección de 30€ plata
        '40': 'Plata',      // Monedas de colección de 40€ plata
      },
      commemorativeDenominations: {'2', '10', '12', '20', '30', '40'},
      defaultCommemorativeReason: 'Conmemorativa',
    ),

    // 3.4 Unión Europea (Zona Euro, grabadas físicamente 1999–presente)
    // Ref: European Central Bank - Euro Coinage Specifications:
    // https://www.ecb.europa.eu/euro/coins/html/index.en.html
    // Ref: Numista - Eurozone Common Issues:
    // https://en.numista.com/catalogue/eurozone-1.html
    NumismaticEmissionRuleData(
      country: 'Unión Europea',
      minYear: 1999,
      maxYear: 2100,
      validCurrencies: ['EUR'],
      defaultCurrency: 'EUR',
      denominations: ['0.01', '0.02', '0.05', '0.10', '0.20', '0.50', '1', '2'],
      denominationMaterials: {
        '0.01': 'Acero bañado en cobre',
        '0.02': 'Acero bañado en cobre',
        '0.05': 'Acero bañado en cobre',
        '0.10': 'Oro nórdico',
        '0.20': 'Oro nórdico',
        '0.50': 'Oro nórdico',
        '1': 'Bimetálica',
        '2': 'Bimetálica',
      },
      commemorativeDenominations: {'2'},
      defaultCommemorativeReason: 'Conmemorativa',
    ),

    // =========================================================================
    // 4. GUATEMALA
    // =========================================================================

    // 4.1 Guatemala - Época Colonial y Federación Centroamericana (1535–1859)
    // Ref: Banco de Guatemala - Historia Numismática: https://www.banguat.gob.gt
    // Ref: Numista - Guatemala - Real (1733-1859):
    // https://en.numista.com/catalogue/guatemala-real-1.html
    NumismaticEmissionRuleData(
      country: 'Guatemala',
      minYear: 1500,
      maxYear: 1859,
      validCurrencies: ['REAL', 'ESC', 'GTH_CENT'],
      defaultCurrency: 'REAL',
      denominations: ['1/4', '1/2', '1', '2', '4', '8'],
      denominationMaterials: {
        '1/4': 'Plata',
        '1/2': 'Plata',
        '1': 'Plata',
        '2': 'Plata',
        '4': 'Plata',
        '8': 'Plata',
      },
    ),

    // 4.2 Guatemala - Época del Peso (1860–1924)
    // Ref: Numista - Guatemala - Peso (1859-1925):
    // https://en.numista.com/catalogue/guatemala-peso-1.html
    NumismaticEmissionRuleData(
      country: 'Guatemala',
      minYear: 1860,
      maxYear: 1924,
      validCurrencies: ['GTQ_HIST', 'REAL'],
      defaultCurrency: 'GTQ_HIST',
      denominations: ['0.01', '0.05', '0.10', '0.25', '0.50', '1', '2', '4', '5', '10', '20', '1/4', '1/2'],
      denominationMaterials: {
        '0.01': 'Cobre',
        '0.05': 'Níquel',
        '0.10': 'Plata',
        '0.25': 'Plata',
        '0.50': 'Plata',
        '1': 'Plata',
        '2': 'Plata',
        '4': 'Plata',
        '5': 'Oro',
        '10': 'Oro',
        '20': 'Oro',
        '1/4': 'Plata',
        '1/2': 'Plata',
      },
    ),

    // 4.3 Guatemala - Época del Quetzal (1925–presente)
    // Ref: Banco de Guatemala - Especificaciones y aleaciones autorizadas (Decreto 92-98):
    // https://www.banguat.gob.gt/es/page/especificaciones-monedas
    // Ref: Numista - Guatemala - Quetzal (1925-date):
    // https://en.numista.com/catalogue/guatemala-quetzal-1.html
    NumismaticEmissionRuleData(
      country: 'Guatemala',
      minYear: 1925,
      maxYear: 2100,
      validCurrencies: ['GTQ'],
      defaultCurrency: 'GTQ',
      denominations: ['0.005', '0.01', '0.05', '0.10', '0.25', '0.50', '1', '5', '10', '20'],
      denominationMaterials: {
        '0.005': 'Aluminio-Magnesio (Magnalio)',
        '0.01': 'Aluminio-Magnesio (Magnalio)', // 98.5% Al, 1.5% Mg
        '0.05': 'Cuproníquel',                  // 61% Cu, 20% Zn, 19% Ni
        '0.10': 'Cuproníquel',                  // 61% Cu, 20% Zn, 19% Ni
        '0.25': 'Cuproníquel',                  // 61% Cu, 20% Zn, 19% Ni
        '0.50': 'Latón',                        // 70% Cu, 24.5% Zn, 5.5% Ni (Monja Blanca)
        '1': 'Latón',                           // 70% Cu, 24.5% Zn, 5.5% Ni (Moneda de la Paz 1999+)
        '5': 'Oro',                             // 5 Quetzales oro (1926)
        '10': 'Oro',                            // 10 Quetzales oro (1926)
        '20': 'Oro',                            // 20 Quetzales oro (1926)
      },
      commemorativeDenominations: {'1'},
      defaultCommemorativeReason: 'Conmemorativa',
    ),

    // =========================================================================
    // 5. COLOMBIA
    // =========================================================================

    // 5.1 Colombia - Virreinato de Nueva Granada y Reales Predecimales (1500–1846)
    // Ref: Banco de la República - Historia de la moneda colonial:
    // https://www.banrep.gov.co/es/coleccion-numismatica/historia-moneda-colonial
    // Ref: Numista - Colombia - Real (1616-1820):
    // https://en.numista.com/catalogue/colombia-real-1.html
    NumismaticEmissionRuleData(
      country: 'Colombia',
      minYear: 1500,
      maxYear: 1846,
      validCurrencies: ['REAL', 'ESC', 'COP_HIST'],
      defaultCurrency: 'REAL',
      denominations: ['1/4', '1/2', '1', '2', '4', '8'],
      denominationMaterials: {
        '1/4': 'Plata',
        '1/2': 'Plata',
        '1': 'Plata',
        '2': 'Plata',
        '4': 'Plata',
        '8': 'Plata',
      },
    ),

    // 5.2 Colombia - Peso Histórico y Decimal Antiguo (1847–1904)
    // Ref: Banco de la República - Colección Numismática:
    // https://www.banrep.gov.co/es/coleccion-numismatica
    // Ref: Numista - Colombia - Peso Decimal (1847-1904):
    // https://en.numista.com/catalogue/colombia-peso-decimal-1.html
    NumismaticEmissionRuleData(
      country: 'Colombia',
      minYear: 1847,
      maxYear: 1904,
      validCurrencies: ['COP_HIST'],
      defaultCurrency: 'COP_HIST',
      denominations: ['0.01', '0.02', '0.05', '0.10', '0.20', '0.50', '1', '2', '5', '10', '20'],
      denominationMaterials: {
        '0.01': 'Cobre',
        '0.02': 'Cobre',
        '0.05': 'Plata',
        '0.10': 'Plata',
        '0.20': 'Plata',
        '0.50': 'Plata',
        '1': 'Plata',
        '2': 'Oro',
        '5': 'Oro',
        '10': 'Oro',
        '20': 'Oro',
      },
    ),

    // 5.3 Colombia - Peso Moderno (1905–presente)
    // Ref: Banco de la República - Monedas en circulación (Familias de Fauna y Tradicional):
    // https://www.banrep.gov.co/es/billetes-monedas/monedas-circulacion
    // Ref: Numista - Colombia - Republic (1905-date):
    // https://en.numista.com/catalogue/colombia-republic-1905-1.html
    NumismaticEmissionRuleData(
      country: 'Colombia',
      minYear: 1905,
      maxYear: 2100,
      validCurrencies: ['COP'],
      defaultCurrency: 'COP',
      denominations: ['1', '2', '5', '10', '20', '50', '100', '200', '500', '1000'],
      denominationMaterials: {
        '1': 'Bronce de aluminio',
        '2': 'Bronce de aluminio',
        '5': 'Cuproníquel',
        '10': 'Cuproníquel',
        '20': 'Cuproníquel',
        '50': 'Acero inoxidable',     // Acero inoxidable tradicional / Acero niquelado (Osito de anteojos 2012+)
        '100': 'Bronce de aluminio',  // Acero latonado tradicional / Bronce de aluminio (Frailejón 2012+)
        '200': 'Cuproníquel',         // Cuproníquel Quimbaya / Guacamaya bandera (2012+)
        '500': 'Bimetálica',          // Árbol de Guacarí / Rana de cristal (2012+)
        '1000': 'Bimetálica',         // Tortuga caguama (2012+)
      },
      commemorativeDenominations: {'1000'},
      defaultCommemorativeReason: 'Conmemorativa',
    ),

    // =========================================================================
    // 6. CANADÁ
    // =========================================================================

    // 6.1 Canadá - Época Colonial, Victoriana y Plata Pre-Decimal/Decimal (1858–1952)
    // Ref: Royal Canadian Mint - Circulation Coins History:
    // https://www.mint.ca/en/discover/canadian-circulation-coins-history
    // Ref: Numista - Canada (1858-1952):
    // https://en.numista.com/catalogue/canada-1.html
    NumismaticEmissionRuleData(
      country: 'Canadá',
      minYear: 1858,
      maxYear: 1952,
      validCurrencies: ['CAD', 'CAD_HIST'],
      defaultCurrency: 'CAD',
      denominations: ['0.01', '0.05', '0.10', '0.20', '0.25', '0.50', '1', '5', '10'],
      denominationMaterials: {
        '0.01': 'Cobre',  // Large Cent / Small Cent de bronce
        '0.05': 'Níquel', // 5 cents plata .925 (hasta 1921) / Níquel puro (1922-1942, 1946+)
        '0.10': 'Plata',  // 10 cents plata (.925 hasta 1919, .800 1920-1952)
        '0.20': 'Plata',  // 20 cents plata (1858)
        '0.25': 'Plata',  // 25 cents plata
        '0.50': 'Plata',  // 50 cents plata
        '1': 'Plata',     // Silver Voyageur Dollar (.800 plata desde 1935)
        '5': 'Oro',       // 5 Dollars oro (1912-1914)
        '10': 'Oro',      // 10 Dollars oro (1912-1914)
      },
    ),

    // 6.2 Canadá - Época de Transición y Plata / Níquel Isabel II (1953–1967)
    // Ref: Royal Canadian Mint - 1967 Centennial Coinage: https://www.mint.ca
    // Ref: Numista - Canada - Elizabeth II Silver Era:
    // https://en.numista.com/catalogue/canada-2.html
    NumismaticEmissionRuleData(
      country: 'Canadá',
      minYear: 1953,
      maxYear: 1967,
      validCurrencies: ['CAD'],
      defaultCurrency: 'CAD',
      denominations: ['0.01', '0.05', '0.10', '0.25', '0.50', '1'],
      denominationMaterials: {
        '0.01': 'Bronce',
        '0.05': 'Níquel',
        '0.10': 'Plata', // .800 plata
        '0.25': 'Plata', // .800 plata
        '0.50': 'Plata', // .800 plata
        '1': 'Plata',    // .800 plata Voyageur / Centennial 1967
      },
      commemorativeDenominations: {'1'},
      defaultCommemorativeReason: 'Conmemorativa',
    ),

    // 6.3 Canadá - Época Moderna (1968–presente)
    // Ref: Royal Canadian Mint - Modern Coin Specifications:
    // https://www.mint.ca/en/discover/canadian-circulation-coins
    // Ref: Numista - Canada - Modern (1968-date):
    // https://en.numista.com/catalogue/canada-3.html
    NumismaticEmissionRuleData(
      country: 'Canadá',
      minYear: 1968,
      maxYear: 2100,
      validCurrencies: ['CAD'],
      defaultCurrency: 'CAD',
      denominations: ['0.01', '0.05', '0.10', '0.25', '0.50', '1', '2'],
      denominationMaterials: {
        '0.01': 'Cobre',                 // Bronce / Zinc bañado en cobre / Acero cobreado (hasta 2012)
        '0.05': 'Níquel',                // Níquel puro / Acero niquelado multi-ply
        '0.10': 'Acero bañado en níquel',
        '0.25': 'Acero bañado en níquel', // Níquel / Acero multi-ply (series provinciales y conmemorativas)
        '0.50': 'Acero bañado en níquel',
        '1': 'Acero bañado en latón',    // "Loonie" (1987+)
        '2': 'Bimetálica',               // "Toonie" (1996+)
      },
      commemorativeDenominations: {'0.25', '1', '2'},
      defaultCommemorativeReason: 'Conmemorativa',
    ),

    // =========================================================================
    // 7. CUBA
    // =========================================================================

    // 7.1 Cuba - Primera República (1915–1961)
    // Ref: Banco Central de Cuba - Emisiones Históricas: https://www.bc.gob.cu/monedas
    // Ref: Numista - Cuba - First Republic (1915-1961):
    // https://en.numista.com/catalogue/cuba-1.html
    NumismaticEmissionRuleData(
      country: 'Cuba',
      minYear: 1915,
      maxYear: 1961,
      validCurrencies: ['CUP'],
      defaultCurrency: 'CUP',
      denominations: ['0.01', '0.02', '0.05', '0.10', '0.20', '0.40', '1', '2', '4', '5', '10', '20'],
      denominationMaterials: {
        '0.01': 'Cuproníquel',
        '0.02': 'Cuproníquel',
        '0.05': 'Cuproníquel',
        '0.10': 'Plata', // .900 plata
        '0.20': 'Plata', // .900 plata
        '0.40': 'Plata', // .900 plata
        '1': 'Plata',    // 1 Peso Estrella ABC / José Martí
        '2': 'Oro',      // 2 Pesos oro
        '4': 'Oro',      // 4 Pesos oro
        '5': 'Oro',      // 5 Pesos oro
        '10': 'Oro',     // 10 Pesos oro
        '20': 'Oro',     // 20 Pesos oro
      },
      commemorativeDenominations: {'1'},
      defaultCommemorativeReason: 'Conmemorativa',
    ),

    // 7.2 Cuba - Período Socialista y Régimen Dual CUP/CUC (1962–presente)
    // Ref: Banco Central de Cuba - Sistema Monetario: https://www.bc.gob.cu
    // Ref: Numista - Cuba - Second Republic & CUC (1962-date):
    // https://en.numista.com/catalogue/cuba-2.html
    NumismaticEmissionRuleData(
      country: 'Cuba',
      minYear: 1962,
      maxYear: 2100,
      validCurrencies: ['CUP', 'CUC'],
      defaultCurrency: 'CUP',
      denominations: ['0.01', '0.02', '0.05', '0.10', '0.20', '0.25', '0.40', '0.50', '1', '3', '5'],
      denominationMaterials: {
        '0.01': 'Aluminio',
        '0.02': 'Aluminio',
        '0.05': 'Aluminio',
        '0.10': 'Aluminio',    // CUP aluminio / CUC acero niquelado
        '0.20': 'Cuproníquel', // CUP aluminio/cuproníquel
        '0.25': 'Cuproníquel', // CUC cuproníquel
        '0.40': 'Cuproníquel',
        '0.50': 'Cuproníquel', // CUC cuproníquel
        '1': 'Cuproníquel',    // CUP cuproníquel / CUC cuproníquel
        '3': 'Cuproníquel',    // 3 Pesos Che Guevara cuproníquel/acero
        '5': 'Bimetálica',     // 5 Pesos CUC bimetálica / CUP latón
      },
      commemorativeDenominations: {'3'},
      defaultCommemorativeReason: 'Conmemorativa',
    ),

    // =========================================================================
    // 8. ARGENTINA
    // =========================================================================

    // 8.1 Argentina - Provincias Unidas del Río de la Plata y Confederación (1813–1880)
    // Ref: Numista - Argentina - Real & Early Peso (1813-1881):
    // https://en.numista.com/catalogue/argentina-1.html
    NumismaticEmissionRuleData(
      country: 'Argentina',
      minYear: 1813,
      maxYear: 1880,
      validCurrencies: ['ARM', 'REAL'],
      defaultCurrency: 'ARM',
      denominations: ['1/4', '1/2', '1', '2', '4', '8'],
      denominationMaterials: {
        '1/4': 'Cobre',
        '1/2': 'Plata',
        '1': 'Plata',
        '2': 'Plata',
        '4': 'Plata',
        '8': 'Plata',
      },
    ),

    // 8.2 Argentina - Peso Moneda Nacional (1881–1969)
    // Ref: Banco Central de la República Argentina - Emisiones históricas: https://www.bcra.gob.ar
    // Ref: Numista - Argentina - Peso Moneda Nacional (1881-1969):
    // https://en.numista.com/catalogue/argentina-2.html
    NumismaticEmissionRuleData(
      country: 'Argentina',
      minYear: 1881,
      maxYear: 1969,
      validCurrencies: ['ARM'],
      defaultCurrency: 'ARM',
      denominations: ['0.01', '0.02', '0.05', '0.10', '0.20', '0.50', '1', '2', '5', '10', '20', '25', '50', '100'],
      denominationMaterials: {
        '0.01': 'Bronce',
        '0.02': 'Bronce',
        '0.05': 'Cuproníquel',
        '0.10': 'Cuproníquel',
        '0.20': 'Cuproníquel',
        '0.50': 'Plata',        // 50 centavos plata / cuproníquel
        '1': 'Plata',           // 1 peso plata Patacón (1881-1896) / cuproníquel
        '5': 'Oro',             // 5 pesos Argentino de oro (1881-1896)
        '10': 'Cuproníquel',
        '20': 'Cuproníquel',
        '25': 'Acero',
        '50': 'Acero',
        '100': 'Acero',
      },
    ),

    // 8.3 Argentina - Peso Ley (1970–1983)
    // Ref: Numista - Argentina - Peso Ley (1970-1983):
    // https://en.numista.com/catalogue/argentina-3.html
    NumismaticEmissionRuleData(
      country: 'Argentina',
      minYear: 1970,
      maxYear: 1983,
      validCurrencies: ['ARL'],
      defaultCurrency: 'ARL',
      denominations: ['0.01', '0.05', '0.10', '0.20', '0.50', '1', '5', '10', '20', '50', '100'],
      denominationMaterials: {
        '0.01': 'Bronce de aluminio',
        '0.05': 'Bronce de aluminio',
        '0.10': 'Bronce de aluminio',
        '0.20': 'Bronce de aluminio',
        '0.50': 'Bronce de aluminio',
        '1': 'Bronce de aluminio',
        '5': 'Bronce de aluminio',
        '10': 'Bronce de aluminio',
        '20': 'Bronce de aluminio',
        '50': 'Bronce de aluminio',
        '100': 'Bronce de aluminio',
      },
    ),

    // 8.4 Argentina - Peso Argentino y Austral (1983–1991)
    // Ref: Numista - Argentina - Austral (1985-1991):
    // https://en.numista.com/catalogue/argentina-4.html
    NumismaticEmissionRuleData(
      country: 'Argentina',
      minYear: 1983,
      maxYear: 1991,
      validCurrencies: ['ARA', 'ARP'],
      defaultCurrency: 'ARA',
      denominations: ['0.005', '0.01', '0.05', '0.10', '0.50', '1', '5', '10', '50', '100', '500', '1000'],
      denominationMaterials: {
        '0.005': 'Aluminio',
        '0.01': 'Aluminio',
        '0.05': 'Aluminio',
        '0.10': 'Aluminio',
        '0.50': 'Aluminio',
        '1': 'Aluminio',
        '5': 'Aluminio',
        '10': 'Aluminio',
        '50': 'Cuproníquel',
        '100': 'Cuproníquel',
        '500': 'Cuproníquel',
        '1000': 'Cuproníquel',
      },
    ),

    // 8.5 Argentina - Peso Convertible Moderno (1992–presente)
    // Ref: Banco Central de la República Argentina - Monedas en circulación: https://www.bcra.gob.ar
    // Ref: Numista - Argentina - Peso (1992-date):
    // https://en.numista.com/catalogue/argentina-5.html
    NumismaticEmissionRuleData(
      country: 'Argentina',
      minYear: 1992,
      maxYear: 2100,
      validCurrencies: ['ARS'],
      defaultCurrency: 'ARS',
      denominations: ['0.01', '0.05', '0.10', '0.25', '0.50', '1', '2', '5', '10'],
      denominationMaterials: {
        '0.01': 'Bronce de aluminio',
        '0.05': 'Bronce de aluminio',
        '0.10': 'Bronce de aluminio',
        '0.25': 'Bronce de aluminio',
        '0.50': 'Bronce de aluminio',
        '1': 'Bimetálica', // Centro bronce de aluminio, anillo cuproníquel
        '2': 'Bimetálica', // Centro cuproníquel, anillo bronce de aluminio
        '5': 'Acero bañado en cobre',
        '10': 'Acero bañado en latón',
      },
      commemorativeDenominations: {'1', '2'},
      defaultCommemorativeReason: 'Conmemorativa',
    ),

    // =========================================================================
    // 9. BRASIL
    // =========================================================================

    // 9.1 Brasil - Período Colonial e Imperial (Réis 1500–1942)
    // Ref: Numista - Brazil - Real / Réis (1500-1942):
    // https://en.numista.com/catalogue/brazil-1.html
    NumismaticEmissionRuleData(
      country: 'Brasil',
      minYear: 1500,
      maxYear: 1942,
      validCurrencies: ['BRS'],
      defaultCurrency: 'BRS',
      denominations: ['10', '20', '40', '80', '100', '200', '300', '400', '500', '640', '960', '1000', '2000'],
      denominationMaterials: {
        '10': 'Cobre',
        '20': 'Cobre',
        '40': 'Cobre',
        '80': 'Cobre',
        '100': 'Cuproníquel',
        '200': 'Cuproníquel',
        '300': 'Cuproníquel',
        '400': 'Cuproníquel',
        '500': 'Plata',
        '640': 'Plata',
        '960': 'Plata',   // Patacão de plata
        '1000': 'Plata',
        '2000': 'Plata',
      },
    ),

    // 9.2 Brasil - Cruzeiro y Cruzado (1942–1993)
    // Ref: Banco Central do Brasil - Museu de Valores: https://www.bcb.gov.br
    // Ref: Numista - Brazil - Cruzeiro (1942-1986):
    // https://en.numista.com/catalogue/brazil-2.html
    NumismaticEmissionRuleData(
      country: 'Brasil',
      minYear: 1942,
      maxYear: 1993,
      validCurrencies: ['BRB', 'BRC', 'BRN', 'BRE', 'BRR'],
      defaultCurrency: 'BRB',
      denominations: ['0.10', '0.20', '0.50', '1', '2', '5', '10', '20', '50', '100', '200', '500', '1000', '5000'],
      denominationMaterials: {
        '0.10': 'Bronce de aluminio',
        '0.20': 'Bronce de aluminio',
        '0.50': 'Bronce de aluminio',
        '1': 'Bronce de aluminio',
        '2': 'Bronce de aluminio',
        '5': 'Cuproníquel',
        '10': 'Cuproníquel',
        '20': 'Cuproníquel',
        '50': 'Cuproníquel',
        '100': 'Acero inoxidable',
        '200': 'Acero inoxidable',
        '500': 'Acero inoxidable',
        '1000': 'Acero inoxidable',
        '5000': 'Acero inoxidable',
      },
    ),

    // 9.3 Brasil - Real Moderno (grabadas físicamente 1994–presente)
    // Ref: Banco Central do Brasil - Moedas do Real: https://www.bcb.gov.br/cedulasemoedas/moedasreal
    // Ref: Numista - Brazil - Real (1994-date):
    // https://en.numista.com/catalogue/brazil-3.html
    NumismaticEmissionRuleData(
      country: 'Brasil',
      minYear: 1994,
      maxYear: 2100,
      validCurrencies: ['BRL'],
      defaultCurrency: 'BRL',
      denominations: ['0.01', '0.05', '0.10', '0.25', '0.50', '1'],
      denominationMaterials: {
        '0.01': 'Acero bañado en cobre',
        '0.05': 'Acero bañado en cobre',
        '0.10': 'Acero bañado en bronce',
        '0.25': 'Acero bañado en bronce',
        '0.50': 'Cuproníquel', // Cuproníquel (1ª familia) / Acero inoxidable (2ª familia)
        '1': 'Bimetálica',     // Centro acero inoxidable, anillo acero bañado en bronce
      },
      commemorativeDenominations: {'1'},
      defaultCommemorativeReason: 'Conmemorativa',
    ),

    // =========================================================================
    // 10. CHILE
    // =========================================================================

    // 10.1 Chile - Período Colonial y Reales (1500–1850)
    // Ref: Numista - Chile - Real (1743-1851):
    // https://en.numista.com/catalogue/chile-1.html
    NumismaticEmissionRuleData(
      country: 'Chile',
      minYear: 1500,
      maxYear: 1850,
      validCurrencies: ['CLF', 'REAL', 'ESC'],
      defaultCurrency: 'REAL',
      denominations: ['1/4', '1/2', '1', '2', '4', '8'],
      denominationMaterials: {
        '1/4': 'Plata',
        '1/2': 'Plata',
        '1': 'Plata',
        '2': 'Plata',
        '4': 'Plata',
        '8': 'Plata',
      },
    ),

    // 10.2 Chile - Peso Antiguo Decimal y Escudo (1851–1974)
    // Ref: Banco Central de Chile - Billetes y Monedas: https://www.bcentral.cl
    // Ref: Numista - Chile - Peso (1851-1959) & Escudo (1960-1975):
    // https://en.numista.com/catalogue/chile-2.html
    NumismaticEmissionRuleData(
      country: 'Chile',
      minYear: 1851,
      maxYear: 1974,
      validCurrencies: ['CLF', 'CLE'],
      defaultCurrency: 'CLF',
      denominations: ['0.005', '0.01', '0.02', '0.05', '0.10', '0.20', '0.50', '1', '2', '5', '10', '20', '50', '100'],
      denominationMaterials: {
        '0.005': 'Cobre',
        '0.01': 'Cobre',
        '0.02': 'Cobre',
        '0.05': 'Cuproníquel',
        '0.10': 'Cuproníquel',
        '0.20': 'Cuproníquel',
        '0.50': 'Plata',
        '1': 'Plata',
        '2': 'Oro',
        '5': 'Oro',
        '10': 'Oro',
        '20': 'Oro',
        '50': 'Oro',
        '100': 'Oro',
      },
    ),

    // 10.3 Chile - Peso Actual (1975–presente)
    // Ref: Banco Central de Chile - Monedas en circulación: https://www.bcentral.cl/billetes-y-monedas/monedas
    // Ref: Numista - Chile - Peso (1975-date):
    // https://en.numista.com/catalogue/chile-3.html
    NumismaticEmissionRuleData(
      country: 'Chile',
      minYear: 1975,
      maxYear: 2100,
      validCurrencies: ['CLP'],
      defaultCurrency: 'CLP',
      denominations: ['1', '5', '10', '50', '100', '500'],
      denominationMaterials: {
        '1': 'Aluminio',
        '5': 'Aluminio-Bronce',
        '10': 'Aluminio-Bronce',
        '50': 'Aluminio-Bronce', // Decagonal
        '100': 'Bimetálica',     // Centro alpaca, anillo bronce de aluminio
        '500': 'Bimetálica',     // Centro bronce de aluminio, anillo alpaca
      },
      commemorativeDenominations: {'100', '500'},
      defaultCommemorativeReason: 'Conmemorativa',
    ),

    // =========================================================================
    // 11. PERÚ
    // =========================================================================

    // 11.1 Perú - Época Colonial y Reales (1500–1862)
    // Ref: Numista - Peru - Real (1568-1857):
    // https://en.numista.com/catalogue/peru-1.html
    NumismaticEmissionRuleData(
      country: 'Perú',
      minYear: 1500,
      maxYear: 1862,
      validCurrencies: ['PER', 'REAL', 'ESC'],
      defaultCurrency: 'REAL',
      denominations: ['1/4', '1/2', '1', '2', '4', '8'],
      denominationMaterials: {
        '1/4': 'Plata',
        '1/2': 'Plata',
        '1': 'Plata',
        '2': 'Plata',
        '4': 'Plata',
        '8': 'Plata',
      },
    ),

    // 11.2 Perú - Sol de Oro e Inti (1863–1990)
    // Ref: Banco Central de Reserva del Perú - Numismática: https://www.bcrp.gob.pe
    // Ref: Numista - Peru - Sol de Oro (1863-1985) & Inti (1985-1991):
    // https://en.numista.com/catalogue/peru-2.html
    NumismaticEmissionRuleData(
      country: 'Perú',
      minYear: 1863,
      maxYear: 1990,
      validCurrencies: ['PEH', 'PEI'],
      defaultCurrency: 'PEH',
      denominations: ['0.01', '0.02', '0.05', '0.10', '0.20', '0.50', '1', '2', '5', '10', '20', '50', '100', '500'],
      denominationMaterials: {
        '0.01': 'Cobre',
        '0.02': 'Cobre',
        '0.05': 'Latón',
        '0.10': 'Latón',
        '0.20': 'Latón',
        '0.50': 'Plata',
        '1': 'Plata', // Un Sol de plata (1863-1935) / Latón
        '2': 'Oro',
        '5': 'Oro',
        '10': 'Oro',
        '20': 'Oro',
        '50': 'Oro',
        '100': 'Oro',
        '500': 'Cuproníquel',
      },
    ),

    // 11.3 Perú - Sol Moderno (1991–presente)
    // Ref: Banco Central de Reserva del Perú - Familia de Monedas: https://www.bcrp.gob.pe/billetes-y-monedas/monedas.html
    // Ref: Numista - Peru - Sol (1991-date):
    // https://en.numista.com/catalogue/peru-3.html
    NumismaticEmissionRuleData(
      country: 'Perú',
      minYear: 1991,
      maxYear: 2100,
      validCurrencies: ['PEN'],
      defaultCurrency: 'PEN',
      denominations: ['0.01', '0.05', '0.10', '0.20', '0.50', '1', '2', '5'],
      denominationMaterials: {
        '0.01': 'Aluminio',
        '0.05': 'Aluminio',
        '0.10': 'Latón',
        '0.20': 'Latón',
        '0.50': 'Alpaca (Plata alemana)',
        '1': 'Alpaca (Plata alemana)', // Serie Riqueza y Orgullo del Perú (conmemorativas)
        '2': 'Bimetálica',             // Centro latón, anillo acero inoxidable
        '5': 'Bimetálica',             // Centro latón, anillo acero inoxidable
      },
      commemorativeDenominations: {'1'},
      defaultCommemorativeReason: 'Conmemorativa',
    ),

    // =========================================================================
    // 12. REINO UNIDO
    // =========================================================================

    // 12.1 Reino Unido - Sistema Pre-Decimal (1500–1970)
    // Ref: The Royal Mint - History of the Pre-decimal Coinage: https://www.royalmint.com
    // Ref: Numista - United Kingdom - Pre-decimal (1500-1970):
    // https://en.numista.com/catalogue/united-kingdom-1.html
    NumismaticEmissionRuleData(
      country: 'Reino Unido',
      minYear: 1500,
      maxYear: 1970,
      validCurrencies: ['GBP_OLD'],
      defaultCurrency: 'GBP_OLD',
      denominations: ['1/4', '1/2', '1', '3', '6', '2', '2.5', '5'],
      denominationMaterials: {
        '1/4': 'Cobre',        // Farthing
        '1/2': 'Cobre',        // Halfpenny
        '1': 'Cobre',          // Penny
        '3': 'Níquel-Latón',   // Threepence dodecagonal (o plata pre-1937)
        '6': 'Cuproníquel',    // Sixpence plata/cuproníquel
        '2': 'Cuproníquel',    // Florin (Two Shillings)
        '2.5': 'Cuproníquel',  // Half Crown
        '5': 'Cuproníquel',    // Crown
      },
    ),

    // 12.2 Reino Unido - Sistema Decimal (1971–presente)
    // Ref: The Royal Mint - Modern Coin Specifications: https://www.royalmint.com
    // Ref: Numista - United Kingdom - Decimal (1971-date):
    // https://en.numista.com/catalogue/united-kingdom-2.html
    NumismaticEmissionRuleData(
      country: 'Reino Unido',
      minYear: 1971,
      maxYear: 2100,
      validCurrencies: ['GBP'],
      defaultCurrency: 'GBP',
      denominations: ['0.005', '0.01', '0.02', '0.05', '0.10', '0.20', '0.50', '1', '2', '5'],
      denominationMaterials: {
        '0.005': 'Bronce',
        '0.01': 'Acero bañado en cobre',
        '0.02': 'Acero bañado en cobre',
        '0.05': 'Acero bañado en níquel',
        '0.10': 'Acero bañado en níquel',
        '0.20': 'Cuproníquel',           // Heptagonal (84% Cu, 16% Ni)
        '0.50': 'Cuproníquel',           // Heptagonal
        '1': 'Bimetálica',               // Dodecagonal bimetálica (2017+) / Níquel-latón redondo (1983-2016)
        '2': 'Bimetálica',               // Centro cuproníquel, anillo latón de níquel
        '5': 'Cuproníquel',              // Crown decimal conmemorativa
      },
      commemorativeDenominations: {'0.50', '2', '5'},
      defaultCommemorativeReason: 'Conmemorativa',
    ),

    // =========================================================================
    // 13. FRANCIA
    // =========================================================================

    // 13.1 Francia - Ancien Régime (1500–1794)
    // Ref: Monnaie de Paris - Histoire: https://www.monnaiedeparis.fr
    // Ref: Numista - France - Royal (1500-1794):
    // https://en.numista.com/catalogue/france-royal-1.html
    NumismaticEmissionRuleData(
      country: 'Francia',
      minYear: 1500,
      maxYear: 1794,
      validCurrencies: ['LVT', 'ECU', 'LDO'],
      defaultCurrency: 'LVT',
      denominations: ['1/12', '1/6', '1/4', '1/2', '1', '2', '3', '6', '12', '24'],
      denominationMaterials: {
        '1/12': 'Cobre', // Denier
        '1/6': 'Cobre',  // Liard
        '1/4': 'Cobre',  // Sol / Douzain
        '1/2': 'Plata',  // Demi-écu
        '1': 'Plata',    // Écu de plata
        '2': 'Oro',      // Louis d'or
        '3': 'Plata',
        '6': 'Plata',
        '12': 'Oro',
        '24': 'Oro',
      },
    ),

    // 13.2 Francia - Franc Ancien (1795–1959)
    // Ref: Numista - France - Franc (1795-1959):
    // https://en.numista.com/catalogue/france-1.html
    NumismaticEmissionRuleData(
      country: 'Francia',
      minYear: 1795,
      maxYear: 1959,
      validCurrencies: ['FRF'],
      defaultCurrency: 'FRF',
      denominations: ['0.01', '0.02', '0.05', '0.10', '0.20', '0.25', '0.50', '1', '2', '5', '10', '20', '50', '100'],
      denominationMaterials: {
        '0.01': 'Bronce',
        '0.02': 'Bronce',
        '0.05': 'Aluminio',           // Bronce / Aluminio
        '0.10': 'Aluminio',
        '0.20': 'Aluminio',
        '0.25': 'Cuproníquel',
        '0.50': 'Aluminio-Bronce',
        '1': 'Aluminio-Bronce',       // Morlon / Semeuse plata
        '2': 'Aluminio-Bronce',
        '5': 'Plata',                 // Plata / Cuproníquel
        '10': 'Plata',                // Plata Turin / Oro Napoleón
        '20': 'Plata',                // Plata Turin / Oro Napoleón
        '50': 'Cuproníquel',
        '100': 'Cuproníquel',
      },
    ),

    // 13.3 Francia - Nouveau Franc (1960–2001)
    // Ref: Numista - France - Nouveau Franc (1960-2001):
    // https://en.numista.com/catalogue/france-2.html
    NumismaticEmissionRuleData(
      country: 'Francia',
      minYear: 1960,
      maxYear: 2001,
      validCurrencies: ['FRF'],
      defaultCurrency: 'FRF',
      denominations: ['0.01', '0.05', '0.10', '0.20', '0.50', '1', '2', '5', '10', '20', '50', '100'],
      denominationMaterials: {
        '0.01': 'Acero inoxidable',
        '0.05': 'Bronce de aluminio',
        '0.10': 'Bronce de aluminio',
        '0.20': 'Bronce de aluminio',
        '0.50': 'Níquel',
        '1': 'Níquel',                // Semeuse de níquel
        '2': 'Níquel',
        '5': 'Plata',                 // Plata .835 (1960-1969) / Cuproníquel niquelado (1970+)
        '10': 'Bimetálica',           // Bimetálica Génie de la Bastille (1988-2001) / Plata Hercule
        '20': 'Trimetálica',          // Trimetálica Mont-Saint-Michel (1992-2001)
        '50': 'Plata',                // 50 Francs Hercule plata (1974-1980)
        '100': 'Plata',               // 100 Francs plata conmemorativa
      },
      commemorativeDenominations: {'10', '20', '100'},
      defaultCommemorativeReason: 'Conmemorativa',
    ),

    // =========================================================================
    // 14. ALEMANIA
    // =========================================================================

    // 14.1 Alemania - Imperio Alemán y República de Weimar (Goldmark / Reichsmark 1873–1948)
    // Ref: Deutsche Bundesbank - Geldgeschichte: https://www.bundesbank.de
    // Ref: Numista - Germany (1871-1948):
    // https://en.numista.com/catalogue/germany-1.html
    NumismaticEmissionRuleData(
      country: 'Alemania',
      minYear: 1873,
      maxYear: 1948,
      validCurrencies: ['FRG', 'PRM', 'RTM', 'RKM'],
      defaultCurrency: 'RKM',
      denominations: ['0.01', '0.02', '0.04', '0.05', '0.10', '0.50', '1', '2', '3', '5', '10', '20'],
      denominationMaterials: {
        '0.01': 'Bronce',
        '0.02': 'Bronce',
        '0.04': 'Bronce',
        '0.05': 'Bronce de aluminio', // Cuproníquel / Bronce de aluminio / Zinc
        '0.10': 'Bronce de aluminio',
        '0.50': 'Bronce de aluminio',
        '1': 'Níquel',                // Níquel / Plata
        '2': 'Plata',                 // Plata .625-.900
        '3': 'Plata',
        '5': 'Plata',                 // 5 Reichsmark Hindenburg / Potsdam plata
        '10': 'Oro',                  // 10 Mark oro imperial
        '20': 'Oro',                  // 20 Mark oro imperial
      },
    ),

    // 14.2 Alemania - Deutsche Mark (RFA 1948–2001)
    // Ref: Deutsche Bundesbank - DM-Münzen: https://www.bundesbank.de
    // Ref: Numista - Federal Republic of Germany - Mark (1948-2001):
    // https://en.numista.com/catalogue/germany-2.html
    NumismaticEmissionRuleData(
      country: 'Alemania',
      minYear: 1948,
      maxYear: 2001,
      validCurrencies: ['DEM', 'DDM'],
      defaultCurrency: 'DEM',
      denominations: ['0.01', '0.02', '0.05', '0.10', '0.50', '1', '2', '5', '10'],
      denominationMaterials: {
        '0.01': 'Acero bañado en cobre',
        '0.02': 'Acero bañado en cobre', // Bronce / Acero cobreado
        '0.05': 'Acero bañado en latón',
        '0.10': 'Acero bañado en latón',
        '0.50': 'Cuproníquel',
        '1': 'Cuproníquel',
        '2': 'Cuproníquel',
        '5': 'Plata',                    // Plata .625 (1951-1974) / Cuproníquel Magnimat (1975+)
        '10': 'Plata',                   // 10 DM plata conmemorativa (Olimpiadas 1972, Aniversarios)
      },
      commemorativeDenominations: {'5', '10'},
      defaultCommemorativeReason: 'Conmemorativa',
    ),

    // =========================================================================
    // 15. ITALIA
    // =========================================================================

    // 15.1 Italia - Reino de Italia (1861–1945)
    // Ref: Banca d'Italia - Museo della Moneta: https://www.bancaditalia.it
    // Ref: Numista - Italy - Kingdom (1861-1946):
    // https://en.numista.com/catalogue/italy-1.html
    NumismaticEmissionRuleData(
      country: 'Italia',
      minYear: 1861,
      maxYear: 1945,
      validCurrencies: ['ITL'],
      defaultCurrency: 'ITL',
      denominations: ['0.01', '0.02', '0.05', '0.10', '0.20', '0.50', '1', '2', '5', '10', '20', '50', '100'],
      denominationMaterials: {
        '0.01': 'Bronce',
        '0.02': 'Bronce',
        '0.05': 'Bronce',
        '0.10': 'Bronce',
        '0.20': 'Níquel',             // Níquel / Acero
        '0.50': 'Níquel',             // Plata / Níquel
        '1': 'Níquel',                // Plata / Níquel / Acero (Acmonital)
        '2': 'Níquel',                // Plata / Níquel / Acero (Acmonital)
        '5': 'Plata',                 // Plata 5 Lire
        '10': 'Plata',                // Plata 10 Lire Biga / Oro
        '20': 'Plata',                // Plata 20 Lire Fascio / Oro
        '50': 'Oro',                  // 50 Lire oro
        '100': 'Oro',                 // 100 Lire oro
      },
    ),

    // 15.2 Italia - República Italiana (Lira 1946–2001)
    // Ref: Istituto Poligrafico e Zecca dello Stato: https://www.ipzs.it
    // Ref: Numista - Italy - Republic - Lira (1946-2001):
    // https://en.numista.com/catalogue/italy-2.html
    NumismaticEmissionRuleData(
      country: 'Italia',
      minYear: 1946,
      maxYear: 2001,
      validCurrencies: ['ITL'],
      defaultCurrency: 'ITL',
      denominations: ['1', '2', '5', '10', '20', '50', '100', '200', '500', '1000'],
      denominationMaterials: {
        '1': 'Aluminio',              // Italma (Aluminio-Magnesio)
        '2': 'Aluminio',              // Italma
        '5': 'Aluminio',              // Italma Delfino
        '10': 'Aluminio',             // Italma Spiga
        '20': 'Bronce de aluminio',   // Bronzital
        '50': 'Acero inoxidable',     // Acmonital Vulcano
        '100': 'Acero inoxidable',    // Acmonital Minerva
        '200': 'Bronce de aluminio',  // Bronzital
        '500': 'Bimetálica',          // Caravelle de plata (1958-1967) / Bimetálica Quirinale (1982-2001)
        '1000': 'Bimetálica',         // Bimetálica Confini d'Europa (1997-2001)
      },
      commemorativeDenominations: {'500', '1000'},
      defaultCommemorativeReason: 'Conmemorativa',
    ),
  ];
}

/// Metadata record representing a country's currency epoch emission rules.
class NumismaticEmissionRuleData {
  final String country;
  final int minYear;
  final int maxYear;
  final List<String> validCurrencies;
  final String? defaultCurrency;
  final List<String> denominations;
  final Map<String, String> denominationMaterials;
  final Set<String> commemorativeDenominations;
  final String? defaultCommemorativeReason;

  const NumismaticEmissionRuleData({
    required this.country,
    required this.minYear,
    required this.maxYear,
    required this.validCurrencies,
    this.defaultCurrency,
    required this.denominations,
    this.denominationMaterials = const {},
    this.commemorativeDenominations = const {},
    this.defaultCommemorativeReason,
  });

  bool matches(String targetCountry, int year) {
    if (country.toLowerCase() != targetCountry.trim().toLowerCase()) return false;
    return year >= minYear && year <= maxYear;
  }
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
