import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import '../../../core/providers/providers.dart';
import '../../catalog/domain/catalog_item.dart';
import '../../catalog/domain/subspecies.dart';
import '../../catalog/domain/numismatic_data_helper.dart';
import '../../catalog/presentation/add_edit_subspecies_modal.dart';
import '../../catalog/presentation/auto_fill_scanner_widget.dart';
import '../../catalog/presentation/guided_dual_scan_widget.dart';
import '../../catalog/presentation/species_form_modal.dart';
import '../../catalog/presentation/species_tile.dart';
import '../../catalog/presentation/subspecies_section_widget.dart';
import '../../relations/domain/entity_relation.dart';
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
    final queryParams = <String, String>{};
    if (initialLocationId != null && initialLocationId.isNotEmpty) {
      queryParams['initialLocationId'] = initialLocationId;
    }
    if (startInCreateSpecies) {
      queryParams['startInCreateSpecies'] = 'true';
    }
    final uri = Uri(path: '/register', queryParameters: queryParams.isNotEmpty ? queryParams : null);
    return context.push(uri.toString(), extra: scannedResult);
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
    final catalogState = ref.watch(catalogListProvider);
    final catalogItems = catalogState.asData?.value ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.registerObjectTitle),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

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
                    icon: Icon(Icons.public, size: 16),
                  ),
                  ButtonSegment(
                    value: RegisterModalMode.createNewSpecies,
                    icon: Icon(Icons.add, size: 16),
                  ),
                  ButtonSegment(
                    value: RegisterModalMode.addSubspeciesToExisting,
                    icon: Icon(Icons.branding_watermark, size: 16),
                  ),
                  ButtonSegment(
                    value: RegisterModalMode.autoFillScanner,
                    icon: Icon(Icons.qr_code_scanner, size: 16),
                  ),
                  ButtonSegment(
                    value: RegisterModalMode.numismaticScanner,
                    icon: Icon(Icons.monetization_on, size: 16),
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
          isEmbedded: true,
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
                  if (mounted) {
                    Navigator.pop(context);
                    InstantiateSpeciesSheet.show(
                      context,
                      species: matchingSpecies,
                      initialSubspecies: newSub,
                      initialLocationId: widget.initialLocationId,
                    );
                  }
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
          initialLocationId: widget.initialLocationId,
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
                type: AppStrings.typeObject,
                description: '${AppStrings.numismaticSpeciesDescriptionPrefix}${result.speciesType})',
                mainPhotoPath: null,
              );
            }

            final currencyUnit = (result.currencyCode != null && result.currencyCode!.trim().isNotEmpty)
                ? result.currencyCode!.trim()
                : 'MXN';

            await catalogRepo.addSpeciesMagnitude(matchingSpecies.id, AppStrings.nominalValuePropertyName, dataType: 'real');
            await catalogRepo.addSpeciesMagnitude(matchingSpecies.id, AppStrings.mintagePropertyName, dataType: 'integer', unitSymbol: 'año');
            await catalogRepo.addSpeciesMagnitude(matchingSpecies.id, AppStrings.currencyPropertyName, dataType: 'string');
            await catalogRepo.addSpeciesMagnitude(matchingSpecies.id, AppStrings.materialPropertyName, dataType: 'string');
            await catalogRepo.addSpeciesMagnitude(matchingSpecies.id, AppStrings.gradePropertyName, dataType: 'string');

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
              final notesStr = NumismaticDataHelper.buildSubspeciesNotes(
                currencyName: result.currencyName ?? result.currencyCode,
                year: result.year,
                composition: result.composition,
              );

              targetSubspecies = Subspecies(
                id: const Uuid().v4(),
                speciesId: freshSpecies.id,
                subspeciesName: result.subspeciesName,
                photoPath: null,
                notes: notesStr.isNotEmpty ? notesStr : null,
                createdAt: DateTime.now(),
              );

              await catalogRepo.saveSubspecies(targetSubspecies);
              if (!mounted) return;
              ref.invalidate(subspeciesListProvider);
            }

            // 2. Determinar anotaciones: Únicamente la información de Edición Especial va en las anotaciones
            String? instanceNotes;
            if (result.isSpecialEdition) {
              final reason = result.specialEditionReason ?? AppStrings.specialEditionTitle;
              if (reason == AppStrings.otherSpecifyOption && result.specialEditionNotes != null && result.specialEditionNotes!.isNotEmpty) {
                instanceNotes = '${AppStrings.specialEditionNotePrefix}${result.specialEditionNotes}';
              } else {
                instanceNotes = '${AppStrings.specialEditionNotePrefix}$reason';
                if (result.specialEditionNotes != null && result.specialEditionNotes!.isNotEmpty) {
                  instanceNotes = '$instanceNotes (${result.specialEditionNotes})';
                }
              }
            }

            // 3. Instanciar directamente en inventario (con soporte para ubicación física o contenedor)
            if (!mounted) return;
            final entityRepo = ref.read(entityRepositoryProvider);
            final relationRepo = ref.read(relationRepositoryProvider);

            final targetPhysicalLoc = result.isContainer
                ? null
                : (result.locationId ?? widget.initialLocationId);

            final createdInstance = await entityRepo.instantiateOrMerge(
              freshSpecies.id,
              targetPhysicalLoc,
              1.0,
              subspeciesId: targetSubspecies.id,
              notes: instanceNotes,
            );

            // Si se seleccionó modo contenedor, crear relación GUARDADO_EN
            if (result.isContainer && result.containerEntityId != null && result.containerEntityId!.isNotEmpty) {
              final rel = EntityRelation(
                id: const Uuid().v4(),
                sourceEntityId: createdInstance.id,
                targetEntityId: result.containerEntityId!,
                relationType: 'GUARDADO_EN',
                createdAt: DateTime.now(),
              );
              await relationRepo.addRelation(rel);
            }

            // 4. Guardar magnitudes 4NF relacionales en la instancia
            if (freshSpecies.magnitudes.isNotEmpty) {
              final List<InstanceMagnitude> customInstanceMags = [];
              for (final sm in freshSpecies.magnitudes) {
                double val = 0.0;
                String? strVal;
                String? unit = sm.unitSymbol;

                if (sm.propertyName == 'Valor nominal') {
                  val = result.faceValueNumber ?? 1.0;
                  unit = null;
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

            // 5. Adjuntos de Anverso y Reverso por instancia (sin stitching)
            final obverseFile = File(result.obversePhotoPath);
            if (await obverseFile.exists()) {
              final ext = obverseFile.path.contains('.') ? obverseFile.path.split('.').last : 'jpg';
              final obverseFileName = NumismaticDataHelper.buildAttachmentFileName(
                subspeciesName: targetSubspecies.subspeciesName,
                instanceId: createdInstance.id,
                side: 'anverso',
                extension: ext,
              );
              await catalogRepo.addAttachment(
                speciesId: freshSpecies.id,
                instanceId: createdInstance.id,
                filePath: obverseFile.path,
                fileName: obverseFileName,
                fileType: 'image',
              );
            }

            if (result.reversePhotoPath != null) {
              final reverseFile = File(result.reversePhotoPath!);
              if (await reverseFile.exists()) {
                final ext = reverseFile.path.contains('.') ? reverseFile.path.split('.').last : 'jpg';
                final reverseFileName = NumismaticDataHelper.buildAttachmentFileName(
                  subspeciesName: targetSubspecies.subspeciesName,
                  instanceId: createdInstance.id,
                  side: 'reverso',
                  extension: ext,
                );
                await catalogRepo.addAttachment(
                  speciesId: freshSpecies.id,
                  instanceId: createdInstance.id,
                  filePath: reverseFile.path,
                  fileName: reverseFileName,
                  fileType: 'image',
                );
              }
            }

            if (!mounted) return;
            ref.invalidate(entityListProvider);
            ref.invalidate(relationListProvider);
            ref.invalidate(catalogListProvider);
            ref.invalidate(speciesAttachmentsProvider(freshSpecies.id));
            ref.invalidate(instanceAttachmentsProvider(createdInstance.id));

            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${AppStrings.pieceInstantiatedDirectlyPrefix}${result.subspeciesName}${AppStrings.pieceInstantiatedDirectlySuffix}'),
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
            isExpanded: true,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.public),
              hintText: AppStrings.selectSpeciesPrompt,
            ),
            items: catalogItems.map((c) {
              return DropdownMenuItem(
                value: c.id,
                child: Text('${c.name} (${c.type})', overflow: TextOverflow.ellipsis),
              );
            }).toList(),
            onChanged: (val) {
              if (val != null) setState(() => _selectedSpeciesIdForSubspecies = val);
            },
          ),
          const SizedBox(height: 16),
          if (_selectedSpeciesIdForSubspecies != null)
            SubspeciesSectionWidget(
              key: ValueKey(_selectedSpeciesIdForSubspecies),
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
