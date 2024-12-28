import 'package:movie_list_tmdb/app/modules/home/domain/entities/movie.dart';
import 'package:movie_list_tmdb/app/modules/home/domain/repositories/movie_list_repository.dart';

class GetLikedMovieDataUsecase {
  final MovieListRepository movieListRepository;

  GetLikedMovieDataUsecase({required this.movieListRepository});

  Future<List<Movie>> call([String? movieId]) async {
    return await movieListRepository.getLikedMoviesList(movieId);
  }
}
