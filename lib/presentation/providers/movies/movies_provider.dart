import 'package:movies/domain/entities/movie.dart';
import 'package:movies/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Tipo de función para obtener películas

typedef MovieCallback = Future<List<Movie>> Function({int page});

//  Provider para Now Playing

final nowPlayingMoviesProvider = NotifierProvider<MoviesNotifier, List<Movie>>(
  () =>
      MoviesNotifier((ref) => ref.watch(movieRepositoryProvider).getNowPlaying),
);

//  Provider para Popular Movies

final popularMoviesProvider = NotifierProvider<MoviesNotifier, List<Movie>>(
  () => MoviesNotifier((ref) => ref.watch(movieRepositoryProvider).getPopular),
);

final getTopRatedMoviesProvider = NotifierProvider<MoviesNotifier, List<Movie>>(
  () => MoviesNotifier((ref) => ref.watch(movieRepositoryProvider).getTopRated),
);

final getMexicanMoviesProvider = NotifierProvider<MoviesNotifier, List<Movie>>(
  () => MoviesNotifier((ref) => ref.watch(movieRepositoryProvider).getMexican),
);

final getUpcomingMoviesProvider = NotifierProvider<MoviesNotifier, List<Movie>>(
  () => MoviesNotifier((ref) => ref.watch(movieRepositoryProvider).getUpcoming),
);

//  Notifier genérico que maneja cualquier tipo de lista de películas

class MoviesNotifier extends Notifier<List<Movie>> {
  final MovieCallback Function(Ref ref) _callbackBuilder;

  late final MovieCallback fetchMoreMovies;

  MoviesNotifier(this._callbackBuilder);

  int currentPage = 0;

  bool isLoading = false;

  @override
  List<Movie> build() {
    fetchMoreMovies = _callbackBuilder(ref);

    return [];
  }

  Future<void> loadNextPage() async {
    if (isLoading) return;

    isLoading = true;

    currentPage++;

    final movies = await fetchMoreMovies(page: currentPage);

    state = [...state, ...movies];

    await Future.delayed(const Duration(milliseconds: 300));

    isLoading = false;
  }
}
