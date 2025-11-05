import 'package:movies/domain/entities/movie.dart';
import 'package:movies/infrastructure/models/moviedb/movie_details.dart';
import 'package:movies/infrastructure/models/moviedb/movie_moviedb.dart';

Movie movieDetailsToEntity( MovieDetails moviedb ) => Movie(

      adult: moviedb.adult,

      backdropPath: (moviedb.backdropPath != '') 

        ? 'https://image.tmdb.org/t/p/w500${ moviedb.backdropPath }'

        : 'https://sd.keepcalms.com/i-w600/keep-calm-poster-not-found.jpg',

      genreIds: moviedb.genres.map((e) => e.name ).toList(),

      id: moviedb.id,

      originalLanguage: moviedb.originalLanguage,

      originalTitle: moviedb.originalTitle,

      overview: moviedb.overview,

      popularity: moviedb.popularity,

      posterPath: (moviedb.posterPath != '')

        ? 'https://image.tmdb.org/t/p/w500${ moviedb.posterPath }'

        : 'https://sd.keepcalms.com/i-w600/keep-calm-poster-not-found.jpg',

      releaseDate: moviedb.releaseDate,

      title: moviedb.title,

      video: moviedb.video,

      voteAverage: moviedb.voteAverage,

      voteCount: moviedb.voteCount

    );