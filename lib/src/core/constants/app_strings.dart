class AppStrings {
  AppStrings._();

  // Navegación y General
  static const appName = 'PWMS';
  static const appTitle = 'PWMS: Gestión de Mundo';
  static const searchHint = 'Buscar en el mundo...';
  static const rootLocationName = 'Mundo';
  static const cancel = 'Cancelar';
  static const save = 'Guardar';
  static const delete = 'Eliminar';
  static const edit = 'Editar';
  static const move = 'Trasladar';
  static const link = 'Relacionar';
  static const attachFile = 'Adjuntar archivo';
  static const confirm = 'Confirmar';
  static const close = 'Cerrar';
  static const add = 'Agregar';
  static const addShort = 'Añadir';
  static const change = 'Cambiar';
  static const viewAll = 'Ver todo';
  static const apply = 'Aplicar';
  static const all = 'Todos';
  static const selectOptionPrompt = 'Selecciona una opción.';
  static const selectMagnitudePrompt = 'Selecciona una magnitud.';
  static const errorPrefix = 'Error: ';
  static const errorGeneric = 'Ha ocurrido un error inesperado.';

  // Pestañas y Navegación Principal
  static const tabHome = 'Inicio';
  static const tabEntities = 'Instancias';
  static const tabLocations = 'Ubicaciones';
  static const tabCatalog = 'Catálogo';
  static const tabHistory = 'Historial';
  static const tabSearch = 'Buscar';

  // Pantalla de Inicio
  static const recentEntitiesTitle = 'Instancias recientes';
  static const activityTitle = 'Historial de actividad';
  static const universeCatalogTitle = 'Catálogo de especies';
  static const locationsTitle = 'Grafo de ubicaciones';
  static const noRecentObjects = 'Sin objetos recientes.';
  static const mainLocations = 'Ubicaciones principales';
  static const objectsCountSuffix = 'objetos';
  static const latestCatalogSpecies = 'Últimas especies en catálogo';
  static const viewCatalog = 'Ver catálogo';
  static const noRecentActivity = 'Sin actividad reciente.';
  static const topLocationsTitle = 'Ubicaciones principales';
  static const objectsLabel = 'objetos';
  static const viewCatalogAction = 'Ver catálogo';
  static const viewAllAction = 'Ver todo';

  // Tipos y Plantillas de Entidades
  static const typeObject = 'Objeto';
  static const typeLivingBeing = 'Ser vivo';
  static const typeDocument = 'Documento';
  static const typeProject = 'Proyecto';
  static const typeMemory = 'Recuerdo';

  // Formularios y Terminología de Registro
  static const registerObjectTitle = 'Registrar en el mundo';
  static const editInstanceTitle = 'Editar instancia';
  static const nameLabel = 'Nombre de especie';
  static const typeLabel = 'Tipo de especie';
  static const locationLabel = 'Ubicación';
  static const quantityLabel = 'Magnitud';
  static const unitLabel = 'Unidad';
  static const barcodeLabel = 'Código de barras';
  static const notesLabel = 'Notas de instancia';
  static const descriptionLabel = 'Descripción técnica';
  static const brandLabel = 'Marca';
  static const isUniqueLabel = 'Especie única';
  static const monetaryValueLabel = 'Valor monetario';
  static const currencyLabel = 'Moneda';
  static const isSaleLabel = 'Registrar como venta';
  static const takePhoto = 'Tomar fotografía';
  static const chooseGallery = 'Elegir de galería';
  static const photoLabel = 'Fotografía principal';
  static const chooseFromCatalog = 'Elegir del catálogo';
  static const showMoreFields = 'Más campos';
  static const showFewerFields = 'Menos campos';
  static const registerAction = 'Registrar en el mundo';
  static const saveChangesAction = 'Guardar cambios';
  static const changePhotoAction = 'Cambiar fotografía';
  static const deletePhotoAction = 'Borrar imagen';
  static const deleteMainPhotoAction = 'Borrar imagen principal';
  static const confirmDeletePhotoTitle = 'Eliminar imagen';
  static const confirmDeletePhotoMessage = '¿Estás seguro de que deseas eliminar la imagen principal? Se borrará el archivo asociado.';
  static const photoDeletedSuccess = 'Imagen eliminada con éxito.';
  static const selectFromCatalogChoice = 'Elegir del catálogo';
  static const createNewSpeciesChoice = 'Crear nueva especie';
  static const instantiateTab = 'Instanciar';
  static const createSpeciesTab = 'Crear especie';
  static const addSubspeciesTab = 'Crear subespecie';
  static const autoFillTab = 'Autollenado';
  static const addSubspeciesChoice = 'Agregar subespecie';

  // Catálogo de Especies
  static const catalogTitle = 'Catálogo de especies';
  static const newSpeciesTitle = 'Nueva especie';
  static const createSpeciesHeader = 'Crear especie en catálogo';
  static const saveSpeciesAction = 'Guardar especie';
  static const instantiateAction = 'Instanciar';
  static const emptyCatalog = 'Catálogo vacío.';
  static const singleInstanceError = 'Esta especie es única y ya existe en tu mundo.';
  static const singleInstanceSubspeciesError = 'La subespecie de esta especie única ya existe en tu mundo.';
  static const duplicateSpeciesNameError = 'Ya existe una especie con este nombre.';
  static const duplicatePhotoError = 'Ya existe una especie con esta misma imagen.';
  static const duplicateAttachmentError = 'Este archivo adjunto ya existe en la especie.';
  static const latestCatalogSpeciesTitle = 'Últimas especies en el catálogo';

  // Subespecies y Variantes
  static const subspeciesTitle = 'Subespecies';
  static const subspeciesCountTitle = 'Subespecies';
  static const addSubspecies = 'Añadir subespecie';
  static const addBrand = 'Agregar subespecie';
  static const noSubspecies = 'Sin subespecies registradas.';
  static const noSubspeciesDefined = 'Sin subespecies.';
  static const subspeciesNameLabel = 'Nombre de subespecie';
  static const editSubspecies = 'Editar subespecie';
  static const deleteSubspecies = 'Eliminar subespecie';
  static const defaultSubspeciesName = 'Genérica';
  static const viewCatalogSpecies = 'Ver especie en catálogo';
  static const viewSpeciesDetail = 'Ver detalle de especie';
  static const masterCatalogSpeciesBadge = 'CATÁLOGO MAESTRO';
  static const registeredPropertiesAndMagnitudes = 'Propiedades y magnitudes registradas';
  static const notInstantiatedYet = 'Esta especie aún no ha sido instanciada.';
  static const registeredInstance = 'Instancia registrada';
  static const speciesInstantiatedSuccess = 'Especie instanciada con éxito.';
  static const selectSpeciesToInstantiate = 'Selecciona una especie para instanciar.';
  static const instantiateCatalogSpeciesHeader = 'Instanciar especie de catálogo';
  static const catalogSpeciesLabel = 'Especie de catálogo';
  static const selectSpeciesPrompt = 'Selecciona una especie...';
  static const physicalLocation = 'Ubicación física';
  static const savedInContainer = 'Guardado en contenedor';
  static const selectContainerPrompt = 'Selecciona contenedor:';
  static const noContainerObjectsAvailable = 'Sin objetos contenedores disponibles.';
  static const selectContainerObject = 'Selecciona objeto contenedor';
  static const containerObjectLabel = 'Objeto contenedor';
  static const magnitudesAndSpecificProps = 'Magnitudes y propiedades:';
  static const subspeciesOrBrandCommercialLabel = 'Subespecie';
  static const selectSubspeciesOrBrandPrompt = 'Selecciona subespecie';
  static const quantityToInstantiateLabel = 'Cantidad';
  static const addPropertyOrUnitTitle = 'Agregar propiedad o unidad';
  static const propertyNameHint = 'Nombre de la propiedad';
  static const selectUnitPrompt = 'Seleccionar unidad de medida';
  static const editSubspeciesDraftTitle = 'Editar subespecie';
  static const newSubspeciesVariantTitle = 'Nueva subespecie';
  static const subspeciesPhotoLabel = 'Fotografía de subespecie';
  static const nameOrVariantLabel = 'Nombre';
  static const nameOrVariantHint = 'Nombre';
  static const brandHint = 'Marca';
  static const barcodeHint = 'Código de barras';
  static const notesSpecialEditionHint = 'Notas';
  static const editSpeciesTitle = 'Editar especie';
  static const createSpeciesTitle = 'Crear nueva especie';
  static const noTemplate = 'Sin plantilla';
  static const selectBaseSpeciesPrompt = 'Seleccionar especie base';
  static const useSpeciesAsBaseTemplate = 'Usar especie como plantilla base';
  static const selectBaseTemplateHint = 'Seleccionar plantilla...';
  static const nameIsImmutable = 'El nombre es inmutable.';
  static const unitsAndMagnitudesTitle = 'Unidades de medida';
  static const addUnitAction = 'Agregar medida';
  static const noAdditionalUnitsAdded = 'Sin unidades adicionales agregadas.';
  static const removeUnitAction = 'Eliminar unidad de medida';
  static const subspeciesOrBrands = 'Subespecies';
  static const addBrandAction = 'Agregar subespecie';
  static const noSubspeciesOrBrandsAdded = 'Sin subespecies agregadas.';
  static const noBarcode = 'Sin código de barras';
  static const chooseFromCatalogAction = 'Elegir del catálogo';
  static const createNewSpeciesAction = 'Crear nueva especie';
  static const createFirstSpeciesAction = 'Crear primera especie';
  static const cannotDeleteOnlySubspecies = 'No se puede eliminar la única subespecie de una especie.';
  static const cannotDeleteOnlySubspeciesTooltip = 'No se puede eliminar la única subespecie.';
  static const subspeciesLabel = 'Subespecie:';

  // Ubicaciones y Grafo Jerárquico
  static const locationsGraphTitle = 'Ubicaciones';
  static const newLocationTitle = 'Nueva ubicación';
  static const newSubLocationTitle = 'Nueva ubicación hija';
  static const childLocationsTitle = 'Ubicaciones hijas';
  static const createNodeHeader = 'Crear ubicación';
  static const locationNameLabel = 'Nombre de ubicación';
  static const locationDescriptionLabel = 'Descripción de ubicación';
  static const createObjectHere = 'Instanciar aquí';
  static const storedObjectsTitle = 'Instancias almacenadas aquí';
  static const emptyLocation = 'Ubicación vacía.';
  static const selectLocationPrompt = 'Seleccionar ubicación';
  static const locationHasNoObjectsOrSublocations = 'Ubicación vacía.';
  static const containerLabel = 'Contenedor';
  static const cannotMoveLocationSelfError = 'Ubicación destino no válida.';
  static const circularLocationError = 'Ubicación destino no válida.';
  static const instantiateObjectHere = 'Instanciar objeto aquí';
  static const treeView = 'Vista de árbol';
  static const graphView = 'Vista de grafo';
  static const previousLocation = 'Ubicación previa';
  static const newGraphLocation = 'Nueva ubicación en el grafo';
  static const movedSuccessfullyGraph = 'trasladado exitosamente en el grafo.';
  static const moveErrorPrefix = 'Error al mover: ';
  static const moveInGraph = 'Trasladar en el grafo';
  static const selectNewLocationOrContainer = 'Selecciona la nueva ubicación o contenedor:';
  static const createLocationOnTheFly = 'Crear nueva ubicación';
  static const locationNameHint = 'Nombre de ubicación';
  static const confirmMoveAction = 'Confirmar traslado';
  static const locationGraphNode = 'Ubicación en el grafo';

  // Detalle, Archivos y Confirmaciones
  static const masterDescription = 'Descripción maestra';
  static const attachmentsTitle = 'Archivos y documentos adjuntos';
  static const emptyAttachments = 'Sin archivos adjuntos.';
  static const deleteConfirmationTitle = 'Eliminar elemento';
  static const deleteConfirmationMessage = '¿Deseas eliminar este elemento de tu mundo?';
  static const zeroQuantityMessage = 'La magnitud llegó a cero. ¿Deseas eliminar la instancia?';
  static const mustProvideEntityOrGroup = 'Debe proporcionarse entidad o grupo.';
  static const photoNotAvailable = 'Fotografía no disponible.';
  static const instanceUpdatedSuccess = 'Instancia actualizada con éxito.';
  static const updateErrorPrefix = 'Error al actualizar: ';
  static const instantiatedObject = 'Objeto instanciado';
  static const graphLocationOrContainer = 'Ubicación o contenedor';
  static const instanceNotesLabel = 'Notas';
  static const specificDetailsHint = 'Detalles';

  // Unidades y Categorías de Medida
  static const unitCategoryPhysical = 'Magnitudes físicas';
  static const unitCategoryDigital = 'Almacenamiento digital';
  static const unitCategoryFinancial = 'Finanzas';
  static const unitCategoryTime = 'Tiempo';
  static const unitCategoryAbstract = 'General';
  static const unitUnits = 'unidades';
  static const unitUnitSingle = 'unidad';
  static const unitPieces = 'piezas';
  static const unitKg = 'kg';
  static const unitGrams = 'g';
  static const unitLiters = 'L';
  static const unitMeters = 'm';
  static const unitsLabel = 'unidades';

  // Servicio de Almacenamiento Local
  static const fileNotFoundInStorage = 'Archivo no encontrado en almacenamiento local.';
  static const fileDeleteFailure = 'Error al eliminar el archivo local.';

  // Requisitos y Dependencias (NECESITA)
  static const requirementsTitle = 'Relaciones de necesidad';
  static const addRequirement = 'Añadir requisito';
  static const addRequirementTitle = 'Agregar requisito';
  static const noRequirements = 'Sin requisitos registrados.';
  static const noRequirementsDefined = 'Sin necesidades definidas.';
  static const noCatalogSpeciesForRequirement = 'No hay especies en el catálogo para requerir.';
  static const selectRequiredSpeciesPrompt = 'Selecciona la especie requerida e indica la cantidad:';
  static const requiredSpeciesLabel = 'Especie requerida';
  static const requirementTypeLabel = 'Tipo de requisito';
  static const requirementTargetLabel = 'Elemento requerido';
  static const quantityRequiredLabel = 'Cantidad requerida';
  static const quantityRequiredHint = 'Cantidad';
  static const requirementNotesLabel = 'Notas del requisito';
  static const notesOptionalLabel = 'Notas';
  static const notesRequirementHint = 'Notas';
  static const needsPrefix = 'NECESITA';

  // Atributos y Plantillas Personalizadas
  static const customAttributesTitle = 'Atributos personalizados';
  static const noCustomAttributesDefined = 'Sin atributos personalizados definidos.';
  static const addAttributeTitle = 'Agregar atributo';
  static const attributeNameHint = 'Nombre del atributo';
  static const attributeValueHint = 'Valor';
  static const templateCustomCreate = 'Crear plantilla personalizada';
  static const templateNameLabel = 'Nombre de plantilla';
  static const templateExamplesHint = 'Nombre de plantilla';
  static const templateUnitsHintLabel = 'Unidades habituales separadas por coma';
  static const templateUnitsExamples = 'Unidades';
  static const saveTemplateAction = 'Guardar plantilla';
  static const customAttributeEditorTitle = 'Editor de atributo personalizado';
  static const attributeNameLabel = 'Nombre de atributo';
  static const attributeTypeLabel = 'Tipo de dato';
  static const attributeValueLabel = 'Valor';
  static const templateSavedSuccess = 'Plantilla guardada con éxito.';

  // Entidades, Demografía y Grupos
  static const noEntitiesRegistered = 'Sin objetos registrados.';
  static const instanceWorldHeader = 'INSTANCIA DEL MUNDO';
  static const addInstanceNotesHint = 'Añadir notas sobre esta instancia...';
  static const majorityDemographics = 'Demografía mayoritaria';
  static const standardSpeciesProfile = 'Perfil estándar de especie';
  static const dynamicPopulationManagement = 'Gestión dinámica de población';
  static const populationManagementInstruction = 'Ajusta la población con los botones o la cifra directamente.';
  static const populationLabel = 'Población';
  static const groupInstanceDetail = 'Detalle de instancias en grupo';
  static const noInstancesAvailableToDelete = 'Sin instancias disponibles para eliminar.';
  static const addByWheelTitle = 'Añadir por rueda de selección';
  static const removeByWheelTitle = 'Eliminar por rueda de selección';
  static const directPopulationAdjustmentTitle = 'Ajuste directo de población';
  static const currentPopulationLabel = 'Población actual';
  static const newTargetPopulationLabel = 'Nueva población objetivo';
  static const applyCalculationAction = 'Aplicar cálculo';
  static const noChangesLabel = 'Sin cambios';
  static const noInstancesToDelete = 'Sin instancias disponibles para eliminar.';
  static const addByWheel = 'Añadir por rueda de selección';
  static const removeByWheel = 'Eliminar por rueda de selección';
  static const noChanges = 'Sin cambios';
  static const directPopulationAdjustment = 'Ajuste directo de población';
  static const currentPopulation = 'Población actual:';
  static const newTargetPopulation = 'Nueva población objetivo';
  static const targetPopulationHint = 'Población';
  static const applyCalculation = 'Aplicar cálculo';

  // Relaciones y Grafo Semántico
  static const selectTargetEntityError = 'Selecciona una entidad objetivo.';
  static const selectDirectedRelationTypePrompt = 'Seleccionar tipo de relación dirigida';
  static const directedRelationTypeLabel = 'Tipo de relación dirigida';
  static const searchTargetEntityLabel = 'Buscar entidad destino';
  static const noEntitiesAvailableToRelate = 'Sin entidades disponibles para relacionar.';
  static const createDirectedRelationAction = 'Crear relación dirigida';
  static const circularRelationError = 'No se pueden crear vínculos circulares.';
  static const selectElementToRelate = 'Selecciona el elemento a relacionar';
  static const directedRelationCreatedSuccess = 'Relación dirigida creada con éxito.';
  static const saveRelationErrorPrefix = 'Error al guardar relación: ';
  static const sourceObjectLabel = 'Objeto origen';
  static const directedRelationInWorld = 'Relación dirigida en tu mundo';
  static const semanticRelationType = 'Tipo de vínculo semántico';
  static const targetOfRelation = 'Destino del vínculo:';
  static const noOtherRelationCandidates = 'Sin otros elementos disponibles para relacionar.';
  static const selectTargetElement = 'Selecciona elemento destino';
  static const targetObjectLabel = 'Objeto destino';
  static const establishDirectedRelation = 'Establecer vínculo dirigido';
  static const selectTargetEntity = 'Selecciona una entidad objetivo.';
  static const selectDirectedRelationType = 'Seleccionar tipo de relación dirigida';
  static const searchTargetEntity = 'Buscar entidad destino';
  static const targetInstanceLabel = 'Instancia destino';
  static const createDirectedRelation = 'Crear relación dirigida';
  static const interactiveRelationGraph = 'Grafo interactivo de relaciones';
  static const interactiveRelationsGraphTitle = 'Grafo interactivo de relaciones';
  static const noDirectedRelations = 'Sin relaciones dirigidas registradas.';
  static const noDirectedRelationsRegistered = 'Sin relaciones dirigidas registradas.';
  static const currentInstance = 'Instancia actual';
  static const currentInstanceLabel = 'Instancia actual';
  static const externalEntity = 'Entidad externa';
  static const sourceEntity = 'Entidad origen';
  static const sourceEntityLabel = 'Entidad origen';
  static const targetEntity = 'Entidad destino';
  static const targetEntityLabel = 'Entidad destino';
  static const deleteRelation = 'Eliminar relación';
  static const deleteRelationTooltip = 'Eliminar relación';
  static const loadRelationsErrorPrefix = 'Error al cargar relaciones: ';
  static const relationsLoadErrorPrefix = 'Error al cargar relaciones: ';
  static const centralInstancePrefix = 'Instancia central: ';
  static const centralInstanceLabel = 'Instancia central';

  // Historial de Actividad
  static const logRegistered = 'Registrado en tu mundo:';
  static const logEdited = 'Editado';
  static const logEditedInfo = 'Editada información de';
  static const logDeleted = 'Eliminado de tu mundo:';
  static const logMoved = 'Trasladado';
  static const logFrom = 'de';
  static const logTo = 'a';
  static const logFileAttached = 'Adjuntado archivo';
  static const logFileDeleted = 'Eliminado archivo';
  static const logRelationEstablished = 'Vínculo establecido:';
  static const logRelationDeleted = 'Vínculo eliminado:';
  static const logPhotoUpdated = 'Actualizada fotografía principal de';
  static const logPhotoDeleted = 'Eliminada fotografía principal de';
  static const logQuantityAdjusted = 'Cantidad ajustada de';
  static const noActivityRegistered = 'Sin actividad registrada.';

  // Pantalla de Búsqueda
  static const objectsCategory = 'Objetos';
  static const historyCategory = 'Historial';
  static const noHistoryResults = 'Sin resultados de historial.';

  // Notificaciones y Recordatorios
  static const notificationsAndRemindersTitle = 'Notificaciones y recordatorios';
  static const refreshAction = 'Actualizar';
  static const noPendingNotifications = 'Sin notificaciones pendientes.';
  static const allElementsUpToDate = 'Todos tus elementos están al día y requerimientos cubiertos.';
  static const loadNotificationsErrorPrefix = 'Error al cargar notificaciones: ';
  static const snoozeReminderTitle = 'Posponer recordatorio';
  static const snoozeReminderPrompt = 'Selecciona la duración para ocultar este aviso:';
  static const snoozeOneDay = 'Posponer 1 día';
  static const snoozeThreeDays = 'Posponer 3 días';
  static const snoozeOneWeek = 'Posponer 1 semana';
  static const snoozeAction = 'Posponer';
  static const dismissAction = 'Descartar';
  static const expiredItemTitle = 'Elemento caducado';
  static const expiringSoonTitle = 'Caducidad próxima';
  static const unsatisfiedNeedTitle = 'Requisito no cubierto';

  // Formularios de Subespecie y Edición
  static const searchPhotoOnWebAction = 'Buscar foto en la web';
  static const brandOptionalLabel = 'Marca';
  static const barcodeOptionalLabel = 'Código de barras';
  static const specialNotesOptionalLabel = 'Notas de edición especial';
  static const cannotDeleteSpeciesWithInstancesError = 'No se puede eliminar una especie con instancias registradas.';
  static const expirationDateLabel = 'Fecha de caducidad';
  static const noExpirationDateAssigned = 'Sin fecha asignada';
  static const expiredDaysAgoPrefix = 'Vencido hace ';
  static const expiredDaysAgoSuffix = ' días';
  static const expiresInDaysAlertPrefix = '¡Vence en ';
  static const expiresInDaysAlertSuffix = ' días!';
  static const expiresInDaysPrefix = 'Vence en ';
  static const expiresInDaysSuffix = ' días';
  static const objectsInLocationAndSublocationsSuffix = ' objetos contenidos';
  static const moveSubspeciesTitle = 'Mover subespecie';
  static const targetSpeciesLabel = 'Nueva especie destino';
  static const subspeciesMovedSuccessPrefix = 'Subespecie movida a ';
  static const moveSubspeciesErrorPrefix = 'Error al mover subespecie: ';
  static const associatedSpeciesLabel = 'Especie asociada:';
  static const separateAction = 'Separar';
  static const subspeciesSeparatedSuccessPrefix = 'Subespecie separada en la especie ';
  static const separateSubspeciesErrorPrefix = 'Error al separar subespecie: ';
  static const noOtherSpeciesToMoveError = 'Sin otras especies disponibles para mover.';
  static const noOtherSpeciesToMergeError = 'Sin otras especies disponibles para fusionar.';
  static const mergeSpeciesTitle = 'Unir especie';
  static const mergeSpeciesAction = 'Unir especies';
  static const speciesMergedSuccessPrefix = 'Especie "';
  static const speciesMergedSuccessMiddle = '" unida exitosamente en "';
  static const separateInNewSpeciesTitle = 'Separar en nueva especie';
  static const specialEditionTitle = 'Edición especial';
  static const specialEditionCheckSubtitle = 'Indica si la pieza posee particularidades.';
  static const specialEditionReasonLabel = 'Razón de edición especial';
  static const specialEditionNotesLabel = 'Anotaciones de edición especial';
  static const confirmAndRegisterPieceAction = 'Confirmar y registrar pieza';
  static const fileAttachedToSpeciesPrefix = 'Archivo "';
  static const fileAttachedToSpeciesSuffix = '" adjuntado a la especie.';
  static const addPropertyOrMagnitudeTitle = 'Añadir propiedad o magnitud';
  static const primitiveDataTypeLabel = 'Tipo de dato primitivo:';
  static const enterNameForImageSearchError = 'Ingresa un nombre para buscar imagen.';

  static const instanceSpecificAttachment = 'Adjunto propio de la instancia';
  static const coinCircularLabel = 'Moneda';
  static const banknoteRectangleLabel = 'Billete';
  static const webImageAssignedSuccess = 'Imagen de Internet asignada correctamente.';
  static const noWebImagesFound = 'Sin imágenes encontradas en Internet.';
  static const assignPhotoAction = 'Asignar foto';

  // Configuración de Respaldos y Base de Datos
  static const backupExportSuccess = 'Respaldo preparado y compartido.';
  static const backupExportErrorPrefix = 'Error exportando respaldo: ';
  static const confirmRestoreTitle = 'Confirmar restauración';
  static const confirmRestoreWarningMessage = 'Importar un respaldo reemplazará los datos actuales de tu mundo. ¿Deseas continuar?';
  static const restoreAllAction = 'Restaurar todo';
  static const backupImportSuccess = 'Respaldo completo y archivos restaurados correctamente.';
  static const backupImportErrorPrefix = 'Error importando respaldo: ';
  static const backupsAndDatabaseTitle = 'Respaldos y base de datos';
  static const exportBackupTitle = 'Exportar respaldo completo';
  static const exportBackupSubtitle = 'Genera un archivo comprimido de tu mundo.';
  static const importBackupTitle = 'Importar respaldo';
  static const importBackupSubtitle = 'Restaura tu mundo desde un archivo de respaldo.';

  // Excepciones e Infraestructura de Catálogo
  static const genericSubspeciesName = 'Genérica';
  static const subspeciesNotFoundError = 'Subespecie no encontrada.';
  static const speciesNotFoundError = 'Especie no encontrada.';
  static const separatedFromSpeciesPrefix = 'Separada de ';
  static const cannotDeleteSubspeciesWithInstancesError = 'No se puede eliminar una subespecie que tiene instancias registradas en tu mundo.';

  // Notificaciones y Canales
  static const defaultItemName = 'Elemento';
  static const expiredNotificationMessagePrefix = '"';
  static const expiredNotificationMessageSuffix = '" ha caducado (';
  static const expiringSoonNotificationMessagePrefix = '"';
  static const expiringSoonNotificationMessageMiddle = '" caducará en ';
  static const expiringSoonNotificationMessageSuffix = ' día(s) (';
  static const unsatisfiedNeedNotificationMessagePrefix = 'Faltan ';
  static const unsatisfiedNeedNotificationMessageMiddle = ' unidad(es) de "';
  static const unsatisfiedNeedNotificationMessageSuffix = '" para cubrir los requerimientos totales (';
  static const notificationChannelName = 'Notificaciones PWMS';
  static const notificationChannelDescription = 'Notificaciones de caducidad y necesidades insatisfechas.';

  // Propiedades Numismáticas y Notas
  static const numismaticSpeciesDescriptionPrefix = 'Especie para piezas numismáticas (';
  static const nominalValuePropertyName = 'Valor nominal';
  static const mintagePropertyName = 'Acuñación';
  static const currencyPropertyName = 'Divisa';
  static const materialPropertyName = 'Material';
  static const gradePropertyName = 'Grado';
  static const currencyNotePrefix = 'Moneda: ';
  static const yearNotePrefix = 'Año: ';
  static const materialNotePrefix = 'Material: ';
  static const otherSpecifyOption = 'Otro';
  static const specialEditionNotePrefix = 'Edición especial: ';

  // Tipos de Datos Primitivos
  static const dataTypeRealLabel = 'Número decimal';
  static const dataTypeIntegerLabel = 'Número entero';
  static const dataTypeStringLabel = 'Texto';
  static const dataTypeBooleanLabel = 'Booleano';

  // Catálogo y Escáner
  static const defaultNonPerishableSubtitle = 'Por defecto los objetos son no perecederos.';
  static const isPerishableProductTitle = 'Producto perecedero';
  static const invalidOrNotFoundCodeTitle = 'Código no hallado';
  static const invalidOrNotFoundCodeMessagePrefix = 'El código de barras "';
  static const invalidOrNotFoundCodeMessageSuffix = '" no se encontró en las bases de datos en línea.';
  static const enterBarcodePrompt = 'Ingresa un código de barras.';
  static const acceptAction = 'Aceptar';

  // Búsqueda y Consola SQL
  static const arbitrarySqlConsoleTitle = 'Consola SQL';
  static const searchDetailedHint = 'Buscar por especie, subespecie, marca, ubicación, propiedad...';
  static const arbitrarySqlQueryLabel = 'Consulta SQL';
  static const selectSqlHint = 'SELECT * FROM ...';
  static const subspeciesCategory = 'Subespecies';
  static const instanceMagnitudesCategory = 'Magnitudes de instancia';
  static const containersCategory = 'Contenedores';
  static const executeAction = 'Ejecutar';
  static const rowsRetrievedPrefix = 'Filas obtenidas: ';

  // Categorías de Consultas SQL Predefinidas
  static const sqlCategoryAll = 'Todas';
  static const sqlCategoryTables = 'Tablas';
  static const sqlCategoryContainers = 'Contenedores';
  static const sqlCategoryAudit = 'Auditoría';
  static const sqlCategoryExpirationMagnitudes = 'Caducidad y Magnitudes';

  // Consultas SQL Predefinidas
  static const sqlPresetInstances = 'Instancias';
  static const sqlPresetContainedItems = 'Elementos guardados';
  static const sqlPresetNonContainedItems = 'Elementos no guardados';
  static const sqlPresetNonContainedWithContainedSpecies = 'No guardados (especie en contenedor)';
  static const sqlPresetContainedWithNonContainedSpecies = 'Guardados (especie fuera de contenedor)';
  static const sqlPresetOrphanEntities = 'Huérfanos sin ubicación';
  static const sqlPresetLocationConflict = 'Conflicto de ubicación';
  static const sqlPresetSelfReferencingRelations = 'Auto-referencias';
  static const sqlPresetMutualContainment = 'Contención mutua';
  static const sqlPresetUniquenessViolation = 'Violación de unicidad';
  static const sqlPresetUninstantiatedSpecies = 'Especies sin instancias';
  static const sqlPresetUninstantiatedSubspecies = 'Subespecies sin instancias';
  static const sqlPresetSubgroupRuleViolation = 'No-Objetos con marca/código';
  static const sqlPresetExpiredEntities = 'Instancias caducadas';
  static const sqlPresetPerishableMissingExpiration = 'Perecederos sin caducidad';
  static const sqlPresetNonPerishableWithExpiration = 'No perecederos con caducidad';
  static const sqlPresetAnomalousMagnitudes = 'Magnitudes <= 0';
  static const sqlPresetMissingMandatoryMagnitudes = 'Magnitudes faltantes';

  // Propiedades de Entidades
  static const editPropertyTitlePrefix = 'Editar propiedad "';
  static const instanceHasAllPropertiesMessage = 'Esta instancia ya posee todas las propiedades definidas por la especie.';
  static const addSpeciesPropertyTitle = 'Agregar propiedad de especie';
  static const addPropertyAction = 'Añadir propiedad';
  static const noPropertiesAssignedToInstance = 'Sin propiedades asignadas a esta instancia.';

  // Registro Numismático y Hojas
  static const numismaticsCategory = 'Numismática';
  static const pieceInstantiatedDirectlyPrefix = 'Pieza "';
  static const pieceInstantiatedDirectlySuffix = '" instanciada directamente.';

  // Gestión de Población y Caducidad
  static const heterogeneousGroupQuantityError = 'No se puede modificar la cantidad en grupos heterogéneos.';
  static const heterogeneousGroupQuickAdjustmentError = 'No se pueden realizar ajustes rápidos en grupos heterogéneos.';
  static const expirationDateForNewInstancePrompt = 'Fecha de caducidad para la nueva instancia';
  static const expirationDateForNewInstancesPrompt = 'Fecha de caducidad para las nuevas instancias';
  static const adjustQuantityTitle = 'Ajustar cantidad';
  static const newTotalQuantityLabel = 'Nueva cantidad total';
  static const deleteGroupTitle = 'Eliminar grupo';
  static const confirmDeleteGroupMessage = '¿Estás seguro de que deseas reducir la cantidad a cero y eliminar todas las instancias de este grupo?';
  static const instancesDeletedSuccess = 'Instancias eliminadas con éxito.';
  static const selectExpirationDateForNewInstancesPrompt = 'Selecciona la fecha de caducidad de las nuevas instancias.';
  static const populationUpdatedSuccessPrefix = 'Población actualizada correctamente a ';
  static const adjustPopulationErrorPrefix = 'Error al ajustar la población: ';
  static const adjustmentNotAvailableTitle = 'Ajuste no disponible';
  static const heterogeneousGroupAdjustmentMessage = 'No es posible ajustar la población en grupos heterogéneos. Abre la vista de grupo para gestionar las instancias.';
  static const understoodAction = 'Entendido';
  static const adjustPopulationTitle = 'Ajustar población';
  static const homogeneousGroupHeaderPrefix = 'Grupo homogéneo (';
  static const homogeneousGroupHeaderSuffix = ' actuales)';
  static const variedSubspeciesLabel = 'Subespecies variadas';
  static const statusExpired = 'Caducado';
  static const statusWarning = 'Próximo a vencer';
  static const generalSpeciesPrefix = 'Especie general: ';
  static const expirationDateOptionalLabel = 'Fecha de caducidad';
  static const noExpirationDate = 'Sin fecha de caducidad';
  static const removeExpirationDateTooltip = 'Quitar fecha de caducidad';
  static const noInstancesAvailableInGroup = 'Sin instancias disponibles en este grupo.';
  static const totalPopulationPrefix = 'Población total: ';
  static const homogeneousGroupProperties = 'Grupo homogéneo';
  static const heterogeneousGroupDescription = 'Grupo heterogéneo';
  static const deleteInstanceTitle = 'Eliminar instancia';
  static const deleteInstanceConfirmationMessage = '¿Estás seguro de que deseas eliminar esta instancia de tu mundo?';

  // Constantes Adicionales de Infraestructura y Formularios
  static const instancePropertiesAndMagnitudesTitle = 'Propiedades y magnitudes de la instancia';
  static const rootLocationLabel = 'Mundo';
  static const sqlHelpHint = 'Escribe una consulta SQL SELECT para inspeccionar la base de datos local.';
  static const sqlNoRowsReturned = 'La consulta se ejecutó correctamente pero no retornó registros.';
  static const sqlSecurityErrorPrefix = 'Por seguridad, las consultas SQL están restringidas a lectura exclusivamente (SELECT). El comando "';
  static const sqlSecurityErrorSuffix = '" está prohibido.';
  static const sqlSyntaxErrorPrefix = 'Error de sintaxis SQL o ejecución: ';
  static const applyCorrectionAction = 'Aplicar corrección';
  static const savingAction = 'Guardando...';
  static const linksCountSuffix = ' vínculos';
  static const noSearchMatchesPrefix = 'No se encontraron coincidencias para "';
  static const noSearchMatchesSuffix = '"';

  // Constantes Adicionales de Sistema y Notificaciones
  static const directedRelationInWorldTitle = 'Relación dirigida en tu mundo';
  static const relationCreatedSuccessPrefix = 'Relación "';
  static const relationCreatedSuccessSuffix = '" creada con éxito.';
  static const movedSuccessfullyInGraphPrefix = '"';
  static const movedSuccessfullyInGraphSuffix = '" trasladado exitosamente en el grafo.';
  static const correctLocationTitlePrefix = 'Corregir ubicación de "';
  static const correctLocationTitleSuffix = '"';
  static const notificationInitErrorPrefix = 'Inicialización de notificaciones omitida o fallida: ';

  // Constantes de Interfaz, Pantalla Principal y Herramientas
  static const controlCenterTooltip = 'Centro de control';
  static const settingsTooltip = 'Configuración de app y respaldos';
  static const notificationsTooltip = 'Notificaciones y recordatorios';
  static const allLocationsOption = 'Todas las ubicaciones';
  static const itemsMovedSuccess = 'Movido correctamente.';
  static const itemsSavedInContainerSuccess = 'Elementos guardados en contenedor.';
  static const deleteSelectionTitle = 'Eliminar selección';
  static const deleteSelectionConfirmationPrefix = '¿Deseas eliminar ';
  static const deleteSelectionConfirmationSuffix = ' elementos seleccionados?';
  static const itemsDeletedSuccess = 'Elementos eliminados.';
  static const toggleViewModeTooltip = 'Cambiar vista';
  static const cancelSelectionTooltip = 'Cancelar selección';
  static const multipleSelectionTooltip = 'Selección múltiple';
  static const globalSettingsTitle = 'Configuración global';
  static const backupManagementTitle = 'Gestión de respaldos locales';
  static const backupManagementSubtitle = 'Exporta o restaura la base de datos completa de tu mundo.';
  static const selectValidContainerPrompt = 'Selecciona un objeto contenedor válido.';
  static const locationCorrectedSuccess = 'Ubicación corregida exitosamente.';
  static const locationCorrectionErrorPrefix = 'Error al corregir ubicación: ';
  static const unknownLocation = 'Ubicación desconocida';
  static const activityLogRegisteredPrefix = 'Registrado en tu mundo: "';
  static const activityLogEditedPrefix = 'Editado "';
  static const activityLogEditedInfoPrefix = 'Editada información de "';
  static const activityLogDeletedPrefix = 'Eliminado de tu mundo: "';
  static const activityLogMovedPrefix = 'Trasladado "';
  static const activityLogFromPrefix = '" de "';
  static const activityLogToPrefix = '" a "';

  // Servicio de Actualizaciones
  static const softwareUpdatesTitle = 'Actualizaciones de la aplicación';
  static const softwareUpdatesSubtitle = 'Comprueba si existen nuevas versiones de PWMS publicadas.';
  static const checkForUpdatesTitle = 'Buscar actualizaciones';
  static const checkForUpdatesSubtitle = 'Verifica si hay nuevas versiones disponibles en GitHub.';
  static const updateAvailableTitle = 'Actualización disponible';
  static const updateAvailablePrompt = 'Se encontró una nueva versión de la aplicación. ¿Deseas descargarla e instalarla ahora?';
  static const currentVersionLabel = 'Versión actual';
  static const latestVersionLabel = 'Nueva versión';
  static const changelogLabel = 'Notas de la versión';
  static const updateNowAction = 'Actualizar ahora';
  static const laterAction = 'Más tarde';
  static const updatingAction = 'Iniciando...';
  static const appUpToDate = 'La aplicación está actualizada.';
  static const updateChecking = 'Buscando actualizaciones...';
  static const updateError = 'Error al verificar actualizaciones: ';
  static const appVersionLabel = 'Versión instalada';
  static const updateStarting = 'Iniciando la descarga del instalador...';
  static const unsupportedPlatformUpdate = 'Las actualizaciones automáticas solo están disponibles en Android.';
}

