abstract class ApiState {}

class ApiInitialState extends ApiState {}

class ApiLoadingState extends ApiState {}

class ApiErrorState extends ApiState {
  final String errorMessage;

  ApiErrorState({required this.errorMessage});
}

class ApiLoadingDataState<T> extends ApiState {
  final T data;

  ApiLoadingDataState({required this.data});
}

class ApiDataState<T> extends ApiState {
  final T data;

  ApiDataState({required this.data});
}
