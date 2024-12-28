import 'dart:convert';

import 'package:movie_list_tmdb/app/api_client/api_client.dart';
import 'package:movie_list_tmdb/app/modules/home/data/model/movies_response_data.dart';

abstract class MovieListRemoteDatasource {
  Future<MoviesResponseData> getMovieList(int pageNumber);
}

class MovieListRemoteDatasourceImpl implements MovieListRemoteDatasource {
  final APIClient apiClient;

  MovieListRemoteDatasourceImpl({required this.apiClient});

  @override
  Future<MoviesResponseData> getMovieList(int pageNumber) async {
    String data = await apiClient.get("/3/trending/movie/day?page=$pageNumber");
    return MoviesResponseData.fromJson(json.decode(data));
  }
}
