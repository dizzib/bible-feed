import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:clock/clock.dart';
import 'package:bible_feed/data/store.dart';
import 'package:bible_feed/model/book.dart';
import 'package:bible_feed/model/books.dart';
import 'package:bible_feed/model/feeds.dart';

void main() {
  late Feeds fds;
  late Books bks0, bks1;
  late Book bk0, bk1, bk2;

  setUp(() async {
    SharedPreferences.setMockInitialValues({
      'bks0.book': 'bk0',
      'bks0.chapter': 1,
      'bks0.isChapterRead': true,
      'bks0.dateLastSaved': DateTime.now().toIso8601String(),
      'bks1.book': 'bk1',
      'bks1.chapter': 1,
      'bks1.isChapterRead': false,
      'bks1.dateLastSaved': DateTime.now().toIso8601String(),
      'hasEverAdvanced': false,
    });

    await Store.init();

    bk0 = Book('bk0', 'Book0', 5);
    bk1 = Book('bk1', 'Book1', 3);
    bk2 = Book('bk2', 'Book2', 2);
    bks0 = Books('bks0', 'Reading List 0', [bk0]);
    bks1 = Books('bks1', 'Reading List 1', [bk1, bk2]);
    fds = Feeds([bks0, bks1]);
  });

  test('[]', () {
    expect(fds[0].books, bks0);
    expect(fds[1].books, bks1);
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
    checkHasAdvanced(bool shouldAdvance) {
      expect(bks0.current.chapter, shouldAdvance ? 2 : 1);
      expect(bks1.current.chapter, shouldAdvance ? 2 : 1);
    }

    test('constructor should advance all feeds if new day', () {
      Store.setBool('bks1.isChapterRead', true);
      var tomorrow = Clock.fixed(DateTime.now().add(const Duration(days: 1)));
      withClock(tomorrow, () => Feeds([bks0, bks1]));
      checkHasAdvanced(true);
    });

    test('forceAdvance should advance all feeds', () {
      fds[1].toggleIsChapterRead();
      fds.forceAdvance();
      checkHasAdvanced(true);
    });

    group('maybeAdvance', () {
      test('if not all read, should not advance', () {
        fds.maybeAdvance();
        checkHasAdvanced(false);
      });

      group('if all read and latest saved day is', () {
        run(String desc, int dayDiff, bool shouldAdvance) {
          test(desc, () {
            fds[1].toggleIsChapterRead();
            withClock(Clock.fixed(DateTime.now().add(Duration(days: dayDiff))), fds.maybeAdvance);
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
