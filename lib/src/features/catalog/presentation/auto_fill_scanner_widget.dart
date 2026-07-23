import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/providers/providers.dart';
import '../domain/subspecies.dart';
import '../infrastructure/product_lookup_service.dart';

class AutoFillScannerWidget extends ConsumerStatefulWidget {
  final String? initialLocationId;

  const AutoFillScannerWidget({
    super.key,
    this.initialLocationId,
  });

  @override
  ConsumerState<AutoFillScannerWidget> createState() => _AutoFillScannerWidgetState();
}

class _AutoFillScannerWidgetState extends ConsumerState<AutoFillScannerWidget> {
  late MobileScannerController _scannerController;
  String? _selectedLocationId;
  bool _isProcessing = false;
  DateTime? _lastScanTime;
  String? _lastStatusMessage;

  @override
  void initState() {
    super.initState();
    _selectedLocationId = widget.initialLocationId;
    _scannerController = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      torchEnabled: false,
    );
  }

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  Future<void> _handleBarcodeDetected(String rawBarcode) async {
    final now = DateTime.now();
    if (_isProcessing) return;
    if (_lastScanTime != null && now.difference(_lastScanTime!).inMilliseconds < 1500) {
      return; // Cooldown 1.5s
    }

    setState(() {
      _isProcessing = true;
      _lastScanTime = now;
      _lastStatusMessage = 'Buscando código $rawBarcode...';
    });

    try {
      final catalogRepo = ref.read(catalogRepositoryProvider);
      final entityRepo = ref.read(entityRepositoryProvider);
      final lookupService = ref.read(productLookupServiceProvider);

      // 1. Buscar en subespecies existentes
      final allSubspecies = await catalogRepo.getAllSubspecies();
      final existingSub = allSubspecies.where((s) => s.barcode != null && s.barcode!.trim() == rawBarcode.trim()).firstOrNull;

      if (existingSub != null) {
        final species = await catalogRepo.getCatalogItemById(existingSub.speciesId);
        if (species != null) {
          await entityRepo.instantiateOrMerge(
            species.id,
            _selectedLocationId,
            1.0,
            subspeciesId: existingSub.id,
          );
          _refreshState();
          _showFeedback('Instanciado automáticamente: ${existingSub.subspeciesName} (${species.name})');
          return;
        }
      }

      // 2. Si no existe localmente, consultar APIs en línea
      final onlineResult = await lookupService.lookupByBarcode(rawBarcode);
      if (onlineResult != null) {
        // Crear especie
        final species = await catalogRepo.getOrCreateSpecies(
          onlineResult.productName,
          type: AppStrings.typeObject,
          description: onlineResult.description,
          mainPhotoPath: onlineResult.localPhotoPath,
        );

        // Crear subespecie
        final newSubspecies = Subspecies(
          id: '',
          speciesId: species.id,
          subspeciesName: onlineResult.brand != null && onlineResult.brand!.isNotEmpty
              ? '${onlineResult.brand} - ${onlineResult.productName}'
              : onlineResult.productName,
          brand: onlineResult.brand,
          barcode: rawBarcode,
          photoPath: onlineResult.localPhotoPath,
          notes: onlineResult.description,
          createdAt: DateTime.now(),
        );

        await catalogRepo.saveSubspecies(newSubspecies);

        // Instanciar
        final createdSubs = await catalogRepo.getSubspeciesForSpecies(species.id);
        final targetSub = createdSubs.where((s) => s.barcode == rawBarcode).firstOrNull ?? createdSubs.firstOrNull;

        await entityRepo.instantiateOrMerge(
          species.id,
          _selectedLocationId,
          1.0,
          subspeciesId: targetSub?.id,
        );

        _refreshState();
        _showFeedback('Creado e Instanciado: ${species.name}');
      } else {
        _showFeedback('Código no encontrado en base de datos local ni en línea ($rawBarcode)', isError: true);
      }
    } catch (e) {
      _showFeedback('Error en autollenado: $e', isError: true);
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  Future<void> _handleShutterCapture() async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
      _lastStatusMessage = 'Analizando imagen capturada...';
    });

    try {
      final picker = ImagePicker();
      final pickedImage = await picker.pickImage(source: ImageSource.camera, imageQuality: 85);
      if (pickedImage != null) {
        final imageFile = File(pickedImage.path);

        // 1. Intentar primero si la foto contiene código de barras
        final barcodeResult = await _scannerController.analyzeImage(pickedImage.path);
        if (barcodeResult != null && barcodeResult.barcodes.isNotEmpty) {
          final code = barcodeResult.barcodes.first.rawValue;
          if (code != null && code.isNotEmpty) {
            await _handleBarcodeDetected(code);
            return;
          }
        }

        // 2. Coincidencia visual si no hay código de barras
        final visualService = ref.read(visualMatchingServiceProvider);
        final matchResult = await visualService.findMatchForImage(imageFile);

        if (matchResult.matchedSubspecies != null) {
          final sub = matchResult.matchedSubspecies!;
          final catalogRepo = ref.read(catalogRepositoryProvider);
          final species = await catalogRepo.getCatalogItemById(sub.speciesId);

          if (species != null) {
            final entityRepo = ref.read(entityRepositoryProvider);
            await entityRepo.instantiateOrMerge(
              species.id,
              _selectedLocationId,
              1.0,
              subspeciesId: sub.id,
            );
            _refreshState();
            _showFeedback('Coincidencia visual local: ${sub.subspeciesName}');
            return;
          }
        } else if (matchResult.onlineProduct != null) {
          final prod = matchResult.onlineProduct!;
          final catalogRepo = ref.read(catalogRepositoryProvider);
          final entityRepo = ref.read(entityRepositoryProvider);

          final species = await catalogRepo.getOrCreateSpecies(
            prod.productName,
            type: AppStrings.typeObject,
            description: prod.description,
            mainPhotoPath: prod.localPhotoPath,
          );

          await entityRepo.instantiateOrMerge(
            species.id,
            _selectedLocationId,
            1.0,
          );

          _refreshState();
          _showFeedback('Identificado e instanciado: ${species.name}');
          return;
        }

        _showFeedback('No se halló coincidencia clara para la foto.', isError: true);
      } else {
        _showFeedback('No se seleccionó o capturó ninguna imagen.');
      }
    } catch (e) {
      _showFeedback('Error al procesar foto: $e', isError: true);
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  void _refreshState() {
    ref.invalidate(entityListProvider);
    ref.invalidate(catalogListProvider);
    ref.invalidate(subspeciesListProvider);
  }

  void _showFeedback(String message, {bool isError = false}) {
    if (!mounted) return;
    setState(() => _lastStatusMessage = message);
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : Colors.green.shade700,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locationState = ref.watch(locationNodeListProvider);
    final locations = locationState.asData?.value ?? [];

    _selectedLocationId ??= locations.firstOrNull?.id;

    return Column(
      children: [
        // Top Location Selector Widget (Simple Header)
        Card(
          elevation: 0,
          color: theme.colorScheme.surfaceContainerHighest.withAlpha(120),
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Row(
              children: [
                const Icon(Icons.location_on, size: 20, color: Colors.blueAccent),
                const SizedBox(width: 8),
                const Text('Ubicación actual:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: _selectedLocationId,
                      hint: const Text('Seleccionar ubicación'),
                      items: locations.map((loc) {
                        return DropdownMenuItem(
                          value: loc.id,
                          child: Text(loc.name, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12)),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedLocationId = val);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Camera Feed Viewbox Frame
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: MobileScanner(
                  controller: _scannerController,
                  onDetect: (capture) {
                    final barcodes = capture.barcodes;
                    if (barcodes.isNotEmpty) {
                      final code = barcodes.first.rawValue;
                      if (code != null && code.isNotEmpty) {
                        _handleBarcodeDetected(code);
                      }
                    }
                  },
                ),
              ),

              // Scanning Overlay Frame Graphic
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _isProcessing ? Colors.orangeAccent : theme.colorScheme.primary.withAlpha(180),
                    width: 2.5,
                  ),
                ),
              ),

              // Status Banner Overlay at top of camera frame
              if (_lastStatusMessage != null)
                Positioned(
                  top: 12,
                  left: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _lastStatusMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),

              // Shutter Capture Button at Bottom of Camera Frame
              Positioned(
                bottom: 16,
                child: ElevatedButton.icon(
                  onPressed: _isProcessing ? null : _handleShutterCapture,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  icon: _isProcessing
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.camera_alt, size: 20),
                  label: Text(_isProcessing ? 'Procesando...' : 'Capturar Coincidencia Visual'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
