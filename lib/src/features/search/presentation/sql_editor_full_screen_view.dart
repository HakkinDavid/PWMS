import 'package:flutter/material.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import 'package:platinum_world_management_system/src/core/constants/app_technical_strings.dart';
import 'package:platinum_world_management_system/src/core/widgets/app_wheel_picker.dart';
import '../domain/sql_preset.dart';

class SqlEditorFullScreenView extends StatefulWidget {
  final String initialQuery;
  final SqlPresetCategory initialCategory;
  final SqlPreset? initialPreset;

  const SqlEditorFullScreenView({
    super.key,
    required this.initialQuery,
    this.initialCategory = SqlPresetCategory.all,
    this.initialPreset,
  });

  static Future<String?> show(
    BuildContext context, {
    required String initialQuery,
    SqlPresetCategory initialCategory = SqlPresetCategory.all,
    SqlPreset? initialPreset,
  }) {
    return Navigator.push<String>(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => SqlEditorFullScreenView(
          initialQuery: initialQuery,
          initialCategory: initialCategory,
          initialPreset: initialPreset,
        ),
      ),
    );
  }

  @override
  State<SqlEditorFullScreenView> createState() => _SqlEditorFullScreenViewState();
}

class _SqlEditorFullScreenViewState extends State<SqlEditorFullScreenView> {
  late final TextEditingController _controller;
  late SqlPresetCategory _selectedCategory;
  SqlPreset? _selectedPreset;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery);
    _selectedCategory = widget.initialCategory;
    _selectedPreset = widget.initialPreset ??
        SqlPreset.defaultPresets.where((p) => p.query.trim() == widget.initialQuery.trim()).firstOrNull ??
        SqlPreset.defaultPresets.first;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickCategory() async {
    final picked = await AppWheelPicker.show<SqlPresetCategory>(
      context,
      items: SqlPresetCategory.values,
      initialValue: _selectedCategory,
      labelBuilder: (cat) => cat.displayName,
      title: AppStrings.sqlCategorySelectPrompt,
    );

    if (picked != null && mounted) {
      setState(() {
        _selectedCategory = picked;
        final matchingPresets = SqlPreset.defaultPresets
            .where((p) => picked == SqlPresetCategory.all || p.category == picked)
            .toList();
        if (_selectedPreset != null && !matchingPresets.contains(_selectedPreset) && matchingPresets.isNotEmpty) {
          _selectedPreset = matchingPresets.first;
          _controller.text = _selectedPreset!.query;
        }
      });
    }
  }

  Future<void> _pickPreset() async {
    final filteredPresets = SqlPreset.defaultPresets
        .where((p) => _selectedCategory == SqlPresetCategory.all || p.category == _selectedCategory)
        .toList();

    if (filteredPresets.isEmpty) return;

    final initialP = filteredPresets.contains(_selectedPreset)
        ? _selectedPreset
        : (filteredPresets.isNotEmpty ? filteredPresets.first : null);

    final picked = await AppWheelPicker.show<SqlPreset>(
      context,
      items: filteredPresets,
      initialValue: initialP,
      labelBuilder: (p) => p.title,
      title: AppStrings.sqlPresetsSelectPrompt,
    );

    if (picked != null && mounted) {
      setState(() {
        _selectedPreset = picked;
        _controller.text = picked.query;
      });
    }
  }

  void _executeAndReturn() {
    final text = _controller.text.trim();
    Navigator.of(context).pop(text.isNotEmpty ? text : null);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    final presetButtonLabel = _selectedPreset != null
        ? _selectedPreset!.title
        : AppStrings.sqlPresetsSelectPrompt;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          AppStrings.fullScreenSqlEditorTitle,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_all),
            tooltip: AppStrings.clearHistoryTooltip,
            onPressed: () => setState(() => _controller.clear()),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Column(
              children: [
                // Toolbar with Category & Presets Pickers (Dedicated Row)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    border: Border(bottom: BorderSide(color: theme.dividerColor.withAlpha(60))),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _pickCategory,
                          icon: const Icon(Icons.category_outlined, size: 16),
                          label: Text(
                            _selectedCategory.displayName,
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                            overflow: TextOverflow.ellipsis,
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: FilledButton.tonalIcon(
                          onPressed: _pickPreset,
                          icon: const Icon(Icons.bookmark_border, size: 16),
                          label: Text(
                            presetButtonLabel,
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                            overflow: TextOverflow.ellipsis,
                          ),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Editor Text Area
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest.withAlpha(70),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: theme.dividerColor.withAlpha(80)),
                    ),
                    child: TextField(
                      controller: _controller,
                      maxLines: null,
                      expands: true,
                      autofocus: true,
                      style: const TextStyle(
                        fontFamily: AppTechnicalStrings.fontFamilyMonospace,
                        fontSize: 14,
                        height: 1.4,
                      ),
                      decoration: const InputDecoration(
                        hintText: AppStrings.sqlCodeEditorHint,
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ),

                // Spacing to account for the floating bottom button
                SizedBox(height: 76 + (bottomInset > 0 ? 0 : 16)),
              ],
            ),
          ),

          // Floating Sticky Execution Button at Bottom
          Positioned(
            left: 16,
            right: 16,
            bottom: bottomInset > 0 ? bottomInset + 12 : 16,
            child: SafeArea(
              top: false,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(40),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _executeAndReturn,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: Colors.white,
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.play_arrow_rounded, size: 22),
                        SizedBox(width: 8),
                        Text(
                          AppStrings.executeSqlAction,
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
