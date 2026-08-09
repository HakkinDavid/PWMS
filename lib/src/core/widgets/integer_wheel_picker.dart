import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constants/app_strings.dart';

class IntegerWheelPicker extends StatefulWidget {
  final int initialValue;
  final int minValue;
  final int maxValue;
  final String title;

  const IntegerWheelPicker({
    super.key,
    required this.initialValue,
    this.minValue = 0,
    this.maxValue = 1000,
    this.title = AppStrings.selectMagnitudePrompt,
  });

  static Future<int?> show(
    BuildContext context, {
    required int initialValue,
    int minValue = 0,
    int maxValue = 1000,
    String title = AppStrings.selectMagnitudePrompt,
  }) {
    return showModalBottomSheet<int>(
      context: context,
      useRootNavigator: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => IntegerWheelPicker(
        initialValue: initialValue,
        minValue: minValue,
        maxValue: maxValue,
        title: title,
      ),
    );
  }

  @override
  State<IntegerWheelPicker> createState() => _IntegerWheelPickerState();
}

class _IntegerWheelPickerState extends State<IntegerWheelPicker> {
  late FixedExtentScrollController _scrollController;
  late int _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue.clamp(widget.minValue, widget.maxValue);
    _scrollController = FixedExtentScrollController(
      initialItem: _selectedValue - widget.minValue,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final totalItems = widget.maxValue - widget.minValue + 1;

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
                  setState(() => _selectedValue = widget.minValue + index);
                },
                children: List.generate(totalItems, (idx) {
                  final val = widget.minValue + idx;
                  final isSelected = val == _selectedValue;
                  return Center(
                    child: Text(
                      '$val',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? theme.colorScheme.primary : theme.textTheme.bodyMedium?.color,
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
                  onPressed: () => Navigator.pop(context, _selectedValue),
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
