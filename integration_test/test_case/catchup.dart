import 'package:bible_feed/manager/catchup_manager.dart';
import 'package:bible_feed/manager/midnight_manager.dart';
import 'package:bible_feed/service/date_time_service.dart';
import 'package:df_log/df_log.dart';
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

    await t.startApp();
    expectChapters(1);

    stubDateTimeService.advance1day();
    stubMidnightManager.notify();

    await t.pumpAndSettle(); // must wait for async code to run

    final catchupManager = sl<CatchupManager>();
    Log.info(catchupManager.daysBehind);

    await t.tapCatchupFab();
  });
}
