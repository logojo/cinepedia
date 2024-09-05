//implementacion del repositorio
//lo que hace es llamar el datasource y a su vez el datasource llamara los metodos coirrespondientes

import 'package:cinemapedia/domain/datasources/movies_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/repositories/movies_repository.dart';

class MovieRepositoryImpl extends MoviesRepository {
  final MoviesDatasource datasource;
  MovieRepositoryImpl(this.datasource);

  //sobreescribiendo el metodo origital para obtener las peliculas
  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) {
    return datasource.getNowPlaying(page: page);
  }

  @override
  Future<List<Movie>> getPupolar({int page = 1}) {
    return datasource.getPopular(page: page);
  }

  @override
  Future<List<Movie>> getTopRated({int page = 1}) {
    return datasource.getTopRated(page: page);
  }

  @override
  Future<List<Movie>> getUpComming({int page = 1}) {
    return datasource.getUpComming(page: page);
  }

  @override
  Future<Movie> getMovieByid(String id) {
    return datasource.getMovieByid(id);
  }

  @override
  Future<List<Movie>> searchMovie(String query) {
    return datasource.searchMovie(query);
  }
}
