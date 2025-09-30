import 'package:app_install_events/app_install_events.dart';
import 'package:df_log/df_log.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../injectable.dart';

abstract class PlatformEventService with ChangeNotifier {}

@integrationTest
@prod
@LazySingleton(as: PlatformEventService)
class ProductionPlatformEventService extends PlatformEventService {
  ProductionPlatformEventService() {
    AppIUEvents().appEvents.listen((event) {
      Log.info(event);
      notifyListeners();
    });
  }
}

@screenshot
@LazySingleton(as: PlatformEventService)
class ScreenshotPlatformEventService extends PlatformEventService {}
