import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../service/platform_event_service.dart';
import 'bible_reader_launch_service.dart';
import 'bible_reader_link_service.dart';

@lazySingleton
class AppInstallService with ChangeNotifier {
  AppInstallService(
    BibleReaderLaunchService bibleReaderLaunchService,
    BibleReaderLinkService bibleReaderLinkService,
    PlatformEventService platformEventService,
  ) {
    void handleAppInstallOrUninstall() async {
      if (await bibleReaderLaunchService.isAvailable(bibleReaderLinkService.linkedBibleReader)) {
        notifyListeners();
      } else {
        bibleReaderLinkService.unlinkBibleReader(); // The linked bible reader has been uninstalled.
      }
    }

    platformEventService.addListener(handleAppInstallOrUninstall);
  }
}
