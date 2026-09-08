import 'app_technical_strings.dart';

class AppStrings {
  AppStrings._();

  // Navegación y general
  static const appName = 'PWMS';
  static const appTitle = 'PWMS: Gestión de mundo';
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

  // Pestañas y navegación principal
  static const tabHome = 'Inicio';
  static const tabEntities = 'Instancias';
  static const tabLocations = 'Ubicaciones';
  static const tabCatalog = 'Catálogo';
  static const tabHistory = 'Historial';
  static const tabSearch = 'Buscar';
  static const tabInventory = 'Inventario';
  static const inventoryTitle = 'Inventario';

  // Pantalla de inicio
  static const recentEntitiesTitle = 'Instancias recientes';
  static const activityTitle = 'Historial de actividad';
  static const universeCatalogTitle = 'Catálogo de especies';
  static const locationsTitle = 'Grafo de ubicaciones';
  static const noRecentObjects = 'No hay objetos recientes.';
  static const deletePropertyFromInstanceTooltip = 'Eliminar propiedad de esta instancia.';
  static const yearUnitSymbol = 'año';
  static const mainLocations = 'Ubicaciones principales';
  static const objectsCountSuffix = 'objetos';
  static const latestCatalogSpecies = 'Últimas especies en el catálogo';
  static const viewCatalog = 'Ver catálogo';
  static const noRecentActivity = 'No hay actividad reciente.';
  static const topLocationsTitle = 'Ubicaciones principales';
  static const objectsLabel = 'objetos';
  static const viewCatalogAction = 'Ver catálogo';
  static const viewAllAction = 'Ver todo';

  // Tipos y plantillas de entidades
  static const typeObject = 'Objeto';
  static const typeLivingBeing = 'Ser vivo';
  static const typeDocument = 'Documento';
  static const typeProject = 'Proyecto';
  static const typeMemory = 'Recuerdo';

  // Formularios y terminología de registro
  static const registerObjectTitle = 'Registrar en el mundo';
  static const editInstanceTitle = 'Editar instancia';
  static const nameLabel = 'Nombre de especie';
  static const typeLabel = 'Tipo de especie';
  static const locationLabel = 'Ubicación';
  static const quantityLabel = 'Magnitud';
  static const unitLabel = 'Unidad';
  static const barcodeLabel = 'Código de barras';
  static const notesLabel = 'Notas de la instancia';
  static const descriptionLabel = 'Descripción técnica';
  static const brandLabel = 'Marca';
  static const isUniqueLabel = 'Especie única';
  static const monetaryValueLabel = 'Valor monetario';
  static const currencyLabel = 'Divisa';
  static const isSaleLabel = 'Registrar como venta';
  static const takePhoto = 'Tomar fotografía';
  static const chooseGallery = 'Elegir de la galería';
  static const photoLabel = 'Fotografía principal';
  static const chooseFromCatalog = 'Elegir del catálogo';
  static const showMoreFields = 'Más campos';
  static const showFewerFields = 'Menos campos';
  static const registerAction = 'Registrar en el mundo';
  static const saveChangesAction = 'Guardar cambios';
  static const changePhotoAction = 'Cambiar fotografía';
  static const deletePhotoAction = 'Eliminar imagen';
  static const deleteMainPhotoAction = 'Eliminar imagen principal';
  static const confirmDeletePhotoTitle = 'Eliminar imagen';
  static const confirmDeletePhotoMessage = '¿Deseas eliminar la imagen principal? Se eliminará el archivo asociado.';
  static const photoDeletedSuccess = 'Imagen eliminada correctamente.';
  static const selectFromCatalogChoice = 'Elegir del catálogo';
  static const createNewSpeciesChoice = 'Crear nueva especie';
  static const instantiateTab = 'Instanciar';
  static const createSpeciesTab = 'Crear especie';
  static const addSubspeciesTab = 'Crear subespecie';
  static const autoFillTab = 'Autocompletar';
  static const addSubspeciesChoice = 'Agregar subespecie';

  // Catálogo de especies
  static const catalogTitle = 'Catálogo de especies';
  static const newSpeciesTitle = 'Nueva especie';
  static const createSpeciesHeader = 'Crear especie en el catálogo';
  static const saveSpeciesAction = 'Guardar especie';
  static const instantiateAction = 'Instanciar';
  static const emptyCatalog = 'El catálogo está vacío.';
  static const singleInstanceError = 'Esta especie es única y ya existe en el mundo.';
  static const singleInstanceSubspeciesError = 'La subespecie de esta especie única ya existe en el mundo.';
  static const duplicateSpeciesNameError = 'Ya existe una especie con este nombre.';
  static const duplicatePhotoError = 'Ya existe una especie con esta misma imagen.';
  static const duplicateAttachmentError = 'Este archivo adjunto ya existe en la especie.';
  static const latestCatalogSpeciesTitle = 'Últimas especies en el catálogo';

  // Subespecies y variantes
  static const subspeciesTitle = 'Subespecies';
  static const subspeciesCountTitle = 'Subespecies';
  static const addSubspecies = 'Agregar subespecie';
  static const addBrand = 'Agregar subespecie';
  static const noSubspecies = 'No hay subespecies registradas.';
  static const noSubspeciesDefined = 'Sin subespecies.';
  static const subspeciesNameLabel = 'Nombre de subespecie';
  static const editSubspecies = 'Editar subespecie';
  static const deleteSubspecies = 'Eliminar subespecie';
  static const defaultSubspeciesName = 'Genérica';
  static const viewCatalogSpecies = 'Ver especie en el catálogo';
  static const viewSpeciesDetail = 'Ver detalle de la especie';
  static const masterCatalogSpeciesBadge = 'Catálogo maestro';
  static const registeredPropertiesAndMagnitudes = 'Propiedades y magnitudes registradas';
  static const notInstantiatedYet = 'Esta especie aún no ha sido instanciada.';
  static const registeredInstance = 'Instancia registrada';
  static const speciesInstantiatedSuccess = 'Especie instanciada correctamente.';
  static const selectSpeciesToInstantiate = 'Selecciona una especie para instanciar.';
  static const instantiateCatalogSpeciesHeader = 'Instanciar especie del catálogo';
  static const catalogSpeciesLabel = 'Especie del catálogo';
  static const selectSpeciesPrompt = 'Selecciona una especie...';
  static const physicalLocation = 'Ubicación física';
  static const savedInContainer = 'Guardado en contenedor';
  static const selectContainerPrompt = 'Selecciona un contenedor:';
  static const noContainerObjectsAvailable = 'No hay objetos contenedores disponibles.';
  static const selectContainerObject = 'Selecciona el objeto contenedor';
  static const containerObjectLabel = 'Objeto contenedor';
  static const searchContainerHint = 'Buscar por nombre, especie o marca...';
  static const changeContainerAction = 'Cambiar contenedor';
  static String noContainersFoundForQuery(String query) => 'No se encontraron contenedores para "$query".';
  static const magnitudesAndSpecificProps = 'Magnitudes y propiedades:';
  static const subspeciesOrBrandCommercialLabel = 'Subespecie';
  static const selectSubspeciesOrBrandPrompt = 'Selecciona una subespecie';
  static const quantityToInstantiateLabel = 'Cantidad';
  static const addPropertyOrUnitTitle = 'Agregar propiedad o unidad';
  static const propertyNameHint = 'Nombre de la propiedad';
  static const selectUnitPrompt = 'Seleccionar unidad de medida';
  static const editSubspeciesDraftTitle = 'Editar subespecie';
  static const newSubspeciesVariantTitle = 'Nueva subespecie';
  static const subspeciesPhotoLabel = 'Fotografía de la subespecie';
  static const nameOrVariantLabel = 'Nombre';
  static const nameOrVariantHint = 'Nombre';
  static const brandHint = 'Marca';
  static const barcodeHint = 'Código de barras';
  static const editSpeciesTitle = 'Editar especie';
  static const createSpeciesTitle = 'Crear nueva especie';
  static const noTemplate = 'Sin plantilla';
  static const selectBaseSpeciesPrompt = 'Seleccionar especie base';
  static const useSpeciesAsBaseTemplate = 'Usar especie como plantilla base';
  static const selectBaseTemplateHint = 'Seleccionar plantilla...';
  static const nameIsImmutable = 'El nombre no se puede modificar.';
  static const unitsAndMagnitudesTitle = 'Unidades de medida';
  static const addUnitAction = 'Agregar medida';
  static const noAdditionalUnitsAdded = 'No se han agregado unidades adicionales.';
  static const removeUnitAction = 'Eliminar unidad de medida';
  static const subspeciesOrBrands = 'Subespecies';
  static const addBrandAction = 'Agregar subespecie';
  static const noSubspeciesOrBrandsAdded = 'No se han agregado subespecies.';
  static const noBarcode = 'Sin código de barras';
  static const chooseFromCatalogAction = 'Elegir del catálogo';
  static const createNewSpeciesAction = 'Crear nueva especie';
  static const createFirstSpeciesAction = 'Crear la primera especie';
  static const cannotDeleteOnlySubspecies = 'No se puede eliminar la única subespecie de una especie.';
  static const cannotDeleteOnlySubspeciesTooltip = 'No se puede eliminar la única subespecie.';
  static const subspeciesLabel = 'Subespecie:';
  static const otherUnassignedInstances = 'Otras instancias sin subespecie';

  // Ubicaciones y grafo jerárquico
  static const locationsGraphTitle = 'Ubicaciones';
  static const newLocationTitle = 'Nueva ubicación';
  static const newSubLocationTitle = 'Nueva sububicación';
  static const childLocationsTitle = 'Sububicaciones';
  static const createNodeHeader = 'Crear ubicación';
  static const locationNameLabel = 'Nombre de la ubicación';
  static const locationDescriptionLabel = 'Descripción de la ubicación';
  static const createObjectHere = 'Instanciar aquí';
  static const storedObjectsTitle = 'Instancias almacenadas aquí';
  static const emptyLocation = 'Esta ubicación está vacía.';
  static const selectLocationPrompt = 'Seleccionar ubicación';
  static const locationHasNoObjectsOrSublocations = 'Esta ubicación está vacía.';
  static const containerLabel = 'Contenedor';
  static const cannotMoveLocationSelfError = 'La ubicación de destino no es válida.';
  static const circularLocationError = 'La ubicación de destino no es válida.';
  static const instantiateObjectHere = 'Instanciar objeto aquí';
  static const treeView = 'Vista de árbol';
  static const graphView = 'Vista de grafo';
  static const previousLocation = 'Ubicación anterior';
  static const newGraphLocation = 'Nueva ubicación en el grafo';
  static const movedSuccessfullyGraph = 'trasladado correctamente en el grafo.';
  static const moveErrorPrefix = 'Error al trasladar: ';
  static const moveInGraph = 'Trasladar en el grafo';
  static const selectNewLocationOrContainer = 'Selecciona la nueva ubicación o contenedor:';
  static const createLocationOnTheFly = 'Crear nueva ubicación';
  static const locationNameHint = 'Nombre de la ubicación';
  static const confirmMoveAction = 'Confirmar traslado';
  static const locationGraphNode = 'Ubicación en el grafo';

  // Detalle, archivos y confirmaciones
  static const masterDescription = 'Descripción maestra';
  static const attachmentsTitle = 'Archivos y documentos adjuntos';
  static const emptyAttachments = 'No hay archivos adjuntos.';
  static const deleteConfirmationTitle = 'Eliminar elemento';
  static const deleteConfirmationMessage = '¿Deseas eliminar este elemento del mundo?';
  static const convertToContainerTitle = '¿Convertir en contenedor?';
  static String convertToContainerMessage(String name, int count) =>
      count == 1
          ? '¿Deseas guardar 1 elemento dentro de "$name" y convertirlo en un nuevo contenedor?'
          : '¿Deseas guardar $count elementos dentro de "$name" y convertirlo en un nuevo contenedor?';
  static const moveToWorldConfirmationTitle = '¿Mover al mundo?';
  static String moveToWorldConfirmationMessage(int count) =>
      count == 1
          ? 'El elemento seleccionado dejará de pertenecer a su ubicación o contenedor actual y pasará al mundo raíz sin ubicación específica. ¿Deseas continuar?'
          : 'Los $count elementos seleccionados dejarán de pertenecer a su ubicación o contenedor actual y pasarán al mundo raíz sin ubicación específica. ¿Deseas continuar?';
  static const zeroQuantityMessage = 'La magnitud llegó a cero. ¿Deseas eliminar la instancia?';
  static const mustProvideEntityOrGroup = 'Debe proporcionarse una entidad o grupo.';
  static const photoNotAvailable = 'Fotografía no disponible.';
  static const instanceUpdatedSuccess = 'Instancia actualizada correctamente.';
  static const updateErrorPrefix = 'Error al actualizar: ';
  static const instantiatedObject = 'Objeto instanciado';
  static const graphLocationOrContainer = 'Ubicación o contenedor';
  static const instanceNotesLabel = 'Notas';
  static const specificDetailsHint = 'Detalles';

  // Unidades y categorías de medida
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

  // Servicio de almacenamiento local
  static const fileNotFoundInStorage = 'Archivo no encontrado en el almacenamiento local.';
  static const fileDeleteFailure = 'Error al eliminar el archivo local.';

  // Requisitos y dependencias
  static const requirementsTitle = 'Relaciones de necesidad';
  static const addRequirement = 'Agregar requisito';
  static const addRequirementTitle = 'Agregar requisito';
  static const noRequirements = 'No hay requisitos registrados.';
  static const noRequirementsDefined = 'No hay requisitos definidos.';
  static const noCatalogSpeciesForRequirement = 'No hay especies disponibles en el catálogo para requerir.';
  static const selectRequiredSpeciesPrompt = 'Selecciona la especie requerida e indica la cantidad:';
  static const requiredSpeciesLabel = 'Especie requerida';
  static const requirementTypeLabel = 'Tipo de requisito';
  static const requirementTargetLabel = 'Elemento requerido';
  static const quantityRequiredLabel = 'Cantidad requerida';
  static const quantityRequiredHint = 'Cantidad';
  static const requirementNotesLabel = 'Notas del requisito';
  static const notesOptionalLabel = 'Notas';
  static const notesRequirementHint = 'Notas';
  static const needsPrefix = 'Necesita';

  // Atributos y plantillas personalizadas
  static const customAttributesTitle = 'Atributos personalizados';
  static const noCustomAttributesDefined = 'No hay atributos personalizados definidos.';
  static const addAttributeTitle = 'Agregar atributo';
  static const attributeNameHint = 'Nombre del atributo';
  static const attributeValueHint = 'Valor';
  static const templateCustomCreate = 'Crear plantilla personalizada';
  static const templateNameLabel = 'Nombre de la plantilla';
  static const templateExamplesHint = 'Nombre de la plantilla';
  static const templateUnitsHintLabel = 'Unidades habituales separadas por coma';
  static const templateUnitsExamples = 'Unidades';
  static const saveTemplateAction = 'Guardar plantilla';
  static const customAttributeEditorTitle = 'Editor de atributo personalizado';
  static const attributeNameLabel = 'Nombre del atributo';
  static const attributeTypeLabel = 'Tipo de dato';
  static const attributeValueLabel = 'Valor';
  static const templateSavedSuccess = 'Plantilla guardada correctamente.';

