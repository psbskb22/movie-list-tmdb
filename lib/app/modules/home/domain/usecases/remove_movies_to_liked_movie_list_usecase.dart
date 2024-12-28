import 'package:movie_list_tmdb/app/modules/home/domain/repositories/movie_list_repository.dart';

import '../entities/movie.dart';

class RemoveMoviesToLikedMovieListUsecase {
  final MovieListRepository movieListRepository;

  RemoveMoviesToLikedMovieListUsecase({required this.movieListRepository});

  Future<bool> call(String movieId) async {
    return await movieListRepository.deleteMoviesToLikedMovieList(movieId);
  }
}
