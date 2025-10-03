import 'package:bible_feed/injectable.env.dart';
import 'package:bible_feed/service/date_time_service.dart';
import 'package:injectable/injectable.dart';

@midnightTest
@LazySingleton(as: DateTimeService)
class MidnightDateTimeService extends DateTimeService {
  final DateTime _createDateTime;

  MidnightDateTimeService() : _createDateTime = DateTime.now();

  @override
  DateTime get now {
    const timeToSettle = Duration(seconds: 2);
    final timeSinceCreate = DateTime.now().difference(_createDateTime);
    final midnightTonight = DateTime(_createDateTime.year, _createDateTime.month, _createDateTime.day + 1);
    return midnightTonight.add(timeSinceCreate).subtract(timeToSettle);
  }
}
