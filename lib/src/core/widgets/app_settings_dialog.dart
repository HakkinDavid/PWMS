import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../storage/app_settings_repository.dart';
import 'backup_settings_dialog.dart';
import 'app_toast.dart';

class AppSettingsDialog extends ConsumerStatefulWidget {
  const AppSettingsDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) => const AppSettingsDialog(),
    );
  }

  @override
  ConsumerState<AppSettingsDialog> createState() => _AppSettingsDialogState();
}

class _AppSettingsDialogState extends ConsumerState<AppSettingsDialog> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _geminiKeyCtrl = TextEditingController();
  final TextEditingController _numistaKeyCtrl = TextEditingController();

  bool _isObscureGemini = true;
  bool _isObscureNumista = true;
  bool _isSavingGemini = false;
  bool _isSavingNumista = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadKeys();
  }

  Future<void> _loadKeys() async {
    final repo = ref.read(appSettingsRepositoryProvider);
    final geminiKey = await repo.getGeminiApiKey();
    final numistaKey = await repo.getNumistaApiKey();
    if (mounted) {
      setState(() {
        if (geminiKey != null) _geminiKeyCtrl.text = geminiKey;
        if (numistaKey != null) _numistaKeyCtrl.text = numistaKey;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _geminiKeyCtrl.dispose();
    _numistaKeyCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveGeminiKey() async {
    setState(() => _isSavingGemini = true);
    try {
      final repo = ref.read(appSettingsRepositoryProvider);
      await repo.setGeminiApiKey(_geminiKeyCtrl.text.trim());
      ref.invalidate(geminiApiKeyProvider);
      if (mounted) {
        AppToast.showSuccess(context, 'Clave Gemini API guardada localmente.');
      }
    } catch (e) {
      if (mounted) AppToast.showError(context, 'Error al guardar clave: $e');
    } finally {
      if (mounted) setState(() => _isSavingGemini = false);
    }
  }

  Future<void> _saveNumistaKey() async {
    setState(() => _isSavingNumista = true);
    try {
      final repo = ref.read(appSettingsRepositoryProvider);
      await repo.setNumistaApiKey(_numistaKeyCtrl.text.trim());
      ref.invalidate(numistaApiKeyProvider);
      if (mounted) {
        AppToast.showSuccess(context, 'Clave Numista API guardada localmente.');
      }
    } catch (e) {
      if (mounted) AppToast.showError(context, 'Error al guardar clave: $e');
    } finally {
      if (mounted) setState(() => _isSavingNumista = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.settings, color: theme.colorScheme.onPrimaryContainer, size: 24),
                ),
                const SizedBox(width: 14),
                Text(
                  'Configuración Global',
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(icon: Icon(Icons.key, size: 18), text: 'APIs & IA'),
                Tab(icon: Icon(Icons.backup, size: 18), text: 'Respaldos DB'),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 320,
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Tab 1: API Keys
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Inteligencia Visual (Gemini Vision API)',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Permite identificar monedas y billetes automáticamente analizando fotos de Anverso y Reverso.',
                          style: TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _geminiKeyCtrl,
                                obscureText: _isObscureGemini,
                                decoration: InputDecoration(
                                  hintText: 'Clave API de Gemini...',
                                  prefixIcon: const Icon(Icons.auto_awesome, size: 20),
                                  suffixIcon: IconButton(
                                    icon: Icon(_isObscureGemini ? Icons.visibility_off : Icons.visibility, size: 18),
                                    onPressed: () => setState(() => _isObscureGemini = !_isObscureGemini),
                                  ),
                                  isDense: true,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: _isSavingGemini ? null : _saveGeminiKey,
                              child: _isSavingGemini
                                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                                  : const Text('Guardar'),
                            ),
                          ],
                        ),
                        const Divider(height: 32),
                        const Text(
                          'Catálogo Abierto Numista (Numista API)',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Opcional. Permite consultar especificaciones oficiales de monedas y billetes internacionales.',
                          style: TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _numistaKeyCtrl,
                                obscureText: _isObscureNumista,
                                decoration: InputDecoration(
                                  hintText: 'Clave API de Numista (Opcional)...',
                                  prefixIcon: const Icon(Icons.travel_explore, size: 20),
                                  suffixIcon: IconButton(
                                    icon: Icon(_isObscureNumista ? Icons.visibility_off : Icons.visibility, size: 18),
                                    onPressed: () => setState(() => _isObscureNumista = !_isObscureNumista),
                                  ),
                                  isDense: true,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: _isSavingNumista ? null : _saveNumistaKey,
                              child: _isSavingNumista
                                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                                  : const Text('Guardar'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Tab 2: Respaldos
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.storage, size: 48, color: Colors.blueAccent),
                        const SizedBox(height: 12),
                        const Text(
                          'Gestión de Copias de Seguridad Local',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Exporta o restaura la base de datos completa de PWMS.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            BackupSettingsDialog.show(context);
                          },
                          icon: const Icon(Icons.backup),
                          label: const Text('Abrir Panel de Respaldos'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
