import 'package:app_install_events/app_install_events.dart';
import 'package:flutter/foundation.dart';

// android only
class BibleReaderAppInstallService with ChangeNotifier {
  BibleReaderAppInstallService() {
    _appIUEvents.appEvents.listen((_) => notifyListeners());
  }

  final _appIUEvents = AppIUEvents();
}
