import 'package:flutter/material.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import 'package:platinum_world_management_system/src/core/constants/app_technical_strings.dart';
import '../../domain/numismatic_data_helper.dart';

/// Presentation widget displaying rich metallurgical metadata, purity badges, and alloy breakdowns
/// derived in O(1) from [NumismaticMaterialDefinition] without modifying underlying 4NF storage.
class NumismaticMaterialBadge extends StatelessWidget {
  final String material;
  final bool compact;
  final bool showLabel;

  const NumismaticMaterialBadge({
    super.key,
    required this.material,
    this.compact = false,
    this.showLabel = true,
  });

  @override
  Widget build(BuildContext context) {
    final clean = material.trim();
    if (clean.isEmpty) return const SizedBox.shrink();

    final def = NumismaticDataHelper.getMaterialDefinition(clean);
    if (def == null) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final badgeColor = _getFamilyColor(def.family);
    final String? pillText = _getPillText(def);

    if (pillText == null && def.alloyComposition == null && def.coreMaterial == null) {
      return const SizedBox.shrink();
    }

    final tooltipMessage = _buildTooltipMessage(def);

    final chipWidget = Container(
      padding: EdgeInsets.symmetric(horizontal: compact ? 6 : 8, vertical: compact ? 2 : 4),
      decoration: BoxDecoration(
        color: badgeColor.withAlpha(isDark ? 45 : 30),
        borderRadius: BorderRadius.circular(compact ? 6 : 8),
        border: Border.all(
          color: badgeColor.withAlpha(isDark ? 160 : 120),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getFamilyIcon(def.family, def.structure),
            size: compact ? 11 : 13,
            color: badgeColor,
          ),
          if (pillText != null && showLabel) ...[
            const SizedBox(width: 4),
            Text(
              pillText,
              style: TextStyle(
                fontSize: compact ? 10 : 11,
                fontWeight: FontWeight.w600,
                color: isDark ? badgeColor : Color.alphaBlend(badgeColor, Colors.black87),
              ),
            ),
          ],
        ],
      ),
    );

    if (tooltipMessage.isEmpty) {
      return chipWidget;
    }

    return Tooltip(
      message: tooltipMessage,
      preferBelow: false,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2C) : const Color(0xFF333333),
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: const TextStyle(fontSize: 11, color: Colors.white),
      child: chipWidget,
    );
  }

  static Color _getFamilyColor(NumismaticMaterialFamily family) {
    switch (family) {
      case NumismaticMaterialFamily.gold:
        return const Color(0xFFE6A100);
      case NumismaticMaterialFamily.silver:
        return const Color(0xFF607D8B);
      case NumismaticMaterialFamily.platinum:
      case NumismaticMaterialFamily.palladium:
        return const Color(0xFF0097A7);
      case NumismaticMaterialFamily.copper:
      case NumismaticMaterialFamily.bronze:
        return const Color(0xFFBF5B2B);
      case NumismaticMaterialFamily.brass:
        return const Color(0xFFC0A000);
      case NumismaticMaterialFamily.bimetallic:
      case NumismaticMaterialFamily.trimetallic:
        return const Color(0xFF673AB7);
      case NumismaticMaterialFamily.paper:
      case NumismaticMaterialFamily.polymer:
        return const Color(0xFF00897B);
      case NumismaticMaterialFamily.steel:
      case NumismaticMaterialFamily.aluminum:
      case NumismaticMaterialFamily.nickel:
      case NumismaticMaterialFamily.zinc:
      case NumismaticMaterialFamily.cupronickel:
      case NumismaticMaterialFamily.other:
        return const Color(0xFF546E7A);
    }
  }

  static IconData _getFamilyIcon(NumismaticMaterialFamily family, NumismaticMaterialStructure structure) {
    if (structure == NumismaticMaterialStructure.bimetallic ||
        structure == NumismaticMaterialStructure.trimetallic) {
      return Icons.radio_button_checked;
    }
    if (structure == NumismaticMaterialStructure.plated ||
        structure == NumismaticMaterialStructure.clad) {
      return Icons.layers_outlined;
    }
    switch (family) {
      case NumismaticMaterialFamily.gold:
      case NumismaticMaterialFamily.silver:
      case NumismaticMaterialFamily.platinum:
      case NumismaticMaterialFamily.palladium:
        return Icons.auto_awesome;
      case NumismaticMaterialFamily.paper:
      case NumismaticMaterialFamily.polymer:
        return Icons.receipt_long;
      default:
        return Icons.circle_outlined;
    }
  }

  static String? _getPillText(NumismaticMaterialDefinition def) {
    if (def.fineness != null) {
      if (def.fineness! >= 0.999) {
        return AppStrings.materialPureFineness;
      }
      return AppStrings.materialLeyFineness((def.fineness! * 1000).toInt());
    }
    if (def.structure == NumismaticMaterialStructure.bimetallic) {
      return AppStrings.materialPillBimetallic;
    }
    if (def.structure == NumismaticMaterialStructure.trimetallic) {
      return AppStrings.materialPillTrimetallic;
    }
    if (def.structure == NumismaticMaterialStructure.plated) {
      return AppStrings.materialPillPlated;
    }
    if (def.structure == NumismaticMaterialStructure.clad) {
      return AppStrings.materialPillClad;
    }
    if (def.family == NumismaticMaterialFamily.polymer) {
      return AppStrings.materialPillPolymer;
    }
    if (def.family == NumismaticMaterialFamily.paper) {
      return AppStrings.materialPillPaper;
    }
    return null;
  }

  static String _buildTooltipMessage(NumismaticMaterialDefinition def) {
    final parts = <String>[];
    parts.add(def.displayName);

    if (def.fineness != null) {
      final pct = (def.fineness! * 100).toStringAsFixed(1).replaceAll(AppTechnicalStrings.pointZero, AppTechnicalStrings.empty);
      parts.add(AppStrings.materialPurityTooltip(pct, def.fineness!));
    }

    if (def.alloyComposition != null && def.alloyComposition!.isNotEmpty) {
      parts.add(AppStrings.materialAlloyTooltip(def.alloyComposition!));
    }

    if (def.coreMaterial != null && def.ringMaterial != null) {
      parts.add(AppStrings.materialBimetallicTooltip(def.coreMaterial!, def.ringMaterial!));
    }

    if (def.platingMaterial != null) {
      parts.add(AppStrings.materialPlatedTooltip(def.platingMaterial!));
    }

    return parts.join(AppTechnicalStrings.newline);
  }
}
