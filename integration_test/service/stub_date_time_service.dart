import 'package:bible_feed/injectable.env.dart';
import 'package:bible_feed/service/date_time_service.dart';
import 'package:injectable/injectable.dart';

@integrationTest
@LazySingleton(as: DateTimeService)
class StubDateTimeService extends DateTimeService {
  DateTime _now = DateTime.now();

  @override
  DateTime get now => _now;

  set now(DateTime value) => _now = value;

  void advance1day() => _now = _now.add(const Duration(days: 1));
}
