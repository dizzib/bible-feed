import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';

import 'date_time_service.dart';
import 'feeds_advance_service.dart';
import 'feeds_advance_state.dart';

@singleton
class AutoAdvanceService with ChangeNotifier {
  final DateTimeService _dateTimeService;
  final FeedsAdvanceService _feedsAdvanceService;

  AutoAdvanceService(this._dateTimeService, this._feedsAdvanceService) {
    AppLifecycleListener(onResume: _onResume);
    _onResume();
  }

  Timer? _timer;

  void _onResume() {
    _feedsAdvanceService.maybeAdvance();
    _setTimer();
  }

  void _run() async {
    if (await _feedsAdvanceService.maybeAdvance() == FeedsAdvanceState.listsAdvanced) notifyListeners();
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
