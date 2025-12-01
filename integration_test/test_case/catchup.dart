import 'package:bible_feed/manager/catchup_setting_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:watch_it/watch_it.dart';

import '../injectable.dart';
import '_helper.dart';
import '_helper_catchup.dart';

Future runCatchupTest() async {
  testWidgets('catchup', (t) async {
    await configureDependencies(environment: 'integration_test');

    final catchupSettingManager = sl<CatchupSettingManager>();

    Future testSettingManager(bool value) async {
      catchupSettingManager.isEnabled = value;
      await t.pumpAndSettle();
      expectNotInteractiveByKey(catchupFabKey); // should reset when re-enabled
    }

    await t.startApp();
    await testSettingManager(true); // enable
    // on fresh install, should alert tomorrow if unread
    await t.advanceDay();
    await t.testCatchupPopup('1 day', 20, expectOnboarding: true);
    await t.setAllFeedsAsRead();
    await t.tapPopupAction(); // onboarding
    expectChapters(2);
    expectNotInteractiveByKey(catchupFabKey);
    await t.setAllFeedsAsRead();
    await t.tapAllDoneFab(); // onboarded, not behind
    await t.tapPopupAction();
    expectChapters(3);
    await t.advanceDay();
    expectNotInteractiveByKey(catchupFabKey);
    await t.advanceDay();
    await t.tapByKey('mat');
    await t.testCatchupPopup('1 day', 19);
    await t.advanceDay();
    await t.tapByKey('gen');
    await t.testCatchupPopup('2 days', 28);
    await t.setAllFeedsAsRead();
    await t.tapPopupAction(); // alldone should auto show
    expectChapters(4);
    await t.testCatchupPopup('1 day', 20);
    await t.setAllFeedsAsRead();
    await t.dismissPopup();
    await t.tapByKey('mat');
    await t.testCatchupPopup('1 day', 11);
    await t.setAllFeedsAsRead();
    await t.tapPopupAction();
    expectChapters(5);
    expectNotInteractiveByKey(catchupFabKey);
    // disable then enable setting should clear alert
    await t.advanceDay();
    await t.advanceDay();
    await t.testCatchupPopup('2 days', 30);
    await testSettingManager(false);
    await testSettingManager(true);
  });
}
