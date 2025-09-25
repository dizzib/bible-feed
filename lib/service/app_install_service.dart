import 'package:app_install_events/app_install_events.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '/service/bible_reader_launch_service.dart';
import '/service/bible_reader_link_service.dart';
import '/service/platform_service.dart';
import 'platform_event_service.dart';

abstract class AppInstallService with ChangeNotifier {}

@prod
@LazySingleton(as: AppInstallService)
class ProductionAppInstallService extends AppInstallService {
  ProductionAppInstallService(
    AppIUEvents appIUEvents,
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

@Environment('screenshot')
@LazySingleton(as: AppInstallService)
class ScreenshotAppInstallService extends AppInstallService {}
