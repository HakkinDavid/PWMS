import 'package:flutter/material.dart';
import '../../../../core/domain/entities/entity_id.dart';
import '../../../entity_management/presentation/controllers/world_explorer_controller.dart';
import '../../../entity_management/presentation/screens/unified_register_modal.dart';
import '../../../entity_management/presentation/screens/world_explorer_screen.dart';
import 'home_screen.dart';

/// Shell Principal de Navegación por Tareas en PWMS (3 Pestañas Persistentes).
class MainShellScreen extends StatefulWidget {
  final WorldExplorerController controller;

  const MainShellScreen({super.key, required this.controller});

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  int _currentIndex = 0;

  void _openRegisterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => UnifiedRegisterModal(
        controller: widget.controller,
      ),
    );
  }

  void _navigateToExplorerAtContainer(EntityId? containerId) {
    widget.controller.openContainer(containerId);
    setState(() => _currentIndex = 1); // Cambia a la pestaña Explorador
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 600;

    final pages = [
      HomeScreen(
        controller: widget.controller,
        onNavigateToExplorer: _navigateToExplorerAtContainer,
      ),
      WorldExplorerScreen(controller: widget.controller),
    ];

    if (isWide) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: _currentIndex,
              onDestinationSelected: (index) {
                if (index == 2) {
                  _openRegisterModal();
                } else {
                  setState(() => _currentIndex = index);
                }
              },
              labelType: NavigationRailLabelType.all,
              leading: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: FloatingActionButton(
                  heroTag: null,
                  onPressed: _openRegisterModal,
                  elevation: 0,
                  child: const Icon(Icons.add_rounded),
                ),
              ),
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.search_outlined),
                  selectedIcon: Icon(Icons.search_rounded),
                  label: Text('Buscar'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.explore_outlined),
                  selectedIcon: Icon(Icons.explore_rounded),
                  label: Text('Explorar'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.add_circle_outline_rounded),
                  selectedIcon: Icon(Icons.add_circle_rounded),
                  label: Text('Registrar'),
                ),
              ],
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(
              child: IndexedStack(
                index: _currentIndex,
                children: pages,
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          if (index == 2) {
            _openRegisterModal();
          } else {
            setState(() => _currentIndex = index);
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search_rounded),
            label: 'Buscar',
          ),
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore_rounded),
            label: 'Explorar',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_circle_outline_rounded),
            selectedIcon: Icon(Icons.add_circle_rounded),
            label: 'Registrar',
          ),
        ],
      ),
    );
  }
}
