import 'package:bible_feed/model/feeds.dart';
import 'package:bible_feed/service/feeds_advance_service.dart';
import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch_it/watch_it.dart';

import '../injectable.dart';

void main() async {
  late FeedsAdvanceService testee;
  late Feeds feeds;

  setUp(() async {
    await configureDependencies({
      'rl0.book': 'b0',
      'rl0.chapter': 1,
      'rl0.dateModified': DateTime.now().toIso8601String(),
      'rl0.isRead': true,
      'rl1.book': 'b1',
      'rl1.chapter': 1,
      'rl1.dateModified': DateTime.now().toIso8601String(),
      'rl1.isRead': false,
      'hasEverAdvanced': false,
    });
    testee = sl<FeedsAdvanceService>();
    feeds = sl<Feeds>();
  });

  group('hasEverAdvanced', () {
    test('should initialise from store', () {
      expect(testee.hasEverAdvanced, false);
    });

    test('should be stored true after advance', () async {
      feeds[1].toggleIsRead();
      await testee.forceAdvance();
      expect(sl<SharedPreferences>().getBool('hasEverAdvanced'), true);
      expect(testee.hasEverAdvanced, true);
    });
  });

  group('Advance:', () {
    checkHasAdvanced(bool shouldAdvance) {
      expect(feeds[0].state.chapter, 1);
      expect(feeds[1].state.chapter, shouldAdvance ? 2 : 1);
    }

    test('forceAdvance should advance all feeds', () async {
      feeds[1].toggleIsRead();
      await testee.forceAdvance();
      checkHasAdvanced(true);
    });

    final tomorrow = Clock.fixed(const Clock().daysFromNow(1));

    group('maybeAdvance', () {
      test('if not all read, on next day, should not advance', () async {
        expect(await withClock(tomorrow, testee.maybeAdvance), AdvanceState.notAllRead);
        checkHasAdvanced(false);
      });

      group('if all read and latest saved day is', () {
        test('today, should not advance', () async {
          feeds[1].toggleIsRead();
          expect(await testee.maybeAdvance(), AdvanceState.allReadAwaitingTomorrow);
          checkHasAdvanced(false);
        });

        test('yesterday, should advance', () async {
          feeds[1].toggleIsRead();
          expect(await withClock(tomorrow, testee.maybeAdvance), AdvanceState.listsAdvanced);
          checkHasAdvanced(true);
        });

        test('1 week ago, should advance', () async {
          feeds[1].toggleIsRead();
          final nextWeek = Clock.fixed(const Clock().weeksFromNow(1));
          expect(await withClock(nextWeek, testee.maybeAdvance), AdvanceState.listsAdvanced);
          checkHasAdvanced(true);
        });
      });
    });
  });
}
