import 'package:bible_feed/manager/catchup_setting_manager.dart';
import 'package:bible_feed/manager/midnight_manager.dart';
import 'package:bible_feed/service/date_time_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:watch_it/watch_it.dart';

import '../manager/stub_midnight_manager.dart';
import '../service/stub_date_time_service.dart';
import '_helper.dart';

final catchupFabKey = 'catchup_fab';
final catchupSettingManager = sl<CatchupSettingManager>();
final stubDateTimeService = sl<DateTimeService>() as StubDateTimeService;
final stubMidnightManager = sl<MidnightManager>() as StubMidnightManager;

extension CatchupTestHelper on WidgetTester {
  Future advanceDay() async {
    stubDateTimeService.advance1day();
    stubMidnightManager.notify();
    await pumpAndSettle(); // must wait for async code to run
  }

  Future testAllDoneButStillBehindPopup(int expectChaptersToRead) async {
    expectText('$expectChaptersToRead more chapters');
    await tapAdvanceNow();
  }

  Future testCatchupPopup(String daysBehind, int expectChaptersToRead, {bool isReset = false}) async {
    expectText('$daysBehind behind');
    expectText('$expectChaptersToRead chapters');
    if (isReset) {
      await tapCatchupReset();
      expectNoText('$daysBehind behind');
      expectNotInteractiveByKey(catchupFabKey);
    } else {
      await dismissPopup();
    }
  }

  Future testSettingManager(bool value) async {
    catchupSettingManager.isEnabled = value;
    await pumpAndSettle();
    expectNotInteractiveByKey(catchupFabKey); // should reset when re-enabled
  }
}
