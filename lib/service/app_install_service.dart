import 'dart:io';

import 'package:app_install_events/app_install_events.dart';
import 'package:df_log/df_log.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AppInstallService with ChangeNotifier {
  AppInstallService() {
    // ios is not supported
    if (Platform.isAndroid) {
      AppIUEvents().appEvents.listen((event) {
        Log.info(event);
        notifyListeners();
      });
    }
  }
}