  // Entidades, demografía y grupos
  static const noEntitiesRegistered = 'No hay objetos registrados.';
  static const instanceWorldHeader = 'Instancia del mundo';
  static const addInstanceNotesHint = 'Agregar notas sobre esta instancia...';
  static const majorityDemographics = 'Demografía mayoritaria';
  static const standardSpeciesProfile = 'Perfil estándar de la especie';
  static const dynamicPopulationManagement = 'Gestión dinámica de población';
  static const populationManagementInstruction = 'Ajusta la población con los botones o ingresando la cifra directamente.';
  static const populationLabel = 'Población';
  static const groupInstanceDetail = 'Detalle de instancias en grupo';
  static const noInstancesAvailableToDelete = 'No hay instancias disponibles para eliminar.';
  static const addByWheelTitle = 'Agregar con selector';
  static const removeByWheelTitle = 'Eliminar con selector';
  static const directPopulationAdjustmentTitle = 'Ajuste directo de población';
  static const currentPopulationLabel = 'Población actual';
  static const newTargetPopulationLabel = 'Nueva población objetivo';
  static const applyCalculationAction = 'Aplicar cálculo';
  static const noChangesLabel = 'Sin cambios';
  static const noInstancesToDelete = 'No hay instancias disponibles para eliminar.';
  static const addByWheel = 'Agregar con selector';
  static const removeByWheel = 'Eliminar con selector';
  static const noChanges = 'Sin cambios';
  static const directPopulationAdjustment = 'Ajuste directo de población';
  static const currentPopulation = 'Población actual:';
  static const newTargetPopulation = 'Nueva población objetivo';
  static const targetPopulationHint = 'Población';
  static const applyCalculation = 'Aplicar cálculo';

  // Relaciones y grafo semántico
  static const selectTargetEntityError = 'Selecciona una entidad de destino.';
  static const selectDirectedRelationTypePrompt = 'Seleccionar tipo de relación dirigida';
  static const directedRelationTypeLabel = 'Tipo de relación dirigida';
  static const searchTargetEntityLabel = 'Buscar entidad de destino';
  static const noEntitiesAvailableToRelate = 'No hay entidades disponibles para relacionar.';
  static const createDirectedRelationAction = 'Crear relación dirigida';
  static const circularRelationError = 'No se pueden crear vínculos circulares.';
  static const selectElementToRelate = 'Selecciona el elemento por relacionar';
  static const directedRelationCreatedSuccess = 'Relación dirigida creada correctamente.';
  static const saveRelationErrorPrefix = 'Error al guardar la relación: ';
  static const sourceObjectLabel = 'Objeto de origen';
  static const directedRelationInWorld = 'Relación dirigida en el mundo';
  static const semanticRelationType = 'Tipo de vínculo semántico';
  static const targetOfRelation = 'Destino del vínculo:';
  static const noOtherRelationCandidates = 'No hay otros elementos disponibles para relacionar.';
  static const selectTargetElement = 'Selecciona el elemento de destino';
  static const targetObjectLabel = 'Objeto de destino';
  static const establishDirectedRelation = 'Establecer vínculo dirigido';
  static const selectTargetEntity = 'Selecciona una entidad de destino.';
  static const selectDirectedRelationType = 'Seleccionar tipo de relación dirigida';
  static const searchTargetEntity = 'Buscar entidad de destino';
  static const targetInstanceLabel = 'Instancia de destino';
  static const createDirectedRelation = 'Crear relación dirigida';
  static const interactiveRelationGraph = 'Grafo interactivo de relaciones';
  static const interactiveRelationsGraphTitle = 'Grafo interactivo de relaciones';
  static const noDirectedRelations = 'No hay relaciones dirigidas registradas.';
  static const noDirectedRelationsRegistered = 'No hay relaciones dirigidas registradas.';
  static const currentInstance = 'Instancia actual';
  static const currentInstanceLabel = 'Instancia actual';
  static const externalEntity = 'Entidad externa';
  static const sourceEntity = 'Entidad de origen';
  static const sourceEntityLabel = 'Entidad de origen';
  static const targetEntity = 'Entidad de destino';
  static const targetEntityLabel = 'Entidad de destino';
  static const deleteRelation = 'Eliminar relación';
  static const deleteRelationTooltip = 'Eliminar relación';
  static const loadRelationsErrorPrefix = 'Error al cargar relaciones: ';
  static const relationsLoadErrorPrefix = 'Error al cargar relaciones: ';
  static const centralInstancePrefix = 'Instancia central: ';
  static const centralInstanceLabel = 'Instancia central';

  // Historial de actividad
  static const logRegistered = 'Registrado en el mundo:';
  static const logEdited = 'Editado';
  static const logEditedInfo = 'Información editada de';
  static const logDeleted = 'Eliminado del mundo:';
  static const logMoved = 'Trasladado';
  static const logFrom = 'de';
  static const logTo = 'a';
  static const logFileAttached = 'Archivo adjuntado';
  static const logFileDeleted = 'Archivo eliminado';
  static const logRelationEstablished = 'Vínculo establecido:';
  static const logRelationDeleted = 'Vínculo eliminado:';
  static const logPhotoUpdated = 'Fotografía principal actualizada de';
  static const logPhotoDeleted = 'Fotografía principal eliminada de';
  static const logQuantityAdjusted = 'Cantidad ajustada de';
  static const noActivityRegistered = 'No hay actividad registrada.';

  // Pantalla de búsqueda
  static const objectsCategory = 'Objetos';
  static const historyCategory = 'Historial';
  static const noHistoryResults = 'No se encontraron resultados en el historial.';

  // Notificaciones y recordatorios
  static const notificationsAndRemindersTitle = 'Notificaciones y recordatorios';
  static const refreshAction = 'Actualizar';
  static const noPendingNotifications = 'No hay notificaciones pendientes.';
  static const allElementsUpToDate = 'Todos los elementos están al día y los requisitos cubiertos.';
  static const loadNotificationsErrorPrefix = 'Error al cargar notificaciones: ';
  static const snoozeReminderTitle = 'Posponer recordatorio';
  static const snoozeReminderPrompt = 'Selecciona la duración para posponer este aviso:';
  static const snoozeOneDay = 'Posponer 1 día';
  static const snoozeThreeDays = 'Posponer 3 días';
  static const snoozeOneWeek = 'Posponer 1 semana';
  static const snoozeAction = 'Posponer';
  static const dismissAction = 'Descartar';
  static const expiredItemTitle = 'Elemento caducado';
  static const expiringSoonTitle = 'Caducidad próxima';
  static const unsatisfiedNeedTitle = 'Requisito no cubierto';

  // Formularios de subespecie y edición
  static const searchPhotoOnWebAction = 'Buscar imagen en la web';
  static const brandOptionalLabel = 'Marca';
  static const barcodeOptionalLabel = 'Código de barras';
  static const variantNotesOptionalLabel = 'Notas de la variante';
  static const cannotDeleteSpeciesWithInstancesError = 'No se puede eliminar una especie con instancias registradas.';
  static const expirationDateLabel = 'Fecha de caducidad';
  static const noExpirationDateAssigned = 'Sin fecha asignada';
  static const expiredDaysAgoPrefix = 'Vencido hace ';
  static const expiredDaysAgoSuffix = ' días';
  static const expiresInDaysAlertPrefix = 'Vence en ';
  static const expiresInDaysAlertSuffix = ' días';
  static const expiresInDaysPrefix = 'Vence en ';
  static const expiresInDaysSuffix = ' días';
  static const objectsInLocationAndSublocationsSuffix = ' objetos contenidos';
  static const moveSubspeciesTitle = 'Trasladar subespecie';
  static const targetSpeciesLabel = 'Nueva especie de destino';
  static const subspeciesMovedSuccessPrefix = 'Subespecie trasladada a ';
  static const moveSubspeciesErrorPrefix = 'Error al trasladar la subespecie: ';
  static const associatedSpeciesLabel = 'Especie asociada:';
  static const separateAction = 'Separar';
  static const subspeciesSeparatedSuccessPrefix = 'Subespecie separada en la especie ';
  static const separateSubspeciesErrorPrefix = 'Error al separar la subespecie: ';
  static const noOtherSpeciesToMoveError = 'No hay otras especies disponibles para trasladar.';
  static const noOtherSpeciesToMergeError = 'No hay otras especies disponibles para fusionar.';
  static const mergeSpeciesTitle = 'Unir especies';
  static const mergeSpeciesAction = 'Unir especies';
  static const speciesMergedSuccessPrefix = 'Especie "';
  static const speciesMergedSuccessMiddle = '" unida correctamente en "';
  static const separateInNewSpeciesTitle = 'Separar en nueva especie';
  static const splitSubspeciesAction = 'Dividir subespecie';
  static const splitSubspeciesTitle = 'Dividir subespecie';
  static const splitSubspeciesSuccessPrefix = 'Subespecie "';
  static const splitSubspeciesSuccessMiddle = '" creada correctamente, con ';
  static const splitSubspeciesSuccessSuffix = ' instancias transferidas.';
  static const splitSubspeciesErrorPrefix = 'Error al dividir la subespecie: ';
  static const noInstancesToTransferNotice = 'Esta subespecie no tiene instancias asociadas. Se creará la nueva subespecie sin transferir instancias.';
  static const selectAllAction = 'Seleccionar todas';
  static const deselectAllAction = 'Deseleccionar todas';
  static const confirmAndRegisterPieceAction = 'Confirmar y registrar pieza';
  static const fileAttachedToSpeciesPrefix = 'Archivo "';
  static const fileAttachedToSpeciesSuffix = '" adjuntado a la especie.';
  static const addPropertyOrMagnitudeTitle = 'Agregar propiedad o magnitud';
  static const primitiveDataTypeLabel = 'Tipo de dato:';
  static const presetNamePropertyLabel = 'Habilitar nombre para instancias';
  static const presetNamePropertyDescription = 'Permite asignar un nombre o apodo individual a cada instancia creada.';
  static const instanceNameOptionalLabel = 'Nombre opcional';
  static const instanceNameHint = 'Ejemplo: Mi objeto favorito o Reloj del abuelo.';
  static const propertyNameNombre = 'Nombre';
  static const enterNameForImageSearchError = 'Ingresa un nombre para buscar la imagen.';

  static const instanceSpecificAttachment = 'Adjunto propio de la instancia';
  static const coinCircularLabel = 'Moneda';
  static const banknoteRectangleLabel = 'Billete';
  static const webImageAssignedSuccess = 'Imagen de internet asignada correctamente.';
  static const noWebImagesFound = 'No se encontraron imágenes en internet.';
  static const assignPhotoAction = 'Asignar fotografía';

  // Configuración de respaldos y base de datos
  static const backupExportSuccess = 'Copia de seguridad preparada y compartida.';
  static const backupExportErrorPrefix = 'Error al exportar la copia de seguridad: ';
  static const confirmRestoreTitle = 'Confirmar restauración';
  static const confirmRestoreWarningMessage = 'Importar una copia de seguridad reemplazará los datos actuales del mundo. ¿Deseas continuar?';
  static const restoreAllAction = 'Restaurar todo';
  static const backupImportSuccess = 'Copia de seguridad y archivos multimedia restaurados correctamente.';
  static const backupImportErrorPrefix = 'Error al importar la copia de seguridad: ';
  static const backupsAndDatabaseTitle = 'Copias de seguridad y base de datos';
  static const exportBackupTitle = 'Exportar copia de seguridad';
  static const exportBackupSubtitle = 'Genera un archivo comprimido con los datos del mundo.';
  static const importBackupTitle = 'Importar copia de seguridad';
  static const importBackupSubtitle = 'Restaura el mundo a partir de un archivo de copia de seguridad.';
  static const restoringBackupDialogTitle = 'Restaurando copia de seguridad...';
  static const restoringBackupDialogMessage = 'Por favor, espera. Se están importando los datos y los archivos multimedia.';

  // Excepciones e infraestructura de catálogo
  static const genericSubspeciesName = 'Genérica';
  static const subspeciesNotFoundError = 'Subespecie no encontrada.';
  static const speciesNotFoundError = 'Especie no encontrada.';
  static const separatedFromSpeciesPrefix = 'Separada de ';
  static const cannotDeleteSubspeciesWithInstancesError = 'No se puede eliminar una subespecie que tiene instancias registradas en el mundo.';
  static const noSubspeciesWarningTitle = 'Sin subespecies';
  static const noSubspeciesWarningMessage = 'No se agregaron subespecies a la especie. Se creará automáticamente la subespecie "Genérica". ¿Deseas continuar?';

  // Notificaciones y canales
  static const defaultItemName = 'Elemento';
  static const expiredNotificationMessagePrefix = '"';
  static const expiredNotificationMessageSuffix = '" ha caducado, con fecha de vencimiento: ';
  static const expiringSoonNotificationMessagePrefix = '"';
  static const expiringSoonNotificationMessageMiddle = '" caducará en ';
  static const expiringSoonNotificationMessageSuffix = ' días, con fecha de vencimiento: ';
  static const unsatisfiedNeedNotificationMessagePrefix = 'Faltan ';
  static const unsatisfiedNeedNotificationMessageMiddle = ' unidades de "';
  static const unsatisfiedNeedNotificationMessageSuffix = '" para cubrir los requisitos totales, disponibles: ';
  static const notificationChannelName = 'Notificaciones de PWMS';
  static const notificationChannelDescription = 'Notificaciones de caducidad y requisitos no cubiertos.';

  // Propiedades numismáticas y notas
  static const numismaticSpeciesDescriptionPrefix = 'Especie para piezas numismáticas de tipo ';
  static const nominalValuePropertyName = 'Valor nominal';
  static const mintagePropertyName = 'Acuñación';
  static const currencyPropertyName = 'Divisa';
  static const materialPropertyName = 'Material';
  static const gradePropertyName = 'Grado';
  static const issuerPropertyName = 'Emisor';
  static const motifPropertyName = 'Motivo';
  static const motifLabel = 'Motivo de la emisión';
  static const selectMotifPrompt = 'Selecciona el motivo conmemorativo';
  static const customMotifOption = 'Motivo personalizado...';
  static const currencyNotePrefix = 'Moneda: ';
  static const yearNotePrefix = 'Año: ';
  static const materialNotePrefix = 'Material: ';
  static const otherSpecifyOption = 'Otro';

  // Tipos de datos primitivos
  static const dataTypeRealLabel = 'Número decimal';
  static const dataTypeIntegerLabel = 'Número entero';
  static const dataTypeStringLabel = 'Texto';
  static const dataTypeBooleanLabel = 'Booleano';

  // Catálogo y escáner
  static const defaultNonPerishableSubtitle = 'Por defecto los objetos son no perecederos.';
  static const isPerishableProductTitle = 'Producto perecedero';
  static const invalidOrNotFoundCodeTitle = 'Código no encontrado';
  static const invalidOrNotFoundCodeMessagePrefix = 'El código de barras "';
  static const invalidOrNotFoundCodeMessageSuffix = '" no se encontró en las bases de datos en línea.';
  static const enterBarcodePrompt = 'Ingresa un código de barras.';
  static const acceptAction = 'Aceptar';

