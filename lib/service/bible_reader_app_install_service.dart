import 'package:app_install_events/app_install_events.dart';
import 'package:flutter/foundation.dart';
import '/extension/object.dart';

// android only
class BibleReaderAppInstallService with ChangeNotifier {
  BibleReaderAppInstallService() {
    AppIUEvents().appEvents.listen((e) {
      e.log();
      notifyListeners();
    });
  }
}
