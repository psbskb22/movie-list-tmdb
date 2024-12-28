import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:movie_list_tmdb/app/core/data_injection/models/movie_singleton.dart';
import 'package:movie_list_tmdb/app/core/state/api_state.dart';
import 'package:movie_list_tmdb/app/core/widgets/shimmer_loading.dart';
import 'package:movie_list_tmdb/app/modules/home/domain/entities/movie.dart';
import 'package:movie_list_tmdb/app/modules/home/presentation/cubits/movie_list_cubit.dart';
import 'package:movie_list_tmdb/app/router/app_routers.dart';

import '../../../../core/widgets/movie_like_widget.dart';

TextEditingController searchTextEditingController = TextEditingController();

class MovieListView extends StatelessWidget {
  const MovieListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie List'),
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => MovieListCubit()..getMovieList(),
          )
        ],
        child: SafeArea(child: MovieList()),
      ),
    );
  }
}

class MovieList extends StatelessWidget {
  const MovieList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: TextField(
            controller: searchTextEditingController,
            onChanged: (value) {
              if (value.isEmpty) {
                context.read<MovieListCubit>().getMovieList();
              }
              context.read<MovieListCubit>().getMovieList(searchKeyword: value);
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
        Expanded(child: BlocBuilder<MovieListCubit, ApiState>(
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
              return Center(child: Text(state.errorMessage));
            } else if (state is ApiDataState) {
              return Center(child: Text(state.data));
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
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        context.read<MovieListCubit>().getMovieList(pagination: true);
        searchTextEditingController.clear();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
          controller: scrollController,
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

class MoiveListCard extends StatelessWidget {
  const MoiveListCard({
    super.key,
    required this.movie,
  });

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        GetIt.I<MovieSingletonData>().update(movie);
        context.push(AppRoutesPath.movieDetails);
      },
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  AspectRatio(
                    aspectRatio: 0.95,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        "https://image.tmdb.org/t/p/w200${movie.posterPath}",
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      movie.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge!
                          .copyWith(color: Colors.white),
                    ),
                  ),
                  LikeButtonWidget(movieId: movie.id),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