  // Búsqueda y consola SQL
  static const arbitrarySqlConsoleTitle = 'Consola SQL';
  static const searchDetailedHint = 'Buscar por especie, subespecie, marca, ubicación o propiedad...';
  static const arbitrarySqlQueryLabel = 'Consulta SQL';
  static const selectSqlHint = 'SELECT * FROM ...';
  static const subspeciesCategory = 'Subespecies';
  static const instanceMagnitudesCategory = 'Magnitudes de la instancia';
  static const containersCategory = 'Contenedores';
  static const executeAction = 'Ejecutar';
  static const rowsRetrievedPrefix = 'Filas obtenidas: ';
  static const selectSearchScopePrompt = 'Seleccionar ámbito de búsqueda';
  static const searchScopePrefix = 'Ámbito: ';
  static const sqlPresetsSelectPrompt = 'Seleccionar consulta predefinida';
  static const sqlCategorySelectPrompt = 'Seleccionar categoría de consulta';
  static const openSqlEditorAction = 'Abrir editor SQL';
  static const executeSqlAction = 'Ejecutar consulta SQL';
  static const editQueryAction = 'Editar consulta';
  static const fullScreenSqlEditorTitle = 'Editor de consulta SQL';
  static const sqlQueryPreviewLabel = 'Consulta SQL activa:';
  static const sqlCodeEditorHint = 'Escribe la consulta SQL de lectura aquí...';
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
  static const sectionCatalog = 'Catálogo de especies y subespecies';
  static const sectionLocations = 'Ubicaciones';
  static const sectionHistory = 'Historial de actividad';
  static const sectionContainers = 'Contenedores';
  static const filterByType = 'Tipo';
  static String filterByTypeWithValue(String type) => '$filterByType: $type';
  static const filterByCategory = 'Categoría';
  static const filterByDate = 'Fecha';
  static const customDateRange = 'Rango personalizado';
  static const clearFilterAction = 'Limpiar filtro';
  static const searchResultsCount = 'Resultados encontrados';
  static const noSubspeciesFound = 'No se encontraron subespecies coincidentes.';

  // Categorías de consultas SQL predefinidas
  static const sqlCategoryAll = 'Todas';
  static const sqlCategoryTables = 'Tablas';
  static const sqlCategoryContainers = 'Contenedores';
  static const sqlCategoryAudit = 'Auditoría';
  static const sqlCategoryExpirationMagnitudes = 'Caducidad y magnitudes';

  // Modos de vista y badges
  static const viewModeTable = 'Tabla';
  static const viewModeTiles = 'Tarjetas';
  static const tabContainers = 'Contenedores';
  static const badgeContainer = 'Contenedor';
  static const badgeOrphan = 'Sin ubicación';
  static const badgeLocationConflict = 'Conflicto de ubicación';
  static const badgeMissingExpiration = 'Sin fecha de caducidad';
  static const emptyContainersSearch = 'No se encontraron objetos contenedores en el mundo.';
  static const containedItemsCountSuffix = ' elementos';
  static const containedItemCountSingle = '1 elemento';

  // Consultas SQL predefinidas
  static const sqlPresetInstances = 'Instancias';
  static const sqlPresetContainedItems = 'Elementos guardados';
  static const sqlPresetNonContainedItems = 'Elementos no guardados';
  static const sqlPresetNonContainedWithContainedSpecies = 'Elementos no guardados con especie en contenedor';
  static const sqlPresetContainedWithNonContainedSpecies = 'Elementos guardados con especie fuera de contenedor';
  static const sqlPresetOrphanEntities = 'Instancias sin ubicación';
  static const sqlPresetLocationConflict = 'Conflicto de ubicación';
  static const sqlPresetSelfReferencingRelations = 'Autorreferencias';
  static const sqlPresetMutualContainment = 'Contención mutua';
  static const sqlPresetUniquenessViolation = 'Inconsistencia de unicidad';
  static const sqlPresetUninstantiatedSpecies = 'Especies sin instancias';
  static const sqlPresetUninstantiatedSubspecies = 'Subespecies sin instancias';
  static const sqlPresetSubgroupRuleViolation = 'Entidades no objetuales con marca o código';
  static const sqlPresetExpiredEntities = 'Instancias caducadas';
  static const sqlPresetPerishableMissingExpiration = 'Perecederos sin fecha de caducidad';
  static const sqlPresetNonPerishableWithExpiration = 'No perecederos con fecha de caducidad';
  static const sqlPresetAnomalousMagnitudes = 'Magnitudes menores o iguales a cero';
  static const sqlPresetMissingMandatoryMagnitudes = 'Magnitudes obligatorias faltantes';

  // Propiedades de entidades
  static const editPropertyTitlePrefix = 'Editar propiedad "';
  static const instanceHasAllPropertiesMessage = 'Esta instancia ya posee todas las propiedades definidas por la especie.';
  static const addSpeciesPropertyTitle = 'Agregar propiedad de especie';
  static const addPropertyAction = 'Agregar propiedad';
  static const noPropertiesAssignedToInstance = 'No hay propiedades asignadas a esta instancia.';

  // Registro numismático y hojas
  static const numismaticsCategory = 'Numismática';
  static const pieceInstantiatedDirectlyPrefix = 'Pieza "';
  static const pieceInstantiatedDirectlySuffix = '" instanciada directamente.';
  static const materialPureFineness = 'Puro .999';
  static String materialLeyFineness(int thousandths) => 'Ley .$thousandths';
  static const materialPillBimetallic = 'Bimetálica';
  static const materialPillTrimetallic = 'Trimetálica';
  static const materialPillPlated = 'Bañada';
  static const materialPillClad = 'Revestida';
  static const materialPillPolymer = 'Polímero';
  static const materialPillPaper = 'Papel';
  static String materialPurityTooltip(String pct, double fineness) => 'Pureza de $pct%, con ley de $fineness.';
  static String materialAlloyTooltip(String alloy) => 'Composición: $alloy.';
  static String materialBimetallicTooltip(String core, String ring) => 'Centro: $core\nAnillo: $ring.';
  static String materialPlatedTooltip(String plating) => 'Recubrimiento: $plating.';

  // Gestión de población y caducidad
  static const heterogeneousGroupQuantityError = 'No se puede modificar la cantidad en grupos heterogéneos.';
  static const heterogeneousGroupQuickAdjustmentError = 'No se pueden realizar ajustes rápidos en grupos heterogéneos.';
  static const expirationDateForNewInstancePrompt = 'Fecha de caducidad para la nueva instancia';
  static const expirationDateForNewInstancesPrompt = 'Fecha de caducidad para las nuevas instancias';
  static const adjustQuantityTitle = 'Ajustar cantidad';
  static const newTotalQuantityLabel = 'Nueva cantidad total';
  static const deleteGroupTitle = 'Eliminar grupo';
  static const confirmDeleteGroupMessage = '¿Deseas reducir la cantidad a cero y eliminar todas las instancias de este grupo?';
  static const instancesDeletedSuccess = 'Instancias eliminadas correctamente.';
  static const selectExpirationDateForNewInstancesPrompt = 'Selecciona la fecha de caducidad de las nuevas instancias.';
  static const populationUpdatedSuccessPrefix = 'Población actualizada correctamente a ';
  static const adjustPopulationErrorPrefix = 'Error al ajustar la población: ';
  static const adjustmentNotAvailableTitle = 'Ajuste no disponible';
  static const heterogeneousGroupAdjustmentMessage = 'No es posible ajustar la población en grupos heterogéneos. Abre la vista de grupo para gestionar las instancias.';
  static const understoodAction = 'Entendido';
  static const adjustPopulationTitle = 'Ajustar población';
  static const homogeneousGroupHeaderPrefix = 'Grupo homogéneo de ';
  static const homogeneousGroupHeaderSuffix = ' elementos actuales';
  static const variedSubspeciesLabel = 'Subespecies variadas';
  static const statusExpired = 'Caducado';
  static const statusWarning = 'Próximo a vencer';
  static const generalSpeciesPrefix = 'Especie general: ';
  static const expirationDateOptionalLabel = 'Fecha de caducidad';
  static const noExpirationDate = 'Sin fecha de caducidad';
  static const removeExpirationDateTooltip = 'Quitar fecha de caducidad';
  static const noInstancesAvailableInGroup = 'No hay instancias disponibles en este grupo.';
  static const totalPopulationPrefix = 'Población total: ';
  static const homogeneousGroupProperties = 'Grupo homogéneo';
  static const heterogeneousGroupDescription = 'Grupo heterogéneo';
  static const deleteInstanceTitle = 'Eliminar instancia';
  static const deleteInstanceConfirmationMessage = '¿Deseas eliminar esta instancia del mundo?';

  // Constantes adicionales de infraestructura y formularios
  static const instancePropertiesAndMagnitudesTitle = 'Propiedades y magnitudes de la instancia';
  static const rootLocationLabel = 'Mundo';
  static const sqlHelpHint = 'Escribe una consulta SQL de lectura para inspeccionar la base de datos local.';
  static const sqlNoRowsReturned = 'La consulta se ejecutó correctamente, pero no devolvió registros.';
  static const sqlSecurityErrorPrefix = 'Por seguridad, las consultas SQL están restringidas exclusivamente a operaciones de lectura. El comando "';
  static const sqlSecurityErrorSuffix = '" no está permitido.';
  static const sqlSyntaxErrorPrefix = 'Error de sintaxis o ejecución en la consulta SQL: ';
  static const applyCorrectionAction = 'Aplicar corrección';
  static const applyRecommendedCorrectionQuestion = '¿Deseas aplicar la corrección recomendada?';
  static String applyRecommendedCorrectionWithValue(String label, String value) =>
      '¿Deseas aplicar la corrección recomendada?\n$label: «$value»';
  /// "Corregir [property] de [from] a [to]" — used when there is exactly one expected value.
  static String correctFromTo(String property, String from, String to) =>
      'Corregir $property de «$from» a «$to»';
  /// "Corregir [property] de [from] a uno válido" — used when multiple valid values exist.
  static String correctFromToValid(String property, String from) =>
      'Corregir $property de «$from» a uno válido';
  static const savingAction = 'Guardando...';
  static const linksCountSuffix = ' vínculos';
  static const noSearchMatchesPrefix = 'No se encontraron coincidencias para "';
  static const noSearchMatchesSuffix = '"';

  // Constantes adicionales de sistema y notificaciones
  static const directedRelationInWorldTitle = 'Relación dirigida en el mundo';
  static const relationCreatedSuccessPrefix = 'Relación "';
  static const relationCreatedSuccessSuffix = '" creada correctamente.';
  static const movedSuccessfullyInGraphPrefix = '"';
  static const movedSuccessfullyInGraphSuffix = '" trasladado correctamente en el grafo.';
  static const correctLocationTitlePrefix = 'Corregir ubicación de "';
  static const correctLocationTitleSuffix = '"';
  static const notificationInitErrorPrefix = 'Error en la inicialización de notificaciones: ';

  // Constantes de interfaz, pantalla principal y herramientas
  static const controlCenterTooltip = 'Centro de control';
  static const settingsTooltip = 'Configuración de la aplicación y copias de seguridad';
  static const notificationsTooltip = 'Notificaciones y recordatorios';
  static const allLocationsOption = 'Todas las ubicaciones';
  static const itemsMovedSuccess = 'Elementos trasladados correctamente.';
  static const itemsSavedInContainerSuccess = 'Elementos guardados en el contenedor correctamente.';
  static const deleteSelectionTitle = 'Eliminar selección';
  static const deleteSelectionConfirmationPrefix = '¿Deseas eliminar ';
  static const deleteSelectionConfirmationSuffix = ' elementos seleccionados?';
  static const itemsDeletedSuccess = 'Elementos eliminados correctamente.';
  static const toggleViewModeTooltip = 'Cambiar vista';
  static const cancelSelectionTooltip = 'Cancelar selección';
  static const multipleSelectionTooltip = 'Selección múltiple';
  static const globalSettingsTitle = 'Configuración global';
  static const backupManagementTitle = 'Gestión de copias de seguridad locales';
  static const backupManagementSubtitle = 'Exporta o restaura la base de datos completa del mundo.';
  static const selectValidContainerPrompt = 'Selecciona un objeto contenedor válido.';
  static const locationCorrectedSuccess = 'Ubicación corregida correctamente.';
  static const locationCorrectionErrorPrefix = 'Error al corregir la ubicación: ';
  static const unknownLocation = 'Ubicación desconocida';
  static const activityLogRegisteredPrefix = 'Registrado en el mundo: "';
  static const activityLogEditedPrefix = 'Información editada de "';
  static const activityLogEditedInfoPrefix = 'Información editada de "';
  static const activityLogDeletedPrefix = 'Eliminado del mundo: "';
  static const activityLogMovedPrefix = 'Trasladado "';
  static const activityLogFromPrefix = '" de "';
  static const activityLogToPrefix = '" a "';

  // Servicio de actualizaciones
  static const softwareUpdatesTitle = 'Actualizaciones de la aplicación';
  static const softwareUpdatesSubtitle = 'Comprueba si existen nuevas versiones publicadas de PWMS.';
  static const checkForUpdatesTitle = 'Buscar actualizaciones';
  static const checkForUpdatesSubtitle = 'Verifica si existen nuevas versiones disponibles.';
  static const updateAvailableTitle = 'Actualización disponible';
  static const updateAvailablePrompt = 'Existe una nueva versión de la aplicación disponible. ¿Deseas descargarla e instalarla ahora?';
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

