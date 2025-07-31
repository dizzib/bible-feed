import 'package:dartx/dartx.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch_it/watch_it.dart';
import 'package:bible_feed/model/book.dart';
import 'package:bible_feed/model/feed.dart';
import '../injectable.dart';
import '../stub/book_stub.dart';
import '../stub/feed_stub.dart';

void main() async {
  initFeed(Map<String, Object> storeValues) async {
    SharedPreferences.setMockInitialValues(storeValues);
    sl.pushNewScope();
    await configureDependencies();
    f2.loadStateOrDefaults();
  }

  DateTime yesterday = DateTime.now() - const Duration(days: 1);

  setUp(() async {
    await initFeed({
      'l2.book': 'b1',
      'l2.chapter': 2,
      'l2.isChapterRead': true,
      'l2.dateModified': yesterday.toIso8601String(),
    });
  });

  group('constructor', () {
    test('should load defaults if store is empty', () async {
      await initFeed({});
      expect(f2.book, b0);
      expect(f2.chapter, 1);
      expect(f2.isChapterRead, false);
      expect(f2.dateModified, null);
    });

    test('should load state from non-empty store', () {
      expect(f2.book, b1);
      expect(f2.chapter, 2);
      expect(f2.isChapterRead, true);
      expect(f2.dateModified, yesterday);
    });
  });

  group('property', () {
    test('book get', () {
      expect(f2.book, b1);
    });

    test('bookIndex get', () {
      expect(f2.bookIndex, 1);
    });

    test('chapter get', () {
      expect(f2.chapter, 2);
    });

    test('isChapterRead get/set should affect chaptersRead', () {
      expect(f2.isChapterRead, true);
      expect(f2.chaptersRead, 2);
      f2.isChapterRead = false;
      expect(f2.isChapterRead, false);
      expect(f2.chaptersRead, 1);
    });

    test('progress get', () {
      f2.nextChapter();
      expect(f2.progress, 0.7);
    });
  });

  group('method', () {
    void checkBookChapterAndStore(Book expectedBook, int expectedChapter) {
      expect(f2.book, expectedBook);
      expect(f2.chapter, expectedChapter);
      expect(sl<SharedPreferences>().getString('l2.book')!, expectedBook.key);
      expect(sl<SharedPreferences>().getInt('l2.chapter')!, expectedChapter);
      expect(DateTime.parse(sl<SharedPreferences>().getString('l2.dateModified')!).date, DateTime.now().date);
    }

    group('nextChapter', () {
      next() async {
        f2.isChapterRead = true;
        await f2.nextChapter();
      }

      test('should fail assertion if not read', () {
        f2.isChapterRead = false;
        expect(f2.nextChapter, throwsAssertionError);
      });

      test('full cycle: should advance/reset chapter and book, and store', () async {
        await next();
        checkBookChapterAndStore(b1, 3);
        await next();
        checkBookChapterAndStore(b2, 1);
        await next();
        checkBookChapterAndStore(b2, 2);
        await next();
        checkBookChapterAndStore(b0, 1);
        await next();
        checkBookChapterAndStore(b0, 2);
        await next();
        checkBookChapterAndStore(b0, 3);
        await next();
        checkBookChapterAndStore(b0, 4);
        await next();
        checkBookChapterAndStore(b0, 5);
        await next();
        checkBookChapterAndStore(b1, 1);
        await next();
        checkBookChapterAndStore(b1, 2);
        await next();
        checkBookChapterAndStore(b1, 3);
      });

      test('should +0 chaptersRead', () async {
        expect(f2.chaptersRead, 2);
        await next();
        expect(f2.chaptersRead, 2);
      });

      test('should reset isChapterRead', () async {
        await next();
        expect(f2.isChapterRead, false);
      });
    });

    test('setBookAndChapter should set book/chapter, reset isChapterRead, and store', () async {
      await f2.setBookAndChapter(0, 4);
      checkBookChapterAndStore(b0, 4);
      expect(f2.isChapterRead, false);
    });

    test('toggleIsChapterRead should toggle and store', () async {
      void checkIsChapterRead(bool expected) {
        expect(f2.isChapterRead, expected);
        expect(sl<SharedPreferences>().getBool('l2.isChapterRead')!, expected);
      }

      await f2.toggleIsChapterRead();
      checkIsChapterRead(false);
      await f2.toggleIsChapterRead();
      checkIsChapterRead(true);
      checkBookChapterAndStore(b1, 2); // ensure no side effects
    });
  });
}
