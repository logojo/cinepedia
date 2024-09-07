import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/helpers/number_formats.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';

//definiendo las caracteristicas de la funcion de busqueda
typedef SearchMoviesCallback = Future<List<Movie>> Function(String query);

class SearchMovieDelegate extends SearchDelegate<Movie?> {
  final SearchMoviesCallback searchMovies;
  List<Movie> initialMovies;

  //*StreamController permite crear y gestionar flujos de datos asíncronos, conocidos como Streams
  //* broadcast: Permite que múltiples oyentes escuchen el mismo flujo de datos es decir diferentes widgets
  StreamController<List<Movie>> debouncedMovies = StreamController.broadcast();
  StreamController<bool> isLoading = StreamController.broadcast();

  Timer? _debounceTimer;

  SearchMovieDelegate(
      {required this.searchMovies, required this.initialMovies});

  //*limpiando los streams de memoria
  void clearStreams() {
    debouncedMovies.close();
    isLoading.close();
  }

  //*metodo que usara el StreamController
  void _onQueryChanged(String query) async {
    isLoading.add(true);
    //verificando si el debounce tiene un valor
    //Si tiene un valor lo cancela
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    //*esperando 500 milisegundos antes de lanzar la peticion
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      final movies = await searchMovies(query);

      initialMovies = movies;
      debouncedMovies.add(movies);
      isLoading.add(false);
    });
  }

  @override
  String get searchFieldLabel => 'Buscar película';

  @override
  List<Widget>? buildActions(BuildContext context) {
    //*La variable query ya viene definida con el SearchDelegate y representa lo que telceamos en el input
    return [
      StreamBuilder(
          initialData: false,
          stream: isLoading.stream,
          builder: (context, snapshot) {
            if (snapshot.data ?? false) {
              return SpinPerfect(
                  duration: const Duration(seconds: 20),
                  spins: 10,
                  infinite: true,
                  child: IconButton(
                      onPressed: () => query = '',
                      icon: const Icon(Icons.refresh_rounded)));
            }

            return FadeIn(
                animate:
                    query.isNotEmpty, //esta parte de codigo sustituye al if
                duration: const Duration(milliseconds: 200),
                child: IconButton(
                    onPressed: () => query = '',
                    icon: const Icon(Icons.clear)));
          }),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    //*La funcion close ya viene definida con el SearchDelegate
    return IconButton(
        onPressed: () {
          clearStreams();
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back_ios_new_rounded));
  }

  @override
  Widget buildResults(BuildContext context) {
    return searchMoviesBuilder();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _onQueryChanged(query);

    //Construyendo widget basado en un Future se puede usar un FutureBuilder o un StreamBuilder segun sea el caso
    return searchMoviesBuilder();
  }

  StreamBuilder<List<Movie>> searchMoviesBuilder() {
    return StreamBuilder(
      initialData: initialMovies,
      stream: debouncedMovies.stream, //searchMovies(query),
      builder: (context, snapshot) {
        final movies = snapshot.data ?? [];

        return ListView.builder(
            itemCount: movies.length,
            itemBuilder: (context, index) => _MovieItem(
                movie: movies[index],
                onMovieSelected: (context, movie) {
                  clearStreams();
                  close(context, movie);
                }));
      },
    );
  }
}

class _MovieItem extends StatelessWidget {
  final Movie movie;
  //* declarando una variable como tipo funcion para poder recibirla como parametro y realizar acciones del widget padre
  final Function onMovieSelected;

  const _MovieItem({required this.movie, required this.onMovieSelected});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    //* GestureDetector te permite dar click y realizar acciones sobre widgets
    return GestureDetector(
      onTap: () {
        onMovieSelected(context, movie);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        //*Siempre que se esta dentro de un row o un column hay que definir un tamaño
        child: Row(
          children: [
            SizedBox(
              width: size.width * 0.2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(movie.posterPath,
                    loadingBuilder: (context, child, loadingProgress) =>
                        FadeIn(child: child)),
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: size.width * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(movie.title, style: textStyle.titleMedium),
                  (movie.overview.length > 100)
                      ? Text('${movie.overview.substring(0, 100)}...')
                      : Text(movie.overview),
                  Row(
                    children: [
                      Icon(
                        Icons.star_half_rounded,
                        color: Colors.yellow.shade800,
                      ),
                      const SizedBox(width: 5),
                      Text(NumberFormats.number(movie.voteAverage, 2),
                          style: textStyle.bodyMedium!
                              .copyWith(color: Colors.yellow.shade900))
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
