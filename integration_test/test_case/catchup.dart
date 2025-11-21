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

    final stubDateTimeService = sl<DateTimeService>() as StubDateTimeService;
    final stubMidnightManager = sl<MidnightManager>() as StubMidnightManager;

    Future advanceDay() async {
      stubDateTimeService.advance1day();
      stubMidnightManager.notify();
      await t.pumpAndSettle(); // must wait for async code to run
    }

    Future openDialogAndTest(String daysBehind, int expectChaptersToRead) async {
      await t.tapByKey('catchup_fab');
      await t.pumpAndSettle();
      expectText('Catchup');
      expectText('$daysBehind behind');
      expectText('$expectChaptersToRead more');
      await t.tap(find.text('Close'));
      await t.pumpAndSettle();
    }

    await t.startApp();
    await advanceDay();
    await openDialogAndTest('1 days', 20);
    await advanceDay();
    await openDialogAndTest('2 days', 30);
    await t.tapAllLists();
    await t.tapYes();
    expectChapters(2);
    await openDialogAndTest('1 days', 20);
    await t.tapAllLists();
    await t.tapAllDoneFab();
    await t.tapYes();
    expectChapters(3);
    expectNotInteractiveByKey('catchup_fab');
  });
}
