import 'package:cinemapedia/infraestructure/models/moviedb/moviedb_response.dart';
import 'package:dio/dio.dart';

import 'package:cinemapedia/config/constants/environments.dart';
import 'package:cinemapedia/infraestructure/mappers/movie_mapper.dart';
import 'package:cinemapedia/domain/datasources/movies_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';

//Se instalo paquete de dio de la pub dev para realizar peticiones http
//se esta implementando el MoviesDatasource

class MoviedbDatasource extends MoviesDatasource {
  final dio = Dio(BaseOptions(baseUrl: Environments.apiUrl, queryParameters: {
    'api_key': Environments.movieDbKey,
    'language': 'es-MX'
  }));

//implementando el metodo que se definio en el datasource
  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    final res = await dio.get('/movie/now_playing');

    //obteniendo la respuesta del endpoint en formato json
    final movieDBresponse = MoviesDbResponse.fromJson(res.data);

    //conviertiendo los datos a el formato de nuestra entity y asignandolo a una variable
    final List<Movie> movies = movieDBresponse.results
        .where((moviedb) =>
            moviedb.posterPath !=
            'no-poster') // filtra los registros que cumplan la condición
        .map((moviedb) => MovieMapper.movieDBToEntity(moviedb))
        .toList();

    return movies;
  }
}
