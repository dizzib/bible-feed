import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch_it/watch_it.dart';
import 'package:bible_feed/extension/clock.dart';
import 'package:bible_feed/model/feed.dart';
import 'package:bible_feed/model/feeds.dart';
import '_test_data.dart';

void main() async {
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
    sl.pushNewScope();
    sl.registerSingleton(FeedPersisterService());
    sl.registerSingleton(await SharedPreferences.getInstance());
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

    test('should be stored true after advance', () async {
      f1.toggleIsChapterRead();
      await fds.forceAdvance();
      expect(sl<SharedPreferences>().getBool('hasEverAdvanced'), true);
      expect(fds.hasEverAdvanced, true);
    });
  });

  group('Advance:', () {
    checkHasAdvanced(bool shouldAdvance) {
      expect(f0.chapter, shouldAdvance ? 2 : 1);
      expect(f1.chapter, shouldAdvance ? 2 : 1);
    }

    test('forceAdvance should advance all feeds', () async {
      f1.toggleIsChapterRead();
      await fds.forceAdvance();
      checkHasAdvanced(true);
    });

    group('maybeAdvance', () {
      test('if not all read, on next day, should not advance', () async {
        expect(await withClock(clock.tomorrow, fds.maybeAdvance), AdvanceState.notAllRead);
        checkHasAdvanced(false);
      });

      group('if all read and latest saved day is', () {
        test('today, should not advance', () async {
          f1.toggleIsChapterRead();
          expect(await fds.maybeAdvance(), AdvanceState.allReadAwaitingTomorrow);
          checkHasAdvanced(false);
        });

        test('yesterday, should advance', () async {
          f1.toggleIsChapterRead();
          expect(await withClock(clock.tomorrow, fds.maybeAdvance), AdvanceState.listsAdvanced);
          checkHasAdvanced(true);
        });

        test('7 days ago, should advance', () async {
          f1.toggleIsChapterRead();
          expect(await withClock(clock.addDays(7), fds.maybeAdvance), AdvanceState.listsAdvanced);
          checkHasAdvanced(true);
        });
      });
    });

    test('reload should refresh from store updated in background', () async {
      sl<SharedPreferences>().setInt('l0.chapter', 2);
      expect(f0.chapter, 1);
      fds.reload();
      expect(f0.chapter, 2);
    });
  });
}
