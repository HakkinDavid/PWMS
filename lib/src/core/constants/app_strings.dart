class AppStrings {
  AppStrings._();

  // Navigation & General
  static const appName = 'PWMS';
  static const searchHint = 'Buscar objetos o especies';
  static const rootLocationName = 'Mundo';
  static const cancel = 'Cancelar';
  static const save = 'Guardar';
  static const delete = 'Eliminar';
  static const edit = 'Editar';
  static const archive = 'Archivar';
  static const unarchive = 'Desarchivar';
  static const move = 'Trasladar';
  static const link = 'Relacionar';
  static const attachFile = 'Adjuntar archivo';
  static const confirm = 'Confirmar';
  static const close = 'Cerrar';

  // Home Screen
  static const recentEntitiesTitle = 'Objetos recientes';
  static const collectionsTitle = 'Colecciones del mundo';
  static const activityTitle = 'Historial de actividad';
  static const universeCatalogTitle = 'Universo de Objetos';
  static const locationsTitle = 'Grafo de Ubicaciones';

  // Entity Types
  static const typeObject = 'Objeto';
  static const typeDocument = 'Documento';
  static const typeProject = 'Proyecto';
  static const typeMemory = 'Recuerdo';

  // Forms
  static const registerObjectTitle = 'Registrar objeto';
  static const editInstanceTitle = 'Editar instancia';
  static const nameLabel = 'Nombre del objeto';
  static const typeLabel = 'Tipo de objeto';
  static const locationLabel = 'Ubicación';
  static const quantityLabel = 'Cantidad';
  static const unitLabel = 'Unidad';
  static const barcodeLabel = 'Código de barras';
  static const notesLabel = 'Notas de instancia';
  static const descriptionLabel = 'Descripción técnica';
  static const brandLabel = 'Marca';
  static const takePhoto = 'Tomar fotografía';
  static const chooseGallery = 'Elegir de galería';
  static const photoLabel = 'Fotografía del objeto';
  static const chooseFromCatalog = 'Elegir del catálogo';
  static const showMoreFields = 'Campos adicionales';
  static const showFewerFields = 'Ocultar campos adicionales';
  static const registerAction = 'Registrar en el mundo';
  static const saveChangesAction = 'Guardar cambios';

  // Catalog
  static const catalogTitle = 'Catálogo Maestro';
  static const newSpeciesTitle = 'Nueva Especie';
  static const createSpeciesHeader = 'Crear especie en catálogo';
  static const saveSpeciesAction = 'Guardar especie';
  static const instantiateAction = 'Instanciar';
  static const emptyCatalog = 'El catálogo está vacío';
  static const singleInstanceError = 'Este elemento ya existe en tu mundo';

  // Locations Graph
  static const locationsGraphTitle = 'Ubicaciones';
  static const newLocationTitle = 'Nueva Ubicación';
  static const newSubLocationTitle = 'Nueva Sub-ubicación';
  static const createNodeHeader = 'Crear ubicación';
  static const locationNameLabel = 'Nombre de ubicación';
  static const locationDescriptionLabel = 'Descripción de ubicación';
  static const createObjectHere = 'Crear objeto aquí';
  static const storedObjectsTitle = 'Objetos almacenados aquí';
  static const emptyLocation = 'Ubicación vacía';
  static const selectLocationPrompt = 'Seleccionar ubicación';

  // Detail & Attachments
  static const locationGraphNode = 'Ubicación en el grafo';
  static const masterDescription = 'Descripción maestra';
  static const attachmentsTitle = 'Archivos y documentos adjuntos';
  static const emptyAttachments = 'Sin archivos adjuntos';
  static const deleteConfirmationTitle = 'Eliminar elemento';
  static const deleteConfirmationMessage = 'Deseas eliminar este elemento de tu mundo';
  static const zeroQuantityMessage = 'La cantidad llegó a cero. Deseas eliminar el elemento';

  // Relations
  static const relationsTitle = 'Relación dirigida';
  static const relationTypeLabel = 'Tipo de vínculo';
  static const targetEntityLabel = 'Destino del vínculo';
  static const establishRelationAction = 'Establecer vínculo';
  static const originLabel = 'Origen';
  static const noRelationCandidates = 'No hay elementos disponibles para relacionar';
}
