import 'package:flutter/material.dart';
import 'minecraft_grid_cell.dart';

/// Pure presentation card for list items across the app (Instances, Species, Locations, etc.).
/// Encapsulates consistent visual styling: 16px corner radius, standard elevation, selection borders,
/// dimming with grayscale filtering, and standardized leading, title, subtitle, extra content, and trailing slots.
class StandardItemCard extends StatelessWidget {
  final Widget leading;
  final Widget title;
  final Widget? subtitle;
  final List<Widget>? extraContent;
  final Widget? trailing;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool isSelected;
  final bool isDimmed;
  final bool isSelectionMode;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final BorderRadius? borderRadius;

  const StandardItemCard({
    super.key,
    required this.leading,
    required this.title,
    this.subtitle,
    this.extraContent,
    this.trailing,
    this.onTap,
    this.onLongPress,
    this.isSelected = false,
    this.isDimmed = false,
    this.isSelectionMode = false,
    this.margin = const EdgeInsets.only(bottom: 8),
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(16);
    final effectiveIsDimmed = isDimmed || (isSelectionMode && !isSelected);
    final highlightColor = theme.colorScheme.secondary;

    Widget cardWidget = Card(
      margin: margin,
      elevation: isSelected ? 3.0 : (effectiveIsDimmed ? 0.5 : 1.5),
      color: isSelected
          ? highlightColor.withAlpha(35)
          : (effectiveIsDimmed ? theme.cardColor.withAlpha(160) : theme.cardColor),
      shape: RoundedRectangleBorder(
        borderRadius: effectiveBorderRadius,
        side: BorderSide(
          color: isSelected
              ? highlightColor
              : theme.dividerColor.withAlpha(effectiveIsDimmed ? 20 : 40),
          width: isSelected ? 2.5 : 1.0,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: effectiveBorderRadius,
        child: Padding(
          padding: padding,
          child: Row(
            children: [
              leading,
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    title,
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      subtitle!,
                    ],
                    if (extraContent != null && extraContent!.isNotEmpty) ...[
                      ...extraContent!,
                    ],
                  ],
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 8),
                trailing!,
              ],
            ],
          ),
        ),
      ),
    );

    if (effectiveIsDimmed) {
      cardWidget = ColorFiltered(
        colorFilter: const ColorFilter.matrix(kMinecraftGrayscaleColorMatrix),
        child: Opacity(
          opacity: 0.65,
          child: cardWidget,
        ),
      );
    }

    return cardWidget;
  }
}
