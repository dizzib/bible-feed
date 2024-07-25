import 'package:clock/clock.dart';

extension DateHelper on DateTime {
  bool get isToday {
    final now = clock.now();
    return now.day == day && now.month == month && now.year == year;
  }
}
