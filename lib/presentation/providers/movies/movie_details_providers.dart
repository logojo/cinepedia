import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//implementado MovieMapNotifier en otro provider

final movieDetailsProvider =
    StateNotifierProvider<MovieMapNotifier, Map<String, Movie>>((ref) {
  final moviesRepository = ref.watch(movieRepositoryProvider);
  return MovieMapNotifier(getMovie: moviesRepository.getMovieByid);
});

// typedef se usa para definir un alias para una función
//Y poder definir una variable con este tipo de tipado
typedef GetMovieCallback = Future<Movie> Function(String movieId);

//Este notifier tambien nos ayuda a mantener en cache las movies que ya han sido buscadas
class MovieMapNotifier extends StateNotifier<Map<String, Movie>> {
  final GetMovieCallback getMovie;

  MovieMapNotifier({required this.getMovie}) : super({});

  Future<void> loadMovie(String movieId) async {
    // validando si en nuetro state ya existe un elemento con ese id y si existe no se retorna nada
    if (state[movieId] != null) return;

    final movie = await getMovie(movieId);

    state = {...state, movieId: movie};
  }
}

//* Esta es la forma que tiene el state del  Map que se crea con MovieMapNotifier

/*
{
  '505642': Movie()
  '505643': Movie()
  '505644': Movie()
  '505645': Movie()
  '505645': Movie()
}
*/
