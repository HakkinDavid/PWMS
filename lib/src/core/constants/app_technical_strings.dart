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
  static const numisPapelMonedaKeyword = 'papel moneda';
  static const numisNotafiliaKeyword = 'notafilia';
  static const numisNumismaticKeyword = 'numismátic';
  static const materialPapelLower = 'papel';
  static const materialPapelAlgodonWithAccentLower = 'papel de algodón';
  static const materialPapelAlgodonWithoutAccentLower = 'papel de algodon';
  static const materialPolimeroWithAccentLower = 'polímero';
  static const materialPolimeroWithoutAccentLower = 'polimero';
  static const materialCottonPaperLower = 'cotton paper';
  static const magPaisWithAccent = 'País';
  static const magPaisWithoutAccent = 'Pais';
  static const magPaisLower = 'país';
  static const magPaisWithoutAccentLower = 'pais';
  static const magMonedaLower = 'moneda';
  static const magDivisaLower = 'divisa';
  static const magMetalLower = 'metal';
  static const magMaterialLower = 'material';
  static const magConservacionWithAccentLower = 'conservación';
  static const magConservacionWithoutAccentLower = 'conservacion';
  static const magGradoLower = 'grado';
  static const magAcunacionWithAccentLower = 'acuñación';
  static const magAcunacionWithoutAccentLower = 'acunacion';
  static const magAnoWithAccentLower = 'año';
  static const magAnoWithoutAccentLower = 'ano';
  static const magAnoDeAcunacionLower = 'año de acuñación';
  static const magMintageLower = 'mintage';
  static const magValorFacialLower = 'valor facial';
  static const magValorNominalLower = 'valor nominal';
  static const magEmisorLower = 'emisor';
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
    'Latón de manganeso',
    'Latón de manganeso (Clad)',
    'Latón de manganeso sobre núcleo de cobre',
    'Cuproníquel sobre núcleo de cobre',
    'Níquel-Latón',
    'Latón dorado (Tombac)',
    'Níquel',
    'Alpaca (Plata alemana)',
    'Oro nórdico',
    'Billón (Vellón)',
    'Zinc',
    'Zinc bañado en cobre',
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
    // Materiales de necesidad, emergencia, Notgeld, papel moneda y polímeros
    'Papel',
    'Papel de algodón',
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
    'Liras': 'Lira',
    'Lira': 'Lira',
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
    'Italiana': 'Italiana',
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
    'Antiguas': 'Antigua',
    'Históricos': 'Histórico',
    'Historicos': 'Histórico',
    'Históricas': 'Histórica',
    'Historicas': 'Histórica',
    'Continentales': 'Continental',
    'Confederados': 'Confederado',
    'Confederadas': 'Confederada',
    'Orientales': 'Oriental',
    'Occidentales': 'Occidental',
    // Variantes femeninas
    'Esterlinas': 'Esterlina',
    'Italianas': 'Italiana',
    'Españolas': 'Española',
    'Espanolas': 'Española',
    'Griegas': 'Griega',
    'Suecas': 'Sueca',
    'Noruegas': 'Noruega',
    'Danesas': 'Danesa',
    'Islandesas': 'Islandesa',
    'Irlandesas': 'Irlandesa',
    'Escocesas': 'Escocesa',
    'Vaticanas': 'Vaticana',
    'Maltesas': 'Maltesa',
    'Sardas': 'Sarda',
    'Milanesas': 'Milanesa',
    'Tornesas': 'Tornesa',
    'Jamaicanas': 'Jamaicana',
    'Egipcias': 'Egipcia',
    'Sirias': 'Siria',
    'Libanesas': 'Libanesa',
    'Otomanas': 'Otomana',
    'Ucranianas': 'Ucraniana',
    'Estonias': 'Estonia',
    'Letonas': 'Letona',
    'Lituanas': 'Lituana',
    'Guineanas': 'Guineana',
    'Saharauis': 'Saharaui',
    'Indias': 'India',
    'Indonesias': 'Indonesia',
    'Pakistaníes': 'Pakistaní',
    'Pakistanies': 'Pakistaní',
    'Mauricianas': 'Mauriciana',
    'Nepalesas': 'Nepalesa',
    'Belgas': 'Belga',
    'Suizas': 'Suiza',
    'Rusas': 'Rusa',
    'Polacas': 'Polaca',
    'Checas': 'Checa',
    'Eslovacas': 'Eslovaca',
    'Húngaras': 'Húngara',
    'Hungaras': 'Húngara',
    'Rumanas': 'Rumana',
    'Búlgaras': 'Búlgara',
    'Bulgaras': 'Búlgara',
    'Serbias': 'Serbia',
    'Turcas': 'Turca',
    'Chinas': 'China',
    'Japonesas': 'Japonesa',
    'Coreanas': 'Coreana',
    'Brasileñas': 'Brasileña',
    'Brasilenas': 'Brasileña',
    'Peruanas': 'Peruana',
    'Bolivianas': 'Boliviana',
    'Guatemaltecas': 'Guatemalteca',
    'Salvadoreñas': 'Salvadoreña',
    'Salvadorenas': 'Salvadoreña',
    'Hondureñas': 'Hondureña',
    'Hondurenas': 'Hondureña',
    'Panameñas': 'Panameña',
    'Panamenas': 'Panameña',
    'Uruguayas': 'Uruguaya',
    'Paraguayas': 'Paraguaya',
    'Haitianas': 'Haitiana',
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
    'latón de manganeso': 'Latón de manganeso sobre núcleo de cobre',
    'laton de manganeso': 'Latón de manganeso sobre núcleo de cobre',
    'latón de manganeso sobre núcleo de cobre': 'Latón de manganeso sobre núcleo de cobre',
    'laton de manganeso sobre nucleo de cobre': 'Latón de manganeso sobre núcleo de cobre',
    'latón de manganeso (clad)': 'Latón de manganeso (Clad)',
    'laton de manganeso (clad)': 'Latón de manganeso (Clad)',
    'manganese brass': 'Latón de manganeso sobre núcleo de cobre',
    'manganese brass clad copper': 'Latón de manganeso sobre núcleo de cobre',
    'cuproníquel sobre núcleo de cobre': 'Cuproníquel sobre núcleo de cobre',
    'cuproniquel sobre nucleo de cobre': 'Cuproníquel sobre núcleo de cobre',
    'cupronickel clad copper': 'Cuproníquel sobre núcleo de cobre',
    'níquel-latón': 'Níquel-Latón',
    'niquel-laton': 'Níquel-Latón',
    'nickel-brass': 'Níquel-Latón',
    'latón de níquel': 'Níquel-Latón',
    'laton de niquel': 'Níquel-Latón',
    'níquel latón': 'Níquel-Latón',
    'niquel laton': 'Níquel-Latón',
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
    'zinc bañado en cobre': 'Zinc bañado en cobre',
    'copper-plated zinc': 'Zinc bañado en cobre',
    'zinc electrodepositado con cobre': 'Zinc bañado en cobre',
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
    'acero cobreado': 'Acero bañado en cobre',
    'acero electrodepositado con cobre': 'Acero bañado en cobre',
    'acero bañado en níquel': 'Acero bañado en níquel',
    'nickel-plated steel': 'Acero bañado en níquel',
    'acero niquelado': 'Acero bañado en níquel',
    'acero electrodepositado con níquel': 'Acero bañado en níquel',
    'acero bañado en latón': 'Acero bañado en latón',
    'brass-plated steel': 'Acero bañado en latón',
    'acero latonado': 'Acero bañado en latón',
    'acero electrodepositado con latón': 'Acero bañado en latón',
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
    'papel de algodón': 'Papel de algodón',
    'papel de algodon': 'Papel de algodón',
    'cotton paper': 'Papel de algodón',
    'papel moneda': 'Papel de algodón',
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

  static const List<NumismaticEmissionRuleData> emissionRules = [
    // =========================================================================
    // 1. MÉXICO Y EMISORES HISTÓRICOS MEXICANOS
    // =========================================================================

    // 1.1 Virreinato de Nueva España (1536–1821)
    // Ref General: Banco de México - Historia de la moneda colonial novohispana:
    // https://www.banxico.org.mx/billetes-y-monedas/virreinato-historia-moneda-b.html
    // Ref General: Numista - Colonial Mexico (1535-1821):
    // https://en.numista.com/catalogue/mexico-colonial-1.html
    // Denominación - Modelo / Referencias:
    // - 1/16 Real (Carlos y Juana / Santo Domingo - Cobre): https://en.numista.com/catalogue/pieces107875.html
    // - 1/8 Real (Tlaco colonial - Cobre): https://en.numista.com/catalogue/pieces61783.html
    // - 1/4 Real (Cuartilla virreinal Carlos IV / Fernando VII - Plata): https://en.numista.com/catalogue/pieces28701.html
    // - 1/2 Real (Columnario / Busto Carlos III, Carlos IV, Fernando VII - Plata): https://en.numista.com/catalogue/pieces15053.html
    // - 1 Real (Columnario / Busto Carlos III, Carlos IV, Fernando VII - Plata): https://en.numista.com/catalogue/pieces13158.html
    // - 2 Reales (Columnario / Busto Carlos III, Carlos IV, Fernando VII - Plata): https://en.numista.com/catalogue/pieces14995.html
    // - 4 Reales (Tostón novohispano - Plata): https://en.numista.com/catalogue/pieces15061.html
    // - 8 Reales (Real de a ocho / Columnaria / Spanish Milled Dollar - Plata): https://en.numista.com/catalogue/pieces15058.html
    NumismaticEmissionRuleData(
      country: 'Virreinato de Nueva España',
      minYear: 1536,
      maxYear: 1821,
      validCurrencies: ['MXR', 'REAL', 'MXE', 'ESC', 'MRV'],
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
      denominationAllowedMaterials: {
        '1/4': ['Plata', 'Cobre'],
      },
    ),

    // 1.2 Primer Imperio Mexicano - Agustín de Iturbide (1822–1823)
    // Ref General: Numista - First Mexican Empire (1821-1823):
    // https://en.numista.com/catalogue/mexico-first-empire-1.html
    // Ref General: Banco de México - Monedas del Primer Imperio:
    // https://www.banxico.org.mx/billetes-y-monedas/primer-imperio-mexicano.html
    // Denominación - Modelo / Referencias:
    // - 1/8 Real (Octavo de Real Cobre - Iturbide): https://en.numista.com/catalogue/pieces64024.html
    // - 1/4 Real (Cuartilla Cobre - Iturbide): https://en.numista.com/catalogue/pieces54972.html
    // - 1/2 Real (Medio Real Plata - Agustín de Iturbide): https://en.numista.com/catalogue/pieces23398.html
    // - 1 Real (1 Real Plata - Agustín de Iturbide): https://en.numista.com/catalogue/pieces23397.html
    // - 2 Reales (2 Reales Plata - Agustín de Iturbide): https://en.numista.com/catalogue/pieces23396.html
    // - 4 Escudos (4 Escudos Oro - Agustín de Iturbide): https://en.numista.com/catalogue/pieces115318.html
    // - 8 Reales (8 Reales Plata - Agustín de Iturbide 1er y 2do Tipo): https://en.numista.com/catalogue/pieces15057.html
    NumismaticEmissionRuleData(
      country: 'Imperio Mexicano (Primer y Segundo Imperio)',
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
      denominationAllowedMaterials: {
        '4': ['Oro', 'Plata'],
        '8': ['Plata', 'Oro'],
      },
    ),

    // 1.3 Segundo Imperio Mexicano - Cobres Provisionales (1864–1865)
    // Ref General: Numista - Second Mexican Empire (1864-1867):
    // https://en.numista.com/catalogue/mexico-second-empire-1.html
    // Ref General: Banco de México - Monedas del Segundo Imperio:
    // https://www.banxico.org.mx/billetes-y-monedas/segundo-imperio-mexicano.html
    // Denominación - Modelo / Referencias:
    // - 0.01 Peso (1 Centavo Cobre Provisional - Águila Imperial / Corona): https://en.numista.com/catalogue/pieces64023.html
    NumismaticEmissionRuleData(
      country: 'Imperio Mexicano (Primer y Segundo Imperio)',
      minYear: 1864,
      maxYear: 1865,
      validCurrencies: ['MXP', 'MXR'],
      defaultCurrency: 'MXP',
      denominations: ['0.01'],
      denominationMaterials: {
        '0.01': 'Cobre',
      },
    ),

    // 1.4 Segundo Imperio Mexicano - Serie Decimal Maximiliano (1866–1867)
    // Ref General: Numista - Second Mexican Empire (1864-1867):
    // https://en.numista.com/catalogue/mexico-second-empire-1.html
    // Ref General: Banco de México - Monedas del Segundo Imperio:
    // https://www.banxico.org.mx/billetes-y-monedas/segundo-imperio-mexicano.html
    // Denominación - Modelo / Referencias:
    // - 0.01 Peso (1 Centavo Cobre - Maximiliano): https://en.numista.com/catalogue/pieces64023.html
    // - 0.05 Peso (5 Centavos Plata Ley .9027 - Maximiliano): https://en.numista.com/catalogue/pieces28704.html
    // - 0.10 Peso (10 Centavos Plata Ley .9027 - Maximiliano): https://en.numista.com/catalogue/pieces28705.html
    // - 0.50 Peso (50 Centavos Plata Ley .9027 - Maximiliano): https://en.numista.com/catalogue/pieces18451.html
    // - 1 Peso (1 Peso Plata Ley .9027 - Maximiliano Emperador): https://en.numista.com/catalogue/pieces7383.html
    // - 20 Pesos (20 Pesos Oro Ley .875 - Maximiliano Emperador): https://en.numista.com/catalogue/pieces31499.html
    NumismaticEmissionRuleData(
      country: 'Imperio Mexicano (Primer y Segundo Imperio)',
      minYear: 1866,
      maxYear: 1867,
      validCurrencies: ['MXP', 'MXR'],
      defaultCurrency: 'MXP',
      denominations: ['0.01', '0.05', '0.10', '0.50', '1', '20'],
      denominationMaterials: {
        '0.01': 'Cobre',
        '0.05': 'Plata',
        '0.10': 'Plata',
        '0.50': 'Plata',
        '1': 'Plata',
        '20': 'Oro',
      },
    ),

    // 1.5 México - Período Virreinal novohispano (1536–1821)
    // Ref: Banco de México - Virreinato de la Nueva España: https://www.banxico.org.mx/billetes-y-monedas/virreinato-historia-moneda-b.html
    // Ref: Numista - Mexico Colonial: https://en.numista.com/catalogue/mexico-colonial-1.html
    // Denominación - Modelo / Referencias:
    // - 1/16, 1/8 Real (Cobre - Pilares y Tlacos): https://en.numista.com/catalogue/pieces107875.html
    // - 1/4, 1/2, 1, 2, 4, 8 Reales (Plata Ley .9027 - Columnarias y Busto Real): https://en.numista.com/catalogue/pieces15058.html
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
      denominationAllowedMaterials: {
        '1/4': ['Plata', 'Cobre'],
      },
    ),

    // 1.6 México - Primer Imperio (1822–1823)
    // Ref: Banco de México - Primer Imperio Mexicano: https://www.banxico.org.mx/billetes-y-monedas/primer-imperio-mexicano.html
    // Ref: Numista - First Mexican Empire: https://en.numista.com/catalogue/mexico-first-empire-1.html
    // Denominación - Modelo / Referencias:
    // - 1/8, 1/4 Real (Cobre - Iturbide): https://en.numista.com/catalogue/pieces64024.html
    // - 1/2, 1, 2, 8 Reales (Plata - Agustín de Iturbide): https://en.numista.com/catalogue/pieces15057.html
    // - 4 Escudos (Oro - Agustín de Iturbide): https://en.numista.com/catalogue/pieces115318.html
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
      denominationAllowedMaterials: {
        '4': ['Oro', 'Plata'],
        '8': ['Plata', 'Oro'],
      },
    ),

    // 1.7 México - Primera República y República Centralista (1823–1863)
    // Ref General: Numista - Mexican Republic - First Republic (1823-1863):
    // https://en.numista.com/catalogue/mexico-first-republic-1.html
    // Ref General: Banco de México - Sistema de reales republicanos (Águila de Perfil y Resplandor):
    // https://www.banxico.org.mx/billetes-y-monedas/primeras-emisiones-republican.html
    // Denominación - Modelo / Referencias:
    // - 1/16 Real (Tlaco / Medio Octavo Cobre): https://en.numista.com/catalogue/pieces54974.html
    // - 1/8 Real (Octavo de Real Cobre - Departamental / República): https://en.numista.com/catalogue/pieces54973.html
    // - 1/4 Real (Cuartilla Cobre / Plata): https://en.numista.com/catalogue/pieces23395.html
    // - 1/2 Real (Plata Ley .9027 - Águila de Perfil / Gorro Frigio): https://en.numista.com/catalogue/pieces15054.html
    // - 1 Real (Plata Ley .9027 - Águila Republicana): https://en.numista.com/catalogue/pieces13159.html
    // - 2 Reales (Plata Ley .9027 - Resplandor): https://en.numista.com/catalogue/pieces14996.html
    // - 4 Reales (Plata Ley .9027 - Resplandor): https://en.numista.com/catalogue/pieces15062.html
    // - 8 Reales (Plata Ley .9027 - Águila de Frente / Resplandor): https://en.numista.com/catalogue/pieces7380.html
    NumismaticEmissionRuleData(
      country: 'México',
      minYear: 1823,
      maxYear: 1863,
      validCurrencies: ['MXR', 'MXE'],
      defaultCurrency: 'MXR',
      denominations: ['1/16', '1/8', '1/4', '1/2', '1', '2', '4', '8'],
      denominationMaterials: {
        '1/16': 'Cobre',
        '1/8': 'Cobre',
        '1/4': 'Cobre',
        '1/2': 'Plata',
        '1': 'Plata',
        '2': 'Plata',
        '4': 'Plata',
        '8': 'Plata',
      },
      denominationAllowedMaterials: {
        '1/4': ['Cobre', 'Plata'],
      },
    ),

    // 1.8 México - Segundo Imperio Cobres (1864–1865)
    // Ref: Banco de México - Segundo Imperio: https://www.banxico.org.mx/billetes-y-monedas/segundo-imperio-mexicano.html
    // Ref: Numista - Second Mexican Empire: https://en.numista.com/catalogue/mexico-second-empire-1.html
    // Denominación - Modelo / Referencias:
    // - 0.01 Peso (1 Centavo Cobre - Águila Imperial): https://en.numista.com/catalogue/pieces64023.html
    NumismaticEmissionRuleData(
      country: 'México',
      minYear: 1864,
      maxYear: 1865,
      validCurrencies: ['MXP', 'MXR'],
      defaultCurrency: 'MXP',
      denominations: ['0.01'],
      denominationMaterials: {
        '0.01': 'Cobre',
      },
    ),

    // 1.9 México - Segundo Imperio Serie Maximiliano Decimal (1866–1867)
    // Ref: Banco de México - Segundo Imperio: https://www.banxico.org.mx/billetes-y-monedas/segundo-imperio-mexicano.html
    // Ref: Numista - Second Mexican Empire: https://en.numista.com/catalogue/mexico-second-empire-1.html
    // Denominación - Modelo / Referencias:
    // - 0.01 Peso (1 Centavo Cobre): https://en.numista.com/catalogue/pieces64023.html
    // - 0.05, 0.10, 0.50, 1 Peso (Plata Ley .9027 - Maximiliano): https://en.numista.com/catalogue/pieces7383.html
    // - 20 Pesos (20 Pesos Oro Ley .875 - Maximiliano): https://en.numista.com/catalogue/pieces31499.html
    NumismaticEmissionRuleData(
      country: 'México',
      minYear: 1866,
      maxYear: 1867,
      validCurrencies: ['MXP', 'MXR'],
      defaultCurrency: 'MXP',
      denominations: ['0.01', '0.05', '0.10', '0.50', '1', '20'],
      denominationMaterials: {
        '0.01': 'Cobre',
        '0.05': 'Plata',
        '0.10': 'Plata',
        '0.50': 'Plata',
        '1': 'Plata',
        '20': 'Oro',
      },
    ),

    // 1.10 México - República Restaurada Sistema Balanza Decimal (1868–1881)
    // Ref General: Numista - Republic of Mexico - Decimal Pesos (1868-1905):
    // https://en.numista.com/catalogue/mexico-republic-decimal-1.html
    // Ref General: Banco de México - Historia del Peso Decimal:
    // https://www.banxico.org.mx/billetes-y-monedas/republica-restaurada-porfiri.html
    // Denominación - Modelo / Referencias:
    // - 0.01 Peso (1 Centavo Cobre Balanza): https://en.numista.com/catalogue/pieces15063.html
    // - 0.02 Peso (2 Centavos Cobre Balanza): https://en.numista.com/catalogue/pieces54975.html
    // - 0.05 Peso (5 Centavos Plata Ley .9027 Balanza): https://en.numista.com/catalogue/pieces18452.html
    // - 0.10 Peso (10 Centavos Plata Ley .9027 Balanza): https://en.numista.com/catalogue/pieces18453.html
    // - 0.25 Peso (25 Centavos Plata Ley .9027 Balanza): https://en.numista.com/catalogue/pieces18454.html
    // - 0.50 Peso (50 Centavos Plata Ley .9027 Balanza): https://en.numista.com/catalogue/pieces18455.html
    // - 1 Peso (1 Peso Plata Ley .9027 Balanza y Espada): https://en.numista.com/catalogue/pieces15059.html
    // - 2.5, 5, 10, 20 Pesos (Oro Ley .875 Balanza): https://en.numista.com/catalogue/pieces18456.html
    // - 8 Reales (Plata Ley .9027 Resplandor en circulación concurrente): https://en.numista.com/catalogue/pieces7380.html
    NumismaticEmissionRuleData(
      country: 'México',
      minYear: 1868,
      maxYear: 1881,
      validCurrencies: ['MXP', 'MXE', 'MXR'],
      defaultCurrency: 'MXP',
      denominations: ['0.01', '0.02', '0.05', '0.10', '0.25', '0.50', '1', '2.5', '5', '10', '20', '8'],
      denominationMaterials: {
        '0.01': 'Cobre',
        '0.02': 'Cobre',
        '0.05': 'Plata',
        '0.10': 'Plata',
        '0.25': 'Plata',
        '0.50': 'Plata',
        '1': 'Plata',
        '2.5': 'Oro',
        '5': 'Oro',
        '10': 'Oro',
        '20': 'Oro',
        '8': 'Plata',
      },
    ),

    // 1.11 México - Crisis del Níquel (1882–1883)
    // Ref: Banco de México - Crisis de las monedas de níquel:
    // https://www.banxico.org.mx/billetes-y-monedas/republica-restaurada-porfiri.html
    // Ref: Numista - Mexico 1882-1883 Nickel Coinage:
    // https://en.numista.com/catalogue/mexico-republic-decimal-1.html
    // Denominación - Modelo / Referencias:
    // - 0.01, 0.02, 0.05 Peso (Níquel / Cuproníquel - Gobierno de Manuel González): https://en.numista.com/catalogue/pieces15064.html
    // - 0.10, 0.25, 0.50, 1 Peso, 8 Reales (Plata Ley .9027 Resplandor): https://en.numista.com/catalogue/pieces7380.html
    // - 2.5, 5, 10, 20 Pesos (Oro Ley .875): https://en.numista.com/catalogue/pieces18456.html
    NumismaticEmissionRuleData(
      country: 'México',
      minYear: 1882,
      maxYear: 1883,
      validCurrencies: ['MXP', 'MXE', 'MXR'],
      defaultCurrency: 'MXP',
      denominations: ['0.01', '0.02', '0.05', '0.10', '0.25', '0.50', '1', '2.5', '5', '10', '20', '8'],
      denominationMaterials: {
        '0.01': 'Níquel',
        '0.02': 'Níquel',
        '0.05': 'Níquel',
        '0.10': 'Plata',
        '0.25': 'Plata',
        '0.50': 'Plata',
        '1': 'Plata',
        '2.5': 'Oro',
        '5': 'Oro',
        '10': 'Oro',
        '20': 'Oro',
        '8': 'Plata',
      },
      denominationAllowedMaterials: {
        '0.01': ['Níquel', 'Cuproníquel'],
        '0.02': ['Níquel', 'Cuproníquel'],
        '0.05': ['Níquel', 'Cuproníquel'],
      },
    ),

    // 1.12 México - Porfiriato Decimal Resplandor (1884–1904)
    // Ref General: Numista - Republic of Mexico - Decimal Pesos (1868-1905):
    // https://en.numista.com/catalogue/mexico-republic-decimal-1.html
    // Ref General: Banco de México - Historia del Peso Decimal:
    // https://www.banxico.org.mx/billetes-y-monedas/republica-restaurada-porfiri.html
    // Denominación - Modelo / Referencias:
    // - 0.01, 0.02 Peso (Cobre - Porfiriato): https://en.numista.com/catalogue/pieces15065.html
    // - 0.05, 0.10, 0.20, 0.25, 0.50 Peso (Plata Ley .9027 Resplandor): https://en.numista.com/catalogue/pieces18457.html
    // - 1 Peso (Un Peso Fuerte Porfiriano Plata Ley .9027): https://en.numista.com/catalogue/pieces15060.html
    // - 8 Reales (Plata Ley .9027 acuñada hasta 1897): https://en.numista.com/catalogue/pieces7380.html
    // - 2.5, 5, 10, 20 Pesos (Oro Ley .875): https://en.numista.com/catalogue/pieces18456.html
    NumismaticEmissionRuleData(
      country: 'México',
      minYear: 1884,
      maxYear: 1904,
      validCurrencies: ['MXP', 'MXE', 'MXR'],
      defaultCurrency: 'MXP',
      denominations: ['0.01', '0.02', '0.05', '0.10', '0.20', '0.25', '0.50', '1', '2.5', '5', '10', '20', '8'],
      denominationMaterials: {
        '0.01': 'Cobre',
        '0.02': 'Cobre',
        '0.05': 'Plata',
        '0.10': 'Plata',
        '0.20': 'Plata',
        '0.25': 'Plata',
        '0.50': 'Plata',
        '1': 'Plata',
        '2.5': 'Oro',
        '5': 'Oro',
        '10': 'Oro',
        '20': 'Oro',
        '8': 'Plata',
      },
    ),

    // 1.13 México - Reforma Monetaria Porfiriana de 1905 (1905–1914)
    // Ref General: Numista - United Mexican States (1905-1969):
    // https://en.numista.com/catalogue/mexico-united-states-1905-1.html
    // Ref General: Banco de México - Monedas de plata y oro del siglo XX:
    // https://www.banxico.org.mx/billetes-y-monedas/monedas-plata-oro-siglo-xx.html
    // Denominación - Modelo / Referencias:
    // - 0.01, 0.02 Peso (Bronce monograma Estados Unidos Mexicanos): https://en.numista.com/catalogue/pieces3820.html
    // - 0.05 Peso (Cuproníquel monograma y calendario azteca): https://en.numista.com/catalogue/pieces3822.html
    // - 0.10, 0.20, 0.50 Peso (Plata Ley .800 Gorro Frigio): https://en.numista.com/catalogue/pieces3823.html
    // - 1 Peso (Un Peso Caballito Plata Ley .9027 - Centenario de la Independencia 1910-1914): https://en.numista.com/catalogue/pieces3826.html
    // - 5, 10 Pesos (Oro Ley .900 Miguel Hidalgo): https://en.numista.com/catalogue/pieces15066.html
    NumismaticEmissionRuleData(
      country: 'México',
      minYear: 1905,
      maxYear: 1914,
      validCurrencies: ['MXP'],
      defaultCurrency: 'MXP',
      denominations: ['0.01', '0.02', '0.05', '0.10', '0.20', '0.50', '1', '5', '10'],
      denominationMaterials: {
        '0.01': 'Bronce',
        '0.02': 'Bronce',
        '0.05': 'Cuproníquel',
        '0.10': 'Plata',
        '0.20': 'Plata',
        '0.50': 'Plata',
        '1': 'Plata',
        '5': 'Oro',
        '10': 'Oro',
      },
      commemorativeDenominations: {'1'},
      commemorativeMotifsByDenomination: {
        '1': [
          'Un Peso Caballito - Centenario de la Independencia (1910-1914)',
          'Pesos Caballito',
        ],
      },
      commemorativeReasons: [
        'Un Peso Caballito - Centenario de la Independencia (1910-1914)',
      ],
    ),

    // 1.14 México - Período Revolucionario / Constitucionalista (1915–1919)
    // Ref: Banco de México - Monedas de la Revolución Mexicana:
    // https://www.banxico.org.mx/billetes-y-monedas/revolucion-mexicana-monedas.html
    // Ref: Numista - United Mexican States (1905-1969):
    // https://en.numista.com/catalogue/mexico-united-states-1905-1.html
    // Denominación - Modelo / Referencias:
    // - 0.01, 0.02, 0.05 Peso (Bronce Constitucionalista): https://en.numista.com/catalogue/pieces3821.html
    // - 0.10, 0.20, 0.50 Peso (Plata Ley .800 / .720 transición): https://en.numista.com/catalogue/pieces3824.html
    // - 1 Peso (Plata Resplandor / Múgica / Hidalgo): https://en.numista.com/catalogue/pieces3827.html
    // - 2, 2.5, 5, 10, 20 Pesos (Oro Ley .900 Hidalgo y Calendario Azteca de Oro 20 Pesos 1917): https://en.numista.com/catalogue/pieces15067.html
    NumismaticEmissionRuleData(
      country: 'México',
      minYear: 1915,
      maxYear: 1919,
      validCurrencies: ['MXP'],
      defaultCurrency: 'MXP',
      denominations: ['0.01', '0.02', '0.05', '0.10', '0.20', '0.50', '1', '2', '2.5', '5', '10', '20'],
      denominationMaterials: {
        '0.01': 'Bronce',
        '0.02': 'Bronce',
        '0.05': 'Bronce',
        '0.10': 'Plata',
        '0.20': 'Plata',
        '0.50': 'Plata',
        '1': 'Plata',
        '2': 'Oro',
        '2.5': 'Oro',
        '5': 'Oro',
        '10': 'Oro',
        '20': 'Oro',
      },
    ),

    // 1.15 México - Ley .720 y Centenario de Oro (1920–1942)
    // Ref General: Banco de México - Monedas de plata y oro del siglo XX:
    // https://www.banxico.org.mx/billetes-y-monedas/monedas-plata-oro-siglo-xx.html
    // Ref General: Numista - United Mexican States (1905-1969):
    // https://en.numista.com/catalogue/mexico-united-states-1905-1.html
    // Denominación - Modelo / Referencias:
    // - 0.01, 0.02 Peso (Bronce monograma): https://en.numista.com/catalogue/pieces3820.html
    // - 0.05 Peso (Josefa Ortiz de Domínguez Blanca Cuproníquel 1936-1942): https://en.numista.com/catalogue/pieces3825.html
    // - 0.10, 0.20, 0.50 Peso (Plata Ley .720 Resplandor): https://en.numista.com/catalogue/pieces3828.html
    // - 1 Peso (Un Peso Resplandor Plata Ley .720 / Victoria Alada 1921 Centenario): https://en.numista.com/catalogue/pieces3829.html
    // - 2, 2.5, 5, 10, 20 Pesos (Oro Ley .900 Hidalgo y Calendario Azteca): https://en.numista.com/catalogue/pieces15067.html
    // - 50 Pesos (Centenario de Oro 50 Pesos 37.5g Oro Puro Ley .900 - 1921-1931, 1943-1947): https://en.numista.com/catalogue/pieces15068.html
    NumismaticEmissionRuleData(
      country: 'México',
      minYear: 1920,
      maxYear: 1942,
      validCurrencies: ['MXP'],
      defaultCurrency: 'MXP',
      denominations: ['0.01', '0.02', '0.05', '0.10', '0.20', '0.50', '1', '2', '2.5', '5', '10', '20', '50'],
      denominationMaterials: {
        '0.01': 'Bronce',
        '0.02': 'Bronce',
        '0.05': 'Cuproníquel',
        '0.10': 'Plata',
        '0.20': 'Plata',
        '0.50': 'Plata',
        '1': 'Plata',
        '2': 'Oro',
        '2.5': 'Oro',
        '5': 'Oro',
        '10': 'Oro',
        '20': 'Oro',
        '50': 'Oro',
      },
      commemorativeDenominations: {'1', '50'},
      commemorativeMotifsByDenomination: {
        '1': [
          'Victoria Alada - Centenario de la Consumación de la Independencia (1921)',
          'Dos Pesos Centenario (1921)',
        ],
        '50': [
          'Centenario de Oro 50 Pesos (1921-1931)',
          'Centenario de Oro 50 Pesos',
        ],
      },
      commemorativeReasons: [
        'Centenario de la Consumación de la Independencia (1921)',
        'Centenario de Oro 50 Pesos (1921-1931)',
      ],
    ),

    // 1.16 México - Segunda Guerra y Postguerra (1943–1949)
    // Ref General: Banco de México - Monedas de plata y oro del siglo XX:
    // https://www.banxico.org.mx/billetes-y-monedas/monedas-plata-oro-siglo-xx.html
    // Ref General: Numista - United Mexican States (1905-1969):
    // https://en.numista.com/catalogue/mexico-united-states-1905-1.html
    // Denominación - Modelo / Referencias:
    // - 0.01 Peso (Bronce Espigas): https://en.numista.com/catalogue/pieces3820.html
    // - 0.05 Peso (Josefa Ortiz de Domínguez Bronce grande 1942-1955): https://en.numista.com/catalogue/pieces3830.html
    // - 0.20 Peso (Pirámide de Teotihuacán Bronce 1943-1955): https://en.numista.com/catalogue/pieces3831.html
    // - 0.50 Peso (Cuauhtémoc Plata Ley .420 - 1947-1948): https://en.numista.com/catalogue/pieces3832.html
    // - 1 Peso (Morelos Cachetón Plata Ley .500 - 1947-1949): https://en.numista.com/catalogue/pieces1105.html
    // - 2, 2.5 Pesos (Oro Ley .900 reacuñaciones): https://en.numista.com/catalogue/pieces15067.html
    // - 5 Pesos (Cuauhtémoc Plata Ley .900 - 1947-1948): https://en.numista.com/catalogue/pieces3834.html
    // - 50 Pesos (Centenario de Oro reacuñaciones 1943-1947): https://en.numista.com/catalogue/pieces15068.html
    NumismaticEmissionRuleData(
      country: 'México',
      minYear: 1943,
      maxYear: 1949,
      validCurrencies: ['MXP'],
      defaultCurrency: 'MXP',
      denominations: ['0.01', '0.05', '0.20', '0.50', '1', '2', '2.5', '5', '50'],
      denominationMaterials: {
        '0.01': 'Bronce',
        '0.05': 'Bronce',
        '0.20': 'Bronce',
        '0.50': 'Plata',
        '1': 'Plata',
        '2': 'Oro',
        '2.5': 'Oro',
        '5': 'Plata',
        '50': 'Oro',
      },
      commemorativeDenominations: {'5'},
      commemorativeMotifsByDenomination: {
        '5': [
          'Cuauhtémoc Plata Ley .900 (1947-1948)',
        ],
      },
      commemorativeReasons: [
        'Cuauhtémoc Plata Ley .900 (1947-1948)',
      ],
    ),

    // 1.17 México - Década de 1950 (1950–1956)
    // Ref General: Banco de México - Monedas de plata y oro del siglo XX:
    // https://www.banxico.org.mx/billetes-y-monedas/monedas-plata-oro-siglo-xx.html
    // Ref General: Numista - United Mexican States (1905-1969):
    // https://en.numista.com/catalogue/mexico-united-states-1905-1.html
    // Denominación - Modelo / Referencias:
    // - 0.01 Peso (Bronce): https://en.numista.com/catalogue/pieces3820.html
    // - 0.05 Peso (Josefa Latón): https://en.numista.com/catalogue/pieces3830.html
    // - 0.10 Peso (Hidalgo Perfil Latón 1955-1957): https://en.numista.com/catalogue/pieces3835.html
    // - 0.20 Peso (Pirámide Teotihuacán Bronce): https://en.numista.com/catalogue/pieces3831.html
    // - 0.25 Peso (Balanza Cuproníquel 1950-1953): https://en.numista.com/catalogue/pieces3836.html
    // - 0.50 Peso (Cuauhtémoc Bronce 1955-1959): https://en.numista.com/catalogue/pieces3837.html
    // - 1 Peso (Morelos Perfil Plata Ley .300 - 1950): https://en.numista.com/catalogue/pieces3838.html
    // - 5 Pesos (Hidalgo Laurel Plata Ley .720 / Ferrocarril del Sureste 1950 / Hidalgo 1953): https://en.numista.com/catalogue/pieces3839.html
    // - 10 Pesos (Hidalgo Plata Ley .900 - 1955-1956): https://en.numista.com/catalogue/pieces3840.html
    NumismaticEmissionRuleData(
      country: 'México',
      minYear: 1950,
      maxYear: 1956,
      validCurrencies: ['MXP'],
      defaultCurrency: 'MXP',
      denominations: ['0.01', '0.05', '0.10', '0.20', '0.25', '0.50', '1', '5', '10'],
      denominationMaterials: {
        '0.01': 'Bronce',
        '0.05': 'Latón',
        '0.10': 'Latón',
        '0.20': 'Bronce',
        '0.25': 'Cuproníquel',
        '0.50': 'Bronce',
        '1': 'Plata',
        '5': 'Plata',
        '10': 'Plata',
      },
      commemorativeDenominations: {'5'},
      commemorativeMotifsByDenomination: {
        '5': [
          'Inauguración del Ferrocarril del Sureste (1950)',
          'Bicentenario del Natalicio de Miguel Hidalgo y Costilla (1953)',
        ],
      },
      commemorativeReasons: [
        'Inauguración del Ferrocarril del Sureste (1950)',
        'Bicentenario del Natalicio de Miguel Hidalgo y Costilla (1953)',
      ],
    ),

    // 1.18 México - Período de los Tepalcates y Conmemorativas (1957–1969)
    // Ref General: Banco de México - Monedas de plata y oro del siglo XX:
    // https://www.banxico.org.mx/billetes-y-monedas/monedas-plata-oro-siglo-xx.html
    // Ref General: Numista - United Mexican States (1905-1969):
    // https://en.numista.com/catalogue/mexico-united-states-1905-1.html
    // Denominación - Modelo / Referencias:
    // - 0.01 Peso (Bronce Espigas): https://en.numista.com/catalogue/pieces3820.html
    // - 0.05 Peso (Josefa Perfil Latón 1954-1969): https://en.numista.com/catalogue/pieces3830.html
    // - 0.10 Peso (Hidalgo Perfil Latón 1957-1967): https://en.numista.com/catalogue/pieces3835.html
    // - 0.20 Peso (Pirámide Teotihuacán Bronce 1955-1971): https://en.numista.com/catalogue/pieces3831.html
    // - 0.50 Peso (Cuauhtémoc Cuproníquel 1964-1969): https://en.numista.com/catalogue/pieces3832.html
    // - 1 Peso (Morelos Tepalcate Plata Ley .100 - 1957-1967): https://en.numista.com/catalogue/pieces1105.html
    // - 5 Pesos (Carranza 1959 Plata Ley .720 / Sesquicentenario 1960 Plata Ley .720): https://en.numista.com/catalogue/pieces3841.html
    // - 10 Pesos (Constitución 1957 Plata Ley .900 / Sesquicentenario 1960 Plata Ley .900): https://en.numista.com/catalogue/pieces3842.html
    // - 25 Pesos (Juegos Olímpicos México 68 Plata Ley .720 - Aros Rectos y Aros Caídos): https://en.numista.com/catalogue/pieces3843.html
    NumismaticEmissionRuleData(
      country: 'México',
      minYear: 1957,
      maxYear: 1969,
      validCurrencies: ['MXP'],
      defaultCurrency: 'MXP',
      denominations: ['0.01', '0.05', '0.10', '0.20', '0.50', '1', '5', '10', '25'],
      denominationMaterials: {
        '0.01': 'Bronce',
        '0.05': 'Latón',
        '0.10': 'Latón',
        '0.20': 'Bronce',
        '0.50': 'Cuproníquel',
        '1': 'Plata',
        '5': 'Plata',
        '10': 'Plata',
        '25': 'Plata',
      },
      commemorativeDenominations: {'5', '10', '25'},
      commemorativeMotifsByDenomination: {
        '5': [
          'Centenario del Natalicio de Venustiano Carranza (1959)',
          'Sesquicentenario de la Independencia (1960)',
        ],
        '10': [
          'Centenario de la Constitución de 1857 (1957)',
          'Sesquicentenario de la Independencia (1960)',
        ],
        '25': [
          'Juegos Olímpicos México 68 (1968)',
          'Juegos Olímpicos México 68 - Aros Caídos (1968)',
          'Juegos Olímpicos México 68 - Aros Rectos (1968)',
        ],
      },
      commemorativeReasons: [
        'Centenario de la Constitución de 1857',
        'Centenario del Natalicio de Venustiano Carranza',
        'Sesquicentenario de la Independencia',
        'Juegos Olímpicos México 68',
      ],
    ),

    // 1.19 México - Transición Pirámide de Bronce y Monedas de Cuproníquel (1970–1973)
    // Ref General: Banco de México - Monedas metálicas desmonetizadas de la unidad anterior:
    // https://www.banxico.org.mx/billetes-y-monedas/monedas-desmonetizadas-unida.html
    // Ref General: Numista - Mexico (1970-1992):
    // https://en.numista.com/catalogue/mexico-united-states-1905-2.html
    // Denominación - Modelo / Referencias:
    // - 0.05 Peso (Josefa Ortiz de Domínguez Latón): https://en.numista.com/catalogue/pieces3830.html
    // - 0.20 Peso (Pirámide de Teotihuacán Bronce): https://en.numista.com/catalogue/pieces3831.html
    // - 0.50 Peso (Cuauhtémoc Cuproníquel): https://en.numista.com/catalogue/pieces3832.html
    // - 1 Peso (José María Morelos Cuproníquel 1970-1983): https://en.numista.com/catalogue/pieces1105.html
    // - 5 Pesos (Vicente Guerrero Cuproníquel 1971-1978): https://en.numista.com/catalogue/pieces3384.html
    NumismaticEmissionRuleData(
      country: 'México',
      minYear: 1970,
      maxYear: 1973,
      validCurrencies: ['MXP'],
      defaultCurrency: 'MXP',
      denominations: ['0.05', '0.20', '0.50', '1', '5'],
      denominationMaterials: {
        '0.05': 'Latón',
        '0.20': 'Bronce',
        '0.50': 'Cuproníquel',
        '1': 'Cuproníquel',
        '5': 'Cuproníquel',
      },
    ),

    // 1.20 México - Serie Numismática Cuproníquel, Latón y Plata (1974–1983)
    // Ref General: Banco de México - Monedas metálicas desmonetizadas de la unidad anterior:
    // https://www.banxico.org.mx/billetes-y-monedas/monedas-desmonetizadas-unida.html
    // Ref General: Numista - Mexico (1970-1992):
    // https://en.numista.com/catalogue/mexico-united-states-1905-2.html
    // Denominación - Modelo / Referencias:
    // - 0.05 Peso (Josefa Ortiz de Domínguez Cabeza Grande Latón 1974-1976): https://en.numista.com/catalogue/pieces3830.html
    // - 0.10 Peso (Mazorca de Maíz Cuproníquel 1974-1980): https://en.numista.com/catalogue/pieces3844.html
    // - 0.20 Peso (Francisco I. Madero Latón 1974-1983): https://en.numista.com/catalogue/pieces3845.html
    // - 0.50 Peso (Cuauhtémoc Cuproníquel): https://en.numista.com/catalogue/pieces3832.html
    // - 1 Peso (José María Morelos Cuproníquel): https://en.numista.com/catalogue/pieces1105.html
    // - 5 Pesos (Vicente Guerrero 1971-1978 / Quetzalcóatl 1980-1985 Cuproníquel): https://en.numista.com/catalogue/pieces3384.html
    // - 10 Pesos (Miguel Hidalgo Heptagonal Cuproníquel 1974-1985): https://en.numista.com/catalogue/pieces3846.html
    // - 20 Pesos (José María Morelos / Jugador de Pelota Cuproníquel 1980-1984): https://en.numista.com/catalogue/pieces3847.html
    // - 50 Pesos (Coyolxauhqui Diosa Azteca de la Luna Cuproníquel 1982-1984): https://en.numista.com/catalogue/pieces3848.html
    // - 100 Pesos (José María Morelos Plata Ley .720 - 1977-1979): https://en.numista.com/catalogue/pieces3849.html
    NumismaticEmissionRuleData(
      country: 'México',
      minYear: 1974,
      maxYear: 1983,
      validCurrencies: ['MXP'],
      defaultCurrency: 'MXP',
      denominations: ['0.05', '0.10', '0.20', '0.50', '1', '5', '10', '20', '50', '100'],
      denominationMaterials: {
        '0.05': 'Latón',
        '0.10': 'Cuproníquel',
        '0.20': 'Latón',
        '0.50': 'Cuproníquel',
        '1': 'Cuproníquel',
        '5': 'Cuproníquel',
        '10': 'Cuproníquel',
        '20': 'Cuproníquel',
        '50': 'Cuproníquel',
        '100': 'Plata',
      },
      commemorativeDenominations: {'100'},
      commemorativeMotifsByDenomination: {
        '100': [
          'Morelos Plata Ley .720 (1977-1979)',
          'José María Morelos Plata Ley .720 (1977-1979)',
        ],
      },
      commemorativeReasons: ['Morelos Plata Ley .720 (1977-1979)'],
    ),

    // 1.21 México - Acero Inoxidable, Latón y Valores Medios (1984–1987)
    // Ref General: Banco de México - Monedas metálicas desmonetizadas:
    // https://www.banxico.org.mx/billetes-y-monedas/monedas-desmonetizadas-unida.html
    // Denominación - Modelo / Referencias:
    // - 1 Peso (José María Morelos Acero inoxidable 1984-1987): https://en.numista.com/catalogue/pieces3850.html
    // - 5 Pesos (Vicente Guerrero / Nueve Lados Latón 1985-1988): https://en.numista.com/catalogue/pieces3851.html
    // - 10 Pesos (Miguel Hidalgo Acero inoxidable 1985-1990): https://en.numista.com/catalogue/pieces3852.html
    // - 20 Pesos (Guadalupe Victoria Latón 1985-1990): https://en.numista.com/catalogue/pieces3853.html
    // - 50 Pesos (Benito Juárez Cuproníquel 1984-1988): https://en.numista.com/catalogue/pieces3854.html
    // - 100 Pesos (Venustiano Carranza Bronce de aluminio 1984-1992): https://en.numista.com/catalogue/pieces3855.html
    // - 200 Pesos (Conmemorativas Cuproníquel 1985-1986): https://en.numista.com/catalogue/pieces3856.html
    // - 500 Pesos (Francisco I. Madero Cuproníquel 1986-1992): https://en.numista.com/catalogue/pieces3857.html
    NumismaticEmissionRuleData(
      country: 'México',
      minYear: 1984,
      maxYear: 1987,
      validCurrencies: ['MXP'],
      defaultCurrency: 'MXP',
      denominations: ['1', '5', '10', '20', '50', '100', '200', '500'],
      denominationMaterials: {
        '1': 'Acero inoxidable',
        '5': 'Latón',
        '10': 'Acero inoxidable',
        '20': 'Latón',
        '50': 'Cuproníquel',
        '100': 'Bronce de aluminio',
        '200': 'Cuproníquel',
        '500': 'Cuproníquel',
      },
      commemorativeDenominations: {'200'},
      commemorativeMotifsByDenomination: {
        '200': [
          '175 Aniversario de la Independencia',
          '175 Aniversario de la Independencia (1985)',
          '75 Aniversario de la Revolución',
          '75 Aniversario de la Revolución (1985)',
          'Copa Mundial de la FIFA México 1986',
          'Copa Mundial FIFA México 86 (1986)',
          'Copa Mundial FIFA México 86',
        ],
      },
      commemorativeReasons: [
        '175 Aniversario de la Independencia',
        '75 Aniversario de la Revolución',
        'Copa Mundial FIFA México 86',
        'Copa Mundial de la FIFA México 1986',
      ],
    ),

    // 1.22 México - Grandes Valores de Inflación Pre-N$ (1988–1992)
    // Ref General: Banco de México - Monedas metálicas desmonetizadas:
    // https://www.banxico.org.mx/billetes-y-monedas/monedas-desmonetizadas-unida.html
    // Denominación - Modelo / Referencias:
    // - 10 Pesos (Miguel Hidalgo Acero inoxidable): https://en.numista.com/catalogue/pieces3852.html
    // - 20 Pesos (Guadalupe Victoria Latón): https://en.numista.com/catalogue/pieces3853.html
    // - 50 Pesos (Benito Juárez Acero inoxidable / Cuproníquel 1988-1992): https://en.numista.com/catalogue/pieces3854.html
    // - 100 Pesos (Venustiano Carranza Bronce de aluminio): https://en.numista.com/catalogue/pieces3855.html
    // - 500 Pesos (Francisco I. Madero Cuproníquel): https://en.numista.com/catalogue/pieces3857.html
    // - 1000 Pesos (Sor Juana Inés de la Cruz Bronce de aluminio 1988-1992): https://en.numista.com/catalogue/pieces3858.html
    // - 5000 Pesos (Cincuentenario de la Expropiación Petrolera Cuproníquel 1988): https://en.numista.com/catalogue/pieces3859.html
    NumismaticEmissionRuleData(
      country: 'México',
      minYear: 1988,
      maxYear: 1992,
      validCurrencies: ['MXP'],
      defaultCurrency: 'MXP',
      denominations: ['10', '20', '50', '100', '500', '1000', '5000'],
      denominationMaterials: {
        '10': 'Acero inoxidable',
        '20': 'Latón',
        '50': 'Acero inoxidable',
        '100': 'Bronce de aluminio',
        '500': 'Cuproníquel',
        '1000': 'Bronce de aluminio',
        '5000': 'Cuproníquel',
      },
      denominationAllowedMaterials: {
        '50': ['Cuproníquel', 'Acero inoxidable'],
      },
      commemorativeDenominations: {'5000'},
      commemorativeMotifsByDenomination: {
        '5000': [
          'Cincuentenario de la Expropiación Petrolera (1988)',
          '50 Aniversario de la Expropiación Petrolera (1988)',
          'Expropiación Petrolera (1988)',
        ],
      },
      commemorativeReasons: [
        'Cincuentenario de la Expropiación Petrolera (1988)',
      ],
    ),

    // 1.23 México - Nuevos Pesos (N$ grabados físicamente 1992–1995)
    // Ref General: Banco de México - Familia B (Nuevos Pesos en proceso de retiro):
    // https://www.banxico.org.mx/billetes-y-monedas/familia-b-proceso-retiro-ban.html
    // Ref General: Numista - Mexico Nuevos Pesos (1992-1995):
    // https://en.numista.com/catalogue/mexico-united-states-1905-3.html
    // Denominación - Modelo / Referencias:
    // - 0.05 Peso (N$ 0.05 Acero inoxidable - Rayos solares): https://en.numista.com/catalogue/pieces3860.html
    // - 0.10 Peso (N$ 0.10 Acero inoxidable - Piedra del Sol): https://en.numista.com/catalogue/pieces3861.html
    // - 0.20 Peso (N$ 0.20 Bronce de aluminio - Piedra del Sol): https://en.numista.com/catalogue/pieces3862.html
    // - 0.50 Peso (N$ 0.50 Bronce de aluminio - Piedra del Sol): https://en.numista.com/catalogue/pieces3863.html
    // - 1 Peso (N$ 1 Bimetálica Anillo Acero / Centro Bronce-Aluminio): https://en.numista.com/catalogue/pieces3864.html
    // - 2 Pesos (N$ 2 Bimetálica Anillo Acero / Centro Bronce-Aluminio): https://en.numista.com/catalogue/pieces3865.html
    // - 5 Pesos (N$ 5 Bimetálica Anillo Acero / Centro Bronce-Aluminio): https://en.numista.com/catalogue/pieces3866.html
    // - 10 Pesos (N$ 10 Bimetálica Centro Plata Sterling .925 / Anillo Bronce-Aluminio): https://en.numista.com/catalogue/pieces3867.html
    // - 20 Pesos (N$ 20 Miguel Hidalgo Bimetálica Centro Plata Sterling .925 - 1993-1995): https://en.numista.com/catalogue/pieces3868.html
    // - 50 Pesos (N$ 50 Niños Héroes Bimetálica Centro Plata Sterling .925 - 1993-1995): https://en.numista.com/catalogue/pieces3869.html
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
        '1': 'Bimetálica',
        '2': 'Bimetálica',
        '5': 'Bimetálica',
        '10': 'Bimetálica',
        '20': 'Bimetálica',
        '50': 'Bimetálica',
      },
    ),

    // 1.24 México - Familia C Primer Período (1996–2007)
    // Ref General: Banco de México - Familia C en circulación:
    // https://www.banxico.org.mx/billetes-y-monedas/familia-c-circulacion-banco-m.html
    // Ref General: Numista - Mexico Modern Pesos (1996-date):
    // https://en.numista.com/catalogue/mexico-united-states-1905-4.html
    // Denominación - Modelo / Referencias:
    // - 0.05 Peso (5 Centavos Acero inoxidable): https://en.numista.com/catalogue/pieces3860.html
    // - 0.10, 0.20, 0.50 Peso (Piedra del Sol): https://en.numista.com/catalogue/pieces3861.html
    // - 1, 2, 5 Pesos (Bimetálicas estándar de circulación): https://en.numista.com/catalogue/pieces3864.html
    // - 10 Pesos (Piedra del Sol Tonatiuh Cuproníquel / Bronce-Aluminio 1997+): https://en.numista.com/catalogue/pieces3870.html
    // - 20 Pesos (Familia C Conmemorativas Bimetálicas): https://www.banxico.org.mx/billetes-y-monedas/monedas-20-pesos-familia-c.html
    // - 100 Pesos (Familia C Bimetálicas Centro de Plata .925): https://www.banxico.org.mx/billetes-y-monedas/monedas-100-pesos-conmemorati.html
    NumismaticEmissionRuleData(
      country: 'México',
      minYear: 1996,
      maxYear: 2007,
      validCurrencies: ['MXN'],
      defaultCurrency: 'MXN',
      denominations: ['0.05', '0.10', '0.20', '0.50', '1', '2', '5', '10', '20', '100'],
      denominationMaterials: {
        '0.05': 'Acero inoxidable',
        '0.10': 'Acero inoxidable',
        '0.20': 'Bronce de aluminio',
        '0.50': 'Bronce de aluminio',
        '1': 'Bimetálica',
        '2': 'Bimetálica',
        '5': 'Bimetálica',
        '10': 'Bimetálica',
        '20': 'Bimetálica',
        '100': 'Bimetálica',
      },
      commemorativeDenominations: {'20', '100'},
      commemorativeMotifsByDenomination: {
        '20': [
          'Octavio Paz - Cambio de Milenio (2000)',
          'Fuego Nuevo - Señorío de Xiuhtecuhtli (2000)',
          'Octavio Paz - Cambio de Milenio',
          'Fuego Nuevo - Señorío de Xiuhtecuhtli',
        ],
        '100': [
          '32 Estados de la República (Fase 1 y Fase 2)',
          '32 Estados de la República - Fase 1 (Heráldicos)',
          '32 Estados de la República - Fase 2 (Emblemáticos)',
          '470 Aniversario de la Casa de Moneda de México (2005)',
          '80 Aniversario del Banco de México (2005)',
          '400 Aniversario de Don Quijote de la Mancha (2005)',
          '400 Aniversario de la Primera Edición de Don Quijote de la Mancha (2005)',
          'Bicentenario del Natalicio de Benito Juárez (2006)',
          '180 Aniversario de la Unión Federal (2004)',
        ],
      },
      commemorativeReasons: [
        'Octavio Paz - Cambio de Milenio',
        'Fuego Nuevo - Señorío de Xiuhtecuhtli',
        '32 Estados de la República',
        '470 Aniversario de la Casa de Moneda de México',
        '80 Aniversario del Banco de México',
        '400 Aniversario de Don Quijote de la Mancha',
        'Bicentenario del Natalicio de Benito Juárez',
        '180 Aniversario de la Unión Federal',
      ],
    ),

    // 1.25 México - Familia C Bicentenario y Centenario (2008–2010)
    // Ref General: Banco de México - Monedas de 5 pesos conmemorativas:
    // https://www.banxico.org.mx/billetes-y-monedas/monedas-5-pesos-conmemorativ.html
    // Ref General: Banco de México - Monedas de 20 pesos Familia C:
    // https://www.banxico.org.mx/billetes-y-monedas/monedas-20-pesos-familia-c.html
    // Denominación - Modelo / Referencias:
    // - 0.05, 0.10, 0.20, 0.50, 1, 2, 10 Pesos (Familia C estándar): https://www.banxico.org.mx/billetes-y-monedas/familia-c-circulacion-banco-m.html
    // - 5 Pesos (37 Monedas Bicentenario de la Independencia y Centenario de la Revolución): https://www.banxico.org.mx/billetes-y-monedas/monedas-5-pesos-conmemorativ.html
    // - 20 Pesos (Octavio Paz Premio Nobel de Literatura 2010): https://www.banxico.org.mx/billetes-y-monedas/monedas-20-pesos-familia-c.html
    NumismaticEmissionRuleData(
      country: 'México',
      minYear: 2008,
      maxYear: 2010,
      validCurrencies: ['MXN'],
      defaultCurrency: 'MXN',
      denominations: ['0.05', '0.10', '0.20', '0.50', '1', '2', '5', '10', '20'],
      denominationMaterials: {
        '0.05': 'Acero inoxidable',
        '0.10': 'Acero inoxidable',
        '0.20': 'Bronce de aluminio',
        '0.50': 'Bronce de aluminio',
        '1': 'Bimetálica',
        '2': 'Bimetálica',
        '5': 'Bimetálica',
        '10': 'Bimetálica',
        '20': 'Bimetálica',
      },
      commemorativeDenominations: {'5', '20'},
      commemorativeMotifsByDenomination: {
        '5': [
          'Ignacio López Rayón',
          'Francisco Xavier Mina',
          'Mariano Matamoros',
          'Carlos María de Bustamante',
          'Hermenegildo Galeana',
          'José María Cos',
          'Pedro Moreno',
          'Agustín de Iturbide',
          'Servando Teresa de Mier',
          'Nicolás Bravo',
          'Leona Vicario',
          'Miguel Hidalgo y Costilla',
          'José María Morelos y Pavón',
          'Vicente Guerrero',
          'Ignacio Allende',
          'Guadalupe Victoria',
          'Josefa Ortiz de Domínguez',
          'Francisco Primo de Verdad y Ramos',
          'Álvaro Obregón',
          'José Vasconcelos',
          'Francisco Villa',
          'Heriberto Jara',
          'Ricardo Flores Magón',
          'Francisco J. Múgica',
          'Filomeno Mata',
          'Carmen Serdán',
          'Andrés Molina Enríquez',
          'Luis Cabrera',
          'Eulalio Gutiérrez',
          'Otilio Montaño',
          'Belisario Domínguez',
          'Francisco I. Madero',
          'Emiliano Zapata',
          'Venustiano Carranza',
          'La Soldadera (Adelita)',
          'José María Pino Suárez',
        ],
        '20': [
          'Octavio Paz - Premio Nobel de Literatura (2010)',
          'Octavio Paz - Premio Nobel de Literatura',
        ],
      },
      commemorativeReasons: [
        'Bicentenario de la Independencia de México (1810-2010)',
        'Centenario de la Revolución Mexicana (1910-2010)',
        'Octavio Paz - Premio Nobel de Literatura (2010)',
      ],
    ),

    // 1.26 México - Familia C Fraccionarias Acero Inoxidable (2011–2019)
    // Ref General: Banco de México - Monedas conmemorativas de 20 pesos Familia C:
    // https://www.banxico.org.mx/billetes-y-monedas/monedas-20-pesos-conmemorati.html
    // Ref General: Banco de México - Monedas fraccionarias de acero inoxidable:
    // https://www.banxico.org.mx/billetes-y-monedas/familia-c-circulacion-banco-m.html
    // Denominación - Modelo / Referencias:
    // - 0.10, 0.20, 0.50 Peso (Acero inoxidable): https://www.banxico.org.mx/billetes-y-monedas/familia-c-circulacion-banco-m.html
    // - 1, 2, 5, 10 Pesos (Bimetálicas estándar): https://www.banxico.org.mx/billetes-y-monedas/familia-c-circulacion-banco-m.html
    // - 20 Pesos (Familia C Conmemorativas Bimetálicas circulares): https://www.banxico.org.mx/billetes-y-monedas/monedas-20-pesos-familia-c.html
    NumismaticEmissionRuleData(
      country: 'México',
      minYear: 2011,
      maxYear: 2019,
      validCurrencies: ['MXN'],
      defaultCurrency: 'MXN',
      denominations: ['0.10', '0.20', '0.50', '1', '2', '5', '10', '20'],
      denominationMaterials: {
        '0.10': 'Acero inoxidable',
        '0.20': 'Acero inoxidable',
        '0.50': 'Acero inoxidable',
        '1': 'Bimetálica',
        '2': 'Bimetálica',
        '5': 'Bimetálica',
        '10': 'Bimetálica',
        '20': 'Bimetálica',
      },
      commemorativeDenominations: {'20'},
      commemorativeMotifsByDenomination: {
        '20': [
          'Centenario del Ejército Mexicano (2013)',
          '150 Aniversario del Natalicio de Belisario Domínguez (2013)',
          '150 Aniversario del Natalicio y 100 Aniversario Luctuoso de Belisario Domínguez (2013)',
          'Centenario de la Gesta Heroica de Veracruz (2014)',
          'Centenario de la Toma de Zacatecas (2014)',
          'Centenario de la Fuerza Aérea Mexicana (2015)',
          'Bicentenario Luctuoso de José María Morelos y Pavón (2015)',
          'Bicentenario Luctuoso del Generalísimo José María Morelos y Pavón (2015)',
          'Quincuagésimo Aniversario del Plan DN-III-E (2016)',
          'Cincuenta Aniversario del Plan DN-III-E (2016)',
          'Centenario de la Constitución Política (2017)',
          'Centenario de la Constitución Política de los Estados Unidos Mexicanos (2017)',
          '50 Aniversario del Plan Marina (2018)',
          'Cincuenta Aniversario de la Aplicación del Plan Marina (2018)',
          '500 Años de la Fundación de la Ciudad y Puerto de Veracruz (2019)',
          'Centenario de la Muerte del General Emiliano Zapata (2019)',
          'Centenario de la Muerte del General Emiliano Zapata Salazar (2019)',
        ],
      },
      commemorativeReasons: [
        'Centenario del Ejército Mexicano (2013)',
        '150 Aniversario de Belisario Domínguez (2013)',
        'Centenario de la Gesta Heroica de Veracruz (2014)',
        'Centenario de la Toma de Zacatecas (2014)',
        'Centenario de la Fuerza Aérea Mexicana (2015)',
        'Bicentenario Luctuoso de Morelos (2015)',
        'Plan DN-III-E (2016)',
        'Centenario de la Constitución (2017)',
        'Plan Marina (2018)',
        '500 Años del Puerto de Veracruz (2019)',
        'Emiliano Zapata (2019)',
      ],
    ),

    // 1.27 México - Familia C1 Dodecagonal (2020–presente)
    // Ref General: Banco de México - Monedas de 20 pesos conmemorativas Familia C1:
    // https://www.banxico.org.mx/billetes-y-monedas/monedas-20-pesos-conmemorati.html
    // Denominación - Modelo / Referencias:
    // - 0.10, 0.20, 0.50 Peso (Acero inoxidable): https://www.banxico.org.mx/billetes-y-monedas/familia-c-circulacion-banco-m.html
    // - 1, 2, 5, 10 Pesos (Bimetálicas): https://www.banxico.org.mx/billetes-y-monedas/familia-c-circulacion-banco-m.html
    // - 20 Pesos (Familia C1 Bimetálica de 12 Lados / Dodecagonal): https://www.banxico.org.mx/billetes-y-monedas/monedas-20-pesos-conmemorati.html
    NumismaticEmissionRuleData(
      country: 'México',
      minYear: 2020,
      maxYear: 2100,
      validCurrencies: ['MXN'],
      defaultCurrency: 'MXN',
      denominations: ['0.10', '0.20', '0.50', '1', '2', '5', '10', '20'],
      denominationMaterials: {
        '0.10': 'Acero inoxidable',
        '0.20': 'Acero inoxidable',
        '0.50': 'Acero inoxidable',
        '1': 'Bimetálica',
        '2': 'Bimetálica',
        '5': 'Bimetálica',
        '10': 'Bimetálica',
        '20': 'Bimetálica',
      },
      commemorativeDenominations: {'20'},
      commemorativeMotifsByDenomination: {
        '20': [
          '700 Años de la Fundación Lunar de México-Tenochtitlan',
          '700 Años de la Fundación Lunar de la Ciudad de México-Tenochtitlan (2021)',
          '700 Años de la Fundación Lunar de México-Tenochtitlan (2021)',
          '500 Años de Memoria Histórica de México-Tenochtitlan',
          '500 Años de Memoria Histórica de México-Tenochtitlan (2021)',
          'Bicentenario de la Independencia Nacional',
          'Bicentenario de la Independencia Nacional (2021)',
          'Cien Años de la Llegada de los Menonitas a México (2022)',
          'Llegada de los Menonitas a México (2022)',
          'Bicentenario de la Marina-Armada de México (2022)',
          'Bicentenario de la Marina-Armada (2022)',
          'Bicentenario del Heroico Colegio Militar (2023)',
          'Bicentenario del Heroico Colegio Militar',
          'Doscientos Años de Relaciones Diplomáticas México-Estados Unidos (2023)',
          'Doscientos Años de Relaciones Diplomáticas entre los Estados Unidos Mexicanos y los Estados Unidos de América (2023)',
          '500 Años de la Fundación de la Primera Villa de Colima (2023)',
          '500 Años de la Fundación de la Villa de Colima (2023)',
          'Villa de Colima (2023)',
          'Bicentenario de la Instauración del Senado de la República (2024)',
          'Bicentenario de la Instauración del Senado de la República y Sesquicentenario de su Restauración (2024)',
          'Cien Años del Heroico Batallón de Marina (2024)',
          'Cien Años del Heroico Batallón de Infantería de Marina (2024)',
        ],
      },
      commemorativeReasons: [
        'Fundación Lunar de Tenochtitlan (2021)',
        'Memoria Histórica de Tenochtitlan (2021)',
        'Bicentenario de la Independencia (2021)',
        'Llegada de los Menonitas a México (2022)',
        'Bicentenario de la Marina-Armada (2022)',
        'Bicentenario del Heroico Colegio Militar (2023)',
        'Relaciones Diplomáticas México-EE.UU. (2023)',
        'Villa de Colima (2023)',
        'Instauración del Senado de la República (2024)',
        'Heroico Batallón de Infantería de Marina (2024)',
      ],
    ),

    // =========================================================================
    // 2. ESTADOS UNIDOS DE AMÉRICA
    // =========================================================================

    // 2.1 Estados Unidos - Período Continental y Pre-Federal (1775–1791)
    // Ref General: Numista - United States - Pre-Federal (1776-1791):
    // https://en.numista.com/catalogue/united-states-pre-federal-1.html
    // Ref General: US Mint - History of the US Mint:
    // https://www.usmint.gov/learn/history/overview-history-of-the-us-mint
    // Denominación - Modelo / Referencias:
    // - 0.01 Dollar (Fugio Cent 1787 - Cobre): https://en.numista.com/catalogue/pieces23018.html | https://www.usmint.gov/learn/history/historical-coin-specifications
    // - 1 Dollar (Continental Dollar 1776 - Plata / Peltre): https://en.numista.com/catalogue/pieces23017.html
    // - 8 Reales (Spanish Milled Dollar / 8 Reales de curso legal en EE.UU. - Plata): https://en.numista.com/catalogue/pieces15058.html
    NumismaticEmissionRuleData(
      country: 'Estados Unidos',
      minYear: 1775,
      maxYear: 1791,
      validCurrencies: ['USC', 'USD'],
      defaultCurrency: 'USC',
      denominations: ['0.01', '1', '8'],
      denominationMaterials: {
        '0.01': 'Cobre',
        '1': 'Plata',
        '8': 'Plata',
      },
    ),

    // 2.2 Estados Unidos - Large Cent, Half Cent y Plata/Oro Clásica (1792–1857)
    // Ref General: US Mint - Historical Coin Specifications:
    // https://www.usmint.gov/learn/history/historical-coin-specifications
    // Ref General: Numista - United States - Federal Republic (1792-1964):
    // https://en.numista.com/catalogue/united-states-1.html
    // Denominación - Modelo / Referencias:
    // - 0.005 Dollar (Half Cent - Cobre puro): https://en.numista.com/catalogue/pieces1124.html
    // - 0.01 Dollar (Large Cent - Cobre puro Flowing Hair / Draped Bust / Coronet / Braided Hair): https://en.numista.com/catalogue/pieces1123.html
    // - 0.05 Dollar (Half Dime - Plata Ley .8924 / .900 Flowing Hair / Draped Bust / Capped Bust / Seated Liberty): https://en.numista.com/catalogue/pieces4314.html
    // - 0.10 Dollar (Dime - Plata Ley .8924 / .900 Draped Bust / Capped Bust / Seated Liberty): https://en.numista.com/catalogue/pieces4315.html
    // - 0.25 Dollar (Quarter Dollar - Plata Ley .8924 / .900 Draped Bust / Capped Bust / Seated Liberty): https://en.numista.com/catalogue/pieces4316.html
    // - 0.50 Dollar (Half Dollar - Plata Ley .8924 / .900 Flowing Hair / Draped Bust / Capped Bust / Seated Liberty): https://en.numista.com/catalogue/pieces4317.html
    // - 1 Dollar (Silver Dollar - Plata Ley .8924 / .900 Flowing Hair / Draped Bust / Gobrecht / Seated Liberty): https://en.numista.com/catalogue/pieces4318.html
    // - 2.5, 5, 10, 20 Dollars (Quarter Eagle, Half Eagle, Eagle, Double Eagle - Oro Ley .9167 / .900): https://en.numista.com/catalogue/pieces4319.html
    NumismaticEmissionRuleData(
      country: 'Estados Unidos',
      minYear: 1792,
      maxYear: 1857,
      validCurrencies: ['USD'],
      defaultCurrency: 'USD',
      denominations: ['0.005', '0.01', '0.05', '0.10', '0.25', '0.50', '1', '2.5', '5', '10', '20'],
      denominationMaterials: {
        '0.005': 'Cobre',
        '0.01': 'Cobre',
        '0.05': 'Plata',
        '0.10': 'Plata',
        '0.25': 'Plata',
        '0.50': 'Plata',
        '1': 'Plata',
        '2.5': 'Oro',
        '5': 'Oro',
        '10': 'Oro',
        '20': 'Oro',
      },
    ),

    // 2.3 Estados Unidos - Small Cent, Guerra Civil y Nuevas Denominaciones (1858–1873)
    // Ref General: Numista - United States - Federal Republic (1792-1964):
    // https://en.numista.com/catalogue/united-states-1.html
    // Denominación - Modelo / Referencias:
    // - 0.01 Dollar (Flying Eagle / Indian Head Cent - Cuproníquel 1856-1864, Bronce 1864+): https://en.numista.com/catalogue/pieces1125.html
    // - 0.02 Dollar (Two Cents Bronce 1864-1873): https://en.numista.com/catalogue/pieces1126.html
    // - 0.03 Dollar (Three Cents Plata / Cuproníquel 1851-1889): https://en.numista.com/catalogue/pieces1127.html
    // - 0.05 Dollar (Shield Nickel Cuproníquel 1866-1883 / Half Dime Plata): https://en.numista.com/catalogue/pieces1128.html
    // - 0.10, 0.25, 0.50, 1 Dollar (Seated Liberty Plata Ley .900): https://en.numista.com/catalogue/pieces4316.html
    // - 2.5, 3, 5, 10, 20 Dollars (Coronet Head / Indian Princess Oro Ley .900): https://en.numista.com/catalogue/pieces4319.html
    NumismaticEmissionRuleData(
      country: 'Estados Unidos',
      minYear: 1858,
      maxYear: 1873,
      validCurrencies: ['USD'],
      defaultCurrency: 'USD',
      denominations: ['0.01', '0.02', '0.03', '0.05', '0.10', '0.25', '0.50', '1', '2.5', '3', '5', '10', '20'],
      denominationMaterials: {
        '0.01': 'Bronce',
        '0.02': 'Bronce',
        '0.03': 'Cuproníquel',
        '0.05': 'Cuproníquel',
        '0.10': 'Plata',
        '0.25': 'Plata',
        '0.50': 'Plata',
        '1': 'Plata',
        '2.5': 'Oro',
        '3': 'Oro',
        '5': 'Oro',
        '10': 'Oro',
        '20': 'Oro',
      },
      denominationAllowedMaterials: {
        '0.01': ['Bronce', 'Cuproníquel'],
        '0.03': ['Cuproníquel', 'Plata'],
        '0.05': ['Cuproníquel', 'Plata'],
      },
    ),

    // 2.4 Estados Unidos - Era Clásica Morgan/Peace y Oro Saint-Gaudens (1874–1933)
    // Ref General: US Mint - Classic Commemorative Program (1892-1954):
    // https://www.usmint.gov/learn/coin-and-medal-programs/commemorative-coins
    // Ref General: Numista - United States - Federal Republic (1792-1964):
    // https://en.numista.com/catalogue/united-states-1.html
    // Denominación - Modelo / Referencias:
    // - 0.01 Dollar (Indian Head / Lincoln Wheat Cent - Bronce): https://en.numista.com/catalogue/pieces908.html
    // - 0.05 Dollar (Liberty Head V / Buffalo Nickel - Cuproníquel): https://en.numista.com/catalogue/pieces1109.html
    // - 0.10 Dollar (Barber / Mercury Dime - Plata Ley .900): https://en.numista.com/catalogue/pieces51.html
    // - 0.20 Dollar (Twenty Cents Plata Ley .900 - 1875-1878): https://en.numista.com/catalogue/pieces1129.html
    // - 0.25 Dollar (Barber / Standing Liberty Quarter - Plata Ley .900): https://en.numista.com/catalogue/pieces52.html
    // - 0.50 Dollar (Barber / Walking Liberty Half Dollar - Plata Ley .900): https://en.numista.com/catalogue/pieces53.html
    // - 1 Dollar (Morgan Dollar 1878-1921 / Peace Dollar 1921-1935 - Plata Ley .900): https://en.numista.com/catalogue/pieces1492.html
    // - 2.5, 3, 4, 5, 10, 20, 50 Dollars (Indian Head / Saint-Gaudens Double Eagle / Panama-Pacific $50 - Oro Ley .900): https://en.numista.com/catalogue/pieces15069.html
    NumismaticEmissionRuleData(
      country: 'Estados Unidos',
      minYear: 1874,
      maxYear: 1933,
      validCurrencies: ['USD'],
      defaultCurrency: 'USD',
      denominations: [
        '0.01', '0.05', '0.10', '0.20', '0.25', '0.50', '1', '2.5', '3', '4', '5', '10', '20', '50',
      ],
      denominationMaterials: {
        '0.01': 'Bronce',
        '0.05': 'Cuproníquel',
        '0.10': 'Plata',
        '0.20': 'Plata',
        '0.25': 'Plata',
        '0.50': 'Plata',
        '1': 'Plata',
        '2.5': 'Oro',
        '3': 'Oro',
        '4': 'Oro',
        '5': 'Oro',
        '10': 'Oro',
        '20': 'Oro',
        '50': 'Oro',
      },
    ),

    // 2.5 Estados Unidos - Pre-Clad Estándar Plata .900 (1934–1964)
    // Ref General: US Mint - History of the Roosevelt Dime and Washington Quarter:
    // https://www.usmint.gov/learn/coin-and-medal-programs/coin-specifications
    // Denominación - Modelo / Referencias:
    // - 0.01 Dollar (Lincoln Wheat / Memorial Cent - Bronce / Acero cincado 1943): https://en.numista.com/catalogue/pieces908.html
    // - 0.05 Dollar (Jefferson Nickel - Cuproníquel / Plata de guerra 35% Ag 1942-1945): https://en.numista.com/catalogue/pieces44.html
    // - 0.10 Dollar (Mercury / Roosevelt Dime - Plata Ley .900): https://en.numista.com/catalogue/pieces51.html
    // - 0.25 Dollar (Washington Quarter - Plata Ley .900): https://en.numista.com/catalogue/pieces54.html
    // - 0.50 Dollar (Walking Liberty / Franklin / 1964 Kennedy Half Dollar - Plata Ley .900): https://en.numista.com/catalogue/pieces53.html
    NumismaticEmissionRuleData(
      country: 'Estados Unidos',
      minYear: 1934,
      maxYear: 1964,
      validCurrencies: ['USD'],
      defaultCurrency: 'USD',
      denominations: ['0.01', '0.05', '0.10', '0.25', '0.50'],
      denominationMaterials: {
        '0.01': 'Bronce',
        '0.05': 'Cuproníquel',
        '0.10': 'Plata',
        '0.25': 'Plata',
        '0.50': 'Plata',
      },
      denominationAllowedMaterials: {
        '0.01': ['Bronce', 'Acero bañado en zinc', 'Latón'],
        '0.05': ['Cuproníquel', 'Plata'],
      },
    ),

    // 2.6 Estados Unidos - Transición Clad & Kennedy Half Dollar 40% Plata (1965–1970)
    // Ref General: US Mint - Coin Specifications:
    // https://www.usmint.gov/learn/coin-and-medal-programs/coin-specifications
    // Denominación - Modelo / Referencias:
    // - 0.01 Dollar (Lincoln Memorial - Latón / Gilding Metal 95% Cu, 5% Zn sin estaño desde 1962): https://en.numista.com/catalogue/pieces43.html
    // - 0.05 Dollar (Jefferson Nickel - Cuproníquel 75% Cu, 25% Ni): https://en.numista.com/catalogue/pieces44.html
    // - 0.10 Dollar (Roosevelt Dime - Cuproníquel sobre núcleo de cobre): https://en.numista.com/catalogue/pieces55.html
    // - 0.25 Dollar (Washington Quarter - Cuproníquel sobre núcleo de cobre): https://en.numista.com/catalogue/pieces56.html
    // - 0.50 Dollar (Kennedy Half Dollar - Plata 40% / Cuproníquel): https://en.numista.com/catalogue/pieces10857.html
    NumismaticEmissionRuleData(
      country: 'Estados Unidos',
      minYear: 1965,
      maxYear: 1970,
      validCurrencies: ['USD'],
      defaultCurrency: 'USD',
      denominations: ['0.01', '0.05', '0.10', '0.25', '0.50'],
      denominationMaterials: {
        '0.01': 'Latón',
        '0.05': 'Cuproníquel',
        '0.10': 'Cuproníquel',
        '0.25': 'Cuproníquel',
        '0.50': 'Plata',
      },
      denominationAllowedMaterials: {
        '0.50': ['Plata', 'Cuproníquel'],
      },
    ),

    // 2.7 Estados Unidos - Era Clad Cuproníquel y Bicentenario (1971–1981)
    // Ref General: US Mint - Bicentennial Coinage (1776-1976):
    // https://www.usmint.gov/learn/coin-and-medal-programs/coin-specifications
    // Denominación - Modelo / Referencias:
    // - 0.01 Dollar (Lincoln Memorial - Latón rojo / Gilding Metal): https://en.numista.com/catalogue/pieces43.html
    // - 0.05 Dollar (Jefferson Nickel - Cuproníquel): https://en.numista.com/catalogue/pieces44.html
    // - 0.10 Dollar (Roosevelt Dime - Cuproníquel): https://en.numista.com/catalogue/pieces55.html
    // - 0.25 Dollar (Washington Quarter / Bicentennial Drummer Boy 1776-1976 - Cuproníquel): https://en.numista.com/catalogue/pieces57.html
    // - 0.50 Dollar (Kennedy Half Dollar / Bicentennial Independence Hall 1776-1976 - Cuproníquel): https://en.numista.com/catalogue/pieces10858.html
    // - 1 Dollar (Eisenhower Dollar / Bicentennial Moon & Liberty Bell 1776-1976 / Susan B. Anthony 1979-1981 - Cuproníquel): https://en.numista.com/catalogue/pieces1354.html
    NumismaticEmissionRuleData(
      country: 'Estados Unidos',
      minYear: 1971,
      maxYear: 1981,
      validCurrencies: ['USD'],
      defaultCurrency: 'USD',
      denominations: ['0.01', '0.05', '0.10', '0.25', '0.50', '1'],
      denominationMaterials: {
        '0.01': 'Latón',
        '0.05': 'Cuproníquel',
        '0.10': 'Cuproníquel',
        '0.25': 'Cuproníquel',
        '0.50': 'Cuproníquel',
        '1': 'Cuproníquel',
      },
      commemorativeDenominations: {'0.25', '0.50', '1'},
      commemorativeMotifsByDenomination: {
        '0.25': [
          'Bicentennial Drummer Boy (1776-1976)',
          'Bicentennial Quarter (1776-1976)',
        ],
        '0.50': [
          'Bicentennial Independence Hall (1776-1976)',
          'Bicentennial Half Dollar (1776-1976)',
        ],
        '1': [
          'Bicentennial Liberty Bell and Moon (1776-1976)',
          'Eisenhower Dollar (1971-1978)',
          'Susan B. Anthony Dollar (1979-1981)',
        ],
      },
      commemorativeReasons: [
        'Bicentennial Drummer Boy (1776-1976)',
        'Bicentennial Independence Hall (1776-1976)',
        'Bicentennial Liberty Bell and Moon (1776-1976)',
      ],
    ),

    // 2.8 Estados Unidos - Centavos de Zinc y 50 State Quarters (1982–1999)
    // Ref General: US Mint - 50 State Quarters Program:
    // https://www.usmint.gov/learn/coin-and-medal-programs/50-state-quarters
    // Denominación - Modelo / Referencias:
    // - 0.01 Dollar (Lincoln Memorial Zinc bañado en cobre / Copper-plated Zinc 1982+): https://en.numista.com/catalogue/pieces42.html
    // - 0.05 Dollar (Jefferson Nickel - Cuproníquel): https://en.numista.com/catalogue/pieces44.html
    // - 0.10 Dollar (Roosevelt Dime - Cuproníquel): https://en.numista.com/catalogue/pieces55.html
    // - 0.25 Dollar (Washington Quarter / 50 State Quarters 1999: Delaware, Pennsylvania, New Jersey, Georgia, Connecticut): https://en.numista.com/catalogue/pieces58.html
    // - 0.50 Dollar (Kennedy Half Dollar - Cuproníquel): https://en.numista.com/catalogue/pieces10858.html
    // - 1 Dollar (Susan B. Anthony Dollar 1999): https://en.numista.com/catalogue/pieces3548.html
    NumismaticEmissionRuleData(
      country: 'Estados Unidos',
      minYear: 1982,
      maxYear: 1999,
      validCurrencies: ['USD'],
      defaultCurrency: 'USD',
      denominations: ['0.01', '0.05', '0.10', '0.25', '0.50', '1'],
      denominationMaterials: {
        '0.01': 'Zinc bañado en cobre',
        '0.05': 'Cuproníquel',
        '0.10': 'Cuproníquel',
        '0.25': 'Cuproníquel',
        '0.50': 'Cuproníquel',
        '1': 'Cuproníquel',
      },
      denominationAllowedMaterials: {
        '0.01': ['Zinc bañado en cobre', 'Bronce', 'Latón'],
      },
      commemorativeDenominations: {'0.25'},
      commemorativeMotifsByDenomination: {
        '0.25': [
          '50 State Quarters - Delaware (1999)',
          '50 State Quarters - Pennsylvania (1999)',
          '50 State Quarters - New Jersey (1999)',
          '50 State Quarters - Georgia (1999)',
          '50 State Quarters - Connecticut (1999)',
        ],
      },
      commemorativeReasons: [
        '50 State Quarters (1999)',
      ],
    ),

    // 2.9 Estados Unidos - Golden Dollar y Programas Modernos (2000–presente)
    // Ref General: US Mint - Modern Coin Specifications:
    // https://www.usmint.gov/learn/coin-and-medal-programs/coin-specifications
    // Denominación - Modelo / Referencias:
    // - 0.01 Dollar (Lincoln Union Shield / Bicentennial Cents 2009 - Zinc bañado en cobre): https://en.numista.com/catalogue/pieces42.html
    // - 0.05 Dollar (Jefferson Nickel / Westward Journey Series 2004-2005 - Cuproníquel): https://en.numista.com/catalogue/pieces44.html
    // - 0.10 Dollar (Roosevelt Dime - Cuproníquel sobre núcleo de cobre): https://en.numista.com/catalogue/pieces55.html
    // - 0.25 Dollar (50 State Quarters 1999-2008, DC & Territories 2009, America the Beautiful 2010-2021, Washington Crossing Delaware 2021, American Women Quarters 2022-2025): https://www.usmint.gov/learn/coin-and-medal-programs/america-the-beautiful-quarters | https://www.usmint.gov/learn/coin-and-medal-programs/american-women-quarters
    // - 0.50 Dollar (Kennedy Half Dollar - Cuproníquel sobre núcleo de cobre): https://en.numista.com/catalogue/pieces10858.html
    // - 1 Dollar (Sacagawea 2000-2008, Native American 2009+, Presidential $1 2007-2016, 2020, American Innovation 2018+ - Latón de manganeso sobre núcleo de cobre): https://www.usmint.gov/learn/coin-and-medal-programs/presidential-dollar-coin | https://www.usmint.gov/learn/coin-and-medal-programs/american-innovation-dollar-coins
    NumismaticEmissionRuleData(
      country: 'Estados Unidos',
      minYear: 2000,
      maxYear: 2100,
      validCurrencies: ['USD'],
      defaultCurrency: 'USD',
      denominations: ['0.01', '0.05', '0.10', '0.25', '0.50', '1'],
      denominationMaterials: {
        '0.01': 'Zinc bañado en cobre',
        '0.05': 'Cuproníquel',
        '0.10': 'Cuproníquel',
        '0.25': 'Cuproníquel',
        '0.50': 'Cuproníquel',
        '1': 'Latón de manganeso sobre núcleo de cobre',
      },
      denominationAllowedMaterials: {
        '1': [
          'Latón de manganeso sobre núcleo de cobre',
          'Latón de manganeso (Clad)',
          'Latón de manganeso',
          'Latón',
        ],
      },
      commemorativeDenominations: {'0.01', '0.05', '0.25', '1'},
      commemorativeMotifsByDenomination: {
        '0.01': [
          'Lincoln Bicentennial - Birthplace (2009)',
          'Lincoln Bicentennial - Formative Years in Indiana (2009)',
          'Lincoln Bicentennial - Professional Life in Illinois (2009)',
          'Lincoln Bicentennial - Presidency in Washington D.C. (2009)',
          'Lincoln Union Shield (2010+)',
        ],
        '0.05': [
          'Westward Journey - Peace Medal (2004)',
          'Westward Journey - Keelboat (2004)',
          'Westward Journey - American Bison (2005)',
          'Westward Journey - Ocean in View (2005)',
        ],
        '0.25': [
          '50 State Quarters',
          'District of Columbia and U.S. Territories Quarters (2009)',
          'America the Beautiful Quarters',
          'General George Washington Crossing the Delaware (2021)',
          'American Women Quarters',
          'American Women Quarters - Maya Angelou (2022)',
          'American Women Quarters - Dr. Sally Ride (2022)',
          'American Women Quarters - Wilma Mankiller (2022)',
          'American Women Quarters - Nina Otero-Warren (2022)',
          'American Women Quarters - Anna May Wong (2022)',
          'American Women Quarters - Bessie Coleman (2023)',
          'American Women Quarters - Edith Kanakaʻole (2023)',
          'American Women Quarters - Eleanor Roosevelt (2023)',
          'American Women Quarters - Jovita Idár (2023)',
          'American Women Quarters - Maria Tallchief (2023)',
          'American Women Quarters - Rev. Dr. Pauli Murray (2024)',
          'American Women Quarters - Patsy Takemoto Mink (2024)',
          'American Women Quarters - Dr. Mary Edwards Walker (2024)',
          'American Women Quarters - Celia Cruz (2024)',
          'American Women Quarters - Zitkala-Ša (2024)',
        ],
        '1': [
          'Sacagawea / Native American Dollar',
          'Sacagawea Dollar (2000-2008)',
          'Native American Dollar',
          'Presidential Dollar',
          'Presidential Dollar - George Washington (2007)',
          'Presidential Dollar - John Adams (2007)',
          'Presidential Dollar - Thomas Jefferson (2007)',
          'Presidential Dollar - James Madison (2007)',
          'Presidential Dollar - James Monroe (2008)',
          'Presidential Dollar - John Quincy Adams (2008)',
          'Presidential Dollar - Andrew Jackson (2008)',
          'Presidential Dollar - Martin Van Buren (2008)',
          'Presidential Dollar - William Henry Harrison (2009)',
          'Presidential Dollar - John Tyler (2009)',
          'Presidential Dollar - James K. Polk (2009)',
          'Presidential Dollar - Zachary Taylor (2009)',
          'Presidential Dollar - Millard Fillmore (2010)',
          'Presidential Dollar - Franklin Pierce (2010)',
          'Presidential Dollar - James Buchanan (2010)',
          'Presidential Dollar - Abraham Lincoln (2010)',
          'Presidential Dollar - Andrew Johnson (2011)',
          'Presidential Dollar - Ulysses S. Grant (2011)',
          'Presidential Dollar - Rutherford B. Hayes (2011)',
          'Presidential Dollar - James A. Garfield (2011)',
          'Presidential Dollar - Chester A. Arthur (2012)',
          'Presidential Dollar - Grover Cleveland - 1st Term (2012)',
          'Presidential Dollar - Benjamin Harrison (2012)',
          'Presidential Dollar - Grover Cleveland - 2nd Term (2012)',
          'Presidential Dollar - William McKinley (2013)',
          'Presidential Dollar - Theodore Roosevelt (2013)',
          'Presidential Dollar - William Howard Taft (2013)',
          'Presidential Dollar - Woodrow Wilson (2013)',
          'Presidential Dollar - Warren G. Harding (2014)',
          'Presidential Dollar - Calvin Coolidge (2014)',
          'Presidential Dollar - Herbert Hoover (2014)',
          'Presidential Dollar - Franklin D. Roosevelt (2014)',
          'Presidential Dollar - Harry S. Truman (2015)',
          'Presidential Dollar - Dwight D. Eisenhower (2015)',
          'Presidential Dollar - John F. Kennedy (2015)',
          'Presidential Dollar - Lyndon B. Johnson (2015)',
          'Presidential Dollar - Richard M. Nixon (2016)',
          'Presidential Dollar - Gerald R. Ford (2016)',
          'Presidential Dollar - Ronald Reagan (2016)',
          'Presidential Dollar - George H.W. Bush (2020)',
          'American Innovation Dollar',
        ],
      },
      commemorativeReasons: [
        '50 State Quarters',
        'America the Beautiful Quarters',
        'American Women Quarters',
        'Sacagawea / Native American Dollar',
        'Presidential Dollar',
        'American Innovation Dollar',
      ],
    ),

    // =========================================================================
    // 3. ESPAÑA Y UNIÓN EUROPEA
    // =========================================================================

    // 3.1 España - Antiguo Régimen y Monarquía Hispánica (1500–1868)
    // Ref General: Real Casa de la Moneda - FNMT Historia: https://www.fnmt.es/museo/historia
    // Ref General: Numista - Spain - Real (1497-1833): https://en.numista.com/catalogue/spain-1.html
    // Ref General: Numista - Spain - Escudo & Decimal (1833-1868): https://en.numista.com/catalogue/spain-2.html
    // Denominación - Modelo / Referencias:
    // - 1/16, 1/8 Real (Maravedís de Cobre / Ochavo / Cuarto): https://en.numista.com/catalogue/pieces28706.html
    // - 1/4, 1/2, 1, 2, 4, 8 Reales (Plata Ley .9027 / .833): https://en.numista.com/catalogue/pieces15070.html
    NumismaticEmissionRuleData(
      country: 'España',
      minYear: 1500,
      maxYear: 1868,
      validCurrencies: ['REAL', 'ESC', 'MRV', 'RDV'],
      defaultCurrency: 'REAL',
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
      denominationAllowedMaterials: {
        '1/4': ['Plata', 'Cobre'],
      },
    ),

    // 3.2 España - Peseta Clásica (1869–1939)
    // Ref General: Banco de España - Billetes y monedas en pesetas:
    // https://www.bde.es/wbe/es/para-ciudadanos/billetes-y-monedas/pesetas/
    // Ref General: Numista - Spain - Peseta (1868-2001):
    // https://en.numista.com/catalogue/spain-peseta-1.html
    // Denominación - Modelo / Referencias:
    // - 0.01, 0.02, 0.05, 0.10 Peseta (Bronce - Matrona / Leones / Alfonso XII / Alfonso XIII): https://en.numista.com/catalogue/pieces1880.html
    // - 0.25 Peseta (Cuproníquel con taladro 1927 / 1937 II República): https://en.numista.com/catalogue/pieces1881.html
    // - 0.50, 1, 2, 5 Pesetas (Plata Ley .835 / .900): https://en.numista.com/catalogue/pieces1882.html
    // - 10, 20, 25, 100 Pesetas (Oro Ley .900): https://en.numista.com/catalogue/pieces15071.html
    NumismaticEmissionRuleData(
      country: 'España',
      minYear: 1869,
      maxYear: 1939,
      validCurrencies: ['ESP'],
      defaultCurrency: 'ESP',
      denominations: [
        '0.01', '0.02', '0.05', '0.10', '0.25', '0.50', '1', '2', '5', '10', '20', '25', '100',
      ],
      denominationMaterials: {
        '0.01': 'Bronce',
        '0.02': 'Bronce',
        '0.05': 'Bronce',
        '0.10': 'Bronce',
        '0.25': 'Cuproníquel',
        '0.50': 'Plata',
        '1': 'Plata',
        '2': 'Plata',
        '5': 'Plata',
        '10': 'Oro',
        '20': 'Oro',
        '25': 'Oro',
        '100': 'Oro',
      },
    ),

    // 3.3 España - Peseta del Estado Español y Transición (1940–1981)
    // Ref General: Banco de España - Monedas de Franco y Juan Carlos I:
    // https://www.bde.es/wbe/es/para-ciudadanos/billetes-y-monedas/pesetas/
    // Denominación - Modelo / Referencias:
    // - 0.05, 0.10 Peseta (Aluminio - Jinete / Ancla): https://en.numista.com/catalogue/pieces1880.html
    // - 0.50 Peseta (Cuproníquel con orificio central): https://en.numista.com/catalogue/pieces1881.html
    // - 1, 2.5 Pesetas (Rubia / Bronce de aluminio): https://en.numista.com/catalogue/pieces785.html
    // - 5, 25, 50 Pesetas (Cuproníquel - Franco / Juan Carlos I): https://en.numista.com/catalogue/pieces1883.html
    // - 100 Pesetas (Franco 1966 Plata Ley .800 / Juan Carlos I 1975): https://en.numista.com/catalogue/pieces3152.html
    NumismaticEmissionRuleData(
      country: 'España',
      minYear: 1940,
      maxYear: 1981,
      validCurrencies: ['ESP'],
      defaultCurrency: 'ESP',
      denominations: ['0.05', '0.10', '0.50', '1', '2.5', '5', '25', '50', '100'],
      denominationMaterials: {
        '0.05': 'Aluminio',
        '0.10': 'Aluminio',
        '0.50': 'Cuproníquel',
        '1': 'Bronce de aluminio',
        '2.5': 'Bronce de aluminio',
        '5': 'Cuproníquel',
        '25': 'Cuproníquel',
        '50': 'Cuproníquel',
        '100': 'Plata',
      },
      denominationAllowedMaterials: {
        '100': ['Plata', 'Cuproníquel'],
      },
      commemorativeDenominations: {'100'},
      commemorativeMotifsByDenomination: {
        '100': [
          '100 Pesetas Franco Plata .800 (1966)',
          '100 Pesetas Juan Carlos I (1975)',
        ],
      },
      defaultCommemorativeReason: 'Conmemorativa',
    ),

    // 3.4 España - Peseta Moderna y Monedas Autonómicas (1982–2001)
    // Ref General: Real Casa de la Moneda - FNMT Series de Pesetas:
    // https://www.fnmt.es/museo/historia
    // Denominación - Modelo / Referencias:
    // - 0.10, 0.50, 1, 2 Pesetas (Aluminio): https://en.numista.com/catalogue/pieces1880.html
    // - 5, 25, 100, 500 Pesetas (Bronce de aluminio / Serie Autonómica de 25 Ptas con agujero): https://en.numista.com/catalogue/pieces1884.html
    // - 10, 50, 200 Pesetas (Cuproníquel): https://en.numista.com/catalogue/pieces1885.html
    // - 2000 Pesetas (Monedas de Plata Conmemorativa FNMT 1994-2001): https://en.numista.com/catalogue/pieces3153.html
    NumismaticEmissionRuleData(
      country: 'España',
      minYear: 1982,
      maxYear: 2001,
      validCurrencies: ['ESP'],
      defaultCurrency: 'ESP',
      denominations: ['0.10', '0.50', '1', '2', '5', '10', '25', '50', '100', '200', '500', '2000'],
      denominationMaterials: {
        '0.10': 'Aluminio',
        '0.50': 'Aluminio',
        '1': 'Aluminio',
        '2': 'Aluminio',
        '5': 'Bronce de aluminio',
        '10': 'Cuproníquel',
        '25': 'Bronce de aluminio',
        '50': 'Cuproníquel',
        '100': 'Bronce de aluminio',
        '200': 'Cuproníquel',
        '500': 'Bronce de aluminio',
        '2000': 'Plata',
      },
      commemorativeDenominations: {'25', '2000'},
      commemorativeMotifsByDenomination: {
        '25': [
          'Juegos Olímpicos de Barcelona 92 (1990-1992)',
          'Castilla y León (1993)',
          'País Vasco (1994)',
          'Canarias (1995)',
          'Principado de Asturias (1996)',
          'Castilla-La Mancha (1997)',
          'Melilla (1997)',
          'Ceuta (1998)',
          'Comunidad Foral de Navarra (1999)',
          'Palacio Real de Madrid (2000)',
        ],
        '2000': [
          'Asamblea del FMI y Banco Mundial - Madrid (1994)',
          'Presidencia Española del Consejo de la Unión Europea (1995)',
          'IV Centenario de Don Quijote y Sancho (1996)',
          '400 Aniversario de Juan de Herrera (1997)',
          'IV Centenario de la Muerte de Felipe II (1998)',
          'Año Santo Xacobeo (1999)',
          'V Centenario del Nacimiento de Carlos V (2000)',
          'Última Emisión de la Peseta - Hispania (2001)',
        ],
      },
      defaultCommemorativeReason: 'Conmemorativa',
    ),

    // 3.5 España - Época del Euro (grabadas físicamente 1999–presente)
    // Ref General: Banco Central Europeo - Monedas de Euro de España:
    // https://www.ecb.europa.eu/euro/coins/html/es.es.html
    // Ref General: Real Casa de la Moneda - FNMT Monedas de Colección y 2€ Conmemorativos:
    // https://www.fnmt.es/coleccionista/monedas-2-euros
    // Ref General: Numista - Spain - Euro (1999-date):
    // https://en.numista.com/catalogue/spain-euro-1.html
    // Denominación - Modelo / Referencias:
    // - 0.01, 0.02, 0.05 Euro (Acero bañado en cobre - Catedral de Santiago de Compostela): https://www.ecb.europa.eu/euro/coins/html/es.es.html
    // - 0.10, 0.20, 0.50 Euro (Oro nórdico - Miguel de Cervantes): https://www.ecb.europa.eu/euro/coins/html/es.es.html
    // - 1 Euro (Bimetálica - Juan Carlos I / Felipe VI): https://www.ecb.europa.eu/euro/coins/html/es.es.html
    // - 2 Euros (Bimetálica - Juan Carlos I / Felipe VI / Serie 2€ Conmemorativos UNESCO y Nacionales): https://www.fnmt.es/coleccionista/monedas-2-euros
    // - 10, 12, 20, 30, 40 Euros (Plata de Colección FNMT): https://www.fnmt.es/coleccionista
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
        '1': 'Bimetálica',
        '2': 'Bimetálica',
        '10': 'Plata',
        '12': 'Plata',
        '20': 'Plata',
        '30': 'Plata',
        '40': 'Plata',
      },
      commemorativeDenominations: {'10', '12', '20', '30', '40'},
      commemorativeMotifsByDenomination: {
        '2': [
          'IV Centenario de Don Quijote de la Mancha',
          'IV Centenario de la Primera Edición de Don Quijote de la Mancha (2005)',
          '50 Aniversario del Tratado de Roma (2007)',
          '10 Años de la Unión Económica y Monetaria (2009)',
          'Centro Histórico de Córdoba - Mezquita-Catedral (UNESCO 2010)',
          'La Alhambra, Generalife y Albaicín de Granada (UNESCO 2011)',
          'Catedral de Burgos (UNESCO 2012)',
          '10 Años de los Billetes y Monedas en Euros (2012)',
          'Real Monasterio de San Lorenzo de El Escorial (UNESCO 2013)',
          'Parque Güell - Obras de Antoni Gaudí (UNESCO 2014)',
          'Proclamación de Su Majestad el Rey Felipe VI (2014)',
          'Cueva de Altamira y Arte Rupestre del Norte de España (UNESCO 2015)',
          '30 Años de la Bandera de la Unión Europea (2015)',
          'Acueducto de Segovia (UNESCO 2016)',
          'Monumentos de Oviedo y del Reino de Asturias (UNESCO 2017)',
          '50 Aniversario del Nacimiento del Rey Felipe VI (2018)',
          'Ciudad Vieja de Santiago de Compostela (UNESCO 2018)',
          'Murallas y Ciudad Vieja de Ávila (UNESCO 2019)',
          'Arquitectura Mudéjar de Aragón (UNESCO 2020)',
          'Ciudad Histórica de Toledo (UNESCO 2021)',
          'Parque Nacional de Garajonay (UNESCO 2022)',
          'V Centenario de la Vuelta al Mundo de Juan Sebastián Elcano (2022)',
          '35 Años del Programa Erasmus (2022)',
          'Ciudad Vieja de Cáceres (UNESCO 2023)',
          'Presidencia Española del Consejo de la Unión Europea (2023)',
          'Catedral, Alcázar y Archivo de Indias de Sevilla (UNESCO 2024)',
          'Bicentenario de la Policía Nacional (2024)',
          'Paisaje de la Luz de Madrid (UNESCO 2025)',
          'Patrimonio Mundial de la UNESCO',
          'Tratado de Roma (2007)',
          '10 Años de la Unión Económica y Monetaria (2009)',
          'Proclamación de Felipe VI (2014)',
          'Conmemorativa',
        ],
      },
      commemorativeReasons: [
        'Tratado de Roma',
        'Unión Económica y Monetaria',
        'Patrimonio Mundial de la UNESCO',
        'Proclamación de Felipe VI',
        'Conmemorativa',
      ],
    ),

    // 3.6 Unión Europea (Zona Euro, grabadas físicamente 1999–presente)
    // Ref General: European Central Bank - Euro Coinage Specifications:
    // https://www.ecb.europa.eu/euro/coins/html/index.en.html
    // Ref General: Numista - Eurozone Common Issues:
    // https://en.numista.com/catalogue/eurozone-1.html
    // Denominación - Modelo / Referencias:
    // - 0.01, 0.02, 0.05 Euro (Acero bañado en cobre): https://www.ecb.europa.eu/euro/coins/html/index.en.html
    // - 0.10, 0.20, 0.50 Euro (Oro nórdico): https://www.ecb.europa.eu/euro/coins/html/index.en.html
    // - 1 Euro (Bimetálica): https://www.ecb.europa.eu/euro/coins/html/index.en.html
    // - 2 Euros (Bimetálica - Emisiones Comunes de la Eurozona): https://www.ecb.europa.eu/euro/coins/comm/html/index.en.html
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
      commemorativeMotifsByDenomination: {
        '2': [
          '50 Aniversario del Tratado de Roma (2007)',
          '10 Años de la Unión Económica y Monetaria (2009)',
          '10 Años de los Billetes y Monedas en Euros (2012)',
          '30 Años de la Bandera de la Unión Europea (2015)',
          '35 Años del Programa Erasmus (2022)',
        ],
      },
      commemorativeReasons: [
        '50 Aniversario del Tratado de Roma (2007)',
        '10 Años de la Unión Económica y Monetaria (2009)',
        '10 Años de los Billetes y Monedas en Euros (2012)',
        '30 Años de la Bandera de la Unión Europea (2015)',
        '35 Años del Programa Erasmus (2022)',
      ],
    ),

    // =========================================================================
    // 4. GUATEMALA
    // =========================================================================

    // 4.1 Guatemala - Época Colonial y Reales Predecimales (1500–1859)
    // Ref General: Banco de Guatemala - Historia Numismática: https://www.banguat.gob.gt
    // Ref General: Numista - Guatemala - Real (1733-1859):
    // https://en.numista.com/catalogue/guatemala-real-1.html
    // Denominación - Modelo / Referencias:
    // - 1/4 Real (Cuartilla de Plata - Busto colonial / República): https://en.numista.com/catalogue/pieces28707.html
    // - 1/2, 1, 2, 4, 8 Reales (Plata Ley .9027 / .835 - Columnarias, Busto y Árbol de la Federación): https://en.numista.com/catalogue/pieces15072.html
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
    // Ref General: Numista - Guatemala - Peso (1859-1925):
    // https://en.numista.com/catalogue/guatemala-peso-1.html
    // Denominación - Modelo / Referencias:
    // - 0.01 Peso (1 Centavo Cobre - Carrera / República): https://en.numista.com/catalogue/pieces15073.html
    // - 0.05 Peso (5 Centavos Níquel / Cuproníquel): https://en.numista.com/catalogue/pieces15074.html
    // - 0.10, 0.25, 0.50, 1 Peso, 1/4, 1/2 Real (Plata Ley .900 / .835 / .500): https://en.numista.com/catalogue/pieces15075.html
    // - 5, 10, 20 Pesos (Oro Ley .900 Rafael Carrera / República): https://en.numista.com/catalogue/pieces15076.html
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

    // 4.3 Guatemala - Quetzal Clásico de Plata y Oro (1925–1964)
    // Ref General: Banco de Guatemala - Historia del Quetzal: https://www.banguat.gob.gt
    // Ref General: Numista - Guatemala - Quetzal (1925-date):
    // https://en.numista.com/catalogue/guatemala-quetzal-1.html
    // Denominación - Modelo / Referencias:
    // - 0.005 Quetzal (Medio Centavo Cuproníquel): https://en.numista.com/catalogue/pieces15077.html
    // - 0.01 Quetzal (1 Centavo Cobre / Bronce Fray Bartolomé de las Casas): https://en.numista.com/catalogue/pieces15078.html
    // - 0.05, 0.10, 0.25, 0.50, 1 Quetzal (Plata Ley .720 Monja Blanca / Quetzal): https://en.numista.com/catalogue/pieces15079.html
    // - 5, 10, 20 Quetzales (Oro Ley .900 Quetzal en Columna): https://en.numista.com/catalogue/pieces15080.html
    NumismaticEmissionRuleData(
      country: 'Guatemala',
      minYear: 1925,
      maxYear: 1964,
      validCurrencies: ['GTQ'],
      defaultCurrency: 'GTQ',
      denominations: ['0.005', '0.01', '0.05', '0.10', '0.25', '0.50', '1', '5', '10', '20'],
      denominationMaterials: {
        '0.005': 'Cuproníquel',
        '0.01': 'Cobre',
        '0.05': 'Plata',
        '0.10': 'Plata',
        '0.25': 'Plata',
        '0.50': 'Plata',
        '1': 'Plata',
        '5': 'Oro',
        '10': 'Oro',
        '20': 'Oro',
      },
    ),

    // 4.4 Guatemala - Quetzal Moderno (1965–presente)
    // Ref General: Banco de Guatemala - Especificaciones y aleaciones autorizadas (Decreto 92-98):
    // https://www.banguat.gob.gt/es/page/especificaciones-monedas
    // Ref General: Numista - Guatemala - Quetzal (1925-date):
    // https://en.numista.com/catalogue/guatemala-quetzal-1.html
    // Denominación - Modelo / Referencias:
    // - 0.01 Quetzal (Fray Bartolomé de las Casas - Aluminio-Magnesio): https://www.banguat.gob.gt/es/page/especificaciones-monedas
    // - 0.05 Quetzal (Árbol de la Libertad - Cuproníquel): https://www.banguat.gob.gt/es/page/especificaciones-monedas
    // - 0.10 Quetzal (Monolito de Quiriguá - Cuproníquel): https://www.banguat.gob.gt/es/page/especificaciones-monedas
    // - 0.25 Quetzal (Mujer Indígena Maya-Tzutujil / Concepción Ramírez - Cuproníquel): https://www.banguat.gob.gt/es/page/especificaciones-monedas
    // - 0.50 Quetzal (Monja Blanca / Flor Nacional - Latón): https://www.banguat.gob.gt/es/page/especificaciones-monedas
    // - 1 Quetzal (Paz Firme y Duradera - Latón / Bimetálica 1998): https://www.banguat.gob.gt/es/page/especificaciones-monedas | https://en.numista.com/catalogue/pieces4789.html
    NumismaticEmissionRuleData(
      country: 'Guatemala',
      minYear: 1965,
      maxYear: 2100,
      validCurrencies: ['GTQ'],
      defaultCurrency: 'GTQ',
      denominations: ['0.01', '0.05', '0.10', '0.25', '0.50', '1'],
      denominationMaterials: {
        '0.01': 'Aluminio-Magnesio (Magnalio)',
        '0.05': 'Cuproníquel',
        '0.10': 'Cuproníquel',
        '0.25': 'Cuproníquel',
        '0.50': 'Latón',
        '1': 'Latón',
      },
      denominationAllowedMaterials: {
        '1': ['Latón', 'Bimetálica'],
      },
      commemorativeDenominations: {'1'},
      commemorativeMotifsByDenomination: {
        '1': [
          'Paz Firme y Duradera (1996+)',
          'Acuerdo de Paz Firme y Duradera',
        ],
      },
      commemorativeReasons: [
        'Paz Firme y Duradera (1996+)',
      ],
    ),

    // =========================================================================
    // 5. COLOMBIA
    // =========================================================================

    // 5.1 Colombia - Virreinato de Nueva Granada y Reales Predecimales (1500–1846)
    // Ref General: Banco de la República - Historia de la moneda colonial:
    // https://www.banrep.gov.co/es/coleccion-numismatica/historia-moneda-colonial
    // Ref General: Numista - Colombia - Real (1616-1820):
    // https://en.numista.com/catalogue/colombia-real-1.html
    // Denominación - Modelo / Referencias:
    // - 1/4 Real (Cuartilla de Plata - Busto colonial / Granada): https://en.numista.com/catalogue/pieces28708.html
    // - 1/2, 1, 2, 4, 8 Reales (Plata Ley .9027 / .835 - Columnarias, Busto y República de Colombia): https://en.numista.com/catalogue/pieces15081.html
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
    // Ref General: Banco de la República - Colección Numismática:
    // https://www.banrep.gov.co/es/coleccion-numismatica
    // Ref General: Numista - Colombia - Peso Decimal (1847-1904):
    // https://en.numista.com/catalogue/colombia-peso-decimal-1.html
    // Denominación - Modelo / Referencias:
    // - 0.01, 0.02 Peso (Cobre / Cuproníquel): https://en.numista.com/catalogue/pieces15082.html
    // - 0.05, 0.10, 0.20, 0.50, 1 Peso (Plata Ley .900 / .835 / .500): https://en.numista.com/catalogue/pieces15083.html
    // - 2, 5, 10, 20 Pesos (Oro Ley .900): https://en.numista.com/catalogue/pieces15084.html
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

    // 5.3 Colombia - Peso Republicano Clásico (1905–1979)
    // Ref General: Banco de la República - Monedas en circulación histórica:
    // https://www.banrep.gov.co/es/billetes-monedas/monedas-circulacion
    // Denominación - Modelo / Referencias:
    // - 0.01, 0.02 Peso (Bronce): https://en.numista.com/catalogue/pieces15085.html
    // - 0.05 Peso (Cuproníquel / Caldas): https://en.numista.com/catalogue/pieces15086.html
    // - 0.10, 0.20, 0.50 Peso (Plata / Cuproníquel - Nariño / Santander): https://en.numista.com/catalogue/pieces15087.html
    // - 1, 2, 5, 50 Pesos (Cuproníquel - Simón Bolívar / Santander): https://en.numista.com/catalogue/pieces15088.html
    // - 10, 20 Pesos (Oro Ley .900): https://en.numista.com/catalogue/pieces15089.html
    NumismaticEmissionRuleData(
      country: 'Colombia',
      minYear: 1905,
      maxYear: 1979,
      validCurrencies: ['COP'],
      defaultCurrency: 'COP',
      denominations: ['0.01', '0.02', '0.05', '0.10', '0.20', '0.50', '1', '2', '5', '10', '20', '50'],
      denominationMaterials: {
        '0.01': 'Bronce',
        '0.02': 'Bronce',
        '0.05': 'Cuproníquel',
        '0.10': 'Plata',
        '0.20': 'Plata',
        '0.50': 'Plata',
        '1': 'Cuproníquel',
        '2': 'Cuproníquel',
        '5': 'Cuproníquel',
        '10': 'Oro',
        '20': 'Oro',
        '50': 'Cuproníquel',
      },
    ),

    // 5.4 Colombia - Familia Tradicional Árbol de Guacarí (1980–2011)
    // Ref General: Banco de la República - Monedas en proceso de retiro:
    // https://www.banrep.gov.co/es/billetes-monedas/monedas-circulacion
    // Denominación - Modelo / Referencias:
    // - 1, 2 Pesos (Bronce de aluminio - Bolívar): https://en.numista.com/catalogue/pieces15090.html
    // - 5, 10, 20 Pesos (Cuproníquel - Bolívar / Policarpa): https://en.numista.com/catalogue/pieces15091.html
    // - 50 Pesos (Acero inoxidable - Escudo de Colombia): https://en.numista.com/catalogue/pieces15092.html
    // - 100 Pesos (Bronce de aluminio - Escudo de Colombia): https://en.numista.com/catalogue/pieces15093.html
    // - 200 Pesos (Cuproníquel - Arte Quimbaya): https://en.numista.com/catalogue/pieces15094.html
    // - 500 Pesos (Bimetálica - Árbol de Guacarí): https://en.numista.com/catalogue/pieces4802.html
    NumismaticEmissionRuleData(
      country: 'Colombia',
      minYear: 1980,
      maxYear: 2011,
      validCurrencies: ['COP'],
      defaultCurrency: 'COP',
      denominations: ['1', '2', '5', '10', '20', '50', '100', '200', '500'],
      denominationMaterials: {
        '1': 'Bronce de aluminio',
        '2': 'Bronce de aluminio',
        '5': 'Cuproníquel',
        '10': 'Cuproníquel',
        '20': 'Cuproníquel',
        '50': 'Acero inoxidable',
        '100': 'Bronce de aluminio',
        '200': 'Cuproníquel',
        '500': 'Bimetálica',
      },
      commemorativeDenominations: {'500'},
      commemorativeMotifsByDenomination: {
        '500': [
          'Árbol de Guacarí (Samanea saman)',
          'Árbol de Guacarí',
        ],
      },
      commemorativeReasons: [
        'Árbol de Guacarí',
      ],
    ),

    // 5.5 Colombia - Familia Biodiversidad de Colombia (2012–presente)
    // Ref General: Banco de la República - Monedas en circulación y conmemorativas:
    // https://www.banrep.gov.co/es/billetes-monedas/monedas-circulacion
    // Denominación - Modelo / Referencias:
    // - 50 Pesos (Oso de Anteojos - Acero bañado en níquel): https://www.banrep.gov.co/es/billetes-monedas/monedas-circulacion
    // - 100 Pesos (Frailejón - Bronce de aluminio): https://www.banrep.gov.co/es/billetes-monedas/monedas-circulacion
    // - 200 Pesos (Guacamaya Bandera - Cuproníquel): https://www.banrep.gov.co/es/billetes-monedas/monedas-circulacion
    // - 500 Pesos (Rana de Cristal - Bimetálica): https://www.banrep.gov.co/es/billetes-monedas/monedas-circulacion
    // - 1000 Pesos (Tortuga Caguama - Bimetálica): https://www.banrep.gov.co/es/billetes-monedas/monedas-circulacion
    // - 10000, 20000 Pesos (Monedas Conmemorativas - Bicentenario Independencia 2019, Policarpa Salavarrieta 2022, Batalla Naval de Maracaibo 2023, Museo Nacional 2023): https://www.banrep.gov.co/es/billetes-monedas/monedas-conmemorativas
    NumismaticEmissionRuleData(
      country: 'Colombia',
      minYear: 2012,
      maxYear: 2100,
      validCurrencies: ['COP'],
      defaultCurrency: 'COP',
      denominations: ['50', '100', '200', '500', '1000', '10000', '20000'],
      denominationMaterials: {
        '50': 'Acero bañado en níquel',
        '100': 'Bronce de aluminio',
        '200': 'Cuproníquel',
        '500': 'Bimetálica',
        '1000': 'Bimetálica',
        '10000': 'Cuproníquel',
        '20000': 'Cuproníquel',
      },
      commemorativeDenominations: {'50', '100', '200', '500', '1000', '10000', '20000'},
      commemorativeMotifsByDenomination: {
        '50': ['Oso de Anteojos (Tremarctos ornatus)'],
        '100': ['Frailejón (Espeletia grandiflora)'],
        '200': ['Guacamaya Bandera (Ara macao)'],
        '500': ['Rana de Cristal (Anura Centrolenidae)'],
        '1000': ['Tortuga Caguama (Caretta caretta)'],
        '10000': [
          'Bicentenario de la Independencia de Colombia (2019)',
          'Bicentenario del Sacrificio de Policarpa Salavarrieta (2022)',
          'Bicentenario de la Batalla Naval del Lago de Maracaibo (2023)',
        ],
        '20000': [
          'Bicentenario del Museo Nacional de Colombia (2023)',
        ],
      },
      commemorativeReasons: [
        'Biodiversidad de Colombia',
        'Bicentenario de la Independencia de Colombia (2019)',
        'Policarpa Salavarrieta (2022)',
        'Batalla Naval del Lago de Maracaibo (2023)',
        'Museo Nacional de Colombia (2023)',
      ],
    ),

    // =========================================================================
    // 6. CANADÁ
    // =========================================================================

    // 6.1 Canadá - Época Victoriana, Jorge V y Jorge VI (1858–1952)
    // Ref General: Royal Canadian Mint - Circulation Coins History:
    // https://www.mint.ca/en/discover/canadian-circulation-coins-history
    // Ref General: Numista - Canada (1858-1952):
    // https://en.numista.com/catalogue/canada-1.html
    // Denominación - Modelo / Referencias:
    // - 0.01 Dollar (Large Cent / Small Cent Cobre / Bronce): https://en.numista.com/catalogue/pieces424.html
    // - 0.05 Dollar (Silver 5 Cents / Nickel 5 Cents 99% Ni / Tombac): https://en.numista.com/catalogue/pieces407.html
    // - 0.10, 0.20, 0.25, 0.50, 1 Dollar (Plata Ley .925 / .800 Voyageur): https://en.numista.com/catalogue/pieces458.html
    // - 5, 10 Dollars (Oro Ley .900): https://en.numista.com/catalogue/pieces15095.html
    NumismaticEmissionRuleData(
      country: 'Canadá',
      minYear: 1858,
      maxYear: 1952,
      validCurrencies: ['CAD', 'CAD_HIST'],
      defaultCurrency: 'CAD',
      denominations: ['0.01', '0.05', '0.10', '0.20', '0.25', '0.50', '1', '5', '10'],
      denominationMaterials: {
        '0.01': 'Cobre',
        '0.05': 'Níquel',
        '0.10': 'Plata',
        '0.20': 'Plata',
        '0.25': 'Plata',
        '0.50': 'Plata',
        '1': 'Plata',
        '5': 'Oro',
        '10': 'Oro',
      },
    ),

    // 6.2 Canadá - Era de Plata Isabel II (1953–1967)
    // Ref General: Royal Canadian Mint - 1967 Centennial Coinage: https://www.mint.ca
    // Ref General: Numista - Canada - Elizabeth II Silver Era:
    // https://en.numista.com/catalogue/canada-2.html
    // Denominación - Modelo / Referencias:
    // - 0.01 Dollar (Bronce 12 Lados / Redondo): https://en.numista.com/catalogue/pieces425.html
    // - 0.05 Dollar (Níquel puro 12 Lados / Redondo): https://en.numista.com/catalogue/pieces408.html
    // - 0.10, 0.25, 0.50, 1 Dollar (Plata Ley .800 Bluenose, Caribú, Escudo, Voyageur / Serie Bicentenario 1967): https://en.numista.com/catalogue/pieces459.html
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
        '0.10': 'Plata',
        '0.25': 'Plata',
        '0.50': 'Plata',
        '1': 'Plata',
      },
      commemorativeDenominations: {'0.25', '0.50', '1'},
      commemorativeMotifsByDenomination: {
        '0.25': ['Centennial Bobcat / Lince (1967)'],
        '0.50': ['Centennial Howling Wolf (1967)'],
        '1': ['Centennial Canada Goose (1967)'],
      },
      commemorativeReasons: [
        'Centennial Coinage (1967)',
      ],
    ),

    // 6.3 Canadá - Transición Níquel Puro Pre-Loonie (1968–1986)
    // Ref General: Royal Canadian Mint - Modern Circulation Coins:
    // https://www.mint.ca/en/discover/canadian-circulation-coins
    // Denominación - Modelo / Referencias:
    // - 0.01 Dollar (Bronce - Hoja de Arce): https://en.numista.com/catalogue/pieces426.html
    // - 0.05 Dollar (Níquel puro 99% - Castor): https://en.numista.com/catalogue/pieces409.html
    // - 0.10 Dollar (Níquel puro 99% - Bluenose): https://en.numista.com/catalogue/pieces389.html
    // - 0.25 Dollar (Níquel puro 99% - Caribú / RCMP Mountie 1973): https://en.numista.com/catalogue/pieces367.html
    // - 0.50 Dollar (Níquel puro 99% - Escudo de Canadá): https://en.numista.com/catalogue/pieces388.html
    // - 1 Dollar (Níquel puro 99% - Voyageur / Conmemorativas Manitoba, BC, PEI, Winnipeg, Constitution): https://en.numista.com/catalogue/pieces460.html
    NumismaticEmissionRuleData(
      country: 'Canadá',
      minYear: 1968,
      maxYear: 1986,
      validCurrencies: ['CAD'],
      defaultCurrency: 'CAD',
      denominations: ['0.01', '0.05', '0.10', '0.25', '0.50', '1'],
      denominationMaterials: {
        '0.01': 'Bronce',
        '0.05': 'Níquel',
        '0.10': 'Níquel',
        '0.25': 'Níquel',
        '0.50': 'Níquel',
        '1': 'Níquel',
      },
      commemorativeDenominations: {'0.25', '1'},
      commemorativeMotifsByDenomination: {
        '0.25': [
          'Mountie RCMP Centennial (1973)',
        ],
        '1': [
          'Manitoba Centennial (1970)',
          'British Columbia Centennial (1971)',
          'Prince Edward Island Centennial (1973)',
          'Winnipeg Centennial (1974)',
          'Constitution Act (1982)',
          'Jacques Cartier 450th Anniversary (1984)',
        ],
      },
      commemorativeReasons: [
        'RCMP Centennial (1973)',
        'Winnipeg Centennial (1974)',
        'Constitution Act (1982)',
      ],
    ),

    // 6.4 Canadá - Introducción del Loonie y Toonie (1987–1999)
    // Ref General: Royal Canadian Mint - The Loonie and Toonie:
    // https://www.mint.ca/en/discover/canadian-circulation-coins
    // Denominación - Modelo / Referencias:
    // - 0.01 Dollar (Bronce 12 Lados / Redondo): https://en.numista.com/catalogue/pieces427.html
    // - 0.05 Dollar (Cuproníquel): https://en.numista.com/catalogue/pieces410.html
    // - 0.10 Dollar (Níquel puro): https://en.numista.com/catalogue/pieces390.html
    // - 0.25 Dollar (Níquel puro - Serie 125 Aniversario 1992 / Millennium 1999): https://en.numista.com/catalogue/pieces368.html
    // - 0.50 Dollar (Níquel puro): https://en.numista.com/catalogue/pieces388.html
    // - 1 Dollar (Loonie - Acero bañado en latón / Aureate-plated nickel 1987+): https://en.numista.com/catalogue/pieces461.html
    // - 2 Dollars (Toonie - Bimetálica Oso Polar 1996+ / Nunavut 1999): https://en.numista.com/catalogue/pieces479.html
    NumismaticEmissionRuleData(
      country: 'Canadá',
      minYear: 1987,
      maxYear: 1999,
      validCurrencies: ['CAD'],
      defaultCurrency: 'CAD',
      denominations: ['0.01', '0.05', '0.10', '0.25', '0.50', '1', '2'],
      denominationMaterials: {
        '0.01': 'Bronce',
        '0.05': 'Cuproníquel',
        '0.10': 'Níquel',
        '0.25': 'Níquel',
        '0.50': 'Níquel',
        '1': 'Acero bañado en latón',
        '2': 'Bimetálica',
      },
      commemorativeDenominations: {'0.25', '1', '2'},
      commemorativeMotifsByDenomination: {
        '0.25': [
          '125 Aniversario de la Confederación de Canadá (1992)',
          'Millennium Series - 12 Diseños Mensuales (1999)',
        ],
        '1': [
          '125 Aniversario de Canadá (1992)',
          'National War Memorial (1994)',
          'Peacekeeping (1995)',
        ],
        '2': [
          'Creación del Territorio de Nunavut (1999)',
        ],
      },
      commemorativeReasons: [
        '125 Aniversario de Canadá (1992)',
        'Millennium Series (1999)',
        'Creación de Nunavut (1999)',
      ],
    ),

    // 6.5 Canadá - Época Multi-Ply Plated Steel (2000–presente)
    // Ref General: Royal Canadian Mint - Modern Coin Specifications:
    // https://www.mint.ca/en/discover/canadian-circulation-coins
    // Denominación - Modelo / Referencias:
    // - 0.01 Dollar (Acero bañado en cobre - Hoja de Arce hasta 2012): https://en.numista.com/catalogue/pieces428.html
    // - 0.05 Dollar (Acero bañado en níquel - Castor): https://en.numista.com/catalogue/pieces411.html
    // - 0.10 Dollar (Acero bañado en níquel - Bluenose): https://en.numista.com/catalogue/pieces391.html
    // - 0.25 Dollar (Acero bañado en níquel - Caribú / Poppy / Vancouver 2010 / Canada 150): https://en.numista.com/catalogue/pieces369.html
    // - 0.50 Dollar (Acero bañado en níquel - Escudo de Armas): https://en.numista.com/catalogue/pieces388.html
    // - 1 Dollar (Loonie - Acero bañado en latón / Lucky Loonie / Terry Fox): https://en.numista.com/catalogue/pieces462.html
    // - 2 Dollars (Toonie - Bimetálica Anillo de Níquel / Centro Bronce-Aluminio / Anillo Negro Reina Isabel II 2022): https://en.numista.com/catalogue/pieces480.html
    NumismaticEmissionRuleData(
      country: 'Canadá',
      minYear: 2000,
      maxYear: 2100,
      validCurrencies: ['CAD'],
      defaultCurrency: 'CAD',
      denominations: ['0.01', '0.05', '0.10', '0.25', '0.50', '1', '2'],
      denominationMaterials: {
        '0.01': 'Acero bañado en cobre',
        '0.05': 'Acero bañado en níquel',
        '0.10': 'Acero bañado en níquel',
        '0.25': 'Acero bañado en níquel',
        '0.50': 'Acero bañado en níquel',
        '1': 'Acero bañado en latón',
        '2': 'Bimetálica',
      },
      commemorativeDenominations: {'0.25', '1', '2'},
      commemorativeMotifsByDenomination: {
        '0.25': [
          'Millennium Series - 12 Diseños (2000)',
          'Remembrance Day Poppy (2004)',
          'Juegos Olímpicos de Invierno Vancouver 2010 (2007-2010)',
          'War of 1812 (2012-2013)',
          'Canada 150 - Hope for a Green Future (2017)',
        ],
        '1': [
          'Lucky Loonie (2004, 2008, 2010, 2012, 2014, 2016)',
          'Terry Fox (2005)',
          'Centenario de los Montreal Canadiens (2009)',
          'Centenario de la Marina Real Canadiense (2010)',
          'Canada 150 - Connecting a Nation (2017)',
          'Despenalización de la Homosexualidad (2019)',
          'Oscar Peterson (2022)',
          'Elsie MacGill (2023)',
        ],
        '2': [
          'Path of Knowledge (2000)',
          '10 Aniversario del Toonie (2006)',
          '400 Años de la Ciudad de Quebec (2008)',
          'HMS Shannon (2012)',
          'Sir John A. Macdonald (2015)',
          'Batalla del Atlántico (2016)',
          'Canada 150 - Dance of the Spirits (2017)',
          'Armisticio de 1918 (2018)',
          'D-Day 75 Aniversario (2019)',
          'Fin de la Segunda Guerra Mundial 75 Aniversario (2020)',
          'Descubrimiento de la Insulina (2021)',
          'Homenaje a la Reina Isabel II - Anillo Negro (2022)',
          'Día Nacional de los Pueblos Indígenas (2023)',
          'Centenario de la Real Fuerza Aérea Canadiense (2024)',
        ],
      },
      commemorativeReasons: [
        'Lucky Loonie',
        'Vancouver 2010 Winter Olympics',
        'Canada 150',
        'Toonie Commemorative Series',
      ],
    ),

    // =========================================================================
    // 7. CUBA
    // =========================================================================

    // 7.1 Cuba - Primera República (1915–1961)
    // Ref General: Banco Central de Cuba - Emisiones Históricas: https://www.bc.gob.cu/monedas
    // Ref General: Numista - Cuba - First Republic (1915-1961):
    // https://en.numista.com/catalogue/cuba-1.html
    // Denominación - Modelo / Referencias:
    // - 0.01, 0.02, 0.05 Peso (Cuproníquel - Estrella de cinco puntas): https://en.numista.com/catalogue/pieces15096.html
    // - 0.10, 0.20, 0.40, 1 Peso (Plata Ley .900 - Escudo de la Palma Real / Busto de José Martí 1953): https://en.numista.com/catalogue/pieces15097.html
    // - 2, 4, 5, 10, 20 Pesos (Oro Ley .900 - José Martí): https://en.numista.com/catalogue/pieces15098.html
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
        '0.10': 'Plata',
        '0.20': 'Plata',
        '0.40': 'Plata',
        '1': 'Plata',
        '2': 'Oro',
        '4': 'Oro',
        '5': 'Oro',
        '10': 'Oro',
        '20': 'Oro',
      },
      commemorativeDenominations: {'0.25', '0.50', '1'},
      commemorativeMotifsByDenomination: {
        '1': [
          'Centenario del Natalicio de José Martí (1953)',
        ],
      },
      commemorativeReasons: [
        'Centenario del Natalicio de José Martí (1953)',
      ],
    ),

    // 7.2 Cuba - Período Socialista Pre-CUC (1962–1993)
    // Ref General: Banco Central de Cuba - Sistema Monetario: https://www.bc.gob.cu
    // Ref General: Numista - Cuba - Second Republic (1962-date):
    // https://en.numista.com/catalogue/cuba-2.html
    // Denominación - Modelo / Referencias:
    // - 0.01, 0.02, 0.05, 0.20 Peso (Aluminio): https://en.numista.com/catalogue/pieces15099.html
    // - 0.40, 1, 3 Pesos (Cuproníquel - Che Guevara "Hasta la Victoria Siempre"): https://en.numista.com/catalogue/pieces15100.html
    NumismaticEmissionRuleData(
      country: 'Cuba',
      minYear: 1962,
      maxYear: 1993,
      validCurrencies: ['CUP'],
      defaultCurrency: 'CUP',
      denominations: ['0.01', '0.02', '0.05', '0.20', '0.40', '1', '3'],
      denominationMaterials: {
        '0.01': 'Aluminio',
        '0.02': 'Aluminio',
        '0.05': 'Aluminio',
        '0.20': 'Aluminio',
        '0.40': 'Cuproníquel',
        '1': 'Cuproníquel',
        '3': 'Cuproníquel',
      },
      commemorativeDenominations: {'3'},
      commemorativeMotifsByDenomination: {
        '3': [
          'Ernesto Che Guevara - Hasta la Victoria Siempre',
          'Che Guevara',
        ],
      },
      commemorativeReasons: [
        'Che Guevara',
      ],
    ),

    // 7.3 Cuba - Régimen Dual CUP / CUC (1994–2020)
    // Ref General: Banco Central de Cuba - Monedas en Circulación: https://www.bc.gob.cu
    // Denominación - Modelo / Referencias:
    // - 0.01, 0.02, 0.05 Peso (Aluminio): https://en.numista.com/catalogue/pieces15099.html
    // - 0.10 Peso (Acero bañado en níquel - Castillo de la Fuerza): https://en.numista.com/catalogue/pieces15101.html
    // - 0.25, 0.50, 1, 3 Pesos (Cuproníquel - José Martí, Camilo Cienfuegos, Che Guevara): https://en.numista.com/catalogue/pieces15102.html
    // - 5 Pesos (Bimetálica - Antonio Maceo / Protesta de Baraguá): https://en.numista.com/catalogue/pieces15103.html
    NumismaticEmissionRuleData(
      country: 'Cuba',
      minYear: 1994,
      maxYear: 2020,
      validCurrencies: ['CUP', 'CUC'],
      defaultCurrency: 'CUP',
      denominations: ['0.01', '0.02', '0.05', '0.10', '0.25', '0.50', '1', '3', '5'],
      denominationMaterials: {
        '0.01': 'Aluminio',
        '0.02': 'Aluminio',
        '0.05': 'Aluminio',
        '0.10': 'Acero bañado en níquel',
        '0.25': 'Cuproníquel',
        '0.50': 'Cuproníquel',
        '1': 'Cuproníquel',
        '3': 'Cuproníquel',
        '5': 'Bimetálica',
      },
      commemorativeDenominations: {'1', '3', '5'},
      commemorativeMotifsByDenomination: {
        '1': [
          'José Martí',
          'Camilo Cienfuegos',
          'Celia Sánchez',
        ],
        '3': [
          'Ernesto Che Guevara - Hasta la Victoria Siempre',
          'Che Guevara',
        ],
        '5': [
          'Antonio Maceo - Protesta de Baraguá',
        ],
      },
      commemorativeReasons: [
        'Héroes de la Revolución Cubana',
        'Che Guevara',
        'Antonio Maceo',
      ],
    ),

    // 7.4 Cuba - Unificación Monetaria (2021–presente)
    // Ref General: Banco Central de Cuba - Ordenamiento Monetario: https://www.bc.gob.cu
    // Denominación - Modelo / Referencias:
    // - 0.05 Peso (Aluminio): https://www.bc.gob.cu
    // - 0.20 Peso (Acero bañado en latón): https://www.bc.gob.cu
    // - 1 Peso (Acero bañado en níquel - José Martí): https://www.bc.gob.cu
    // - 3 Pesos (Acero bañado en níquel - Ernesto Che Guevara): https://www.bc.gob.cu
    // - 5 Pesos (Acero bañado en latón - Antonio Maceo): https://www.bc.gob.cu
    NumismaticEmissionRuleData(
      country: 'Cuba',
      minYear: 2021,
      maxYear: 2100,
      validCurrencies: ['CUP'],
      defaultCurrency: 'CUP',
      denominations: ['0.05', '0.20', '1', '3', '5'],
      denominationMaterials: {
        '0.05': 'Aluminio',
        '0.20': 'Acero bañado en latón',
        '1': 'Acero bañado en níquel',
        '3': 'Acero bañado en níquel',
        '5': 'Acero bañado en latón',
      },
      commemorativeDenominations: {'1', '3', '5'},
      commemorativeMotifsByDenomination: {
        '1': ['José Martí'],
        '3': ['Ernesto Che Guevara'],
        '5': ['Antonio Maceo'],
      },
      commemorativeReasons: [
        'Héroes Nacionales',
      ],
    ),

    // =========================================================================
    // 8. ARGENTINA
    // =========================================================================

    // 8.1 Argentina - Provincias Unidas del Río de la Plata y Confederación (1813–1880)
    // Ref General: Banco Central de la República Argentina - Historia Numismática: https://www.bcra.gob.ar
    // Ref General: Numista - Argentina - Real & Early Peso (1813-1881):
    // https://en.numista.com/catalogue/argentina-1.html
    // Denominación - Modelo / Referencias:
    // - 1/4 Real (Cobre - Sol de Mayo / F.O. / Provincias del Río de la Plata): https://en.numista.com/catalogue/pieces15085.html
    // - 1/2 Real (Plata Ley .896 - Sol Radiante / Escudo Nacional): https://en.numista.com/catalogue/pieces15086.html
    // - 1 Real (Plata Ley .896 - Sol Radiante / Escudo Nacional): https://en.numista.com/catalogue/pieces15087.html
    // - 2 Reales (Plata Ley .896 - Sol Radiante / Escudo Nacional): https://en.numista.com/catalogue/pieces15088.html
    // - 4 Reales (Plata Ley .896 - Sol Radiante / Escudo Nacional): https://en.numista.com/catalogue/pieces15089.html
    // - 8 Reales (Plata Ley .896 - Sol de Mayo "En Unión y Libertad" / Escudo Nacional): https://en.numista.com/catalogue/pieces15090.html
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
    // Ref General: Banco Central de la República Argentina - Emisiones históricas: https://www.bcra.gob.ar
    // Ref General: Numista - Argentina - Peso Moneda Nacional (1881-1969):
    // https://en.numista.com/catalogue/argentina-2.html
    // Denominación - Modelo / Referencias:
    // - 0.01, 0.02 Peso (Bronce - Libertad de Oudiné / Escudo Nacional): https://en.numista.com/catalogue/pieces7117.html
    // - 0.05, 0.10, 0.20 Peso (Cuproníquel / Níquel - Libertad de Oudiné): https://en.numista.com/catalogue/pieces7118.html
    // - 0.50, 1 Peso (Plata Ley .900 - Libertad con gorro frigio): https://en.numista.com/catalogue/pieces7119.html
    // - 2 Pesos (Cuproníquel - San Martín): https://en.numista.com/catalogue/pieces7120.html
    // - 5 Pesos (Oro Ley .900 - Argentino de Oro / Libertad Oudiné): https://en.numista.com/catalogue/pieces7121.html
    // - 10, 20 Pesos (Cuproníquel / Acero revestido - San Martín / Cabildo de Buenos Aires): https://en.numista.com/catalogue/pieces7122.html
    // - 25, 50, 100 Pesos (Acero / Cuproníquel - Fragata Sarmiento / Sesquicentenario de Mayo): https://en.numista.com/catalogue/pieces7123.html
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
        '0.50': 'Plata',
        '1': 'Plata',
        '2': 'Cuproníquel',
        '5': 'Oro',
        '10': 'Cuproníquel',
        '20': 'Cuproníquel',
        '25': 'Acero',
        '50': 'Acero',
        '100': 'Acero',
      },
      commemorativeDenominations: {'25', '50', '100'},
      commemorativeMotifsByDenomination: {
        '25': [
          'Sesquicentenario de la Revolución de Mayo (1960)',
        ],
        '50': [
          'Centenario de la Reorganización Nacional (1962)',
          'Sesquicentenario de la Declaración de la Independencia (1966)',
        ],
        '100': [
          'Sesquicentenario de la Declaración de la Independencia (1966)',
          'Centenario del Nacimiento del General San Martín (1978)',
        ],
      },
      commemorativeReasons: [
        'Sesquicentenario de la Revolución de Mayo (1960)',
        'Sesquicentenario de la Independencia (1966)',
      ],
    ),

    // 8.3 Argentina - Peso Ley 18.188 (1970–1983)
    // Ref General: Banco Central de la República Argentina - Emisiones Ley 18.188: https://www.bcra.gob.ar
    // Ref General: Numista - Argentina - Peso Ley (1970-1983):
    // https://en.numista.com/catalogue/argentina-3.html
    // Denominación - Modelo / Referencias:
    // - 0.01, 0.05, 0.10, 0.20, 0.50, 1, 5, 10 Pesos (Bronce de aluminio - Libertad / San Martín / Cabildo): https://en.numista.com/catalogue/pieces7124.html
    // - 20, 50, 100 Pesos (Bronce de aluminio - Mundial Argentina 1978 / San Martín Bicentenario): https://en.numista.com/catalogue/pieces7125.html
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
      commemorativeDenominations: {'20', '50', '100'},
      commemorativeMotifsByDenomination: {
        '20': [
          'Mundial de Fútbol Argentina 1978 - Estadio José María Minella',
          'Mundial de Fútbol Argentina 1978 - Estadio Monumental',
          'Bicentenario del Natalicio del General José de San Martín (1978)',
        ],
        '50': [
          'Mundial de Fútbol Argentina 1978 - Estadio Ciudad de Mendoza',
          'Bicentenario del Natalicio del General José de San Martín (1978)',
        ],
        '100': [
          'Mundial de Fútbol Argentina 1978 - Estadio Monumental de River Plate',
          'Bicentenario del Natalicio del General José de San Martín (1978)',
          'Centenario de la Conquista del Desierto (1979)',
        ],
      },
      commemorativeReasons: [
        'Mundial de Fútbol Argentina 1978',
        'Bicentenario de San Martín (1978)',
      ],
    ),

    // 8.4 Argentina - Peso Argentino (1983–1985)
    // Ref General: Banco Central de la República Argentina: https://www.bcra.gob.ar
    // Ref General: Numista - Argentina - Peso Argentino (1983-1985):
    // https://en.numista.com/catalogue/argentina-4.html
    // Denominación - Modelo / Referencias:
    // - 0.01, 0.05, 0.10, 0.50, 1 Peso (Aluminio - Escudo Nacional / Congreso de la Nación): https://en.numista.com/catalogue/pieces7130.html
    // - 5, 10, 50, 100 Pesos (Latón - Cabildo / Casa de Tucumán / Monumento a la Bandera): https://en.numista.com/catalogue/pieces7131.html
    NumismaticEmissionRuleData(
      country: 'Argentina',
      minYear: 1983,
      maxYear: 1985,
      validCurrencies: ['ARP'],
      defaultCurrency: 'ARP',
      denominations: ['0.01', '0.05', '0.10', '0.50', '1', '5', '10', '50', '100'],
      denominationMaterials: {
        '0.01': 'Aluminio',
        '0.05': 'Aluminio',
        '0.10': 'Aluminio',
        '0.50': 'Aluminio',
        '1': 'Aluminio',
        '5': 'Latón',
        '10': 'Latón',
        '50': 'Latón',
        '100': 'Latón',
      },
    ),

    // 8.5 Argentina - Austral (1985–1991)
    // Ref General: Banco Central de la República Argentina: https://www.bcra.gob.ar
    // Ref General: Numista - Argentina - Austral (1985-1991):
    // https://en.numista.com/catalogue/argentina-4.html
    // Denominación - Modelo / Referencias:
    // - 0.005, 0.01, 0.05, 0.10, 0.50, 1, 5, 10 Australes (Aluminio - Fauna Argentina: Ñandú, Puma, Hornero): https://en.numista.com/catalogue/pieces7135.html
    // - 50, 100, 500, 1000 Australes (Cuproníquel / Bronce de aluminio - Libertad / San Martín): https://en.numista.com/catalogue/pieces7136.html
    NumismaticEmissionRuleData(
      country: 'Argentina',
      minYear: 1985,
      maxYear: 1991,
      validCurrencies: ['ARA'],
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

    // 8.6 Argentina - Peso Convertible Series Tradicionales (1992–2016)
    // Ref General: Banco Central de la República Argentina - Monedas en circulación:
    // https://www.bcra.gob.ar/mediospago/monedas_emisiones_vigentes.asp
    // Ref General: Numista - Argentina - Peso (1992-date):
    // https://en.numista.com/catalogue/argentina-5.html
    // Denominación - Modelo / Referencias:
    // - 0.01 Peso (Bronce de aluminio - Laurel): https://en.numista.com/catalogue/pieces2215.html
    // - 0.05 Peso (Bronce de aluminio / Acero bañado en latón - Sol de Mayo): https://en.numista.com/catalogue/pieces2216.html
    // - 0.10 Peso (Bronce de aluminio / Acero bañado en latón - Escudo Nacional): https://en.numista.com/catalogue/pieces2217.html
    // - 0.25 Peso (Bronce de aluminio / Cuproníquel - Cabildo de Buenos Aires): https://en.numista.com/catalogue/pieces2218.html
    // - 0.50 Peso (Bronce de aluminio - Casa de Tucumán / Conmemorativas UNICEF / Voto Femenino): https://en.numista.com/catalogue/pieces2219.html
    // - 1 Peso (Bimetálica Anillo Bronce-Aluminio / Núcleo Cuproníquel - Primera Moneda Patria 1813 / Serie Bicentenario Mayo 2010): https://en.numista.com/catalogue/pieces2220.html
    // - 2 Pesos (Bimetálica Anillo Cuproníquel / Núcleo Bronce-Aluminio - Sol de Mayo / Malvinas / Bandera / Independencia): https://en.numista.com/catalogue/pieces25000.html
    NumismaticEmissionRuleData(
      country: 'Argentina',
      minYear: 1992,
      maxYear: 2016,
      validCurrencies: ['ARS'],
      defaultCurrency: 'ARS',
      denominations: ['0.01', '0.05', '0.10', '0.25', '0.50', '1', '2'],
      denominationMaterials: {
        '0.01': 'Bronce de aluminio',
        '0.05': 'Bronce de aluminio',
        '0.10': 'Bronce de aluminio',
        '0.25': 'Bronce de aluminio',
        '0.50': 'Bronce de aluminio',
        '1': 'Bimetálica',
        '2': 'Bimetálica',
      },
      commemorativeMotifsByDenomination: {
        '0.50': [
          'Convención Nacional Constituyente (1994)',
          '50 Aniversario de UNICEF (1994)',
          '50 Aniversario del Voto Femenino (1997)',
          'Mercosur (1998)',
          'Centenario del Natalicio de Jorge Luis Borges (1999)',
          'Fallecimiento de Eva Perón - 50 Aniversario (2002)',
        ],
        '1': [
          'Bicentenario de la Revolución de Mayo - Pucará de Tilcara (2010)',
          'Bicentenario de la Revolución de Mayo - El Palmar (2010)',
          'Bicentenario de la Revolución de Mayo - Aconcagua (2010)',
          'Bicentenario de la Revolución de Mayo - Mar del Plata (2010)',
          'Bicentenario de la Revolución de Mayo - Glaciar Perito Moreno (2010)',
          'Bicentenario de la Primera Moneda Patria - Asamblea del Año XIII (2013)',
          '50 Aniversario de UNICEF (1994)',
          '30 Aniversario de la Carta de las Naciones Unidas (1995)',
          'Mercosur (1998)',
          'Centenario del Natalicio de Jorge Luis Borges (1999)',
        ],
        '2': [
          'Bicentenario de la Creación de la Bandera Nacional (2012)',
          '30 Aniversario de la Guerra de Malvinas (2012)',
          'Bicentenario de la Declaración de la Independencia (2016)',
          'Centenario del Descubrimiento del Petróleo en Argentina (2007)',
          'Centenario del Vuelo de Jorge Newbery (2014)',
          'Bicentenario del Combate de San Lorenzo (2013)',
          'Bicentenario del Cruce de los Andes (2017)',
          '70 Aniversario de los Derechos Políticos de la Mujer (2017)',
        ],
      },
      commemorativeReasons: [
        'Bicentenario de la Revolución de Mayo (2010)',
        'Bicentenario de la Primera Moneda Patria (2013)',
        'Guerra de Malvinas (2012)',
        'Bicentenario de la Independencia (2016)',
      ],
    ),

    // 8.7 Argentina - Serie "Árboles de la República Argentina" (2017–presente)
    // Ref General: Banco Central de la República Argentina - Línea Peso Árboles:
    // https://www.bcra.gob.ar/mediospago/nueva_familia_arboles.asp
    // Denominación - Modelo / Referencias:
    // - 1 Peso (Acero bañado en cobre - Jacarandá): https://en.numista.com/catalogue/pieces125867.html
    // - 2 Pesos (Acero bañado en latón - Palo Borracho): https://en.numista.com/catalogue/pieces146197.html
    // - 5 Pesos (Acero bañado en níquel - Arrayán): https://en.numista.com/catalogue/pieces125869.html
    // - 10 Pesos (Alpaca - Caldén): https://en.numista.com/catalogue/pieces146199.html
    NumismaticEmissionRuleData(
      country: 'Argentina',
      minYear: 2017,
      maxYear: 2100,
      validCurrencies: ['ARS'],
      defaultCurrency: 'ARS',
      denominations: ['1', '2', '5', '10'],
      denominationMaterials: {
        '1': 'Acero bañado en cobre',
        '2': 'Acero bañado en latón',
        '5': 'Acero bañado en níquel',
        '10': 'Alpaca (Plata alemana)',
      },
      commemorativeMotifsByDenomination: {
        '1': ['Jacarandá (Jacaranda mimosifolia)'],
        '2': ['Palo Borracho (Ceiba speciosa)'],
        '5': ['Arrayán (Luma apiculata)'],
        '10': ['Caldén (Prosopis caldenia)'],
      },
      commemorativeReasons: [
        'Serie Árboles de la República Argentina',
      ],
    ),

    // =========================================================================
    // 9. BRASIL
    // =========================================================================

    // 9.1 Brasil - Período Colonial e Imperial (1500–1941)
    // Ref General: Banco Central do Brasil - Museu de Valores: https://www.bcb.gov.br
    // Ref General: Numista - Brazil - Real / Réis (1500-1942):
    // https://en.numista.com/catalogue/brazil-1.html
    // Denominación - Modelo / Referencias:
    // - 10, 20, 40, 80 Réis (Cobre / Bronce - Escudo Imperial): https://en.numista.com/catalogue/pieces15130.html
    // - 100, 200, 300, 400 Réis (Cuproníquel - República / Busto da República): https://en.numista.com/catalogue/pieces7200.html
    // - 500, 640, 960, 1000, 2000 Réis (Plata Ley .917 / .900 / .500 - Patacão / D. Pedro II): https://en.numista.com/catalogue/pieces7201.html
    NumismaticEmissionRuleData(
      country: 'Brasil',
      minYear: 1500,
      maxYear: 1941,
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
        '960': 'Plata',
        '1000': 'Plata',
        '2000': 'Plata',
      },
    ),

    // 9.2 Brasil - Cruzeiro (1942–1985)
    // Ref General: Banco Central do Brasil - Museu de Valores: https://www.bcb.gov.br
    // Ref General: Numista - Brazil - Cruzeiro (1942-1986):
    // https://en.numista.com/catalogue/brazil-2.html
    // Denominación - Modelo / Referencias:
    // - 0.10, 0.20, 0.50, 1, 2 Cruzeiros (Bronce de aluminio - Getúlio Vargas / Mapa do Brasil / Tamandaré): https://en.numista.com/catalogue/pieces7210.html
    // - 5, 10, 20, 50 Cruzeiros (Cuproníquel - Sesquicentenário da Independência 1972 / Santos Dumont): https://en.numista.com/catalogue/pieces7211.html
    NumismaticEmissionRuleData(
      country: 'Brasil',
      minYear: 1942,
      maxYear: 1985,
      validCurrencies: ['BRB', 'BRC'],
      defaultCurrency: 'BRB',
      denominations: ['0.10', '0.20', '0.50', '1', '2', '5', '10', '20', '50'],
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
      },
      commemorativeMotifsByDenomination: {
        '5': ['Sesquicentenário da Independência do Brasil (1972)'],
        '10': ['Sesquicentenário da Independência do Brasil (1972)'],
        '20': ['Sesquicentenário da Independência do Brasil (1972)', 'Centenário da Imigração Italiana (1975)'],
      },
      commemorativeReasons: [
        'Sesquicentenário da Independência do Brasil (1972)',
      ],
    ),

    // 9.3 Brasil - Cruzado, Cruzado Novo y Cruzeiro Real (1986–1993)
    // Ref General: Banco Central do Brasil: https://www.bcb.gov.br
    // Ref General: Numista - Brazil - Cruzado & Cruzeiro Real (1986-1993):
    // https://en.numista.com/catalogue/brazil-2.html
    // Denominación - Modelo / Referencias:
    // - 0.01 a 50 Cruzados/Cruzeiros (Acero inoxidable - Peixe-boi, Garça, Seringueiro, Gaúcho, Baiana): https://en.numista.com/catalogue/pieces7215.html
    // - 100, 200 Cruzados (Acero inoxidable - Centenário da Abolição da Escravidão / Centenário da República): https://en.numista.com/catalogue/pieces7216.html
    // - 500, 1000, 5000 Cruzeiros Reais (Acero inoxidable - Peixe-boi / Gaúcho): https://en.numista.com/catalogue/pieces7217.html
    NumismaticEmissionRuleData(
      country: 'Brasil',
      minYear: 1986,
      maxYear: 1993,
      validCurrencies: ['BRN', 'BRE', 'BRR'],
      defaultCurrency: 'BRN',
      denominations: ['0.01', '0.05', '0.10', '0.50', '1', '5', '10', '50', '100', '200', '500', '1000', '5000'],
      denominationMaterials: {
        '0.01': 'Acero inoxidable',
        '0.05': 'Acero inoxidable',
        '0.10': 'Acero inoxidable',
        '0.50': 'Acero inoxidable',
        '1': 'Acero inoxidable',
        '5': 'Acero inoxidable',
        '10': 'Acero inoxidable',
        '50': 'Acero inoxidable',
        '100': 'Acero inoxidable',
        '200': 'Acero inoxidable',
        '500': 'Acero inoxidable',
        '1000': 'Acero inoxidable',
        '5000': 'Acero inoxidable',
      },
      commemorativeMotifsByDenomination: {
        '100': ['Centenário da Abolição da Escravidão - Lei Áurea (1988)'],
        '200': ['Centenário da Proclamação da República (1989)'],
      },
      commemorativeReasons: [
        'Centenário da Abolição da Escravidão (1988)',
        'Centenário da Proclamação da República (1989)',
      ],
    ),

    // 9.4 Brasil - Real 1ª Familia Acero Inoxidable (1994–1997)
    // Ref General: Banco Central do Brasil - Moedas do Real:
    // https://www.bcb.gov.br/cedulasemoedas/moedasreal
    // Ref General: Numista - Brazil - Real 1st Family (1994-1997):
    // https://en.numista.com/catalogue/brazil-3.html
    // Denominación - Modelo / Referencias:
    // - 0.01 Real (Acero inoxidable - Efígie da República): https://en.numista.com/catalogue/pieces2257.html
    // - 0.05 Real (Acero inoxidable - Efígie da República): https://en.numista.com/catalogue/pieces2258.html
    // - 0.10 Real (Acero inoxidable - Efígie da República / 50 Anos da FAO 1995): https://en.numista.com/catalogue/pieces2259.html
    // - 0.25 Real (Acero inoxidable - Efígie da República / 50 Anos da FAO 1995): https://en.numista.com/catalogue/pieces2260.html
    // - 0.50 Real (Acero inoxidable - Efígie da República): https://en.numista.com/catalogue/pieces2261.html
    // - 1 Real (Acero inoxidable - Efígie da República / 30 Anos do Banco Central 1995): https://en.numista.com/catalogue/pieces2262.html
    NumismaticEmissionRuleData(
      country: 'Brasil',
      minYear: 1994,
      maxYear: 1997,
      validCurrencies: ['BRL'],
      defaultCurrency: 'BRL',
      denominations: ['0.01', '0.05', '0.10', '0.25', '0.50', '1'],
      denominationMaterials: {
        '0.01': 'Acero inoxidable',
        '0.05': 'Acero inoxidable',
        '0.10': 'Acero inoxidable',
        '0.25': 'Acero inoxidable',
        '0.50': 'Acero inoxidable',
        '1': 'Acero inoxidable',
      },
      commemorativeMotifsByDenomination: {
        '0.10': ['FAO - 50 Anos da FAO (1995)'],
        '0.25': ['FAO - 50 Anos da FAO (1995)'],
        '1': ['30 Anos do Banco Central do Brasil (1995)'],
      },
      commemorativeReasons: [
        '50 Anos da FAO (1995)',
        '30 Anos do Banco Central do Brasil (1995)',
      ],
    ),

    // 9.5 Brasil - Real 2ª Familia Bimetálica y Recubrimientos (1998–presente)
    // Ref General: Banco Central do Brasil - Moedas do Real:
    // https://www.bcb.gov.br/cedulasemoedas/moedasreal
    // Ref General: Numista - Brazil - Real 2nd Family (1998-date):
    // https://en.numista.com/catalogue/brazil-3.html
    // Denominación - Modelo / Referencias:
    // - 0.01 Real (Acero bañado en cobre - Pedro Álvares Cabral): https://en.numista.com/catalogue/pieces2263.html
    // - 0.05 Real (Acero bañado en cobre - Tiradentes): https://en.numista.com/catalogue/pieces2264.html
    // - 0.10 Real (Acero bañado en bronce - D. Pedro I): https://en.numista.com/catalogue/pieces2265.html
    // - 0.25 Real (Acero bañado en bronce - Manuel Deodoro da Fonseca): https://en.numista.com/catalogue/pieces2266.html
    // - 0.50 Real (Cuproníquel / Acero inoxidable - Barão do Rio Branco): https://en.numista.com/catalogue/pieces2267.html
    // - 1 Real (Bimetálica Anillo Acero Inox / Centro Acero bañado en bronce - Efígie da República / Série Rio 2016 e Históricas): https://en.numista.com/catalogue/pieces2268.html
    NumismaticEmissionRuleData(
      country: 'Brasil',
      minYear: 1998,
      maxYear: 2100,
      validCurrencies: ['BRL'],
      defaultCurrency: 'BRL',
      denominations: ['0.01', '0.05', '0.10', '0.25', '0.50', '1'],
      denominationMaterials: {
        '0.01': 'Acero bañado en cobre',
        '0.05': 'Acero bañado en cobre',
        '0.10': 'Acero bañado en bronce',
        '0.25': 'Acero bañado en bronce',
        '0.50': 'Cuproníquel',
        '1': 'Bimetálica',
      },
      commemorativeMotifsByDenomination: {
        '1': [
          '50 Aniversario de la Declaración Universal de los Derechos Humanos (1998)',
          'Centenario de Juscelino Kubitschek (2002)',
          '40 Aniversario del Banco Central do Brasil (2005)',
          'Centenario de la Inmigración Japonesa a Brasil (2008)',
          'Entrega de la Bandera Olímpica - Londres 2012 a Río 2016 (2012)',
          '50 Aniversario del Banco Central do Brasil (2015)',
          '25 Años del Plano Real (2019)',
          'Juegos Olímpicos y Paralímpicos Río 2016 - Atletismo (2014)',
          'Juegos Olímpicos y Paralímpicos Río 2016 - Natación (2014)',
          'Juegos Olímpicos y Paralímpicos Río 2016 - Paratriatlón (2014)',
          'Juegos Olímpicos y Paralímpicos Río 2016 - Golf (2014)',
          'Juegos Olímpicos y Paralímpicos Río 2016 - Baloncesto (2015)',
          'Juegos Olímpicos y Paralímpicos Río 2016 - Vela (2015)',
          'Juegos Olímpicos y Paralímpicos Río 2016 - Paracanotaje (2015)',
          'Juegos Olímpicos y Paralímpicos Río 2016 - Rugby (2015)',
          'Juegos Olímpicos y Paralímpicos Río 2016 - Fútbol (2015)',
          'Juegos Olímpicos y Paralímpicos Río 2016 - Voleibol (2015)',
          'Juegos Olímpicos y Paralímpicos Río 2016 - Atletismo Paralímpico (2015)',
          'Juegos Olímpicos y Paralímpicos Río 2016 - Judo (2015)',
          'Juegos Olímpicos y Paralímpicos Río 2016 - Boxeo (2016)',
          'Juegos Olímpicos y Paralímpicos Río 2016 - Natación Paralímpica (2016)',
          'Juegos Olímpicos y Paralímpicos Río 2016 - Mascota Olímpica Vinicius (2016)',
          'Juegos Olímpicos y Paralímpicos Río 2016 - Mascota Paralímpica Tom (2016)',
        ],
      },
      commemorativeReasons: [
        'Derechos Humanos (1998)',
        'Centenario de JK (2002)',
        'Banco Central do Brasil',
        'Juegos Olímpicos Río 2016',
        '25 Años Plano Real (2019)',
      ],
    ),

    // =========================================================================
    // 10. CHILE
    // =========================================================================

    // 10.1 Chile - Período Colonial y Reales (1500–1850)
    // Ref General: Banco Central de Chile - Historia Numismática: https://www.bcentral.cl
    // Ref General: Numista - Chile - Real (1743-1851):
    // https://en.numista.com/catalogue/chile-1.html
    // Denominación - Modelo / Referencias:
    // - 1/4 Real (Plata Ley .896 - Cuartilla de Plata / Columna): https://en.numista.com/catalogue/pieces15104.html
    // - 1/2 Real (Plata Ley .896 - Busto Carlos IV / Fernando VII): https://en.numista.com/catalogue/pieces15105.html
    // - 1 Real (Plata Ley .896 - Busto y Columnarias de Santiago): https://en.numista.com/catalogue/pieces15106.html
    // - 2 Reales (Plata Ley .896 - Escudo Colonial / República de Chile Volcán): https://en.numista.com/catalogue/pieces15107.html
    // - 4 Reales (Plata Ley .896 - Busto y Escudo Real): https://en.numista.com/catalogue/pieces15108.html
    // - 8 Reales (Plata Ley .896 - Peso de Santiago / Volcán / Columna de la Libertad): https://en.numista.com/catalogue/pieces15109.html
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

    // 10.2 Chile - Peso Antiguo Decimal (1851–1959)
    // Ref General: Banco Central de Chile - Billetes y Monedas: https://www.bcentral.cl
    // Ref General: Numista - Chile - Peso (1851-1959):
    // https://en.numista.com/catalogue/chile-2.html
    // Denominación - Modelo / Referencias:
    // - 0.005, 0.01, 0.02 Peso (Cobre - Cóndor sobre roca): https://en.numista.com/catalogue/pieces15110.html
    // - 0.05, 0.10, 0.20 Peso (Cuproníquel / Plata - Cóndor / Escudo Nacional): https://en.numista.com/catalogue/pieces15111.html
    // - 0.50, 1 Peso (Plata Ley .900 / .500 - Cóndor andino / Busto de Bernardo O'Higgins): https://en.numista.com/catalogue/pieces15112.html
    // - 2, 5, 10, 20, 50, 100 Pesos (Oro Ley .900 - Busto alegórico de la República): https://en.numista.com/catalogue/pieces15113.html
    NumismaticEmissionRuleData(
      country: 'Chile',
      minYear: 1851,
      maxYear: 1959,
      validCurrencies: ['CLF'],
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

    // 10.3 Chile - Escudo Chileno (1960–1974)
    // Ref General: Banco Central de Chile: https://www.bcentral.cl
    // Ref General: Numista - Chile - Escudo (1960-1975):
    // https://en.numista.com/catalogue/chile-2.html
    // Denominación - Modelo / Referencias:
    // - 0.005, 0.01, 0.02, 0.05 Escudo (Aluminio - Cóndor): https://en.numista.com/catalogue/pieces15114.html
    // - 0.10, 0.20 Escudo (Bronce de aluminio - Bernardo O'Higgins): https://en.numista.com/catalogue/pieces15115.html
    // - 0.50, 1, 2, 5, 10, 50, 100 Escudos (Cuproníquel / Bronce - Bernardo O'Higgins / Escudo Nacional): https://en.numista.com/catalogue/pieces15116.html
    NumismaticEmissionRuleData(
      country: 'Chile',
      minYear: 1960,
      maxYear: 1974,
      validCurrencies: ['CLE'],
      defaultCurrency: 'CLE',
      denominations: ['0.005', '0.01', '0.02', '0.05', '0.10', '0.20', '0.50', '1', '2', '5', '10', '50', '100'],
      denominationMaterials: {
        '0.005': 'Aluminio',
        '0.01': 'Aluminio',
        '0.02': 'Aluminio',
        '0.05': 'Aluminio',
        '0.10': 'Bronce de aluminio',
        '0.20': 'Bronce de aluminio',
        '0.50': 'Cuproníquel',
        '1': 'Cuproníquel',
        '2': 'Cuproníquel',
        '5': 'Cuproníquel',
        '10': 'Cuproníquel',
        '50': 'Cuproníquel',
        '100': 'Cuproníquel',
      },
    ),

    // 10.4 Chile - Peso Actual (1975–presente)
    // Ref General: Banco Central de Chile - Monedas en circulación:
    // https://www.bcentral.cl/billetes-y-monedas/monedas
    // Ref General: Numista - Chile - Peso (1975-date):
    // https://en.numista.com/catalogue/chile-3.html
    // Denominación - Modelo / Referencias:
    // - 1 Peso (Aluminio / Bronce de aluminio - Bernardo O'Higgins): https://en.numista.com/catalogue/pieces1588.html
    // - 5 Pesos (Bronce de aluminio - Bernardo O'Higgins / Forma octogonal): https://en.numista.com/catalogue/pieces1589.html
    // - 10 Pesos (Bronce de aluminio - Bernardo O'Higgins / Ángel de la Libertad): https://en.numista.com/catalogue/pieces1590.html
    // - 50 Pesos (Bronce de aluminio - Bernardo O'Higgins / Forma decagonal): https://en.numista.com/catalogue/pieces1591.html
    // - 100 Pesos (Bimetálica Anillo Bronce-Aluminio / Centro Alpaca - Pueblos Originarios Mujer Mapuche / Escudo 8 Lados): https://en.numista.com/catalogue/pieces1592.html
    // - 500 Pesos (Bimetálica Anillo Alpaca / Centro Bronce-Aluminio - Cardenal Raúl Silva Henríquez): https://en.numista.com/catalogue/pieces1593.html
    NumismaticEmissionRuleData(
      country: 'Chile',
      minYear: 1975,
      maxYear: 2100,
      validCurrencies: ['CLP'],
      defaultCurrency: 'CLP',
      denominations: ['1', '5', '10', '50', '100', '500'],
      denominationMaterials: {
        '1': 'Aluminio',
        '5': 'Bronce de aluminio',
        '10': 'Bronce de aluminio',
        '50': 'Bronce de aluminio',
        '100': 'Bimetálica',
        '500': 'Bimetálica',
      },
      denominationAllowedMaterials: {
        '5': ['Bronce de aluminio', 'Aluminio-Bronce'],
        '10': ['Bronce de aluminio', 'Aluminio-Bronce'],
        '50': ['Bronce de aluminio', 'Aluminio-Bronce'],
      },
      commemorativeMotifsByDenomination: {
        '10': [
          'Bernardo O\'Higgins',
          'Ángel de la Libertad (1976-1990)',
        ],
        '50': [
          'Bernardo O\'Higgins (Forma Decagonal)',
        ],
        '100': [
          'Pueblos Originarios - Mujer Mapuche',
          'Escudo Nacional de 8 Lados (1981-2000)',
        ],
        '500': [
          'Cardenal Raúl Silva Henríquez',
        ],
      },
      commemorativeReasons: [
        'Pueblos Originarios de Chile',
        'Cardenal Raúl Silva Henríquez',
        'Ángel de la Libertad',
      ],
    ),

    // =========================================================================
    // 11. PERÚ
    // =========================================================================

    // 11.1 Perú - Época Colonial y Reales (1500–1862)
    // Ref General: Banco Central de Reserva del Perú - Numismática Colonial: https://www.bcrp.gob.pe
    // Ref General: Numista - Peru - Real (1568-1857):
    // https://en.numista.com/catalogue/peru-1.html
    // Denominación - Modelo / Referencias:
    // - 1/4 Real (Plata Ley .896 - Cuartillo de Plata de Lima): https://en.numista.com/catalogue/pieces15117.html
    // - 1/2 Real (Plata Ley .896 - Columnarias de Lima / Monograma): https://en.numista.com/catalogue/pieces15118.html
    // - 1 Real (Plata Ley .896 - Busto Carlos III / Carlos IV / Fernando VII): https://en.numista.com/catalogue/pieces15119.html
    // - 2 Reales (Plata Ley .896 - Busto y Escudo Real de Lima): https://en.numista.com/catalogue/pieces15120.html
    // - 4 Reales (Plata Ley .896 - Escudo Coronadas): https://en.numista.com/catalogue/pieces15121.html
    // - 8 Reales (Plata Ley .896 - Real de a Ocho / Firme y Feliz por la Unión): https://en.numista.com/catalogue/pieces15122.html
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

    // 11.2 Perú - Sol de Oro (1863–1984)
    // Ref General: Banco Central de Reserva del Perú - Numismática: https://www.bcrp.gob.pe
    // Ref General: Numista - Peru - Sol de Oro (1863-1985):
    // https://en.numista.com/catalogue/peru-2.html
    // Denominación - Modelo / Referencias:
    // - 0.01, 0.02 Sol (Cobre / Bronce - Dos Centavos / Un Centavo): https://en.numista.com/catalogue/pieces15123.html
    // - 0.05, 0.10, 0.20 Sol (Latón / Cuproníquel - Escudo Nacional): https://en.numista.com/catalogue/pieces15124.html
    // - 0.50, 1 Sol (Plata Ley .900 / .500 / Latón - Firme y Feliz por la Unión / Libertad Parada / Túpac Amaru II): https://en.numista.com/catalogue/pieces15125.html
    // - 2, 5, 10, 20, 50, 100 Soles (Oro Ley .900 / Cuproníquel - Libra Peruana / Almirante Miguel Grau / Túpac Amaru): https://en.numista.com/catalogue/pieces15126.html
    NumismaticEmissionRuleData(
      country: 'Perú',
      minYear: 1863,
      maxYear: 1984,
      validCurrencies: ['PEH'],
      defaultCurrency: 'PEH',
      denominations: ['0.01', '0.02', '0.05', '0.10', '0.20', '0.50', '1', '2', '5', '10', '20', '50', '100'],
      denominationMaterials: {
        '0.01': 'Cobre',
        '0.02': 'Cobre',
        '0.05': 'Latón',
        '0.10': 'Latón',
        '0.20': 'Latón',
        '0.50': 'Plata',
        '1': 'Plata',
        '2': 'Oro',
        '5': 'Oro',
        '10': 'Oro',
        '20': 'Oro',
        '50': 'Oro',
        '100': 'Oro',
      },
      commemorativeMotifsByDenomination: {
        '1': ['Libertad Parada', 'Túpac Amaru II (1970-1977)'],
        '5': ['Almirante Miguel Grau'],
        '10': ['Túpac Amaru II'],
        '100': ['Centenario de la Guerra del Pacífico (1979)'],
      },
    ),

    // 11.3 Perú - Inti (1985–1990)
    // Ref General: Banco Central de Reserva del Perú: https://www.bcrp.gob.pe
    // Ref General: Numista - Peru - Inti (1985-1991):
    // https://en.numista.com/catalogue/peru-2.html
    // Denominación - Modelo / Referencias:
    // - 0.01, 0.05 Inti (Aluminio - Miguel Grau): https://en.numista.com/catalogue/pieces15127.html
    // - 0.10, 0.50, 1 Inti (Latón - Miguel Grau): https://en.numista.com/catalogue/pieces15128.html
    // - 5, 10, 50, 100, 500 Intis (Cuproníquel / Latón - Gran Almirante Miguel Grau / César Vallejo / Andrés Avelino Cáceres): https://en.numista.com/catalogue/pieces15129.html
    NumismaticEmissionRuleData(
      country: 'Perú',
      minYear: 1985,
      maxYear: 1990,
      validCurrencies: ['PEI'],
      defaultCurrency: 'PEI',
      denominations: ['0.01', '0.05', '0.10', '0.50', '1', '5', '10', '50', '100', '500'],
      denominationMaterials: {
        '0.01': 'Aluminio',
        '0.05': 'Aluminio',
        '0.10': 'Latón',
        '0.50': 'Latón',
        '1': 'Latón',
        '5': 'Cuproníquel',
        '10': 'Cuproníquel',
        '50': 'Cuproníquel',
        '100': 'Cuproníquel',
        '500': 'Cuproníquel',
      },
      commemorativeMotifsByDenomination: {
        '1': ['Gran Almirante Miguel Grau'],
        '5': ['Gran Almirante Miguel Grau'],
        '50': ['Andrés Avelino Cáceres'],
        '100': ['César Vallejo'],
      },
    ),

    // 11.4 Perú - Sol Moderno (1991–presente)
    // Ref General: Banco Central de Reserva del Perú - Familia de Monedas:
    // https://www.bcrp.gob.pe/billetes-y-monedas/monedas.html
    // Ref General: Numista - Peru - Sol (1991-date):
    // https://en.numista.com/catalogue/peru-3.html
    // Denominación - Modelo / Referencias:
    // - 0.01, 0.05 Sol (Aluminio - Diseños Precolombinos / Escudo Nacional): https://en.numista.com/catalogue/pieces4951.html
    // - 0.10, 0.20 Sol (Latón - Diseños de Chan Chan / Escudo Nacional): https://en.numista.com/catalogue/pieces4952.html
    // - 0.50 Sol (Alpaca - Diseños Precolombinos): https://en.numista.com/catalogue/pieces4953.html
    // - 1 Sol (Alpaca - Escudo Nacional / Serie Riqueza y Orgullo / Serie Fauna / Serie Constructores / Serie Mujeres): https://en.numista.com/catalogue/pieces4954.html
    // - 2 Soles (Bimetálica Anillo Acero / Núcleo Latón - Colibrí de las Líneas de Nazca): https://en.numista.com/catalogue/pieces4955.html
    // - 5 Soles (Bimetálica Anillo Acero / Núcleo Latón - Ave Fragata de las Líneas de Nazca): https://en.numista.com/catalogue/pieces4956.html
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
        '1': 'Alpaca (Plata alemana)',
        '2': 'Bimetálica',
        '5': 'Bimetálica',
      },
      commemorativeMotifsByDenomination: {
        '1': [
          // Serie Riqueza y Orgullo del Perú (26 motivos)
          'Tumi de Oro (Lambayeque)',
          'Sarcófagos de Karajía (Amazonas)',
          'Estela de Raimondi (Áncash)',
          'Chullpas de Sillustani (Puno)',
          'Monasterio de Santa Catalina (Arequipa)',
          'Machu Picchu (Cusco)',
          'Gran Pajatén (San Martín)',
          'Piedra de Saywite (Apurímac)',
          'Fortaleza del Real Felipe (Callao)',
          'Templo del Sol - Vilcashuamán (Ayacucho)',
          'Kuntur Wasi (Cajamarca)',
          'Templo Inca Huaytará (Huancavelica)',
          'Complejo Arqueológico de Kotosh (Huánuco)',
          'Arte Textil Paracas (Ica)',
          'Complejo Arqueológico de Tunanmarca (Junín)',
          'Ciudad Sagrada de Caral (Lima)',
          'Huaca de la Luna (La Libertad)',
          'Antiguo Hotel Palace (Loreto)',
          'Catedral de Lima (Lima)',
          'Petroglifos de Pusharo (Madre de Dios)',
          'Arquitectura Moqueguana (Moquegua)',
          'Sitio Arqueológico de Huarautambo (Pasco)',
          'Complejo Arqueológico de Cabeza de Vaca (Tumbes)',
          'Cerámica Vicús (Piura)',
          'Cerámica Shipibo-Konibo (Ucayali)',
          'Arco Parabólico de Tacna (Tacna)',
          // Serie Recursos Naturales del Perú (3 motivos)
          'La Anchoveta (Engraulis ringens)',
          'El Cacao (Theobroma cacao)',
          'La Quinua (Chenopodium quinoa)',
          // Serie Fauna Silvestre Amenazada del Perú (10 motivos)
          'Oso Andino de Anteojos (Tremarctos ornatus)',
          'Cocodrilo de Tumbes (Crocodylus acutus)',
          'Cóndor Andino (Vultur gryphus)',
          'Tapir Andino (Tapirus pinchaque)',
          'Pava Aliblanca (Penelope albipennis)',
          'Jaguar (Panthera onca)',
          'Suri (Rhea pennata)',
          'Mono Choro de Cola Amarilla (Lagothrix flavicauda)',
          'Gato Andino (Leopardus jacobita)',
          'Rana Gigante del Titicaca (Telmatobius culeus)',
          // Serie Constructores de la República Bicentenario 1821-2021 (9 motivos)
          'Juan Pablo Viscardo y Guzmán',
          'Hipólito Unanue',
          'Toribio Rodríguez de Mendoza',
          'Manuel Lorenzo de Vidaurre',
          'Francisco Xavier de Luna Pizarro',
          'José Baquíjano y Carrillo',
          'José Faustino Sánchez Carrión',
          'José de la Mar',
          'Mariano Melgar',
          // Serie La Mujer en el Proceso de Independencia del Perú (3 motivos)
          'Heroínas Toledo',
          'Brigida Silva de Ochoa',
          'María Parado de Bellido',
          // Conmemorativas Especiales
          'Bicentenario del Banco Central de Reserva del Perú (2022)',
          'Casa Nacional de Moneda - 450 Años (2015)',
        ],
      },
      commemorativeReasons: [
        'Serie Riqueza y Orgullo del Perú',
        'Serie Recursos Naturales del Perú',
        'Serie Fauna Silvestre Amenazada del Perú',
        'Serie Constructores de la República',
        'Serie La Mujer en el Proceso de Independencia',
      ],
    ),

    // =========================================================================
    // 12. REINO UNIDO
    // =========================================================================

    // 12.1 Reino Unido - Sistema Pre-Decimal (1500–1970)
    // Ref General: The Royal Mint - History of the Pre-decimal Coinage: https://www.royalmint.com
    // Ref General: Numista - United Kingdom - Pre-decimal (1500-1970):
    // https://en.numista.com/catalogue/united-kingdom-1.html
    // Denominación - Modelo / Referencias:
    // - 1/4 Penny (Farthing - Cobre / Bronce - Britannia / Wren): https://en.numista.com/catalogue/pieces15131.html
    // - 1/2 Penny (Halfpenny - Cobre / Bronce - Golden Hind): https://en.numista.com/catalogue/pieces15132.html
    // - 1 Penny (Cobre / Bronce - Britannia): https://en.numista.com/catalogue/pieces15133.html
    // - 3 Pence (Threepence - Níquel-Latón 12 Lados / Planta de cardo): https://en.numista.com/catalogue/pieces15134.html
    // - 6 Pence (Sixpence - Cuproníquel / Plata - Emblemas Florales Reales): https://en.numista.com/catalogue/pieces15135.html
    // - 2 Shillings (Florin / 2 - Cuproníquel / Plata - Escudos Tudor): https://en.numista.com/catalogue/pieces15137.html
    // - 2.5 Shillings (Half Crown / 2.5 - Cuproníquel / Plata - Escudo Real): https://en.numista.com/catalogue/pieces15138.html
    // - 5 Shillings (Crown / 5 - Cuproníquel / Plata - San Jorge y el Dragón): https://en.numista.com/catalogue/pieces15139.html
    NumismaticEmissionRuleData(
      country: 'Reino Unido',
      minYear: 1500,
      maxYear: 1970,
      validCurrencies: ['GBP_OLD'],
      defaultCurrency: 'GBP_OLD',
      denominations: ['1/4', '1/2', '1', '3', '6', '2', '2.5', '5'],
      denominationMaterials: {
        '1/4': 'Cobre',
        '1/2': 'Cobre',
        '1': 'Cobre',
        '3': 'Níquel-Latón',
        '6': 'Cuproníquel',
        '2': 'Cuproníquel',
        '2.5': 'Cuproníquel',
        '5': 'Cuproníquel',
      },
    ),

    // 12.2 Reino Unido - Sistema Decimal 1ª Fase (1971–2016)
    // Ref General: The Royal Mint - Round Pound and Decimal History:
    // https://www.royalmint.com/discover/uk-coins/coin-design-and-specifications/
    // Ref General: Numista - United Kingdom - Decimal (1971-date):
    // https://en.numista.com/catalogue/united-kingdom-2.html
    // Denominación - Modelo / Referencias:
    // - 0.005 Pound (Half New Penny - Bronce): https://en.numista.com/catalogue/pieces860.html
    // - 0.01 Pound (1 Penny - Bronce hasta 1991 / Acero bañado en cobre 1992+): https://en.numista.com/catalogue/pieces861.html
    // - 0.02 Pound (2 Pence - Bronce hasta 1991 / Acero bañado en cobre 1992+): https://en.numista.com/catalogue/pieces862.html
    // - 0.05 Pound (5 Pence - Cuproníquel hasta 2011 / Acero bañado en níquel 2011+): https://en.numista.com/catalogue/pieces863.html
    // - 0.10 Pound (10 Pence - Cuproníquel hasta 2011 / Acero bañado en níquel 2011+): https://en.numista.com/catalogue/pieces864.html
    // - 0.20 Pound (20 Pence - Cuproníquel / Rosa Tudor coronada): https://en.numista.com/catalogue/pieces865.html
    // - 0.50 Pound (50 Pence - Cuproníquel Heptagonal / Beatrix Potter / Kew Gardens / Olympics): https://en.numista.com/catalogue/pieces866.html
    // - 1 Pound (1 Pound Redonda - Níquel-Latón / Puentes / Ciudades / Flora heráldica): https://en.numista.com/catalogue/pieces1388.html
    // - 2 Pounds (2 Pounds Bimetálica Anillo Níquel-Latón / Núcleo Cuproníquel - Historia y Ciencia): https://en.numista.com/catalogue/pieces1389.html
    // - 5 Pounds (Crown - Cuproníquel / Jubileos Reales y Bodas): https://en.numista.com/catalogue/pieces1390.html
    NumismaticEmissionRuleData(
      country: 'Reino Unido',
      minYear: 1971,
      maxYear: 2016,
      validCurrencies: ['GBP'],
      defaultCurrency: 'GBP',
      denominations: ['0.005', '0.01', '0.02', '0.05', '0.10', '0.20', '0.50', '1', '2', '5'],
      denominationMaterials: {
        '0.005': 'Bronce',
        '0.01': 'Acero bañado en cobre',
        '0.02': 'Acero bañado en cobre',
        '0.05': 'Acero bañado en níquel',
        '0.10': 'Acero bañado en níquel',
        '0.20': 'Cuproníquel',
        '0.50': 'Cuproníquel',
        '1': 'Níquel-Latón',
        '2': 'Bimetálica',
        '5': 'Cuproníquel',
      },
      denominationAllowedMaterials: {
        '0.01': ['Acero bañado en cobre', 'Bronce'],
        '0.02': ['Acero bañado en cobre', 'Bronce'],
        '0.05': ['Acero bañado en níquel', 'Cuproníquel'],
        '0.10': ['Acero bañado en níquel', 'Cuproníquel'],
      },
      commemorativeMotifsByDenomination: {
        '0.50': [
          'Ingreso a la Comunidad Económica Europea EEC (1973)',
          'Presidencia Británica de la CEE (1992-1993)',
          '50 Aniversario del Día D desembarco de Normandía (1994)',
          '50 Aniversario del NHS Servicio Nacional de Salud (1998)',
          '25 Aniversario de la Adhesión a la CEE (1998)',
          'Fundación de las Public Libraries (2000)',
          'Centenario de la Suffragette WSPU (2003)',
          '50 Aniversario de la Milla de Roger Bannister (2004)',
          '250 Aniversario del Diccionario de Samuel Johnson (2005)',
          '150 Aniversario de la Victoria Cross (2006)',
          'Centenario del Movimiento Scout (2007)',
          '250 Aniversario de los Jardines de Kew - Kew Gardens (2009)',
          'Centenario de Girlguiding (2010)',
          'Juegos Olímpicos y Paralímpicos de Londres 2012 - 29 Deportes (2011)',
          'Centenario del Nacimiento de Benjamin Britten (2013)',
          'Juegos de la Commonwealth Glasgow 2014 (2014)',
          '75 Aniversario de la Batalla de Inglaterra (2015)',
          'Serie Beatrix Potter - Peter Rabbit (2016)',
          'Serie Beatrix Potter - Jemima Puddle-Duck (2016)',
          'Serie Beatrix Potter - Mrs. Tiggy-Winkle (2016)',
          'Serie Beatrix Potter - Squirrel Nutkin (2016)',
          'Centenario de la Batalla de Hastings (2016)',
        ],
        '1': [
          'Escudos de Armas del Reino Unido (1983, 1993, 2003, 2008)',
          'Cardo de Escocia (1984, 1989)',
          'Puerro de Gales (1985, 1990)',
          'Lino de Irlanda del Norte (1986, 1991)',
          'Roble de Inglaterra (1987, 1992)',
          'Puentes del Reino Unido (2004-2007)',
          'Ciudades Capitales del Reino Unido (2010-2011)',
          'Flora Heráldica Británica (2013-2014)',
        ],
        '2': [
          'Desarrollo de la Tecnología (1997+)',
          'Rugby World Cup (1999)',
          'Centenario de la Radio Transatlántica de Marconi (2001)',
          'Commonwealth Games Manchester (2002)',
          '50 Aniversario del Descubrimiento del ADN (2003)',
          '200 Aniversario de la Locomotora de Vapor de Trevithick (2004)',
          '400 Aniversario de la Conspiración de la Pólvora (2005)',
          '60 Aniversario del Fin de la Segunda Guerra Mundial (2005)',
          '200 Aniversario de Isambard Kingdom Brunel (2006)',
          'Bicentenario de la Abolición del Comercio de Esclavos (2007)',
          'Handover Olímpico Beijing a Londres (2008)',
          '200 Aniversario de Charles Darwin (2009)',
          '400 Aniversario de la Biblia King James (2011)',
          'Bicentenario de Charles Dickens (2012)',
          'Centenario de la Primera Guerra Mundial (2014-2018)',
          '800 Aniversario de la Carta Magna (2015)',
          '400 Aniversario de William Shakespeare (2016)',
        ],
      },
      commemorativeReasons: [
        'Beatrix Potter Series',
        'London 2012 Olympic Series',
        'Kew Gardens 250th Anniversary',
        'British History Commemoratives',
      ],
    ),

    // 12.3 Reino Unido - Sistema Decimal 2ª Fase Dodecagonal (2017–presente)
    // Ref General: The Royal Mint - 12-sided £1 Coin & Modern Commemoratives:
    // https://www.royalmint.com/discover/uk-coins/
    // Denominación - Modelo / Referencias:
    // - 0.01, 0.02 Pound (Acero bañado en cobre - Escudo Real): https://en.numista.com/catalogue/pieces861.html
    // - 0.05, 0.10 Pound (Acero bañado en níquel - Escudo Real): https://en.numista.com/catalogue/pieces863.html
    // - 0.20 Pound (Cuproníquel - Escudo Real): https://en.numista.com/catalogue/pieces865.html
    // - 0.50 Pound (Cuproníquel Heptagonal - Brexit / Dinosaurios / Pride / Carlos III): https://en.numista.com/catalogue/pieces866.html
    // - 1 Pound (Bimetálica 12 Lados Anillo Níquel-Latón / Centro Níquel - Nations of the Crown / Rey Carlos III Abejas): https://en.numista.com/catalogue/pieces100658.html
    // - 2 Pounds (Bimetálica Anillo Níquel-Latón / Centro Cuproníquel - Homenajes Históricos y Literarios): https://en.numista.com/catalogue/pieces1389.html
    // - 5 Pounds (Crown - Cuproníquel): https://en.numista.com/catalogue/pieces1390.html
    NumismaticEmissionRuleData(
      country: 'Reino Unido',
      minYear: 2017,
      maxYear: 2100,
      validCurrencies: ['GBP'],
      defaultCurrency: 'GBP',
      denominations: ['0.01', '0.02', '0.05', '0.10', '0.20', '0.50', '1', '2', '5'],
      denominationMaterials: {
        '0.01': 'Acero bañado en cobre',
        '0.02': 'Acero bañado en cobre',
        '0.05': 'Acero bañado en níquel',
        '0.10': 'Acero bañado en níquel',
        '0.20': 'Cuproníquel',
        '0.50': 'Cuproníquel',
        '1': 'Bimetálica',
        '2': 'Bimetálica',
        '5': 'Cuproníquel',
      },
      commemorativeMotifsByDenomination: {
        '0.50': [
          'Sir Isaac Newton (2017)',
          'Centenario de la Ley de Representación Popular (2018)',
          'Stephen Hawking (2019)',
          'Salida del Reino Unido de la Unión Europea - Brexit (2020)',
          'Dinosaurios de la Colección del Museo de Historia Natural - Megalosaurus (2020)',
          '50 Aniversario del Orgullo Gay - Pride UK (2022)',
          'Coronación del Rey Carlos III (2023)',
          'Homenaje a la Reina Isabel II (2022)',
        ],
        '1': [
          'Nations of the Crown (2017+)',
          'Flora y Fauna Británica - Abejas de Carlos III (2023+)',
        ],
        '2': [
          'Jane Austen (2017)',
          'Centenario de la RAF Royal Air Force (2018)',
          '75 Aniversario del Día D (2019)',
          '100 Años de Agatha Christie (2020)',
          '75 Aniversario de la Victoria en Europa VE Day (2020)',
          'Alexander Graham Bell (2022)',
          'J.R.R. Tolkien (2023)',
        ],
      },
      commemorativeReasons: [
        'Brexit (2020)',
        'Pride UK 50th Anniversary',
        'King Charles III Coronation',
        'British Cultural Icons',
      ],
    ),

    // =========================================================================
    // 13. FRANCIA
    // =========================================================================

    // 13.1 Francia - Ancien Régime (1500–1794)
    // Ref General: Monnaie de Paris - Histoire: https://www.monnaiedeparis.fr
    // Ref General: Numista - France - Royal (1500-1794):
    // https://en.numista.com/catalogue/france-royal-1.html
    // Denominación - Modelo / Referencias:
    // - 1/12, 1/6, 1/4 Écu/Sol (Cobre - Busto Real Louis XIV / Louis XV): https://en.numista.com/catalogue/pieces15140.html
    // - 1/2, 1, 3, 6 Livres/Écus (Plata Ley .917 / .900 - Busto Louis XVI / Escudo de Francia): https://en.numista.com/catalogue/pieces15141.html
    // - 2, 12, 24 Livres (Louis d'Or - Oro Ley .917): https://en.numista.com/catalogue/pieces15142.html
    NumismaticEmissionRuleData(
      country: 'Francia',
      minYear: 1500,
      maxYear: 1794,
      validCurrencies: ['LVT', 'ECU', 'LDO'],
      defaultCurrency: 'LVT',
      denominations: ['1/12', '1/6', '1/4', '1/2', '1', '2', '3', '6', '12', '24'],
      denominationMaterials: {
        '1/12': 'Cobre',
        '1/6': 'Cobre',
        '1/4': 'Cobre',
        '1/2': 'Plata',
        '1': 'Plata',
        '2': 'Oro',
        '3': 'Plata',
        '6': 'Plata',
        '12': 'Oro',
        '24': 'Oro',
      },
    ),

    // 13.2 Francia - Franc Ancien (1795–1959)
    // Ref General: Monnaie de Paris: https://www.monnaiedeparis.fr
    // Ref General: Numista - France - Franc (1795-1959):
    // https://en.numista.com/catalogue/france-1.html
    // Denominación - Modelo / Referencias:
    // - 0.01, 0.02 Franc (Bronce - Dupré / Marianne): https://en.numista.com/catalogue/pieces15143.html
    // - 0.05, 0.10, 0.20 Franc (Aluminio / Cuproníquel - Lindauer con agujero central): https://en.numista.com/catalogue/pieces15144.html
    // - 0.25 Franc (Cuproníquel - Lindauer): https://en.numista.com/catalogue/pieces15145.html
    // - 0.50, 1, 2 Francs (Aluminio-Bronce / Níquel - Morlon / Chambre de Commerce): https://en.numista.com/catalogue/pieces15146.html
    // - 5 Francs (Cuproníquel / Plata - Lavrillier / Tour Eiffel): https://en.numista.com/catalogue/pieces15147.html
    // - 10, 20 Francs (Plata / Cuproníquel - Turin / Guiraud): https://en.numista.com/catalogue/pieces15148.html
    // - 50, 100 Francs (Cuproníquel / Plata Ley .900 - Guiraud / Hercule): https://en.numista.com/catalogue/pieces15149.html
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
        '0.05': 'Aluminio',
        '0.10': 'Aluminio',
        '0.20': 'Aluminio',
        '0.25': 'Cuproníquel',
        '0.50': 'Aluminio-Bronce',
        '1': 'Aluminio-Bronce',
        '2': 'Aluminio-Bronce',
        '5': 'Cuproníquel',
        '10': 'Plata',
        '20': 'Plata',
        '50': 'Cuproníquel',
        '100': 'Cuproníquel',
      },
    ),

    // 13.3 Francia - Nouveau Franc (1960–2001)
    // Ref General: Monnaie de Paris - Le Nouveau Franc:
    // https://www.monnaiedeparis.fr
    // Ref General: Numista - France - Nouveau Franc (1960-2001):
    // https://en.numista.com/catalogue/france-2.html
    // Denominación - Modelo / Referencias:
    // - 0.01 Franc (Acero inoxidable - Épi de blé): https://en.numista.com/catalogue/pieces1.html
    // - 0.05, 0.10, 0.20 Franc (Bronce de aluminio - Marianne de Lagriffoul): https://en.numista.com/catalogue/pieces2.html
    // - 0.50, 1, 2 Francs (Níquel puro - La Semeuse de Roty): https://en.numista.com/catalogue/pieces3.html
    // - 5 Francs (Cuproníquel / Plata Ley .835 - La Semeuse / Tour Eiffel 1989): https://en.numista.com/catalogue/pieces6.html
    // - 10 Francs (Bimetálica Anillo Bronce-Aluminio / Núcleo Níquel - Génie de la Bastille / Conmemorativas): https://en.numista.com/catalogue/pieces9.html
    // - 20 Francs (Trimetálica Anillo Bronce-Aluminio / Centro Bimetálico - Mont-Saint-Michel / Jeux Méditerranéens): https://en.numista.com/catalogue/pieces10.html
    // - 50 Francs (Plata Ley .900 - Hercule de Dupré): https://en.numista.com/catalogue/pieces678.html
    // - 100 Francs (Plata Ley .900 - Marie Curie / Zola / Panthéon / Droits de l'Homme): https://en.numista.com/catalogue/pieces679.html
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
        '1': 'Níquel',
        '2': 'Níquel',
        '5': 'Cuproníquel',
        '10': 'Bimetálica',
        '20': 'Trimetálica',
        '50': 'Plata',
        '100': 'Plata',
      },
      commemorativeMotifsByDenomination: {
        '10': [
          'Génie de la Bastille',
          'Bicentenario de la Revolución Francesa (1989)',
          'Centenario de la Torre Eiffel (1989)',
          'Guglielmo Marconi (1992)',
          'Mont Saint-Michel (1992)',
          'Gaston Phébus (1994)',
          'Jean Monnet (1988)',
        ],
        '20': [
          'Mont Saint-Michel',
          'Juegos Olímpicos de Albertville 1992 - Pierre de Coubertin (1992)',
          'Juegos del Mediterráneo (1993)',
        ],
        '50': [
          'Hercule de Dupré (1974-1980)',
        ],
        '100': [
          'Marie Curie (1984)',
          'Émile Zola (1985)',
          'Estatua de la Libertad (1986)',
          'La Fayette (1987)',
          'Fraternité (1988)',
          'Droits de l\'Homme (1989)',
          'Charlemagne (1990)',
          'René Descartes (1991)',
          'Jean Monnet (1992)',
          'Liberté par Louvre (1993)',
          'André Malraux (1996)',
          'Clovis (1996)',
          'Paul Cézanne (1998)',
        ],
      },
      commemorativeReasons: [
        'Bicentenaire de la Révolution',
        'Hercule de Dupré',
        'Grands Personnages de France',
      ],
    ),

    // =========================================================================
    // 14. ALEMANIA
    // =========================================================================

    // 14.1 Alemania - Imperio Alemán Goldmark (1873–1923)
    // Ref General: Deutsche Bundesbank - Geldgeschichte: https://www.bundesbank.de
    // Ref General: Numista - Germany - Empire (1871-1918):
    // https://en.numista.com/catalogue/germany-1.html
    // Denominación - Modelo / Referencias:
    // - 0.01, 0.02 Mark (1 y 2 Pfennig - Cobre - Kaiserreich Adler): https://en.numista.com/catalogue/pieces15150.html
    // - 0.05, 0.10, 0.20 Mark (5, 10, 20 Pfennig - Cuproníquel): https://en.numista.com/catalogue/pieces15151.html
    // - 0.25 Mark (Níquel puro): https://en.numista.com/catalogue/pieces15152.html
    // - 0.50, 1, 2, 3, 5 Mark (Plata Ley .900 - Águila Imperial / Reyes y Príncipes de los Estados Alemanes): https://en.numista.com/catalogue/pieces15153.html
    // - 10, 20 Mark (Oro Ley .900 - Guillermo I / Guillermo II / Estados Alemanes): https://en.numista.com/catalogue/pieces15154.html
    NumismaticEmissionRuleData(
      country: 'Alemania',
      minYear: 1873,
      maxYear: 1923,
      validCurrencies: ['FRG', 'PRM'],
      defaultCurrency: 'FRG',
      denominations: ['0.01', '0.02', '0.05', '0.10', '0.20', '0.25', '0.50', '1', '2', '3', '5', '10', '20'],
      denominationMaterials: {
        '0.01': 'Cobre',
        '0.02': 'Cobre',
        '0.05': 'Cuproníquel',
        '0.10': 'Cuproníquel',
        '0.20': 'Cuproníquel',
        '0.25': 'Níquel',
        '0.50': 'Plata',
        '1': 'Plata',
        '2': 'Plata',
        '3': 'Plata',
        '5': 'Plata',
        '10': 'Oro',
        '20': 'Oro',
      },
    ),

    // 14.2 Alemania - República de Weimar y Reichsmark (1924–1947)
    // Ref General: Deutsche Bundesbank - Geldgeschichte: https://www.bundesbank.de
    // Ref General: Numista - Germany - Weimar & Third Reich (1924-1948):
    // https://en.numista.com/catalogue/germany-1.html
    // Denominación - Modelo / Referencias:
    // - 0.01, 0.02, 0.04 Mark (1, 2, 4 Reichspfennig - Bronce): https://en.numista.com/catalogue/pieces15155.html
    // - 0.05, 0.10, 0.50 Mark (Bronce de aluminio): https://en.numista.com/catalogue/pieces15156.html
    // - 1 Mark (Níquel puro): https://en.numista.com/catalogue/pieces15157.html
    // - 2, 3, 5 Reichsmark (Plata Ley .625 / .900 - Paul von Hindenburg / Iglesia de Potsdam / Águila): https://en.numista.com/catalogue/pieces15158.html
    NumismaticEmissionRuleData(
      country: 'Alemania',
      minYear: 1924,
      maxYear: 1947,
      validCurrencies: ['RKM', 'RTM'],
      defaultCurrency: 'RKM',
      denominations: ['0.01', '0.02', '0.04', '0.05', '0.10', '0.50', '1', '2', '3', '5'],
      denominationMaterials: {
        '0.01': 'Bronce',
        '0.02': 'Bronce',
        '0.04': 'Bronce',
        '0.05': 'Bronce de aluminio',
        '0.10': 'Bronce de aluminio',
        '0.50': 'Bronce de aluminio',
        '1': 'Níquel',
        '2': 'Plata',
        '3': 'Plata',
        '5': 'Plata',
      },
    ),

    // 14.3 Alemania - Deutsche Mark 1ª Era (1948–1974)
    // Ref General: Deutsche Bundesbank - DM-Münzen:
    // https://www.bundesbank.de/de/aufgaben/bargeld/dm-banknoten-und-dm-muenzen
    // Ref General: Numista - Federal Republic of Germany - Mark (1948-2001):
    // https://en.numista.com/catalogue/germany-2.html
    // Denominación - Modelo / Referencias:
    // - 0.01 Mark (Acero bañado en cobre - Hoja de roble): https://en.numista.com/catalogue/pieces846.html
    // - 0.02 Mark (Bronce hasta 1968 / Acero bañado en cobre 1968+): https://en.numista.com/catalogue/pieces847.html
    // - 0.05, 0.10 Mark (Acero bañado en latón): https://en.numista.com/catalogue/pieces848.html
    // - 0.50, 1, 2 Mark (Cuproníquel - 50 Pfennig Frau beim Pflanzen / Max Planck / Theodor Heuss / Konrad Adenauer): https://en.numista.com/catalogue/pieces849.html
    // - 5 Mark (Plata Ley .625 "Silberadler" 1951-1974 / Conmemorativas): https://en.numista.com/catalogue/pieces850.html
    // - 10 Mark (Plata Ley .625 - Juegos Olímpicos de Múnich 1972): https://en.numista.com/catalogue/pieces851.html
    NumismaticEmissionRuleData(
      country: 'Alemania',
      minYear: 1948,
      maxYear: 1974,
      validCurrencies: ['DEM', 'DDM'],
      defaultCurrency: 'DEM',
      denominations: ['0.01', '0.02', '0.05', '0.10', '0.50', '1', '2', '5', '10'],
      denominationMaterials: {
        '0.01': 'Acero bañado en cobre',
        '0.02': 'Bronce',
        '0.05': 'Acero bañado en latón',
        '0.10': 'Acero bañado en latón',
        '0.50': 'Cuproníquel',
        '1': 'Cuproníquel',
        '2': 'Cuproníquel',
        '5': 'Plata',
        '10': 'Plata',
      },
      commemorativeMotifsByDenomination: {
        '5': [
          'Centenario del Germanisches Nationalmuseum (1952)',
          '150 Aniversario del Fallecimiento de Friedrich von Schiller (1955)',
          '300 Aniversario del Natalicio de Ludwig Wilhelm von Baden (1955)',
          'Centenario del Fallecimiento de Joseph von Eichendorff (1957)',
          '150 Aniversario del Natalicio de Johann Gottlieb Fichte (1964)',
          '250 Aniversario del Fallecimiento de Gottfried Wilhelm Leibniz (1966)',
          'Centenario de Wilhelm Conrad Röntgen (1967)',
          'Centenario del Fallecimiento de Wilhelm von Humboldt (1967)',
          '150 Aniversario del Natalicio de Karl Marx (1968)',
          '500 Aniversario del Fallecimiento de Johannes Gutenberg (1968)',
          '150 Aniversario del Natalicio de Friedrich Wilhelm Raiffeisen (1968)',
          'Centenario de la Fundación del Reichstag (1971)',
          '500 Aniversario del Natalicio de Alberto Durero (1971)',
          '500 Aniversario del Natalicio de Nicolás Copérnico (1973)',
          '125 Aniversario de la Asamblea Nacional de Frankfurt en Paulskirche (1973)',
          '25 Años de la Ley Fundamental de la RFA (1974)',
          '250 Aniversario del Natalicio de Immanuel Kant (1974)',
        ],
        '10': [
          'Juegos Olímpicos de Múnich 1972',
          'Juegos Olímpicos de Múnich 1972 - Emblema Espiral',
          'Juegos Olímpicos de Múnich 1972 - Rayos de Luz',
          'Juegos Olímpicos de Múnich 1972 - Pareja de Atletas',
          'Juegos Olímpicos de Múnich 1972 - Instalaciones Deportivas Estadio Olímpico',
          'Juegos Olímpicos de Múnich 1972 - Bucle conmemorativo',
        ],
      },
      commemorativeReasons: [
        'Juegos Olímpicos de Múnich 1972',
        'Grandes Personalidades de la Historia Alemana',
      ],
    ),

    // 14.4 Alemania - Deutsche Mark 2ª Era Magnimat (1975–2001)
    // Ref General: Deutsche Bundesbank - DM-Münzen:
    // https://www.bundesbank.de/de/aufgaben/bargeld/dm-banknoten-und-dm-muenzen
    // Ref General: Numista - Federal Republic of Germany - Mark (1948-2001):
    // https://en.numista.com/catalogue/germany-2.html
    // Denominación - Modelo / Referencias:
    // - 0.01, 0.02 Mark (Acero bañado en cobre): https://en.numista.com/catalogue/pieces846.html
    // - 0.05, 0.10 Mark (Acero bañado en latón): https://en.numista.com/catalogue/pieces848.html
    // - 0.50, 1, 2 Mark (Cuproníquel / Magnimat): https://en.numista.com/catalogue/pieces849.html
    // - 5 Mark (Cuproníquel / Magnimat / Conmemorativas): https://en.numista.com/catalogue/pieces850.html
    // - 10 Mark (Plata Ley .625 / .925 - Serie Conmemorativa de la República Federal de Alemania): https://en.numista.com/catalogue/pieces851.html
    NumismaticEmissionRuleData(
      country: 'Alemania',
      minYear: 1975,
      maxYear: 2001,
      validCurrencies: ['DEM'],
      defaultCurrency: 'DEM',
      denominations: ['0.01', '0.02', '0.05', '0.10', '0.50', '1', '2', '5', '10'],
      denominationMaterials: {
        '0.01': 'Acero bañado en cobre',
        '0.02': 'Acero bañado en cobre',
        '0.05': 'Acero bañado en latón',
        '0.10': 'Acero bañado en latón',
        '0.50': 'Cuproníquel',
        '1': 'Cuproníquel',
        '2': 'Cuproníquel',
        '5': 'Cuproníquel',
        '10': 'Plata',
      },
      commemorativeMotifsByDenomination: {
        '10': [
          '750 Años de Berlín (1987)',
          'Bicentenario del Natalicio de Arthur Schopenhauer (1988)',
          'Centenario del Fallecimiento de Carl Zeiss (1988)',
          '40 Años de la República Federal de Alemania (1989)',
          '2000 Años de Bonn (1989)',
          '800 Años del Puerto de Hamburgo (1989)',
          '800 Años de la Orden Teutónica (1990)',
          '200 Aniversario de la Puerta de Brandeburgo (1991)',
          '125 Aniversario del Natalicio de Käthe Kollwitz (1992)',
          '150 Aniversario de la Orden Pour le Mérite (1992)',
          '1000 Años de Potsdam (1993)',
          '150 Aniversario del Natalicio de Robert Koch (1993)',
          '50 Aniversario del Levantamiento del 20 de Julio de 1944 (1994)',
          '250 Aniversario del Natalicio de Johann Gottfried Herder (1994)',
          'Centenario del Descubrimiento de los Rayos X (1995)',
          '150 Aniversario del Descubrimiento de Neptuno por Johann Gottfried Galle (1996)',
          '500 Aniversario del Reformador Philipp Melanchthon (1997)',
          'Centenario del Motor Diesel (1997)',
          '350 Años de la Paz de Westfalia (1998)',
          '50 Años del Deutsche Mark (1998)',
          '900 Aniversario del Natalicio de Hildegarda de Bingen (1998)',
          '50 Años de la Ley Fundamental (1999)',
          '250 Aniversario del Natalicio de Johann Wolfgang von Goethe (1999)',
          'Exposición Universal Expo 2000 Hannover (2000)',
          '250 Aniversario del Fallecimiento de Johann Sebastian Bach (2000)',
          '10 Años de la Unidad Alemana (2000)',
          '50 Años del Tribunal Constitucional Federal (2001)',
        ],
      },
      commemorativeReasons: [
        'Serie Conmemorativa de 10 Marcos de Plata',
        'Historia de la República Federal de Alemania',
      ],
    ),

    // =========================================================================
    // 15. ITALIA
    // =========================================================================

    // 15.1 Italia - Reino de Italia (1861–1945)
    // Ref General: Banca d'Italia - Museo della Moneta: https://www.bancaditalia.it
    // Ref General: Numista - Italy - Kingdom (1861-1946):
    // https://en.numista.com/catalogue/italy-1.html
    // Denominación - Modelo / Referencias:
    // - 0.01, 0.02, 0.05, 0.10 Lira (1 a 10 Centesimi - Bronce - Vittorio Emanuele II / Umberto I): https://en.numista.com/catalogue/pieces15160.html
    // - 0.20, 0.50 Lira (Níquel puro / Acmonital): https://en.numista.com/catalogue/pieces15161.html
    // - 1, 2 Liras (Acmonital / Plata Ley .835 - Águila / Corona / Buque): https://en.numista.com/catalogue/pieces15162.html
    // - 5, 10, 20 Liras (Plata Ley .900 / .800 / .600 - Cuadriga / Littore / Elmo): https://en.numista.com/catalogue/pieces15163.html
    // - 50, 100 Liras (Oro Ley .900 - Vittorio Emanuele III): https://en.numista.com/catalogue/pieces15164.html
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
        '0.20': 'Níquel',
        '0.50': 'Níquel',
        '1': 'Acero inoxidable',
        '2': 'Acero inoxidable',
        '5': 'Plata',
        '10': 'Plata',
        '20': 'Plata',
        '50': 'Oro',
        '100': 'Oro',
      },
    ),

    // 15.2 Italia - República Italiana 1ª Era Caravelle de Plata (1946–1981)
    // Ref General: Istituto Poligrafico e Zecca dello Stato: https://www.ipzs.it
    // Ref General: Numista - Italy - Republic - Lira (1946-2001):
    // https://en.numista.com/catalogue/italy-2.html
    // Denominación - Modelo / Referencias:
    // - 1, 2, 5, 10 Liras (Italma - Aluminio - Espiga / Olivo / Timón / Arado): https://en.numista.com/catalogue/pieces725.html
    // - 20 Liras (Bronzital - Bronce de aluminio - Roble): https://en.numista.com/catalogue/pieces726.html
    // - 50, 100 Liras (Acmonital - Acero inoxidable - Vulcano / Minerva): https://en.numista.com/catalogue/pieces727.html
    // - 200 Liras (Bronzital - Trabajo / Exposición): https://en.numista.com/catalogue/pieces728.html
    // - 500 Liras (Plata Ley .835 - Le Caravelle di Colombo / Centenario Unità 1961 / Dante 1965 / Marconi 1974): https://en.numista.com/catalogue/pieces729.html
    NumismaticEmissionRuleData(
      country: 'Italia',
      minYear: 1946,
      maxYear: 1981,
      validCurrencies: ['ITL'],
      defaultCurrency: 'ITL',
      denominations: ['1', '2', '5', '10', '20', '50', '100', '200', '500'],
      denominationMaterials: {
        '1': 'Aluminio',
        '2': 'Aluminio',
        '5': 'Aluminio',
        '10': 'Aluminio',
        '20': 'Bronce de aluminio',
        '50': 'Acero inoxidable',
        '100': 'Acero inoxidable',
        '200': 'Bronce de aluminio',
        '500': 'Plata',
      },
      commemorativeMotifsByDenomination: {
        '500': [
          'Le Caravelle di Cristoforo Colombo (1958-1967)',
          'Centenario de la Unificación de Italia - Proclama del Reino de Italia (1961)',
          'Centenario del Nacimiento de Dante Alighieri (1965)',
          'Centenario del Nacimiento de Guglielmo Marconi (1974)',
          'Bimilenario de Virgilio (1981)',
        ],
      },
      commemorativeReasons: [
        'Le Caravelle di Colombo',
        'Centenario dell\'Unità d\'Italia',
        'Dante Alighieri',
        'Guglielmo Marconi',
      ],
    ),

    // 15.3 Italia - República Italiana 2ª Era Bimetálicas (1982–2001)
    // Ref General: Istituto Poligrafico e Zecca dello Stato: https://www.ipzs.it
    // Ref General: Numista - Italy - Republic - Lira (1946-2001):
    // https://en.numista.com/catalogue/italy-2.html
    // Denominación - Modelo / Referencias:
    // - 1, 2, 5, 10 Liras (Italma - Aluminio): https://en.numista.com/catalogue/pieces725.html
    // - 20 Liras (Bronzital - Bronce de aluminio): https://en.numista.com/catalogue/pieces726.html
    // - 50, 100 Liras (Acmonital - Acero inoxidable): https://en.numista.com/catalogue/pieces727.html
    // - 200 Liras (Bronzital - Aeronautica Militare / Carabinieri / Guardia di Finanza / FAO): https://en.numista.com/catalogue/pieces728.html
    // - 500 Liras (Bimetálica Anillo Acmonital / Núcleo Bronzital - Repubblica Italiana / Luca Pacioli / ISTAT / Polizia / FIGC / IFAD / Parlamento Europeo): https://en.numista.com/catalogue/pieces730.html
    // - 1000 Liras (Bimetálica Anillo Bronzital / Núcleo Cuproníquel - Mappa dell\'Europa / Confini): https://en.numista.com/catalogue/pieces731.html
    NumismaticEmissionRuleData(
      country: 'Italia',
      minYear: 1982,
      maxYear: 2001,
      validCurrencies: ['ITL'],
      defaultCurrency: 'ITL',
      denominations: ['1', '2', '5', '10', '20', '50', '100', '200', '500', '1000'],
      denominationMaterials: {
        '1': 'Aluminio',
        '2': 'Aluminio',
        '5': 'Aluminio',
        '10': 'Aluminio',
        '20': 'Bronce de aluminio',
        '50': 'Acero inoxidable',
        '100': 'Acero inoxidable',
        '200': 'Bronce de aluminio',
        '500': 'Bimetálica',
        '1000': 'Bimetálica',
      },
      commemorativeMotifsByDenomination: {
        '200': [
          'Centenario de la Aeronautica Militare (1993)',
          'Centenario del Nacimiento de Maria Montessori (1990)',
          '70 Aniversario de la Guardia di Finanza (1996)',
          '50 Aniversario de la Declaración Universal de los Derechos Humanos (1998)',
        ],
        '500': [
          'República Italiana Clásica Bimetálica',
          'Centenario del Banco de Italia (1993)',
          'Centenario de Luca Pacioli (1994)',
          '70 Aniversario del ISTAT (1996)',
          '50 Aniversario de la Policía de Tráfico Polizia Stradale (1997)',
          'Centenario de la Federación Italiana de Fútbol FIGC (1998)',
          '20 Años del IFAD (1998)',
          'Elecciones al Parlamento Europeo (1999)',
        ],
        '1000': [
          'Mapa de la Unión Europea con Fronteras Erróneas (1997)',
          'Mapa de la Unión Europea con Fronteras Corregidas (1997-1998)',
        ],
      },
      commemorativeReasons: [
        '500 Lire Bimetalliche Commemorative',
        '1000 Lire Mappa d\'Europa',
      ],
    ),

    // =========================================================================
    // NOTAFILIA: BILLETES Y PAPEL MONEDA (isBanknote: true)
    // =========================================================================

    // B1.1 México Billetes - Época Revolucionaria y Pre-Banco de México (1823–1924)
    // Ref General: Banco de México - Historia del billete mexicano:
    // https://www.banxico.org.mx/billetes-y-monedas/historia-billete-banco-mexico.html
    // Ref General: Numista - Mexican Banknotes:
    // https://en.numista.com/catalogue/mexico-banknotes-1.html
    // Denominación - Modelo / Referencias:
    // - 0.05, 0.10, 0.20, 0.50 Peso (Cartones y Billetes fraccionarios revolucionarios): https://en.numista.com/catalogue/pieces15170.html
    // - 1, 2, 5, 10, 20, 50, 100, 500, 1000 Pesos (Gobierno Constitucionalista, Ejército del Norte, Banco de Londres y México): https://en.numista.com/catalogue/mexico-banknotes-1.html
    NumismaticEmissionRuleData(
      country: 'México',
      minYear: 1823,
      maxYear: 1924,
      validCurrencies: ['MXP'],
      defaultCurrency: 'MXP',
      denominations: ['0.05', '0.10', '0.20', '0.50', '1', '2', '5', '10', '20', '50', '100', '500', '1000'],
      denominationMaterials: {
        '0.05': 'Papel',
        '0.10': 'Papel',
        '0.20': 'Papel',
        '0.50': 'Papel',
        '1': 'Papel',
        '2': 'Papel',
        '5': 'Papel',
        '10': 'Papel',
        '20': 'Papel',
        '50': 'Papel',
        '100': 'Papel',
        '500': 'Papel',
        '1000': 'Papel',
      },
      isBanknote: true,
    ),

    // B1.2 México Billetes - Primeras Emisiones Banco de México / ABNC (1925–1978)
    // Ref General: Banco de México - Billetes impresos por American Bank Note Company (ABNC):
    // https://www.banxico.org.mx/billetes-y-monedas/billetes-abnc-banco-mexico.html
    // Ref General: Numista - Mexico - Banknotes (1925-1978):
    // https://en.numista.com/catalogue/mexico-banknotes-2.html
    // Denominación - Modelo / Referencias:
    // - 1 Peso (ABNC - Calendario Azteca / Piedra del Sol): https://www.banxico.org.mx/billetes-y-monedas/billetes-abnc-banco-mexico.html
    // - 2 Pesos (ABNC - Monumento a la Independencia): https://www.banxico.org.mx/billetes-y-monedas/billetes-abnc-banco-mexico.html
    // - 5 Pesos (ABNC - La Gitana / Josefa Ortiz de Domínguez): https://www.banxico.org.mx/billetes-y-monedas/billetes-abnc-banco-mexico.html
    // - 10 Pesos (ABNC - La Tehuana / Miguel Hidalgo): https://www.banxico.org.mx/billetes-y-monedas/billetes-abnc-banco-mexico.html
    // - 20 Pesos (ABNC - Josefa Ortiz de Domínguez): https://www.banxico.org.mx/billetes-y-monedas/billetes-abnc-banco-mexico.html
    // - 50 Pesos (ABNC - Ignacio Allende): https://www.banxico.org.mx/billetes-y-monedas/billetes-abnc-banco-mexico.html
    // - 100 Pesos (ABNC - Miguel Hidalgo y Costilla): https://www.banxico.org.mx/billetes-y-monedas/billetes-abnc-banco-mexico.html
    // - 500 Pesos (ABNC - José María Morelos y Pavón): https://www.banxico.org.mx/billetes-y-monedas/billetes-abnc-banco-mexico.html
    // - 1000 Pesos (ABNC - Cuauhtémoc): https://www.banxico.org.mx/billetes-y-monedas/billetes-abnc-banco-mexico.html
    // - 5000, 10000 Pesos (ABNC - Niños Héroes / Matías Romero): https://www.banxico.org.mx/billetes-y-monedas/billetes-abnc-banco-mexico.html
    NumismaticEmissionRuleData(
      country: 'México',
      minYear: 1925,
      maxYear: 1978,
      validCurrencies: ['MXP'],
      defaultCurrency: 'MXP',
      denominations: ['1', '2', '5', '10', '20', '50', '100', '500', '1000', '5000', '10000'],
      denominationMaterials: {
        '1': 'Papel de algodón',
        '2': 'Papel de algodón',
        '5': 'Papel de algodón',
        '10': 'Papel de algodón',
        '20': 'Papel de algodón',
        '50': 'Papel de algodón',
        '100': 'Papel de algodón',
        '500': 'Papel de algodón',
        '1000': 'Papel de algodón',
        '5000': 'Papel de algodón',
        '10000': 'Papel de algodón',
      },
      isBanknote: true,
    ),

    // B1.3 México Billetes - Familia AA Fábrica de Billetes Banxico (1969–1992)
    // Ref General: Banco de México - Billetes de la Familia AA desmonetizados:
    // https://www.banxico.org.mx/billetes-y-monedas/familia-aa-desmonetizados-ban.html
    // Denominación - Modelo / Referencias:
    // - 5 Pesos (Josefa Ortiz de Domínguez): https://www.banxico.org.mx/billetes-y-monedas/familia-aa-desmonetizados-ban.html
    // - 10 Pesos (Miguel Hidalgo): https://www.banxico.org.mx/billetes-y-monedas/familia-aa-desmonetizados-ban.html
    // - 20 Pesos (José María Morelos): https://www.banxico.org.mx/billetes-y-monedas/familia-aa-desmonetizados-ban.html
    // - 50 Pesos (Benito Juárez): https://www.banxico.org.mx/billetes-y-monedas/familia-aa-desmonetizados-ban.html
    // - 100 Pesos (Venustiano Carranza): https://www.banxico.org.mx/billetes-y-monedas/familia-aa-desmonetizados-ban.html
    // - 500 Pesos (Francisco I. Madero): https://www.banxico.org.mx/billetes-y-monedas/familia-aa-desmonetizados-ban.html
    // - 1000 Pesos (Sor Juana Inés de la Cruz): https://www.banxico.org.mx/billetes-y-monedas/familia-aa-desmonetizados-ban.html
    NumismaticEmissionRuleData(
      country: 'México',
      minYear: 1969,
      maxYear: 1992,
      validCurrencies: ['MXP'],
      defaultCurrency: 'MXP',
      denominations: ['5', '10', '20', '50', '100', '500', '1000'],
      denominationMaterials: {
        '5': 'Papel de algodón',
        '10': 'Papel de algodón',
        '20': 'Papel de algodón',
        '50': 'Papel de algodón',
        '100': 'Papel de algodón',
        '500': 'Papel de algodón',
        '1000': 'Papel de algodón',
      },
      isBanknote: true,
    ),

    // B1.4 México Billetes - Familia A Altas Denominaciones Inflacionarias (1979–1992)
    // Ref General: Banco de México - Billetes de la Familia A desmonetizados:
    // https://www.banxico.org.mx/billetes-y-monedas/familia-desmonetizados-banco.html
    // Denominación - Modelo / Referencias:
    // - 2000 Pesos (Justo Sierra): https://www.banxico.org.mx/billetes-y-monedas/familia-desmonetizados-banco.html
    // - 5000 Pesos (Niños Héroes): https://www.banxico.org.mx/billetes-y-monedas/familia-desmonetizados-banco.html
    // - 10000 Pesos (Lázaro Cárdenas): https://www.banxico.org.mx/billetes-y-monedas/familia-desmonetizados-banco.html
    // - 20000 Pesos (Andrés Quintana Roo): https://www.banxico.org.mx/billetes-y-monedas/familia-desmonetizados-banco.html
    // - 50000 Pesos (Cuauhtémoc): https://www.banxico.org.mx/billetes-y-monedas/familia-desmonetizados-banco.html
    // - 100000 Pesos (Plutarco Elías Calles): https://www.banxico.org.mx/billetes-y-monedas/familia-desmonetizados-banco.html
    NumismaticEmissionRuleData(
      country: 'México',
      minYear: 1979,
      maxYear: 1992,
      validCurrencies: ['MXP'],
      defaultCurrency: 'MXP',
      denominations: ['2000', '5000', '10000', '20000', '50000', '100000'],
      denominationMaterials: {
        '2000': 'Papel de algodón',
        '5000': 'Papel de algodón',
        '10000': 'Papel de algodón',
        '20000': 'Papel de algodón',
        '50000': 'Papel de algodón',
        '100000': 'Papel de algodón',
      },
      isBanknote: true,
    ),

    // B1.5 México Billetes - Familia B Nuevos Pesos N$ (1993–1995)
    // Ref General: Banco de México - Billetes de la Familia B en proceso de retiro:
    // https://www.banxico.org.mx/billetes-y-monedas/familia-b-proceso-retiro-ban.html
    // Denominación - Modelo / Referencias:
    // - 10 Nuevos Pesos (Lázaro Cárdenas): https://www.banxico.org.mx/billetes-y-monedas/familia-b-proceso-retiro-ban.html
    // - 20 Nuevos Pesos (Andrés Quintana Roo): https://www.banxico.org.mx/billetes-y-monedas/familia-b-proceso-retiro-ban.html
    // - 50 Nuevos Pesos (Cuauhtémoc): https://www.banxico.org.mx/billetes-y-monedas/familia-b-proceso-retiro-ban.html
    // - 100 Nuevos Pesos (Plutarco Elías Calles): https://www.banxico.org.mx/billetes-y-monedas/familia-b-proceso-retiro-ban.html
    NumismaticEmissionRuleData(
      country: 'México',
      minYear: 1993,
      maxYear: 1995,
      validCurrencies: ['MXN'],
      defaultCurrency: 'MXN',
      denominations: ['10', '20', '50', '100'],
      denominationMaterials: {
        '10': 'Papel de algodón',
        '20': 'Papel de algodón',
        '50': 'Papel de algodón',
        '100': 'Papel de algodón',
      },
      isBanknote: true,
    ),

    // B1.6 México Billetes - Familia C (1994–2001)
    // Ref General: Banco de México - Billetes de la Familia C en proceso de retiro:
    // https://www.banxico.org.mx/billetes-y-monedas/familia-c-circulacion-banco-m.html
    // Denominación - Modelo / Referencias:
    // - 10 Pesos (Emiliano Zapata): https://www.banxico.org.mx/billetes-y-monedas/familia-c-circulacion-banco-m.html
    // - 20 Pesos (Benito Juárez): https://www.banxico.org.mx/billetes-y-monedas/familia-c-circulacion-banco-m.html
    // - 50 Pesos (José María Morelos): https://www.banxico.org.mx/billetes-y-monedas/familia-c-circulacion-banco-m.html
    // - 100 Pesos (Nezahualcóyotl): https://www.banxico.org.mx/billetes-y-monedas/familia-c-circulacion-banco-m.html
    // - 200 Pesos (Sor Juana Inés de la Cruz): https://www.banxico.org.mx/billetes-y-monedas/familia-c-circulacion-banco-m.html
    // - 500 Pesos (Ignacio Zaragoza): https://www.banxico.org.mx/billetes-y-monedas/familia-c-circulacion-banco-m.html
    NumismaticEmissionRuleData(
      country: 'México',
      minYear: 1994,
      maxYear: 2001,
      validCurrencies: ['MXN'],
      defaultCurrency: 'MXN',
      denominations: ['10', '20', '50', '100', '200', '500'],
      denominationMaterials: {
        '10': 'Papel de algodón',
        '20': 'Papel de algodón',
        '50': 'Papel de algodón',
        '100': 'Papel de algodón',
        '200': 'Papel de algodón',
        '500': 'Papel de algodón',
      },
      isBanknote: true,
    ),

    // B1.7 México Billetes - Familia D y D1 Introducción de Polímero (2002–2007)
    // Ref General: Banco de México - Billetes de las Familias D y D1:
    // https://www.banxico.org.mx/billetes-y-monedas/familia-d1-proceso-retiro-ba.html
    // Denominación - Modelo / Referencias:
    // - 10 Pesos (Emiliano Zapata): https://www.banxico.org.mx/billetes-y-monedas/familia-d1-proceso-retiro-ba.html
    // - 20 Pesos (Polímero - Benito Juárez): https://www.banxico.org.mx/billetes-y-monedas/familia-d1-proceso-retiro-ba.html
    // - 50 Pesos (José María Morelos): https://www.banxico.org.mx/billetes-y-monedas/familia-d1-proceso-retiro-ba.html
    // - 100 Pesos (Nezahualcóyotl): https://www.banxico.org.mx/billetes-y-monedas/familia-d1-proceso-retiro-ba.html
    // - 200 Pesos (Sor Juana Inés de la Cruz): https://www.banxico.org.mx/billetes-y-monedas/familia-d1-proceso-retiro-ba.html
    // - 500 Pesos (Ignacio Zaragoza): https://www.banxico.org.mx/billetes-y-monedas/familia-d1-proceso-retiro-ba.html
    NumismaticEmissionRuleData(
      country: 'México',
      minYear: 2002,
      maxYear: 2007,
      validCurrencies: ['MXN'],
      defaultCurrency: 'MXN',
      denominations: ['10', '20', '50', '100', '200', '500'],
      denominationMaterials: {
        '10': 'Papel de algodón',
        '20': 'Polímero',
        '50': 'Papel de algodón',
        '100': 'Papel de algodón',
        '200': 'Papel de algodón',
        '500': 'Papel de algodón',
      },
      isBanknote: true,
    ),

    // B1.8 México Billetes - Familia F y Conmemorativos del Centenario/Bicentenario (2006–2019)
    // Ref General: Banco de México - Billetes de la Familia F en circulación:
    // https://www.banxico.org.mx/billetes-y-monedas/familia-f-circulacion-banco-m.html
    // Denominación - Modelo / Referencias:
    // - 20 Pesos (Polímero - Benito Juárez / Zona Arqueológica de Monte Albán): https://www.banxico.org.mx/billetes-y-monedas/familia-f-circulacion-banco-m.html
    // - 50 Pesos (Polímero - José María Morelos / Acueducto de Morelia): https://www.banxico.org.mx/billetes-y-monedas/familia-f-circulacion-banco-m.html
    // - 100 Pesos (Papel de algodón - Nezahualcóyotl / Centenario Revolución 2010 / Centenario Constitución 2017): https://www.banxico.org.mx/billetes-y-monedas/familia-f-circulacion-banco-m.html
    // - 200 Pesos (Papel de algodón - Sor Juana Inés de la Cruz / Bicentenario Independencia 2010): https://www.banxico.org.mx/billetes-y-monedas/familia-f-circulacion-banco-m.html
    // - 500 Pesos (Papel de algodón - Diego Rivera y Frida Kahlo): https://www.banxico.org.mx/billetes-y-monedas/familia-f-circulacion-banco-m.html
    // - 1000 Pesos (Papel de algodón - Miguel Hidalgo / Universidad de Guanajuato): https://www.banxico.org.mx/billetes-y-monedas/familia-f-circulacion-banco-m.html
    NumismaticEmissionRuleData(
      country: 'México',
      minYear: 2006,
      maxYear: 2019,
      validCurrencies: ['MXN'],
      defaultCurrency: 'MXN',
      denominations: ['20', '50', '100', '200', '500', '1000'],
      denominationMaterials: {
        '20': 'Polímero',
        '50': 'Polímero',
        '100': 'Papel de algodón',
        '200': 'Papel de algodón',
        '500': 'Papel de algodón',
        '1000': 'Papel de algodón',
      },
      denominationAllowedMaterials: {
        '100': ['Papel de algodón', 'Polímero'],
      },
      commemorativeMotifsByDenomination: {
        '100': [
          'Centenario de la Revolución Mexicana (2010)',
          'Centenario de la Constitución Política (2017)',
        ],
        '200': [
          'Bicentenario de la Independencia de México (2010)',
        ],
      },
      commemorativeReasons: [
        'Centenario de la Revolución Mexicana (2010)',
        'Centenario de la Constitución Política (2017)',
        'Bicentenario de la Independencia de México (2010)',
      ],
      isBanknote: true,
    ),

    // B1.9 México Billetes - Familia G en Circulación y Polímeros de Vanguardia (2020–presente)
    // Ref General: Banco de México - Billetes de la Familia G:
    // https://www.banxico.org.mx/billetes-y-monedas/familia-g-circulacion-banco-m.html
    // Denominación - Modelo / Referencias:
    // - 20 Pesos (Polímero - Bicentenario de la Independencia Nacional): https://www.banxico.org.mx/billetes-y-monedas/familia-g-circulacion-banco-m.html
    // - 50 Pesos (Polímero - Fundación de Tenochtitlan / Ajolote y Xochimilco): https://www.banxico.org.mx/billetes-y-monedas/familia-g-circulacion-banco-m.html
    // - 100 Pesos (Polímero - Sor Juana Inés de la Cruz / Bosques Templados y Mariposa Monarca): https://www.banxico.org.mx/billetes-y-monedas/familia-g-circulacion-banco-m.html
    // - 200 Pesos (Papel de algodón - Miguel Hidalgo y José María Morelos / Reserva El Pinacate): https://www.banxico.org.mx/billetes-y-monedas/familia-g-circulacion-banco-m.html
    // - 500 Pesos (Papel de algodón - Benito Juárez / Ballena Gris y Pastos Marinos El Vizcaíno): https://www.banxico.org.mx/billetes-y-monedas/familia-g-circulacion-banco-m.html
    // - 1000 Pesos (Papel de algodón - Francisco I. Madero, Hermila Galindo y Carmen Serdán / Calakmul y Jaguar): https://www.banxico.org.mx/billetes-y-monedas/familia-g-circulacion-banco-m.html
    NumismaticEmissionRuleData(
      country: 'México',
      minYear: 2020,
      maxYear: 2100,
      validCurrencies: ['MXN'],
      defaultCurrency: 'MXN',
      denominations: ['20', '50', '100', '200', '500', '1000'],
      denominationMaterials: {
        '20': 'Polímero',
        '50': 'Polímero',
        '100': 'Polímero',
        '200': 'Papel de algodón',
        '500': 'Papel de algodón',
        '1000': 'Papel de algodón',
      },
      denominationAllowedMaterials: {
        '100': ['Polímero', 'Papel de algodón'],
      },
      commemorativeMotifsByDenomination: {
        '20': [
          'Bicentenario de la Independencia Nacional (2021)',
        ],
      },
      commemorativeReasons: [
        'Bicentenario de la Independencia Nacional (2021)',
      ],
      isBanknote: true,
    ),

    // B2.1 Estados Unidos Billetes - Large Size Notes (1861–1927)
    // Ref General: US Bureau of Engraving and Printing - Large Size Currency: https://www.bep.gov
    // Ref General: Numista - United States - Banknotes (Large Size):
    // https://en.numista.com/catalogue/united-states-banknotes-1.html
    // Denominación - Modelo / Referencias:
    // - 1, 2, 5, 10, 20, 50, 100, 500, 1000, 5000, 10000 Dollars (Legal Tender, Silver & Gold Certificates, National Bank Notes): https://www.bep.gov
    NumismaticEmissionRuleData(
      country: 'Estados Unidos',
      minYear: 1861,
      maxYear: 1927,
      validCurrencies: ['USD'],
      defaultCurrency: 'USD',
      denominations: ['1', '2', '5', '10', '20', '50', '100', '500', '1000', '5000', '10000'],
      denominationMaterials: {
        '1': 'Papel de algodón',
        '2': 'Papel de algodón',
        '5': 'Papel de algodón',
        '10': 'Papel de algodón',
        '20': 'Papel de algodón',
        '50': 'Papel de algodón',
        '100': 'Papel de algodón',
        '500': 'Papel de algodón',
        '1000': 'Papel de algodón',
        '5000': 'Papel de algodón',
        '10000': 'Papel de algodón',
      },
      isBanknote: true,
    ),

    // B2.2 Estados Unidos Billetes - Small Size Federal Reserve Notes (1928–presente)
    // Ref General: US Bureau of Engraving and Printing - Currency Denominations:
    // https://www.bep.gov/currency/denominations
    // Ref General: US Federal Reserve - Currency: https://www.federalreserve.gov
    // Denominación - Modelo / Referencias:
    // - $1 (George Washington / Great Seal): https://www.federalreserve.gov/faqs/currency_12773.htm
    // - $2 (Thomas Jefferson / Declaration of Independence): https://www.federalreserve.gov/faqs/currency_12773.htm
    // - $5 (Abraham Lincoln / Lincoln Memorial): https://www.federalreserve.gov/faqs/currency_12773.htm
    // - $10 (Alexander Hamilton / US Treasury): https://www.federalreserve.gov/faqs/currency_12773.htm
    // - $20 (Andrew Jackson / White House): https://www.federalreserve.gov/faqs/currency_12773.htm
    // - $50 (Ulysses S. Grant / US Capitol): https://www.federalreserve.gov/faqs/currency_12773.htm
    // - $100 (Benjamin Franklin / Independence Hall): https://www.federalreserve.gov/faqs/currency_12773.htm
    // - $500, $1000, $5000, $10000, $100000 (McKinley, Cleveland, Madison, Chase, Wilson): https://www.bep.gov
    NumismaticEmissionRuleData(
      country: 'Estados Unidos',
      minYear: 1928,
      maxYear: 2100,
      validCurrencies: ['USD'],
      defaultCurrency: 'USD',
      denominations: ['1', '2', '5', '10', '20', '50', '100', '500', '1000', '5000', '10000', '100000'],
      denominationMaterials: {
        '1': 'Papel de algodón',
        '2': 'Papel de algodón',
        '5': 'Papel de algodón',
        '10': 'Papel de algodón',
        '20': 'Papel de algodón',
        '50': 'Papel de algodón',
        '100': 'Papel de algodón',
        '500': 'Papel de algodón',
        '1000': 'Papel de algodón',
        '5000': 'Papel de algodón',
        '10000': 'Papel de algodón',
        '100000': 'Papel de algodón',
      },
      isBanknote: true,
    ),

    // B3.1 España Billetes - Era de la Peseta (1874–2001)
    // Ref General: Banco de España - Billetes en pesetas:
    // https://www.bde.es/wbe/es/para-ciudadanos/billetes-y-monedas/pesetas/
    // Denominación - Modelo / Referencias:
    // - 1 a 10000 Pesetas (Cervantes, Velázquez, Goya, Rosalía de Castro, Juan Ramón Jiménez, Benito Pérez Galdós, José Celestino Mutis, Hernán Cortés, Juan Carlos I): https://www.bde.es/wbe/es/para-ciudadanos/billetes-y-monedas/pesetas/
    NumismaticEmissionRuleData(
      country: 'España',
      minYear: 1874,
      maxYear: 2001,
      validCurrencies: ['ESP'],
      defaultCurrency: 'ESP',
      denominations: ['1', '2', '5', '10', '25', '50', '100', '200', '500', '1000', '2000', '5000', '10000'],
      denominationMaterials: {
        '1': 'Papel de algodón',
        '2': 'Papel de algodón',
        '5': 'Papel de algodón',
        '10': 'Papel de algodón',
        '25': 'Papel de algodón',
        '50': 'Papel de algodón',
        '100': 'Papel de algodón',
        '200': 'Papel de algodón',
        '500': 'Papel de algodón',
        '1000': 'Papel de algodón',
        '2000': 'Papel de algodón',
        '5000': 'Papel de algodón',
        '10000': 'Papel de algodón',
      },
      isBanknote: true,
    ),

    // B3.2 España & Unión Europea Billetes - Era del Euro (2002–presente)
    // Ref General: Banco Central Europeo - Billetes en euros (Series 2002 y Europa):
    // https://www.ecb.europa.eu/euro/banknotes/html/index.es.html
    // Denominación - Modelo / Referencias:
    // - 5, 10, 20, 50, 100, 200, 500 Euros (Arquitectura Clásica, Románica, Gótica, Renacentista, Barroca, Modernista): https://www.ecb.europa.eu/euro/banknotes/html/index.es.html
    NumismaticEmissionRuleData(
      country: 'España',
      minYear: 2002,
      maxYear: 2100,
      validCurrencies: ['EUR'],
      defaultCurrency: 'EUR',
      denominations: ['5', '10', '20', '50', '100', '200', '500'],
      denominationMaterials: {
        '5': 'Papel de algodón',
        '10': 'Papel de algodón',
        '20': 'Papel de algodón',
        '50': 'Papel de algodón',
        '100': 'Papel de algodón',
        '200': 'Papel de algodón',
        '500': 'Papel de algodón',
      },
      isBanknote: true,
    ),
    NumismaticEmissionRuleData(
      country: 'Unión Europea',
      minYear: 2002,
      maxYear: 2100,
      validCurrencies: ['EUR'],
      defaultCurrency: 'EUR',
      denominations: ['5', '10', '20', '50', '100', '200', '500'],
      denominationMaterials: {
        '5': 'Papel de algodón',
        '10': 'Papel de algodón',
        '20': 'Papel de algodón',
        '50': 'Papel de algodón',
        '100': 'Papel de algodón',
        '200': 'Papel de algodón',
        '500': 'Papel de algodón',
      },
      isBanknote: true,
    ),

    // B4.1 Guatemala Billetes - Quetzales Clásicos y Modernos (1948–2006)
    // Ref General: Banco de Guatemala - Historia de los Billetes de Quetzal: https://www.banguat.gob.gt
    // Denominación - Modelo / Referencias:
    // - 0.50, 1, 5, 10, 20, 50, 100, 200 Quetzales (Tecún Umán, José María Orellana, Justo Rufino Barrios, Miguel García Granados, Mariano Gálvez, Carlos Mérida, Francisco Marroquín): https://www.banguat.gob.gt
    NumismaticEmissionRuleData(
      country: 'Guatemala',
      minYear: 1948,
      maxYear: 2006,
      validCurrencies: ['GTQ'],
      defaultCurrency: 'GTQ',
      denominations: ['0.50', '1', '5', '10', '20', '50', '100', '200'],
      denominationMaterials: {
        '0.50': 'Papel de algodón',
        '1': 'Papel de algodón',
        '5': 'Papel de algodón',
        '10': 'Papel de algodón',
        '20': 'Papel de algodón',
        '50': 'Papel de algodón',
        '100': 'Papel de algodón',
        '200': 'Papel de algodón',
      },
      isBanknote: true,
    ),

    // B4.2 Guatemala Billetes - Era de Polímero y Familias Actuales (2007–presente)
    // Ref General: Banco de Guatemala - Billetes de 1 y 5 Quetzales en Polímero:
    // https://www.banguat.gob.gt
    // Denominación - Modelo / Referencias:
    // - 1 Quetzal (Polímero - General José María Orellana): https://www.banguat.gob.gt
    // - 5 Quetzales (Polímero - General Justo Rufino Barrios): https://www.banguat.gob.gt
    // - 10, 20, 50, 100, 200 Quetzales (Papel de algodón): https://www.banguat.gob.gt
    NumismaticEmissionRuleData(
      country: 'Guatemala',
      minYear: 2007,
      maxYear: 2100,
      validCurrencies: ['GTQ'],
      defaultCurrency: 'GTQ',
      denominations: ['1', '5', '10', '20', '50', '100', '200'],
      denominationMaterials: {
        '1': 'Polímero',
        '5': 'Polímero',
        '10': 'Papel de algodón',
        '20': 'Papel de algodón',
        '50': 'Papel de algodón',
        '100': 'Papel de algodón',
        '200': 'Papel de algodón',
      },
      isBanknote: true,
    ),

    // B5.1 Colombia Billetes - Pesos Oro (1960–1993)
    // Ref General: Banco de la República - Billetes antiguos colombianos: https://www.banrep.gov.co
    // Denominación - Modelo / Referencias:
    // - 1 a 10000 Pesos Oro (Santander, Bolívar, Nariño, Caldas, Camilo Torres, Policarpa Salavarrieta): https://www.banrep.gov.co
    NumismaticEmissionRuleData(
      country: 'Colombia',
      minYear: 1960,
      maxYear: 1993,
      validCurrencies: ['COP'],
      defaultCurrency: 'COP',
      denominations: ['1', '2', '5', '10', '20', '50', '100', '200', '500', '1000', '2000', '5000', '10000'],
      denominationMaterials: {
        '1': 'Papel de algodón',
        '2': 'Papel de algodón',
        '5': 'Papel de algodón',
        '10': 'Papel de algodón',
        '20': 'Papel de algodón',
        '50': 'Papel de algodón',
        '100': 'Papel de algodón',
        '200': 'Papel de algodón',
        '500': 'Papel de algodón',
        '1000': 'Papel de algodón',
        '2000': 'Papel de algodón',
        '5000': 'Papel de algodón',
        '10000': 'Papel de algodón',
      },
      isBanknote: true,
    ),

    // B5.2 Colombia Billetes - Pesos y Nueva Familia de Billetes (1994–presente)
    // Ref General: Banco de la República - Nueva Familia de Billetes:
    // https://www.banrep.gov.co/es/billetes-monedas/billetes-circulacion
    // Denominación - Modelo / Referencias:
    // - 1000 Pesos (Jorge Eliécer Gaitán): https://www.banrep.gov.co/es/billetes-monedas/billetes-circulacion
    // - 2000 Pesos (Débora Arango / Caño Cristales): https://www.banrep.gov.co/es/billetes-monedas/billetes-circulacion
    // - 5000 Pesos (José Asunción Silva / Páramos): https://www.banrep.gov.co/es/billetes-monedas/billetes-circulacion
    // - 10000 Pesos (Virginia Gutiérrez / Amazonia): https://www.banrep.gov.co/es/billetes-monedas/billetes-circulacion
    // - 20000 Pesos (Alfonso López Michelsen / Canales de La Mojana): https://www.banrep.gov.co/es/billetes-monedas/billetes-circulacion
    // - 50000 Pesos (Gabriel García Márquez / Ciudad Perdida): https://www.banrep.gov.co/es/billetes-monedas/billetes-circulacion
    // - 100000 Pesos (Carlos Lleras Restrepo / Valle de Cocora): https://www.banrep.gov.co/es/billetes-monedas/billetes-circulacion
    NumismaticEmissionRuleData(
      country: 'Colombia',
      minYear: 1994,
      maxYear: 2100,
      validCurrencies: ['COP'],
      defaultCurrency: 'COP',
      denominations: ['1000', '2000', '5000', '10000', '20000', '50000', '100000'],
      denominationMaterials: {
        '1000': 'Papel de algodón',
        '2000': 'Papel de algodón',
        '5000': 'Papel de algodón',
        '10000': 'Papel de algodón',
        '20000': 'Papel de algodón',
        '50000': 'Papel de algodón',
        '100000': 'Papel de algodón',
      },
      isBanknote: true,
    ),

    // B6.1 Canadá Billetes - Scenes of Canada, Birds & Journey Series (1935–2010)
    // Ref General: Bank of Canada - Bank Note Series:
    // https://www.bankofcanada.ca/banknotes/bank-note-series/
    // Denominación - Modelo / Referencias:
    // - 1, 2, 5, 10, 20, 50, 100, 1000 Dollars (Scenes of Canada, Birds of Canada, Canadian Journey Series): https://www.bankofcanada.ca/banknotes/bank-note-series/
    NumismaticEmissionRuleData(
      country: 'Canadá',
      minYear: 1935,
      maxYear: 2010,
      validCurrencies: ['CAD'],
      defaultCurrency: 'CAD',
      denominations: ['1', '2', '5', '10', '20', '50', '100', '1000'],
      denominationMaterials: {
        '1': 'Papel de algodón',
        '2': 'Papel de algodón',
        '5': 'Papel de algodón',
        '10': 'Papel de algodón',
        '20': 'Papel de algodón',
        '50': 'Papel de algodón',
        '100': 'Papel de algodón',
        '1000': 'Papel de algodón',
      },
      isBanknote: true,
    ),

    // B6.2 Canadá Billetes - Frontier Polymer Series (2011–presente)
    // Ref General: Bank of Canada - Polymer Series:
    // https://www.bankofcanada.ca/banknotes/bank-note-series/polymer-series/
    // Denominación - Modelo / Referencias:
    // - 5 Dollars (Polímero - Sir Wilfrid Laurier / Canadarm2): https://www.bankofcanada.ca/banknotes/bank-note-series/polymer-series/
    // - 10 Dollars (Polímero - Sir John A. Macdonald / Viola Desmond / The Canadian Train): https://www.bankofcanada.ca/banknotes/bank-note-series/polymer-series/
    // - 20 Dollars (Polímero - Reina Isabel II / Canadian National Vimy Memorial): https://www.bankofcanada.ca/banknotes/bank-note-series/polymer-series/
    // - 50 Dollars (Polímero - W.L. Mackenzie King / CCGS Amundsen): https://www.bankofcanada.ca/banknotes/bank-note-series/polymer-series/
    // - 100 Dollars (Polímero - Sir Robert Borden / Innovación Médica e Insulina): https://www.bankofcanada.ca/banknotes/bank-note-series/polymer-series/
    NumismaticEmissionRuleData(
      country: 'Canadá',
      minYear: 2011,
      maxYear: 2100,
      validCurrencies: ['CAD'],
      defaultCurrency: 'CAD',
      denominations: ['5', '10', '20', '50', '100'],
      denominationMaterials: {
        '5': 'Polímero',
        '10': 'Polímero',
        '20': 'Polímero',
        '50': 'Polímero',
        '100': 'Polímero',
      },
      isBanknote: true,
    ),

    // B7.1 Cuba Billetes - Período Socialista y Régimen Dual (1961–2020)
    // Ref General: Banco Central de Cuba - Billetes Históricos: https://www.bc.gob.cu
    // Denominación - Modelo / Referencias:
    // - 1 a 1000 Pesos (José Martí, Che Guevara, Antonio Maceo, Máximo Gómez, Camilo Cienfuegos, Calixto García, Frank País, Ignacio Agramonte, Julio Antonio Mella): https://www.bc.gob.cu
    NumismaticEmissionRuleData(
      country: 'Cuba',
      minYear: 1961,
      maxYear: 2020,
      validCurrencies: ['CUP', 'CUC'],
      defaultCurrency: 'CUP',
      denominations: ['1', '3', '5', '10', '20', '50', '100', '200', '500', '1000'],
      denominationMaterials: {
        '1': 'Papel de algodón',
        '3': 'Papel de algodón',
        '5': 'Papel de algodón',
        '10': 'Papel de algodón',
        '20': 'Papel de algodón',
        '50': 'Papel de algodón',
        '100': 'Papel de algodón',
        '200': 'Papel de algodón',
        '500': 'Papel de algodón',
        '1000': 'Papel de algodón',
      },
      isBanknote: true,
    ),

    // B7.2 Cuba Billetes - Unificación Monetaria (2021–presente)
    // Ref General: Banco Central de Cuba - Ordenamiento Monetario: https://www.bc.gob.cu
    // Denominación - Modelo / Referencias:
    // - 1 a 1000 Pesos (José Martí, Che Guevara, Antonio Maceo, Máximo Gómez, Camilo Cienfuegos, Calixto García, Frank País, Ignacio Agramonte, Julio Antonio Mella): https://www.bc.gob.cu
    NumismaticEmissionRuleData(
      country: 'Cuba',
      minYear: 2021,
      maxYear: 2100,
      validCurrencies: ['CUP'],
      defaultCurrency: 'CUP',
      denominations: ['1', '3', '5', '10', '20', '50', '100', '200', '500', '1000'],
      denominationMaterials: {
        '1': 'Papel de algodón',
        '3': 'Papel de algodón',
        '5': 'Papel de algodón',
        '10': 'Papel de algodón',
        '20': 'Papel de algodón',
        '50': 'Papel de algodón',
        '100': 'Papel de algodón',
        '200': 'Papel de algodón',
        '500': 'Papel de algodón',
        '1000': 'Papel de algodón',
      },
      isBanknote: true,
    ),

    // B8.1 Argentina Billetes - Peso Convertible y Emisiones Modernas (1992–presente)
    // Ref General: Banco Central de la República Argentina - Billetes en circulación:
    // https://www.bcra.gob.ar/mediospago/billetes_emisiones_vigentes.asp
    // Denominación - Modelo / Referencias:
    // - 1 Peso (Carlos Pellegrini): https://www.bcra.gob.ar
    // - 2 Pesos (Bartolomé Mitre): https://www.bcra.gob.ar
    // - 5 Pesos (General José de San Martín): https://www.bcra.gob.ar
    // - 10 Pesos (Manuel Belgrano): https://www.bcra.gob.ar
    // - 20 Pesos (Juan Manuel de Rosas / Guanaco): https://www.bcra.gob.ar
    // - 50 Pesos (Domingo Faustino Sarmiento / Islas Malvinas / Cóndor Andino): https://www.bcra.gob.ar
    // - 100 Pesos (Julio Argentino Roca / Eva Duarte de Perón / Taruca): https://www.bcra.gob.ar
    // - 200 Pesos (Ballena Franca Austral): https://www.bcra.gob.ar
    // - 500 Pesos (Yaguareté): https://www.bcra.gob.ar
    // - 1000 Pesos (Hornero / José de San Martín): https://www.bcra.gob.ar
    // - 2000 Pesos (Cecilia Grierson y Ramón Carrillo / Instituto Malbrán): https://www.bcra.gob.ar
    // - 10000 Pesos (Manuel Belgrano y María Remedios del Valle): https://www.bcra.gob.ar
    // - 20000 Pesos (Juan Bautista Alberdi): https://www.bcra.gob.ar
    NumismaticEmissionRuleData(
      country: 'Argentina',
      minYear: 1992,
      maxYear: 2100,
      validCurrencies: ['ARS'],
      defaultCurrency: 'ARS',
      denominations: ['1', '2', '5', '10', '20', '50', '100', '200', '500', '1000', '2000', '10000', '20000'],
      denominationMaterials: {
        '1': 'Papel de algodón',
        '2': 'Papel de algodón',
        '5': 'Papel de algodón',
        '10': 'Papel de algodón',
        '20': 'Papel de algodón',
        '50': 'Papel de algodón',
        '100': 'Papel de algodón',
        '200': 'Papel de algodón',
        '500': 'Papel de algodón',
        '1000': 'Papel de algodón',
        '2000': 'Papel de algodón',
        '10000': 'Papel de algodón',
        '20000': 'Papel de algodón',
      },
      isBanknote: true,
    ),

    // B9.1 Brasil Billetes - Real 1ª y 2ª Familia (1994–presente)
    // Ref General: Banco Central do Brasil - Cédulas do Real:
    // https://www.bcb.gov.br/cedulasemoedas/cedulasreal
    // Denominación - Modelo / Referencias:
    // - 1 Real (Beija-flor): https://www.bcb.gov.br/cedulasemoedas/cedulasreal
    // - 2 Reais (Tartaruga-marinha): https://www.bcb.gov.br/cedulasemoedas/cedulasreal
    // - 5 Reais (Garça): https://www.bcb.gov.br/cedulasemoedas/cedulasreal
    // - 10 Reais (Arara / Conmemorativa Polímero Cabral 2000): https://www.bcb.gov.br/cedulasemoedas/cedulasreal
    // - 20 Reais (Mico-leão-dourado): https://www.bcb.gov.br/cedulasemoedas/cedulasreal
    // - 50 Reais (Onça-pintada): https://www.bcb.gov.br/cedulasemoedas/cedulasreal
    // - 100 Reais (Garoupa): https://www.bcb.gov.br/cedulasemoedas/cedulasreal
    // - 200 Reais (Lobo-guará): https://www.bcb.gov.br/cedulasemoedas/cedulasreal
    NumismaticEmissionRuleData(
      country: 'Brasil',
      minYear: 1994,
      maxYear: 2100,
      validCurrencies: ['BRL'],
      defaultCurrency: 'BRL',
      denominations: ['1', '2', '5', '10', '20', '50', '100', '200'],
      denominationMaterials: {
        '1': 'Papel de algodón',
        '2': 'Papel de algodón',
        '5': 'Papel de algodón',
        '10': 'Papel de algodón',
        '20': 'Papel de algodón',
        '50': 'Papel de algodón',
        '100': 'Papel de algodón',
        '200': 'Papel de algodón',
      },
      denominationAllowedMaterials: {
        '10': ['Papel de algodón', 'Polímero'],
      },
      isBanknote: true,
    ),

    // B10.1 Chile Billetes - Peso Chileno y Familias Bicentenario (1975–presente)
    // Ref General: Banco Central de Chile - Billetes en circulación:
    // https://www.bcentral.cl/billetes-y-monedas/billetes
    // Denominación - Modelo / Referencias:
    // - 500 Pesos (Papel de algodón - Raúl Silva Henríquez): https://www.bcentral.cl/billetes-y-monedas/billetes
    // - 1000 Pesos (Polímero - Ignacio Carrera Pinto / Torres del Paine): https://www.bcentral.cl/billetes-y-monedas/billetes
    // - 2000 Pesos (Polímero - Manuel Rodríguez / Reserva Nalcas): https://www.bcentral.cl/billetes-y-monedas/billetes
    // - 5000 Pesos (Polímero - Gabriela Mistral / Parque La Campana): https://www.bcentral.cl/billetes-y-monedas/billetes
    // - 10000 Pesos (Papel de algodón - Arturo Prat / Parque Alberto de Agostini): https://www.bcentral.cl/billetes-y-monedas/billetes
    // - 20000 Pesos (Papel de algodón - Andrés Bello / Salar de Surire): https://www.bcentral.cl/billetes-y-monedas/billetes
    NumismaticEmissionRuleData(
      country: 'Chile',
      minYear: 1975,
      maxYear: 2100,
      validCurrencies: ['CLP'],
      defaultCurrency: 'CLP',
      denominations: ['500', '1000', '2000', '5000', '10000', '20000'],
      denominationMaterials: {
        '500': 'Papel de algodón',
        '1000': 'Polímero',
        '2000': 'Polímero',
        '5000': 'Polímero',
        '10000': 'Papel de algodón',
        '20000': 'Papel de algodón',
      },
      isBanknote: true,
    ),

    // B11.1 Perú Billetes - Nuevo Sol y Familias Bicentenario (1991–presente)
    // Ref General: Banco Central de Reserva del Perú - Billetes en circulación:
    // https://www.bcrp.gob.pe/billetes-y-monedas/billetes.html
    // Denominación - Modelo / Referencias:
    // - 10 Soles (José Abelardo Quiñones / Chabuca Granda): https://www.bcrp.gob.pe
    // - 20 Soles (Raúl Porras Barrenechea / José María Arguedas): https://www.bcrp.gob.pe
    // - 50 Soles (Abraham Valdelomar / María Rostworowski): https://www.bcrp.gob.pe
    // - 100 Soles (Jorge Basadre / Pedro Paulet): https://www.bcrp.gob.pe
    // - 200 Soles (Santa Rosa de Lima / Tilsa Tsuchiya): https://www.bcrp.gob.pe
    NumismaticEmissionRuleData(
      country: 'Perú',
      minYear: 1991,
      maxYear: 2100,
      validCurrencies: ['PEN'],
      defaultCurrency: 'PEN',
      denominations: ['10', '20', '50', '100', '200'],
      denominationMaterials: {
        '10': 'Papel de algodón',
        '20': 'Papel de algodón',
        '50': 'Papel de algodón',
        '100': 'Papel de algodón',
        '200': 'Papel de algodón',
      },
      denominationAllowedMaterials: {
        '10': ['Papel de algodón', 'Polímero'],
        '20': ['Papel de algodón', 'Polímero'],
        '50': ['Papel de algodón', 'Polímero'],
      },
      isBanknote: true,
    ),

    // B12.1 Reino Unido Billetes - Series D, E, F y Polymer Series (1970–presente)
    // Ref General: Bank of England - Current Banknotes & Polymer Series:
    // https://www.bankofengland.co.uk/banknotes
    // Denominación - Modelo / Referencias:
    // - 5 Pounds (Polímero - Sir Winston Churchill / Queen Elizabeth II / King Charles III): https://www.bankofengland.co.uk/banknotes
    // - 10 Pounds (Polímero - Jane Austen / Queen Elizabeth II / King Charles III): https://www.bankofengland.co.uk/banknotes
    // - 20 Pounds (Polímero - J.M.W. Turner / Queen Elizabeth II / King Charles III): https://www.bankofengland.co.uk/banknotes
    // - 50 Pounds (Polímero - Alan Turing / Queen Elizabeth II / King Charles III): https://www.bankofengland.co.uk/banknotes
    NumismaticEmissionRuleData(
      country: 'Reino Unido',
      minYear: 1970,
      maxYear: 2100,
      validCurrencies: ['GBP'],
      defaultCurrency: 'GBP',
      denominations: ['5', '10', '20', '50'],
      denominationMaterials: {
        '5': 'Polímero',
        '10': 'Polímero',
        '20': 'Polímero',
        '50': 'Polímero',
      },
      denominationAllowedMaterials: {
        '5': ['Polímero', 'Papel de algodón'],
        '10': ['Polímero', 'Papel de algodón'],
        '20': ['Polímero', 'Papel de algodón'],
        '50': ['Polímero', 'Papel de algodón'],
      },
      isBanknote: true,
    ),

    // B13.1 Francia Billetes - Nouveau Franc (1960–2001)
    // Ref General: Banque de France - Histoire des billets: https://www.banque-france.fr
    // Denominación - Modelo / Referencias:
    // - 5, 10, 20, 50, 100, 200, 500 Francs (Victor Hugo, Voltaire, Berlioz, Debussy, Quentin de La Tour, Saint-Exupéry, Delacroix, Cézanne, Gustave Eiffel, Pierre et Marie Curie): https://www.banque-france.fr
    NumismaticEmissionRuleData(
      country: 'Francia',
      minYear: 1960,
      maxYear: 2001,
      validCurrencies: ['FRF'],
      defaultCurrency: 'FRF',
      denominations: ['5', '10', '20', '50', '100', '200', '500'],
      denominationMaterials: {
        '5': 'Papel de algodón',
        '10': 'Papel de algodón',
        '20': 'Papel de algodón',
        '50': 'Papel de algodón',
        '100': 'Papel de algodón',
        '200': 'Papel de algodón',
        '500': 'Papel de algodón',
      },
      isBanknote: true,
    ),

    // B14.1 Alemania Billetes - Deutsche Mark Series (1948–2001)
    // Ref General: Deutsche Bundesbank - DM-Banknoten:
    // https://www.bundesbank.de/de/aufgaben/bargeld/dm-banknoten-und-dm-muenzen
    // Denominación - Modelo / Referencias:
    // - 5, 10, 20, 50, 100, 200, 500, 1000 DM (Bettina von Arnim, Gauss, Droste-Hülshoff, Neumann, Clara Schumann, Paul Ehrlich, Maria Sibylla Merian, Gebrüder Grimm): https://www.bundesbank.de
    NumismaticEmissionRuleData(
      country: 'Alemania',
      minYear: 1948,
      maxYear: 2001,
      validCurrencies: ['DEM', 'DDM'],
      defaultCurrency: 'DEM',
      denominations: ['5', '10', '20', '50', '100', '200', '500', '1000'],
      denominationMaterials: {
        '5': 'Papel de algodón',
        '10': 'Papel de algodón',
        '20': 'Papel de algodón',
        '50': 'Papel de algodón',
        '100': 'Papel de algodón',
        '200': 'Papel de algodón',
        '500': 'Papel de algodón',
        '1000': 'Papel de algodón',
      },
      isBanknote: true,
    ),

    // B15.1 Italia Billetes - Lira Italiana (1946–2001)
    // Ref General: Banca d'Italia - Banconote della Lira: https://www.bancaditalia.it
    // Denominación - Modelo / Referencias:
    // - 500, 1000, 2000, 5000, 10000, 50000, 100000, 500000 Liras (Mercurio, Verdi, Montessori, Galilei, Marconi, Colombo, Bellini, Volta, Bernini, Caravaggio, Raffaello): https://www.bancaditalia.it
    NumismaticEmissionRuleData(
      country: 'Italia',
      minYear: 1946,
      maxYear: 2001,
      validCurrencies: ['ITL'],
      defaultCurrency: 'ITL',
      denominations: ['500', '1000', '2000', '5000', '10000', '50000', '100000', '500000'],
      denominationMaterials: {
        '500': 'Papel de algodón',
        '1000': 'Papel de algodón',
        '2000': 'Papel de algodón',
        '5000': 'Papel de algodón',
        '10000': 'Papel de algodón',
        '50000': 'Papel de algodón',
        '100000': 'Papel de algodón',
        '500000': 'Papel de algodón',
      },
      isBanknote: true,
    ),
  ];
}

