import 'package:flutter/material.dart';

const List<double> kMinecraftGrayscaleColorMatrix = <double>[
  0.2126, 0.7152, 0.0722, 0, 0,
  0.2126, 0.7152, 0.0722, 0, 0,
  0.2126, 0.7152, 0.0722, 0, 0,
  0,      0,      0,      1, 0,
];

/// Pure presentation container for a square Minecraft-style cell.
/// Handles visual framing, selection glow, borders, status badges and grayscale filtering when dimmed.
class MinecraftGridCell extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool isSelected;
  final bool isDimmed;
  final bool isExpired;
  final Widget? topLeftBadge;
  final Widget? bottomRightBadge;
  final Widget? topRightBadge;
  final Widget? bottomLeftBadge;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry padding;

  const MinecraftGridCell({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.isSelected = false,
    this.isDimmed = false,
    this.isExpired = false,
    this.topLeftBadge,
    this.bottomRightBadge,
    this.topRightBadge,
    this.bottomLeftBadge,
    this.borderRadius,
    this.padding = const EdgeInsets.all(8.0),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(16);
    final highlightColor = theme.colorScheme.secondary;

    Widget tileContent = Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: effectiveBorderRadius,
        onTap: onTap,
        onLongPress: onLongPress,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          decoration: BoxDecoration(
            color: isSelected
                ? highlightColor.withAlpha(50)
                : (isDimmed
                    ? theme.colorScheme.surfaceContainerHighest.withAlpha(60)
                    : theme.colorScheme.surfaceContainerHighest.withAlpha(120)),
            borderRadius: effectiveBorderRadius,
            border: Border.all(
              color: isSelected
                  ? highlightColor
                  : (isExpired
                      ? Colors.redAccent.withAlpha(180)
                      : theme.dividerColor.withAlpha(isDimmed ? 20 : 50)),
              width: isSelected ? 3.0 : 1.0,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: highlightColor.withAlpha(80),
                      blurRadius: 8,
                      spreadRadius: 1,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withAlpha(isDimmed ? 5 : 15),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
          ),
          child: Stack(
            children: [
              // Center Content
              Center(
                child: Padding(
                  padding: padding,
                  child: child,
                ),
              ),

              // Top Left Overlay Badge (Status / Alert / Custom)
              if (topLeftBadge != null)
                Positioned(
                  top: 6,
                  left: 6,
                  child: topLeftBadge!,
                )
              else if (isExpired)
                Positioned(
                  top: 6,
                  left: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.warning_amber_rounded,
                      size: 12,
                      color: Colors.white,
                    ),
                  ),
                ),

              // Top Right Overlay Badge
              if (topRightBadge != null)
                Positioned(
                  top: 6,
                  right: 6,
                  child: topRightBadge!,
                ),

              // Bottom Left Overlay Badge
              if (bottomLeftBadge != null)
                Positioned(
                  bottom: 6,
                  left: 6,
                  child: bottomLeftBadge!,
                ),

              // Bottom Right Overlay Badge (Count / Population / Custom)
              if (bottomRightBadge != null)
                Positioned(
                  bottom: 6,
                  right: 6,
                  child: bottomRightBadge!,
                ),
            ],
          ),
        ),
      ),
    );

    if (isDimmed) {
      tileContent = ColorFiltered(
        colorFilter: const ColorFilter.matrix(kMinecraftGrayscaleColorMatrix),
        child: Opacity(
          opacity: 0.65,
          child: tileContent,
        ),
      );
    }

    return tileContent;
  }
}
