import 'package:movie_list_tmdb/app/modules/home/domain/entities/movie.dart';

class MovieSingletonData {
  Movie? movie;
  update(Movie movie) {
    this.movie = movie;
  }
}
