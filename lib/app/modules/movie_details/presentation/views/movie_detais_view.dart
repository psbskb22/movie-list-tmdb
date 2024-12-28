import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:movie_list_tmdb/app/core/data_injection/models/movie_singleton.dart';
import 'package:movie_list_tmdb/app/core/state/data_state.dart';
import 'package:movie_list_tmdb/app/core/widgets/movie_like_widget/like_button_widget.dart';
import 'package:movie_list_tmdb/app/core/widgets/shimmer_loading.dart';
import 'package:movie_list_tmdb/app/modules/home/domain/entities/movie.dart';

import '../cubits/movie_details_cubit.dart';

class MovieDetaisView extends StatelessWidget {
  const MovieDetaisView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   leading: IconButton(
      //       onPressed: () {
      //         context.pop();
      //       },
      //       icon: Icon(Icons.arrow_back_ios_new_rounded)),
      //   titleSpacing: 0,
      // ),
      body: Center(
        child: BlocProvider(
          create: (context) => MovieDetailsCubit()..getData(),
          child: MovieDetailsWidget(),
        ),
      ),
    );
  }
}

class MovieDetailsWidget extends StatelessWidget {
  const MovieDetailsWidget({
    super.key,
  });

  String showData(String date) {
    return DateFormat("dd MMM yyyy").format(DateTime.parse(date));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovieDetailsCubit, DataState>(
      builder: (context, state) {
        if (state is FinalDataState) {
          Movie movie = state.data as Movie;
          return Column(
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Stack(
                  children: [
                    ShimmerLoading(
                      child: Container(
                        color: Colors.grey,
                        height: 300,
                        width: MediaQuery.of(context).size.width,
                      ),
                    ),
                    ClipRRect(
                      child: Image.network(
                        "https://image.tmdb.org/t/p/w500${movie.backdropPath}",
                        loadingBuilder: (context, child, loadingProgress) {
                          return child;
                        },
                        fit: BoxFit.cover,
                        height: 300,
                        width: MediaQuery.of(context).size.width,
                      ),
                    ),
                    SafeArea(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    context.pop();
                                  },
                                  child: Icon(
                                    Icons.arrow_back_ios_new_rounded,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                LikeButtonWidget(
                                  movie: movie,
                                  iconSize: 30,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  spacing: 8,
                  children: [
                    Row(
                      spacing: 8,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            "https://image.tmdb.org/t/p/w200${movie.posterPath}",
                            fit: BoxFit.cover,
                            height: 100,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                movie.title,
                                maxLines: 2,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              Text(
                                  "Rating: ${movie.voteAverage.toString()}/10"),
                              Text(
                                  "Release Data: ${showData(movie.releaseDate.toString())}"),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Text(movie.overview ?? ""),
                  ],
                ),
              ),
            ],
          );
        }
        return Text('Movie Details');
      },
    );
  }
}
