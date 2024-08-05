import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';

class Home extends StatelessWidget {
  static const name = 'home';
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _HomeView(),
      bottomNavigationBar: CustomButtomNavigation(),
    );
  }
}

class _HomeView extends ConsumerStatefulWidget {
  const _HomeView();

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<_HomeView> {
  @override
  void initState() {
    super.initState();
    //este read del provider va a mandar llamar la siguiente pagina
    ref.read(nowPlayingMoviesProvider.notifier).loadNextPAge();
    ref.read(popularesProvider.notifier).loadNextPAge();
    ref.read(topRatedProvider.notifier).loadNextPAge();
    ref.read(upcomingProvider.notifier).loadNextPAge();
  }

  @override
  Widget build(BuildContext context) {
    //cuando ya tenemos data las extraemos con el watch
    final slideMovies = ref.watch(moviesSlideshowProvider);
    final movies = ref.watch(nowPlayingMoviesProvider);
    final popular = ref.watch(popularesProvider);
    final topRated = ref.watch(topRatedProvider);
    final upcoming = ref.watch(upcomingProvider);

    if (slideMovies.isEmpty) {
      return const Loader();
    }

//* SingleChildScrollView me permite  hacer scroll vertical de la aplicación
    //* return SingleChildScrollView(
    return CustomScrollView(
        //Slivers trabaja direntamente con el scrollvire
        slivers: [
          //Esto me permite que la appbar aparesca al bajar el scroll
          const SliverAppBar(
            floating: true,
            flexibleSpace: FlexibleSpaceBar(
              title: CustomAppBar(),
            ),
          ),
          SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
            return Column(children: [
              //
              MoviesSlideShow(movies: slideMovies),
              MoviesHorizontal(
                movies: movies,
                title: 'En cines',
                subtitle: 'Lunes 20',
                loadNextPage: () {
                  //cargando las siguientes peliculas usando la funcioón desde el provider
                  ref.read(nowPlayingMoviesProvider.notifier).loadNextPAge();
                },
              ),
              MoviesHorizontal(
                movies: upcoming,
                title: 'Proximamente',
                subtitle: 'En este mes',
                loadNextPage: () {
                  //cargando las siguientes peliculas usando la funcioón desde el provider
                  ref.read(upcomingProvider.notifier).loadNextPAge();
                },
              ),
              MoviesHorizontal(
                movies: popular,
                title: 'Populares',
                subtitle: 'Top 10',
                loadNextPage: () {
                  //cargando las siguientes peliculas usando la funcioón desde el provider
                  ref.read(popularesProvider.notifier).loadNextPAge();
                },
              ),
              MoviesHorizontal(
                movies: topRated,
                title: 'Mejores calificadas',
                subtitle: 'Por la critica',
                loadNextPage: () {
                  //cargando las siguientes peliculas usando la funcioón desde el provider
                  ref.read(topRatedProvider.notifier).loadNextPAge();
                },
              ),
              const SizedBox(
                height: 20,
              )
            ]);
          }, childCount: 1))
        ]);
  }
}
