import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_list_tmdb/app/core/data_injection/models/movie_singleton.dart';
import 'package:movie_list_tmdb/app/core/widgets/movie_like_widget/like_button_widget.dart';
import 'package:movie_list_tmdb/app/router/app_routers.dart';

import '../../domain/entities/movie.dart';

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
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }
                          return Container(
                            color: Theme.of(context).colorScheme.tertiary,
                          );
                        },
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
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onSecondary),
                    ),
                  ),
                  LikeButtonWidget(movie: movie),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