/// Metadata record representing a country's currency epoch emission rules (Coins or Banknotes).
class NumismaticEmissionRuleData {
  final String country;
  final int minYear;
  final int maxYear;
  final List<String> validCurrencies;
  final String? defaultCurrency;
  final List<String> denominations;
  final Map<String, String> denominationMaterials;
  final Map<String, List<String>> denominationAllowedMaterials;
  final Set<String> commemorativeDenominations;
  final List<String> commemorativeReasons;
  final Map<String, List<String>> commemorativeMotifsByDenomination;
  final String? defaultCommemorativeReason;
  final bool isBanknote;

  const NumismaticEmissionRuleData({
    required this.country,
    required this.minYear,
    required this.maxYear,
    required this.validCurrencies,
    this.defaultCurrency,
    required this.denominations,
    this.denominationMaterials = const {},
    this.denominationAllowedMaterials = const {},
    this.commemorativeDenominations = const {},
    this.commemorativeReasons = const [],
    this.commemorativeMotifsByDenomination = const {},
    this.defaultCommemorativeReason,
    this.isBanknote = false,
  });

  bool matches(String targetCountry, int year, {bool isBanknote = false}) {
    if (country.toLowerCase() != targetCountry.trim().toLowerCase()) return false;
    if (this.isBanknote != isBanknote) return false;
    return year >= minYear && year <= maxYear;
  }

