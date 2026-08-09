import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constants/app_strings.dart';

class AppWheelPicker<T> extends StatefulWidget {
  final List<T> items;
  final T? initialValue;
  final String Function(T item) labelBuilder;
  final String title;

  const AppWheelPicker({
    super.key,
    required this.items,
    this.initialValue,
    required this.labelBuilder,
    this.title = AppStrings.selectOptionPrompt,
  });

  static Future<T?> show<T>(
    BuildContext context, {
    required List<T> items,
    T? initialValue,
    required String Function(T item) labelBuilder,
    String title = AppStrings.selectOptionPrompt,
  }) {
    if (items.isEmpty) return Future.value(null);
    return showModalBottomSheet<T>(
      context: context,
      useRootNavigator: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AppWheelPicker<T>(
        items: items,
        initialValue: initialValue,
        labelBuilder: labelBuilder,
        title: title,
      ),
    );
  }

  @override
  State<AppWheelPicker<T>> createState() => _AppWheelPickerState<T>();
}

class _AppWheelPickerState<T> extends State<AppWheelPicker<T>> {
  late FixedExtentScrollController _scrollController;
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    int initialIdx = 0;
    if (widget.initialValue != null) {
      final found = widget.items.indexOf(widget.initialValue as T);
      if (found >= 0) initialIdx = found;
    }
    _selectedIndex = initialIdx;
    _scrollController = FixedExtentScrollController(initialItem: _selectedIndex);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      bottom: true,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.45,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.withAlpha(100),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                widget.title,
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 12),

            // Cupertino Wheel Picker
            Expanded(
              child: CupertinoPicker(
                scrollController: _scrollController,
                itemExtent: 44,
                onSelectedItemChanged: (index) {
                  setState(() => _selectedIndex = index);
                },
                children: widget.items.map((item) {
                  final isSelected = widget.items.indexOf(item) == _selectedIndex;
                  final label = widget.labelBuilder(item);
                  return Center(
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? theme.colorScheme.primary : theme.textTheme.bodyMedium?.color,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    if (_selectedIndex >= 0 && _selectedIndex < widget.items.length) {
                      Navigator.pop(context, widget.items[_selectedIndex]);
                    } else {
                      Navigator.pop(context, null);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text(AppStrings.confirm, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
