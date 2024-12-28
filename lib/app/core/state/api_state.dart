abstract class ApiState {}

class ApiInitialState extends ApiState {}

class ApiLoadingState extends ApiState {}

class ApiErrorState extends ApiState {
  final String errorMessage;

  ApiErrorState({required this.errorMessage});
}

class ApiDataState<T> extends ApiState {
  final T data;
  final bool isLoading;

  ApiDataState({required this.data, required this.isLoading});
}
