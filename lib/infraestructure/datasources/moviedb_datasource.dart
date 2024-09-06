import 'package:cinemapedia/infraestructure/models/moviedb/details.dart';
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

  List<Movie> _jsonToMovies(Map<String, dynamic> json) {
    //obteniendo la respuesta del endpoint en formato json
    final popularResponse = MoviesDbResponse.fromJson(json);

    //conviertiendo los datos a el formato de nuestra entity y asignandolo a una variable
    final List<Movie> movies = popularResponse.results
        .where((moviedb) => moviedb.posterPath != 'no-poster')
        .map((moviedb) => MovieMapper.movieDBToEntity(moviedb))
        .toList();

    return movies;
  }

//implementando el metodo que se definio en el datasource
  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    final res =
        await dio.get('/movie/now_playing', queryParameters: {'page': page});

    return _jsonToMovies(res.data);
  }

  @override
  Future<List<Movie>> getPopular({int page = 1}) async {
    final res =
        await dio.get('/movie/popular', queryParameters: {'page': page});

    return _jsonToMovies(res.data);
  }

  @override
  Future<List<Movie>> getTopRated({int page = 1}) async {
    final res =
        await dio.get('/movie/top_rated', queryParameters: {'page': page});

    return _jsonToMovies(res.data);
  }

  @override
  Future<List<Movie>> getUpComming({int page = 1}) async {
    final res =
        await dio.get('/movie/upcoming', queryParameters: {'page': page});

    return _jsonToMovies(res.data);
  }

  @override
  Future<Movie> getMovieByid(String id) async {
    final res = await dio.get('/movie/$id');

    if (res.statusCode != 200) throw Exception('Movie with id $id not found');

    final movieDetails = Details.fromJson(res.data);

    final Movie movie = MovieMapper.movieDetailsToEntity(movieDetails);

    return movie;
  }

  @override
  Future<List<Movie>> searchMovie(String query) async {
    if (query.isEmpty) return [];

    final res =
        await dio.get('/search/movie', queryParameters: {'query': query});

    return _jsonToMovies(res.data);
  }
}
