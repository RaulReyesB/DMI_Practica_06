import 'package:dio/dio.dart';
import 'package:movies/config/constants/environment.dart';
import 'package:movies/domain/datasources/movies_datasource.dart';
import 'package:movies/infrastructure/mappers/movie_mapper.dart';
import 'package:movies/infrastructure/models/moviedb/movie_details.dart';
import 'package:movies/infrastructure/models/moviedb/moviedb_response.dart';
import 'package:movies/domain/entities/movie.dart';

class MoviedbDatasource extends MoviesDatasource {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      headers: {
        'Authorization': 'Bearer ${Environment.theMovieDbKey}',
        'Content-Type': 'application/json;charset=utf-8',
      },
      queryParameters: {'language': 'es-MX'},
    ),
  );

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    // print(' Solicitando películas');

    try {
      final response = await dio.get(
        '/movies/now_playing',
        queryParameters: {'page': page},
      );
      // print(' Respuesta recibida de TMDB');
      // print(response.data); // opcional

      final movieDBResponse = MovieDbResponse.fromJson(response.data);

      final List<Movie> movies =
          movieDBResponse.results
              .where((moviedb) => moviedb.posterPath.isNotEmpty)
              .map((moviedb) => MovieMapper.movieDBToEntity(moviedb))
              .toList();

      //print('Películas obtenidas: ${movies.length}');
      return movies;
    } catch (e) {
      //print('Error al obtener películas: $e');
      return [];
    }
  }

  @override
  Future<List<Movie>> getPopular({int page = 1}) async {
    final response = await dio.get(
      '/movies/popular',
      queryParameters: {'page': page},
    );
    final movieDBResponse = MovieDbResponse.fromJson(response.data);

    final List<Movie> movies =
        movieDBResponse.results
            .where((moviedb) => moviedb.posterPath.isNotEmpty)
            .map((moviedb) => MovieMapper.movieDBToEntity(moviedb))
            .toList();
    return movies;
  }

  @override
  Future<List<Movie>> getTopRated({int page = 1}) async {
    final response = await dio.get(
      '/movies/top_rated',
      queryParameters: {'page': page},
    );
    final movieDBResponse = MovieDbResponse.fromJson(response.data);

    final List<Movie> movies =
        movieDBResponse.results
            .where((moviedb) => moviedb.posterPath.isNotEmpty)
            .map((moviedb) => MovieMapper.movieDBToEntity(moviedb))
            .toList();
    return movies;
  }

  @override
  Future<List<Movie>> getUpcoming({int page = 1}) async {
    final response = await dio.get(
      '/movies/upcoming',
      queryParameters: {'page': page},
    );
    final movieDBResponse = MovieDbResponse.fromJson(response.data);

    final List<Movie> movies =
        movieDBResponse.results
            .where((moviedb) => moviedb.posterPath.isNotEmpty)
            .map((moviedb) => MovieMapper.movieDBToEntity(moviedb))
            .toList();
    return movies;
  }

  @override
  Future<List<Movie>> getMexican({int page = 1}) async {
    final response = await dio.get(
      '/discover/movies',
      queryParameters: {
        'page': page,
        'withOriginalLanguage': 'es',
        'with_origin_country': 'MX',
        'region': 'MX',
        'sort_by': 'vote_average.desc',
        'vote_count.gte': 10,
      },
    );
    final movieDBResponse = MovieDbResponse.fromJson(response.data);

    final List<Movie> movies =
        movieDBResponse.results
            .where((moviedb) => moviedb.posterPath.isNotEmpty)
            .map((moviedb) => MovieMapper.movieDBToEntity(moviedb))
            .toList();
    return movies;
  }

  @override
  Future<Movie> getMovieById(String id) async {
    final response = await dio.get('movie/$id');

    if (response.statusCode != 200)
      throw Exception('movie with id: $id not fund');

    final movieDB = MovieDetails.fromJson(response.data);
    return movieDB;
  }
}
