import 'package:go_router/go_router.dart';
import 'package:movie_list_tmdb/app/modules/home/presentation/views/movie_list_view.dart';

class AppRouter {
  static var router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => MovieListView(),
      ),
      GoRoute(
        path: '/movie_details',
        builder: (context, state) => MovieListView(),
      ),
    ],
  );
}
