import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';

import '../injectable.env.dart';
import '../service/date_time_service.dart';

abstract class MidnightManager with ChangeNotifier {}

// Using @lazysingleton breaks golden tests...
//
// The following assertion was thrown running a test:
// A Timer is still pending even after the widget tree was disposed.
// 'package:flutter_test/src/binding.dart':
// Failed assertion: line 1617 pos 12: '!timersPending'
//
@golden
@prod
@Singleton(as: MidnightManager)
class ProdMidnightManager extends MidnightManager {
  final DateTimeService _dateTimeService;

  ProdMidnightManager(this._dateTimeService) {
    AppLifecycleListener(onResume: _setTimer);
    _setTimer();
  }

  Timer? _timer;

  void _run() {
    notifyListeners();
    _setTimer();
  }

  void _setTimer() {
    final now = _dateTimeService.now;
    final midnightTonight = DateTime(now.year, now.month, now.day + 1);
    final durationToMidnight = midnightTonight.difference(now);
    _timer?.cancel();
    _timer = Timer(durationToMidnight, _run);
    // Log.info('$now. Timer will fire in ${durationToMidnight.toString()}');
  }
}
