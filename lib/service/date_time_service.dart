import 'package:injectable/injectable.dart';

import '../injectable.dart';

abstract class DateTimeService {
  DateTime get now;
}

@prod
@screenshot
@test
@LazySingleton(as: DateTimeService)
class NowDateTimeService extends DateTimeService {
  @override
  DateTime get now => DateTime.now();
}
