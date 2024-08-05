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
  }

  @override
  Widget build(BuildContext context) {
    //cuando ya tenemos data las extraemos con el watch
    final slideMovies = ref.watch(moviesSlideshowProvider);
    final movies = ref.watch(nowPlayingMoviesProvider);

    if (slideMovies.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Column(children: [
      const CustomAppBar(),
      MoviesSlideShow(movies: slideMovies),
      MoviesHorizontal(
        movies: movies,
        title: 'En cines',
        subtitle: 'Lunes 20',
      )
    ]);
  }
}