  // Centro de control y auditorías de inventario
  static const controlCenterTitle = 'Centro de control y salud de datos';
  static const regenerateAuditsTooltip = 'Regenerar revisiones';
  static const dataHealthVerifiedTitle = 'Salud de datos totalmente verificada';
  static const dataHealthVerifiedSubtitle = 'No se detectaron anomalías ni inconsistencias en el inventario. El mundo está perfectamente estructurado.';
  static const runNewAuditAction = 'Realizar nueva auditoría';
  static const correctAction = 'Correcto';
  static const fixAction = 'Corregir';
  static const attachmentNameRetainedSuccess = 'Nombre del archivo adjunto mantenido.';
  static const attachmentRenamedSuccess = 'Archivo adjunto renombrado correctamente.';
  static const incompleteNumismaticMagnitudesTitle = 'Magnitudes numismáticas incompletas';
  static const magnitudesRetainedSuccess = 'Magnitudes mantenidas sin cambios.';
  static const numismaticMagnitudesAutoFilledSuccess = 'Magnitudes numismáticas autocompletadas correctamente.';
  static const emptyGradeDataTitle = 'Dato numismático vacío: grado de conservación';
  static const gradeRetainedEmptySuccess = 'Grado de conservación mantenido vacío.';
  static const assignGradeTitle = 'Asignar grado de conservación';
  static const controlCenterLoadErrorPrefix = 'Error al cargar tarjetas de control: ';
  static const uninstantiatedSubspeciesAuditTitle = 'Subespecie no instanciada en el mundo';
  static const uninstantiatedSpeciesAuditTitle = 'Especie no instanciada en el mundo';
  static const locationVerificationAuditTitle = 'Verificación de ubicación de la instancia';
  static const ownershipCheckAuditTitle = 'Control de pertenencia y contenedor';
  static const expirationAuditTitle = 'Auditoría de fecha de caducidad';
  static const orphanEntityAuditTitle = 'Instancia sin ubicación asignada';
  static const incompleteSpeciesInfoAuditTitle = 'Información de especie incompleta';
  static const remoteImageAuditTitle = 'Imágenes remotas sin descargar';
  static const numismaticSubspeciesIncongruityTitle = 'Incongruencia en la subespecie numismática';
  static const numismaticDuplicateSubspeciesTitle = 'Subespecie numismática duplicada';
  static const numismaticAttachmentIncongruityTitle = 'Incongruencia en el archivo adjunto numismático';
  static const numismaticMissingMagnitudesTitle = 'Magnitudes numismáticas faltantes';
  static const numismaticEmissionOutlierAuditTitle = 'Anomalía histórica en emisión numismática';
  static const emptyDataAuditTitle = 'Auditoría de datos vacíos';
  static const locationConflictAuditTitle = 'Conflicto de ubicación';
  static const cyclicContainmentAuditTitle = 'Contención cíclica detectada';
  static const uniquenessViolationAuditTitle = 'Inconsistencia de unicidad en especie';
  static const perishableMissingExpirationAuditTitle = 'Producto perecedero sin fecha de caducidad';
  static const nonPerishableWithExpirationAuditTitle = 'Producto no perecedero con fecha de caducidad';
  static const subgroupRuleViolationAuditTitle = 'Infracción de regla de subgrupo';
  static const missingMandatoryMagnitudesAuditTitle = 'Magnitudes obligatorias faltantes';
  static const anomalousMagnitudeAuditTitle = 'Magnitud anómala detectada';
  static const duplicateSpeciesAuditTitle = 'Especies homónimas duplicadas';
  static const duplicatePhotoAuditTitle = 'Fotografía compartida entre especies';
  static const speciesWithoutSubspeciesAuditTitle = 'Especie sin subespecies';
  static const unlinkedInstancesAuditTitle = 'Instancias desvinculadas';
  static const anomalousExpirationAuditTitle = 'Fecha de caducidad anómala';

  // Constantes de formularios numismáticos
  static const noSelectionPrompt = 'Sin selección';
  static const countryIssuerLabel = 'Emisor';
  static const selectCountryPrompt = 'Selecciona un emisor.';
  static const specifyCountryLabel = 'Especificar país o emisor';
  static const specifyCountryPrompt = 'Ingresa el país o emisor.';
  static const unspecifiedCountryLabel = 'País desconocido';
  static const denominationLabel = 'Denominación';
  static const selectDenominationPrompt = 'Selecciona una denominación.';
  static const denominationNumberLabel = 'Número de denominación';
  static const enterDenominationNumberPrompt = 'Ingresa el número de denominación.';
  static const enterValidNumericValuePrompt = 'Ingresa un valor numérico válido.';
  static const unspecifiedDenominationLabel = 'Sin denominación';
  static const mintageYearLabel = 'Año de emisión';
  static const enterMintageYearPrompt = 'Ingresa el año de emisión.';
  static const enterValidMintageYearPrompt = 'Ingresa un año válido.';
  static const unspecifiedYearLabel = 'Año desconocido';
  static const selectGradePrompt = 'Selecciona el estado de conservación.';
  static const specifyGradeLabel = 'Especificar conservación';
  static const specifyGradePrompt = 'Ingresa el estado de conservación.';
  static const unspecifiedGradeLabel = 'Conservación no calificada';
  static const selectMaterialPrompt = 'Selecciona el material o composición.';
  static const specifyMaterialLabel = 'Especificar material o composición';
  static const specifyMaterialPrompt = 'Ingresa el material o composición.';
  static const unspecifiedMaterialLabel = 'Material desconocido';
  static const numismaticDataTitlePrefix = 'Datos numismáticos: ';
  static const selectCurrencyPrompt = 'Selecciona una divisa.';
  static const specifyCurrencyLabel = 'Especificar divisa';
  static const specifyCurrencyPrompt = 'Ingresa la divisa.';
  static const unspecifiedCurrencyLabel = 'Sin divisa';

  // Confirmaciones y prevención de descarte de cambios
  static const unsavedChangesTitle = 'Cambios sin guardar';
  static const unsavedChangesMessage = 'Tienes modificaciones pendientes sin guardar. ¿Deseas descartar los cambios o continuar editando?';
  static const discardChangesAction = 'Descartar cambios';
  static const keepEditingAction = 'Continuar editando';
  static const confirmReplaceAttachmentTitle = 'Reemplazar archivo adjunto';
  static const confirmReplaceAttachmentMessage = '¿Deseas reemplazar este archivo adjunto? El archivo anterior será sustituido.';
  static const confirmDeleteSubspeciesTitle = 'Eliminar subespecie';
  static const confirmDeleteSubspeciesMessagePrefix = '¿Deseas eliminar permanentemente la subespecie "';
  static const confirmDeleteSubspeciesMessageSuffix = '"?';
  static const confirmDeleteRequirementTitle = 'Eliminar requisito';
  static const confirmDeleteRequirementMessagePrefix = '¿Deseas eliminar este requisito de "';
  static const confirmDeleteRequirementMessageSuffix = '"?';
  static const confirmDeleteRelationTitle = 'Eliminar relación';
  static const confirmDeleteRelationMessagePrefix = '¿Deseas eliminar la relación "';
  static const confirmDeleteRelationMessageMiddle = '" con "';
  static const confirmDeleteRelationMessageSuffix = '"?';
  static const confirmDeleteLocationTitle = 'Eliminar ubicación';
  static const confirmDeleteLocationMessagePrefix = '¿Deseas eliminar la ubicación "';
  static const confirmDeleteLocationMessageSuffix = '" y sus referencias asociadas?';
  static const confirmRemovePhotoTitle = 'Quitar fotografía';
  static const confirmRemovePhotoMessage = '¿Deseas eliminar la fotografía seleccionada?';
  static const confirmRemoveAttributeTitle = 'Eliminar atributo';
  static const confirmRemoveAttributeMessagePrefix = '¿Deseas eliminar el atributo personalizado "';
  static const confirmRemoveAttributeMessageSuffix = '"?';
  static const confirmDeletePropertyTitle = 'Eliminar propiedad';
  static const confirmDeletePropertyMessagePrefix = '¿Deseas eliminar la propiedad "';
  static const confirmDeletePropertyMessageSuffix = '"?';

  // Navegación y buscador
  static const goBackAction = 'Volver';
  static const createOrInstantiateAction = 'Crear o instanciar';
  static const moveSelectionAction = 'Trasladar selección';
  static const deleteSelectionAction = 'Eliminar selección';
  static const confirmDeleteSelectionTitle = 'Confirmar eliminación';
  static const viewAllLocationsAction = 'Ver todas';
  static String confirmDeleteSelectionPrompt(int count) =>
      count == 1 ? '¿Deseas eliminar 1 elemento?' : '¿Deseas eliminar $count elementos?';
  static String deleteElementsConfirmation(int count) =>
      count == 1 ? '¿Deseas eliminar 1 elemento seleccionado?' : '¿Deseas eliminar $count elementos seleccionados?';

  // Formateadores de errores
  static String formatError(Object err) => 'Error: $err.';

  // Operaciones de taxonomía
  static const mergeSpeciesDialogTitle = 'Unir especies';
  static const targetSpeciesFormLabel = 'Especie de destino';
  static const separateInNewSpeciesDialogTitle = 'Separar en nueva especie';
  static const newSpeciesNameFormLabel = 'Nombre de la nueva especie';
  static const splitSubspeciesDialogTitle = 'Dividir subespecie';

  // Gestión de adjuntos en vista detallada
  static const renameAttachmentTitle = 'Renombrar archivo adjunto';
  static const fileNameLabel = 'Nombre del archivo';
  static const replaceFileAction = 'Reemplazar archivo';
  static const renameAction = 'Renombrar';
  static const deleteAttachmentAction = 'Eliminar archivo adjunto';
  static const openAttachmentTooltip = 'Abrir archivo adjunto';
  static const openExternallyAction = 'Abrir externamente';
  static const openExternallyTooltip = 'Abrir con aplicación externa';
  static const shareAction = 'Compartir';
  static const shareAttachmentTooltip = 'Compartir archivo';
  static const attachmentOptionsTooltip = 'Opciones del archivo adjunto';
  static const moreOptionsTooltip = 'Más opciones';
  static const errorOpeningFilePrefix = 'Error al abrir archivo: ';
  static const errorSharingFilePrefix = 'Error al compartir archivo: ';
  static String replaceAttachmentTitle(String name) => 'Reemplazar archivo adjunto: $name';

  // Multimedia, escáner y llenado rápido
  static const shelfLifeDaysLabel = 'Vida útil en días';
  static const shelfLifeDaysHint = 'Ejemplo: 30';
  static const warningDaysLabel = 'Aviso previo en días';
  static const warningDaysHint = 'Ejemplo: 7';
  static const attachToSpeciesAction = 'Adjuntar a la especie';
  static const speciesPhotoTitle = 'Foto de la especie';
  static const subspeciesPhotoTitle = 'Foto de la subespecie o variante';
  static const standardCameraCapture = 'Captura estándar con la cámara';
  static const chooseFromGallery = 'Elegir imagen de la galería de fotos';
  static const searchWeb = 'Buscar en la web';
  static const fileExplorer = 'Explorador de archivos';
  static const selectPdfOrDocument = 'Seleccionar documento o archivo local';
  static const manualBarcodeHint = 'Código de barras manual...';
  static const productOrSpeciesSearchHint = 'Nombre del producto o de la especie...';
  static const coinObverse = 'Anverso';
  static const coinReverse = 'Reverso';
  static const completeAllFieldsPrompt = 'Completa todos los campos antes de guardar.';
  static const exampleDecimalHint = 'Ejemplo: 0.50';
  static const exampleYearHint = 'Ejemplo: 1982';

  // Reglas de auditoría y centro de control
  static const confirmSubspeciesTitle = 'Confirmar subespecie';
  static const keepAction = 'Mantener';
  static const deleteSubspeciesAction = 'Eliminar subespecie';
  static const resolveUniquenessTitle = 'Resolver unicidad';
  static const makeNonUniqueAction = 'Convertir a no única';
  static const deleteDuplicatesAction = 'Eliminar duplicados';
  static const whatActionForSpeciesPrompt = '¿Qué acción deseas realizar con esta especie?';
  static const createInstanceAction = 'Crear instancia';
  static const deleteSpeciesAction = 'Eliminar especie';
  static const relationalLocationConflictTitle = 'Conflicto de ubicación en contenedor';
  static const onlyInContainerAction = 'Solo en contenedor';
  static const onlyDirectLocationAction = 'Solo ubicación directa';
  static const reassignLocationAction = 'Reasignar';
  static const circularRelationTitle = 'Relación circular';
  static const deleteInvalidRelationAction = 'Eliminar relación no válida';
  static const keepThisObjectQuestion = '¿Conservas este objeto?';
  static const perishableWithoutExpirationTitle = 'Perecedero sin fecha de caducidad';
  static const nonPerishableWithExpirationTitle = 'No perecedero con fecha de caducidad';
  static const booleanFalseAction = 'No';
  static const booleanTrueAction = 'Sí';
  static const numismaticIncongruityTitle = 'Incongruencia en datos numismáticos';
  static const updateSubspeciesFromInstanceAction = 'Actualizar subespecie según la instancia';
  static const desyncedAttachmentNameTitle = 'Nombre de archivo adjunto desincronizado';
  static const mergeDuplicateSubspeciesAction = 'Fusionar subespecies duplicadas';

  static const uninstantiatedSubspeciesCardTitle = 'Subespecie sin instancia';
  static const uniqueSubspeciesDuplicatedTitle = 'Subespecie única duplicada';
  static const subgroupRuleViolationTitle = 'Infracción de regla de subgrupo';
  static const uninstantiatedSpeciesWorldTitle = 'Especie sin instancias en el mundo';
  static const incompleteSpeciesInfoTitle = 'Especie sin imagen principal';
  static const remoteSpeciesImageTitle = 'Imagen remota de la especie';
  static const remoteSubspeciesImageTitle = 'Imagen remota de la subespecie';
  static const orphanEntityTitle = 'Instancia sin ubicación ni contenedor';
  static const resolveLocationTitle = 'Resolver ubicación';
  static const correctInstanceTitle = 'Corregir instancia';
  static const deregisterInstanceTitle = 'Dar de baja instancia';
  static const haveYouMovedThisObjectQuestion = '¿Has trasladado este objeto?';
  static const selectExpirationDatePrompt = 'Selecciona la fecha de caducidad';
  static const anomalousMagnitudeCardTitle = 'Magnitud con valor no positivo';
  static const numismaticDuplicateSubspeciesCardTitle = 'Subespecies numismáticas duplicadas';
  static const numismaticEmissionOutlierCardTitle = 'Anomalía histórica numismática';
  static const numismaticEmissionOutlierSkipped = 'Anomalía histórica mantenida sin cambios.';
  static const numismaticEmissionOutlierFixedSuccess = 'Anomalía numismática corregida correctamente.';
  static const fixCorrectCurrencyAction = 'Corregir a divisa canónica';
  static const fixCorrectMaterialAction = 'Corregir a material canónico';
  static const fixSetMotifAction = 'Asignar motivo';
  static const fixCorrectYearAction = 'Corregir año de acuñación';
  static const fixPickDenominationAction = 'Seleccionar denominación válida';
  static const correctNumismaticIncongruityTitle = 'Corregir incongruencia numismática';
  static const invalidUnitSymbolTitle = 'Unidad de medida desconocida';
  static const integerUnitIncongruityTitle = 'Incongruencia de unidad entera';
  static const nonNumericWithUnitTitle = 'Unidad en propiedad no numérica';
  static const negativeMagnitudeViolationTitle = 'Valor numérico negativo no válido';
  static const propertyNameSuggestionIncongruityTitle = 'Nombre de propiedad sugerido';

