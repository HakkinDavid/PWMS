import 'package:go_router/go_router.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/entities/presentation/entity_detail_screen.dart';
import '../../features/search/presentation/search_screen.dart';
import '../../features/places/presentation/places_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/entity/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return EntityDetailScreen(entityId: id);
      },
    ),
    GoRoute(
      path: '/search',
      builder: (context, state) => const SearchScreen(),
    ),
    GoRoute(
      path: '/places',
      builder: (context, state) => const PlacesScreen(),
    ),
  ],
);
