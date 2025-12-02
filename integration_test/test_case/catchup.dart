import 'package:bible_feed/manager/catchup_setting_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:watch_it/watch_it.dart';

import '../injectable.dart';
import '_helper.dart';
import '_helper_catchup.dart';

Future runCatchupTest() async {
  // beware, splitting this test causes strange issues with initialisation!?
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

    /// on fresh install, should alert tomorrow if unread
    await t.advanceDay();
    await t.testCatchupPopup('1 day', 20, isReset: true);
    await t.setAllFeedsAsRead();

    /// test fall behind then catch up
    await t.tapAdvanceNow();
    await t.advanceDay();
    expectNotInteractiveByKey(catchupFabKey);
    await t.advanceDay();
    await t.testCatchupPopup('1 day', 20);
    await t.tapByKey('mat');
    await t.tapByKey('gen');
    await t.advanceDay();
    await t.testCatchupPopup('2 days', 28);
    await t.setAllFeedsAsRead();
    await t.testAllDoneButStillBehindPopup(20);
    await t.setAllFeedsAsRead();
    await t.testAllDoneButStillBehindPopup(10);

    /// test disable then enable setting should clear alert
    await t.advanceDay();
    await t.testCatchupPopup('1 day', 20);
    await testSettingManager(false);
    await testSettingManager(true);
  });
}
