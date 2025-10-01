import 'package:bible_feed/injectable.env.dart';
import 'package:bible_feed/service/date_time_service.dart';
import 'package:injectable/injectable.dart';

@midnightTest
@LazySingleton(as: DateTimeService)
class MidnightDateTimeService extends DateTimeService {
  static const int _allowToSettleSecs = 2;
  final Duration _offset;

  MidnightDateTimeService()
    : _offset = DateTime(2025, 1, 1, 23, 59, 60 - _allowToSettleSecs).difference(DateTime.now());

  @override
  DateTime get now => DateTime.now().add(_offset);
}
