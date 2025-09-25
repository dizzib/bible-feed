import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '/service/bible_reader_launch_service.dart';
import '/service/bible_reader_link_service.dart';
import '/service/platform_service.dart';
import 'platform_event_service.dart';

@lazySingleton
class AppInstallService with ChangeNotifier {
  AppInstallService(
    BibleReaderLinkService bibleReaderService,
    BibleReaderLaunchService bibleReaderLaunchService,
    PlatformService platformService,
    PlatformEventService platformEventService,
  ) {
    if (platformService.isIOS) return; // ios cannot detect app (un)install events
    platformEventService.addListener(() async {
      if (await bibleReaderLaunchService.isAvailable(bibleReaderService.linkedBibleReader)) {
        notifyListeners();
        return;
      }
      bibleReaderService.unlinkBibleReader(); // the linked bible reader has been uninstalled
    });
  }
}