  bool hasDenomination(String targetDenom) {
    return denominations.any((d) => matchesDenomination(d, targetDenom));
  }

  List<String> getAllowedMaterialsForDenomination(String targetDenom) {
    for (final entry in denominationAllowedMaterials.entries) {
      if (matchesDenomination(entry.key, targetDenom)) {
        return entry.value;
      }
    }
    final singleMat = getMaterialForDenomination(targetDenom);
    if (singleMat != null) {
      return [singleMat];
    }
    return const [];
  }

  String? getMaterialForDenomination(String targetDenom) {
    if (denominationMaterials.containsKey(targetDenom)) {
      return denominationMaterials[targetDenom];
    }
    for (final entry in denominationMaterials.entries) {
      if (matchesDenomination(entry.key, targetDenom)) {
        return entry.value;
      }
    }
    for (final entry in denominationAllowedMaterials.entries) {
      if (matchesDenomination(entry.key, targetDenom) && entry.value.isNotEmpty) {
        return entry.value.first;
      }
    }
    return null;
  }

  bool isMaterialValidForDenomination(String targetDenom, String targetMaterial) {
    final allowed = getAllowedMaterialsForDenomination(targetDenom);
    if (allowed.isEmpty) return true;
    final cleanTarget = targetMaterial.trim().toLowerCase();
    return allowed.any((mat) => mat.trim().toLowerCase() == cleanTarget);
  }

