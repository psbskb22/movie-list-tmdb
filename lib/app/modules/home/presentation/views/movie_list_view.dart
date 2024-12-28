import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_list_tmdb/app/core/state/api_state.dart';
import 'package:movie_list_tmdb/app/modules/home/domain/entities/movie.dart';
import 'package:movie_list_tmdb/app/modules/home/presentation/cubits/movie_list_cubit.dart';

import '../widgets/like_animated_icon_widget.dart';

class MovieListView extends StatelessWidget {
  const MovieListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie List'),
      ),
      body: BlocProvider(
        create: (context) => MovieListCubit()..getMovieList(),
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
            if (state is ApiLoadingDataState) {
              List<Movie> movieList = state.data;
              return Column(
                children: [
                  Expanded(child: MovieListWidget(movieList: movieList)),
                  const Center(child: CircularProgressIndicator()),
                ],
              );
            }
            if (state is ApiDataState) {
              List<Movie> movieList = state.data;
              return MovieListWidget(movieList: movieList);
            } else if (state is ApiErrorState) {
              return Center(child: Text(state.errorMessage));
            } else if (state is ApiDataState) {
              return Center(child: Text(state.data));
            }
            return const Center(child: CircularProgressIndicator());
          },
        )),
      ],
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
            return Container(
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
                              "https://image.tmdb.org/t/p/w200${widget.movieList[index].posterPath}",
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
                            widget.movieList[index].title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(color: Colors.white),
                          ),
                        ),
                        LikeAnimatedIconWidget(),
                        // Icon(Icons.favorite_outline_sharp),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
