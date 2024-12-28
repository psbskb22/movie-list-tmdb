import 'package:movie_list_tmdb/app/local_storage/client/sql_client.dart';
import 'package:movie_list_tmdb/app/local_storage/database/sql_database.dart';
import 'package:movie_list_tmdb/app/modules/home/data/model/movies_response_data.dart';

import '../../domain/entities/movie.dart';

abstract class MovieListLocalDatasource {
  Future<MoviesResponseData> getMovieList(int pageNumber);
  Future<List<Movie>> getLikedMoviesList(String? movieId);
  Future<bool> cacheMovieList(
      int pageNumber, MoviesResponseData moviesResponseData);
  Future<bool> addMoviesToLikedMovieList(Movie movie);
  Future<bool> deleteMoviesToLikedMovieList(String movieId);
}

class MovieListLocalDatasourceImpl implements MovieListLocalDatasource {
  final StorageType storageType;

  late SQLClient sqlClient;
  late SQLClient likeSqlClient;

  MovieListLocalDatasourceImpl({this.storageType = StorageType.internal}) {
    sqlClient = SQLClient(tableName: "movieList", storageType: storageType);
    likeSqlClient = SQLClient(tableName: "movieLike", storageType: storageType);
  }

  @override
  Future<MoviesResponseData> getMovieList(int pageNumber) async {
    List<Map<String, dynamic>> data =
        await sqlClient.read(id: pageNumber.toString());
    return MoviesResponseData.fromJson(data.first);
  }

  @override
  Future<List<Movie>> getLikedMoviesList(String? movieId) async {
    List<Map<String, dynamic>> data = await likeSqlClient.read(id: movieId);
    return data.map((element) {
      Movie movie = Movie.fromJson(element);
      return movie;
    }).toList();
  }

  @override
  Future<bool> cacheMovieList(
      int pageNumber, MoviesResponseData moviesResponseData) async {
    return await sqlClient.write(
        id: pageNumber.toString(), data: moviesResponseData.toJson());
  }

  @override
  Future<bool> addMoviesToLikedMovieList(Movie movie) async {
    return await likeSqlClient.write(
        id: movie.id.toString(), data: movie.toJson());
  }

  @override
  Future<bool> deleteMoviesToLikedMovieList(String movieId) async {
    return await likeSqlClient.delete(id: movieId);
  }
}
