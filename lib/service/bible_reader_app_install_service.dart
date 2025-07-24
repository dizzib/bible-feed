import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:app_install_events/app_install_events.dart';
import '/extension/object.dart';

class BibleReaderAppInstallService with ChangeNotifier {
  BibleReaderAppInstallService() {
    // ios is not supported
    if (Platform.isAndroid) {
      AppIUEvents().appEvents.listen((e) {
        e.log();
        notifyListeners();
      });
    }
  }
}
