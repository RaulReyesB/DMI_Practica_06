import 'package:movies/presentation/providers/providers.dart';
import 'package:movies/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  static const name = 'home-screen';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _HomeView(),
      bottomNavigationBar: CustomBottomNavigationbar(),
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

    // Cargar las siguientes páginas solo una vez
    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
    ref.read(popularMoviesProvider.notifier).loadNextPage();
    ref.read(getTopRatedMoviesProvider.notifier).loadNextPage();
    ref.read(getMexicanMoviesProvider.notifier).loadNextPage();
    ref.read(getUpcomingMoviesProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    final initialLoading = ref.watch(initialLoadingProvider);
    if (initialLoading) return const FullscreenLoader();

    // Se obtienen las películas desde los proveedores
    final nowPlaying = ref.watch(nowPlayingMoviesProvider);
    final slideShowMovies = ref.watch(moviesSlideshowProvider);
    final popular = ref.watch(popularMoviesProvider);
    final mejorClificados = ref.watch(getTopRatedMoviesProvider);
    final mexican = ref.watch(getMexicanMoviesProvider);
    final upcoming = ref.watch(getUpcomingMoviesProvider);

    final now = DateTime.now();

    // Formatos de fecha
    final formatoCompleto = DateFormat('EEEE d \'de\' MMMM y', 'es_MX');
    final formatoMes = DateFormat('MMMM', 'es_MX');
    final formatoMesAnio = DateFormat('MMMM y', 'es_MX');

    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          floating: true,
          flexibleSpace: FlexibleSpaceBar(title: CustomAppbar()),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return SingleChildScrollView(
                // Usamos SingleChildScrollView para evitar el overflow
                child: Column(
                  children: [
                    MoviesSlideshow(movies: slideShowMovies),
                    MovieHorizontalListview(
                      movies: nowPlaying,
                      title: 'En cines',
                      subTitle: formatoCompleto.format(now),
                      loadNextPage:
                          () =>
                              ref
                                  .read(nowPlayingMoviesProvider.notifier)
                                  .loadNextPage(),
                    ),
                    MovieHorizontalListview(
                      movies: upcoming,
                      title: 'Próximamente',
                      subTitle: formatoMesAnio.format(now).toUpperCase(),
                      loadNextPage:
                          () =>
                              ref
                                  .read(getUpcomingMoviesProvider.notifier)
                                  .loadNextPage(),
                    ),
                    MovieHorizontalListview(
                      movies: popular,
                      title: 'Populares',
                      subTitle: formatoMes.format(now).toUpperCase(),
                      loadNextPage:
                          () =>
                              ref
                                  .read(popularMoviesProvider.notifier)
                                  .loadNextPage(),
                    ),
                    MovieHorizontalListview(
                      movies: mejorClificados,
                      title: 'Mejor calificados',
                      subTitle: 'Películas con mejor calificación',
                      loadNextPage:
                          () =>
                              ref
                                  .read(getTopRatedMoviesProvider.notifier)
                                  .loadNextPage(),
                    ),
                    MovieHorizontalListview(
                      movies: mexican,
                      title: 'Mexicanas',
                      subTitle: 'Mejores películas mexicanas',
                      loadNextPage:
                          () =>
                              ref
                                  .read(getMexicanMoviesProvider.notifier)
                                  .loadNextPage(),
                    ),
                  ],
                ),
              );
            },
            childCount: 1, // Número de elementos en el SliverList
          ),
        ),
      ],
    );
  }
}
