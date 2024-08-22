import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:watch_it/watch_it.dart';
import 'package:cron/cron.dart';
import '../data/reading_lists.dart';
import '../model/feeds.dart';
import '../util/log.dart';
import '../util/store.dart';

// https://stackoverflow.com/questions/74397262/flutter-background-service-onstart-method-must-be-a-top-level-or-static-functio
@pragma("vm:entry-point")
void onStart(ServiceInstance service) async {
  await Store.init();
  var schedule = Schedule(
    hours: '0',  // at midnight
    minutes: '0',  // in the 1st minute. BUG: sometimes seems to skip 00 seconds!?
    seconds: '*/5',  // every 5 seconds, in an attempt to fix issue #1.
  );
  schedule.toCronString(hasSecond: true).log();
  Cron().schedule(schedule, () async {
    // this runs in its own isolate and cannot access memory from main() isolate,
    // therefore we must use a new instance of Feeds
    await Store.reload();
    var result = await Feeds(readingLists).maybeAdvance();
    service.invoke(result.toString());
  });
}

class BackgroundService {
  var service = FlutterBackgroundService();

  BackgroundService() {
    service.configure(
      androidConfiguration: AndroidConfiguration(onStart: onStart, isForegroundMode: false),
      iosConfiguration: IosConfiguration(onForeground: onStart,)
    );
    handleOnListsAdvanced();
  }

  void handleOnListsAdvanced() async {
    // when b/g service updates feeds, reload from Store so UI gets refreshed
    await for(var _ in service.on(AdvanceState.listsAdvanced.toString())) {
      await Store.reload();
      di<Feeds>().reload();
    }
  }
}
