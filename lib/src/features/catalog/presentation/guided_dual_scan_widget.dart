import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../domain/numismatic_recognition_models.dart';
import '../infrastructure/numismatic_recognition_engine.dart';

class GuidedDualScanWidget extends ConsumerStatefulWidget {
  final Function(NumismaticScanResult result)? onScannedResult;

  const GuidedDualScanWidget({
    super.key,
    this.onScannedResult,
  });

  @override
  ConsumerState<GuidedDualScanWidget> createState() => _GuidedDualScanWidgetState();
}

class _GuidedDualScanWidgetState extends ConsumerState<GuidedDualScanWidget> {
  File? _obverseFile;
  File? _reverseFile;
  bool _isProcessing = false;
  String? _statusMessage;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickPhoto({required bool isObverse, required ImageSource source}) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 90,
        maxWidth: 1600,
      );
      if (image != null) {
        setState(() {
          if (isObverse) {
            _obverseFile = File(image.path);
          } else {
            _reverseFile = File(image.path);
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al capturar foto: $e'), backgroundColor: Colors.redAccent),
      );
    }
  }

  Future<void> _processRecognition() async {
    if (_obverseFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes capturar al menos la foto del Anverso (cara principal).')),
      );
      return;
    }

    setState(() {
      _isProcessing = true;
      _statusMessage = 'Identificando pieza numismática...';
    });

    try {
      final engine = ref.read(numismaticRecognitionEngineProvider);
      final result = await engine.processDualPhotos(
        obversePhoto: _obverseFile!,
        reversePhoto: _reverseFile,
      );

      if (mounted) {
        widget.onScannedResult?.call(result);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error en análisis: $e'), backgroundColor: Colors.redAccent),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
          _statusMessage = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withAlpha(80),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: theme.colorScheme.primary.withAlpha(100)),
            ),
            child: const Row(
              children: [
                Icon(Icons.monetization_on_outlined, color: Colors.amber, size: 24),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Escaneo Numismático Guiado: Toma una foto clara del Anverso (obligatorio) y del Reverso (opcional) de tu moneda o billete.',
                    style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Tarjetas de Captura Dual
          Row(
            children: [
              Expanded(
                child: _buildPhotoCard(
                  title: '1. Anverso (Obligatorio)',
                  subtitle: 'Cara principal',
                  file: _obverseFile,
                  isObverse: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildPhotoCard(
                  title: '2. Reverso (Opcional)',
                  subtitle: 'Cara secundaria',
                  file: _reverseFile,
                  isObverse: false,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Status message
          if (_statusMessage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Center(
                child: Text(
                  _statusMessage!,
                  style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
            ),

          // Botón de Análisis
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: (_isProcessing || _obverseFile == null) ? null : _processRecognition,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              icon: _isProcessing
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.auto_awesome),
              label: Text(
                _isProcessing ? 'Procesando Escaneo...' : 'Analizar e Instanciar Pieza',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoCard({
    required String title,
    required String subtitle,
    required File? file,
    required bool isObverse,
  }) {
    final theme = Theme.of(context);

    return Container(
      height: 210,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withAlpha(120),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: file != null ? Colors.green.shade600 : theme.colorScheme.outline.withAlpha(100),
          width: file != null ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
            child: Column(
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11), textAlign: TextAlign.center),
                Text(subtitle, style: const TextStyle(fontSize: 10, color: Colors.grey), textAlign: TextAlign.center),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Expanded(
            child: file != null
                ? Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(file, fit: BoxFit.cover, width: double.infinity, height: double.infinity),
                      ),
                      Positioned(
                        right: 4,
                        top: 4,
                        child: CircleAvatar(
                          radius: 14,
                          backgroundColor: Colors.black87,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: const Icon(Icons.close, size: 14, color: Colors.white),
                            onPressed: () {
                              setState(() {
                                if (isObverse) {
                                  _obverseFile = null;
                                } else {
                                  _reverseFile = null;
                                }
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  )
                : Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Icon(Icons.add_a_photo_outlined, size: 36, color: Colors.grey),
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () => _pickPhoto(isObverse: isObverse, source: ImageSource.camera),
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Row(
                      children: [
                        Icon(Icons.camera_alt, size: 14),
                        SizedBox(width: 2),
                        Text('Cámara', style: TextStyle(fontSize: 10)),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => _pickPhoto(isObverse: isObverse, source: ImageSource.gallery),
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Row(
                      children: [
                        Icon(Icons.photo_library, size: 14),
                        SizedBox(width: 2),
                        Text('Galería', style: TextStyle(fontSize: 10)),
                      ],
                    ),
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
