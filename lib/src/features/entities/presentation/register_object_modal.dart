import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart' as img;
import 'package:uuid/uuid.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/units_registry.dart';
import '../../../core/providers/providers.dart';
import '../../catalog/domain/catalog_item.dart';
import '../../catalog/domain/subspecies.dart';
import '../../catalog/presentation/add_edit_subspecies_modal.dart';
import '../../catalog/presentation/auto_fill_scanner_widget.dart';
import '../../catalog/presentation/guided_dual_scan_widget.dart';
import '../../catalog/presentation/species_form_modal.dart';
import '../../catalog/presentation/species_tile.dart';
import '../../catalog/presentation/subspecies_section_widget.dart';
import '../domain/instance_magnitude.dart';
import 'instantiate_species_sheet.dart';

enum RegisterModalMode { selectFromCatalog, createNewSpecies, addSubspeciesToExisting, autoFillScanner, numismaticScanner }

class RegisterObjectModal extends ConsumerStatefulWidget {
  final String? initialLocationId;
  final bool startInCreateSpecies;
  final dynamic scannedResult;

  const RegisterObjectModal({
    super.key,
    this.initialLocationId,
    this.startInCreateSpecies = false,
    this.scannedResult,
  });

  static Future<void> show(
    BuildContext context, {
    String? initialLocationId,
    bool startInCreateSpecies = false,
    dynamic scannedResult,
  }) {
    return showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => RegisterObjectModal(
        initialLocationId: initialLocationId,
        startInCreateSpecies: startInCreateSpecies,
        scannedResult: scannedResult,
      ),
    );
  }

  @override
  ConsumerState<RegisterObjectModal> createState() => _RegisterObjectModalState();
}

class _RegisterObjectModalState extends ConsumerState<RegisterObjectModal> {
  late RegisterModalMode _currentMode;
  String? _selectedSpeciesIdForSubspecies;
  dynamic _activeScannedResult;

