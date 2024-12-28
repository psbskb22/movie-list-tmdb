import 'package:flutter_bloc/flutter_bloc.dart';

enum MovieListType { all, favorite }

class MovieListTypeSelectionCubit extends Cubit<MovieListType> {
  MovieListTypeSelectionCubit() : super(MovieListType.all);

  select(int index) {
    if (index == 0) {
      emit(MovieListType.all);
    } else {
      emit(MovieListType.favorite);
    }
  }
}
