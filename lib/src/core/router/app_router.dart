import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/home/presentation/inventory_finder_screen.dart';
import '../../features/home/presentation/main_shell_screen.dart';
import '../../features/home/presentation/settings_screen.dart';

import '../../features/entities/presentation/entity_detail_screen.dart';
import '../../features/entities/presentation/register_object_modal.dart';
import '../../features/search/presentation/search_screen.dart';
import '../../features/catalog/presentation/catalog_screen.dart';
import '../../features/catalog/presentation/species_detail_screen.dart';
import '../../features/notifications/presentation/notifications_screen.dart';

import '../../features/control_center/presentation/control_center_screen.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
export 'app_navigation_extension.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainShellScreen(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/inventory',
              builder: (context, state) {
                final locId = state.uri.queryParameters['focusNodeId'] ?? state.uri.queryParameters['locationId'];
                final containerId = state.uri.queryParameters['containerId'];
                return InventoryFinderScreen(
                  initialLocationId: locId,
                  initialContainerId: containerId,
                );
              },
            ),
            GoRoute(
              path: '/entities',
              builder: (context, state) {
                final locId = state.uri.queryParameters['focusNodeId'] ?? state.uri.queryParameters['locationId'];
                final containerId = state.uri.queryParameters['containerId'];
                return InventoryFinderScreen(
                  initialLocationId: locId,
                  initialContainerId: containerId,
                );
              },
            ),
            GoRoute(
              path: '/locations',
              builder: (context, state) {
                final locId = state.uri.queryParameters['focusNodeId'] ?? state.uri.queryParameters['locationId'];
                final containerId = state.uri.queryParameters['containerId'];
                return InventoryFinderScreen(
                  initialLocationId: locId,
                  initialContainerId: containerId,
                  startWithCurtainOpen: locId == null && containerId == null,
                );
              },
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/catalog',
              builder: (context, state) {
                final speciesId = state.uri.queryParameters['speciesId'];
                final filter = state.uri.queryParameters['filter'];
                return CatalogScreen(
                  initialSpeciesId: speciesId,
                  initialFilter: filter,
                );
              },
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/search',
              builder: (context, state) {
                final q = state.uri.queryParameters['q'];
                final scope = state.uri.queryParameters['scope'];
                return SearchScreen(
                  initialQuery: q,
                  initialScope: scope,
                );
              },
            ),
          ],
        ),
      ],
    ),

    GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationsScreen(),
    ),

    GoRoute(
      path: '/register',
      builder: (context, state) {
        final initialLocId = state.uri.queryParameters['initialLocationId'];
        final startInCreate = state.uri.queryParameters['startInCreateSpecies'] == 'true';
        final scannedResult = state.extra;
        return RegisterObjectModal(
          initialLocationId: initialLocId,
          startInCreateSpecies: startInCreate,
          scannedResult: scannedResult,
        );
      },
    ),
    GoRoute(
      path: '/control-center',
      builder: (context, state) => const ControlCenterScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/entity/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return EntityDetailScreen(entityId: id);
      },
    ),
    GoRoute(
      path: '/entities/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return EntityDetailScreen(entityId: id);
      },
    ),
    GoRoute(
      path: '/catalog/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return SpeciesDetailScreen(speciesId: id);
      },
    ),
  ],
);
