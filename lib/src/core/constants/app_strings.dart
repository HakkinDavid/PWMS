import 'app_technical_strings.dart';

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
  static const tabInventory = 'Inventario';
  static const inventoryTitle = 'Inventario';

  // Pantalla de Inicio
  static const recentEntitiesTitle = 'Instancias recientes';
  static const activityTitle = 'Historial de actividad';
  static const universeCatalogTitle = 'Catálogo de especies';
  static const locationsTitle = 'Grafo de ubicaciones';
  static const noRecentObjects = 'Sin objetos recientes.';
  static const deletePropertyFromInstanceTooltip = 'Eliminar propiedad de esta instancia.';
  static const yearUnitSymbol = 'año';
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
  static const currencyLabel = 'Divisa';
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
  static const searchContainerHint = 'Buscar por nombre, especie, marca...';
  static const changeContainerAction = 'Cambiar contenedor';
  static String noContainersFoundForQuery(String query) => 'No se encontraron contenedores para "$query".';
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
  static const otherUnassignedInstances = 'Otras instancias sin subespecie';

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
  static const convertToContainerTitle = '¿Convertir en contenedor?';
  static String convertToContainerMessage(String name, int count) =>
      count == 1
          ? '¿Deseas guardar 1 elemento dentro de "$name" y convertirlo en un nuevo contenedor?'
          : '¿Deseas guardar $count elementos dentro de "$name" y convertirlo en un nuevo contenedor?';
  static const moveToWorldConfirmationTitle = '¿Mover al Mundo?';
  static String moveToWorldConfirmationMessage(int count) =>
      count == 1
          ? 'El elemento seleccionado dejará de pertenecer a su ubicación o contenedor actual y pasará al Mundo raíz sin ubicación específica. ¿Deseas continuar?'
          : 'Los $count elementos seleccionados dejarán de pertenecer a su ubicación o contenedor actual y pasarán al Mundo raíz sin ubicación específica. ¿Deseas continuar?';
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
  static const mergeSpeciesAction = 'Unir Especies';
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
  static const noSubspeciesWarningTitle = 'Sin subespecies';
  static const noSubspeciesWarningMessage = 'No se agregaron subespecies a la especie. Se creará automáticamente la subespecie "Genérica". ¿Deseas continuar?';

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
  static const selectSearchScopePrompt = 'Seleccionar ámbito de búsqueda';
  static const searchScopePrefix = 'Ámbito: ';
  static const sqlPresetsSelectPrompt = 'Seleccionar plantilla SQL';
  static const sqlCategorySelectPrompt = 'Seleccionar categoría SQL';
  static const openSqlEditorAction = 'Abrir Editor SQL';
  static const executeSqlAction = 'Ejecutar consulta SQL';
  static const editQueryAction = 'Editar consulta';
  static const fullScreenSqlEditorTitle = 'Editor de Consulta SQL';
  static const sqlQueryPreviewLabel = 'Consulta SQL activa:';
  static const sqlCodeEditorHint = 'Escribe tu consulta SQL SELECT aquí...';
  static const dateFilterLabel = 'Filtrar por fecha';
  static const dateAll = 'Cualquier fecha';
  static const dateToday = 'Hoy';
  static const dateLast7Days = 'Últimos 7 días';
  static const dateLast30Days = 'Últimos 30 días';
  static const dateThisMonth = 'Este mes';
  static const dateThisYear = 'Este año';
  static const dateCustomRange = 'Rango personalizado...';
  static const selectDateFilterPrompt = 'Seleccionar filtro de fecha';
  static const selectCategoryFilterPrompt = 'Seleccionar categoría';
  static const selectTypeFilterPrompt = 'Seleccionar tipo';
  static const searchInAllScope = 'Búsqueda global en todos los elementos';
  static const sectionInstances = 'Instancias';
  static const sectionCatalog = 'Catálogo (Especies y Subespecies)';
  static const sectionLocations = 'Ubicaciones';
  static const sectionHistory = 'Historial de Actividad';
  static const sectionContainers = 'Contenedores';
  static const filterByType = 'Tipo';
  static String filterByTypeWithValue(String type) => '$filterByType: $type';
  static const filterByCategory = 'Categoría';
  static const filterByDate = 'Fecha';
  static const customDateRange = 'Rango personalizado';
  static const clearFilterAction = 'Limpiar filtro';
  static const searchResultsCount = 'Resultados encontrados';
  static const noSubspeciesFound = 'Sin subespecies coincidentes.';

  // Categorías de Consultas SQL Predefinidas
  static const sqlCategoryAll = 'Todas';
  static const sqlCategoryTables = 'Tablas';
  static const sqlCategoryContainers = 'Contenedores';
  static const sqlCategoryAudit = 'Auditoría';
  static const sqlCategoryExpirationMagnitudes = 'Caducidad y Magnitudes';

  // Modos de Vista y Badges de Tiles
  static const viewModeTable = 'Tabla';
  static const viewModeTiles = 'Tarjetas';
  static const tabContainers = 'Contenedores';
  static const badgeContainer = 'Contenedor';
  static const badgeOrphan = 'Sin ubicación';
  static const badgeLocationConflict = 'Conflicto de ubicación';
  static const badgeMissingExpiration = 'Sin caducidad';
  static const emptyContainersSearch = 'No se encontraron objetos contenedores en el mundo.';
  static const containedItemsCountSuffix = ' elementos';
  static const containedItemCountSingle = '1 elemento';

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

  // Centro de Control y Auditorías de Inventario
  static const controlCenterTitle = 'Centro de Control y Salud de Datos';
  static const regenerateAuditsTooltip = 'Regenerar revisiones';
  static const dataHealthVerifiedTitle = 'Salud de datos 100% verificada';
  static const dataHealthVerifiedSubtitle = 'No se detectaron anomalías ni inconsistencias en tu inventario. Tu mundo PWMS está perfectamente estructurado.';
  static const runNewAuditAction = 'Realizar nueva auditoría';
  static const correctAction = 'CORRECTO';
  static const fixAction = 'CORREGIR';
  static const attachmentNameRetainedSuccess = 'Nombre de adjunto mantenido.';
  static const attachmentRenamedSuccess = 'Archivo adjunto renombrado correctamente.';
  static const incompleteNumismaticMagnitudesTitle = 'Magnitudes numismáticas incompletas';
  static const magnitudesRetainedSuccess = 'Magnitudes mantenidas sin cambios.';
  static const numismaticMagnitudesAutoFilledSuccess = 'Magnitudes numismáticas autocompletadas.';
  static const emptyGradeDataTitle = 'Dato numismático vacío: grado';
  static const gradeRetainedEmptySuccess = 'Grado de conservación mantenido vacío.';
  static const assignGradeTitle = 'Asignar grado de conservación';
  static const controlCenterLoadErrorPrefix = 'Error al cargar tarjetas de control: ';
  static const uninstantiatedSubspeciesAuditTitle = 'Subespecie no instanciada en el mundo';
  static const uninstantiatedSpeciesAuditTitle = 'Especie no instanciada en el mundo';
  static const locationVerificationAuditTitle = 'Verificación de ubicación de instancia';
  static const ownershipCheckAuditTitle = 'Control de pertenencia y contenedor';
  static const expirationAuditTitle = 'Auditoría de fecha de caducidad';
  static const orphanEntityAuditTitle = 'Instancia huérfana sin ubicación asignada';
  static const incompleteSpeciesInfoAuditTitle = 'Información de especie incompleta';
  static const remoteImageAuditTitle = 'Imágenes remotas sin descargar';
  static const numismaticSubspeciesIncongruityTitle = 'Incongruencia en subespecie numismática';
  static const numismaticDuplicateSubspeciesTitle = 'Subespecie numismática duplicada';
  static const numismaticAttachmentIncongruityTitle = 'Incongruencia en archivo adjunto numismático';
  static const numismaticMissingMagnitudesTitle = 'Magnitudes numismáticas faltantes';
  static const emptyDataAuditTitle = 'Auditoría de datos vacíos';
  static const locationConflictAuditTitle = 'Conflicto de ubicación';
  static const cyclicContainmentAuditTitle = 'Contención cíclica detectada';
  static const uniquenessViolationAuditTitle = 'Violación de unicidad de especie';
  static const perishableMissingExpirationAuditTitle = 'Producto perecedero sin fecha de caducidad';
  static const nonPerishableWithExpirationAuditTitle = 'Producto no perecedero con fecha de caducidad';
  static const subgroupRuleViolationAuditTitle = 'Violación de regla de subgrupo';
  static const missingMandatoryMagnitudesAuditTitle = 'Magnitudes obligatorias faltantes';
  static const anomalousMagnitudeAuditTitle = 'Magnitud anómala detectada';
  static const duplicateSpeciesAuditTitle = 'Especies homónimas duplicadas';
  static const duplicatePhotoAuditTitle = 'Fotografía compartida entre especies';
  static const speciesWithoutSubspeciesAuditTitle = 'Especie sin subespecies';
  static const unlinkedInstancesAuditTitle = 'Instancias desvinculadas';
  static const anomalousExpirationAuditTitle = 'Fecha de caducidad anómala';

  // Constantes de Formularios Numismáticos
  static const noSelectionPrompt = 'Sin selección';
  static const countryIssuerLabel = 'Emisor';
  static const selectCountryPrompt = 'Selecciona un emisor.';
  static const denominationLabel = 'Denominación';
  static const selectDenominationPrompt = 'Selecciona una denominación.';
  static const denominationNumberLabel = 'Número de denominación';
  static const enterDenominationNumberPrompt = 'Ingresa el número de denominación.';
  static const enterValidNumericValuePrompt = 'Ingresa un valor numérico válido.';
  static const mintageYearLabel = 'Año de emisión';
  static const enterMintageYearPrompt = 'Ingresa el año de emisión.';
  static const enterValidMintageYearPrompt = 'Ingresa un año válido.';
  static const selectGradePrompt = 'Selecciona el estado de conservación.';
  static const selectMaterialPrompt = 'Selecciona el material o composición.';
  static const selectSpecialEditionReasonPrompt = 'Selecciona la razón de edición especial.';
  static const specifySpecialEditionNotesPrompt = 'Especifica el motivo de la edición especial.';
  static const numismaticDataTitlePrefix = 'Datos numismáticos: ';
  static const selectCurrencyPrompt = 'Selecciona una divisa.';

  // Confirmaciones y Prevención de Descarte de Cambios
  static const unsavedChangesTitle = 'Cambios sin guardar';
  static const unsavedChangesMessage = 'Tienes modificaciones pendientes sin guardar. ¿Deseas descartar los cambios o continuar editando?';
  static const discardChangesAction = 'Descartar cambios';
  static const keepEditingAction = 'Continuar editando';
  static const confirmReplaceAttachmentTitle = 'Reemplazar adjunto';
  static const confirmReplaceAttachmentMessage = '¿Deseas reemplazar este archivo adjunto? El archivo anterior será sustituido.';
  static const confirmDeleteSubspeciesTitle = 'Eliminar subespecie';
  static const confirmDeleteSubspeciesMessagePrefix = '¿Estás seguro de que deseas eliminar permanentemente la subespecie "';
  static const confirmDeleteSubspeciesMessageSuffix = '"?';
  static const confirmDeleteRequirementTitle = 'Eliminar requisito';
  static const confirmDeleteRequirementMessagePrefix = '¿Estás seguro de que deseas eliminar este requisito de "';
  static const confirmDeleteRequirementMessageSuffix = '"?';
  static const confirmDeleteRelationTitle = 'Eliminar relación';
  static const confirmDeleteRelationMessagePrefix = '¿Deseas desvincular la relación "';
  static const confirmDeleteRelationMessageMiddle = '" con "';
  static const confirmDeleteRelationMessageSuffix = '"?';
  static const confirmDeleteLocationTitle = 'Eliminar ubicación';
  static const confirmDeleteLocationMessagePrefix = '¿Estás seguro de que deseas eliminar la ubicación "';
  static const confirmDeleteLocationMessageSuffix = '" y sus referencias asociadas?';
  static const confirmRemovePhotoTitle = 'Quitar fotografía';
  static const confirmRemovePhotoMessage = '¿Deseas quitar la fotografía seleccionada?';
  static const confirmRemoveAttributeTitle = 'Eliminar atributo';
  static const confirmRemoveAttributeMessagePrefix = '¿Deseas eliminar el atributo personalizado "';
  static const confirmRemoveAttributeMessageSuffix = '"?';
  static const confirmDeletePropertyTitle = 'Eliminar propiedad';
  static const confirmDeletePropertyMessagePrefix = '¿Estás seguro de que deseas eliminar la propiedad "';
  static const confirmDeletePropertyMessageSuffix = '"?';

  // Navegación y Buscador (Acciones y Confirmaciones)
  static const goBackAction = 'Retroceder';
  static const createOrInstantiateAction = 'Crear o Instanciar';
  static const moveSelectionAction = 'Mover Selección';
  static const deleteSelectionAction = 'Eliminar Selección';
  static const confirmDeleteSelectionTitle = 'Confirmar eliminación';
  static const viewAllLocationsAction = 'Ver todas';
  static String confirmDeleteSelectionPrompt(int count) => '¿Eliminar $count elemento(s)?';
  static String deleteElementsConfirmation(int count) => '¿Deseas eliminar $count elementos seleccionados?';

  // Formateadores de Errores
  static String formatError(Object err) => 'Error: $err';

  // Operaciones de Taxonomía
  static const mergeSpeciesDialogTitle = 'Unir Especie';
  static const targetSpeciesFormLabel = 'Especie Destino';
  static const separateInNewSpeciesDialogTitle = 'Separar en Nueva Especie';
  static const newSpeciesNameFormLabel = 'Nombre de la Nueva Especie';

  // Gestión de Adjuntos en Vista Detallada
  static const renameAttachmentTitle = 'Renombrar adjunto';
  static const fileNameLabel = 'Nombre del archivo';
  static const replaceFileAction = 'Reemplazar archivo';
  static const renameAction = 'Renombrar';
  static const deleteAttachmentAction = 'Eliminar adjunto';
  static const openAttachmentTooltip = 'Abrir adjunto';
  static const openExternallyAction = 'Abrir externamente';
  static const openExternallyTooltip = 'Abrir con aplicación externa';
  static const shareAction = 'Compartir';
  static const shareAttachmentTooltip = 'Compartir archivo';
  static const attachmentOptionsTooltip = 'Opciones de adjunto';
  static const errorOpeningFilePrefix = 'Error al abrir archivo: ';
  static const errorSharingFilePrefix = 'Error al compartir archivo: ';
  static String replaceAttachmentTitle(String name) => 'Reemplazar Adjunto ($name)';

  // Multimedia, Escáner y Llenado Rápido
  static const shelfLifeDaysLabel = 'Vida útil (días)';
  static const shelfLifeDaysHint = 'ej. 30';
  static const warningDaysLabel = 'Aviso prev. (días)';
  static const warningDaysHint = 'ej. 7';
  static const attachToSpeciesAction = 'Adjuntar a Especie';
  static const speciesPhotoTitle = 'Foto de la Especie';
  static const subspeciesPhotoTitle = 'Foto de la Subespecie / Variante';
  static const standardCameraCapture = 'Captura estándar con la cámara';
  static const chooseFromGallery = 'Elegir imagen de la galería de fotos';
  static const searchWeb = 'Buscar en la web';
  static const fileExplorer = 'Explorador de archivos';
  static const selectPdfOrDocument = 'Seleccionar PDF, documento o archivo local';
  static const manualBarcodeHint = 'Código de barras manual...';
  static const productOrSpeciesSearchHint = 'Nombre del producto / especie...';
  static const coinObverse = 'Anverso';
  static const coinReverse = 'Reverso';
  static const completeAllFieldsPrompt = 'Por favor completa todos los campos antes de guardar.';
  static const exampleDecimalHint = 'Ej: 0.50';
  static const exampleYearHint = 'Ej: 1982';

  // Reglas de Auditoría y Centro de Control
  static const confirmSubspeciesTitle = 'Confirmar Subespecie';
  static const keepAction = 'Mantener';
  static const deleteSubspeciesAction = 'Eliminar Subespecie';
  static const resolveUniquenessTitle = 'Resolver unicidad';
  static const makeNonUniqueAction = 'Convertir a No Única';
  static const deleteDuplicatesAction = 'Eliminar Duplicados';
  static const whatActionForSpeciesPrompt = '¿Qué acción deseas realizar con esta especie?';
  static const createInstanceAction = 'Crear Instancia';
  static const deleteSpeciesAction = 'Eliminar Especie';
  static const relationalLocationConflictTitle = 'Conflicto de Ubicación en Contenedor';
  static const onlyInContainerAction = 'Solo en Contenedor';
  static const onlyDirectLocationAction = 'Solo Ubicación Directa';
  static const reassignLocationAction = 'Reasignar';
  static const circularRelationTitle = 'Relación circular';
  static const deleteInvalidRelationAction = 'Eliminar relación inválida';
  static const keepThisObjectQuestion = '¿Conservas este objeto?';
  static const perishableWithoutExpirationTitle = 'Perecedero sin Caducidad';
  static const nonPerishableWithExpirationTitle = 'No Perecedero con Caducidad';
  static const booleanFalseAction = 'No (Falso)';
  static const booleanTrueAction = 'Sí (Verdadero)';
  static const numismaticIncongruityTitle = 'Incongruencia en Datos Numismáticos';
  static const updateSubspeciesFromInstanceAction = 'Actualizar Subespecie según la Instancia';
  static const desyncedAttachmentNameTitle = 'Nombre de Adjunto Desincronizado';
  static const mergeDuplicateSubspeciesAction = 'Fusionar Subespecies Duplicadas';

  static const uninstantiatedSubspeciesCardTitle = 'Subespecie sin Instancia';
  static const uniqueSubspeciesDuplicatedTitle = 'Subespecie Única Duplicada';
  static const subgroupRuleViolationTitle = 'Infracción de Regla de Subgrupo';
  static const uninstantiatedSpeciesWorldTitle = 'Especie sin Instancias en el Mundo';
  static const incompleteSpeciesInfoTitle = 'Especie sin Imagen Principal';
  static const remoteSpeciesImageTitle = 'Imagen de Especie No Local (URL Remota)';
  static const remoteSubspeciesImageTitle = 'Imagen de Subespecie No Local (URL Remota)';
  static const orphanEntityTitle = 'Instancia sin Ubicación ni Contenedor';
  static const resolveLocationTitle = 'Resolver ubicación';
  static const correctInstanceTitle = 'Corregir Instancia';
  static const deregisterInstanceTitle = 'Dar de Baja Instancia';
  static const haveYouMovedThisObjectQuestion = '¿Has movido este objeto?';
  static const selectExpirationDatePrompt = 'Selecciona Fecha de Caducidad';
  static const anomalousMagnitudeCardTitle = 'Magnitud con Valor No Positivo';
  static const numismaticDuplicateSubspeciesCardTitle = 'Subespecies Numismáticas Duplicadas';
  static const correctNumismaticIncongruityTitle = 'Corregir Incongruencia Numismática';
  static const invalidUnitSymbolTitle = 'Unidad de Medida Desconocida';
  static const integerUnitIncongruityTitle = 'Incongruencia de Unidad Entera';
  static const nonNumericWithUnitTitle = 'Unidad en Propiedad No Numérica';
  static const negativeMagnitudeViolationTitle = 'Valor Numérico Negativo Inválido';
  static const propertyNameSuggestionIncongruityTitle = 'Nombre de Propiedad Sugerido';

  static const correctLocationOrContainerAction = 'Corregir Ubicación / Contenedor';
  static const deleteFromInventoryAction = 'Eliminar de Inventario';
  static const deregisterInstanceAction = 'Eliminar Instancia';
  static const deleteRelationActionLabel = 'Eliminar Relación';
  static const mergeAndReassignAction = 'Fusionar y Reasignar';

  static const unknownSpecies = 'Desconocida';
  static const originFallback = 'Origen';
  static const destinationFallback = 'Destino';
  static const containerFallback = 'Contenedor';
  static const directLocationFallback = 'Ubicación directa';
  static const genericSubspeciesNameLower = 'genérica';
  static const unitYear = 'año';

  static const subspeciesKeptSuccess = 'Subespecie mantenida.';
  static const subspeciesDeletedSuccess = 'Subespecie eliminada.';
  static const subspeciesDuplicationSkipped = 'Duplicidad de subespecie omitida.';
  static const speciesSetToNotUniqueSuccess = 'Especie configurada como No Única.';
  static const duplicatesDeletedPreservedOneSuccess = 'Instancias duplicadas eliminadas. Se conservó 1 instancia.';
  static const attributesSkipped = 'Atributos omitidos.';
  static const brandAndBarcodeRemovedSuccess = 'Marca y código de barras removidos.';
  static const speciesKeptInCatalog = 'Especie conservada en catálogo.';
  static const speciesDeletedFromCatalogSuccess = 'Especie eliminada del catálogo.';
  static const informationSkippedForNow = 'Información omitida por el momento.';
  static const remoteImageKeptWithoutDownload = 'Imagen remota conservada sin descargar.';
  static const locationKeptUnassigned = 'Ubicación mantenida como no asignada.';
  static const locationConflictSkipped = 'Conflicto de ubicación omitido.';
  static const directLocationRemovedKeptInContainerSuccess = 'Ubicación directa removida. Conservado en contenedor.';
  static const elementRemovedFromContainerSuccess = 'Elemento retirado del contenedor.';
  static const circularRelationKept = 'Relación circular conservada.';
  static const conflictingRelationDeletedSuccess = 'Relación conflictiva eliminada.';
  static const instanceConfirmedInInventory = 'Instancia confirmada en inventario.';
  static const instanceDeregisteredSuccess = 'Instancia dada de baja.';
  static const locationConfirmedSuccess = 'Ubicación confirmada.';
  static const expirationDateSkipped = 'Fecha de caducidad omitida.';
  static const expirationDateUpdatedSuccess = 'Fecha de caducidad actualizada.';
  static const expirationDateKept = 'Caducidad conservada.';
  static const expirationDateRemovedSuccess = 'Fecha de caducidad eliminada.';
  static const magnitudeSkipped = 'Magnitud omitida.';
  static const valueKept = 'Valor conservado.';
  static const duplicateSubspeciesKeptWithoutChanges = 'Subespecies duplicadas conservadas sin cambios.';
  static const duplicateSubspeciesMergedSuccess = 'Subespecies duplicadas fusionadas con éxito.';
  static const incongruitySkipped = 'Incongruencia omitida.';
  static const subspeciesAndAttachmentsSyncedSuccess = 'Subespecie y adjuntos sincronizados con éxito.';
  static const remoteImageDownloadedSuccess = 'Imagen descargada y guardada localmente con éxito.';
  static const remoteImageDownloadFailedMessage = 'No se pudo descargar automáticamente la imagen. Puedes seleccionarla mediante el selector de medios.';
  static const invalidUnitRetained = 'Símbolo de unidad conservado.';
  static const unitUpdatedSuccess = 'Unidad de medida actualizada con éxito.';
  static const unitRemovedSuccess = 'Unidad de medida removida con éxito.';
  static const integerUnitNormalizedSuccess = 'Propiedad normalizada a tipo entero con éxito.';
  static const negativeValueCorrectedSuccess = 'Valor numérico corregido con éxito.';
  static const propertyNameRenamedSuccess = 'Nombre de propiedad actualizado con éxito.';
  static const changeUnitAction = 'Cambiar Unidad de Medida';
  static const selectNewUnitPrompt = 'Selecciona una nueva unidad de medida';
  static const unspecifiedPropertyPlaceholder = '—';
  static const markAsUnknownOrNotApplicable = 'Marcar como Desconocido / No aplica';
  static const propertyMarkedAsUnknownSuccess = 'Propiedad marcada como no disponible/desconocida.';
  static const setNullAction = 'Establecer nulo';
  static const enterValueAction = 'Ingresar valor';

  static const confirmDeleteConflictingRelationMessage = '¿Confirmas que deseas eliminar esta relación conflictiva?';

  static String keepSubspeciesPrompt(String name) => '¿Deseas mantener la subespecie "$name" en tu catálogo o eliminarla?';
  static String manageSpeciesTitle(String name) => 'Gestionar "$name"';
  static String assignPropertyTitle(String prop) => 'Asignar $prop';
   static const ccTabIntegrityRules = 'Reglas de Integridad';
  static const ccTabRoutineChecks = 'Comprobaciones Rutinarias';
  static const ccTabIgnored = 'Omitidas';
  static const ccIntegrityEmptyTitle = 'Integridad de Datos Verificada';
  static const ccIntegrityEmptySubtitle = 'No se encontraron violaciones de reglas ni inconsistencias en el catálogo o inventario.';
  static const ccRoutineEmptyTitle = 'Verificaciones Rutinarias al Día';
  static const ccRoutineEmptySubtitle = 'Todas las comprobaciones periódicas de inventario y ubicación han sido completadas.';
  static const ccIgnoredEmptyTitle = 'Sin Comprobaciones Omitidas';
  static const ccIgnoredEmptySubtitle = 'Las comprobaciones que marques como "no volver a mostrar" aparecerán aquí para que no pierdas su rastro.';
  static const runNewRoutineCheckAction = 'Iniciar Verificaciones';
  static const doNotShowAgainAction = 'No volver a mostrar';
  static const restoreAction = 'Volver a mostrar';
  static const cardMarkedAsIgnoredSuccess = 'Marcada como "no volver a mostrar". Puedes encontrarla en la pestaña Omitidas.';
  static const cardUnignoredSuccess = 'Comprobación reactivada y devuelta a la lista activa.';
  static String pendingIntegrityRules(int count) => '$count regla(s) pendiente(s)';
  static String pendingRoutineChecks(int count) => '$count verificación(es) pendiente(s)';
  static String pendingIgnoredCount(int count) => '$count omitida(s)';

  // Botones Semánticos de CCCs (Confirmación y Acción)
  static const confirmKeepAction = 'Mantener';
  static const confirmSkipAction = 'Omitir';
  static const confirmKeepInCatalogAction = 'Mantener en catálogo';
  static const confirmWithoutExpirationAction = 'Sin caducidad';
  static const confirmKeepExpirationAction = 'Mantener fecha';
  static const confirmKeepEmptyAction = 'Dejar vacía';
  static const confirmKeepValueAction = 'Conservar valor';
  static const confirmKeepUnitAction = 'Conservar unidad';
  static const confirmKeepDecimalAction = 'Conservar decimal';
  static const confirmKeepNegativeAction = 'Conservar negativo';
  static const confirmKeepNameAction = 'Conservar nombre';
  static const confirmKeepSeparateAction = 'Mantener separadas';
  static const confirmKeepDataAction = 'Conservar datos';
  static const confirmWithoutGradeAction = 'Sin grado';
  static const confirmKeepUnassignedAction = 'Dejar sin ubicación';
  static const confirmKeepConflictAction = 'Mantener conflicto';
  static const confirmKeepRelationAction = 'Conservar relación';
  static const confirmKeepSharedPhotoAction = 'Mantener compartida';
  static const confirmWithoutSubspeciesAction = 'Dejar sin subespecie';
  static const confirmKeepUnlinkedAction = 'Mantener desvinculada';
  static const confirmIKeepThisObject = 'Sí, lo conservo';
  static const confirmItIsHere = 'Sí, está aquí';
  static const confirmKeepUrlAction = 'Conservar enlace';

  static const fixManageAction = 'Gestionar';
  static const fixAssignDateAction = 'Asignar fecha';
  static const fixRemoveDateAction = 'Remover fecha';
  static const fixEnterValueAction = 'Ingresar valor';
  static const fixCorrectValueAction = 'Corregir valor';
  static const fixChangeUnitAction = 'Cambiar unidad';
  static const fixNormalizeIntegerAction = 'Normalizar a entero';
  static const fixRemoveUnitAction = 'Remover unidad';
  static const fixRenamePropertyAction = 'Renombrar propiedad';
  static const fixMergeSubspeciesAction = 'Fusionar subespecies';
  static const fixUpdateSubspeciesAction = 'Actualizar subespecie';
  static const fixRenameFileAction = 'Renombrar archivo';
  static const fixAutocompleteAction = 'Autocompletar';
  static const fixAssignGradeAction = 'Asignar grado';
  static const fixAssignLocationAction = 'Asignar ubicación';
  static const fixResolveLocationAction = 'Resolver ubicación';
  static const fixDeleteRelationAction = 'Eliminar relación';
  static const fixMergeOrRenameAction = 'Fusionar o renombrar';
  static const fixChangeOrSeparateAction = 'Cambiar o separar';
  static const fixCreateSubspeciesAction = 'Crear subespecie';
  static const fixReassignOrDeregisterAction = 'Reasignar / Dar de baja';
  static const fixCorrectExpirationAction = 'Corregir fecha';
  static const fixRelocateOrManageAction = 'No / Gestionar';
  static const fixRelocateAction = 'No, reubicar';
  static const fixDownloadLocallyAction = 'Descargar localmente';
  static const fixAddPhotoAction = 'Agregar foto';
  static const fixCleanAttributesAction = 'Limpiar atributos';
  static const fixResolveDuplicatesAction = 'Resolver duplicados';
  static const fixCreateInstanceAction = 'Crear instancia';

  static String resolveMissingPropertyPrompt(String prop) => '¿Cómo deseas registrar la propiedad "$prop"?';
  static String assignBooleanPrompt(String prop) => 'Selecciona el valor booleano para "$prop":';
  static String correctPropertyTitle(String prop) => 'Corregir $prop';
  static String syncInfoPrompt(String name, String msg) => 'Sincronizar información para "$name":\n\n$msg';

  static String subspeciesNameWithBrand(String name, String? brand) => brand != null && brand.isNotEmpty ? '$name ($brand)' : name;
  static String uninstantiatedSubspeciesSubtitle(String subName, String speciesName) => '$subName • Especie: $speciesName';
  static String uninstantiatedSubspeciesQuestion(String subName) => '¿Deseas registrar una instancia física para la subespecie "$subName" o gestionarla?';
  static String uniqueSubspeciesDuplicatedSubtitle(String subspecies, String species, int count) => '$subspecies • $species ($count instancias)';
  static String uniqueSubspeciesDuplicatedQuestion(String subspecies, String species, int count) => '¿Deseas eliminar las instancias duplicadas o permitir múltiples instancias de "$subspecies"?';
  static String resolveUniquenessPrompt(String subspecies, String species, int count) => 'La subespecie "$subspecies" de la especie única "$species" tiene $count instancias.\n\n¿Deseas permitir múltiples instancias convirtiendo la especie en No Única o eliminar los duplicados de esta subespecie?';
  static String subgroupRuleViolationSubtitle(String subspecies, String type) => '$subspecies • Tipo: $type';
  static String subgroupRuleViolationQuestion(String type) => '¿Deseas limpiar la marca y código de barras no permitidos en el subgrupo "$type"?';
  static String speciesWithType(String name, String type) => '$name ($type)';
  static String uninstantiatedSpeciesQuestion(String name) => '¿Deseas crear una instancia física para la especie "$name" o gestionarla?';
  static String incompleteSpeciesInfoQuestion(String name) => '¿Deseas asignar una imagen principal a la especie "$name"?';
  static String remoteSpeciesImageSubtitle(String name, String type) => '$name ($type) • Imagen en Internet';
  static String remoteSpeciesImageQuestion(String name) => '¿Deseas descargar la imagen remota de "$name" para guardarla localmente en el dispositivo?';
  static String remoteSubspeciesImageSubtitle(String subspecies, String species) => '$subspecies • $species';
  static String remoteSubspeciesImageQuestion(String subspecies) => '¿Deseas descargar la imagen remota de "$subspecies" para guardarla localmente en el dispositivo?';
  static String orphanEntitySubtitle(String displayName, String path) => '$displayName • Ubicación efectiva: $path';
  static String orphanEntityQuestion(String displayName) => '¿Deseas asignar una ubicación física o contenedor a "$displayName"?';
  static String locationConflictSubtitle(String displayName, String container, String directLoc) => '$displayName • En: $container & $directLoc';
  static String locationConflictQuestion(String displayName, String container, String directLoc) => '¿Deseas resolver la doble asignación de "$displayName" (en "$container" y "$directLoc")?';
  static String resolveLocationConflictPrompt(String displayName, String container, String directLoc) => 'El elemento "$displayName" tiene doble asignación:\n\n• Contenedor: $container\n• Ubicación directa: $directLoc\n\n¿Cómo deseas resolverlo?';
  static String circularRelationSubtitle(String source, String target, String relationType) => '$source ➔ $target ($relationType)';
  static String circularRelationQuestion(String source, String target) => '¿Deseas eliminar la relación circular inválida entre "$source" y "$target"?';
  static String ownershipCheckSubtitle(String displayName, String path) => '$displayName • Ubicación efectiva: $path';
  static String ownershipCheckQuestion(String displayName, String path) => '¿Aún conservas "$displayName" en su ubicación ("$path")?';
  static String whatActionForInstancePrompt(String displayName) => '¿Qué acción deseas realizar sobre la instancia "$displayName"?';
  static String confirmDeregisterInstanceMessage(String displayName) => '¿Confirmas que deseas eliminar del inventario esta instancia de "$displayName"?';
  static String locationVerificationSubtitle(String displayName, String path) => '$displayName • Ubicación registrada: $path';
  static String locationVerificationQuestion(String displayName, String path) => '¿La ubicación de "$displayName" sigue siendo "$path"?';
  static String perishableMissingExpirationSubtitle(String displayName, String species) => '$displayName • Especie: $species';
  static String perishableMissingExpirationQuestion(String species, String displayName) => '¿Deseas asignar fecha de caducidad a la instancia "$displayName" ($species)?';
  static String nonPerishableWithExpirationSubtitle(String displayName, String date) => '$displayName • Caducidad asignada: $date';
  static String nonPerishableWithExpirationQuestion(String species, String displayName) => '¿Deseas remover la fecha de caducidad de "$displayName" ($species no perecedera)?';
  static String unitSymbolParentheses(String symbol) => ' ($symbol)';
  static String missingMagnitudeTitle(String property) => 'Magnitud Faltante: $property';
  static String missingMagnitudeSubtitle(String displayName, String property, String unitSuffix) => '$displayName • Especie define: $property$unitSuffix';
  static String missingMagnitudeQuestion(String displayName, String property, String species) => '¿Deseas registrar el valor de "$property" para "$displayName"?';
  static String propertyRegisteredSuccess(String property) => 'Propiedad "$property" registrada.';
  static String anomalousMagnitudeSubtitle(String displayName, String property, num value, String unit) => unit.isNotEmpty ? '$displayName • $property: $value $unit' : '$displayName • $property: $value';
  static String anomalousMagnitudeQuestion(String property, num value) => '¿Deseas corregir el valor anómalo de "$property" ($value)?';
  static String propertyValueUpdatedSuccess(String property, num value) => 'Valor de "$property" actualizado a $value.';
  static String numismaticDuplicateSubspeciesSubtitle(String subspecies, int count, String species) => '$subspecies • $count subespecies idénticas en $species';
  static String numismaticDuplicateSubspeciesQuestion(int count, String subspecies) => '¿Deseas fusionar las $count subespecies de "$subspecies" en una sola canónica?';
  static String mergeDuplicateSubspeciesPrompt(int count, String subspecies) => '¿Deseas consolidar las $count subespecies de "$subspecies" en una sola subespecie y reasignar todas las instancias existentes?';
  static String numismaticSubspeciesIncongruitySubtitle(String displayName, String subspecies) => '$displayName • Subespecie: $subspecies';
  static String numismaticSubspeciesIncongruityQuestion(String issueMsg) => '$issueMsg ¿Deseas actualizar la subespecie con los datos de esta pieza?';
  static String desyncedAttachmentNameSubtitle(String displayName, String fileName) => '$displayName • Actual: $fileName';
  static String desyncedAttachmentNameQuestion(String fileName, String subspecies, String expected) => '¿Deseas renombrar el adjunto "$fileName" a su formato canónico "$expected"?';
  static String incompleteNumismaticMagnitudesSubtitle(String displayName, String mags) => '$displayName • Faltan: $mags';
  static String incompleteNumismaticMagnitudesQuestion(String displayName, String mags) => '¿Deseas autocompletar las magnitudes ($mags) de "$displayName" desde la subespecie?';
  static String emptyGradeDataSubtitle(String displayName) => '$displayName • Grado de conservación sin asignar';
  static String emptyGradeDataQuestion(String displayName) => '¿Deseas asignar un grado de conservación a la pieza "$displayName"?';
  static String gradeUpdatedSuccess(String grade) => 'Grado de conservación actualizado a "$grade".';
  static String photoOfDisplayName(String name) => 'Foto de $name';

  static String invalidUnitSymbolSubtitle(String targetName, String propName, String symbol) => '$targetName • Propiedad "$propName" con unidad no estándar "$symbol"';
  static String invalidUnitSymbolQuestion(String propName, String symbol) => '¿Deseas reemplazar la unidad no reconocida "$symbol" en "$propName" por una unidad estándar?';
  static String integerUnitIncongruitySubtitle(String targetName, String propName, String symbol) => '$targetName • Propiedad "$propName" ($symbol) con tipo o valor no entero';
  static String integerUnitIncongruityQuestion(String propName, String symbol) => '¿Deseas normalizar a entero el valor y tipo de "$propName" con unidad "$symbol"?';
  static String nonNumericWithUnitSubtitle(String targetName, String propName, String dataType, String symbol) => '$targetName • Propiedad "$propName" ($dataType) con unidad física "$symbol"';
  static String nonNumericWithUnitQuestion(String propName, String dataType) => '¿Deseas remover la unidad física de la propiedad no numérica "$propName"?';
  static String negativeMagnitudeViolationSubtitle(String targetName, String propName, num val, String symbol) => symbol.isNotEmpty ? '$targetName • "$propName" con valor negativo inválido ($val $symbol)' : '$targetName • "$propName" con valor negativo inválido ($val)';
  static String negativeMagnitudeViolationQuestion(String propName) => '¿Deseas corregir el valor negativo no permitido en "$propName"?';
  static String propertyNameSuggestionIncongruitySubtitle(String spName, String currentProp, String suggestedProp, String symbol) => '$spName • "$currentProp" ($symbol) ➔ Sugerido: "$suggestedProp"';
  static String propertyNameSuggestionIncongruityQuestion(String currentProp, String suggestedProp, String symbol) => '¿Deseas renombrar la propiedad "$currentProp" a su sugerencia estándar "$suggestedProp"?';

  // Formularios Numismáticos, Asistente de Escaneo e Inventario
  static const otherSpecifyParenthesized = 'Otro (especificar)';
  static const materialPaper = 'Papel';
  static const inAppQuickFillSourceEngine = 'Formulario Rápido In-App';
  static const coinCircularDescriptor = 'Moneda (Circular)';
  static const banknoteRectangleDescriptor = 'Billete (Rectangular)';
  static const capturingHighDefinitionPrompt = 'Capturando en alta definición...';
  static const captureCompleteStatus = 'CAPTURA COMPLETA (2/2)';
  static const step1Obverse = 'PASO 1: ANVERSO';
  static const step2Reverse = 'PASO 2: REVERSO';
  static const disableTorchTooltip = 'Desactivar linterna';
  static const enableTorchTooltip = 'Activar linterna (evita barrido)';
  static const bothSidesReadyTip = '¡Ambos lados listos! Pulsa "Continuar a Datos Numismáticos".';
  static const cameraIlluminationTip = 'Tip: Activa la linterna y ajusta el zoom para encuadrar la pieza.';
  static const continueToNumismaticDataAction = 'Continuar a Datos Numismáticos';
  static const emptyContainerPrompt = 'Este contenedor está vacío.\nArrastra elementos aquí para guardarlos.';
  static const emptyLocationPrompt = 'No hay elementos en esta ubicación.';
  static const cameraInitErrorPrefix = 'Error al inicializar cámara: ';
  static const cameraCaptureErrorPrefix = 'Error en captura: ';
  static String selectedCount(int count) => '$count seleccionado(s)';
  static String currencyCodeWithName(String code, String name) => '$code ($name)';
  static String zoomLevelDisplay(double zoom) => '${zoom.toStringAsFixed(1)}x';

  // Catalog, Taxonomy, Media and Species Form Strings
  static const replaceAction = 'Reemplazar';
  static const attachToInstanceAction = 'Adjuntar a esta Instancia';
  static const attachmentAddedToEditing = 'Adjunto agregado a la edición.';
  static const attachmentAddedSuccessfully = 'Adjunto agregado correctamente.';
  static const numismaticAttachmentModifiedInEditing = 'Adjunto numismático modificado en la edición.';
  static const numismaticAttachmentUpdatedSuccessfully = 'Adjunto numismático actualizado correctamente.';
  static const attachmentModifiedInEditing = 'Adjunto modificado en la edición.';
  static const attachmentReplacedSuccessfully = 'Adjunto reemplazado correctamente.';
  static const nameUpdatedInEditing = 'Nombre actualizado en la edición.';
  static const nameUpdatedSuccessfully = 'Nombre actualizado correctamente.';
  static const physicalFileNotFoundInStorage = 'El archivo físico no existe en el almacenamiento.';
  static const attachmentRemovedFromEditing = 'Adjunto removido de la edición.';
  static const attachmentDeletedSuccessfully = 'Adjunto eliminado correctamente.';
  static const speciesLabel = 'Especie';
  static const instanceLabel = 'Instancia';
  static const nonPerishable = 'Imperecedero';
  static const perishable = 'Perecedero';
  static const addAttachmentToThisInstance = 'Agregar adjunto a esta instancia';
  static const physicalFileNotFound = 'Archivo físico no encontrado';
  static const selectOrCaptureAttachmentTitle = 'Seleccionar o Capturar Adjunto';
  static const scanObverseTitle = 'Escanear anverso';
  static const scanReverseTitle = 'Escanear reverso';
  static const coinWord = 'moneda';
  static const banknoteWord = 'billete';
  static const searchOnlineImagesByName = 'Buscar imágenes online por nombre';
  static const captureVisualMatchAction = 'Capturar Coincidencia Visual';
  static const analyzingCapturedImage = 'Analizando imagen capturada...';
  static const noBarcodeOrIsbnDetected = 'No se detectó un código de barras o ISBN en la imagen.';
  static const noPhotoSelected = 'No se seleccionó ninguna foto.';
  static const searchWebImageTitle = 'Buscar Imagen en Internet';
  static const defaultNewObjectName = 'Nuevo Objeto';
  static const processing = 'Procesando...';

  static String confirmDeleteAttachmentPrompt(String name) => '¿Deseas eliminar permanentemente el archivo "$name"?';
  static String speciesPrefix(String name) => 'Especie: $name';
  static String perishableWithShelfLife(int? days) => days != null ? 'Perecedero ($days días de vida útil)' : 'Perecedero';
  static String mergeSpeciesDescription(String sourceName) => 'Se fusionará "$sourceName" con otra especie. Todas las subespecies e instancias pertenecerán a la especie destino.';
  static String speciesMergedSuccess(String source, String target) => 'Especie "$source" unida exitosamente en "$target".';
  static String separateSubspeciesDescription(String subName) => 'La subespecie "$subName" se promoverá a una especie independiente.';
  static String moveSubspeciesDescription(String subName) => 'Se moverá la subespecie "$subName" y sus instancias a la especie seleccionada.';
  static String newSpeciesDefaultName(String subName) => '$subName (Especie)';
  static String numismaticObverseSubtitle(String itemType) => 'Retícula guiada, corrección de exposición y recorte centrado para anverso de $itemType.';
  static String numismaticReverseSubtitle(String itemType) => 'Retícula guiada, corrección de exposición y recorte centrado para reverso de $itemType.';
  static String suggestedSearchQuery(String query) => 'Búsqueda sugerida: "$query"';
  static String searchingBarcode(String barcode) => 'Buscando código $barcode...';
  static String autoInstantiatedFeedback(String subName, String speciesName) => 'Instanciado automáticamente: $subName ($speciesName)';
  static String autoFillError(String err) => 'Error en autollenado: $err';
  static String photoProcessingError(String err) => 'Error al procesar foto: $err';
  static String searchWebImagesError(String err) => 'Error buscando imágenes: $err';
  static String downloadOrAssignImageError(String err) => 'Error al descargar/asignar la imagen: $err';
  static String saveSubspeciesError(String err) => 'Error al guardar subespecie: $err';
  static String replaceAttachmentError(String err) => 'Error al reemplazar adjunto: $err';
  static String errorOpeningFile(Object err) => '$errorOpeningFilePrefix$err';
  static String errorSharingFile(Object err) => '$errorSharingFilePrefix$err';
  static String renameError(String err) => 'Error al renombrar: $err';
  static String deleteError(String err) => 'Error al eliminar: $err';
  static String mergeSpeciesError(String err) => 'Error al unir especies: $err';

  // Respaldo y Base de Datos (Errores y Mensajes Adicionales)
  static const backupZipCompressionError = 'Error al generar la compresión del paquete de respaldo.';
  static const backupZipMissingDatabaseJsonError = 'El paquete ZIP no contiene un archivo database.json válido.';
  static const invalidBackupStructureError = 'El archivo de respaldo no tiene una estructura válida.';
  static const unspecifiedGrade = 'No especificado';

  // Servicio de Actualizaciones (Logs y Mensajes de UI)
  static const errorGettingPackageVersion = 'Error al obtener la versión del paquete';
  static const checkingUpdateInNativeChannel = 'Consultando disponibilidad de actualización en canal nativo...';
  static const platformExceptionCheckingUpdate = 'PlatformException al verificar actualización';
  static const unexpectedErrorCheckingUpdate = 'Error inesperado verificando actualización';
  static const invokingUpdateAppNative = 'Invocando método updateApp en canal nativo...';
  static const errorExecutingUpdateApp = 'Error al ejecutar updateApp';
  static const errorTriggeringUpdate = 'Error al disparar actualización';

  // Dynamic Helpers para Actualizaciones, Almacenamiento y Versiones
  static String sourceFileNotFoundAtPath(String path) => 'El archivo origen no existe en la ruta: $path';
  static String errorComparingVersions(String latest, String current) => 'Error comparando versiones ($latest vs $current)';
  static String autoUpdatesOnlyOnAndroid(String platform) => 'Las actualizaciones automáticas solo están disponibles en Android (Plataforma actual: $platform).';
  static String updateCheckResult(bool available, String? latest, String current) => 'Resultado de actualización: disponible=$available (remoto=$latest, actual=$current)';
  static String versionDisplay(String? version) => 'v${version ?? '?'}';
  static String sqlSecurityError(String kw) => '$sqlSecurityErrorPrefix$kw$sqlSecurityErrorSuffix';
  static String sqlSyntaxError(String err) => '$sqlSyntaxErrorPrefix$err';
  static String rowsRetrieved(int count) => '$rowsRetrievedPrefix$count';
  static String noSearchMatches(String query) => '$noSearchMatchesPrefix$query$noSearchMatchesSuffix';
  static String errorWithDetails(Object err) => '$errorPrefix$err';
  static String updateErrorWithException(Object error) => '$updateError$error';
  static String backupExportErrorMessage(Object error) => '$backupExportErrorPrefix$error';
  static String backupImportErrorMessage(Object error) => '$backupImportErrorPrefix$error';
  static String formatObjectsCount(int count) => '$count $objectsLabel';
  static String sectionHeaderWithCount(String section, int count) => '$section ($count)';
  static String scopeWithPrefix(String scope) => '$searchScopePrefix$scope';
  static String dateRangeFormatted(String start, String end) => '$start - $end';

  // Activity Log Dynamic Helpers & Constants
  static const historyTitle = 'Historial y Auditoría';
  static const historyScreenTitle = 'Historial y Auditoría';
  static const historyScreenSubtitle = 'Consulta todos los cambios y eventos registrados en la base de datos';
  static const historySearchHint = 'Buscar eventos, descripciones o nombres...';
  static const filterAll = 'Todos';
  static const filterEntities = 'Instancias';
  static const filterSpecies = 'Especies';
  static const filterLocations = 'Ubicaciones';
  static const filterRelations = 'Relaciones';
  static const filterBackups = 'Respaldos y Sistema';
  static const categoryFilterAll = 'Todos';
  static const categoryFilterEntities = 'Instancias';
  static const categoryFilterSpecies = 'Especies';
  static const categoryFilterLocations = 'Ubicaciones';
  static const categoryFilterRelations = 'Relaciones';
  static const categoryFilterBackupsAndSystem = 'Respaldos y Sistema';
  static const historyDetailTitle = 'Detalle de Evento';
  static const eventDetailsTitle = 'Detalle de Evento';
  static const historyEmptySearch = 'No se encontraron eventos que coincidan con la búsqueda.';
  static const historyEmptyCategory = 'Sin actividad registrada en esta categoría.';
  static const noHistoryEvents = 'Sin actividad registrada';
  static const noHistoryEventsSubtitle = 'Los eventos y modificaciones en el sistema aparecerán aquí cronológicamente.';
  static const historyTimestampLabel = 'Fecha y hora exacta';
  static const exactTimestampLabel = 'Fecha y hora exacta';
  static const historyCategoryLabel = 'Categoría';
  static const categoryLabel = 'Categoría';
  static const historyTypeLabel = 'Tipo de evento';
  static const historyTargetLabel = 'Elemento involucrado';
  static const targetIdLabel = 'ID del elemento';
  static const targetTypeLabel = 'Tipo de elemento';
  static const historyPayloadLabel = 'Metadatos / Cambios';
  static const technicalDetailsTitle = 'Metadatos / Detalles técnicos';
  static const historyNavigateToTarget = 'Ver elemento';
  static const viewTargetAction = 'Ver elemento';
  static const historyClearHistoryTooltip = 'Limpiar historial';
  static const clearHistoryTooltip = 'Limpiar historial';
  static const historyClearConfirmationTitle = '¿Vaciar historial de actividad?';
  static const clearHistoryTitle = '¿Vaciar historial de actividad?';
  static const historyClearConfirmationMessage = 'Esta acción eliminará los registros del historial de eventos. Los datos de tus entidades, especies y ubicaciones no se verán afectados.';
  static const clearHistoryConfirmation = 'Esta acción eliminará los registros del historial de eventos. Los datos de tus entidades, especies y ubicaciones no se verán afectados.';
  static const cancelAction = 'Cancelar';
  static const clearAction = 'Vaciar';
  static const historyAuditLogSettings = 'Historial de auditoría de BD';
  static const historyAuditLogSettingsSubtitle = 'Consulta todos los cambios y eventos registrados en la base de datos';
  static const timeJustNow = 'Hace un momento';
  static String timeMinutesAgo(int m) => 'Hace $m min';
  static String timeHoursAgo(int h) => 'Hace $h h';
  static String timeDaysAgo(int d) => 'Hace $d d';

  static String activityRegistered(String name, String type) => 'Registrado en tu mundo: "$name" ($type)';
  static String activityEditedWithDetails(String name, String details) => 'Editado "$name": $details';
  static String activityEdited(String name) => 'Editada información de "$name"';
  static String activityDeleted(String name) => 'Eliminado de tu mundo: "$name"';
  static String activityMoved(String name, String from, String to) => 'Trasladado "$name" de "$from" a "$to"';
  static String activityAttachmentAdded(String fileName, String entityName) => 'Adjuntado archivo "$fileName" a "$entityName"';
  static String activityAttachmentRemoved(String fileName, String entityName) => 'Eliminado archivo "$fileName" de "$entityName"';
  static String activityRelationAdded(String sourceName, String relationType, String targetName) => 'Vínculo establecido: "$sourceName" $relationType "$targetName"';
  static String activityRelationRemoved(String sourceName, String relationType, String targetName) => 'Vínculo eliminado: "$sourceName" $relationType "$targetName"';
  static String activityPhotoChanged(String name) => 'Actualizada fotografía principal de "$name"';
  static String activityPhotoRemoved(String name) => 'Eliminada fotografía principal de "$name"';
  static String activityQuantityConsumed(String name, Object qty, String unit) => 'Cantidad ajustada de "$name": $qty $unit';
  static String activitySpeciesCreated(String name, String type) => 'Nueva especie registrada: "$name" ($type)';
  static String activitySpeciesEdited(String name, String details) => 'Especie modificada "$name": $details';
  static String activitySpeciesDeleted(String name) => 'Especie eliminada: "$name"';
  static String activitySpeciesMerged(String source, String target) => 'Especie "$source" fusionada en "$target"';
  static String activitySubspeciesCreated(String subName, String speciesName) => 'Nueva subespecie registrada: "$subName" en "$speciesName"';
  static String activitySubspeciesSeparated(String subName, String newSpecies) => 'Subespecie "$subName" separada a especie "$newSpecies"';
  static String activitySubspeciesMoved(String subName, String targetSpecies) => 'Subespecie "$subName" trasladada a "$targetSpecies"';
  static String activitySubspeciesDeleted(String subName) => 'Subespecie eliminada: "$subName"';
  static String activityLocationCreated(String name) => 'Nueva ubicación registrada: "$name"';
  static String activityLocationEdited(String name) => 'Ubicación modificada: "$name"';
  static String activityLocationMoved(String name, String? parent) => parent != null ? 'Ubicación "$name" trasladada a "$parent"' : 'Ubicación "$name" convertida en principal';
  static String activityLocationDeleted(String name) => 'Ubicación eliminada: "$name"';
  static String activityEntitiesBatchDeleted(int count) => 'Eliminación en lote: $count instancias eliminadas';
  static String activityBackupExported(int totalRecords) => 'Copia de seguridad exportada ($totalRecords registros)';
  static String activityBackupRestored(int totalRecords, String? originDate) => originDate != null ? 'Copia de seguridad restaurada ($totalRecords registros, origen: $originDate)' : 'Copia de seguridad restaurada ($totalRecords registros)';
  static String activityAuditFixApplied(String ruleTitle, String details) => 'Auditoría aplicada: $ruleTitle ($details)';
  static String activityEntityUpdatedInPlace(String name, String changes) => 'Actualizada instancia de "$name": $changes';


  // Presentation Dynamic Helpers (Entities, Locations, Notifications)
  static String editPropertyTitle(String propertyName) => 'Editar propiedad "$propertyName"';
  static String valueWithUnitLabel(String unit) => 'Valor ($unit)';
  static String valueWithDataTypeLabel(String dataType) => 'Valor ($dataType)';
  static String unitOrTypeInParentheses(String value) => ' ($value)';
  static String propertyWithUnitOrType(String propertyName, String unitOrType) => '$propertyName ($unitOrType)';
  static String deleteSpeciesInstanceConfirmation(String speciesName) => '¿Estás seguro de que deseas eliminar "$speciesName"?';
  static String speciesGeneralWithType(String speciesName, String type) => 'Especie general: $speciesName ($type)';
  static String barcodeWithColon(String barcode) => 'Código de barras: $barcode';
  static String dateFormattedWithDays(String dateStr, String daysStr) => '$dateStr ($daysStr)';
  static String expiredDaysAgo(int days) => 'Vencido hace $days días';
  static String expiresInDaysAlert(int days) => '¡Vence en $days días!';
  static String expiresInDays(int days) => 'Vence en $days días';
  static String confirmDeleteProperty(String propertyName) => '¿Estás seguro de que deseas eliminar la propiedad "$propertyName"?';
  static String numismaticSpeciesDescription(String speciesType) => 'Colección Numismática ($speciesType)';
  static String pieceInstantiatedDirectly(String name) => 'Pieza "$name" instanciada directamente.';
  static String speciesInstantiatedSuccessWithName(String speciesName) => 'Instancia agregada exitosamente: "$speciesName"';
  static String instantiateSpeciesTitle(String speciesName) => 'Instanciar "$speciesName"';
  static String subspeciesWithBrand(String name, String? brand) => brand != null ? '$name ($brand)' : name;
  static String typeWithPropertyAndValue(String type, String propertyName, String displayValue) => '$type • $propertyName: $displayValue';
  static String confirmReplaceAttachmentNamedMessage(String fileName) => '$confirmReplaceAttachmentMessage\n("$fileName")';
  static String confirmReplaceAttachmentRenamedMessage(String oldName, String newName) => '$confirmReplaceAttachmentMessage\n("$oldName" ➔ "$newName")';
  static String confirmRemoveAttributeMessage(String key) => '¿Deseas eliminar el atributo "$key"?';
  static String confirmDeleteLocationMessage(String name) => '¿Estás seguro de que deseas eliminar la ubicación "$name" y todo su contenido?';
  static String objectsInLocationAndSublocations(int count) => '$count objetos contenidos';
  static String locationCorrectionError(String err) => 'Error al corregir ubicación: $err';
  static String correctLocationTitle(String entityName) => 'Corregir ubicación de "$entityName"';

  // Domain Rules Property Name Suggestions
  static const propMass = 'Masa';
  static const propVolume = 'Volumen';
  static const propLength = 'Longitud';
  static const propSurface = 'Superficie';
  static const propTime = 'Tiempo';
  static const propElectricCurrent = 'Corriente eléctrica';
  static const propTemperature = 'Temperatura';
  static const propSubstanceAmount = 'Cantidad de sustancia';
  static const propLuminousIntensity = 'Intensidad luminosa';
  static const propForce = 'Fuerza';
  static const propPressure = 'Presión';
  static const propEnergy = 'Energía';
  static const propPower = 'Potencia';
  static const propFrequency = 'Frecuencia';
  static const propVoltage = 'Voltaje';
  static const propResistance = 'Resistencia';
  static const propStorage = 'Almacenamiento';
  static const propYear = 'Año';
  static const propQuantity = 'Cantidad';
  static const propPrice = 'Precio';
  static const propFaceValue = 'Valor Facial';
  static const propDefault = 'Propiedad';

  // Numismatic Defaults, Prefixes & Magnitude Names
  static const defaultNumismaticPiece = 'Pieza Numismática';
  static const noteCoinPrefix = 'Moneda: ';
  static const noteYearPrefix = 'Año: ';
  static const noteMaterialPrefix = 'Material: ';
  static const magValorNominal = 'Valor nominal';
  static const magAcunacion = 'Acuñación';
  static const magDivisa = 'Divisa';
  static const magMaterial = 'Material';
  static const magGrado = 'Grado';

  // Taxonomy & Product Defaults
  static const speciesBook = 'Libro';

  // Perishability Inference Reasons
  static const perishabilityReasonNonObjectType = 'Las especies de tipo distinto a Objeto son No Perecederas por definición.';
  static String perishabilityReasonDurableObject(String kw) => 'Detectado como objeto durable/no alimenticio ($kw).';
  static const perishabilityReasonDairy = 'Categoría Lácteos (~14 días de vida útil).';
  static const perishabilityReasonBakery = 'Categoría Panadería (~7 días de vida útil).';
  static const perishabilityReasonFruitVeg = 'Categoría Frutas & Verduras (~7 días de vida útil).';
  static const perishabilityReasonMeat = 'Categoría Carnes & Pescados (~5 días de vida útil).';
  static const perishabilityReasonBeverage = 'Categoría Bebidas Perecederas (~30 días de vida útil).';
  static const perishabilityReasonPharmacy = 'Categoría Farmacia / Salud (~365 días de vida útil).';
  static const perishabilityReasonCanned = 'Categoría Enlatados & Conservas (~365 días de vida útil).';
  static const perishabilityReasonDefault = 'No se identificó categoría perecedera; configurado como No Perecedero por defecto.';

  // Activity Logger Descriptions (new entry-point methods not in previous block)
  static String activityEntityCreated(String name, String type) => 'Registrado en tu mundo: "$name" ($type)';
  static String activityEntityEditedWithDetails(String name, String details) => 'Editado "$name": $details';
  static String activityEntityEdited(String name) => 'Editada información de "$name"';
  static String activityEntityDeleted(String name) => 'Eliminado de tu mundo: "$name"';
  static String activityEntityMoved(String name, String from, String to) => 'Trasladado "$name" de "$from" a "$to"';

  // Notification Message Builders
  static String notifMessageExpired(String formattedDate) =>
      formattedDate.isNotEmpty ? 'Fecha de caducidad: $formattedDate' : expiredItemTitle;
  static String notifMessageExpiringSoon(int daysLeft, String formattedDate) =>
      'Caduca en $daysLeft día(s) ($formattedDate)';
  static String notifMessageUnsatisfiedNeed(String deficitStr, double stockCount, double requiredQty) =>
      'Faltan $deficitStr unidad(es) ($stockCount/$requiredQty en inventario)';

  // Date Formatting
  static const _zeroPad = '0';
  static String formatDateDMY(DateTime? dt) {
    if (dt == null) return AppTechnicalStrings.empty;
    final d = dt.day.toString().padLeft(2, _zeroPad);
    final m = dt.month.toString().padLeft(2, _zeroPad);
    return '$d/$m/${dt.year}';
  }

  static String formatDateTimeDMY(DateTime? dt) {
    if (dt == null) return AppTechnicalStrings.empty;
    final y = dt.year.toString().padLeft(4, _zeroPad);
    final m = dt.month.toString().padLeft(2, _zeroPad);
    final d = dt.day.toString().padLeft(2, _zeroPad);
    final hh = dt.hour.toString().padLeft(2, _zeroPad);
    final mm = dt.minute.toString().padLeft(2, _zeroPad);
    return '$d/$m/$y $hh:$mm';
  }

  static const infoUpdated = 'Información actualizada';
  static const historyLocationModified = 'Ubicación modificada';
  static const historyNotesUpdated = 'Notas actualizadas';
  static const historyExpirationUpdated = 'Fecha de caducidad actualizada';

  // Numismatic Camera Capture View
  static const numisAnversoSideLabel = 'Anverso';
  static const numisReversoSideLabel = 'Reverso';
  static String numisCaptureCoinTitle(String side) => 'Captura de Moneda ($side)';
  static String numisCaptureBanknoteTitle(String side) => 'Captura de Billete ($side)';
  static String numisActiveSideLabel(String side) => 'CAPTURA: $side';
  static const numisCapturingHD = 'Capturando en alta definición...';
  static const numisErrorInitCamera = 'Error al inicializar cámara: ';
  static String numisErrorInitCameraMsg(Object e) => 'Error al inicializar cámara: $e';
  static const numisCropFailedLogPrefix = 'Numismatic crop isolate failed or timed out: ';
  static String numisCropFailedLog(Object e) => 'Numismatic crop isolate failed or timed out: $e';
  static const numisErrorCapture = 'Error en captura: ';
  static String numisErrorCaptureMsg(Object e) => 'Error en captura: $e';
  static const numisCameraIlluminationTip2 = 'Tip: Activa la linterna y ajusta el zoom para encuadrar los relieves.';
  static const numisVolumeShutterTip = 'Dispara con el obturador o con los botones de volumen (+ / -)';

  // Numismatic Audit Message Builders
  static String numisAuditTitleMismatch(String actual, String canonical) =>
      'Título no estandarizado (Actual: "$actual" vs Estándar: "$canonical")';
  static String numisAuditYearMismatch(Object inst, Object sub) =>
      'Año (Instancia: $inst vs Subespecie: $sub)';
  static String numisAuditFaceValueMismatch(Object inst, Object sub) =>
      'Valor Nominal (Instancia: $inst vs Subespecie: $sub)';
  static String numisAuditCurrencyNotIso(String actual, String iso) =>
      'Divisa de instancia no es código ISO (Actual: "$actual" vs Código ISO: "$iso")';
  static String numisAuditGradeMismatch(String actual, String std) =>
      'Grado de conservación no estandarizado (Actual: "$actual" vs Estándar: "$std")';
  static String numisAuditMaterialMismatch(String actual, String std) =>
      'Material no estandarizado (Actual: "$actual" vs Estándar: "$std")';
  static String numisAuditIncongruence(String joined) => 'Incongruencia: $joined';
  static String numisAttachmentPath(String dir, String name) => '$dir/$name';

  // Taxonomy Chain
  static const taxonomyDepartmentGeneral = 'General';
  static String taxonomyCombinedText(String? g, String? c, String t) =>
      '${g ?? AppTechnicalStrings.empty} ${c ?? AppTechnicalStrings.empty} $t';

  // Species Form Modal Helpers
  static String fileAttachedToSpecies(String fileName) => 'Archivo "$fileName" adjuntado a la especie.';
  static String confirmDeletePropertyNamed(String propertyName) => '¿Estás seguro de que deseas eliminar la propiedad "$propertyName"?';
  static String confirmDeleteSubspeciesNamed(String subspeciesName) => '¿Estás seguro de que deseas eliminar permanentemente la subespecie "$subspeciesName"?';
  static String subspeciesOrBrandsWithCount(int count) => '$subspeciesOrBrands ($count)';
  static String instancesCount(int count) => count == 1 ? '1 instancia' : '$count instancias';
  static String subspeciesCountWithInstances(int subspeciesCount, int instancesCount) => '$subspeciesOrBrands ($subspeciesCount) • $tabEntities ($instancesCount)';
  static String confirmDeleteSpeciesNamed(String name) => '$deleteConfirmationMessage "$name"?';

  // Catalog Domain & Presentation Helpers
  static const propMonetaryUnit = 'Unidad Monetaria';
  static String separatedFromSpeciesName(String name) => '$separatedFromSpeciesPrefix$name';
  static const errorNoCamerasFound = 'No se encontraron cámaras disponibles en el dispositivo.';
  static const errorCameraInitCancelledWidgetDisposed = 'Inicialización cancelada: el widget ya fue descartado.';
  static const errorCouldNotInitBackCamera = 'No se pudo inicializar la cámara trasera.';
  static String invalidOrNotFoundCodeMessage(String barcode) => '$invalidOrNotFoundCodeMessagePrefix$barcode$invalidOrNotFoundCodeMessageSuffix';
  static String cameraInitError(Object e) => '$cameraInitErrorPrefix$e';
  static String cameraCaptureError(Object e) => '$cameraCaptureErrorPrefix$e';
  static String nameWithType(String name, String type) => '$name ($type)';
  static String confirmDeleteRequirementMessage(String speciesName) => '$confirmDeleteRequirementMessagePrefix$speciesName$confirmDeleteRequirementMessageSuffix';
  static String requirementSummary(String formattedQty, String speciesName) => '$needsPrefix $formattedQty x $speciesName';
  static String formatQuantityValue(double qty) => qty % 1 == 0 ? '${qty.toInt()}' : '$qty';
  static String entitiesTabWithCount(int count) => '$tabEntities ($count)';
  static String quantityWithFormattedUnit(String formattedValue, String unit) => '$quantityLabel: $formattedValue $unit';
  static String quantityWithValue(String value) => '$quantityLabel: $value';
  static String breadcrumbPathAndTarget(String ancestorPath, String targetName) => '$ancestorPath $targetName';

  // Presentation & Interaction Helpers
  static String reviewCounter(int current, int total) => 'Revisión $current de $total';
  static String pendingReviews(int count) => '$count pendientes';
  static String controlCenterLoadError(Object error) => '$controlCenterLoadErrorPrefix$error';
  static String countString(num count) => count.toString();
  static String speciesTypeWithBullet(String type, String? name) => name != null && name.isNotEmpty ? '$type • $name' : type;
  static String objectsCount(int count) => '$count $objectsLabel';
  static const draggingElement = 'Arrastrando elemento';
  static String draggingUnits(int count) => 'Arrastrando $count unidades';
  static String draggingSelectedElements(int count) => 'Arrastrando $count elementos seleccionados';
  static String updateErrorWithDetails(Object err) => '$updateError$err';
  static String appVersionDisplay(String version) => '$appName • $appVersionLabel: v$version';
  static String loadNotificationsError(Object err) => '$loadNotificationsErrorPrefix$err';
  static String saveRelationError(Object err) => '$saveRelationErrorPrefix$err';
  static String quoted(String text) => '"$text"';
  static String relationCreatedSuccess(String relationType) => '$relationCreatedSuccessPrefix$relationType$relationCreatedSuccessSuffix';
  static String linkEntityTitle(String name) => '$link "$name"';
  static String relationsLoadError(Object err) => '$relationsLoadErrorPrefix$err';
  static String linksCount(int count) => '$count$linksCountSuffix';
  static String confirmDeleteRelationMessage(String relationType, String otherName) => '$confirmDeleteRelationMessagePrefix$relationType$confirmDeleteRelationMessageMiddle$otherName$confirmDeleteRelationMessageSuffix';
  static const centralInstanceLabelColon = '$centralInstanceLabel: ';

  // Taxonomy Operations Helpers
  static String subspeciesSeparatedSuccess(String speciesName) => '$subspeciesSeparatedSuccessPrefix"$speciesName".';
  static String separateSubspeciesError(Object e) => '$separateSubspeciesErrorPrefix$e';
  static String subspeciesMovedSuccess(String targetName) => '$subspeciesMovedSuccessPrefix"$targetName".';
  static String moveSubspeciesError(Object e) => '$moveSubspeciesErrorPrefix$e';

  // Entity Display Helpers
  static String speciesWithSubspeciesDisplay(String speciesName, String subspeciesWithBrand) => '$speciesName - $subspeciesWithBrand';
  static const affirmativeYes = 'Sí';
  static const negativeNo = 'No';
  static String valueWithUnit(String value, String unit) => '$value $unit';
  static String propertyNameWithUnitText(String name, String unitText) => '$name$unitText';

  // Instance Preview Card Helpers
  static String speciesTypeWithSpeciesNamePrefix(String type, String speciesName) => '$type • $speciesName • ';
  static String speciesTypeBulletPrefix(String type) => '$type • ';
  static String propertyWithColon(String propertyName, String displayValue) => '$propertyName: $displayValue';
  static String countWithStatus(int count, String status) => '$count $status';
  static String ancestorPathWithSpace(String path) => '$path ';

  // Special Edition Helpers
  static String specialEditionWithReason(String reason) => '$specialEditionNotePrefix$reason';
  static String specialEditionWithAdditionalNotes(String baseNote, String extraNotes) => '$baseNote ($extraNotes)';

  // Attachment Helpers
  static String scanReverseFileName(String speciesName) => '${scanReverseTitle}_$speciesName${AppTechnicalStrings.extJpg}';

  // Governance & Immediate Confirmation Helpers
  static const duplicateSpeciesDialogTitle = 'Nombre de especie duplicado';
  static String duplicateSpeciesPrompt(String name) => 'Ya existe una especie registrada con el nombre "$name". ¿Qué deseas hacer?';
  static const createSeparateSpeciesAction = 'Crear Especie Separada';
  static const mergeWithExistingSpeciesAction = 'Fusionar con Existente';
  static const duplicatePhotoDialogTitle = 'Fotografía ya asignada';
  static String duplicatePhotoPrompt(String speciesName) => 'Esta imagen ya está asignada a la especie "$speciesName". ¿Deseas vincular la misma fotografía o elegir otra?';
  static const reusePhotoAction = 'Vincular Misma Foto';
  static const deleteSpeciesWithInstancesTitle = 'Eliminar especie con instancias';
  static String deleteSpeciesWithInstancesPrompt(String speciesName, int count) => 'La especie "$speciesName" tiene $count instancia(s) activa(s) en el mundo. ¿Qué acción deseas realizar?';
  static const reassignInstancesAction = 'Reasignar Instancias';
  static const cascadeDeleteInstancesAction = 'Eliminar Todo en Cascada';
  static const deleteSubspeciesWithInstancesTitle = 'Eliminar subespecie con instancias';
  static String deleteSubspeciesWithInstancesPrompt(String subName, int count) => 'La subespecie "$subName" tiene $count instancia(s) activa(s). ¿Qué acción deseas realizar?';
  static const deleteOnlySubspeciesTitle = 'Eliminar única subespecie';
  static String deleteOnlySubspeciesPrompt(String speciesName) => 'Esta es la única subespecie de "$speciesName". Si la eliminas, la especie quedará sin subespecies hasta que crees una nueva. ¿Deseas continuar?';
  static const subgroupDeviationTitle = 'Excepción de regla de subgrupo';
  static String subgroupDeviationPrompt(String type, String attribute) => 'El subgrupo "$type" habitualmente no utiliza $attribute. ¿Deseas guardar esta excepción o prefieres corregirla?';
  static const confirmExceptionAction = 'Guardar Excepción';
  static const correctDataAction = 'Corregir Datos';
  static const showNonStandardFields = 'Campos adicionales no estándar';
  static const hideNonStandardFields = 'Ocultar campos adicionales';
  static const nonStandardFieldsHint = 'Campos no habituales para este subgrupo (se guardarán como excepción)';
  static String originSpeciesLeftEmptyWarning(String speciesName) => 'La especie de origen "$speciesName" ha quedado sin subespecies y se conservará como plantilla vacía en el catálogo.';
  static String instancesReassignedSuccess(int count, String target) => '$count instancia(s) reasignada(s) correctamente a "$target".';
  static String speciesDeletedWithCascadeSuccess(int count) => 'Especie y $count instancia(s) eliminadas correctamente.';
  static String duplicateSpeciesCardSubtitle(String name, int count) => '$count especies registradas con el nombre "$name".';
  static String duplicateSpeciesQuestion(String name) => '¿Deseas fusionar las especies homónimas "$name" o renombrar alguna?';
  static String duplicatePhotoCardSubtitle(String name, String other) => 'La especie "$name" comparte foto con "$other".';
  static String duplicatePhotoQuestion(String name, String other) => '¿Deseas mantener la misma foto o asignar imágenes separadas para "$name" y "$other"?';
  static String speciesWithoutSubspeciesSubtitle(String name) => 'La especie "$name" no tiene ninguna subespecie o variante registrada.';
  static String speciesWithoutSubspeciesQuestion(String name) => '¿Deseas crear la subespecie "Genérica", agregar una nueva subespecie o eliminar "$name"?';
  static const generateGenericSubspeciesAction = 'Crear "Genérica"';
  static String unlinkedInstancesSubtitle(String displayName) => 'La instancia "$displayName" no tiene una subespecie válida asociada.';
  static String unlinkedInstancesQuestion(String displayName) => '¿Deseas reasignar "$displayName" a una subespecie activa o darla de baja?';
  static String anomalousExpirationSubtitle(String displayName, String date) => 'Fecha de caducidad registrada: $date.';
  static String anomalousExpirationQuestion(String displayName) => 'La fecha de caducidad para "$displayName" parece incongruente. ¿Deseas ajustarla?';
  static const reassignToSubspeciesTitle = 'Reasignar a Subespecie';
  static const reassignToSpeciesTitle = 'Reasignar a Especie';
  static const selectTargetSubspeciesPrompt = 'Selecciona la subespecie de destino:';
  static const selectTargetSpeciesPrompt = 'Selecciona la especie de destino:';
  static const duplicateSpeciesMergedSuccess = 'Especies homónimas fusionadas correctamente.';
  static const speciesRenamedSuccess = 'Especie renombrada correctamente.';
  static const photoDecoupledSuccess = 'Fotografía desacoplada para esta especie.';
  static const genericSubspeciesGeneratedSuccess = 'Subespecie "Genérica" generada correctamente.';
  static const instanceReassignedSuccess = 'Instancia reasignada correctamente.';
}







