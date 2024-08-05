import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:clock/clock.dart';
import 'package:bible_feed/model/book.dart';
import 'package:bible_feed/model/feeds.dart';
import 'package:bible_feed/model/reading_list.dart';
import 'package:bible_feed/util/date.dart';
import 'package:bible_feed/util/store.dart';

void main() {
  late Book bk0, bk1, bk2;
  late Feeds fds;
  late ReadingList rl0, rl1;

  setUp(() async {
    SharedPreferences.setMockInitialValues({
      'rl0.book': 'bk0',
      'rl0.chapter': 1,
      'rl0.isChapterRead': true,
      'rl0.dateLastSaved': DateTime.now().toIso8601String(),
      'rl1.book': 'bk1',
      'rl1.chapter': 1,
      'rl1.isChapterRead': false,
      'rl1.dateLastSaved': DateTime.now().toIso8601String(),
      'hasEverAdvanced': false,
    });

    await Store.init();

    bk0 = const Book('bk0', 'Book0', 5);
    bk1 = const Book('bk1', 'Book1', 3);
    bk2 = const Book('bk2', 'Book2', 2);
    rl0 = ReadingList('rl0', 'Reading List 0', [bk0]);
    rl1 = ReadingList('rl1', 'Reading List 1', [bk1, bk2]);
    fds = Feeds([rl0, rl1]);
  });

  test('[]', () {
    expect(fds[0].readingList, rl0);
    expect(fds[1].readingList, rl1);
  });

  test('areChaptersRead', () {
    expect(fds.areChaptersRead, false);
    fds[1].toggleIsChapterRead();
    expect(fds.areChaptersRead, true);
  });

  group('hasEverAdvanced', () {
    test('should initialise from store', () {
      expect(fds.hasEverAdvanced, false);
    });

    test('should be stored true after advance', () {
      fds[1].toggleIsChapterRead();
      fds.forceAdvance();
      expect(Store.getBool('hasEverAdvanced'), true);
      expect(fds.hasEverAdvanced, true);
    });
  });

  group('Advance:', () {
    final tomorrow = Clock.fixed(DateTime.now().addDays(1));

    checkHasAdvanced(bool shouldAdvance) {
      expect(fds[0].chapter, shouldAdvance ? 2 : 1);
      expect(fds[1].chapter, shouldAdvance ? 2 : 1);
    }

    test('constructor should advance all feeds if new day', () {
      Store.setBool('rl1.isChapterRead', true);
      withClock(tomorrow, () => fds = Feeds([rl0, rl1]));
      checkHasAdvanced(true);
    });

    test('forceAdvance should advance all feeds', () {
      fds[1].toggleIsChapterRead();
      fds.forceAdvance();
      checkHasAdvanced(true);
    });

    group('maybeAdvance', () {
      test('if not all read on next day, should not advance', () {
        withClock(tomorrow, fds.maybeAdvance);
        checkHasAdvanced(false);
      });

      group('if all read and latest saved day is', () {
        run(String desc, int dayDiff, bool shouldAdvance) {
          test(desc, () {
            fds[1].toggleIsChapterRead();
            withClock(Clock.fixed(DateTime.now().addDays(dayDiff)), fds.maybeAdvance);
            checkHasAdvanced(shouldAdvance);
          });
        }
        run('today, should not advance', 0, false);
        run('yesterday, should advance', 1, true);
        run('a week ago, should advance', 7, true);
      });
    });
  });
}
