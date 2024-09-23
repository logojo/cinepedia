import 'package:cinemapedia/presentation/providers/movies/movies_providers.dart';
import 'package:cinemapedia/presentation/widgets/movies/movie_masonry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PopularesView extends ConsumerStatefulWidget {
  const PopularesView({super.key});

  @override
  PopularesViewState createState() => PopularesViewState();
}
//* AutomaticKeepAliveClientMixin es un  Mixin es necesario para mantener el estado en el PageView

class PopularesViewState extends ConsumerState<PopularesView>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    final populares = ref.watch(popularesProvider);

    if (populares.isEmpty) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }

    return Scaffold(
      body: MovieMasonry(
          loadNextPage: () =>
              ref.read(popularesProvider.notifier).loadNextPAge(),
          movies: populares),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
