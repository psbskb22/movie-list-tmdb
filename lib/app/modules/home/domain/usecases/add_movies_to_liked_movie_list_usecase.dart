import 'package:movie_list_tmdb/app/modules/home/domain/repositories/movie_list_repository.dart';

import '../entities/movie.dart';

class AddMoviesToLikedMovieListUsecase {
  final MovieListRepository movieListRepository;

  AddMoviesToLikedMovieListUsecase({required this.movieListRepository});

  Future<bool> call(Movie movie) async {
    return await movieListRepository.addMoviesToLikedMovieList(movie);
  }
}
