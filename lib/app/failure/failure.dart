abstract class Failure {
  final String message;

  Failure({this.message = ""});
}

class DefaultFailure extends Failure {
  DefaultFailure({super.message});
}

class ClientFailure extends Failure {
  ClientFailure({super.message});
}

class ServerFailure extends Failure {
  ServerFailure({super.message});
}
