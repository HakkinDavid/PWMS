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
import '../../features/history/presentation/history_screen.dart';

import '../../features/control_center/presentation/control_center_screen.dart';
import 'package:platinum_world_management_system/src/core/constants/app_technical_strings.dart';
export 'app_navigation_extension.dart';


final rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: AppTechnicalRoutes.root,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainShellScreen(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppTechnicalRoutes.root,
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppTechnicalRoutes.inventory,
              builder: (context, state) {
                final locId = state.uri.queryParameters[AppTechnicalRoutes.paramFocusNodeId] ?? state.uri.queryParameters[AppTechnicalRoutes.paramLocationId];
                final containerId = state.uri.queryParameters[AppTechnicalRoutes.paramContainerId];
                final targetEntityId = state.uri.queryParameters[AppTechnicalRoutes.paramTargetEntityId];
                return InventoryFinderScreen(
                  key: inventoryFinderKey,
                  initialLocationId: locId,
                  initialContainerId: containerId,
                  initialTargetEntityId: targetEntityId,
                );
              },
            ),
            GoRoute(
              path: AppTechnicalRoutes.entities,
              builder: (context, state) {
                final locId = state.uri.queryParameters[AppTechnicalRoutes.paramFocusNodeId] ?? state.uri.queryParameters[AppTechnicalRoutes.paramLocationId];
                final containerId = state.uri.queryParameters[AppTechnicalRoutes.paramContainerId];
                final targetEntityId = state.uri.queryParameters[AppTechnicalRoutes.paramTargetEntityId];
                return InventoryFinderScreen(
                  key: inventoryFinderKey,
                  initialLocationId: locId,
                  initialContainerId: containerId,
                  initialTargetEntityId: targetEntityId,
                );
              },
            ),
            GoRoute(
              path: AppTechnicalRoutes.locations,
              builder: (context, state) {
                final locId = state.uri.queryParameters[AppTechnicalRoutes.paramFocusNodeId] ?? state.uri.queryParameters[AppTechnicalRoutes.paramLocationId];
                final containerId = state.uri.queryParameters[AppTechnicalRoutes.paramContainerId];
                final targetEntityId = state.uri.queryParameters[AppTechnicalRoutes.paramTargetEntityId];
                return InventoryFinderScreen(
                  key: inventoryFinderKey,
                  initialLocationId: locId,
                  initialContainerId: containerId,
                  initialTargetEntityId: targetEntityId,
                  startWithCurtainOpen: locId == null && containerId == null,
                );
              },
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppTechnicalRoutes.catalog,
              builder: (context, state) {
                final speciesId = state.uri.queryParameters[AppTechnicalRoutes.paramSpeciesId];
                final filter = state.uri.queryParameters[AppTechnicalRoutes.paramFilter];
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
              path: AppTechnicalRoutes.search,
              builder: (context, state) {
                final q = state.uri.queryParameters[AppTechnicalRoutes.paramQ];
                final scope = state.uri.queryParameters[AppTechnicalRoutes.paramScope];
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
      path: AppTechnicalRoutes.notifications,
      builder: (context, state) => const NotificationsScreen(),
    ),

    GoRoute(
      path: AppTechnicalRoutes.register,
      builder: (context, state) {
        final initialLocId = state.uri.queryParameters[AppTechnicalRoutes.paramInitialLocationId];
        final startInCreate = state.uri.queryParameters[AppTechnicalRoutes.paramStartInCreateSpecies] == AppTechnicalStrings.boolTrue;
        final scannedResult = state.extra;
        return RegisterObjectModal(
          initialLocationId: initialLocId,
          startInCreateSpecies: startInCreate,
          scannedResult: scannedResult,
        );
      },
    ),
    GoRoute(
      path: AppTechnicalRoutes.controlCenter,
      builder: (context, state) => const ControlCenterScreen(),
    ),
    GoRoute(
      path: AppTechnicalRoutes.settings,
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: AppTechnicalRoutes.history,
      builder: (context, state) => const HistoryScreen(),
    ),
    GoRoute(
      path: AppTechnicalRoutes.entityDetailLegacy,
      builder: (context, state) {
        final id = state.pathParameters[AppTechnicalRoutes.paramId]!;
        return EntityDetailScreen(entityId: id);
      },
    ),
    GoRoute(
      path: AppTechnicalRoutes.entityDetail,
      builder: (context, state) {
        final id = state.pathParameters[AppTechnicalRoutes.paramId]!;
        return EntityDetailScreen(entityId: id);
      },
    ),
    GoRoute(
      path: AppTechnicalRoutes.catalogDetail,
      builder: (context, state) {
        final id = state.pathParameters[AppTechnicalRoutes.paramId]!;
        return SpeciesDetailScreen(speciesId: id);
      },
    ),
  ],
);
