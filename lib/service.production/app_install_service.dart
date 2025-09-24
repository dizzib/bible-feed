import 'package:app_install_events/app_install_events.dart';
import 'package:df_log/df_log.dart';
import 'package:injectable/injectable.dart';

import '/service/app_install_service.dart' as base;
import '../service/bible_reader_launch_service.dart';
import '../service/bible_reader_link_service.dart';
import 'platform_service.dart';

@prod
@LazySingleton(as: base.AppInstallService)
class AppInstallService extends base.AppInstallService {
  AppInstallService(
    BibleReaderLinkService bibleReaderService,
    BibleReaderLaunchService bibleReaderLaunchService,
    PlatformService platformService,
  ) {
    if (platformService.isIOS) return; // ios cannot detect app (un)install events
    AppIUEvents().appEvents.listen((event) async {
      Log.info(event);
      if (await bibleReaderLaunchService.isAvailable(bibleReaderService.linkedBibleReader)) {
        notifyListeners();
        return;
      }
      bibleReaderService.unlinkBibleReader(); // the linked bible reader has been uninstalled
    });
  }
}
