sealed class Result {}

final class Success extends Result {}

final class Failure extends Result {
  Failure({this.exception});

  final Exception? exception;
}
