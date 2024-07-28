import 'package:cinemapedia/infraestructure/datasources/moviedb_datasource.dart';
import 'package:cinemapedia/infraestructure/repositories/movie_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//Provider de solo lectura, la data que contiene no cambiara
final movieRepositoryProvider = Provider((ref) {
  //retornando la implementacion del repositorio mandando como parametro el datasource(la fuente de datos o la api)
  return MovieRepositoryImpl(MoviedbDatasource());
});
