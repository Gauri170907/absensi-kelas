abstract class ApiException implements Exception {
  final String message;

  ApiException(this.message);
}

class UnknownException extends ApiException {
  UnknownException() : super("Something went wrong unexpectedly");
}

class NoInternetConnectionException extends ApiException {
  NoInternetConnectionException() : super("No internet connection");
}

class InternalException extends ApiException {
  InternalException() : super("Something went wrong");
}

class ServerException extends ApiException {
  ServerException() : super("Connection error to host");
}

class TimeOutException extends ApiException {
  TimeOutException() : super("Timeout");
}
