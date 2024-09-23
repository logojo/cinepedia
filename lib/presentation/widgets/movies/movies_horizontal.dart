import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/helpers/number_formats.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MoviesHorizontal extends StatefulWidget {
  final List<Movie> movies;
  final String? title;
  final String? subtitle;
  final VoidCallback? loadNextPage;

  const MoviesHorizontal(
      {super.key,
      required this.movies,
      this.title,
      this.subtitle,
      this.loadNextPage});

  @override
  State<MoviesHorizontal> createState() => _MoviesHorizontalState();
}

class _MoviesHorizontalState extends State<MoviesHorizontal> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if (widget.loadNextPage == null) return;

      //Si tengo un callback
      //scrollController.position.pixels -> posocion altual del listView
      //scrollController.position.maxScrollExtent maxima posición del listView
      if (scrollController.position.pixels + 200 >=
          scrollController.position.maxScrollExtent) {
        widget.loadNextPage!();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 350,
        child: Column(children: [
          if (widget.title != null || widget.subtitle != null)
            _Title(widget.title, widget.subtitle),
          Expanded(
              child: ListView.builder(
            controller: scrollController,
            itemCount: widget.movies.length,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return FadeInRight(child: _Slide(movie: widget.movies[index]));
            },
          ))
        ]));
  }
}

class _Slide extends StatelessWidget {
  final Movie movie;
  const _Slide({required this.movie});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: GestureDetector(
                onTap: () => context.push('/home/0/movie/${movie.id}'),
                child: FadeInImage(
                    height: 220,
                    fit: BoxFit.cover,
                    placeholder:
                        const AssetImage('assets/loaders/bottle-loader.gif'),
                    image: NetworkImage(movie.posterPath)),
              ),
            ),
          ),

          //*Imagen codigo anterior
          // SizedBox(
          //   width: 150,
          //   child: ClipRRect(
          //     borderRadius: BorderRadius.circular(20),
          //     child: Image.network(
          //       movie.posterPath,
          //       fit: BoxFit.cover,
          //       width: 150,
          //       loadingBuilder: (context, child, loadingProgress) {
          //         if (loadingProgress != null) {
          //           return const Center(
          //               child: CircularProgressIndicator(strokeWidth: 2));
          //         }

          //         //* con este codigo se realizara la navegacion a otra pantalla
          //         return GestureDetector(
          //           child: FadeIn(child: child),
          //           onTap: () => context.push('/home/0/movie/${movie.id}'),
          //         );
          //       },
          //     ),
          //   ),
          // ),

          const SizedBox(
            height: 5,
          ),

          //*Title
          SizedBox(
            width: 150,
            child: Text(
              movie.title,
              maxLines: 2,
              style: textStyle.bodySmall,
            ),
          ),

          //*Rating
          SizedBox(
            width: 145,
            child: Row(
              children: [
                Icon(Icons.star_half_outlined, color: Colors.yellow.shade800),
                const SizedBox(width: 3),
                Text(
                  '${movie.voteAverage}',
                  style: textStyle.bodyMedium
                      ?.copyWith(color: Colors.yellow.shade800),
                ),
                const SizedBox(width: 3),
                const Spacer(),
                Text(
                    //paquete intl de la pub dev para formatear numeros
                    //y se creo una clase para utilizarlo
                    NumberFormats.number(movie.popularity),
                    style: textStyle.bodySmall)
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  final String? title;
  final String? subtitle;

  const _Title(this.title, this.subtitle);

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleLarge;
    return Container(
      padding: const EdgeInsets.only(top: 10),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$title',
            style: titleStyle,
          ),
          FilledButton(
              style: const ButtonStyle(visualDensity: VisualDensity.compact),
              onPressed: () {},
              child: Text('$subtitle'))
        ],
      ),
    );
  }
}
