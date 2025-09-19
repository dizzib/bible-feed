import 'dart:io';

import 'package:app_install_events/app_install_events.dart';
import 'package:df_log/df_log.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import 'bible_reader_service.dart';

@lazySingleton
class AppInstallService with ChangeNotifier {
  AppInstallService(BibleReaderService bibleReaderService) {
    if (Platform.isIOS) return; // ios cannot detect app (un)install events
    AppIUEvents().appEvents.listen((event) async {
      Log.info(event);
      if (await bibleReaderService.linkedBibleReader.isAvailable()) {
        notifyListeners();
        return;
      }
      bibleReaderService.linkedBibleReaderIndex = 0; // the linked bible reader has been uninstalled
    });
  }
}
