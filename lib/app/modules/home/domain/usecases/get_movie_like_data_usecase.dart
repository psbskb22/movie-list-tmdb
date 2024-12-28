import 'package:movie_list_tmdb/app/modules/home/domain/repositories/movie_list_repository.dart';

class GetMovieLikeDataUsecase {
  final MovieListRepository movieListRepository;

  GetMovieLikeDataUsecase({required this.movieListRepository});

  Future<bool> getMovieLikeData(String movieId) async {
    return await movieListRepository.getMovieLikeData(movieId);
  }

  Future<bool> addMovieLikeData(String movieId, bool isLiked) async {
    return await movieListRepository.cacheMovieLikeData(movieId, isLiked);
  }
}
