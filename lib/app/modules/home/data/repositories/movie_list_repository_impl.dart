import 'package:dartz/dartz.dart';
import 'package:movie_list_tmdb/app/failure/failure.dart';
import 'package:movie_list_tmdb/app/modules/home/data/datasources/movie_list_local_datasource.dart';
import 'package:movie_list_tmdb/app/modules/home/data/datasources/movie_list_remote_datasource.dart';
import 'package:movie_list_tmdb/app/modules/home/data/model/movies_response_data.dart';
import 'package:movie_list_tmdb/app/modules/home/domain/repositories/movie_list_repository.dart';

import '../../domain/entities/movie.dart';

class MovieListRepositoryImpl extends MovieListRepository {
  final MovieListRemoteDatasource movieListRemoteDatasource;
  final MovieListLocalDatasource movieListLocalDatasource;

  MovieListRepositoryImpl({
    required this.movieListRemoteDatasource,
    required this.movieListLocalDatasource,
  });
  @override
  Future<Either<Failure, List<Movie>>> getMovieList(int pageNumber) async {
    try {
      MoviesResponseData data =
          await movieListRemoteDatasource.getMovieList(pageNumber);
      await movieListLocalDatasource.cacheMovieList(pageNumber, data);
      return Right(data.results);
    } catch (e) {
      try {
        MoviesResponseData data =
            await movieListLocalDatasource.getMovieList(pageNumber);
        return Right(data.results);
      } catch (e) {
        return Left(DefaultFailure(message: e.toString()));
      }
    }
  }
}
