import 'package:injectable/injectable.dart';

import '../injectable.dart';

abstract class DateTimeService {
  DateTime get now;
}

@prod
@test
@LazySingleton(as: DateTimeService)
class NowDateTimeService extends DateTimeService {
  @override
  DateTime get now => DateTime.now();
}

@integrationTest
@LazySingleton(as: DateTimeService)
class MidnightDateTimeService extends DateTimeService {
  static const int _allowToSettleSecs = 2;
  final Duration _offset;

  MidnightDateTimeService()
    : _offset = DateTime(2025, 1, 1, 23, 59, 60 - _allowToSettleSecs).difference(DateTime.now());

  @override
  DateTime get now => DateTime.now().add(_offset);
}
