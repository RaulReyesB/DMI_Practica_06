import 'package:movies/presentation/providers/movies/movies_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final initialLoadingProvider = Provider<bool>((ref) {
  final step1 = ref.watch(nowPlayingMoviesProvider).isEmpty;
  final step2 = ref.watch(getUpcomingMoviesProvider).isEmpty;
  final step3 = ref.watch(popularMoviesProvider).isEmpty;
  final step4 = ref.watch(getTopRatedMoviesProvider).isEmpty;
  final step5 = ref.watch(getMexicanMoviesProvider).isEmpty;

  if (step1 || step2 || step3 || step4 || step5) return true;
  return false;
});
