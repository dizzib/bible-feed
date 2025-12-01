import 'package:bible_feed/manager/catchup_setting_manager.dart';
import 'package:bible_feed/manager/midnight_manager.dart';
import 'package:bible_feed/service/date_time_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:watch_it/watch_it.dart';

import '_helper.dart';
import '../injectable.dart';
import '../manager/stub_midnight_manager.dart';
import '../service/stub_date_time_service.dart';

Future runCatchupTest() async {
  testWidgets('catchup', (t) async {
    await configureDependencies(environment: 'integration_test');

    final catchupFabKey = 'catchup_fab';
    final catchupSettingManager = sl<CatchupSettingManager>();
    final stubDateTimeService = sl<DateTimeService>() as StubDateTimeService;
    final stubMidnightManager = sl<MidnightManager>() as StubMidnightManager;

    Future advanceDay() async {
      stubDateTimeService.advance1day();
      stubMidnightManager.notify();
      await t.pumpAndSettle(); // must wait for async code to run
    }

    Future testCatchupPopup(String daysBehind, int expectChaptersToRead, {expectOnboarding = false}) async {
      if (!expectOnboarding) {
        await t.tapByKey(catchupFabKey);
      }
      expectText('$daysBehind behind');
      expectText('$expectChaptersToRead chapters');
      await t.dismissPopup();
    }

    Future testSettingManager(bool value) async {
      catchupSettingManager.isEnabled = value;
      await t.pumpAndSettle();
      expectNotInteractiveByKey(catchupFabKey); // should reset when re-enabled
    }

    await t.startApp();
    await testSettingManager(true); // enable
    // on fresh install, should alert tomorrow if unread
    await advanceDay();
    await testCatchupPopup('1 day', 20, expectOnboarding: true);
    await t.setAllFeedsAsRead();
    await t.tapPopupAction(); // onboarding
    expectChapters(2);
    expectNotInteractiveByKey(catchupFabKey);
    await t.setAllFeedsAsRead();
    await t.tapAllDoneFab(); // onboarded, not behind
    await t.tapPopupAction();
    expectChapters(3);
    await advanceDay();
    expectNotInteractiveByKey(catchupFabKey);
    await advanceDay();
    await t.tapByKey('mat');
    await testCatchupPopup('1 day', 19);
    await advanceDay();
    await t.tapByKey('gen');
    await testCatchupPopup('2 days', 28);
    await t.setAllFeedsAsRead();
    await t.tapPopupAction(); // alldone should auto show
    expectChapters(4);
    await testCatchupPopup('1 day', 20);
    await t.setAllFeedsAsRead();
    await t.dismissPopup();
    await t.tapByKey('mat');
    await testCatchupPopup('1 day', 11);
    await t.setAllFeedsAsRead();
    await t.tapPopupAction();
    expectChapters(5);
    expectNotInteractiveByKey(catchupFabKey);
    // disable then enable setting should clear alert
    await advanceDay();
    await advanceDay();
    await testCatchupPopup('2 days', 30);
    await testSettingManager(false);
    await testSettingManager(true);
  });
}