  static const correctLocationOrContainerAction = 'Corregir ubicación o contenedor';
  static const selectLocationOrContainerPrompt = 'Seleccionar ubicación o contenedor';
  static const deleteFromInventoryAction = 'Eliminar del inventario';
  static const deregisterInstanceAction = 'Eliminar instancia';
  static const deleteRelationActionLabel = 'Eliminar relación';
  static const mergeAndReassignAction = 'Fusionar y reasignar';

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
  static const speciesSetToNotUniqueSuccess = 'Especie configurada como no única.';
  static const duplicatesDeletedPreservedOneSuccess = 'Instancias duplicadas eliminadas. Se conservó una instancia.';
  static const attributesSkipped = 'Atributos omitidos.';
  static const brandAndBarcodeRemovedSuccess = 'Marca y código de barras eliminados correctamente.';
  static const speciesKeptInCatalog = 'Especie conservada en el catálogo.';
  static const speciesDeletedFromCatalogSuccess = 'Especie eliminada del catálogo.';
  static const informationSkippedForNow = 'Información omitida por el momento.';
  static const remoteImageKeptWithoutDownload = 'Imagen remota conservada sin descargar.';
  static const locationKeptUnassigned = 'Ubicación mantenida como no asignada.';
  static const locationConflictSkipped = 'Conflicto de ubicación omitido.';
  static const directLocationRemovedKeptInContainerSuccess = 'Ubicación directa eliminada. Conservado en el contenedor.';
  static const elementRemovedFromContainerSuccess = 'Elemento retirado del contenedor.';
  static const circularRelationKept = 'Relación circular conservada.';
  static const conflictingRelationDeletedSuccess = 'Relación en conflicto eliminada.';
  static const instanceConfirmedInInventory = 'Instancia confirmada en el inventario.';
  static const instanceDeregisteredSuccess = 'Instancia dada de baja correctamente.';
  static const locationConfirmedSuccess = 'Ubicación confirmada.';
  static const expirationDateSkipped = 'Fecha de caducidad omitida.';
  static const expirationDateUpdatedSuccess = 'Fecha de caducidad actualizada correctamente.';
  static const expirationDateKept = 'Fecha de caducidad conservada.';
  static const expirationDateRemovedSuccess = 'Fecha de caducidad eliminada correctamente.';
  static const magnitudeSkipped = 'Magnitud omitida.';
  static const valueKept = 'Valor conservado.';
  static const duplicateSubspeciesKeptWithoutChanges = 'Subespecies duplicadas conservadas sin cambios.';
  static const duplicateSubspeciesMergedSuccess = 'Subespecies duplicadas fusionadas correctamente.';
  static const incongruitySkipped = 'Incongruencia omitida.';
  static const subspeciesAndAttachmentsSyncedSuccess = 'Subespecie y archivos adjuntos sincronizados correctamente.';
  static const remoteImageDownloadedSuccess = 'Imagen descargada y guardada localmente con éxito.';
  static const remoteImageDownloadFailedMessage = 'No se pudo descargar automáticamente la imagen. Puedes seleccionarla desde la galería de fotos.';
  static const invalidUnitRetained = 'Símbolo de unidad conservado.';
  static const unitUpdatedSuccess = 'Unidad de medida actualizada correctamente.';
  static const unitRemovedSuccess = 'Unidad de medida eliminada correctamente.';
  static const integerUnitNormalizedSuccess = 'Propiedad normalizada a tipo entero correctamente.';
  static const negativeValueCorrectedSuccess = 'Valor numérico corregido correctamente.';
  static const propertyNameRenamedSuccess = 'Nombre de propiedad actualizado correctamente.';
  static const changeUnitAction = 'Cambiar unidad de medida';
  static const selectNewUnitPrompt = 'Selecciona una nueva unidad de medida';
  static const unspecifiedPropertyPlaceholder = '—';
  static const markAsUnknownOrNotApplicable = 'Marcar como desconocido o no aplicable';
  static const propertyMarkedAsUnknownSuccess = 'Propiedad marcada como no disponible o desconocida.';
  static const setNullAction = 'Establecer nulo';
  static const enterValueAction = 'Ingresar valor';

  static const confirmDeleteConflictingRelationMessage = '¿Deseas eliminar esta relación en conflicto?';

  static String keepSubspeciesPrompt(String name) => '¿Deseas mantener la subespecie "$name" en el catálogo o eliminarla?';
  static String manageSpeciesTitle(String name) => 'Gestionar "$name"';
  static String assignPropertyTitle(String prop) => 'Asignar $prop';
  static const ccTabIntegrityRules = 'Reglas de integridad';
  static const ccTabRoutineChecks = 'Comprobaciones rutinarias';
  static const ccTabIgnored = 'Omitidas';
  static const ccIntegrityEmptyTitle = 'Integridad de datos verificada';
  static const ccIntegrityEmptySubtitle = 'No se encontraron infracciones de reglas ni inconsistencias en el catálogo o inventario.';
  static const ccRoutineEmptyTitle = 'Verificaciones rutinarias al día';
  static const ccRoutineEmptySubtitle = 'Todas las comprobaciones periódicas de inventario y ubicación han sido completadas.';
  static const ccIgnoredEmptyTitle = 'Sin comprobaciones omitidas';
  static const ccIgnoredEmptySubtitle = 'Las comprobaciones que marques como no volver a mostrar aparecerán aquí.';
  static const runNewRoutineCheckAction = 'Iniciar verificaciones';
  static const doNotShowAgainAction = 'No volver a mostrar';
  static const restoreAction = 'Volver a mostrar';
  static const cardMarkedAsIgnoredSuccess = 'Marcada para no volver a mostrarse. Puedes encontrarla en la pestaña de comprobaciones omitidas.';
  static const cardUnignoredSuccess = 'Comprobación reactivada y devuelta a la lista activa.';
  static String pendingIntegrityRules(int count) =>
      count == 1 ? '1 regla pendiente' : '$count reglas pendientes';
  static String pendingRoutineChecks(int count) =>
      count == 1 ? '1 verificación pendiente' : '$count verificaciones pendientes';
  static String pendingIgnoredCount(int count) =>
      count == 1 ? '1 comprobación omitida' : '$count comprobaciones omitidas';

  // Botones semánticos de confirmación y acción
  static const confirmKeepAction = 'Mantener';
  static const confirmSkipAction = 'Omitir';
  static const confirmKeepInCatalogAction = 'Mantener en el catálogo';
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
  static const fixRemoveDateAction = 'Eliminar fecha';
  static const fixEnterValueAction = 'Ingresar valor';
  static const fixCorrectValueAction = 'Corregir valor';
  static const fixChangeUnitAction = 'Cambiar unidad';
  static const fixNormalizeIntegerAction = 'Normalizar a entero';
  static const fixRemoveUnitAction = 'Eliminar unidad';
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
  static const fixReassignOrDeregisterAction = 'Reasignar o dar de baja';
  static const fixCorrectExpirationAction = 'Corregir fecha';
  static const fixRelocateOrManageAction = 'Gestionar';
  static const fixRelocateAction = 'No, reubicar';
  static const fixDownloadLocallyAction = 'Descargar localmente';
  static const fixAddPhotoAction = 'Agregar fotografía';
  static const fixCleanAttributesAction = 'Limpiar atributos';
  static const fixResolveDuplicatesAction = 'Resolver duplicados';
  static const fixCreateInstanceAction = 'Crear instancia';

  static String resolveMissingPropertyPrompt(String prop) => '¿Cómo deseas registrar la propiedad "$prop"?';
  static String assignBooleanPrompt(String prop) => 'Selecciona el valor booleano para "$prop":';
  static String correctPropertyTitle(String prop) => 'Corregir $prop';
  static String syncInfoPrompt(String name, String msg) => 'Sincronizar información para "$name":\n\n$msg';

  static String subspeciesNameWithBrand(String name, String? brand) =>
      brand != null && brand.isNotEmpty ? '$name ($brand)' : name;
  static String uninstantiatedSubspeciesSubtitle(String subName, String speciesName) =>
      '$subName • Especie: $speciesName';
  static String uninstantiatedSubspeciesQuestion(String subName) =>
      '¿Deseas registrar una instancia física para la subespecie "$subName" o gestionarla?';
  static String uniqueSubspeciesDuplicatedSubtitle(String subspecies, String species, int count) =>
      '$subspecies • $species: $count instancias';
  static String uniqueSubspeciesDuplicatedQuestion(String subspecies, String species, int count) =>
      '¿Deseas eliminar las instancias duplicadas o permitir múltiples instancias de "$subspecies"?';
  static String resolveUniquenessPrompt(String subspecies, String species, int count) =>
      'La subespecie "$subspecies" de la especie única "$species" tiene $count instancias.\n\n¿Deseas permitir múltiples instancias convirtiendo la especie en no única o eliminar los duplicados de esta subespecie?';
  static String subgroupRuleViolationSubtitle(String subspecies, String type) =>
      '$subspecies • Tipo: $type';
  static String subgroupRuleViolationQuestion(String type) =>
      '¿Deseas limpiar la marca y el código de barras no permitidos en el subgrupo "$type"?';
  static String speciesWithType(String name, String type) => '$name - $type';
  static String uninstantiatedSpeciesQuestion(String name) =>
      '¿Deseas crear una instancia física para la especie "$name" o gestionarla?';
  static String incompleteSpeciesInfoQuestion(String name) =>
      '¿Deseas asignar una imagen principal a la especie "$name"?';
  static String remoteSpeciesImageSubtitle(String name, String type) =>
      '$name - $type • Imagen remota';
  static String remoteSpeciesImageQuestion(String name) =>
      '¿Deseas descargar la imagen remota de "$name" para guardarla localmente en el dispositivo?';
  static String remoteSubspeciesImageSubtitle(String subspecies, String species) =>
      '$subspecies • $species';
  static String remoteSubspeciesImageQuestion(String subspecies) =>
      '¿Deseas descargar la imagen remota de "$subspecies" para guardarla localmente en el dispositivo?';
  static String orphanEntitySubtitle(String displayName, String path) =>
      '$displayName • Ubicación efectiva: $path';
  static String orphanEntityQuestion(String displayName) =>
      '¿Deseas asignar una ubicación física o un contenedor a "$displayName"?';
  static String locationConflictSubtitle(String displayName, String container, String directLoc) =>
      '$displayName • En contenedor $container y en ubicación $directLoc';
  static String locationConflictQuestion(String displayName, String container, String directLoc) =>
      '¿Deseas resolver la doble asignación de "$displayName" asignado en "$container" y "$directLoc"?';
  static String resolveLocationConflictPrompt(String displayName, String container, String directLoc) =>
      'El elemento "$displayName" tiene doble asignación:\n\n• Contenedor: $container\n• Ubicación directa: $directLoc\n\n¿Cómo deseas resolverlo?';
  static String circularRelationSubtitle(String source, String target, String relationType) =>
      '$source ➔ $target • $relationType';
  static String circularRelationQuestion(String source, String target) =>
      '¿Deseas eliminar la relación circular no válida entre "$source" y "$target"?';
  static String ownershipCheckSubtitle(String displayName, String path) =>
      '$displayName • Ubicación efectiva: $path';
  static String ownershipCheckQuestion(String displayName, String path) =>
      '¿Aún conservas "$displayName" en su ubicación "$path"?';
  static String whatActionForInstancePrompt(String displayName) =>
      '¿Qué acción deseas realizar sobre la instancia "$displayName"?';
  static String confirmDeregisterInstanceMessage(String displayName) =>
      '¿Confirmas que deseas dar de baja del inventario esta instancia de "$displayName"?';
  static String locationVerificationSubtitle(String displayName, String path) =>
      '$displayName • Ubicación registrada: $path';
  static String locationVerificationQuestion(String displayName, String path) =>
      '¿La ubicación de "$displayName" sigue siendo "$path"?';
  static String perishableMissingExpirationSubtitle(String displayName, String species) =>
      '$displayName • Especie: $species';
  static String perishableMissingExpirationQuestion(String species, String displayName) =>
      '¿Deseas asignar fecha de caducidad a la instancia "$displayName" de especie $species?';
  static String nonPerishableWithExpirationSubtitle(String displayName, String date) =>
      '$displayName • Caducidad asignada: $date';
  static String nonPerishableWithExpirationQuestion(String species, String displayName) =>
      '¿Deseas quitar la fecha de caducidad de "$displayName", correspondiente a la especie no perecedera $species?';
  static String unitSymbolParentheses(String symbol) => ' $symbol';
  static String missingMagnitudeTitle(String property) => 'Magnitud faltante: $property';
  static String missingMagnitudeSubtitle(String displayName, String property, String unitSuffix) =>
      '$displayName • La especie define $property$unitSuffix';
  static String missingMagnitudeQuestion(String displayName, String property, String species) =>
      '¿Deseas registrar el valor de "$property" para "$displayName"?';
  static String propertyRegisteredSuccess(String property) =>
      'Propiedad "$property" registrada correctamente.';
  static String anomalousMagnitudeSubtitle(String displayName, String property, num value, String unit) =>
      unit.isNotEmpty ? '$displayName • $property: $value $unit' : '$displayName • $property: $value';
  static String anomalousMagnitudeQuestion(String property, num value) =>
      '¿Deseas corregir el valor anómalo de "$property", actualmente registrado como $value?';
  static String propertyValueUpdatedSuccess(String property, num value) =>
      'Valor de "$property" actualizado a $value.';
  static String numismaticDuplicateSubspeciesSubtitle(String subspecies, int count, String species) =>
      '$subspecies • $count subespecies idénticas en $species';
  static String numismaticDuplicateSubspeciesQuestion(int count, String subspecies) =>
      '¿Deseas fusionar las $count subespecies de "$subspecies" en una sola?';
  static String mergeDuplicateSubspeciesPrompt(int count, String subspecies) =>
      '¿Deseas consolidar las $count subespecies de "$subspecies" en una sola subespecie y reasignar todas las instancias existentes?';
  static String numismaticSubspeciesIncongruitySubtitle(String displayName, String subspecies) =>
      '$displayName • Subespecie: $subspecies';
  static String numismaticSubspeciesIncongruityQuestion(String issueMsg) =>
      '$issueMsg ¿Deseas actualizar la subespecie con los datos de esta pieza?';
  static String desyncedAttachmentNameSubtitle(String displayName, String fileName) =>
      '$displayName • Archivo actual: $fileName';
  static String desyncedAttachmentNameQuestion(String fileName, String subspecies, String expected) =>
      '¿Deseas renombrar el archivo adjunto "$fileName" a su formato estándar "$expected"?';
  static String incompleteNumismaticMagnitudesSubtitle(String displayName, String mags) =>
      '$displayName • Faltan: $mags';
  static String incompleteNumismaticMagnitudesQuestion(String displayName, String mags) =>
      '¿Deseas autocompletar las magnitudes $mags de "$displayName" desde la subespecie?';
  static String emptyGradeDataSubtitle(String displayName) =>
      '$displayName • Grado de conservación sin asignar';
  static String emptyGradeDataQuestion(String displayName) =>
      '¿Deseas asignar un grado de conservación a la pieza "$displayName"?';
  static String gradeUpdatedSuccess(String grade) =>
      'Grado de conservación actualizado a "$grade".';
  static String numismaticEmissionOutlierSubtitle(String displayName, String anomalyDescription) =>
      '$displayName • $anomalyDescription';
  static String numismaticEmissionOutlierQuestion(String anomalyDetail, String suggestedFix) =>
      '$anomalyDetail ¿Deseas aplicar la corrección recomendada: $suggestedFix?';
  static String numismaticMagnitudeNotAmongExpectedDesc(String magnitudeName, {String? currentValue}) =>
      currentValue != null && currentValue.trim().isNotEmpty
          ? 'La magnitud $magnitudeName, con valor actual "$currentValue", no posee un valor de los esperados para este espécimen.'
          : 'La magnitud $magnitudeName no posee un valor de los esperados para este espécimen.';
  static String numismaticCurrencyAnachronismDesc(String foundIso, String expectedIso, int year, String country) =>
      'Divisa $foundIso no válida para $country en $year. Divisa esperada: $expectedIso.';
  static String numismaticMaterialContradictionDesc(String foundMat, String expectedMat, String denom) =>
      'Material "$foundMat" incongruente con la emisión para $denom. Esperado: "$expectedMat".';
  static String numismaticMotifMismatchDesc(String denom, String motif, {String? currentMotif}) =>
      currentMotif != null && currentMotif.trim().isNotEmpty
          ? 'Motivo actual "$currentMotif" incongruente con la emisión para $denom. Esperado: "$motif".'
          : 'La emisión de $denom corresponde al motivo conmemorativo "$motif", pero no coincide.';
  static String numismaticDenominationAnomalyDesc(String denom, String country, int year) =>
      'Denominación "$denom" no pertenece a las emisiones oficiales de $country en el año $year.';
  static String numismaticYearOutOfRangeDesc(int year, String country) =>
      'Año $year fuera del rango histórico registrado para $country.';
  static String photoOfDisplayName(String name) => 'Fotografía de $name';

