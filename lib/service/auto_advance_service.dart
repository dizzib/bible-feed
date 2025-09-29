import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';

import 'feed_advance_state.dart';
import 'feeds_advance_service.dart';

@singleton // Cannot be lazy, else https://github.com/dart-lang/tools/issues/705 manifests in integration test.
class AutoAdvanceService with ChangeNotifier {
  final FeedsAdvanceService _feedsAdvanceService;

  AutoAdvanceService(this._feedsAdvanceService) {
    AppLifecycleListener(onResume: _onResume);
    _onResume();
  }

  Timer? _timer;

  void _onResume() {
    _feedsAdvanceService.maybeAdvance();
    _setTimer();
  }

  void _run() async {
    if (await _feedsAdvanceService.maybeAdvance() == FeedAdvanceState.listsAdvanced) notifyListeners();
    _setTimer();
  }

  void _setTimer() {
    final now = clock.now(); // Use clock (not DateTime) for tests.
    final midnightTonight = DateTime(now.year, now.month, now.day + 1);
    final durationToMidnight = midnightTonight.difference(now);
    _timer?.cancel();
    _timer = Timer(durationToMidnight, _run);
    // 'AutoAdvanceService: timer will fire in ${durationToMidnight.toString()}'.log();
  }
}
