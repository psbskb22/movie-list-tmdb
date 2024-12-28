import 'package:movie_list_tmdb/app/local_storage/client/sql_client.dart';
import 'package:movie_list_tmdb/app/local_storage/database/sql_database.dart';
import 'package:movie_list_tmdb/app/modules/home/data/model/movies_response_data.dart';

abstract class MovieListLocalDatasource {
  Future<MoviesResponseData> getMovieList(int pageNumber);
  Future<bool> cacheMovieList(
      int pageNumber, MoviesResponseData moviesResponseData);
}

class MovieListLocalDatasourceImpl implements MovieListLocalDatasource {
  final StorageType storageType;

  late SQLClient sqlClient;

  MovieListLocalDatasourceImpl({this.storageType = StorageType.internal}) {
    sqlClient = SQLClient(tableName: "movieList", storageType: storageType);
  }

  @override
  Future<MoviesResponseData> getMovieList(int pageNumber) async {
    List<Map<String, dynamic>> data =
        await sqlClient.read(id: pageNumber.toString());
    return MoviesResponseData.fromJson(data.first);
  }

  @override
  Future<bool> cacheMovieList(
      int pageNumber, MoviesResponseData moviesResponseData) async {
    return await sqlClient.write(
        id: pageNumber.toString(), data: moviesResponseData.toJson());
  }
}
