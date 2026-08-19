import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constants/app_strings.dart';

class WheelPickerResult<T> {
  final T value;
  const WheelPickerResult(this.value);
}

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

  static Future<WheelPickerResult<T>?> showPicker<T>(
    BuildContext context, {
    required List<T> items,
    T? initialValue,
    required String Function(T item) labelBuilder,
    String title = AppStrings.selectOptionPrompt,
  }) {
    if (items.isEmpty) return Future.value(null);
    return showModalBottomSheet<WheelPickerResult<T>>(
      context: context,
      useRootNavigator: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => AppWheelPicker<T>(
        items: items,
        initialValue: initialValue,
        labelBuilder: labelBuilder,
        title: title,
      ),
    );
  }

  static Future<T?> show<T>(
    BuildContext context, {
    required List<T> items,
    T? initialValue,
    required String Function(T item) labelBuilder,
    String title = AppStrings.selectOptionPrompt,
  }) async {
    final res = await showPicker<T>(
      context,
      items: items,
      initialValue: initialValue,
      labelBuilder: labelBuilder,
      title: title,
    );
    return res?.value;
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
                children: List.generate(widget.items.length, (index) {
                  final item = widget.items[index];
                  final isSelected = index == _selectedIndex;
                  final label = widget.labelBuilder(item);
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      _scrollController.animateToItem(
                        index,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                      );
                      setState(() => _selectedIndex = index);
                    },
                    child: Center(
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
                    ),
                  );
                }),
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
                      Navigator.pop(context, WheelPickerResult<T>(widget.items[_selectedIndex]));
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

/// A DropdownFormField replacement that uses Cupertino [AppWheelPicker] bottom sheet.
class AppWheelPickerField<T> extends FormField<T> {
  final T? value;
  final ValueChanged<T?>? onChanged;

  AppWheelPickerField({
    super.key,
    this.value,
    required List<T> items,
    required String Function(T item) labelBuilder,
    this.onChanged,
    String? title,
    InputDecoration decoration = const InputDecoration(),
    super.validator,
    super.autovalidateMode,
    bool enabled = true,
    String? placeholder,
  }) : super(
          initialValue: value,
          enabled: enabled,
          builder: (FormFieldState<T> field) {
            final _AppWheelPickerFieldState<T> state = field as _AppWheelPickerFieldState<T>;
            final context = state.context;
            final currentValue = state.value;
            final hasValue = currentValue != null;

            return InkWell(
              onTap: enabled && items.isNotEmpty
                  ? () async {
                      final result = await AppWheelPicker.showPicker<T>(
                        context,
                        items: items,
                        initialValue: currentValue,
                        labelBuilder: labelBuilder,
                        title: title ?? decoration.labelText ?? AppStrings.selectOptionPrompt,
                      );

                      if (result != null) {
                        state.didChange(result.value);
                        onChanged?.call(result.value);
                      }
                    }
                  : null,
              borderRadius: BorderRadius.circular(14),
              child: InputDecorator(
                decoration: decoration.copyWith(
                  errorText: state.errorText,
                  enabled: enabled,
                  hintText: placeholder ?? decoration.hintText,
                ),
                isEmpty: !hasValue,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: hasValue
                          ? Text(
                              labelBuilder(currentValue),
                              style: const TextStyle(fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            )
                          : const SizedBox.shrink(),
                    ),
                    Icon(
                      Icons.unfold_more,
                      size: 20,
                      color: enabled ? null : Theme.of(context).disabledColor,
                    ),
                  ],
                ),
              ),
            );
          },
        );

  @override
  FormFieldState<T> createState() => _AppWheelPickerFieldState<T>();
}

class _AppWheelPickerFieldState<T> extends FormFieldState<T> {
  @override
  AppWheelPickerField<T> get widget => super.widget as AppWheelPickerField<T>;

  @override
  void didUpdateWidget(AppWheelPickerField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      setValue(widget.value);
    }
  }

  @override
  void reset() {
    super.reset();
    setValue(widget.value);
  }
}
