import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:cron/cron.dart';
import '../data/reading_lists.dart';
import '../model/feeds.dart';
import '../util/log.dart';
import '../util/store.dart';

// https://stackoverflow.com/questions/74397262/flutter-background-service-onstart-method-must-be-a-top-level-or-static-functio
@pragma("vm:entry-point")
void onStart(_) async {
  // this runs in its own isolate and cannot access memory from main() isolate,
  // therefore we must use a new instance of Feeds
  await Store.init();
  var schedule = Schedule(
    minutes: '0',  // hourly
    // seconds: '*/5',  // every 5 seconds (for debugging)
  );
  schedule.toCronString(hasSecond: true).log();
  Cron().schedule(schedule, () async {
    await Store.reload();
    Feeds(readingLists);  // implicity call maybeAdvance()
  });
}

class BackgroundService {
  BackgroundService() {
    FlutterBackgroundService().configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        isForegroundMode: false,
      ),
      iosConfiguration: IosConfiguration(
        onForeground: onStart,
      )
    );
  }
}
