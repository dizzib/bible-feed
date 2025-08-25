import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';

import '/extension/object.dart';
import 'feeds_advance_service.dart';

@prod // disable log noise in unit tests
@singleton // cannot be lazy, else https://github.com/dart-lang/tools/issues/705 manifests in integration test
class AutoAdvanceService with ChangeNotifier {
  final FeedsAdvanceService _feedsAdvanceService;

  AutoAdvanceService(this._feedsAdvanceService) {
    AppLifecycleListener(onResume: onResume);
    onResume();
  }

  Timer? _timer;

  void onResume() {
    _feedsAdvanceService.maybeAdvance();
    _setTimer();
  }

  void _run() async {
    if (await _feedsAdvanceService.maybeAdvance() == AdvanceState.listsAdvanced) notifyListeners();
    _setTimer();
  }

  void _setTimer() {
    final midnightTonight = DateTime(clock.now().year, clock.now().month, clock.now().day + 1);
    final durationToMidnight = midnightTonight.difference(clock.now());
    _timer?.cancel();
    _timer = Timer(durationToMidnight, _run);
    'AutoAdvanceService: timer will fire in ${durationToMidnight.toString()}'.log();
  }
}
