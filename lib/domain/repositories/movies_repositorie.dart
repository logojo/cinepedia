import 'package:cinemapedia/domain/entities/movie.dart';

//Los repositorios seon los encargados de llamar al datasource

//Los repositorios me dan la posivilidad de poder cambiar el datasource(origen de datos)
abstract class MoviesRepository {
  Future<List<Movie>> getNowPlaying({int page = 1});
}
