import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:movie_list_tmdb/app/core/data_injection/models/movie_singleton.dart';
import 'package:movie_list_tmdb/app/core/state/data_state.dart';
import 'package:movie_list_tmdb/app/modules/home/domain/entities/movie.dart';

class MovieDetailsCubit extends Cubit<DataState> {
  MovieDetailsCubit() : super(InitialDataState());

  getData() {
    emit(LoadingDataState());
    MovieSingletonData data = GetIt.I.get<MovieSingletonData>();
    Movie? movie = data.movie;
    if (movie == null) {
      emit(ErrorDataState(errorMessage: 'No data found'));
      return;
    } else {
      emit(FinalDataState(data: movie));
    }
  }
}
