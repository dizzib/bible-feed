import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:clock/clock.dart';
import 'package:bible_feed/model/book.dart';
import 'package:bible_feed/model/feed.dart';
import 'package:bible_feed/model/feeds.dart';
import 'package:bible_feed/model/reading_list.dart';
import 'package:bible_feed/util/date.dart';
import 'package:bible_feed/util/store.dart';

void main() {
  var b0 = const Book('b0', 'Book0', 5);
  var b1 = const Book('b1', 'Book1', 3);
  var b2 = const Book('b2', 'Book2', 2);
  var l0 = ReadingList('l0', 'Reading List 0', [b0]);
  var l1 = ReadingList('l1', 'Reading List 1', [b1, b2]);

  late Feed f0, f1;
  late Feeds fds;

  void initFeeds() {
    fds = Feeds([l0, l1]);
    f0 = fds[0];
    f1 = fds[1];
  }

  setUp(() async {
    SharedPreferences.setMockInitialValues({
      'l0.book': 'b0',
      'l0.chapter': 1,
      'l0.isChapterRead': true,
      'l0.dateLastSaved': DateTime.now().toIso8601String(),
      'l1.book': 'b1',
      'l1.chapter': 1,
      'l1.isChapterRead': false,
      'l1.dateLastSaved': DateTime.now().toIso8601String(),
      'hasEverAdvanced': false,
    });

    await Store.init();
    initFeeds();
  });

  test('[]', () {
    expect(f0.readingList, l0);
    expect(f1.readingList, l1);
  });

  test('areChaptersRead', () {
    expect(fds.areChaptersRead, false);
    f1.toggleIsChapterRead();
    expect(fds.areChaptersRead, true);
  });

  group('hasEverAdvanced', () {
    test('should initialise from store', () {
      expect(fds.hasEverAdvanced, false);
    });

    test('should be stored true after advance', () {
      f1.toggleIsChapterRead();
      fds.forceAdvance();
      expect(Store.getBool('hasEverAdvanced'), true);
      expect(fds.hasEverAdvanced, true);
    });
  });

  group('Advance:', () {
    final tomorrow = Clock.fixed(DateTime.now().addDays(1));

    checkHasAdvanced(bool shouldAdvance) {
      expect(f0.chapter, shouldAdvance ? 2 : 1);
      expect(f1.chapter, shouldAdvance ? 2 : 1);
    }

    test('constructor should advance all feeds if new day', () {
      f1.toggleIsChapterRead();
      withClock(tomorrow, initFeeds);
      checkHasAdvanced(true);
    });

    test('forceAdvance should advance all feeds', () {
      f1.toggleIsChapterRead();
      fds.forceAdvance();
      checkHasAdvanced(true);
    });

    group('maybeAdvance', () {
      test('if not all read, on next day, should not advance', () {
        withClock(tomorrow, fds.maybeAdvance);
        checkHasAdvanced(false);
      });

      group('if all read and latest saved day is', () {
        test('today, should not advance', () {
          f1.toggleIsChapterRead();
          fds.maybeAdvance();
          checkHasAdvanced(false);
        });

        test('yesterday, should advance', () {
          f1.toggleIsChapterRead();
          withClock(tomorrow, fds.maybeAdvance);
          checkHasAdvanced(true);
        });

        test('7 days ago, should advance', () {
          f1.toggleIsChapterRead();
          withClock(Clock.fixed(DateTime.now().addDays(7)), fds.maybeAdvance);
          checkHasAdvanced(true);
        });
      });
    });
  });
}
