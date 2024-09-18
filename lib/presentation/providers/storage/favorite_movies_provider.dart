import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/repositories/local_storage_repository.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final favoriteMoviesProvider =
    StateNotifierProvider<StorageMoviesNotifier, Map<int, Movie>>((ref) {
  final localStorageRepository = ref.watch(localStorageRepositoryProvider);
  return StorageMoviesNotifier(localStorageRepository: localStorageRepository);
});

/* Mapa
{
 123: Movie,
 321: movie
}
 */
class StorageMoviesNotifier extends StateNotifier<Map<int, Movie>> {
  int page = 0;
  final LocalStorageRepository localStorageRepository;

  StorageMoviesNotifier({required this.localStorageRepository}) : super({});

  Future<List<Movie>> loadNextPage() async {
    final movies = await localStorageRepository.loadMovies(
        offset: page * 10, limit: 20); //todo limit 20
    page++;

    //* el state es el mapa de las peliculas

    //* declarando mapa de tipo int y Movie
    final tempMoviesMap = <int, Movie>{};

    for (final movie in movies) {
      tempMoviesMap[movie.id] = movie;
    }

    //notificando el nuevo estado de las peliculas
    state = {...state, ...tempMoviesMap};
    return movies;
  }

//* al crear esta función contiene un error ya que esta funcion solo buscara dentro del state como se encuentra
//* es decir que aun no busca dentro de todas la peliculas marcadas como favoritas
  Future<void> toggleFavorite(Movie movie) async {
    await localStorageRepository.toggleFaviorite(movie);

//*Buscando la pelicula en el state por el id de la pelicula
    final bool isMovieInFavorites = state[movie.id] != null;

    if (isMovieInFavorites) {
      state.remove(movie.id);
      state = {...state};
    } else {
      state = {...state, movie.id: movie};
    }
  }
}
