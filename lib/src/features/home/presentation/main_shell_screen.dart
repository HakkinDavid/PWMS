import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import '../../entities/presentation/register_object_modal.dart';
import 'inventory_finder_screen.dart';

class MainShellScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainShellScreen({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: navigationShell.currentIndex == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (navigationShell.currentIndex == 1) {
          final handled = inventoryFinderKey.currentState?.handleBackNavigation() ?? false;
          if (!handled) {
            navigationShell.goBranch(0);
          }
        } else if (navigationShell.currentIndex != 0) {
          navigationShell.goBranch(0);
        }
      },
      child: Scaffold(
        body: navigationShell,
        floatingActionButton: FloatingActionButton(
          onPressed: () => RegisterObjectModal.show(context),
          tooltip: AppStrings.registerObjectTitle,
          child: const Icon(Icons.add),
        ),
        bottomNavigationBar: NavigationBar(
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: (index) {
            navigationShell.goBranch(
              index,
              initialLocation: index == navigationShell.currentIndex,
            );
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: AppStrings.tabHome,
            ),
            NavigationDestination(
              icon: Icon(Icons.inventory_2_outlined),
              selectedIcon: Icon(Icons.inventory_2),
              label: AppStrings.tabInventory,
            ),
            NavigationDestination(
              icon: Icon(Icons.category_outlined),
              selectedIcon: Icon(Icons.category),
              label: AppStrings.tabCatalog,
            ),
            NavigationDestination(
              icon: Icon(Icons.search_outlined),
              selectedIcon: Icon(Icons.search),
              label: AppStrings.tabSearch,
            ),
          ],
        ),
      ),
    );
  }
}
