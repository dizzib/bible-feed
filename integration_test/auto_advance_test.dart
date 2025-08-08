import 'package:bible_feed/extension/object.dart';
import 'package:clock/clock.dart';
import 'package:dartx/dartx.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'helper.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  var now = DateTime.now();
  var midnightTonight = DateTime(now.year, now.month, now.day + 1);
  var durationToMidnight = midnightTonight.difference(now).log();
  var mockClock = Clock(() => DateTime.now() - const Duration(seconds: 2) + durationToMidnight);

  testWidgets('auto advance at midnight', (t) async {
    await withClock(mockClock, () async {
      await t.initialiseApp();
      expectChapters(1);
      await t.tapAllLists();
      await t.tapNo();
      await t.pump(const Duration(seconds: 2));
      expectChapters(2);
    });
  });
}
