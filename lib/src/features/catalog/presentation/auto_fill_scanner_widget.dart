import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/providers/providers.dart';
import '../infrastructure/product_lookup_service.dart';

class AutoFillScannerWidget extends ConsumerStatefulWidget {
  final String? initialLocationId;
  final Function(ProductLookupResult scannedResult)? onScannedResult;

  const AutoFillScannerWidget({
    super.key,
    this.initialLocationId,
    this.onScannedResult,
  });

  @override
  ConsumerState<AutoFillScannerWidget> createState() => _AutoFillScannerWidgetState();
}

class _AutoFillScannerWidgetState extends ConsumerState<AutoFillScannerWidget> {
  late MobileScannerController _scannerController;
  final TextEditingController _manualBarcodeCtrl = TextEditingController();
  bool _isProcessing = false;

  // Smart Cooldown tracking
  String? _lastScannedBarcode;
  DateTime? _lastScanTime;
  String? _lastStatusMessage;

  @override
  void initState() {
    super.initState();
    _scannerController = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      torchEnabled: false,
    );
  }

  @override
  void dispose() {
    _manualBarcodeCtrl.dispose();
    _scannerController.dispose();
    super.dispose();
  }

  Future<void> _handleBarcodeDetected(String rawBarcode) async {
    final now = DateTime.now();
    if (_isProcessing) return;

    // Cooldown inteligente: 15s para el mismo código consecutivo, 1.5s para un código distinto
    final isSameBarcode = _lastScannedBarcode == rawBarcode.trim();
    final requiredCooldownMs = isSameBarcode ? 15000 : 1500;

    if (_lastScanTime != null && now.difference(_lastScanTime!).inMilliseconds < requiredCooldownMs) {
      return;
    }

    setState(() {
      _isProcessing = true;
      _lastScannedBarcode = rawBarcode.trim();
      _lastScanTime = now;
      _lastStatusMessage = 'Buscando código $rawBarcode...';
    });

    try {
      final catalogRepo = ref.read(catalogRepositoryProvider);
      final entityRepo = ref.read(entityRepositoryProvider);
      final lookupService = ref.read(productLookupServiceProvider);

      // 1. Buscar en subespecies o especies existentes localmente
      final allSubspecies = await catalogRepo.getAllSubspecies();
      final existingSub = allSubspecies.where((s) => s.barcode != null && s.barcode!.trim() == rawBarcode.trim()).firstOrNull;

      if (existingSub != null) {
        final species = await catalogRepo.getCatalogItemById(existingSub.speciesId);
        if (species != null) {
          await entityRepo.instantiateOrMerge(
            species.id,
            widget.initialLocationId,
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
        if (mounted) {
          widget.onScannedResult?.call(onlineResult);
        }
      } else {
        // Punto 2: Código inválido o no encontrado: mostrar diálogo y negarse
        if (mounted) {
          await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: Colors.amber),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      AppStrings.invalidOrNotFoundCodeTitle,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
              content: Text('${AppStrings.invalidOrNotFoundCodeMessagePrefix}$rawBarcode${AppStrings.invalidOrNotFoundCodeMessageSuffix}'),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text(AppStrings.acceptAction),
                ),
              ],
            ),
          );
        }
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
        // 1. Intentar si la foto contiene código de barras
        final barcodeResult = await _scannerController.analyzeImage(pickedImage.path);
        if (barcodeResult != null && barcodeResult.barcodes.isNotEmpty) {
          final code = barcodeResult.barcodes.first.rawValue;
          if (code != null && code.isNotEmpty) {
            await _handleBarcodeDetected(code);
            return;
          }
        }

        _showFeedback('No se detectó un código de barras o ISBN en la imagen.', isError: true);
      } else {
        _showFeedback('No se seleccionó ninguna foto.');
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

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Visor de Cámara Compacto en Ratio Rectangular 16:9
          Container(
            height: 200,
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 12),
            child: AspectRatio(
              aspectRatio: 16 / 9,
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

                  // Marco gráfico para escaneo rápido
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _isProcessing ? Colors.orangeAccent : theme.colorScheme.primary.withAlpha(180),
                        width: 2.5,
                      ),
                    ),
                  ),

                  // Banner de estado sobre la cámara
                  if (_lastStatusMessage != null)
                    Positioned(
                      top: 10,
                      left: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
                ],
              ),
            ),
          ),

          // Botón Obturador para Capturar Coincidencia Visual
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton.icon(
              onPressed: _isProcessing ? null : _handleShutterCapture,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              icon: _isProcessing
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.camera_alt, size: 20),
              label: Text(_isProcessing ? 'Procesando...' : 'Capturar Coincidencia Visual', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 12),

          // Punto 5: Campo de texto para Ingreso Manual de Código de Barras
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _manualBarcodeCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Código de barras manual...',
                    prefixIcon: Icon(Icons.qr_code, size: 20),
                    isDense: true,
                  ),
                  onSubmitted: (val) {
                    if (val.trim().isNotEmpty) {
                      _handleBarcodeDetected(val.trim());
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: _isProcessing
                    ? null
                    : () {
                        final code = _manualBarcodeCtrl.text.trim();
                        if (code.isNotEmpty) {
                          _handleBarcodeDetected(code);
                        } else {
                          _showFeedback(AppStrings.enterBarcodePrompt, isError: true);
                        }
                      },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.search, size: 18),
                label: const Text(AppStrings.tabSearch, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