  static String invalidUnitSymbolSubtitle(String targetName, String propName, String symbol) =>
      '$targetName • Propiedad "$propName" con unidad no estándar "$symbol"';
  static String invalidUnitSymbolQuestion(String propName, String symbol) =>
      '¿Deseas reemplazar la unidad no reconocida "$symbol" en "$propName" por una unidad estándar?';
  static String integerUnitIncongruitySubtitle(String targetName, String propName, String symbol) =>
      '$targetName • Propiedad "$propName" con unidad "$symbol" con tipo o valor no entero';
  static String integerUnitIncongruityQuestion(String propName, String symbol) =>
      '¿Deseas normalizar a número entero el valor y tipo de "$propName" con unidad "$symbol"?';
  static String nonNumericWithUnitSubtitle(String targetName, String propName, String dataType, String symbol) =>
      '$targetName • Propiedad "$propName" de tipo $dataType con unidad física "$symbol"';
  static String nonNumericWithUnitQuestion(String propName, String dataType) =>
      '¿Deseas remover la unidad física de la propiedad no numérica "$propName"?';
  static String negativeMagnitudeViolationSubtitle(String targetName, String propName, num val, String symbol) =>
      symbol.isNotEmpty
          ? '$targetName • "$propName" con valor negativo no permitido: $val $symbol'
          : '$targetName • "$propName" con valor negativo no permitido: $val';
  static String negativeMagnitudeViolationQuestion(String propName) =>
      '¿Deseas corregir el valor negativo no permitido en "$propName"?';
  static String propertyNameSuggestionIncongruitySubtitle(String spName, String currentProp, String suggestedProp, String symbol) =>
      '$spName • "$currentProp" con unidad "$symbol" ➔ Sugerido: "$suggestedProp"';
  static String propertyNameSuggestionIncongruityQuestion(String currentProp, String suggestedProp, String symbol) =>
      '¿Deseas renombrar la propiedad "$currentProp" a su sugerencia estándar "$suggestedProp"?';

  // Formularios numismáticos, asistente de escaneo e inventario
  static const otherSpecifyParenthesized = 'Otro por especificar';
  static const materialPaper = 'Papel';
  static const inAppQuickFillSourceEngine = 'Formulario rápido integrado';
  static const coinCircularDescriptor = 'Moneda circular';
  static const banknoteRectangleDescriptor = 'Billete rectangular';
  static const capturingHighDefinitionPrompt = 'Capturando en alta resolución...';
  static const captureCompleteStatus = 'Captura completada';
  static const step1Obverse = 'Paso 1: anverso';
  static const step2Reverse = 'Paso 2: reverso';
  static const disableTorchTooltip = 'Desactivar linterna';
  static const enableTorchTooltip = 'Activar linterna para mejorar la nitidez';
  static const bothSidesReadyTip = 'Ambos lados listos. Pulsa Continuar a datos numismáticos.';
  static const cameraIlluminationTip = 'Consejo: Activa la linterna y ajusta el zoom para encuadrar la pieza.';
  static const continueToNumismaticDataAction = 'Continuar a datos numismáticos';
  static const emptyContainerPrompt = 'Este contenedor está vacío.\nArrastra elementos aquí para guardarlos.';
  static const emptyLocationPrompt = 'No hay elementos en esta ubicación.';
  static const cameraInitErrorPrefix = 'Error al inicializar la cámara: ';
  static const cameraCaptureErrorPrefix = 'Error en la captura de imagen: ';
  static String selectedCount(int count) =>
      count == 1 ? '1 seleccionado' : '$count seleccionados';
  static String currencyCodeWithName(String code, String name) => '$code ($name)';
  static String zoomLevelDisplay(double zoom) => '${zoom.toStringAsFixed(1)}x';

  // Catálogo, taxonomía y formularios de especie
  static const replaceAction = 'Reemplazar';
  static const attachToInstanceAction = 'Adjuntar a esta instancia';
  static const attachmentAddedToEditing = 'Archivo adjunto agregado a la edición.';
  static const attachmentAddedSuccessfully = 'Archivo adjunto agregado correctamente.';
  static const numismaticAttachmentModifiedInEditing = 'Archivo adjunto numismático modificado en la edición.';
  static const numismaticAttachmentUpdatedSuccessfully = 'Archivo adjunto numismático actualizado correctamente.';
  static const attachmentModifiedInEditing = 'Archivo adjunto modificado en la edición.';
  static const attachmentReplacedSuccessfully = 'Archivo adjunto reemplazado correctamente.';
  static const nameUpdatedInEditing = 'Nombre actualizado en la edición.';
  static const nameUpdatedSuccessfully = 'Nombre actualizado correctamente.';
  static const physicalFileNotFoundInStorage = 'El archivo físico no existe en el almacenamiento.';
  static const attachmentRemovedFromEditing = 'Archivo adjunto eliminado de la edición.';
  static const attachmentDeletedSuccessfully = 'Archivo adjunto eliminado correctamente.';
  static const speciesLabel = 'Especie';
  static const instanceLabel = 'Instancia';
  static const nonPerishable = 'No perecedero';
  static const perishable = 'Perecedero';
  static const addAttachmentToThisInstance = 'Agregar archivo adjunto a esta instancia';
  static const physicalFileNotFound = 'Archivo físico no encontrado';
  static const selectOrCaptureAttachmentTitle = 'Seleccionar o capturar archivo adjunto';
  static const scanObverseTitle = 'Escanear anverso';
  static const scanReverseTitle = 'Escanear reverso';
  static const coinWord = 'moneda';
  static const banknoteWord = 'billete';
  static const searchOnlineImagesByName = 'Buscar imágenes en internet por nombre';
  static const captureVisualMatchAction = 'Capturar coincidencia visual';
  static const analyzingCapturedImage = 'Analizando imagen capturada...';
  static const noBarcodeOrIsbnDetected = 'No se detectó un código de barras o ISBN en la imagen.';
  static const noPhotoSelected = 'No se seleccionó ninguna fotografía.';
  static const searchWebImageTitle = 'Buscar imagen en internet';
  static const defaultNewObjectName = 'Nuevo objeto';
  static const processing = 'Procesando...';

  static String confirmDeleteAttachmentPrompt(String name) => '¿Deseas eliminar permanentemente el archivo "$name"?';
  static String speciesPrefix(String name) => 'Especie: $name';
  static String perishableWithShelfLife(int? days) =>
      days != null ? 'Perecedero, con $days días de vida útil' : 'Perecedero';
  static String mergeSpeciesDescription(String sourceName) =>
      'Se fusionará "$sourceName" con otra especie. Todas las subespecies e instancias pertenecerán a la especie de destino.';
  static String speciesMergedSuccess(String source, String target) =>
      'Especie "$source" unida correctamente en "$target".';
  static String separateSubspeciesDescription(String subName) =>
      'La subespecie "$subName" se promoverá a una especie independiente.';
  static String moveSubspeciesDescription(String subName) =>
      'Se trasladará la subespecie "$subName" y sus instancias a la especie seleccionada.';
  static String splitSubspeciesDescription(String subName) =>
      'Crea una nueva subespecie a partir de "$subName" con datos modificados y transfiere las instancias seleccionadas a ella.';
  static String newSpeciesDefaultName(String subName) => '$subName especie';
  static String splitSubspeciesDefaultName(String subName) => '$subName copia';
  static String instancesToTransferTitle(int selected, int total) => 'Instancias a transferir: $selected de $total';
  static String numismaticObverseSubtitle(String itemType) =>
      'Retícula guiada, corrección de exposición y recorte centrado para el anverso de $itemType.';
  static String numismaticReverseSubtitle(String itemType) =>
      'Retícula guiada, corrección de exposición y recorte centrado para el reverso de $itemType.';
  static String suggestedSearchQuery(String query) => 'Búsqueda sugerida: "$query"';
  static String searchingBarcode(String barcode) => 'Buscando código $barcode...';
  static String autoInstantiatedFeedback(String subName, String speciesName) =>
      'Instanciado automáticamente: $subName de especie $speciesName.';
  static String autoFillError(String err) => 'Error en autocompletado: $err.';
  static String photoProcessingError(String err) => 'Error al procesar fotografía: $err.';
  static String searchWebImagesError(String err) => 'Error al buscar imágenes en internet: $err.';
  static String downloadOrAssignImageError(String err) => 'Error al descargar o asignar la imagen: $err.';
  static String saveSubspeciesError(String err) => 'Error al guardar la subespecie: $err.';
  static String replaceAttachmentError(String err) => 'Error al reemplazar el archivo adjunto: $err.';
  static String errorOpeningFile(Object err) => '$errorOpeningFilePrefix$err';
  static String errorSharingFile(Object err) => '$errorSharingFilePrefix$err';
  static String renameError(String err) => 'Error al renombrar: $err.';
  static String deleteError(String err) => 'Error al eliminar: $err.';
  static String mergeSpeciesError(String err) => 'Error al unir especies: $err.';

  // Respaldo y base de datos
  static const backupZipCompressionError = 'Error al generar la compresión del paquete de copia de seguridad.';
  static const backupZipMissingDatabaseJsonError = 'El archivo comprimido de respaldo no contiene una base de datos válida.';
  static const invalidBackupStructureError = 'El archivo de copia de seguridad no tiene una estructura válida.';
  static const unspecifiedGrade = 'No especificado';

  // Servicio de actualizaciones
  static const errorGettingPackageVersion = 'Error al obtener la versión del paquete.';
  static const checkingUpdateInNativeChannel = 'Consultando la disponibilidad de actualizaciones...';
  static const platformExceptionCheckingUpdate = 'Error del sistema al verificar la actualización.';
  static const unexpectedErrorCheckingUpdate = 'Error inesperado al verificar la actualización.';
  static const invokingUpdateAppNative = 'Iniciando el proceso de actualización...';
  static const errorExecutingUpdateApp = 'Error al ejecutar la actualización de la aplicación.';
  static const errorTriggeringUpdate = 'Error al iniciar la actualización.';

  // Helpers dinámicos
  static String sourceFileNotFoundAtPath(String path) => 'El archivo de origen no existe en la ruta: $path.';
  static String errorComparingVersions(String latest, String current) =>
      'Error al comparar versiones: versión remota $latest frente a actual $current.';
  static String autoUpdatesOnlyOnAndroid(String platform) =>
      'Las actualizaciones automáticas solo están disponibles en Android. Plataforma actual: $platform.';
  static String updateCheckResult(bool available, String? latest, String current) =>
      available
          ? 'Actualización disponible: versión $latest frente a instalada $current.'
          : 'Aplicación actualizada en versión $current.';
  static String versionDisplay(String? version) => 'v${version ?? '?'}';
  static String sqlSecurityError(String kw) => '$sqlSecurityErrorPrefix$kw$sqlSecurityErrorSuffix';
  static String sqlSyntaxError(String err) => '$sqlSyntaxErrorPrefix$err';
  static String rowsRetrieved(int count) => '$rowsRetrievedPrefix$count';
  static String noSearchMatches(String query) => '$noSearchMatchesPrefix$query$noSearchMatchesSuffix';
  static String errorWithDetails(Object err) => '$errorPrefix$err';
  static String updateErrorWithException(Object error) => '$updateError$error';
  static String backupExportErrorMessage(Object error) => '$backupExportErrorPrefix$error';
  static String backupImportErrorMessage(Object error) => '$backupImportErrorPrefix$error';
  static String formatObjectsCount(int count) => count == 1 ? '1 $objectsLabel' : '$count $objectsLabel';
  static String sectionHeaderWithCount(String section, int count) => '$section: $count';
  static String scopeWithPrefix(String scope) => '$searchScopePrefix$scope';
  static String dateRangeFormatted(String start, String end) => '$start a $end';

  // Historial y auditoría
  static const historyTitle = 'Historial y auditoría';
  static const historyScreenTitle = 'Historial y auditoría';
  static const historyScreenSubtitle = 'Consulta todos los cambios y eventos registrados en la base de datos.';
  static const historySearchHint = 'Buscar eventos, descripciones o nombres...';
  static const filterAll = 'Todos';
  static const filterEntities = 'Instancias';
  static const filterSpecies = 'Especies';
  static const filterLocations = 'Ubicaciones';
  static const filterRelations = 'Relaciones';
  static const filterBackups = 'Copias de seguridad y sistema';
  static const categoryFilterAll = 'Todos';
  static const categoryFilterEntities = 'Instancias';
  static const categoryFilterSpecies = 'Especies';
  static const categoryFilterLocations = 'Ubicaciones';
  static const categoryFilterRelations = 'Relaciones';
  static const categoryFilterBackupsAndSystem = 'Copias de seguridad y sistema';
  static const historyDetailTitle = 'Detalle del evento';
  static const eventDetailsTitle = 'Detalle del evento';
  static const historyEmptySearch = 'No se encontraron eventos que coincidan con la búsqueda.';
  static const historyEmptyCategory = 'No hay actividad registrada en esta categoría.';
  static const noHistoryEvents = 'Sin actividad registrada';
  static const noHistoryEventsSubtitle = 'Los eventos y modificaciones en el sistema aparecerán aquí cronológicamente.';
  static const historyTimestampLabel = 'Fecha y hora exacta';
  static const exactTimestampLabel = 'Fecha y hora exacta';
  static const historyCategoryLabel = 'Categoría';
  static const categoryLabel = 'Categoría';
  static const historyTypeLabel = 'Tipo de evento';
  static const historyTargetLabel = 'Elemento involucrado';
  static const targetIdLabel = 'Identificador del elemento';
  static const targetTypeLabel = 'Tipo de elemento';
  static const historyPayloadLabel = 'Metadatos y cambios';
  static const technicalDetailsTitle = 'Metadatos y detalles técnicos';
  static const historyNavigateToTarget = 'Ver elemento';
  static const viewTargetAction = 'Ver elemento';
  static const historyClearHistoryTooltip = 'Vaciar historial';
  static const clearHistoryTooltip = 'Vaciar historial';
  static const historyClearConfirmationTitle = '¿Vaciar historial de actividad?';
  static const clearHistoryTitle = '¿Vaciar historial de actividad?';
  static const historyClearConfirmationMessage = 'Esta acción eliminará los registros del historial de eventos. Los datos de tus instancias, especies y ubicaciones no se verán afectados.';
  static const clearHistoryConfirmation = 'Esta acción eliminará los registros del historial de eventos. Los datos de tus instancias, especies y ubicaciones no se verán afectados.';
  static const cancelAction = 'Cancelar';
  static const clearAction = 'Vaciar';
  static const historyAuditLogSettings = 'Historial de auditoría de la base de datos';
  static const historyAuditLogSettingsSubtitle = 'Consulta todos los cambios y eventos registrados en la base de datos.';
  static const timeJustNow = 'Hace un momento';
  static String timeMinutesAgo(int m) => m == 1 ? 'Hace 1 minuto' : 'Hace $m minutos';
  static String timeHoursAgo(int h) => h == 1 ? 'Hace 1 hora' : 'Hace $h horas';
  static String timeDaysAgo(int d) => d == 1 ? 'Hace 1 día' : 'Hace $d días';

