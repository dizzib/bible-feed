import 'package:clock/clock.dart';
import 'datetime.dart';

extension ClockHelper on Clock {
  Clock get tomorrow => addDays(1);

  Clock addDays(int days) => Clock.fixed(clock.now().addDays(days));
}
