import 'package:clock/clock.dart';

extension DateHelper on DateTime {
  bool get isToday {
    final now = clock.now(); // use clock (not DateTime) for unit testing
    return now.day == day && now.month == month && now.year == year;
  }
}
