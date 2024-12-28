import 'package:get_it/get_it.dart';

import 'models/movie_singleton.dart';

class GetItDataInjection {
  static void setup() {
    GetIt.I.registerSingleton<MovieSingletonData>(MovieSingletonData());
  }
}
