class AppStrings {
  AppStrings._();

  // Navigation & General
  static const appName = 'PWMS';
  static const searchHint = 'Buscar especies, instancias o ubicaciones';
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

  // Tabs & Navigation Shell
  static const tabHome = 'Inicio';
  static const tabEntities = 'Instancias';
  static const tabLocations = 'Ubicaciones';
  static const tabCatalog = 'Catálogo';
  static const tabSearch = 'Buscar';

  // Home Screen
  static const recentEntitiesTitle = 'Instancias recientes';
  static const activityTitle = 'Historial de actividad';
  static const universeCatalogTitle = 'Catálogo de especies';
  static const locationsTitle = 'Grafo de ubicaciones';

  // Entity Subgroups / Types
  static const typeObject = 'Objeto';
  static const typeLivingBeing = 'Ser vivo';
  static const typeDocument = 'Documento';
  static const typeProject = 'Proyecto';
  static const typeMemory = 'Recuerdo';

  // Forms & Terminology
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

  // Locations Graph & Children
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

  // Detail & Attachments
  static const locationGraphNode = 'Ubicación en el grafo';
  static const masterDescription = 'Descripción maestra';
  static const attachmentsTitle = 'Archivos y documentos adjuntos';
  static const emptyAttachments = 'Sin archivos adjuntos';
  static const deleteConfirmationTitle = 'Eliminar elemento';
  static const deleteConfirmationMessage = '¿Deseas eliminar este elemento de tu mundo?';
  static const zeroQuantityMessage = 'La magnitud llegó a cero. ¿Deseas eliminar la instancia?';

  // Relations
  static const relationsTitle = 'Relación dirigida';
  static const relationTypeLabel = 'Tipo de vínculo';
  static const targetEntityLabel = 'Destino del vínculo';
  static const establishRelationAction = 'Establecer vínculo';
  static const originLabel = 'Origen';
  static const noRelationCandidates = 'No hay elementos disponibles para relacionar';
}
