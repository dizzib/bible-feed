import 'package:clock/clock.dart';
import 'package:dartx/dartx.dart';
import 'package:df_log/df_log.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helper.dart';

void main() {
  var now = DateTime.now();
  var midnightTonight = DateTime(now.year, now.month, now.day + 1);
  var durationToMidnight = midnightTonight.difference(now);
  var mockClock = Clock(() => DateTime.now() - const Duration(seconds: 2) + durationToMidnight);

  Log.info('Time to midnight is $durationToMidnight');

  testWidgets('auto advance at midnight', (t) async {
    await withClock(mockClock, () async {
      await t.initialiseApp();
      expectChapters(1);
      await t.tapAllLists();
      expectText('All done!');
      await t.pumpAndSettle(const Duration(seconds: 2));
      expectChapters(2);
      expectNoText('All done!');
    });
  });
}
