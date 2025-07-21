import 'package:clock/clock.dart';
import 'package:cron/cron.dart';
import 'package:flutter/widgets.dart';
import 'package:watch_it/watch_it.dart';
import '/extension/object.dart';
import '/model/feeds.dart';

class AutoAdvanceService with ChangeNotifier {
  AutoAdvanceService() {
    AppLifecycleListener(onResume: sl<Feeds>().maybeAdvance);

    var schedule = Schedule(
      hours: '0', // at midnight
      minutes: '0', // in the 1st minute. BUG: sometimes seems to skip 00 seconds!?
      seconds: '*/5', // every 5 seconds, in an attempt to fix issue #1.
    );
    schedule.toCronString(hasSecond: true).log();

    Cron().schedule(schedule, () async {
      clock.now().log();
      if (await sl<Feeds>().maybeAdvance() == AdvanceState.listsAdvanced) notifyListeners();
    });

    sl<Feeds>().maybeAdvance();
  }
}
