import 'package:app_install_events/app_install_events.dart';
import 'package:df_log/df_log.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '/injectable.env.dart';

abstract class PlatformEventService with ChangeNotifier {}

@midnightTest
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
