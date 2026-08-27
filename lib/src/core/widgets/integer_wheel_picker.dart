import 'package:flutter/material.dart';
import '../constants/app_strings.dart';
import 'app_wheel_picker.dart';

class IntegerWheelPicker extends StatelessWidget {
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
    final count = maxValue >= minValue ? maxValue - minValue + 1 : 0;
    final items = List<int>.generate(count, (index) => minValue + index);

    return AppWheelPicker.show<int>(
      context,
      items: items,
      initialValue: initialValue.clamp(minValue, maxValue),
      labelBuilder: (val) => '$val',
      title: title,
    );
  }

  @override
  Widget build(BuildContext context) {
    final count = maxValue >= minValue ? maxValue - minValue + 1 : 0;
    final items = List<int>.generate(count, (index) => minValue + index);

    return AppWheelPicker<int>(
      items: items,
      initialValue: initialValue.clamp(minValue, maxValue),
      labelBuilder: (val) => '$val',
      title: title,
    );
  }
}

