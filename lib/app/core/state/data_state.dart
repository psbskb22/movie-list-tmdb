abstract class DataState {}

class InitialDataState extends DataState {}

class LoadingDataState extends DataState {}

class ErrorDataState extends DataState {
  final String errorMessage;

  ErrorDataState({required this.errorMessage});
}

class FinalDataState<T> extends DataState {
  final T data;

  FinalDataState({required this.data});
}
