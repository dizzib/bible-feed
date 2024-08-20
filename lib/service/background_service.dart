import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:cron/cron.dart';
import 'package:watch_it/watch_it.dart';
import '../model/feeds.dart';
import '../util/log.dart';

// https://stackoverflow.com/questions/74397262/flutter-background-service-onstart-method-must-be-a-top-level-or-static-functio
void onStart(ServiceInstance service) {
  Cron().schedule(
    Schedule.parse('0 * * * *'), () async {
      'cron'.log();
      di<Feeds>().maybeAdvance();
    }
  );
}

class BackgroundService {
  BackgroundService() {
    FlutterBackgroundService()..configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        isForegroundMode: false,
      ),
      iosConfiguration: IosConfiguration(
        onForeground: onStart,
      )
    )..startService();
  }
}
