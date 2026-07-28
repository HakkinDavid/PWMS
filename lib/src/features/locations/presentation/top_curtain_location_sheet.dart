import 'package:flutter/material.dart';
import '../domain/location_node.dart';

class TopCurtainLocationSheet extends StatefulWidget {
  final List<LocationNode> allLocations;
  final String? selectedLocationId;
  final ValueChanged<String?> onLocationSelected;
  final Function(Object payload, String targetLocationId) onDropOnLocation;

  const TopCurtainLocationSheet({
    super.key,
    required this.allLocations,
    required this.selectedLocationId,
    required this.onLocationSelected,
    required this.onDropOnLocation,
  });

  @override
  State<TopCurtainLocationSheet> createState() => _TopCurtainLocationSheetState();
}

class _TopCurtainLocationSheetState extends State<TopCurtainLocationSheet> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _expandAnimation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  String _buildBreadcrumbPath() {
    if (widget.selectedLocationId == null) return 'Inventario Principal (Todas las ubicaciones)';
    final locMap = {for (var l in widget.allLocations) l.id: l};

    final path = <String>[];
    String? currId = widget.selectedLocationId;
    while (currId != null && locMap.containsKey(currId)) {
      final node = locMap[currId]!;
      path.insert(0, node.name);
      currId = node.parentLocationId;
    }

    return path.isEmpty ? 'Ubicación Desconocida' : path.join(' > ');
  }

  Widget _buildTreeItem(LocationNode node, int depth) {
    final children = widget.allLocations.where((l) => l.parentLocationId == node.id).toList();
    final isSelected = node.id == widget.selectedLocationId;
    final theme = Theme.of(context);

    return DragTarget<Object>(
      onWillAcceptWithDetails: (details) => true,
      onAcceptWithDetails: (details) {
        widget.onDropOnLocation(details.data, node.id);
      },
      builder: (context, candidateData, rejectedData) {
        final isHovered = candidateData.isNotEmpty;

        return Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: depth * 16.0, top: 4, bottom: 4),
              decoration: BoxDecoration(
                color: isHovered
                    ? theme.colorScheme.primaryContainer
                    : (isSelected ? theme.colorScheme.primary.withAlpha(30) : null),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                dense: true,
                visualDensity: VisualDensity.compact,
                leading: Icon(
                  children.isNotEmpty ? Icons.folder_outlined : Icons.location_on_outlined,
                  color: isSelected ? theme.colorScheme.primary : Colors.grey,
                ),
                title: Text(
                  node.name,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? theme.colorScheme.primary : null,
                  ),
                ),
                onTap: () {
                  widget.onLocationSelected(node.id);
                  _toggleExpand();
                },
              ),
            ),
            if (children.isNotEmpty)
              ...children.map((child) => _buildTreeItem(child, depth + 1)),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rootLocations = widget.allLocations.where((l) => l.parentLocationId == null).toList();

    return DragTarget<Object>(
      onWillAcceptWithDetails: (_) {
        if (!_isExpanded) {
          _toggleExpand();
        }
        return true;
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(20),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Breadcrumbs Route Header Bar
              InkWell(
                onTap: _toggleExpand,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  child: Row(
                    children: [
                      Icon(Icons.route_outlined, size: 20, color: theme.colorScheme.primary),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _buildBreadcrumbPath(),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.primary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: AnimatedRotation(
                          turns: _isExpanded ? 0.5 : 0.0,
                          duration: const Duration(milliseconds: 200),
                          child: const Icon(Icons.keyboard_arrow_down),
                        ),
                        onPressed: _toggleExpand,
                      ),
                    ],
                  ),
                ),
              ),

              // Expandable Tree View Curtain
              SizeTransition(
                sizeFactor: _expandAnimation,
                child: Container(
                  constraints: const BoxConstraints(maxHeight: 280),
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          dense: true,
                          visualDensity: VisualDensity.compact,
                          leading: const Icon(Icons.all_inbox_outlined),
                          title: const Text('Todas las ubicaciones', style: TextStyle(fontWeight: FontWeight.bold)),
                          selected: widget.selectedLocationId == null,
                          onTap: () {
                            widget.onLocationSelected(null);
                            _toggleExpand();
                          },
                        ),
                        const Divider(),
                        ...rootLocations.map((root) => _buildTreeItem(root, 0)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
