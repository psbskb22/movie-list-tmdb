import 'package:dartz/dartz.dart';
import 'package:movie_list_tmdb/app/failure/failure.dart';

import '../entities/movie.dart';

abstract class MovieListRepository {
  Future<Either<Failure, List<Movie>>> getMovieList(int pageNumber);
  Future<bool> getMovieLikeData(String movieId);
  Future<bool> cacheMovieLikeData(String movieId, bool isLiked);
}
