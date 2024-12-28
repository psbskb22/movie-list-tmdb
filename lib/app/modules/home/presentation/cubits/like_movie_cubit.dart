import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_list_tmdb/app/api_client/api_client.dart';
import 'package:movie_list_tmdb/app/modules/home/data/datasources/movie_list_local_datasource.dart';
import 'package:movie_list_tmdb/app/modules/home/data/datasources/movie_list_remote_datasource.dart';
import 'package:movie_list_tmdb/app/modules/home/domain/repositories/movie_list_repository.dart';
import 'package:movie_list_tmdb/app/modules/home/domain/usecases/get_movie_like_data_usecase.dart';

import '../../data/repositories/movie_list_repository_impl.dart';

class LikeMovieCubit extends Cubit<bool> {
  LikeMovieCubit() : super(false);

  Future<void> likeMovie(String movieId) async {
    MovieListRepository movieListRepository = MovieListRepositoryImpl(
      movieListRemoteDatasource:
          MovieListRemoteDatasourceImpl(apiClient: APIClient()),
      movieListLocalDatasource: MovieListLocalDatasourceImpl(),
    );
    GetMovieLikeDataUsecase getMovieLikeDataUsecase =
        GetMovieLikeDataUsecase(movieListRepository: movieListRepository);
    await getMovieLikeDataUsecase.addMovieLikeData(movieId, !state);
    bool isLiked = await getMovieLikeDataUsecase.getMovieLikeData(movieId);
    emit(isLiked);
  }
}
