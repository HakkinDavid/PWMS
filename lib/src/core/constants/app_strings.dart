class AppStrings {
  AppStrings._();

  // Navigation y General
  static const appName = 'PWMS';
  static const searchHint = 'Buscar especies, instancias o ubicaciones';
  static const rootLocationName = 'Mundo';
  static const cancel = 'Cancelar';
  static const save = 'Guardar';
  static const delete = 'Eliminar';
  static const edit = 'Editar';
  static const move = 'Trasladar';
  static const interactiveRelationsGraphTitle = 'Grafo Interactivo de Relaciones';
  static const noDirectedRelationsRegistered = 'Sin relaciones dirigidas registradas';
  static const currentInstanceLabel = 'Instancia Actual';
  static const targetEntityLabel = 'Entidad Destino';
  static const sourceEntityLabel = 'Entidad Origen';
  static const deleteRelationTooltip = 'Eliminar relación';
  static const centralInstanceLabel = 'Instancia Central';
  static const relationsLoadErrorPrefix = 'Error al cargar relaciones: ';
  static const link = 'Relacionar';
  static const attachFile = 'Adjuntar archivo';
  static const confirm = 'Confirmar';
  static const close = 'Cerrar';

  // Tabs y Navigation Shell
  static const tabHome = 'Inicio';
  static const tabEntities = 'Instancias';
  static const tabLocations = 'Ubicaciones';
  static const tabCatalog = 'Catálogo';
  static const tabHistory = 'Historial';
  static const tabSearch = 'Buscar';

  // Home Screen
  static const recentEntitiesTitle = 'Instancias recientes';
  static const activityTitle = 'Historial de actividad';
  static const universeCatalogTitle = 'Catálogo de especies';
  static const locationsTitle = 'Grafo de ubicaciones';

  // Entity Subgroups
  static const typeObject = 'Objeto';
  static const typeLivingBeing = 'Ser vivo';
  static const typeDocument = 'Documento';
  static const typeProject = 'Proyecto';
  static const typeMemory = 'Recuerdo';

  // Forms y Terminology
  static const registerObjectTitle = 'Registrar en el mundo';
  static const editInstanceTitle = 'Editar instancia';
  static const nameLabel = 'Nombre de la especie';
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
  static const isSaleLabel = '¿Registrar como venta?';
  static const takePhoto = 'Tomar fotografía';
  static const chooseGallery = 'Elegir de galería';
  static const photoLabel = 'Fotografía principal';
  static const chooseFromCatalog = 'Elegir del catálogo';
  static const showMoreFields = 'Campos adicionales';
  static const showFewerFields = 'Ocultar campos adicionales';
  static const registerAction = 'Registrar en el mundo';
  static const saveChangesAction = 'Guardar cambios';

  // Catalog
  static const catalogTitle = 'Catálogo de especies';
  static const newSpeciesTitle = 'Nueva especie';
  static const createSpeciesHeader = 'Crear especie en catálogo';
  static const saveSpeciesAction = 'Guardar especie';
  static const instantiateAction = 'Instanciar';
  static const emptyCatalog = 'El catálogo está vacío';
  static const singleInstanceError = 'Esta especie es única y ya existe en tu mundo';
  static const duplicateSpeciesNameError = 'Ya existe una especie con este nombre';
  static const duplicatePhotoError = 'Ya existe una especie con esta misma imagen';
  static const duplicateAttachmentError = 'Este archivo adjunto ya existe en la especie';

  // Locations Graph y Children
  static const locationsGraphTitle = 'Ubicaciones';
  static const newLocationTitle = 'Nueva ubicación';
  static const newSubLocationTitle = 'Nueva ubicación hija';
  static const childLocationsTitle = 'Ubicaciones hijas';
  static const createNodeHeader = 'Crear ubicación';
  static const locationNameLabel = 'Nombre de ubicación';
  static const locationDescriptionLabel = 'Descripción de ubicación';
  static const createObjectHere = 'Instanciar aquí';
  static const storedObjectsTitle = 'Instancias almacenadas aquí';
  static const emptyLocation = 'Ubicación vacía';
  static const selectLocationPrompt = 'Seleccionar ubicación';
  static const locationHasNoObjectsOrSublocations = 'Esta ubicación no contiene objetos ni sub-ubicaciones.';

  // Detail y Attachments
  static const locationGraphNode = 'Ubicación en el grafo';
  static const masterDescription = 'Descripción maestra';
  static const attachmentsTitle = 'Archivos y documentos adjuntos';
  static const emptyAttachments = 'Sin archivos adjuntos';
  static const deleteConfirmationTitle = 'Eliminar elemento';
  static const deleteConfirmationMessage = '¿Deseas eliminar este elemento de tu mundo?';
  static const zeroQuantityMessage = 'La magnitud llegó a cero. ¿Deseas eliminar la instancia?';

  // App Title y General
  static const appTitle = 'PWMS - Platinum World Management System';
  static const selectOptionPrompt = 'Seleccionar opción';
  static const selectMagnitudePrompt = 'Seleccionar Magnitud';
  static const all = 'Todos';
  static const errorPrefix = 'Error: ';
  static const errorGeneric = 'Ha ocurrido un error inesperado';
  static const change = 'Cambiar';
  static const viewAll = 'Ver todo';
  static const apply = 'Aplicar';

  // Units Registry
  static const unitCategoryPhysical = 'Magnitudes físicas y métricas';
  static const unitCategoryDigital = 'Digital';
  static const unitCategoryFinancial = 'Financiero y monetario';
  static const unitCategoryTime = 'Tiempo';
  static const unitCategoryAbstract = 'General';

  static const unitUnits = 'unidades';
  static const unitUnitSingle = 'unidad';
  static const unitPieces = 'piezas';
  static const unitKg = 'kg';
  static const unitGrams = 'g';
  static const unitLiters = 'L';
  static const unitMeters = 'm';

  // Storage Service
  static const fileNotFoundInStorage = 'Archivo no encontrado en almacenamiento local';
  static const fileDeleteFailure = 'Error al eliminar el archivo local';

  // Catalog Section y Requirements, Subspecies
  static const requirementsTitle = 'Relaciones de necesidad';
  static const addRequirement = 'Añadir Requisito';
  static const addRequirementTitle = 'Agregar Requisito NECESITA';
  static const noRequirements = 'Sin requisitos registrados';
  static const noRequirementsDefined = 'No hay necesidades definidas.';
  static const noCatalogSpeciesForRequirement = 'No hay especies en el catálogo para requerir.';
  static const selectRequiredSpeciesPrompt = 'Selecciona la especie requerida e indica la cantidad necesaria:';
  static const requiredSpeciesLabel = 'Especie Requerida';
  static const requirementTypeLabel = 'Tipo de Requisito';
  static const requirementTargetLabel = 'Especie o Elemento Requerido';
  static const quantityRequiredLabel = 'Cantidad Requerida';
  static const quantityRequiredHint = 'Ej. 6';
  static const requirementNotesLabel = 'Notas del Requisito';
  static const notesOptionalLabel = 'Notas (Opcional)';
  static const notesRequirementHint = 'Ej. Baterías para encendido';
  static const add = 'Agregar';
  static const needsPrefix = 'NECESITA';

  static const subspeciesOrBrandCommercialLabel = 'Subespecie';
  static const selectSubspeciesOrBrandPrompt = 'Selecciona subespecie';
  static const quantityToInstantiateLabel = 'Cantidad';
  static const subspeciesTitle = 'Subespecies';
  static const subspeciesCountTitle = 'Subespecies';
  static const addSubspecies = 'Añadir subespecie';
  static const addBrand = 'Agregar subespecie';
  static const noSubspecies = 'Sin subespecies registradas';
  static const noSubspeciesDefined = 'No hay subespecies.';
  static const subspeciesNameLabel = 'Nombre de Subespecie';
  static const editSubspecies = 'Editar Subespecie';
  static const deleteSubspecies = 'Eliminar Subespecie';

  static const defaultSubspeciesName = 'Estándar';
  static const viewCatalogSpecies = 'Ver Especie en Catálogo';
  static const viewSpeciesDetail = 'Ver detalle de especie';
  static const masterCatalogSpeciesBadge = 'ESPECIE DE CATÁLOGO MAESTRO';
  static const registeredPropertiesAndMagnitudes = 'Propiedades y Magnitudes Registradas';
  static const notInstantiatedYet = 'Esta especie aún no ha sido instanciada en tu mundo.';
  static const registeredInstance = 'Instancia registrada';
  static const speciesInstantiatedSuccess = 'Especie instanciada con éxito';
  static const selectSpeciesToInstantiate = 'Selecciona una especie para instanciar.';
  static const instantiateCatalogSpeciesHeader = 'Instanciar Especie de Catálogo';
  static const catalogSpeciesLabel = 'Especie de Catálogo:';
  static const selectSpeciesPrompt = 'Selecciona una especie...';
  static const physicalLocation = 'Ubicación Física';
  static const savedInContainer = 'Guardado en Contenedor';
  static const selectContainerPrompt = 'Selecciona Contenedor (Relación GUARDADO_EN):';
  static const noContainerObjectsAvailable = 'No hay objetos contenedores disponibles.';
  static const selectContainerObject = 'Selecciona objeto contenedor';
  static const containerObjectLabel = 'Objeto Contenedor';
  static const magnitudesAndSpecificProps = 'Magnitudes y Propiedades Específicas:';

  static const addPropertyOrUnitTitle = 'Agregar propiedad';
  static const propertyNameHint = 'Nombre de la propiedad (ej. Masa, Volumen, Longitud)';
  static const selectUnitPrompt = 'Seleccionar Unidad de Medida';
  static const editSubspeciesDraftTitle = 'Editar Subespecie (Borrador)';
  static const newSubspeciesVariantTitle = 'Nueva Subespecie (Variante)';
  static const subspeciesPhotoLabel = 'Foto de la Subespecie';
  static const nameOrVariantLabel = 'Nombre';
  static const nameOrVariantHint = 'Ej. Alkaline Heavy Duty';
  static const brandHint = 'Ej. Duracell';
  static const barcodeHint = 'Ej. 750123456789';
  static const notesSpecialEditionHint = 'Ej. Edición especial';
  static const editSpeciesTitle = 'Editar Especie';
  static const createSpeciesTitle = 'Crear Nueva Especie';
  static const noTemplate = 'Sin plantilla';
  static const selectBaseSpeciesPrompt = 'Seleccionar Especie Base';
  static const useSpeciesAsBaseTemplate = 'Usar especie como plantilla base';
  static const selectBaseTemplateHint = 'Seleccionar plantilla base...';
  static const nameIsImmutable = 'El nombre es inmutable';
  static const unitsAndMagnitudesTitle = 'Unidades y Magnitudes de Medida';
  static const addUnitAction = 'Agregar unidad de medida';
  static const noAdditionalUnitsAdded = 'Sin unidades adicionales agregadas.';
  static const removeUnitAction = 'Eliminar unidad de medida';
  static const subspeciesOrBrands = 'Subespecies';
  static const addBrandAction = 'Agregar subespecie';
  static const noSubspeciesOrBrandsAdded = 'Sin subespecies agregadas.';
  static const noBarcode = 'Sin barcode';

  static const chooseFromCatalogAction = 'Elegir del catálogo';
  static const createNewSpeciesAction = 'Crear nueva especie';
  static const createFirstSpeciesAction = 'Crear primera especie';

  // Entities y Templates
  static const customAttributesTitle = 'Atributos Personalizados';
  static const noCustomAttributesDefined = 'Sin atributos personalizados definidos.';
  static const addAttributeTitle = 'Agregar Atributo';
  static const attributeNameHint = 'Ej. Voltaje, Garantía, Color...';
  static const attributeValueHint = 'Ej. 220V, 2 años, Rojo...';
  static const addShort = 'Añadir';
  static const templateCustomCreate = 'Crear Plantilla Personalizada';
  static const templateNameLabel = 'Nombre de la plantilla';
  static const templateExamplesHint = 'Ej. Herramienta Eléctrica, Dispositivo...';
  static const templateUnitsHintLabel = 'Unidades de medida habituales (separadas por coma)';
  static const templateUnitsExamples = 'Ej. piezas, kg, metros';
  static const saveTemplateAction = 'Guardar Plantilla';
  static const customAttributeEditorTitle = 'Editor de Atributo Personalizado';
  static const attributeNameLabel = 'Nombre del Atributo';
  static const attributeTypeLabel = 'Tipo de Dato';
  static const attributeValueLabel = 'Valor';

  static const noEntitiesRegistered = 'No hay objetos registrados';
  static const instanceWorldHeader = 'INSTANCIA DEL MUNDO';
  static const addInstanceNotesHint = 'Añadir notas sobre esta instancia...';

  static const majorityDemographics = 'Demografía Mayoritaria';
  static const standardSpeciesProfile = 'Perfil estándar de la especie (sin notas diferenciales)';
  static const dynamicPopulationManagement = 'Gestión Dinámica de Población';
  static const populationManagementInstruction = '• Toque corto en -/+: Resta o suma 1 unidad\n• Toque largo en -/+: Activa el WheelPicker\n• Toque en la cifra: Escribe la población objetivo';
  static const populationLabel = 'Población';
  static const groupInstanceDetail = 'Detalle de Instancias en el Grupo';

  static const noInstancesAvailableToDelete = 'No hay instancias disponibles para eliminar.';
  static const addByWheelTitle = 'Añadir por Rueda (WheelPicker)';
  static const removeByWheelTitle = 'Eliminar por Rueda (WheelPicker)';
  static const directPopulationAdjustmentTitle = 'Ajuste Directo de Población';
  static const currentPopulationLabel = 'Población actual';
  static const newTargetPopulationLabel = 'Nueva Población Objetivo';
  static const applyCalculationAction = 'Aplicar Cálculo';
  static const noChangesLabel = 'Sin cambios';

  static const latestCatalogSpeciesTitle = 'Últimas especies en el catálogo';
  static const mustProvideEntityOrGroup = 'Debe proporcionarse entity o group';
  static const photoNotAvailable = 'Fotografía no disponible';

  static const selectTargetEntityError = 'Selecciona una entidad objetivo';
  static const selectDirectedRelationTypePrompt = 'Seleccionar Tipo de Relación Dirigida';
  static const directedRelationTypeLabel = 'Tipo de Relación Dirigida (Origen ➔ Destino)';
  static const searchTargetEntityLabel = 'Buscar Entidad Destino';
  static const noEntitiesAvailableToRelate = 'No hay entidades disponibles para relacionar.';
  static const createDirectedRelationAction = 'Crear Relación Dirigida';
  static const changePhotoAction = 'Cambiar';
  static const unitsLabel = 'unidades';
  static const selectFromCatalogChoice = 'Elegir del catálogo';
  static const createNewSpeciesChoice = 'Crear nueva especie';
  static const topLocationsTitle = 'Ubicaciones principales';
  static const objectsLabel = 'objetos';
  static const viewCatalogAction = 'Ver catálogo';
  static const viewAllAction = 'Ver todo';
  static const circularLocationError = 'No se puede mover una ubicación dentro de sí misma ni de sus ubicaciones hijas';

  static const noInstancesToDelete = 'No hay instancias disponibles para eliminar.';
  static const addByWheel = 'Añadir por Rueda (WheelPicker)';
  static const removeByWheel = 'Eliminar por Rueda (WheelPicker)';
  static const noChanges = 'Sin cambios';
  static const directPopulationAdjustment = 'Ajuste Directo de Población';
  static const currentPopulation = 'Población actual:';
  static const newTargetPopulation = 'Nueva Población Objetivo';
  static const targetPopulationHint = 'Ej. 15';
  static const applyCalculation = 'Aplicar Cálculo';

  static const instanceUpdatedSuccess = 'Instancia actualizada con éxito';
  static const updateErrorPrefix = 'Error al actualizar: ';
  static const instantiatedObject = 'Objeto Instanciado';
  static const graphLocationOrContainer = 'Ubicación en el Grafo (Lugar o Contenedor)';
  static const instanceNotesLabel = 'Notas';
  static const specificDetailsHint = 'Detalles específicos...';

  // Activity Logger
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
  static const noActivityRegistered = 'Sin actividad registrada';

  // Home Screen
  static const noRecentObjects = 'Sin objetos recientes';
  static const mainLocations = 'Ubicaciones principales';
  static const objectsCountSuffix = 'objetos';
  static const latestCatalogSpecies = 'Últimas especies en el catálogo';
  static const viewCatalog = 'Ver catálogo';
  static const noRecentActivity = 'Sin actividad reciente';

  // Locations y Places
  static const containerLabel = 'Contenedor';
  static const cannotMoveLocationSelfError = 'No se puede mover una ubicación dentro de sí misma ni de sus ubicaciones hijas';
  static const instantiateObjectHere = 'Instanciar objeto aquí';
  static const treeView = 'Vista de Árbol';
  static const graphView = 'Vista de Grafo';
  static const previousLocation = 'Ubicación previa';
  static const newGraphLocation = 'Nueva ubicación en Grafo';
  static const movedSuccessfullyGraph = 'trasladado exitosamente en el Grafo';
  static const moveErrorPrefix = 'Error al mover: ';
  static const moveInGraph = 'Trasladar en el Grafo';
  static const selectNewLocationOrContainer = 'Selecciona la nueva ubicación o contenedor:';
  static const createLocationOnTheFly = 'Crear nueva ubicación sobre la marcha';
  static const locationNameHint = 'Ej. Estantería #3, Garaje...';
  static const confirmMoveAction = 'Confirmar Traslado';

  // Relations
  static const circularRelationError = 'No se puede crear un vínculo circular: el elemento ya forma parte o contiene la entidad destino.';
  static const selectElementToRelate = 'Selecciona el elemento a relacionar';
  static const directedRelationCreatedSuccess = 'Relación dirigida creada con éxito';
  static const saveRelationErrorPrefix = 'Error al guardar relación: ';
  static const sourceObjectLabel = 'Objeto Origen';
  static const directedRelationInWorld = 'Relación Dirigida en tu Mundo';
  static const semanticRelationType = 'Tipo de vínculo semántico';
  static const targetOfRelation = 'Destino del vínculo:';
  static const noOtherRelationCandidates = 'No hay otros elementos disponibles para relacionar.';
  static const selectTargetElement = 'Selecciona elemento destino';
  static const targetObjectLabel = 'Objeto Destino';
  static const establishDirectedRelation = 'Establecer Vínculo Dirigido';
  static const selectTargetEntity = 'Selecciona una entidad objetivo';
  static const selectDirectedRelationType = 'Seleccionar Tipo de Relación Dirigida';
  static const searchTargetEntity = 'Buscar Entidad Destino';
  static const targetInstanceLabel = 'Instancia Destino';
  static const createDirectedRelation = 'Crear Relación Dirigida';
  static const interactiveRelationGraph = 'Grafo Interactivo de Relaciones';
  static const noDirectedRelations = 'Sin relaciones dirigidas registradas';
  static const currentInstance = 'Instancia Actual';
  static const externalEntity = 'Entidad Externa';
  static const sourceEntity = 'Entidad Origen';
  static const targetEntity = 'Entidad Destino';
  static const deleteRelation = 'Eliminar relación';
  static const loadRelationsErrorPrefix = 'Error al cargar relaciones: ';
  static const centralInstancePrefix = 'Instancia Central: ';

  // Search Screen
  static const objectsCategory = 'Objetos';
  static const historyCategory = 'Historial';
  static const noHistoryResults = 'Sin resultados de historial';
}