  static String activityRegistered(String name, String type) => 'Registrado en el mundo: "$name", tipo $type.';
  static String activityEditedWithDetails(String name, String details) => 'Editado "$name": $details.';
  static String activityEdited(String name) => 'Información editada de "$name".';
  static String activityDeleted(String name) => 'Eliminado del mundo: "$name".';
  static String activityMoved(String name, String from, String to) => 'Trasladado "$name" de "$from" a "$to".';
  static String activityAttachmentAdded(String fileName, String entityName) => 'Archivo "$fileName" adjuntado a "$entityName".';
  static String activityAttachmentRemoved(String fileName, String entityName) => 'Archivo "$fileName" eliminado de "$entityName".';
  static String activityRelationAdded(String sourceName, String relationType, String targetName) => 'Vínculo establecido: "$sourceName" con relación $relationType hacia "$targetName".';
  static String activityRelationRemoved(String sourceName, String relationType, String targetName) => 'Vínculo eliminado: "$sourceName" con relación $relationType hacia "$targetName".';
  static String activityPhotoChanged(String name) => 'Fotografía principal actualizada de "$name".';
  static String activityPhotoRemoved(String name) => 'Fotografía principal eliminada de "$name".';
  static String activityQuantityConsumed(String name, Object qty, String unit) => 'Cantidad ajustada de "$name": $qty $unit.';
  static String activitySpeciesCreated(String name, String type) => 'Nueva especie registrada: "$name", tipo $type.';
  static String activitySpeciesEdited(String name, String details) => 'Especie modificada "$name": $details.';
  static String activitySpeciesDeleted(String name) => 'Especie eliminada: "$name".';
  static String activitySpeciesMerged(String source, String target) => 'Especie "$source" fusionada en "$target".';
  static String activitySubspeciesCreated(String subName, String speciesName) => 'Nueva subespecie registrada: "$subName" en "$speciesName".';
  static String activitySubspeciesSeparated(String subName, String newSpecies) => 'Subespecie "$subName" separada a especie "$newSpecies".';
  static String activitySubspeciesMoved(String subName, String targetSpecies) => 'Subespecie "$subName" trasladada a "$targetSpecies".';
  static String activitySubspeciesDeleted(String subName) => 'Subespecie eliminada: "$subName".';
  static String activitySubspeciesSplit(String origName, String newName, int count) => 'Subespecie "$origName" dividida en "$newName", con $count instancias transferidas.';
  static String activityLocationCreated(String name) => 'Nueva ubicación registrada: "$name".';
  static String activityLocationEdited(String name) => 'Ubicación modificada: "$name".';
  static String activityLocationMoved(String name, String? parent) => parent != null ? 'Ubicación "$name" trasladada a "$parent".' : 'Ubicación "$name" convertida en principal.';
  static String activityLocationDeleted(String name) => 'Ubicación eliminada: "$name".';
  static String activityEntitiesBatchDeleted(int count) => count == 1 ? 'Eliminación en lote: 1 instancia eliminada.' : 'Eliminación en lote: $count instancias eliminadas.';
  static String activityBackupExported(int totalRecords) => 'Copia de seguridad exportada con $totalRecords registros.';
  static String activityBackupRestored(int totalRecords, String? originDate) => originDate != null ? 'Copia de seguridad restaurada con $totalRecords registros, fecha de origen: $originDate.' : 'Copia de seguridad restaurada con $totalRecords registros.';
  static String activityAuditFixApplied(String ruleTitle, String details) => 'Auditoría aplicada: $ruleTitle. $details.';
  static String activityEntityUpdatedInPlace(String name, String changes) => 'Instancia actualizada de "$name": $changes.';

  // Helpers de presentación
  static String editPropertyTitle(String propertyName) => 'Editar propiedad "$propertyName"';
  static String valueWithUnitLabel(String unit) => 'Valor en $unit';
  static String valueWithDataTypeLabel(String dataType) => 'Valor: $dataType';
  static String unitOrTypeInParentheses(String value) => ' - $value';
  static String propertyWithUnitOrType(String propertyName, String unitOrType) => '$propertyName - $unitOrType';
  static String deleteSpeciesInstanceConfirmation(String speciesName) => '¿Deseas eliminar "$speciesName"?';
  static String speciesGeneralWithType(String speciesName, String type) => 'Especie general: $speciesName - $type';
  static String barcodeWithColon(String barcode) => 'Código de barras: $barcode';
  static String dateFormattedWithDays(String dateStr, String daysStr) => '$dateStr, $daysStr';
  static String expiredDaysAgo(int days) => days == 1 ? 'Vencido hace 1 día' : 'Vencido hace $days días';
  static String expiresInDaysAlert(int days) => days == 1 ? 'Vence en 1 día' : 'Vence en $days días';
  static String expiresInDays(int days) => days == 1 ? 'Vence en 1 día' : 'Vence en $days días';
  static String confirmDeleteProperty(String propertyName) => '¿Deseas eliminar la propiedad "$propertyName"?';
  static String numismaticSpeciesDescription(String speciesType) => 'Colección numismática de $speciesType';
  static String pieceInstantiatedDirectly(String name) => 'Pieza "$name" instanciada directamente.';
  static String speciesInstantiatedSuccessWithName(String speciesName) => 'Instancia agregada exitosamente: "$speciesName".';
  static String instantiateSpeciesTitle(String speciesName) => 'Instanciar "$speciesName"';
  static String subspeciesWithBrand(String name, String? brand) => brand != null && brand.isNotEmpty ? '$name ($brand)' : name;
  static String typeWithPropertyAndValue(String type, String propertyName, String displayValue) => '$type • $propertyName: $displayValue';
  static String confirmReplaceAttachmentNamedMessage(String fileName) => '$confirmReplaceAttachmentMessage\n"$fileName"';
  static String confirmReplaceAttachmentRenamedMessage(String oldName, String newName) => '$confirmReplaceAttachmentMessage\n"$oldName" ➔ "$newName"';
  static String confirmRemoveAttributeMessage(String key) => '¿Deseas eliminar el atributo "$key"?';
  static String confirmDeleteLocationMessage(String name) => '¿Deseas eliminar la ubicación "$name" y todo su contenido?';
  static String objectsInLocationAndSublocations(int count) => count == 1 ? '1 objeto contenido' : '$count objetos contenidos';
  static String locationCorrectionError(String err) => 'Error al corregir la ubicación: $err.';
  static String correctLocationTitle(String entityName) => 'Corregir ubicación de "$entityName"';
  static String moveSelectedCountTitle(int count) => count == 1 ? 'Trasladar 1 elemento seleccionado' : 'Trasladar $count elementos seleccionados';

  // Nombres sugeridos de propiedades
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
  static const propFaceValue = 'Valor facial';
  static const propDefault = 'Propiedad';

  // Valores predeterminados numismáticos
  static const defaultNumismaticPiece = 'Pieza numismática';
  static const noteCoinPrefix = 'Moneda: ';
  static const noteYearPrefix = 'Año: ';
  static const noteMaterialPrefix = 'Material: ';
  static const magValorNominal = 'Valor nominal';
  static const magAcunacion = 'Acuñación';
  static const magDivisa = 'Divisa';
  static const magMaterial = 'Material';
  static const magGrado = 'Grado';
  static const magEmisor = 'Emisor';
  static String numismaticEstimatedFineContent(String fineWeight, String metalName, String purityPct) =>
      'Contenido fino estimado: $fineWeight g de $metalName, con ley de $purityPct%.';

  // Taxonomía
  static const speciesBook = 'Libro';

  // Razones de perecedero
  static const perishabilityReasonNonObjectType = 'Las especies de tipo distinto a Objeto son no perecederas por definición.';
  static String perishabilityReasonDurableObject(String kw) => 'Detectado como objeto duradero o no alimenticio: $kw.';
  static const perishabilityReasonDairy = 'Categoría lácteos, con aproximadamente 14 días de vida útil.';
  static const perishabilityReasonBakery = 'Categoría panadería, con aproximadamente 7 días de vida útil.';
  static const perishabilityReasonFruitVeg = 'Categoría frutas y verduras, con aproximadamente 7 días de vida útil.';
  static const perishabilityReasonMeat = 'Categoría carnes y pescados, con aproximadamente 5 días de vida útil.';
  static const perishabilityReasonBeverage = 'Categoría bebidas perecederas, con aproximadamente 30 días de vida útil.';
  static const perishabilityReasonPharmacy = 'Categoría farmacia y salud, con aproximadamente 365 días de vida útil.';
  static const perishabilityReasonCanned = 'Categoría enlatados y conservas, con aproximadamente 365 días de vida útil.';
  static const perishabilityReasonDefault = 'No se identificó una categoría perecedera; configurado como no perecedero por defecto.';

  // Métodos de registro de actividad para entidades
  static String activityEntityCreated(String name, String type) => 'Registrado en el mundo: "$name", tipo $type.';
  static String activityEntityEditedWithDetails(String name, String details) => 'Editado "$name": $details.';
  static String activityEntityEdited(String name) => 'Información editada de "$name".';
  static String activityEntityDeleted(String name) => 'Eliminado del mundo: "$name".';
  static String activityEntityMoved(String name, String from, String to) => 'Trasladado "$name" de "$from" a "$to".';

  // Mensajes de notificación
  static String notifMessageExpired(String formattedDate) =>
      formattedDate.isNotEmpty ? 'Fecha de caducidad: $formattedDate.' : '$expiredItemTitle.';
  static String notifMessageExpiringSoon(int daysLeft, String formattedDate) =>
      daysLeft == 1 ? 'Caduca en 1 día, fecha: $formattedDate.' : 'Caduca en $daysLeft días, fecha: $formattedDate.';
  static String notifMessageUnsatisfiedNeed(String deficitStr, double stockCount, double requiredQty) =>
      'Faltan $deficitStr unidades: $stockCount de $requiredQty en inventario.';

  // Formato de fechas
  static const _zeroPad = '0';
  static const spanishMonthNames = [
    'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
    'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
  ];
  static const spanishWeekdayNames = [
    'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'
  ];

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

  static String formatMonthYear(DateTime dt) {
    final monthName = spanishMonthNames[dt.month - 1];
    return '$monthName de ${dt.year}';
  }

  static String formatFullDate(DateTime dt) {
    final weekdayName = spanishWeekdayNames[dt.weekday - 1];
    final monthName = spanishMonthNames[dt.month - 1];
    return '$weekdayName, ${dt.day} de $monthName de ${dt.year}';
  }

  static const infoUpdated = 'Información actualizada';
  static const historyLocationModified = 'Ubicación modificada';
  static const historyNotesUpdated = 'Notas actualizadas';
  static const historyExpirationUpdated = 'Fecha de caducidad actualizada';

  // Cámara numismática
  static const numisAnversoSideLabel = 'Anverso';
  static const numisReversoSideLabel = 'Reverso';
  static String numisCaptureCoinTitle(String side) => 'Captura de moneda: $side';
  static String numisCaptureBanknoteTitle(String side) => 'Captura de billete: $side';
  static String numisActiveSideLabel(String side) => 'Captura: $side';
  static const numisCapturingHD = 'Capturando en alta resolución...';
  static const numisErrorInitCamera = 'Error al inicializar la cámara: ';
  static String numisErrorInitCameraMsg(Object e) => 'Error al inicializar la cámara: $e.';
  static const numisCropFailedLogPrefix = 'El recorte de la imagen falló o excedió el tiempo: ';
  static String numisCropFailedLog(Object e) => 'El recorte de la imagen falló o excedió el tiempo: $e.';
  static const numisErrorCapture = 'Error en la captura: ';
  static String numisErrorCaptureMsg(Object e) => 'Error en la captura: $e.';
  static const numisCameraIlluminationTip2 = 'Consejo: Activa la linterna y ajusta el zoom para encuadrar los relieves.';
  static const numisVolumeShutterTip = 'Dispara con el obturador o con los botones de volumen.';

  // Mensajes de auditoría numismática
  static String numisAuditTitleMismatch(String actual, String canonical) =>
      'Título no estandarizado: valor actual "$actual", valor estándar "$canonical"';
  static String numisAuditYearMismatch(Object inst, Object sub) =>
      'Año: valor en instancia $inst, valor en subespecie $sub';
  static String numisAuditFaceValueMismatch(Object inst, Object sub) =>
      'Valor nominal: valor en instancia $inst, valor en subespecie $sub';
  static String numisAuditCurrencyMismatch(String instCurrency, String subCurrency) =>
      'Divisa de instancia "$instCurrency" no coincide con la subespecie "$subCurrency"';
  static String numisAuditCurrencyNotIso(String actual, String iso) =>
      'Divisa de instancia no es código ISO: valor actual "$actual", código ISO "$iso"';
  static String numisAuditGradeMismatch(String actual, String std) =>
      'Grado de conservación no estandarizado: valor actual "$actual", valor estándar "$std"';
  static String numisAuditMaterialMismatch(String actual, String std) =>
      'Material no estandarizado: valor actual "$actual", valor estándar "$std"';
  static String numisAuditIncongruence(String joined) => 'Incongruencia: $joined.';
  static String numisAttachmentPath(String dir, String name) => '$dir/$name';

  // Taxonomía
  static const taxonomyDepartmentGeneral = 'General';
  static String taxonomyCombinedText(String? g, String? c, String t) =>
      '${g ?? AppTechnicalStrings.empty} ${c ?? AppTechnicalStrings.empty} $t';

  // Formularios de especies y modales
  static String fileAttachedToSpecies(String fileName) => 'Archivo "$fileName" adjuntado a la especie.';
  static String confirmDeletePropertyNamed(String propertyName) => '¿Deseas eliminar la propiedad "$propertyName"?';
  static String confirmDeleteSubspeciesNamed(String subspeciesName) => '¿Deseas eliminar permanentemente la subespecie "$subspeciesName"?';
  static String subspeciesOrBrandsWithCount(int count) => count == 1 ? '$subspeciesOrBrands: 1' : '$subspeciesOrBrands: $count';
  static String instancesCount(int count) => count == 1 ? '1 instancia' : '$count instancias';
  static String subspeciesCountWithInstances(int subspeciesCount, int instancesCount) =>
      '$subspeciesOrBrands: $subspeciesCount • $tabEntities: $instancesCount';
  static String confirmDeleteSpeciesNamed(String name) => '$deleteConfirmationMessage "$name"?';

