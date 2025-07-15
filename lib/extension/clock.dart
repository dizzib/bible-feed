import 'package:clock/clock.dart';
import 'date.dart';

extension ClockHelper on Clock {
  Clock get tomorrow => addDays(1);

  Clock addDays(int days) => Clock.fixed(clock.now().addDays(days));
}
