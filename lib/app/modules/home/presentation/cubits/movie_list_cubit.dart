import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_list_tmdb/app/api_client/api_client.dart';
import 'package:movie_list_tmdb/app/core/state/api_state.dart';
import 'package:movie_list_tmdb/app/failure/exceptions.dart';
import 'package:movie_list_tmdb/app/failure/failure.dart';
import 'package:movie_list_tmdb/app/modules/home/data/datasources/movie_list_local_datasource.dart';
import 'package:movie_list_tmdb/app/modules/home/data/datasources/movie_list_remote_datasource.dart';
import 'package:movie_list_tmdb/app/modules/home/data/repositories/movie_list_repository_impl.dart';
import 'package:movie_list_tmdb/app/modules/home/domain/entities/movie.dart';
import 'package:movie_list_tmdb/app/modules/home/domain/repositories/movie_list_repository.dart';
import 'package:movie_list_tmdb/app/modules/home/domain/usecases/get_movie_list_usecase.dart';
import 'package:movie_list_tmdb/main.dart';

class MovieListCubit extends Cubit<ApiState> {
  MovieListCubit() : super(ApiInitialState());

  int _pageNumber = 1;
  String? _searchKeyword;
  List<Movie> movieList = [];

  MovieListRepository movieListRepository = MovieListRepositoryImpl(
    movieListRemoteDatasource:
        MovieListRemoteDatasourceImpl(apiClient: APIClient()),
    movieListLocalDatasource: MovieListLocalDatasourceImpl(),
  );

  void getMovieList({bool pagination = false, String? searchKeyword}) async {
    if (pagination == true) {
      _pageNumber++;
      _searchKeyword = null;
    }
    if (searchKeyword != null) {
      _searchKeyword = searchKeyword;
      List<Movie> serachMovieList = _searchMovie(_searchKeyword!);
      emit(ApiDataState(data: serachMovieList, isLoading: false));
      return;
    }
    if (movieList.isEmpty) {
      emit(ApiLoadingState());
    } else {
      emit(ApiDataState(data: movieList, isLoading: true));
    }

    GetMovieListUsecase getMovieListUsecase =
        GetMovieListUsecase(movieListRepository: movieListRepository);
    Either<Failure, List<Movie>> result =
        await getMovieListUsecase.call(_pageNumber);
    result.fold((l) {
      String errorMessage = "Failed to load data";
      if (l is NoInternetException) {
        errorMessage = "No internet connection";
      } else if (l is TimeoutException) {
        errorMessage = "Request timeout";
      } else if (l is ClientException) {
        errorMessage = "Client error";
      } else if (l is ServerException) {
        errorMessage = "Server error";
      }
      final scaffoldMessengerState = scaffoldMessengerKey.currentState;
      scaffoldMessengerState!.showSnackBar(SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.redAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ));
      emit(ApiErrorState(errorMessage: errorMessage));
    }, (r) {
      if (pagination) {
        movieList.addAll(r);
      } else {
        movieList = r;
      }
      emit(ApiDataState(data: movieList, isLoading: false));
    });
  }

  List<Movie> _searchMovie(String searchKeyword) {
    List<Movie> serachMovieList = List<Movie>.from(movieList);
    serachMovieList = movieList
        .where((element) => element.title.toLowerCase().contains(searchKeyword))
        .toList();
    return serachMovieList;
  }
}