  // Helpers de catálogo
  static const propMonetaryUnit = 'Unidad Monetaria';
  static String separatedFromSpeciesName(String name) => '$separatedFromSpeciesPrefix$name';
  static const errorNoCamerasFound = 'No se encontraron cámaras disponibles en el dispositivo.';
  static const errorCameraInitCancelledWidgetDisposed = 'Inicialización cancelada debido al cierre de la vista.';
  static const errorCouldNotInitBackCamera = 'No se pudo inicializar la cámara trasera.';
  static String invalidOrNotFoundCodeMessage(String barcode) => '$invalidOrNotFoundCodeMessagePrefix$barcode$invalidOrNotFoundCodeMessageSuffix';
  static String cameraInitError(Object e) => '$cameraInitErrorPrefix$e';
  static String cameraCaptureError(Object e) => '$cameraCaptureErrorPrefix$e';
  static String nameWithType(String name, String type) => '$name - $type';
  static String confirmDeleteRequirementMessage(String speciesName) => '$confirmDeleteRequirementMessagePrefix$speciesName$confirmDeleteRequirementMessageSuffix';
  static String requirementSummary(String formattedQty, String speciesName) => '$needsPrefix $formattedQty de $speciesName';
  static String formatQuantityValue(double qty) => qty % 1 == 0 ? '${qty.toInt()}' : '$qty';
  static String entitiesTabWithCount(int count) => '$tabEntities: $count';
  static String quantityWithFormattedUnit(String formattedValue, String unit) => '$quantityLabel: $formattedValue $unit';
  static String quantityWithValue(String value) => '$quantityLabel: $value';
  static String breadcrumbPathAndTarget(String ancestorPath, String targetName) => '$ancestorPath $targetName';

  // Helpers de presentación e interacción
  static String reviewCounter(int current, int total) => 'Revisión $current de $total';
  static String pendingReviews(int count) => count == 1 ? '1 pendiente' : '$count pendientes';
  static String controlCenterLoadError(Object error) => '$controlCenterLoadErrorPrefix$error';
  static String countString(num count) => count.toString();
  static String speciesTypeWithBullet(String type, String? name) => name != null && name.isNotEmpty ? '$type • $name' : type;
  static String objectsCount(int count) => count == 1 ? '1 $objectsLabel' : '$count $objectsLabel';
  static const draggingElement = 'Arrastrando elemento';
  static String draggingUnits(int count) => count == 1 ? 'Arrastrando 1 unidad' : 'Arrastrando $count unidades';
  static String draggingSelectedElements(int count) => count == 1 ? 'Arrastrando 1 elemento seleccionado' : 'Arrastrando $count elementos seleccionados';
  static String updateErrorWithDetails(Object err) => '$updateError$err';
  static String appVersionDisplay(String version) => '$appName • $appVersionLabel: v$version';
  static String loadNotificationsError(Object err) => '$loadNotificationsErrorPrefix$err';
  static String saveRelationError(Object err) => '$saveRelationErrorPrefix$err';
  static String quoted(String text) => '"$text"';
  static String relationCreatedSuccess(String relationType) => '$relationCreatedSuccessPrefix$relationType$relationCreatedSuccessSuffix';
  static String linkEntityTitle(String name) => '$link "$name"';
  static String relationsLoadError(Object err) => '$relationsLoadErrorPrefix$err';
  static String linksCount(int count) => '$count$linksCountSuffix';
  static String confirmDeleteRelationMessage(String relationType, String otherName) =>
      '$confirmDeleteRelationMessagePrefix$relationType$confirmDeleteRelationMessageMiddle$otherName$confirmDeleteRelationMessageSuffix';
  static const centralInstanceLabelColon = '$centralInstanceLabel: ';

  // Operaciones de taxonomía
  static String subspeciesSeparatedSuccess(String speciesName) => '$subspeciesSeparatedSuccessPrefix"$speciesName".';
  static String separateSubspeciesError(Object e) => '$separateSubspeciesErrorPrefix$e';
  static String subspeciesMovedSuccess(String targetName) => '$subspeciesMovedSuccessPrefix"$targetName".';
  static String moveSubspeciesError(Object e) => '$moveSubspeciesErrorPrefix$e';
  static String subspeciesSplitSuccess(String newName, int count) =>
      '$splitSubspeciesSuccessPrefix$newName$splitSubspeciesSuccessMiddle$count$splitSubspeciesSuccessSuffix';
  static String splitSubspeciesError(Object e) => '$splitSubspeciesErrorPrefix$e';

  // Visualización de entidades
  static String speciesWithSubspeciesDisplay(String speciesName, String subspeciesWithBrand) => '$speciesName - $subspeciesWithBrand';
  static const affirmativeYes = 'Sí';
  static const negativeNo = 'No';
  static String valueWithUnit(String value, String unit) => '$value $unit';
  static String propertyNameWithUnitText(String name, String unitText) => '$name$unitText';

  // Previsualización de instancias
  static String speciesTypeWithSpeciesNamePrefix(String type, String speciesName) => '$type • $speciesName • ';
  static String speciesTypeBulletPrefix(String type) => '$type • ';
  static String propertyWithColon(String propertyName, String displayValue) => '$propertyName: $displayValue';
  static String countWithStatus(int count, String status) => '$count $status';
  static String ancestorPathWithSpace(String path) => '$path ';

  // Adjuntos
  static String scanReverseFileName(String speciesName) => '${scanReverseTitle}_$speciesName${AppTechnicalStrings.extJpg}';

  // Gobernanza y confirmaciones inmediatas
  static const duplicateSpeciesDialogTitle = 'Nombre de especie duplicado';
  static String duplicateSpeciesPrompt(String name) => 'Ya existe una especie registrada con el nombre "$name". ¿Qué acción deseas realizar?';
  static const createSeparateSpeciesAction = 'Crear especie separada';
  static const mergeWithExistingSpeciesAction = 'Fusionar con existente';
  static const duplicatePhotoDialogTitle = 'Fotografía ya asignada';
  static String duplicatePhotoPrompt(String speciesName) => 'Esta imagen ya está asignada a la especie "$speciesName". ¿Deseas vincular la misma fotografía o elegir otra?';
  static const reusePhotoAction = 'Vincular la misma foto';
  static const deleteSpeciesWithInstancesTitle = 'Eliminar especie con instancias';
  static String deleteSpeciesWithInstancesPrompt(String speciesName, int count) =>
      count == 1
          ? 'La especie "$speciesName" tiene 1 instancia activa en el mundo. ¿Qué acción deseas realizar?'
          : 'La especie "$speciesName" tiene $count instancias activas en el mundo. ¿Qué acción deseas realizar?';
  static const reassignInstancesAction = 'Reasignar instancias';
  static const cascadeDeleteInstancesAction = 'Eliminar todo en cascada';
  static const deleteSubspeciesWithInstancesTitle = 'Eliminar subespecie con instancias';
  static String deleteSubspeciesWithInstancesPrompt(String subName, int count) =>
      count == 1
          ? 'La subespecie "$subName" tiene 1 instancia activa. ¿Qué acción deseas realizar?'
          : 'La subespecie "$subName" tiene $count instancias activas. ¿Qué acción deseas realizar?';
  static const deleteOnlySubspeciesTitle = 'Eliminar única subespecie';
  static String deleteOnlySubspeciesPrompt(String speciesName) =>
      'Esta es la única subespecie de "$speciesName". Si la eliminas, la especie quedará sin subespecies hasta que crees una nueva. ¿Deseas continuar?';
  static const subgroupDeviationTitle = 'Excepción de regla de subgrupo';
  static String subgroupDeviationPrompt(String type, String attribute) =>
      'El subgrupo "$type" habitualmente no utiliza $attribute. ¿Deseas guardar esta excepción o prefieres corregirla?';
  static const confirmExceptionAction = 'Guardar excepción';
  static const correctDataAction = 'Corregir datos';
  static const showNonStandardFields = 'Campos adicionales no estándar';
  static const hideNonStandardFields = 'Ocultar campos adicionales';
  static const nonStandardFieldsHint = 'Campos no habituales para este subgrupo que se guardarán como excepción.';
  static String originSpeciesLeftEmptyWarning(String speciesName) =>
      'La especie de origen "$speciesName" ha quedado sin subespecies y se conservará como plantilla vacía en el catálogo.';
  static String instancesReassignedSuccess(int count, String target) =>
      count == 1
          ? '1 instancia reasignada correctamente a "$target".'
          : '$count instancias reasignadas correctamente a "$target".';
  static String speciesDeletedWithCascadeSuccess(int count) =>
      count == 1
          ? 'Especie y 1 instancia eliminadas correctamente.'
          : 'Especie y $count instancias eliminadas correctamente.';
  static String duplicateSpeciesCardSubtitle(String name, int count) =>
      count == 1
          ? '1 especie registrada con el nombre "$name".'
          : '$count especies registradas con el nombre "$name".';
  static String duplicateSpeciesQuestion(String name) =>
      '¿Deseas fusionar las especies homónimas "$name" o renombrar alguna?';
  static String duplicatePhotoCardSubtitle(String name, String other) =>
      'La especie "$name" comparte fotografía con "$other".';
  static String duplicatePhotoQuestion(String name, String other) =>
      '¿Deseas mantener la misma fotografía o asignar imágenes separadas para "$name" y "$other"?';
  static String speciesWithoutSubspeciesSubtitle(String name) =>
      'La especie "$name" no tiene ninguna subespecie o variante registrada.';
  static String speciesWithoutSubspeciesQuestion(String name) =>
      '¿Deseas crear la subespecie "Genérica", agregar una nueva subespecie o eliminar "$name"?';
  static const generateGenericSubspeciesAction = 'Crear "Genérica"';
  static String unlinkedInstancesSubtitle(String displayName) =>
      'La instancia "$displayName" no tiene una subespecie válida asociada.';
  static String unlinkedInstancesQuestion(String displayName) =>
      '¿Deseas reasignar "$displayName" a una subespecie activa o darla de baja?';
  static String anomalousExpirationSubtitle(String displayName, String date) =>
      'Fecha de caducidad registrada: $date.';
  static String anomalousExpirationQuestion(String displayName) =>
      'La fecha de caducidad para "$displayName" parece incongruente. ¿Deseas ajustarla?';
  static const reassignToSubspeciesTitle = 'Reasignar a subespecie';
  static const reassignToSpeciesTitle = 'Reasignar a especie';
  static const selectTargetSubspeciesPrompt = 'Selecciona la subespecie de destino:';
  static const selectTargetSpeciesPrompt = 'Selecciona la especie de destino:';
  static const duplicateSpeciesMergedSuccess = 'Especies homónimas fusionadas correctamente.';
  static const speciesRenamedSuccess = 'Especie renombrada correctamente.';
  static const photoDecoupledSuccess = 'Fotografía desacoplada para esta especie.';
  static const genericSubspeciesGeneratedSuccess = 'Subespecie "Genérica" generada correctamente.';
  static const instanceReassignedSuccess = 'Instancia reasignada correctamente.';

  // Radar y calendario de vencimientos
  static const expirationsRadarTitle = 'Agenda';
  static const expirationsCalendarTitle = 'Calendario de vencimientos';
  static const expirationsViewAll = 'Ver todo';
  static const expirationsEmpty = 'Sin vencimientos registrados';
  static const expirationsEmptySubtitle = 'Las instancias con fecha de caducidad aparecerán aquí.';
  static const urgencyExpired = 'Vencido';
  static const urgencyCritical = 'Crítico';
  static const urgencyWarning = 'Por vencer';
  static const urgencyUpcoming = 'En observación';
  static const urgencySafe = 'A salvo';
  static String statusExpiredCount(int count) =>
      count == 1 ? '1 vencido' : '$count vencidos';
  static String statusExpiringSoonCount(int count) =>
      count == 1 ? '1 por vencer' : '$count por vencer';
  static String daysAgoExpired(int days) =>
      days == 1 ? 'Venció hace 1 día' : 'Venció hace $days días';
  static const expiredToday = 'Vence hoy';
  static const expiredYesterday = 'Venció ayer';
  static const expiresTomorrow = 'Vence mañana';
  static String daysLeftExpiring(int days) =>
      days == 1 ? 'Vence en 1 día' : 'Vence en $days días';
  static String monthsLeftExpiring(int months) =>
      months == 1 ? 'Vence en 1 mes' : 'Vence en $months meses';
  static const sectionExpired = 'Ya vencidos';
  static const sectionToday = 'Hoy';
  static const sectionThisWeek = 'Esta semana';
  static const sectionThisMonth = 'Este mes';
  static const sectionFuture = 'Próximos meses';
  static const viewModeMonthly = 'Mensual';
  static const viewModeAgenda = 'Agenda';
  static const actionExtendExpiration = 'Modificar fecha';
  static const actionLocateInInventory = 'Localizar';
  static const instanceConsumedSuccess = 'Instancia consumida y registrada en el historial.';
  static const filterAllUrgencies = 'Todas las urgencias';
  static const filterOnlyExpired = 'Solo vencidos';
  static const filterOnlyExpiringSoon = 'Por vencer en menos de 7 días';
  static const searchExpirationsHint = 'Buscar por nombre o especie...';
  static const noExpirationsForDate = 'No hay vencimientos registrados para este día.';

  // Mapa de actividad y registro de interacción
  static const activityHeatmapTitle = 'Actividad del sistema';
  static const activityHeatmapSubtitle = 'Frecuencia de interacción diaria.';
  static const currentStreakLabel = 'Racha activa';
  static const maxStreakLabel = 'Racha récord';
  static String streakDaysCount(int count) => count == 1 ? '1 día' : '$count días';
  static String totalEventsThisMonth(int count) => count == 1 ? '1 acción este mes' : '$count acciones este mes';
  static String totalEventsInYear(int count) => count == 1 ? '1 acción en el año' : '$count acciones en el año';
  static const heatmapLess = 'Menos';
  static const heatmapMore = 'Más';
  static String heatmapActivityCount(int count, String date) => count == 1 ? '1 acción el $date' : '$count acciones el $date';
  static String filteringByDate(String date) => 'Filtrando por fecha: $date';
  static const clearDateFilter = 'Quitar filtro';
  static const chromaDistributionTitle = 'Distribución cromática de actividad';

  // Curva de vida útil
  static const shelfLifeTitle = 'Curva de vida útil';
  static String shelfLifeConsumedRatio(int percent) => '$percent% consumida';
  static String shelfLifeRemaining(int days) => days == 1 ? '1 día restante' : '$days días restantes';
  static String shelfLifeStartPrefix(String dateStr) => 'Inicio: $dateStr';
  static String shelfLifeEndPrefix(String dateStr) => 'Vence: $dateStr';
  static String consumedEventDescription(String name) => 'Se consumió la instancia "$name".';
  static String labelWithCount(String label, int count) => '$label: $count';
  static String itemsCount(int count) => count == 1 ? '1 elemento' : '$count elementos';
  static String dateWithRelativeTime(String dateStr, String relativeStr) => '$dateStr, $relativeStr';
  static const currentStreakWithColon = 'Racha activa: ';
  static String streakWithFlame(int count) => '🔥 ${streakDaysCount(count)}';
  static String streakWithTrophy(int count) => '· 🏆 ${streakDaysCount(count)}';
  static String heatmapHeaderStats(int streak, int total) => '🔥 ${streakDaysCount(streak)} de racha · $total acciones en el año';
  static const weekdayShortLetters = ['L', 'M', 'X', 'J', 'V', 'S', 'D'];
  static const weekdayShortLettersSundayFirst = ['D', 'L', 'M', 'X', 'J', 'V', 'S'];
}
