import 'package:clock/clock.dart';

extension DateHelper on DateTime {
  DateTime get date => DateTime(year, month, day);

  bool get isToday {
    final now = clock.now();
    return now.day == day && now.month == month && now.year == year;
  }
}
