import 'package:injectable/injectable.dart';

// Prefer this to clock, due to issues like:
//
// - https://github.com/dart-lang/tools/issues/705 manifesting in integration tests.
// - https://github.com/dart-lang/test/issues/2304
//
abstract class DateTimeService {
  DateTime get now;
}

@prod
@LazySingleton(as: DateTimeService)
class NowDateTimeService extends DateTimeService {
  @override
  DateTime get now => DateTime.now();
}
