import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch_it/watch_it.dart';
import 'package:bible_feed/model/feeds.dart';
import 'mock_reading_list.dart';
import 'mock_reading_lists.dart';

void main() async {
  late Feeds feeds;

  setUp(() async {
    SharedPreferences.setMockInitialValues({
      'l0.book': 'b0',
      'l0.chapter': 1,
      'l0.isChapterRead': true,
      'l0.dateModified': DateTime.now().toIso8601String(),
      'l1.book': 'b1',
      'l1.chapter': 1,
      'l1.isChapterRead': false,
      'l1.dateModified': DateTime.now().toIso8601String(),
      'hasEverAdvanced': false,
    });
    sl.pushNewScope();
    sl.registerSingleton(await SharedPreferences.getInstance());
    registerMockReadingLists();
    feeds = Feeds();
  });

  test('[]', () {
    expect(feeds[0].readingList, l0);
    expect(feeds[1].readingList, l1);
  });

  test('areChaptersRead', () {
    expect(feeds.areChaptersRead, false);
    feeds[1].toggleIsChapterRead();
    expect(feeds.areChaptersRead, true);
  });

  group('hasEverAdvanced', () {
    test('should initialise from store', () {
      expect(feeds.hasEverAdvanced, false);
    });

    test('should be stored true after advance', () async {
      feeds[1].toggleIsChapterRead();
      await feeds.forceAdvance();
      expect(sl<SharedPreferences>().getBool('hasEverAdvanced'), true);
      expect(feeds.hasEverAdvanced, true);
    });
  });

  group('Advance:', () {
    checkHasAdvanced(bool shouldAdvance) {
      expect(feeds[0].chapter, shouldAdvance ? 2 : 1);
      expect(feeds[1].chapter, shouldAdvance ? 2 : 1);
    }

    test('forceAdvance should advance all feeds', () async {
      feeds[1].toggleIsChapterRead();
      await feeds.forceAdvance();
      checkHasAdvanced(true);
    });

    final tomorrow = Clock.fixed(const Clock().daysFromNow(1));

    group('maybeAdvance', () {
      test('if not all read, on next day, should not advance', () async {
        expect(await withClock(tomorrow, feeds.maybeAdvance), AdvanceState.notAllRead);
        checkHasAdvanced(false);
      });

      group('if all read and latest saved day is', () {
        test('today, should not advance', () async {
          feeds[1].toggleIsChapterRead();
          expect(await feeds.maybeAdvance(), AdvanceState.allReadAwaitingTomorrow);
          checkHasAdvanced(false);
        });

        test('yesterday, should advance', () async {
          feeds[1].toggleIsChapterRead();
          expect(await withClock(tomorrow, feeds.maybeAdvance), AdvanceState.listsAdvanced);
          checkHasAdvanced(true);
        });

        test('1 week ago, should advance', () async {
          feeds[1].toggleIsChapterRead();
          final nextWeek = Clock.fixed(const Clock().weeksFromNow(1));
          expect(await withClock(nextWeek, feeds.maybeAdvance), AdvanceState.listsAdvanced);
          checkHasAdvanced(true);
        });
      });
    });

    test('reload should refresh from store updated in background', () async {
      sl<SharedPreferences>().setInt('l0.chapter', 2);
      expect(feeds[0].chapter, 1);
      feeds.reload();
      expect(feeds[0].chapter, 2);
    });
  });
}
