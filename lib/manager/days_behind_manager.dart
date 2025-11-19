import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../service/date_time_service.dart';
import 'feeds_advance_manager.dart';

@lazySingleton
class DaysBehindManager with ChangeNotifier {
  final DateTimeService _dateTimeService;
  final FeedsAdvanceManager _feedsAdvanceManager;

  DaysBehindManager(this._dateTimeService, this._feedsAdvanceManager);

  int get daysBehind {
    final now = _dateTimeService.now;
    final lastAdvance = _feedsAdvanceManager.lastAdvanceDate;
    if (lastAdvance == null) return 0;
    final midnightYesterday = DateTime(now.year, now.month, now.day);
    final midnightLastAdvance = DateTime(lastAdvance.year, lastAdvance.month, lastAdvance.day);
    return midnightYesterday.difference(midnightLastAdvance).inDays;
  }
}
