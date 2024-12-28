import 'package:flutter/material.dart';
import 'package:movie_list_tmdb/app/api_client/api_client.dart';

import '../../modules/home/data/datasources/movie_list_local_datasource.dart';
import '../../modules/home/data/datasources/movie_list_remote_datasource.dart';
import '../../modules/home/data/repositories/movie_list_repository_impl.dart';
import '../../modules/home/domain/repositories/movie_list_repository.dart';
import '../../modules/home/domain/usecases/get_movie_like_data_usecase.dart';

class LikeButtonWidget extends StatefulWidget {
  const LikeButtonWidget({
    super.key,
    required this.movieId,
  });

  final int movieId;

  @override
  State<LikeButtonWidget> createState() => _LikeButtonWidgetState();
}

class _LikeButtonWidgetState extends State<LikeButtonWidget> {
  bool isLiked = false;
  late GetMovieLikeDataUsecase getMovieLikeDataUsecase;

  init() async {
    isLiked = await getMovieLikeDataUsecase
        .getMovieLikeData(widget.movieId.toString());
    setState(() {});
  }

  Future<void> likeMovie() async {
    isLiked = !isLiked;
    await getMovieLikeDataUsecase.addMovieLikeData(
        widget.movieId.toString(), isLiked);
    setState(() {});
  }

  @override
  void initState() {
    MovieListRepository movieListRepository = MovieListRepositoryImpl(
      movieListRemoteDatasource:
          MovieListRemoteDatasourceImpl(apiClient: APIClient()),
      movieListLocalDatasource: MovieListLocalDatasourceImpl(),
    );
    getMovieLikeDataUsecase =
        GetMovieLikeDataUsecase(movieListRepository: movieListRepository);
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          likeMovie();
        });
      },
      child: isLiked
          ? const Icon(
              Icons.favorite,
              color: Colors.redAccent,
            )
          : const Icon(Icons.favorite_outline_sharp),
    );
  }
}
