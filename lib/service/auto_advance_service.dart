import 'package:clock/clock.dart';
import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';
import 'dart:async';

import '/extension/object.dart';
import '/model/feeds.dart';

@singleton // cannot be lazy, else https://github.com/dart-lang/tools/issues/705 manifests in integration test
class AutoAdvanceService with ChangeNotifier {
  final Feeds feeds;

  AutoAdvanceService(this.feeds) {
    AppLifecycleListener(onResume: onResume);
    onResume();
  }

  Timer? _timer;

  void onResume() {
    feeds.maybeAdvance();
    _setTimer();
  }

  void _run() async {
    if (await feeds.maybeAdvance() == AdvanceState.listsAdvanced) notifyListeners();
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
