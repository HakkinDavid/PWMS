import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/providers/providers.dart';
import '../../../core/widgets/app_toast.dart';
import '../../catalog/domain/catalog_item.dart';
import '../../catalog/domain/subspecies.dart';
import '../../catalog/infrastructure/product_lookup_service.dart';
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

  // Form states for Instantiation Tab
  CatalogItem? _selectedSpecies;
  Subspecies? _selectedSubspecies;
  String? _selectedLocationId;
  final _instantiateQtyCtrl = TextEditingController(text: '1');
  final _instantiateNotesCtrl = TextEditingController();
  DateTime? _instantiateExpDate;

  // Form states for New Species Tab
  late TextEditingController _speciesNameCtrl;
  late TextEditingController _brandCtrl;
  late TextEditingController _barcodeCtrl;
  late TextEditingController _speciesDescCtrl;
  String _speciesType = AppStrings.typeObject;
  bool _isUnique = false;
  bool _isNonPerishable = true;
  final _shelfLifeCtrl = TextEditingController(text: '30');

  // Form states for Location Tab
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

    if (result != null) {
      _speciesType = result.type;
      _tabController.animateTo(1); // Auto switch to creation tab when scanned
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
        expirationDate: _instantiateExpDate,
      );

      ref.read(entityListProvider.notifier).loadEntities();

      if (mounted) {
        AppToast.showSuccess(context, 'Instanciado correctamente.');
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) AppToast.showError(context, 'Error al instanciar: $e');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _handleSpeciesSubmit() async {
    final name = _speciesNameCtrl.text.trim();
    if (name.isEmpty) {
      AppToast.showRestriction(context, 'El nombre de la especie es obligatorio.');
      return;
    }

    setState(() => _isSaving = true);

    try {
      final catalogRepo = ref.read(catalogRepositoryProvider);
      final species = await catalogRepo.getOrCreateSpecies(
        name,
        type: _speciesType,
        description: _speciesDescCtrl.text.trim().isNotEmpty ? _speciesDescCtrl.text.trim() : null,
        isUnique: _isUnique,
      );

      final brand = _brandCtrl.text.trim();
      final barcode = _barcodeCtrl.text.trim();

      if (brand.isNotEmpty || barcode.isNotEmpty) {
        final subName = brand.isNotEmpty ? brand : name;
        final sub = Subspecies(
          id: '',
          speciesId: species.id,
          subspeciesName: subName,
          brand: brand.isNotEmpty ? brand : null,
          barcode: barcode.isNotEmpty ? barcode : null,
          createdAt: DateTime.now(),
        );
        await catalogRepo.saveSubspecies(sub);
      }

      ref.read(catalogListProvider.notifier).loadCatalog();

      if (mounted) {
        AppToast.showSuccess(context, 'Especie/Subespecie guardada correctamente.');
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) AppToast.showError(context, 'Error al guardar especie: $e');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _handleLocationSubmit() async {
    final name = _locNameCtrl.text.trim();
    if (name.isEmpty) {
      AppToast.showRestriction(context, 'El nombre de la ubicación es obligatorio.');
      return;
    }

    setState(() => _isSaving = true);

    try {
      final locRepo = ref.read(locationRepositoryProvider);
      final node = LocationNode(
        id: '',
        name: name,
        parentLocationId: _parentLocationId,
        description: _locDescCtrl.text.trim().isNotEmpty ? _locDescCtrl.text.trim() : null,
        createdAt: DateTime.now(),
      );
      await locRepo.saveNode(node);
      ref.read(locationNodeListProvider.notifier).loadNodes();

      if (mounted) {
        AppToast.showSuccess(context, 'Ubicación creada correctamente.');
        Navigator.pop(context);
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
    final catalogItems = ref.watch(catalogListProvider).asData?.value ?? [];
    final subspeciesList = ref.watch(subspeciesListProvider).asData?.value ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Centro de Creación'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.add_shopping_cart), text: 'Instanciar'),
            Tab(icon: Icon(Icons.category_outlined), text: 'Especie/Subespecie'),
            Tab(icon: Icon(Icons.account_tree_outlined), text: 'Ubicación'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: Instanciar Especie
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<CatalogItem>(
                  value: _selectedSpecies,
                  decoration: const InputDecoration(
                    labelText: 'Seleccionar Especie',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.inventory_2_outlined),
                  ),
                  items: catalogItems.map((c) => DropdownMenuItem(value: c, child: Text(c.name))).toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedSpecies = val;
                      _selectedSubspecies = subspeciesList.where((s) => s.speciesId == val?.id).firstOrNull;
                    });
                  },
                ),
                const SizedBox(height: 16),
                if (_selectedSpecies != null) ...[
                  DropdownButtonFormField<Subspecies>(
                    value: _selectedSubspecies,
                    decoration: const InputDecoration(
                      labelText: 'Subespecie / Marca',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.style_outlined),
                    ),
                    items: subspeciesList
                        .where((s) => s.speciesId == _selectedSpecies!.id)
                        .map((s) => DropdownMenuItem(value: s, child: Text(s.subspeciesName)))
                        .toList(),
                    onChanged: (val) => setState(() => _selectedSubspecies = val),
                  ),
                  const SizedBox(height: 16),
                ],
                ListTile(
                  title: Text(_selectedLocationId == null ? 'Sin ubicación asignada' : 'Ubicación elegida'),
                  subtitle: Text(_selectedLocationId ?? 'Toca para seleccionar contenedor o nodo'),
                  leading: const Icon(Icons.location_on_outlined),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    final res = await LocationTreePicker.show(context, initialSelectedId: _selectedLocationId);
                    if (res != null) setState(() => _selectedLocationId = res.locationId);
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _instantiateQtyCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Cantidad de Instancias',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.numbers),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _instantiateNotesCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Notas Adicionales',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.notes),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    icon: _isSaving ? const CircularProgressIndicator() : const Icon(Icons.check),
                    label: const Text('Confirmar Instanciación'),
                    onPressed: _isSaving ? null : _handleInstantiationSubmit,
                  ),
                ),
              ],
            ),
          ),

          // Tab 2: Nueva Especie / Subespecie
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.scannedResult != null) ...[
                  Card(
                    color: theme.colorScheme.primaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          const Icon(Icons.qr_code_scanner),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Datos detectados por escáner (${widget.scannedResult!.barcode ?? ""}). Revisa o edita antes de guardar.',
                              style: TextStyle(color: theme.colorScheme.onPrimaryContainer, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                TextField(
                  controller: _speciesNameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Nombre de la Especie (ej. Monitor, Libro)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.label_outlined),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _brandCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Marca / Subespecie / Autor (Opcional)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.branding_watermark_outlined),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _barcodeCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Código de Barras / ISBN (Opcional)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.qr_code_2),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _speciesType,
                  decoration: const InputDecoration(
                    labelText: 'Tipo de Especie',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    AppStrings.typeObject,
                    AppStrings.typeDocument,
                    AppStrings.typeProject,
                    AppStrings.typeMemory,
                  ].map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                  onChanged: (val) => setState(() => _speciesType = val ?? AppStrings.typeObject),
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('¿Es Único?'),
                  subtitle: const Text('Indica si solo puede existir 1 instancia en el mundo.'),
                  value: _isUnique,
                  onChanged: (v) => setState(() => _isUnique = v),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    icon: _isSaving ? const CircularProgressIndicator() : const Icon(Icons.save_outlined),
                    label: const Text('Guardar Especie / Subespecie'),
                    onPressed: _isSaving ? null : _handleSpeciesSubmit,
                  ),
                ),
              ],
            ),
          ),

          // Tab 3: Nueva Ubicación / Contenedor
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _locNameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Nombre de Ubicación / Contenedor',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.place_outlined),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _locDescCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Descripción / Notas',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.description_outlined),
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: Text(_parentLocationId == null ? 'Ubicación Raíz' : 'Ubicación Padre Asignada'),
                  subtitle: Text(_parentLocationId ?? 'Toca para anidar dentro de otra ubicación'),
                  leading: const Icon(Icons.account_tree_outlined),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    final res = await LocationTreePicker.show(context, initialSelectedId: _parentLocationId);
                    if (res != null) setState(() => _parentLocationId = res.locationId);
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    icon: _isSaving ? const CircularProgressIndicator() : const Icon(Icons.add_location_alt_outlined),
                    label: const Text('Crear Ubicación'),
                    onPressed: _isSaving ? null : _handleLocationSubmit,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
