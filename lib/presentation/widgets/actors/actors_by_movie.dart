import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia/presentation/providers/providers.dart';

class ActorByMovie extends ConsumerWidget {
  final String movieId;

  const ActorByMovie({super.key, required this.movieId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actorsByMovie = ref.watch(actorsByMovieProvider);

    //* loading actors
    if (actorsByMovie[movieId] == null) {
      return Container(
          height: 100,
          margin: const EdgeInsets.only(bottom: 50),
          child:
              const Center(child: CircularProgressIndicator(strokeWidth: 2)));
    }

    final actors = actorsByMovie[movieId]!;

    return SizedBox(
        height: 300,
        child: ListView.builder(
          itemCount: actors.length,
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            final actor = actors[index];

            return Container(
              width: 135,
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //*Foto Actor
                  FadeInRight(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: FadeInImage(
                        height: 180,
                        width: 135,
                        fit: BoxFit.cover,
                        placeholder: const AssetImage(
                            'assets/loaders/bottle-loader.gif'),
                        image: NetworkImage(
                          actor.profilePath,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 5),

                  //* Nombre
                  Text(actor.name, maxLines: 2),
                  Text(
                    actor.character ?? '',
                    maxLines: 2,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis),
                  )
                ],
              ),
            );
          },
        ));
  }
}
