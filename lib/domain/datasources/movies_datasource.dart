//definiendo la forma de nuestros origenes de datos

// es una clase abstracta por que no se crearan instacias de esta
// solo se definira como debe de lucir los origenes de datos
// y los metodos que se van a llamar para traer la data independientemente de la fuente

import 'package:cinemapedia/domain/entities/movie.dart';

abstract class MoviesDatasource {
  Future<List<Movie>> getNowPlaying({int page = 1});

  Future<List<Movie>> getPopular({int page = 1});

  Future<List<Movie>> getTopRated({int page = 1});

  Future<List<Movie>> getUpComming({int page = 1});

  Future<Movie> getMovieByid(String id);
}
