import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:cron/cron.dart';
import 'package:watch_it/watch_it.dart';
import '../model/feeds.dart';
import '../util/log.dart';

// https://stackoverflow.com/questions/74397262/flutter-background-service-onstart-method-must-be-a-top-level-or-static-functio
void onStart(ServiceInstance service) {
  'onStart'.log();
  Cron().schedule(
    Schedule.parse('* * * * *'), () async {
      'cron'.log();
      di<Feeds>().maybeAdvance();
    }
  );
}

class BackgroundService {
  final _service = FlutterBackgroundService();
  BackgroundService() {
    'BackgroundService'.log();
    _service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: true,
        isForegroundMode: false,
      ),
      iosConfiguration: IosConfiguration(
        autoStart: true,
        onForeground: onStart,
      )
    );
    _service.startService();
  }
}
