import 'package:injectable/injectable.dart';

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
