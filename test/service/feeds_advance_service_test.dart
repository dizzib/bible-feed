import 'package:bible_feed/model/feeds.dart';
import 'package:bible_feed/service/feeds_advance_service.dart';
import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch_it/watch_it.dart';

import '../injectable.dart';

void main() async {
  late FeedsAdvanceService fixture;
  late Feeds feeds;

  setUp(() async {
    await configureDependencies({
      'l0.book': 'b0',
      'l0.chapter': 1,
      'l0.dateModified': DateTime.now().toIso8601String(),
      'l0.isRead': true,
      'l1.book': 'b1',
      'l1.chapter': 1,
      'l1.dateModified': DateTime.now().toIso8601String(),
      'l1.isRead': false,
      'hasEverAdvanced': false,
    });
    fixture = sl<FeedsAdvanceService>();
    feeds = sl<Feeds>();
  });

  group('hasEverAdvanced', () {
    test('should initialise from store', () {
      expect(fixture.hasEverAdvanced, false);
    });

    test('should be stored true after advance', () async {
      feeds[1].toggleIsRead();
      await fixture.forceAdvance();
      expect(sl<SharedPreferences>().getBool('hasEverAdvanced'), true);
      expect(fixture.hasEverAdvanced, true);
    });
  });

  group('Advance:', () {
    checkHasAdvanced(bool shouldAdvance) {
      expect(feeds[0].state.chapter, shouldAdvance ? 2 : 1);
      expect(feeds[1].state.chapter, shouldAdvance ? 2 : 1);
    }

    test('forceAdvance should advance all feeds', () async {
      feeds[1].toggleIsRead();
      await fixture.forceAdvance();
      checkHasAdvanced(true);
    });

    final tomorrow = Clock.fixed(const Clock().daysFromNow(1));

    group('maybeAdvance', () {
      test('if not all read, on next day, should not advance', () async {
        expect(await withClock(tomorrow, fixture.maybeAdvance), AdvanceState.notAllRead);
        checkHasAdvanced(false);
      });

      group('if all read and latest saved day is', () {
        test('today, should not advance', () async {
          feeds[1].toggleIsRead();
          expect(await fixture.maybeAdvance(), AdvanceState.allReadAwaitingTomorrow);
          checkHasAdvanced(false);
        });

        test('yesterday, should advance', () async {
          feeds[1].toggleIsRead();
          expect(await withClock(tomorrow, fixture.maybeAdvance), AdvanceState.listsAdvanced);
          checkHasAdvanced(true);
        });

        test('1 week ago, should advance', () async {
          feeds[1].toggleIsRead();
          final nextWeek = Clock.fixed(const Clock().weeksFromNow(1));
          expect(await withClock(nextWeek, fixture.maybeAdvance), AdvanceState.listsAdvanced);
          checkHasAdvanced(true);
        });
      });
    });
  });
}
