import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/domain/domain_rules.dart';
import '../../../core/providers/providers.dart';
import '../../../core/storage/file_storage_service.dart';
import '../../../core/widgets/app_toast.dart';
import '../../catalog/domain/catalog_item.dart';
import '../../catalog/domain/subspecies.dart';
import '../../catalog/domain/taxonomy/perishability_inference_engine.dart';
import '../../catalog/infrastructure/product_lookup_service.dart';
import '../../catalog/presentation/web_image_picker_dialog.dart';
import '../../locations/domain/location_node.dart';
import '../../locations/presentation/location_tree_picker.dart';

class CreateMasterScreen extends ConsumerStatefulWidget {
  final ProductLookupResult? scannedResult;
  final int initialTabIndex;

  const CreateMasterScreen({
    super.key,
    this.scannedResult,
    this.initialTabIndex = 0,
  });

  @override
  ConsumerState<CreateMasterScreen> createState() => _CreateMasterScreenState();
}

class _CreateMasterScreenState extends ConsumerState<CreateMasterScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // --- TAB 1: INSTANCIAR ---
  CatalogItem? _selectedSpecies;
  Subspecies? _selectedSubspecies;
  String? _selectedLocationId;
  final _instantiateQtyCtrl = TextEditingController(text: '1');
  final _instantiateNotesCtrl = TextEditingController();
  DateTime? _instantiateExpDate;
  final Map<String, double> _instantiateCustomMagValues = {};

  // --- TAB 2: NUEVA ESPECIE / SUBESPECIE ---
  late TextEditingController _speciesNameCtrl;
  late TextEditingController _brandCtrl;
  late TextEditingController _barcodeCtrl;
  late TextEditingController _speciesDescCtrl;
  late TextEditingController _shelfLifeCtrl;
  String _speciesType = AppStrings.typeObject;
  bool _isUnique = false;
  bool _isNonPerishable = true;

  XFile? _selectedImage;
  String? _webImageLocalPath;

  // List of property definitions for new species: propertyName -> unitSymbol
  final List<Map<String, String>> _speciesPropertyDefs = [];
  final List<Subspecies> _draftSubspecies = [];

  // --- TAB 3: NUEVA UBICACIÓN ---
  final _locNameCtrl = TextEditingController();
  final _locDescCtrl = TextEditingController();
  String? _parentLocationId;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: widget.initialTabIndex);

    final result = widget.scannedResult;
    _speciesNameCtrl = TextEditingController(text: result?.generalSpeciesName ?? '');
    _brandCtrl = TextEditingController(text: result?.brand ?? '');
    _barcodeCtrl = TextEditingController(text: result?.barcode ?? '');
    _speciesDescCtrl = TextEditingController(text: result?.description ?? '');
    _shelfLifeCtrl = TextEditingController(text: '30');

    if (result != null) {
      _speciesType = result.type;
      if (result.localPhotoPath != null) {
        _selectedImage = XFile(result.localPhotoPath!);
      }

      if (result.subspeciesName.isNotEmpty) {
        _draftSubspecies.add(Subspecies(
          id: const Uuid().v4(),
          speciesId: '',
          subspeciesName: result.subspeciesName,
          brand: result.brand,
          barcode: result.barcode,
          photoPath: result.localPhotoPath,
          createdAt: DateTime.now(),
        ));
      }

      _tabController.animateTo(1); // auto switch to New Species tab when scanned
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _instantiateQtyCtrl.dispose();
    _instantiateNotesCtrl.dispose();
    _speciesNameCtrl.dispose();
    _brandCtrl.dispose();
    _barcodeCtrl.dispose();
    _speciesDescCtrl.dispose();
    _shelfLifeCtrl.dispose();
    _locNameCtrl.dispose();
    _locDescCtrl.dispose();
    super.dispose();
  }

  // --- TAB 1 ACTIONS ---
  Future<void> _handleInstantiationSubmit() async {
    if (_selectedSpecies == null) {
      AppToast.showRestriction(context, 'Selecciona una especie para instanciar.');
      return;
    }

    final double qty = double.tryParse(_instantiateQtyCtrl.text.trim()) ?? 1.0;
    setState(() => _isSaving = true);

    try {
      final repo = ref.read(entityRepositoryProvider);
      await repo.instantiateOrMerge(
        _selectedSpecies!.id,
        _selectedLocationId,
        qty,
        subspeciesId: _selectedSubspecies?.id,
        notes: _instantiateNotesCtrl.text.trim().isNotEmpty ? _instantiateNotesCtrl.text.trim() : null,
        customMagnitudeValues: _instantiateCustomMagValues.isNotEmpty ? _instantiateCustomMagValues : null,
        expirationDate: _instantiateExpDate,
      );

      ref.invalidate(entityListProvider);
      ref.invalidate(catalogListProvider);

      if (mounted) {
        AppToast.showSuccess(context, 'Instanciación creada exitosamente.');
        context.pop();
      }
    } catch (e) {
      if (mounted) AppToast.showError(context, 'Error al instanciar: $e');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  // --- TAB 2 ACTIONS ---
  Future<void> _handleNewSpeciesSubmit() async {
    final name = _speciesNameCtrl.text.trim();
    if (name.isEmpty) {
      AppToast.showRestriction(context, 'El nombre de la especie es obligatorio.');
      return;
    }

    setState(() => _isSaving = true);

    try {
      final fileStorage = ref.read(fileStorageServiceProvider);
      String? mainPhotoPath;

      if (_selectedImage != null) {
        mainPhotoPath = await fileStorage.saveFile(_selectedImage!.path);
      } else if (_webImageLocalPath != null) {
        mainPhotoPath = await fileStorage.saveFile(_webImageLocalPath!);
      }

      final catalogRepo = ref.read(catalogRepositoryProvider);

      // Create main species item
      final species = CatalogItem(
        id: const Uuid().v4(),
        name: name,
        type: _speciesType,
        description: _speciesDescCtrl.text.trim().isNotEmpty ? _speciesDescCtrl.text.trim() : null,
        mainPhotoPath: mainPhotoPath,
        isUnique: (_speciesType == AppStrings.typeDocument || _speciesType == AppStrings.typeProject || _speciesType == AppStrings.typeMemory) ? true : _isUnique,
        isNonPerishable: _isNonPerishable,
        defaultShelfLifeDays: !_isNonPerishable ? (int.tryParse(_shelfLifeCtrl.text.trim()) ?? 30) : null,
        createdAt: DateTime.now(),
      );

      await catalogRepo.saveCatalogItem(species);

      // Add draft subspecies if any
      for (final sub in _draftSubspecies) {
        final newSub = sub.copyWith(speciesId: species.id);
        await catalogRepo.saveSubspecies(newSub);
      }

      ref.invalidate(catalogListProvider);

      if (mounted) {
        AppToast.showSuccess(context, 'Especie "${species.name}" creada exitosamente.');
        setState(() {
          _selectedSpecies = species;
          _tabController.animateTo(0); // Switch to instantiate tab
        });
      }
    } catch (e) {
      if (mounted) AppToast.showError(context, 'Error al crear especie: $e');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  // --- TAB 3 ACTIONS ---
  Future<void> _handleNewLocationSubmit() async {
    final name = _locNameCtrl.text.trim();
    if (name.isEmpty) {
      AppToast.showRestriction(context, 'El nombre de la ubicación es obligatorio.');
      return;
    }

    setState(() => _isSaving = true);

    try {
      final locRepo = ref.read(locationRepositoryProvider);
      final newLocation = LocationNode(
        id: const Uuid().v4(),
        name: name,
        description: _locDescCtrl.text.trim().isNotEmpty ? _locDescCtrl.text.trim() : null,
        parentLocationId: _parentLocationId,
        createdAt: DateTime.now(),
      );

      await locRepo.saveNode(newLocation);
      ref.invalidate(locationNodeListProvider);

      if (mounted) {
        AppToast.showSuccess(context, 'Ubicación "$name" creada exitosamente.');
        _locNameCtrl.clear();
        _locDescCtrl.clear();
      }
    } catch (e) {
      if (mounted) AppToast.showError(context, 'Error al crear ubicación: $e');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Centro de Creación Maestro'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.add_shopping_cart), text: 'Instanciar'),
            Tab(icon: Icon(Icons.category_outlined), text: 'Nueva Especie'),
            Tab(icon: Icon(Icons.add_location_alt_outlined), text: 'Nueva Ubicación'),
          ],
        ),
      ),
      body: _isSaving
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildInstantiateTab(theme),
                _buildNewSpeciesTab(theme),
                _buildNewLocationTab(theme),
              ],
            ),
    );
  }

  // TAB 1: INSTANCIAR
  Widget _buildInstantiateTab(ThemeData theme) {
    final catalogState = ref.watch(catalogListProvider);
    final subspeciesState = ref.watch(subspeciesListProvider);
    final locationsState = ref.watch(locationNodeListProvider);

    final speciesList = catalogState.asData?.value ?? [];
    final allSubspecies = subspeciesState.asData?.value ?? [];
    final locations = locationsState.asData?.value ?? [];

    final availableSubspecies = _selectedSpecies != null
        ? allSubspecies.where((s) => s.speciesId == _selectedSpecies!.id).toList()
        : <Subspecies>[];

    final selectedLocNode = locations.where((l) => l.id == _selectedLocationId).firstOrNull;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('1. Seleccionar Especie', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          DropdownButtonFormField<CatalogItem>(
            value: _selectedSpecies,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.style_outlined),
              labelText: 'Especie del Catálogo',
            ),
            items: speciesList.map((s) => DropdownMenuItem(value: s, child: Text(s.name))).toList(),
            onChanged: (val) {
              setState(() {
                _selectedSpecies = val;
                _selectedSubspecies = null;
              });
            },
          ),
          const SizedBox(height: 16),

          if (availableSubspecies.isNotEmpty) ...[
            Text('Subespecie / Variante', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButtonFormField<Subspecies>(
              value: _selectedSubspecies,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.branding_watermark_outlined),
                labelText: 'Variante o Marca (Opcional)',
              ),
              items: availableSubspecies.map((sub) => DropdownMenuItem(value: sub, child: Text('${sub.subspeciesName} ${sub.brand != null ? "(${sub.brand})" : ""}'))).toList(),
              onChanged: (val) => setState(() => _selectedSubspecies = val),
            ),
            const SizedBox(height: 16),
          ],

          Text('2. Cantidad & Ubicación', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _instantiateQtyCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Cantidad de Instancias',
                    prefixIcon: Icon(Icons.numbers),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: InkWell(
                  onTap: () async {
                    final res = await LocationTreePicker.show(context);
                    if (res != null) {
                      setState(() => _selectedLocationId = res.locationId);
                    }
                  },
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Ubicación',
                      prefixIcon: Icon(Icons.location_on_outlined),
                    ),
                    child: Text(selectedLocNode?.name ?? 'Sin Ubicación', maxLines: 1, overflow: TextOverflow.ellipsis),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          if (_selectedSpecies != null && !_selectedSpecies!.isNonPerishable) ...[
            Text('Fecha de Caducidad', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            InkWell(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now().add(Duration(days: _selectedSpecies!.defaultShelfLifeDays ?? 30)),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 3650)),
                );
                if (picked != null) setState(() => _instantiateExpDate = picked);
              },
              child: InputDecorator(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.calendar_today_outlined),
                  labelText: 'Seleccionar Caducidad',
                ),
                child: Text(_instantiateExpDate != null ? _instantiateExpDate.toString().substring(0, 10) : 'Sin fecha asignada'),
              ),
            ),
            const SizedBox(height: 16),
          ],

          Text('Notas u Observaciones', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            controller: _instantiateNotesCtrl,
            decoration: const InputDecoration(
              labelText: 'Notas opcionales',
              prefixIcon: Icon(Icons.notes_outlined),
            ),
          ),
          const SizedBox(height: 32),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: _handleInstantiationSubmit,
              icon: const Icon(Icons.check),
              label: const Text('Confirmar e Instanciar'),
            ),
          ),
        ],
      ),
    );
  }

  // TAB 2: NUEVA ESPECIE
  Widget _buildNewSpeciesTab(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen y Botón Web
          Center(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () async {
                    final picker = ImagePicker();
                    final img = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
                    if (img != null) setState(() => _selectedImage = img);
                  },
                  child: Container(
                    height: 110,
                    width: 110,
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: theme.dividerColor),
                    ),
                    child: _selectedImage != null
                        ? ClipRRect(borderRadius: BorderRadius.circular(20), child: Image.file(File(_selectedImage!.path), fit: BoxFit.cover))
                        : (_webImageLocalPath != null && File(_webImageLocalPath!).existsSync())
                            ? ClipRRect(borderRadius: BorderRadius.circular(20), child: Image.file(File(_webImageLocalPath!), fit: BoxFit.cover))
                            : const Icon(Icons.add_a_photo_outlined, size: 40),
                  ),
                ),
                TextButton.icon(
                  onPressed: () async {
                    final query = _speciesNameCtrl.text.trim();
                    if (query.isEmpty) {
                      AppToast.showRestriction(context, 'Ingresa un nombre para buscar foto');
                      return;
                    }
                    await WebImagePickerDialog.show(context, searchQuery: query);
                  },
                  icon: const Icon(Icons.image_search, size: 18),
                  label: const Text('Buscar foto en Web'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Subgroup Type Chips
          Text('Tipo de Subgrupo', style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            children: [
              AppStrings.typeObject,
              AppStrings.typeLivingBeing,
              AppStrings.typeDocument,
              AppStrings.typeProject,
              AppStrings.typeMemory,
            ].map((t) => ChoiceChip(
              label: Text(t),
              selected: _speciesType == t,
              onSelected: (sel) {
                if (sel) setState(() => _speciesType = t);
              },
            )).toList(),
          ),
          const SizedBox(height: 16),

          TextField(
            controller: _speciesNameCtrl,
            decoration: const InputDecoration(labelText: 'Nombre de la Especie *', prefixIcon: Icon(Icons.auto_awesome)),
          ),
          const SizedBox(height: 12),

          if (_speciesType == AppStrings.typeObject) ...[
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _brandCtrl,
                    decoration: const InputDecoration(labelText: 'Marca (Opcional)', prefixIcon: Icon(Icons.branding_watermark_outlined)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _barcodeCtrl,
                    decoration: const InputDecoration(labelText: 'Código de Barras (Opcional)', prefixIcon: Icon(Icons.qr_code_2)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],

          TextField(
            controller: _speciesDescCtrl,
            decoration: const InputDecoration(labelText: 'Descripción (Opcional)', prefixIcon: Icon(Icons.description_outlined)),
          ),
          const SizedBox(height: 16),

          // Perecedero Switch
          SwitchListTile(
            title: const Text('¿Es Inperecedero?'),
            subtitle: const Text('Si no vence (ej. herramientas, muebles)'),
            value: _isNonPerishable,
            onChanged: (val) => setState(() => _isNonPerishable = val),
          ),

          if (!_isNonPerishable)
            TextField(
              controller: _shelfLifeCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Días de Vida Útil Sugeridos', prefixIcon: Icon(Icons.timer_outlined)),
            ),

          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: _handleNewSpeciesSubmit,
              icon: const Icon(Icons.save),
              label: const Text('Guardar Especie en Catálogo'),
            ),
          ),
        ],
      ),
    );
  }

  // TAB 3: NUEVA UBICACIÓN
  Widget _buildNewLocationTab(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Crear Nueva Ubicación o Contenedor', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          TextField(
            controller: _locNameCtrl,
            decoration: const InputDecoration(
              labelText: 'Nombre de Ubicación *',
              prefixIcon: Icon(Icons.location_on_outlined),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _locDescCtrl,
            decoration: const InputDecoration(
              labelText: 'Descripción / Detalles',
              prefixIcon: Icon(Icons.notes_outlined),
            ),
          ),
          const SizedBox(height: 16),

          InkWell(
            onTap: () async {
              final res = await LocationTreePicker.show(context);
              if (res != null) {
                setState(() => _parentLocationId = res.locationId);
              }
            },
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Ubicación Padre (Opcional)',
                prefixIcon: Icon(Icons.folder_outlined),
              ),
              child: Text(_parentLocationId ?? 'Ninguna (Nivel Raíz)'),
            ),
          ),
          const SizedBox(height: 32),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: _handleNewLocationSubmit,
              icon: const Icon(Icons.add_location),
              label: const Text('Crear Ubicación'),
            ),
          ),
        ],
      ),
    );
  }
}
