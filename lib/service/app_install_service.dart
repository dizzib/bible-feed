import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '/service/bible_reader_launch_service.dart';
import '/service/bible_reader_link_service.dart';
import '/service/platform_service.dart';
import 'platform_event_service.dart';

@lazySingleton
class AppInstallService with ChangeNotifier {
  AppInstallService(
    BibleReaderLaunchService bibleReaderLaunchService,
    BibleReaderLinkService bibleReaderLinkService,
    PlatformEventService platformEventService,
    PlatformService platformService,
  ) {
    if (platformService.isIOS) return; // IOS cannot detect app (un)install events.

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
