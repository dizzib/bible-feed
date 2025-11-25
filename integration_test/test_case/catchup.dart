import 'package:bible_feed/manager/catchup_setting_manager.dart';
import 'package:bible_feed/manager/midnight_manager.dart';
import 'package:bible_feed/service/date_time_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:watch_it/watch_it.dart';

import '../helper.dart';
import '../injectable.dart';
import '../manager/stub_midnight_manager.dart';
import '../service/stub_date_time_service.dart';

Future runCatchupTest() async {
  testWidgets('catchup', (t) async {
    await configureDependencies(environment: 'integration_test');

    final fabKey = 'catchup_fab';
    final catchupSettingManager = sl<CatchupSettingManager>();
    final stubDateTimeService = sl<DateTimeService>() as StubDateTimeService;
    final stubMidnightManager = sl<MidnightManager>() as StubMidnightManager;

    Future advanceDay() async {
      stubDateTimeService.advance1day();
      stubMidnightManager.notify();
      await t.pumpAndSettle(); // must wait for async code to run
    }

    Future testCatchupDialog(String daysBehind, int expectChaptersToRead, {expectOnboarding = false}) async {
      if (!expectOnboarding) {
        await t.tapByKey(fabKey);
        await t.pumpAndSettle();
      }
      expectText('Catchup');
      expectText('$daysBehind behind');
      expectText('$expectChaptersToRead chapters');
      await t.tap(find.text('Close'));
      await t.pumpAndSettle();
    }

    Future testSettingManager(bool value) async {
      catchupSettingManager.isEnabled = value;
      await t.pumpAndSettle();
      expectNotInteractiveByKey(fabKey); // should reset when re-enabled
    }

    await t.startApp();
    await testSettingManager(true); // enable
    // on fresh install, should alert tomorrow if unread
    await advanceDay();
    await testCatchupDialog('1 day', 20, expectOnboarding: true);
    await t.setAllFeedsAsRead();
    await t.tapYes();
    expectChapters(2);
    expectNotInteractiveByKey(fabKey);
    await t.setAllFeedsAsRead();
    await t.tapAllDoneFab();
    await t.tapYes();
    expectChapters(3);
    await advanceDay();
    expectNotInteractiveByKey(fabKey);
    await advanceDay();
    await t.tapByKey('mat');
    await testCatchupDialog('1 day', 19);
    await advanceDay();
    await t.tapByKey('gen');
    await testCatchupDialog('2 days', 28);
    await t.setAllFeedsAsRead();
    await t.tapAllDoneFab();
    await t.tapYes();
    expectChapters(4);
    await testCatchupDialog('1 day', 20);
    await t.setAllFeedsAsRead();
    await t.tapByKey('mat');
    await testCatchupDialog('1 day', 11);
    await t.setAllFeedsAsRead();
    await t.tapAllDoneFab();
    await t.tapYes();
    expectChapters(5);
    expectNotInteractiveByKey(fabKey);
    // disable then enable setting should clear alert
    await advanceDay();
    await advanceDay();
    await testCatchupDialog('2 days', 30);
    await testSettingManager(false);
    await testSettingManager(true);
  });
}
