import 'package:cinemapedia/presentation/screens/screens.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(initialLocation: '/', routes: [
  GoRoute(
      path: '/',
      name: Home.name,
      builder: (context, state) => const Home(),
      routes: [
        GoRoute(
          path: 'movie/:id',
          name: Movie.name,
          builder: (context, state) {
            final movieId = state.pathParameters['id'] ?? 'no-id';
            return Movie(movieId: movieId);
          },
        )
      ]),
]);
