import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../service/platform_event_service.dart';
import 'bible_reader_launch_manager.dart';
import 'bible_reader_link_manager.dart';

@lazySingleton
class AppInstallManager with ChangeNotifier {
  AppInstallManager(
    BibleReaderLaunchManager bibleReaderLaunchManager,
    BibleReaderLinkManager bibleReaderLinkManager,
    PlatformEventService platformEventService,
  ) {
    void handleAppInstallOrUninstall() async {
      if (await bibleReaderLaunchManager.isAvailable(bibleReaderLinkManager.linkedBibleReader)) {
        notifyListeners();
      } else {
        bibleReaderLinkManager.unlinkBibleReader(); // The linked bible reader has been uninstalled.
      }
    }

    platformEventService.addListener(handleAppInstallOrUninstall);
  }
}
