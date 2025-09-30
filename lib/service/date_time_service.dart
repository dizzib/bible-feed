import 'package:injectable/injectable.dart';

import '../injectable.dart';

abstract class DateTimeService {
  DateTime get now;
}

@prod
@LazySingleton(as: DateTimeService)
class NowDateTimeService extends DateTimeService {
  @override
  DateTime get now => DateTime.now();
}

@integrationTest
@LazySingleton(as: DateTimeService)
class MidnightDateTimeService extends DateTimeService {
  static const int _allowTimeToSettleSecs = 2;
  late final Duration _offset;

  MidnightDateTimeService() {
    _offset = DateTime(2025, 1, 1, 23, 59, 60 - _allowTimeToSettleSecs).difference(DateTime.now());
  }

  @override
  DateTime get now => DateTime.now().add(_offset);
}
