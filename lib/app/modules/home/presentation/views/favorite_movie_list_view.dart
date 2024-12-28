import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:movie_list_tmdb/app/core/state/api_state.dart';
import 'package:movie_list_tmdb/app/core/widgets/shimmer_loading.dart';
import 'package:movie_list_tmdb/app/modules/home/domain/entities/movie.dart';
import 'package:movie_list_tmdb/app/modules/home/presentation/cubits/movie_list_cubit.dart';

import '../cubits/favorite_movie_list_cubit.dart';
import '../widgets/movie_list_card.dart';
import '../widgets/movie_list_error_widget.dart';

TextEditingController searchTextEditingController = TextEditingController();

class FavoriteMovieListView extends StatelessWidget {
  const FavoriteMovieListView({super.key});

  @override
  Widget build(BuildContext context) {
    searchTextEditingController.clear();
    return Column(
      children: [
        SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: TextField(
            controller: searchTextEditingController,
            onChanged: (value) {
              if (value.isEmpty) {
                context.read<FavoriteMovieListCubit>().getFavoriteMovieList();
              }
              context
                  .read<FavoriteMovieListCubit>()
                  .getFavoriteMovieList(searchKeyword: value);
            },
            decoration: InputDecoration(
              hintText: 'Search for movies',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
        Expanded(child: BlocBuilder<FavoriteMovieListCubit, ApiState>(
          builder: (context, state) {
            if (state is ApiDataState) {
              List<Movie> movieList = state.data;
              bool isLoading = state.isLoading;
              return Column(
                children: [
                  Expanded(child: MovieListWidget(movieList: movieList)),
                  if (isLoading)
                    Center(
                        child: LoadingAnimationWidget.staggeredDotsWave(
                      color: Theme.of(context).colorScheme.primary,
                      size: 50,
                    )),
                ],
              );
            } else if (state is ApiErrorState) {
              return MovieListErrorWidget(
                errorMessage: state.errorMessage,
              );
            }
            return MovieListLoadingWidget();
          },
        )),
      ],
    );
  }
}

class MovieListLoadingWidget extends StatefulWidget {
  const MovieListLoadingWidget({
    super.key,
  });

  @override
  State<MovieListLoadingWidget> createState() => _MovieListLoadingWidgetState();
}

class _MovieListLoadingWidgetState extends State<MovieListLoadingWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 0.8,
          ),
          itemCount: 10,
          itemBuilder: (context, index) {
            return ShimmerLoading(
                child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(16),
              ),
            ));
          }),
    );
  }
}

class MovieListWidget extends StatefulWidget {
  final List<Movie> movieList;
  const MovieListWidget({
    super.key,
    required this.movieList,
  });

  @override
  State<MovieListWidget> createState() => _MovieListWidgetState();
}

class _MovieListWidgetState extends State<MovieListWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 0.8,
          ),
          itemCount: widget.movieList.length,
          itemBuilder: (context, index) {
            return MoiveListCard(movie: widget.movieList[index]);
          }),
    );
  }
}
