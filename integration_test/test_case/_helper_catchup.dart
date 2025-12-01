import 'package:bible_feed/manager/midnight_manager.dart';
import 'package:bible_feed/service/date_time_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:watch_it/watch_it.dart';

import '../manager/stub_midnight_manager.dart';
import '../service/stub_date_time_service.dart';
import '_helper.dart';

final catchupFabKey = 'catchup_fab';
final stubDateTimeService = sl<DateTimeService>() as StubDateTimeService;
final stubMidnightManager = sl<MidnightManager>() as StubMidnightManager;

extension CatchupTestHelper on WidgetTester {
  Future advanceDay() async {
    stubDateTimeService.advance1day();
    stubMidnightManager.notify();
    await pumpAndSettle(); // must wait for async code to run
  }

  Future testCatchupPopup(String daysBehind, int expectChaptersToRead, {expectOnboarding = false}) async {
    if (!expectOnboarding) {
      await tapByKey(catchupFabKey);
    }
    expectText('$daysBehind behind');
    expectText('$expectChaptersToRead chapters');
    await dismissPopup();
  }
}
