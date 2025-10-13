import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';

import '../service/date_time_service.dart';
import 'feeds_advance_manager.dart';
import 'feeds_advance_state.dart';

@singleton
class AutoAdvanceManager with ChangeNotifier {
  final DateTimeService _dateTimeService;
  final FeedsAdvanceManager _feedsAdvanceManager;

  AutoAdvanceManager(this._dateTimeService, this._feedsAdvanceManager) {
    AppLifecycleListener(onResume: _onResume);
    _onResume();
  }

  Timer? _timer;

  void _onResume() {
    _feedsAdvanceManager.maybeAdvance();
    _setTimer();
  }

  void _run() async {
    if (await _feedsAdvanceManager.maybeAdvance() == FeedsAdvanceState.listsAdvanced) notifyListeners();
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
