import 'package:cinemapedia/config/constants/environments.dart';
import 'package:cinemapedia/domain/datasources/actors_datasource.dart';
import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/infraestructure/mappers/actor_mapper.dart';
import 'package:cinemapedia/infraestructure/models/moviedb/credits_response.dart';
import 'package:dio/dio.dart';

class ActorMoviedbDatasource extends ActorsDatasource {
  final dio = Dio(BaseOptions(baseUrl: Environments.apiUrl, queryParameters: {
    'api_key': Environments.movieDbKey,
    'language': 'es-MX'
  }));

  List<Actor> _jsonToActors(Map<String, dynamic> json) {
    final creditsReponse = CreditsResponse.fromJson(json);

    final List<Actor> actors = creditsReponse.cast
        .map((actor) => ActorMapper.castToEntity(actor))
        .toList();

    return actors;
  }

  @override
  Future<List<Actor>> getActorsByMovie(String movieId) async {
    final res = await dio.get('/movie/$movieId/credits');
    return _jsonToActors(res.data);
  }
}
