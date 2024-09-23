import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';

import 'package:cinemapedia/config/helpers/number_formats.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';

class MovieScreen extends ConsumerStatefulWidget {
  static const name = 'movie';

  final String movieId;

  const MovieScreen({super.key, required this.movieId});

  @override
  MovieState createState() => MovieState();
}

class MovieState extends ConsumerState<MovieScreen> {
  @override
  void initState() {
    super.initState();

    ref.read(movieDetailsProvider.notifier).loadMovie(widget.movieId);
    ref.read(actorsByMovieProvider.notifier).loadActors(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    final Movie? movie = ref.watch(movieDetailsProvider)[widget.movieId];

    if (movie == null) {
      return const Scaffold(
          body: Center(child: CircularProgressIndicator(strokeWidth: 2)));
    }

    return Scaffold(
        body: CustomScrollView(
      physics: const ClampingScrollPhysics(),
      slivers: [
        _CustomSliverAppBar(movie: movie),
        SliverList(
            delegate: SliverChildBuilderDelegate(
                (context, index) => _MovieDetails(movie: movie),
                childCount: 1))
      ],
    ));
  }
}

class _MovieDetails extends StatelessWidget {
  final Movie movie;
  const _MovieDetails({required this.movie});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textStyle = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TitleAndOverview(movie: movie, size: size, textStyle: textStyle),

        //*Generos de la pelicula
        _Genres(movie: movie),

        ActorByMovie(movieId: movie.id.toString()),

        VideosFromMovie(movieId: movie.id),

        const SizedBox(height: 20),

        SimilarMovies(movieId: movie.id),
      ],
    );
  }
}

class _Genres extends StatelessWidget {
  const _Genres({
    required this.movie,
  });

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: SizedBox(
        width: double.infinity,
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          alignment: WrapAlignment.center,
          children: [
            ...movie.genreIds.map((gender) => Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: Chip(
                    label: Text(gender),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}

class _TitleAndOverview extends StatelessWidget {
  const _TitleAndOverview({
    required this.movie,
    required this.size,
    required this.textStyle,
  });

  final Movie movie;
  final Size size;
  final TextTheme textStyle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //*Imagen
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              movie.posterPath,
              width: size.width *
                  0.3, // obteniendo el 30% de la pantalla para elñ tamaño de la imagen
            ),
          ),

          const SizedBox(
            width: 10,
          ),

          //*Descripcion de la pelicula
          SizedBox(
            width: (size.width - 40) * 0.7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  style: textStyle.titleLarge,
                ),
                Text(movie.overview),
                const SizedBox(height: 10),
                MovieRating(voteAverage: movie.voteAverage),
                Row(
                  children: [
                    const Text(
                      'Estreno',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 5),
                    Text(NumberFormats.shortDate(movie.releaseDate!))
                  ],
                )
              ],
            ),
          ) //obteniendo el resto del tamaño de la pantalla
        ],
      ),
    );
  }
}

//*FutureProvider se usa cuando se tiene algun tipo de tarea asincrona
//*con este provider verifico si la pelicula esta marcada como favorito
final isFavoriteProvider =
    FutureProvider.family.autoDispose((ref, int movieId) {
  final localStorageRepository = ref.watch(localStorageRepositoryProvider);
  return localStorageRepository.isMovieFavorite(movieId);
});

class _CustomSliverAppBar extends ConsumerWidget {
  final Movie movie;
  const _CustomSliverAppBar({required this.movie});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final isFavorite = ref.watch(isFavoriteProvider(movie.id));
    final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return SliverAppBar(
      backgroundColor: Colors.black,
      expandedHeight: size.height * 0.7, //obteniendo el 70% de la pantalla
      foregroundColor: Colors.white,
      actions: [
        IconButton(
          onPressed: () async {
            //*al acerlo con este provider solo tengo acceso a la bd y agrego o quitolas peliculas a favoritos de la bd
            //* pero no de el list que las muestra en pantalla
            // ref.read(localStorageRepositoryProvider).toggleFaviorite(movie);

            //* con este provider accedo a la bd y ademas actualizo el estado de la lista que almacena las peliculas
            //* y las muestra en panatalla

            //* como es una función asincrona hay que esperar a que se complete para despues invalidar el estado de isFavoriteProvider
            await ref
                .read(favoriteMoviesProvider.notifier)
                .toggleFavorite(movie);

            //*lo invalidamos para que vuelva a hacer la petición
            //*esta funcion canbia el icono de corazon de rojo a blanco
            ref.invalidate(isFavoriteProvider(movie.id));
          },

          //* isFavorite puede usar el metodo when por que es una variable que recibe un valor asincrono del provider
          icon: isFavorite.when(
              loading: () => const CircularProgressIndicator(strokeWidth: 2),
              data: (isFavorite) => isFavorite
                  ? Icon(
                      Icons.favorite_rounded,
                      color: Colors.red.shade800,
                    )
                  : const Icon(Icons.favorite_border),
              error: (_, __) => throw UnimplementedError()),
        )
      ],
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(bottom: 0),
        title: _CustomGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.7, 1.0],
          colors: [Colors.transparent, scaffoldBackgroundColor],
        ),

        //Stack permite poner widgets encima de otros
        background: Stack(
          children: [
            SizedBox.expand(
              child: Image.network(
                movie.posterPath,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress != null) return const SizedBox();

                  return FadeIn(child: child);
                },
              ),
            ),

            //* Favorite Gradient Background
            const _CustomGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                stops: [
                  0.0,
                  0.2
                ],
                colors: [
                  Colors.black54,
                  Colors.transparent,
                ]),

            //* Back arrow background
            const _CustomGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [
                  0.0,
                  0.3
                ],
                colors: [
                  Colors.black87,
                  Colors.transparent,
                ]),
          ],
        ),
      ),
    );
  }
}

class _CustomGradient extends StatelessWidget {
  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  final List<double> stops;
  final List<Color> colors;

  const _CustomGradient(
      {this.begin = Alignment.centerLeft,
      this.end = Alignment.centerRight,
      required this.stops,
      required this.colors});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: DecoratedBox(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: begin, end: end, stops: stops, colors: colors))),
    );
  }
}
