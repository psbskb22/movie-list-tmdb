import 'package:movie_list_tmdb/app/local_storage/client/sql_client.dart';
import 'package:movie_list_tmdb/app/local_storage/database/sql_database.dart';
import 'package:movie_list_tmdb/app/modules/home/data/model/movies_response_data.dart';

abstract class MovieListLocalDatasource {
  Future<MoviesResponseData> getMovieList(int pageNumber);
  Future<bool> getMovieLikeData(String movieId);
  Future<bool> cacheMovieList(
      int pageNumber, MoviesResponseData moviesResponseData);
  Future<bool> cacheMoviveLikeData(String movieId, bool isLiked);
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
  Future<bool> getMovieLikeData(String movieId) async {
    List<Map<String, dynamic>> data = await likeSqlClient.read(id: movieId);
    return data.first["isLiked"];
  }

  @override
  Future<bool> cacheMovieList(
      int pageNumber, MoviesResponseData moviesResponseData) async {
    return await sqlClient.write(
        id: pageNumber.toString(), data: moviesResponseData.toJson());
  }

  @override
  Future<bool> cacheMoviveLikeData(String movieId, bool isLiked) async {
    return await likeSqlClient
        .write(id: movieId, data: {"id": movieId, "isLiked": isLiked});
  }
}
