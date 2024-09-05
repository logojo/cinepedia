import 'package:cinemapedia/domain/entities/movie.dart';

//Los repositorios seon los encargados de llamar al datasource

//Los repositorios me dan la posivilidad de poder cambiar el datasource(origen de datos)
abstract class MoviesRepository {
  Future<List<Movie>> getNowPlaying({int page = 1});

  Future<List<Movie>> getPupolar({int page = 1});

  Future<List<Movie>> getTopRated({int page = 1});

  Future<List<Movie>> getUpComming({int page = 1});

  Future<Movie> getMovieByid(String id);

  Future<List<Movie>> searchMovie(String query);
}
