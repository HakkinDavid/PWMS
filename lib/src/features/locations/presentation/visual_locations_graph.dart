import 'dart:math';
import 'package:flutter/material.dart';
import '../domain/location_node.dart';
import '../infrastructure/location_repository.dart';
import '../../entities/domain/world_entity.dart';


class VisualLocationsGraph extends StatefulWidget {
  final List<LocationNode> nodes;
  final List<WorldEntity> entities;
  final String? focusNodeId;
  final ValueChanged<LocationNode> onNodeSelected;

  const VisualLocationsGraph({
    super.key,
    required this.nodes,
    required this.entities,
    this.focusNodeId,
    required this.onNodeSelected,
  });

  @override
  State<VisualLocationsGraph> createState() => _VisualLocationsGraphState();
}

class _VisualLocationsGraphState extends State<VisualLocationsGraph> {
  final TransformationController _transformationController = TransformationController();

  Map<String, Offset> _calculateNodePositions(Size canvasSize) {
    final Map<String, Offset> positions = {};
    final rootNodes = widget.nodes.where((n) => n.parentLocationId == null).toList();
    if (rootNodes.isEmpty) return positions;

    final double width = max(canvasSize.width, 800.0);
    const double levelHeight = 140.0;

    void layoutLevel(List<LocationNode> levelNodes, int depth, double startX, double endX) {
      if (levelNodes.isEmpty) return;
      final double step = (endX - startX) / (levelNodes.length + 1);

      for (int i = 0; i < levelNodes.length; i++) {
        final node = levelNodes[i];
        final x = startX + step * (i + 1);
        final y = 80.0 + depth * levelHeight;
        positions[node.id] = Offset(x, y);

        final children = widget.nodes.where((n) => n.parentLocationId == node.id).toList();
        if (children.isNotEmpty) {
          final double childStartX = startX + step * i;
          final double childEndX = startX + step * (i + 1);
          layoutLevel(children, depth + 1, childStartX, childEndX);
        }
      }
    }

    layoutLevel(rootNodes, 0, 0.0, width);
    return positions;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canvasSize = Size(MediaQuery.of(context).size.width, 1000);
    final positions = _calculateNodePositions(canvasSize);

    return InteractiveViewer(
      transformationController: _transformationController,
      constrained: false,
      boundaryMargin: const EdgeInsets.all(200),
      minScale: 0.5,
      maxScale: 2.5,
      child: Container(
        width: max(MediaQuery.of(context).size.width, 800),
        height: 1000,
        color: theme.colorScheme.surface,
        child: Stack(
          children: [
            // Directed Edges (Arrows)
            CustomPaint(
              size: canvasSize,
              painter: _GraphEdgesPainter(
                nodes: widget.nodes,
                positions: positions,
                lineColor: theme.colorScheme.primary.withAlpha(120),
              ),
            ),

            // Node Widgets (Circles with Icons & Badges)
            ...widget.nodes.map((node) {
              final pos = positions[node.id] ?? const Offset(100, 100);
              final isFocused = node.id == widget.focusNodeId;
              final itemCount = LocationRepository.getRecursiveItemCount(node.id, widget.nodes, widget.entities);

              return Positioned(
                left: pos.dx - 36,
                top: pos.dy - 36,
                child: GestureDetector(
                  onTap: () => widget.onNodeSelected(node),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isFocused
                              ? theme.colorScheme.primary
                              : theme.colorScheme.surfaceContainerHighest,
                          border: Border.all(
                            color: isFocused ? Colors.amber : theme.colorScheme.primary,
                            width: isFocused ? 3.5 : 2.0,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(30),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(
                              node.parentLocationId == null ? Icons.public : Icons.location_on,
                              color: isFocused ? Colors.white : theme.colorScheme.primary,
                              size: 28,
                            ),
                            Positioned(
                              right: 2,
                              top: 2,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.amber,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  '$itemCount',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface.withAlpha(220),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: theme.dividerColor),
                        ),
                        child: Text(
                          node.name,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: isFocused ? FontWeight.bold : FontWeight.normal,
                            color: isFocused ? theme.colorScheme.primary : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _GraphEdgesPainter extends CustomPainter {
  final List<LocationNode> nodes;
  final Map<String, Offset> positions;
  final Color lineColor;

  _GraphEdgesPainter({
    required this.nodes,
    required this.positions,
    required this.lineColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final arrowPaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.fill;

    for (final node in nodes) {
      if (node.parentLocationId != null && positions.containsKey(node.parentLocationId)) {
        final parentPos = positions[node.parentLocationId]!;
        final childPos = positions[node.id]!;

        // Draw line between centers
        canvas.drawLine(parentPos, childPos, paint);

        // Draw arrow near child node
        final double angle = atan2(childPos.dy - parentPos.dy, childPos.dx - parentPos.dx);
        const double arrowDist = 32.0; // Radius of node circle
        final Offset arrowTip = Offset(
          childPos.dx - arrowDist * cos(angle),
          childPos.dy - arrowDist * sin(angle),
        );

        final path = Path()
          ..moveTo(arrowTip.dx, arrowTip.dy)
          ..lineTo(
            arrowTip.dx - 10 * cos(angle - pi / 6),
            arrowTip.dy - 10 * sin(angle - pi / 6),
          )
          ..lineTo(
            arrowTip.dx - 10 * cos(angle + pi / 6),
            arrowTip.dy - 10 * sin(angle + pi / 6),
          )
          ..close();

        canvas.drawPath(path, arrowPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _GraphEdgesPainter oldDelegate) {
    return oldDelegate.positions != positions;
  }
}
