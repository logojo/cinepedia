import 'package:cinemapedia/presentation/screens/screens.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(initialLocation: '/home/0', routes: [
  GoRoute(
      path: '/home/:page',
      name: Home.name,
      builder: (context, state) {
        final pageIndex = int.parse(state.pathParameters['page'] ?? '0');

        if (pageIndex > 2 || pageIndex < 0) {
          return const Home(pageIndex: 0);
        }
        return Home(pageIndex: pageIndex);
      },
      routes: [
        GoRoute(
          path: 'movie/:id',
          name: MovieScreen.name,
          builder: (context, state) {
            final movieId = state.pathParameters['id'] ?? 'no-id';
            return MovieScreen(movieId: movieId);
          },
        )
      ]),
  GoRoute(
    path: '/',
    redirect: (_, __) =>
        '/home/0', // normalmente seria así (context, state) => pero se pone el _ para indicar que no necesito ningun parametro
  )
]);
