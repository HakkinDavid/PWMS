import 'package:flutter/material.dart';

class SpeciesTextBadgeAvatar extends StatelessWidget {
  final String speciesName;
  final double size;
  final Color? backgroundColor;
  final Color? textColor;
  final BorderRadius? borderRadius;

  const SpeciesTextBadgeAvatar({
    super.key,
    required this.speciesName,
    this.size = 48,
    this.backgroundColor,
    this.textColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bg = backgroundColor ?? theme.colorScheme.primary.withAlpha(25);
    final fg = textColor ?? theme.colorScheme.primary;
    final r = borderRadius ?? BorderRadius.circular(10);

    final displayName = speciesName.trim().isNotEmpty ? speciesName.trim() : 'Especie';

    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: r,
        border: Border.all(
          color: fg.withAlpha(50),
          width: 1,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        displayName,
        textAlign: TextAlign.center,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: (size * 0.22).clamp(8.0, 11.0),
          fontWeight: FontWeight.bold,
          height: 1.1,
          color: fg,
        ),
      ),
    );
  }
}
