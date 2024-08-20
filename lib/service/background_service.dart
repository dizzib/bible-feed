import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter/foundation.dart';
import 'package:watch_it/watch_it.dart';
import 'package:cron/cron.dart';
import '../data/reading_lists.dart';
import '../model/feeds.dart';
import '../util/log.dart';
import '../util/store.dart';

// https://stackoverflow.com/questions/74397262/flutter-background-service-onstart-method-must-be-a-top-level-or-static-functio
@pragma("vm:entry-point")
void onStart(ServiceInstance service) async {
  // this runs in its own isolate and cannot access memory from main() isolate,
  // therefore we must use a separate instance of Feeds
  await Store.init();
  var schedule = Schedule(
    minutes: '0',  // hourly
    // seconds: '*/5',  // every 5 seconds (for debugging)
  );
  schedule.toCronString(hasSecond: true).log();
  Cron().schedule(schedule, () async {
    await Store.reload();
    if (Feeds(readingLists).maybeAdvance() == AdvanceState.listsAdvanced) {
      // HACK: allow time for updates to asynchronously save in background, otherwise UI will update
      // before all changes are written.
      Future.delayed(const Duration(seconds: 2), () {
        'listsAdvanced'.log();
        service.invoke('listsAdvanced');
      });
    }
  });
}

class BackgroundService with ChangeNotifier {
  var service = FlutterBackgroundService();

  BackgroundService() {
    service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        isForegroundMode: false,
      ),
      iosConfiguration: IosConfiguration(
        onForeground: onStart,
      )
    );
    handleOnListsAdvanced();
  }

  void handleOnListsAdvanced() async {
    // when b/g service updates feeds, reload from Store so UI gets refreshed
    await for(var e in service.on('listsAdvanced')) {
      await Store.reload();
      di<Feeds>().reload();
    }
  }
}
