sealed class BibleReaderLaunchResult {}

final class Success extends BibleReaderLaunchResult {}

final class Failure extends BibleReaderLaunchResult {
  Failure([this.exception]);

  final Exception? exception;
}
