import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final nowPlayingMoviesProvider =
    StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  //obteniendo el listado de peliculas y asignado la funcion getNowPlaying a una variable
  //para que este se pase como parametro al MoviesNotifier
  final fetchMoreMovies = ref.watch(movieRepositoryProvider).getNowPlaying;

  return MoviesNotifier(fetchMoreMovies: fetchMoreMovies);
});

//* populares
final popularesProvider =
    StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  final fetchPopularMovies = ref.watch(movieRepositoryProvider).getPupolar;

  return MoviesNotifier(fetchMoreMovies: fetchPopularMovies);
});

//* topRated
final topRatedProvider =
    StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  final fetchMovies = ref.watch(movieRepositoryProvider).getTopRated;

  return MoviesNotifier(fetchMoreMovies: fetchMovies);
});

//*upcoming
final upcomingProvider =
    StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  final fetchMovies = ref.watch(movieRepositoryProvider).getUpComming;

  return MoviesNotifier(fetchMoreMovies: fetchMovies);
});

//en esta función definimos el caso de uso
//Es decir que funcion se va a llamar para los datos
typedef MovieCallback = Future<List<Movie>> Function({int page});

class MoviesNotifier extends StateNotifier<List<Movie>> {
  int currenPage = 0;
  bool isLoading = false;
  MovieCallback fetchMoreMovies;

  MoviesNotifier({
    required this.fetchMoreMovies,
  }) : super([]);

  Future<void> loadNextPAge() async {
    if (isLoading) return;

    //Con esta variable se inpide que se hagan varias peticiones  simultaneas y sobrecargar los recursos
    isLoading = true;
    currenPage++;

    final List<Movie> movies = await fetchMoreMovies(page: currenPage);

    //regresando el nuevo esdado -> nuevo listado de peliculas
    state = [...state, ...movies];
    isLoading = false;
  }
}