  bool isCommemorativeDenomination(String targetDenom) {
    if (commemorativeDenominations.isNotEmpty) {
      return commemorativeDenominations.any((d) => matchesDenomination(d, targetDenom));
    }
    return false;
  }

  List<String> getCommemorativeMotifsForDenomination(String targetDenom) {
    for (final entry in commemorativeMotifsByDenomination.entries) {
      if (matchesDenomination(entry.key, targetDenom)) {
        return entry.value;
      }
    }
    if (commemorativeReasons.isNotEmpty) {
      if (commemorativeDenominations.isEmpty || isCommemorativeDenomination(targetDenom)) {
        return commemorativeReasons;
      }
    }
    if (defaultCommemorativeReason != null && defaultCommemorativeReason!.trim().isNotEmpty) {
      if (commemorativeDenominations.isEmpty || isCommemorativeDenomination(targetDenom)) {
        return [defaultCommemorativeReason!];
      }
    }
    return const [];
  }

  bool isMotifValidForDenomination(String targetDenom, String targetMotif) {
    final motifs = getCommemorativeMotifsForDenomination(targetDenom);
    if (motifs.isEmpty) return true;
    final clean = targetMotif.trim().toLowerCase();
    return motifs.any((m) {
      final mClean = m.trim().toLowerCase();
      return mClean == clean || mClean.contains(clean) || clean.contains(mClean);
    });
  }

  static bool matchesDenomination(String d1, String d2) {
    final s1 = d1.trim().toLowerCase();
    final s2 = d2.trim().toLowerCase();
    if (s1 == s2) return true;
    final num1 = _parseDenominationNumber(s1);
    final num2 = _parseDenominationNumber(s2);
    if (num1 != null && num2 != null) {
      return (num1 - num2).abs() < 0.0001;
    }
    return false;
  }

  static double? _parseDenominationNumber(String val) {
    final direct = double.tryParse(val);
    if (direct != null) return direct;
    if (val.contains('/')) {
      final parts = val.split('/');
      if (parts.length == 2) {
        final numerator = double.tryParse(parts[0].trim());
        final denominator = double.tryParse(parts[1].trim());
        if (numerator != null && denominator != null && denominator != 0) {
          return numerator / denominator;
        }
      }
    }
    return null;
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
