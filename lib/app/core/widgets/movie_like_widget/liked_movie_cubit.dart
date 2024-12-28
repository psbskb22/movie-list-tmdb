import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_list_tmdb/app/api_client/api_client.dart';
import 'package:movie_list_tmdb/app/modules/home/data/datasources/movie_list_local_datasource.dart';
import 'package:movie_list_tmdb/app/modules/home/data/datasources/movie_list_remote_datasource.dart';
import 'package:movie_list_tmdb/app/modules/home/data/repositories/movie_list_repository_impl.dart';
import 'package:movie_list_tmdb/app/modules/home/domain/entities/movie.dart';
import 'package:movie_list_tmdb/app/modules/home/domain/repositories/movie_list_repository.dart';
import 'package:movie_list_tmdb/app/modules/home/domain/usecases/add_movies_to_liked_movie_list_usecase.dart';
import 'package:movie_list_tmdb/app/modules/home/domain/usecases/get_liked_movie_list_usecase.dart';
import 'package:movie_list_tmdb/app/modules/home/domain/usecases/remove_movies_to_liked_movie_list_usecase.dart';

class LikedMovieCubit extends Cubit<Movie?> {
  LikedMovieCubit() : super(null);
  MovieListRepository movieListRepository = MovieListRepositoryImpl(
    movieListRemoteDatasource:
        MovieListRemoteDatasourceImpl(apiClient: APIClient()),
    movieListLocalDatasource: MovieListLocalDatasourceImpl(),
  );

  getLikedMovie(String movieId) async {
    GetLikedMovieDataUsecase getMovieLikeDataUsecase =
        GetLikedMovieDataUsecase(movieListRepository: movieListRepository);
    List<Movie> movies = await getMovieLikeDataUsecase.call(movieId);
    if (!isClosed) emit(movies.firstOrNull);
  }

  like(Movie movie) {
    if (state != null) {
      _removeLikedMovie(state!.id.toString());
    } else {
      _addLikedMovie(movie);
    }
  }

  _addLikedMovie(Movie movie) async {
    AddMoviesToLikedMovieListUsecase addMoviesToLikedMovieListUsecase =
        AddMoviesToLikedMovieListUsecase(
            movieListRepository: movieListRepository);
    bool result = await addMoviesToLikedMovieListUsecase.call(movie);
    if (result) emit(movie);
  }

  _removeLikedMovie(String movieId) async {
    RemoveMoviesToLikedMovieListUsecase removeMoviesToLikedMovieListUsecase =
        RemoveMoviesToLikedMovieListUsecase(
            movieListRepository: movieListRepository);
    bool result = await removeMoviesToLikedMovieListUsecase.call(movieId);
    if (result) emit(null);
  }
}
