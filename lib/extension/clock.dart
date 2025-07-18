import 'package:dartx/dartx.dart';
import 'package:clock/clock.dart';

extension ClockHelper on Clock {
  Clock addDays(int days) => Clock.fixed(clock.now() + Duration(days: days));
}
