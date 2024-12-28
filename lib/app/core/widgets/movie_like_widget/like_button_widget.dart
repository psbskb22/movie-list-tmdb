import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_list_tmdb/app/modules/home/domain/entities/movie.dart';
import 'liked_movie_cubit.dart';

class LikeButtonWidget extends StatelessWidget {
  final double? iconSize;
  final Movie movie;
  const LikeButtonWidget({
    super.key,
    required this.movie,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          LikedMovieCubit()..getLikedMovie(movie.id.toString()),
      child: LikeButton(
        iconSize: iconSize,
        movie: movie,
      ),
    );
  }
}

class LikeButton extends StatelessWidget {
  final Movie movie;
  final double? iconSize;
  const LikeButton({
    super.key,
    required this.iconSize,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LikedMovieCubit, Movie?>(
      builder: (context, state) {
        return InkWell(
          onTap: () {
            context.read<LikedMovieCubit>().like(movie);
          },
          child: state != null && state.id == movie.id
              ? Icon(
                  Icons.favorite,
                  color: Colors.redAccent,
                  size: iconSize,
                )
              : Icon(
                  Icons.favorite_outline_sharp,
                  color: Theme.of(context).colorScheme.onSecondary,
                  size: iconSize,
                ),
        );
      },
    );
  }
}
