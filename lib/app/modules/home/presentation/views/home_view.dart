import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_list_tmdb/app/modules/home/presentation/cubits/favorite_movie_list_cubit.dart';
import 'package:movie_list_tmdb/app/modules/home/presentation/cubits/movie_list_cubit.dart';
import 'package:movie_list_tmdb/app/modules/home/presentation/cubits/movie_list_type_selection_cubit.dart';
import 'package:movie_list_tmdb/app/modules/home/presentation/views/movie_list_view.dart';

import '../widgets/toggle_button.dart';
import 'favorite_movie_list_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => MovieListCubit()..getMovieList(pageNumber: 1),
        ),
        BlocProvider(
          create: (context) => FavoriteMovieListCubit(),
        ),
        BlocProvider(
          create: (context) => MovieListTypeSelectionCubit(),
        ),
      ],
      child: MovieList(),
    );
  }
}

class MovieList extends StatelessWidget {
  const MovieList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie List'),
        actions: [
          ToggleButton(
            onSelect: (index) {
              context.read<MovieListTypeSelectionCubit>().select(index);
              if (index == 0) {
                context.read<MovieListCubit>().getMovieList(pageNumber: 1);
              } else {
                context.read<FavoriteMovieListCubit>().getFavoriteMovieList();
              }
            },
          )
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<MovieListTypeSelectionCubit, MovieListType>(
          builder: (context, state) {
            if (state == MovieListType.all) {
              return MovieListView();
            }
            return FavoriteMovieListView();
          },
        ),
      ),
    );
  }
}
