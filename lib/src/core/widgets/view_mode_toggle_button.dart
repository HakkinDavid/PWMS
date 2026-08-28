import 'package:flutter/material.dart';
import '../constants/app_strings.dart';
import '../domain/item_view_mode.dart';

/// Reusable AppBar action button to toggle between Detailed List and Minecraft Grid view modes.
class ViewModeToggleButton extends StatelessWidget {
  final ItemViewMode viewMode;
  final ValueChanged<ItemViewMode> onChanged;
  final String? tooltip;

  const ViewModeToggleButton({
    super.key,
    required this.viewMode,
    required this.onChanged,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        viewMode == ItemViewMode.detailedList
            ? Icons.view_list
            : Icons.apps,
      ),
      tooltip: tooltip ?? AppStrings.toggleViewModeTooltip,
      onPressed: () {
        onChanged(
          viewMode == ItemViewMode.detailedList
              ? ItemViewMode.minecraftGrid
              : ItemViewMode.detailedList,
        );
      },
    );
  }
}
