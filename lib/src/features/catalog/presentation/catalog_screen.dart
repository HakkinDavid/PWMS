import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/providers/providers.dart';
import '../../entities/presentation/create_entity_sheet.dart';
import '../domain/catalog_item.dart';

class CatalogScreen extends ConsumerWidget {
  const CatalogScreen({super.key});

  void _showCreateSpeciesModal(BuildContext context, WidgetRef ref) {
    final nameCtrl = TextEditingController();
    final brandCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final barcodeCtrl = TextEditingController();
    String type = 'Objeto / Herramienta';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final theme = Theme.of(ctx);
        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 16,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                const SizedBox(height: 16),
                Text(
                  'Crear Especie en el Universo de Objetos',
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Define el objeto maestro en el catálogo universal para instanciarlo libremente en tu mundo.',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nameCtrl,
                  autofocus: true,
                  decoration: const InputDecoration(
                    labelText: 'Nombre maestro del objeto / especie',
                    hintText: 'Ej. Multímetro Fluke 87V, Batería AA 1.5V...',
                    prefixIcon: Icon(Icons.auto_awesome),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: brandCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Marca / Fabricante (Opcional)',
                    hintText: 'Ej. Fluke, Sony, Duracell...',
                    prefixIcon: Icon(Icons.branding_watermark),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: barcodeCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Código de barras maestro',
                    hintText: 'Ej. 750123456789',
                    prefixIcon: Icon(Icons.qr_code),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descCtrl,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Descripción técnica maestro',
                    prefixIcon: Icon(Icons.notes),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      final name = nameCtrl.text.trim();
                      if (name.isEmpty) return;

                      final item = CatalogItem(
                        id: const Uuid().v4(),
                        name: name,
                        type: type,
                        brand: brandCtrl.text.trim().isNotEmpty ? brandCtrl.text.trim() : null,
                        description: descCtrl.text.trim().isNotEmpty ? descCtrl.text.trim() : null,
                        barcode: barcodeCtrl.text.trim().isNotEmpty ? barcodeCtrl.text.trim() : null,
                        createdAt: DateTime.now(),
                      );

                      await ref.read(catalogListProvider.notifier).saveCatalogItem(item);
                      if (ctx.mounted) Navigator.pop(ctx);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text('Guardar Especie en Universo', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalogState = ref.watch(catalogListProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Universo de Objetos (Catálogo)'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateSpeciesModal(context, ref),
        icon: const Icon(Icons.add_circle_outline),
        label: const Text('Nueva Especie'),
      ),
      body: catalogState.when(
        data: (items) {
          if (items.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.public, size: 64, color: theme.colorScheme.primary.withAlpha(120)),
                    const SizedBox(height: 16),
                    Text(
                      'El Universo de Objetos está vacío',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Crea especies o modelos maestros para instanciar fácilmente múltiples ejemplares en tu mundo.',
                      style: theme.textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = items[index];
              return Card(
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    backgroundColor: theme.colorScheme.primary.withAlpha(30),
                    child: Icon(Icons.auto_awesome, color: theme.colorScheme.primary),
                  ),
                  title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${item.brand ?? "Sin marca"} • ${item.type}'),
                  trailing: ElevatedButton.icon(
                    onPressed: () {
                      CreateEntitySheet.show(context);
                    },
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('Instanciar'),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
