import 'package:clock/clock.dart';

extension DateHelper on DateTime {
  DateTime get date => DateTime(year, month, day);

  DateTime addDays(int days) => add(Duration(days: days));

  bool get isToday {
    final now = clock.now();
    return now.day == day && now.month == month && now.year == year;
  }
}
