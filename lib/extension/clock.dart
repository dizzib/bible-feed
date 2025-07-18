import 'package:dartx/dartx.dart';
import 'package:clock/clock.dart';

extension ClockHelper on Clock {
  Clock get tomorrow => addDays(1);
  Clock addDays(int days) => Clock.fixed(clock.now() + Duration(days: days));
}
