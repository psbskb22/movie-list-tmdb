import 'package:dartz/dartz.dart';
import 'package:movie_list_tmdb/app/failure/failure.dart';
import 'package:movie_list_tmdb/app/modules/home/domain/repositories/movie_list_repository.dart';

import '../entities/movie.dart';

class GetMovieListUsecase {
  final MovieListRepository movieListRepository;

  GetMovieListUsecase({required this.movieListRepository});

  Future<Either<Failure, List<Movie>>> call(int pageNumber) async {
    return await movieListRepository.getMovieList(pageNumber);
  }
}
