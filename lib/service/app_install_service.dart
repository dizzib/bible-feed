import 'package:app_install_events/app_install_events.dart';
import 'package:flutter/foundation.dart';

// android only
class AppInstallService with ChangeNotifier {
  AppInstallService() {
    _appIUEvents.appEvents.listen((_) => notifyListeners());
  }

  final _appIUEvents = AppIUEvents();
}
