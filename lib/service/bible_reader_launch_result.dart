sealed class BibleReaderLaunchResult {}

final class LaunchBypassed extends BibleReaderLaunchResult {}

final class LaunchOk extends BibleReaderLaunchResult {}

final class LaunchFailed extends BibleReaderLaunchResult {
  LaunchFailed([this.exception]);

  final Exception? exception;
}
