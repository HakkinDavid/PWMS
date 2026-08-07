import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/storage/app_settings_repository.dart';
import '../../../core/widgets/backup_settings_dialog.dart';
import '../../../core/widgets/app_toast.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> with SingleTickerProviderStateMixin {
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración Global'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.key), text: 'APIs & IA'),
            Tab(icon: Icon(Icons.backup), text: 'Respaldos de Base de Datos'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: APIs & IA
          ListView(
            padding: const EdgeInsets.all(24.0),
            children: [
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: theme.colorScheme.outlineVariant.withAlpha(120)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.auto_awesome, color: theme.colorScheme.primary, size: 24),
                          const SizedBox(width: 10),
                          Text(
                            'Inteligencia Visual (Gemini Vision API)',
                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Se utiliza para identificar monedas y billetes automáticamente analizando fotos de Anverso y Reverso.',
                        style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _geminiKeyCtrl,
                              obscureText: _isObscureGemini,
                              decoration: InputDecoration(
                                hintText: 'Clave API de Gemini...',
                                prefixIcon: const Icon(Icons.key_rounded),
                                suffixIcon: IconButton(
                                  icon: Icon(_isObscureGemini ? Icons.visibility_off : Icons.visibility),
                                  onPressed: () => setState(() => _isObscureGemini = !_isObscureGemini),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton.icon(
                            onPressed: _isSavingGemini ? null : _saveGeminiKey,
                            icon: _isSavingGemini
                                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                                : const Icon(Icons.save),
                            label: const Text('Guardar'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: theme.colorScheme.outlineVariant.withAlpha(120)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.travel_explore, color: theme.colorScheme.secondary, size: 24),
                          const SizedBox(width: 10),
                          Text(
                            'Catálogo Abierto Numista (Numista API)',
                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Opcional. Permite consultar especificaciones oficiales de monedas y billetes internacionales.',
                        style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _numistaKeyCtrl,
                              obscureText: _isObscureNumista,
                              decoration: InputDecoration(
                                hintText: 'Clave API de Numista (Opcional)...',
                                prefixIcon: const Icon(Icons.key_rounded),
                                suffixIcon: IconButton(
                                  icon: Icon(_isObscureNumista ? Icons.visibility_off : Icons.visibility),
                                  onPressed: () => setState(() => _isObscureNumista = !_isObscureNumista),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton.icon(
                            onPressed: _isSavingNumista ? null : _saveNumistaKey,
                            icon: _isSavingNumista
                                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                                : const Icon(Icons.save),
                            label: const Text('Guardar'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Tab 2: Respaldos DB
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.storage, size: 64, color: theme.colorScheme.onPrimaryContainer),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Gestión de Copias de Seguridad Local',
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Exporta o restaura la base de datos completa de PWMS de forma segura en tu almacenamiento local.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: 280,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: () => BackupSettingsDialog.show(context),
                      icon: const Icon(Icons.backup),
                      label: const Text('Abrir Panel de Respaldos', style: TextStyle(fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
