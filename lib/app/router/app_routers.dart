import 'package:go_router/go_router.dart';
import 'package:movie_list_tmdb/app/modules/home/presentation/views/home_view.dart';
import 'package:movie_list_tmdb/app/modules/movie_details/presentation/views/movie_detais_view.dart';

class AppRouter {
  static var router = GoRouter(
    routes: [
      GoRoute(
        path: AppRoutesPath.init,
        builder: (context, state) => HomeView(),
      ),
      GoRoute(
        path: AppRoutesPath.movieDetails,
        builder: (context, state) => MovieDetaisView(),
      ),
    ],
  );
}

class AppRoutesPath {
  static const String init = '/';
  static const String movieDetails = '/movie_details';
}
