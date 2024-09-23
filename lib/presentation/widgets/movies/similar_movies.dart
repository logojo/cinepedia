import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:cinemapedia/presentation/widgets/movies/movies_horizontal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final similarMoviesProvider = FutureProvider.family((ref, int movieId) {
  final movieRepository = ref.watch(movieRepositoryProvider);
  return movieRepository.getSimilarMovies(movieId);
});

class SimilarMovies extends ConsumerWidget {
  final int movieId;

  const SimilarMovies({super.key, required this.movieId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final similarMovies = ref.watch(similarMoviesProvider(movieId));

    return similarMovies.when(
        data: (movies) => _Recomendacions(movies: movies),
        error: (_, __) =>
            const Center(child: Text('No se pudo cargar peliculas similares')),
        loading: () =>
            const Center(child: CircularProgressIndicator(strokeWidth: 2)));
  }
}

class _Recomendacions extends StatelessWidget {
  final List<Movie> movies;

  const _Recomendacions({required this.movies});

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) return const SizedBox();

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: MoviesHorizontal(movies: movies),
    );
  }
}
