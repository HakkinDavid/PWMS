import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/home/presentation/inventory_finder_screen.dart';
import '../../features/home/presentation/main_shell_screen.dart';
import '../../features/home/presentation/settings_screen.dart';

import '../../features/entities/presentation/entity_detail_screen.dart';
import '../../features/entities/presentation/grouped_instance_detail_screen.dart';
import '../../features/search/presentation/search_screen.dart';
import '../../features/catalog/presentation/catalog_screen.dart';
import '../../features/catalog/presentation/species_detail_screen.dart';
import '../../features/notifications/presentation/notifications_screen.dart';

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
              builder: (context, state) => const InventoryFinderScreen(),
            ),
            GoRoute(
              path: '/entities',
              builder: (context, state) => const InventoryFinderScreen(),
            ),
            GoRoute(
              path: '/locations',
              builder: (context, state) => const InventoryFinderScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/catalog',
              builder: (context, state) => const CatalogScreen(),
            ),
          ],
        ),
      ],
    ),

    GoRoute(
      path: '/grouped-instance-detail',
      builder: (context, state) {
        final speciesId = state.uri.queryParameters['speciesId'] ?? '';
        final locId = state.uri.queryParameters['locId'];
        return GroupedInstanceDetailScreen(
          speciesId: speciesId,
          effectiveLocationId: locId != null && locId.isNotEmpty ? locId : null,
        );
      },
    ),
    GoRoute(
      path: '/search',
      builder: (context, state) => const SearchScreen(),
    ),
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationsScreen(),
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
