import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_list_tmdb/app/api_client/api_client.dart';
import 'package:movie_list_tmdb/app/core/state/api_state.dart';

import '../../data/datasources/movie_list_local_datasource.dart';
import '../../data/datasources/movie_list_remote_datasource.dart';
import '../../data/repositories/movie_list_repository_impl.dart';
import '../../domain/entities/movie.dart';
import '../../domain/repositories/movie_list_repository.dart';
import '../../domain/usecases/get_liked_movie_list_usecase.dart';

class FavoriteMovieListCubit extends Cubit<ApiState> {
  FavoriteMovieListCubit() : super(ApiInitialState());

  List<Movie> favoriteMovieList = [];
  String? _searchKeyword;

  MovieListRepository movieListRepository = MovieListRepositoryImpl(
    movieListRemoteDatasource:
        MovieListRemoteDatasourceImpl(apiClient: APIClient()),
    movieListLocalDatasource: MovieListLocalDatasourceImpl(),
  );

  void getFavoriteMovieList({String? searchKeyword}) async {
    emit(ApiLoadingState());
    if (searchKeyword != null) {
      _searchKeyword = searchKeyword;
      List<Movie> serachMovieList = _searchMovie(_searchKeyword!);
      emit(ApiDataState(data: serachMovieList, isLoading: false));
      return;
    }
    GetLikedMovieDataUsecase getMovieLikeDataUsecase =
        GetLikedMovieDataUsecase(movieListRepository: movieListRepository);
    favoriteMovieList = await getMovieLikeDataUsecase.call();
    if (favoriteMovieList.isEmpty) {
      emit(ApiErrorState(errorMessage: "No favorite movie found"));
      return;
    }
    emit(ApiDataState(data: favoriteMovieList, isLoading: false));
  }

  List<Movie> _searchMovie(String searchKeyword) {
    List<Movie> serachMovieList = List<Movie>.from(favoriteMovieList);
    serachMovieList = favoriteMovieList
        .where((element) => element.title.toLowerCase().contains(searchKeyword))
        .toList();
    return serachMovieList;
  }
}