  @override
  void initState() {
    super.initState();
    _activeScannedResult = widget.scannedResult;
    _currentMode = (widget.startInCreateSpecies || _activeScannedResult != null)
        ? RegisterModalMode.createNewSpecies
        : RegisterModalMode.selectFromCatalog;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final catalogState = ref.watch(catalogListProvider);
    final catalogItems = catalogState.asData?.value ?? [];

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 14,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.94, // Modal más grande (94% screen height)
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.withAlpha(100),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Segmented Button
            SizedBox(
              width: double.infinity,
              child: SegmentedButton<RegisterModalMode>(
                showSelectedIcon: false,
                style: SegmentedButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                ),
                segments: const [
                  ButtonSegment(
                    value: RegisterModalMode.selectFromCatalog,
                    label: Text(AppStrings.instantiateTab, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                    icon: Icon(Icons.public, size: 14),
                  ),
                  ButtonSegment(
                    value: RegisterModalMode.createNewSpecies,
                    label: Text(AppStrings.createSpeciesTab, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                    icon: Icon(Icons.add, size: 14),
                  ),
                  ButtonSegment(
                    value: RegisterModalMode.addSubspeciesToExisting,
                    label: Text(AppStrings.addSubspeciesTab, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                    icon: Icon(Icons.branding_watermark, size: 14),
                  ),
                  ButtonSegment(
                    value: RegisterModalMode.autoFillScanner,
                    label: Text(AppStrings.autoFillTab, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                    icon: Icon(Icons.qr_code_scanner, size: 14),
                  ),
                  ButtonSegment(
                    value: RegisterModalMode.numismaticScanner,
                    label: Text('Numismática', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                    icon: Icon(Icons.monetization_on, size: 14),
                  ),
                ],
                selected: {_currentMode},
                onSelectionChanged: (set) {
                  setState(() => _currentMode = set.first);
                },
              ),
            ),
            const SizedBox(height: 12),

            // Body
            Expanded(
              child: _buildBodyView(context, catalogState, catalogItems),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBodyView(
    BuildContext context,
    AsyncValue<List<CatalogItem>> catalogState,
    List<CatalogItem> catalogItems,
  ) {
    switch (_currentMode) {
      case RegisterModalMode.selectFromCatalog:
        return _buildBrowseCatalogView(context, catalogState);
      case RegisterModalMode.createNewSpecies:
        return SpeciesFormModal(
          scannedResult: _activeScannedResult,
          onSpeciesSaved: (createdSpecies) {
            Navigator.pop(context);
            InstantiateSpeciesSheet.show(
              context,
              species: createdSpecies,
              initialLocationId: widget.initialLocationId,
            );
          },
        );
      case RegisterModalMode.addSubspeciesToExisting:
        return _buildAddSubspeciesToExistingView(context, catalogItems);
      case RegisterModalMode.autoFillScanner:
        return AutoFillScannerWidget(
          initialLocationId: widget.initialLocationId,
          onScannedResult: (result) {
            final catalog = catalogItems;
            final genName = result.generalSpeciesName.trim().toLowerCase();
            final matchingSpecies = catalog.where((c) => c.name.trim().toLowerCase() == genName && genName.isNotEmpty).firstOrNull;

            if (matchingSpecies != null) {
              setState(() {
                _selectedSpeciesIdForSubspecies = matchingSpecies.id;
                _currentMode = RegisterModalMode.addSubspeciesToExisting;
              });

              final subName = result.subspeciesName.trim();
              final finalSubName = subName.isNotEmpty ? subName : matchingSpecies.name;

              AddEditSubspeciesModal.show(
                context,
                species: matchingSpecies,
                initialSubspecies: Subspecies(
                  id: const Uuid().v4(),
                  speciesId: matchingSpecies.id,
                  subspeciesName: finalSubName,
                  brand: result.brand?.toString(),
                  barcode: result.barcode?.toString(),
                  photoPath: result.localPhotoPath?.toString() ?? result.photoUrl?.toString(),
                  notes: result.description?.toString(),
                  createdAt: DateTime.now(),
                ),
                isFromAutoFill: true,
              ).then((newSub) async {
                if (newSub != null && mounted) {
                  await ref.read(catalogRepositoryProvider).saveSubspecies(newSub);
                  ref.invalidate(catalogListProvider);
                  ref.invalidate(subspeciesListProvider);
                  ref.invalidate(entityListProvider);
                }
              });
            } else {
              setState(() {
                _activeScannedResult = result;
                _currentMode = RegisterModalMode.createNewSpecies;
              });
            }
          },
        );
      case RegisterModalMode.numismaticScanner:
        return GuidedDualScanWidget(
          onScannedResult: (result) async {
            if (!mounted) return;
            final catalogRepo = ref.read(catalogRepositoryProvider);
            final catalog = catalogItems;

            final speciesName = result.generalSpeciesName.trim().isNotEmpty
                ? result.generalSpeciesName.trim()
                : result.speciesType;

            var matchingSpecies = catalog.where((c) => c.name.trim().toLowerCase() == speciesName.toLowerCase()).firstOrNull;

            if (matchingSpecies == null) {
              matchingSpecies = await catalogRepo.getOrCreateSpecies(
                speciesName,
                type: 'Objeto',
                description: 'Especie para piezas numismáticas (${result.speciesType})',
                mainPhotoPath: result.obversePhotoPath,
              );
            }

            final currencyUnit = (result.currencyCode != null && result.currencyCode!.trim().isNotEmpty)
                ? result.currencyCode!.trim()
                : 'MXN';

            // Registrar magnitudes 4NF relacionales de la especie con tipos primitivos:
            // 1. Valor nominal (tipo: real, unidad: divisa)
            // 2. Acuñación (tipo: integer, unidad: año)
            // 3. Divisa (tipo: string, sin unidad)
            // 4. Material (tipo: string, sin unidad)
            // 5. Grado (tipo: string, sin unidad)
            await catalogRepo.addSpeciesMagnitude(matchingSpecies.id, 'Valor nominal', dataType: 'real', unitSymbol: currencyUnit);
            await catalogRepo.addSpeciesMagnitude(matchingSpecies.id, 'Acuñación', dataType: 'integer', unitSymbol: 'año');
            await catalogRepo.addSpeciesMagnitude(matchingSpecies.id, 'Divisa', dataType: 'string');
            await catalogRepo.addSpeciesMagnitude(matchingSpecies.id, 'Material', dataType: 'string');
            await catalogRepo.addSpeciesMagnitude(matchingSpecies.id, 'Grado', dataType: 'string');

            if (!mounted) return;
            ref.invalidate(catalogListProvider);

            final freshSpecies = await catalogRepo.getCatalogItemById(matchingSpecies.id) ?? matchingSpecies;

            // 1. Reutilizar subespecie existente si coincide el nombre (ej: "5 Pesos Mexicanos - México (2022)")
            final existingSubspeciesList = await catalogRepo.getSubspeciesForSpecies(freshSpecies.id);
            Subspecies? targetSubspecies;

            for (final sub in existingSubspeciesList) {
              if (sub.subspeciesName.trim().toLowerCase() == result.subspeciesName.trim().toLowerCase()) {
                targetSubspecies = sub;
                break;
              }
            }

            if (targetSubspecies == null) {
              final currencyStr = result.currencyName ?? result.currencyCode ?? '';
              final notesParts = <String>[];
              if (currencyStr.isNotEmpty) notesParts.add('Moneda: $currencyStr');
              if (result.year != null) notesParts.add('Año: ${result.year}');
              if (result.composition != null) notesParts.add('Material: ${result.composition}');

              targetSubspecies = Subspecies(
                id: const Uuid().v4(),
                speciesId: freshSpecies.id,
                subspeciesName: result.subspeciesName,
                photoPath: result.obversePhotoPath, // Foto del anverso del primer ejemplar como imagen principal
                notes: notesParts.isNotEmpty ? notesParts.join(' | ') : null,
                createdAt: DateTime.now(),
              );

              await catalogRepo.saveSubspecies(targetSubspecies);
              if (!mounted) return;
              ref.invalidate(subspeciesListProvider);
            }

            // 2. Determinar anotaciones: Únicamente la información de Edición Especial va en las anotaciones
            String? instanceNotes;
            if (result.isSpecialEdition) {
              final reason = result.specialEditionReason ?? 'Edición Especial';
              if (reason == 'Otro (especificar)' && result.specialEditionNotes != null && result.specialEditionNotes!.isNotEmpty) {
                instanceNotes = 'Edición Especial: ${result.specialEditionNotes}';
              } else {
                instanceNotes = 'Edición Especial: $reason';
                if (result.specialEditionNotes != null && result.specialEditionNotes!.isNotEmpty) {
                  instanceNotes = '$instanceNotes (${result.specialEditionNotes})';
                }
              }
            }

            // 3. Instanciar directamente en inventario (Sin desplegar InstantiateSpeciesSheet)
            if (!mounted) return;
            final entityRepo = ref.read(entityRepositoryProvider);
            final createdInstance = await entityRepo.instantiateOrMerge(
              freshSpecies.id,
              widget.initialLocationId,
              1.0,
              subspeciesId: targetSubspecies.id,
              notes: instanceNotes,
            );

            // 4. Guardar magnitudes 4NF relacionales en la instancia
            if (freshSpecies.magnitudes.isNotEmpty) {
              final List<InstanceMagnitude> customInstanceMags = [];
              for (final sm in freshSpecies.magnitudes) {
                double val = 0.0;
                String? strVal;
                String? unit = sm.unitSymbol;

                if (sm.propertyName == 'Valor nominal') {
                  val = result.faceValueNumber ?? 1.0;
                  unit = currencyUnit;
                } else if (sm.propertyName == 'Acuñación') {
                  if (result.year != null && double.tryParse(result.year!) != null) {
                    val = double.parse(result.year!);
                  }
                  unit = 'año';
                } else if (sm.propertyName == 'Divisa') {
                  strVal = currencyUnit;
                  unit = null;
                } else if (sm.propertyName == 'Material') {
                  strVal = result.composition;
                  unit = null;
                } else if (sm.propertyName == 'Grado') {
                  strVal = result.grade;
                  unit = null;
                }

                customInstanceMags.add(InstanceMagnitude(
                  id: const Uuid().v4(),
                  instanceId: createdInstance.id,
                  propertyName: sm.propertyName,
                  dataType: sm.dataType,
                  magnitudeValue: val,
                  stringValue: strVal,
                  unitSymbol: unit,
                ));
              }

              final updatedWithMags = createdInstance.copyWith(magnitudes: customInstanceMags);
              await entityRepo.saveEntity(updatedWithMags);
            }

            // 5. Stitch de Anverso y Reverso y adjunto a la instancia con formato <subespecie>_<uuid>.jpg
            final sanitizedSubname = targetSubspecies.subspeciesName.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');
            final compositeFileName = '$sanitizedSubname (${createdInstance.id}).jpg';

            File compositeFile = File(result.obversePhotoPath);
            if (result.reversePhotoPath != null && await File(result.reversePhotoPath!).exists()) {
              try {
                final obvFile = File(result.obversePhotoPath);
                final revFile = File(result.reversePhotoPath!);
                final bytes1 = await obvFile.readAsBytes();
                final bytes2 = await revFile.readAsBytes();

                final img1 = img.decodeImage(bytes1);
                final img2 = img.decodeImage(bytes2);

                if (img1 != null && img2 != null) {
                  final targetHeight = img1.height;
                  final resizedImg2 = (img2.height != targetHeight)
                      ? img.copyResize(img2, height: targetHeight)
                      : img2;

                  const margin = 20;
                  final totalWidth = img1.width + resizedImg2.width + margin;
                  final totalHeight = targetHeight;

                  final combined = img.Image(width: totalWidth, height: totalHeight);
                  img.fill(combined, color: img.ColorRgb8(30, 30, 30));

                  img.compositeImage(combined, img1, dstX: 0, dstY: 0);
                  img.compositeImage(combined, resizedImg2, dstX: img1.width + margin, dstY: 0);

                  final compositePath = '${obvFile.parent.path}/$compositeFileName';
                  compositeFile = File(compositePath);
                  await compositeFile.writeAsBytes(img.encodeJpg(combined, quality: 85));
                }
              } catch (_) {}
            }

            await catalogRepo.addAttachment(
              speciesId: freshSpecies.id,
              filePath: compositeFile.path,
              fileName: compositeFileName,
              fileType: 'image',
            );

            if (!mounted) return;
            ref.invalidate(entityListProvider);
            ref.invalidate(catalogListProvider);

            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Pieza "${result.subspeciesName}" instanciada directamente.'),
                backgroundColor: Colors.green.shade800,
                duration: const Duration(seconds: 4),
              ),
            );
          },
        );
    }
  }

  Widget _buildAddSubspeciesToExistingView(BuildContext context, List<CatalogItem> catalogItems) {
    if (catalogItems.isEmpty) {
      return const Center(child: Text(AppStrings.emptyCatalog));
    }

    _selectedSpeciesIdForSubspecies ??= catalogItems.first.id;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppStrings.catalogSpeciesLabel, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            initialValue: _selectedSpeciesIdForSubspecies,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.public),
              hintText: AppStrings.selectSpeciesPrompt,
            ),
            items: catalogItems.map((c) {
              return DropdownMenuItem(
                value: c.id,
                child: Text('${c.name} (${c.type})'),
              );
            }).toList(),
            onChanged: (val) {
              if (val != null) setState(() => _selectedSpeciesIdForSubspecies = val);
            },
          ),
          const SizedBox(height: 16),
          if (_selectedSpeciesIdForSubspecies != null)
            SubspeciesSectionWidget(
              speciesId: _selectedSpeciesIdForSubspecies!,
              isEditing: true,
            ),
        ],
      ),
    );
  }

  Widget _buildBrowseCatalogView(BuildContext context, AsyncValue<List<CatalogItem>> catalogState) {
    return catalogState.when(
      data: (items) {
        if (items.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.public, size: 48, color: Colors.grey),
                  const SizedBox(height: 12),
                  const Text(AppStrings.emptyCatalog),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => setState(() => _currentMode = RegisterModalMode.createNewSpecies),
                    icon: const Icon(Icons.add),
                    label: const Text(AppStrings.createFirstSpeciesAction),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (ctx, idx) {
            final item = items[idx];
            return SpeciesTile(
              species: item,
              onInstantiate: () {
                Navigator.pop(context);
                InstantiateSpeciesSheet.show(
                  context,
                  species: item,
                  initialLocationId: widget.initialLocationId,
                );
              },
              onTap: () {
                Navigator.pop(context);
                InstantiateSpeciesSheet.show(
                  context,
                  species: item,
                  initialLocationId: widget.initialLocationId,
                );
              },
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('${AppStrings.errorPrefix}$err')),
    );
  }
}
