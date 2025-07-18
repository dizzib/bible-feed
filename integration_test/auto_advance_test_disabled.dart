import 'package:dartx/dartx.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clock/clock.dart';
import 'package:bible_feed/extension/object.dart';
import 'helper.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  var now = DateTime.now();
  var midnightTonight = DateTime(now.year, now.month, now.day + 1);
  var durationToTonight = midnightTonight.difference(now).log();
  var mockClock = Clock(() => DateTime.now() - const Duration(seconds: 5) + durationToTonight);

  testWidgets('auto advance at midnight', (t) async {
    await withClock(mockClock, () async {
      await t.initialiseApp();
      expectChapters(1);
      await t.tapAllLists();
      await t.tapNo();
      // the following should auto-advance but does not, probably because mockClock does not
      // reach the isolate where cron is running. This failing test is disabled for now.
      await t.pump(const Duration(seconds: 7));
      expectChapters(2);
    });
  });
}
