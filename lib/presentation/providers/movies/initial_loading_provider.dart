//Provider que cambia su estado basado en otros providers

import 'package:cinemapedia/presentation/providers/movies/movies_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final initialLoadigProvider = Provider<bool>((ref) {
  final step1 = ref.watch(nowPlayingMoviesProvider).isEmpty;
  //final step2 = ref.watch(popularesProvider).isEmpty;
  final step2 = ref.watch(topRatedProvider).isEmpty;
  final step3 = ref.watch(upcomingProvider).isEmpty;

  if (step1 || step2 || step3) return true;

  return false;
});
