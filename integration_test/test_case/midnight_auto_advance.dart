import 'package:bible_feed/manager/midnight_manager.dart';
import 'package:bible_feed/service/date_time_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:watch_it/watch_it.dart';

import '../helper.dart';
import '../injectable.dart';
import '../service/stub_date_time_service.dart';
import '../service/stub_midnight_manager.dart';

Future runMidnightAdvanceTest() async {
  testWidgets('auto advance at midnight', (t) async {
    await configureDependencies(environment: 'integration_test');

    final stubDateTimeService = sl<DateTimeService>() as StubDateTimeService;
    final stubMidnightManager = sl<MidnightManager>() as StubMidnightManager;

    await t.startApp();
    expectChapters(1);
    await t.tapAllLists();
    expectText('All done!');

    stubDateTimeService.advance1day();
    stubMidnightManager.notify();

    await t.pumpAndSettle(); // must wait for async code to run
    expectChapters(2);
    expectNoText('All done!');
  });
}
