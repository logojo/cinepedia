import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia/domain/entities/video.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

//*obteniendo los videos del repositorio
final FutureProviderFamily<List<Video>, int> videoFromMovieProvider =
    FutureProvider.family((ref, int movieId) {
  final moviesRepository = ref.watch(movieRepositoryProvider);
  return moviesRepository.getYoutubeVideosById(movieId);
});

class VideosFromMovie extends ConsumerWidget {
  final int movieId;
  const VideosFromMovie({super.key, required this.movieId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moviesFormVideo = ref.watch(videoFromMovieProvider(movieId));

    return moviesFormVideo.when(
        data: (videos) => _VideosList(videos: videos),
        error: (_, __) =>
            const Center(child: Text('No se pudo cargar el video')),
        loading: () =>
            const Center(child: CircularProgressIndicator(strokeWidth: 2)));
  }
}

class _VideosList extends StatelessWidget {
  final List<Video> videos;

  const _VideosList({required this.videos});

  @override
  Widget build(BuildContext context) {
    if (videos.isEmpty) {
      return const SizedBox();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            'Videos',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),

        //* solo se muetra el primer video

        _YouTubeVideoPlayer(
          youtubeId: videos.first.youtubeKey,
          name: videos.first.name,
        )
      ],
    );
  }
}

class _YouTubeVideoPlayer extends StatefulWidget {
  final String youtubeId;
  final String name;

  const _YouTubeVideoPlayer({required this.youtubeId, required this.name});

  @override
  State<_YouTubeVideoPlayer> createState() => _YouTubeVideoPlayerState();
}

class _YouTubeVideoPlayerState extends State<_YouTubeVideoPlayer> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = YoutubePlayerController(
        initialVideoId: widget.youtubeId,
        flags: const YoutubePlayerFlags(
            hideThumbnail: true,
            showLiveFullscreenButton: false,
            mute: false,
            autoPlay: false,
            disableDragSeek: true,
            loop: false,
            isLive: false,
            forceHD: false,
            enableCaption: false));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Text(widget.name), YoutubePlayer(controller: _controller)],
      ),
    );
  }
}
