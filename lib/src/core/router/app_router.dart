import 'package:go_router/go_router.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/home/presentation/main_shell_screen.dart';
import '../../features/entities/presentation/entities_tab.dart';
import '../../features/entities/presentation/entity_detail_screen.dart';
import '../../features/search/presentation/search_screen.dart';
import '../../features/locations/presentation/locations_graph_screen.dart';
import '../../features/catalog/presentation/catalog_screen.dart';
import '../../features/catalog/presentation/species_detail_screen.dart';
import '../../features/history/presentation/history_tab.dart';

final appRouter = GoRouter(
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
              path: '/entities',
              builder: (context, state) => const EntitiesTab(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/locations',
              builder: (context, state) => const LocationsGraphScreen(),
            ),
            GoRoute(
              path: '/places',
              builder: (context, state) => const LocationsGraphScreen(),
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
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/history',
              builder: (context, state) => const HistoryTab(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/search',
      builder: (context, state) => const SearchScreen(),
    ),
    GoRoute(
      path: '/entity/:id',
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
