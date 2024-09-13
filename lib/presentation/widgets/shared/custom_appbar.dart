import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia/presentation/delegates/search_movies_delegate.dart';
import 'package:go_router/go_router.dart';

class CustomAppBar extends ConsumerWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final titleStyle = Theme.of(context).textTheme.titleMedium;
    return SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SizedBox(
            width: double.infinity,
            child: Row(
              children: [
                Icon(Icons.movie_creation_outlined, color: colors.primary),
                const SizedBox(width: 5),
                Text(
                  'Cinemapedia',
                  style: titleStyle,
                ),
                const Spacer(),
                IconButton(
                    onPressed: () {
                      //* referencia al provider que se usara para la busqueda
                      //final movieRepository = ref.read(movieRepositoryProvider);

                      final searchedMovies = ref.read(searchedMoviesProvider);

                      //*obteniendo el valor del query de busqueda del provider
                      final searchQuery = ref.read(searchQueryProvider);

                      //*funcion de busqueda propia de flutter
                      //* y recibiendo la pelicula que se busco
                      showSearch<Movie?>(
                              query: searchQuery,
                              context: context,
                              delegate: SearchMovieDelegate(
                                  initialMovies: searchedMovies,
                                  searchMovies: ref
                                      .read(searchedMoviesProvider.notifier)
                                      .searchMoviesByQuery))
                          //*Se esta mandando llamar la referencia del provider searchedMoviesProvider que se encargara de cargar
                          //* de cargar las pelicular de una buqueda previa o realizar una nueva busqueda
                          // */
                          .then((movie) {
                        //*en caso de recibir una pelicula redireccionarlo a la pagina details
                        if (movie == null) return;
                        context.push('/home/0/movie/${movie.id}');
                      });
                    },
                    icon: const Icon(Icons.search)),
              ],
            ),
          ),
        ));
  }
}
