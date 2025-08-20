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
    await configureDependencies();
    f2.loadStateOrDefaults();
  }

  DateTime yesterday = DateTime.now() - const Duration(days: 1);

  setUp(() async {
    await initFeed({
      'l2.book': 'b1',
      'l2.chapter': 2,
      'l2.isRead': true,
      'l2.dateModified': yesterday.toIso8601String(),
    });
  });

  group('constructor', () {
    test('should load defaults if store is empty', () async {
      await initFeed({});
      expect(f2.book, b0);
      expect(f2.chapter, 1);
      expect(f2.dateModified, null);
      expect(f2.isRead, false);
      expect(f2.verse, 1);
    });

    test('should load state from non-empty store', () {
      expect(f2.book, b1);
      expect(f2.chapter, 2);
      expect(f2.dateModified, yesterday);
      expect(f2.isRead, true);
      expect(f2.verse, 1);
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
      expect(f2.isRead, true);
      expect(f2.chaptersRead, 2);
      f2.isRead = false;
      expect(f2.isRead, false);
      expect(f2.chaptersRead, 1);
    });

    test('progress get', () {
      f2.advance();
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

    group('advance', () {
      advance() async {
        f2.isRead = true;
        await f2.advance();
      }

      test('should fail assertion if not read', () {
        f2.isRead = false;
        expect(f2.advance(), throwsAssertionError);
      });

      test('full cycle: should advance/reset chapter and book, and store', () async {
        await advance();
        checkBookChapterAndStore(b1, 3);
        await advance();
        checkBookChapterAndStore(b2, 1);
        await advance();
        checkBookChapterAndStore(b2, 2);
        await advance();
        checkBookChapterAndStore(b0, 1);
        await advance();
        checkBookChapterAndStore(b0, 2);
        await advance();
        checkBookChapterAndStore(b0, 3);
        await advance();
        checkBookChapterAndStore(b0, 4);
        await advance();
        checkBookChapterAndStore(b0, 5);
        await advance();
        checkBookChapterAndStore(b1, 1);
        await advance();
        checkBookChapterAndStore(b1, 2);
        await advance();
        checkBookChapterAndStore(b1, 3);
      });

      test('should +0 chaptersRead', () async {
        expect(f2.chaptersRead, 2);
        await advance();
        expect(f2.chaptersRead, 2);
      });

      test('should reset isChapterRead', () async {
        await advance();
        expect(f2.isRead, false);
      });
    });

    test('setBookAndChapter should set book/chapter, reset isRead, and store', () async {
      await f2.setBookAndChapter(0, 4);
      checkBookChapterAndStore(b0, 4);
      expect(f2.isRead, false);
    });

    test('toggleIsRead should toggle and store', () async {
      void checkIsRead(bool expected) {
        expect(f2.isRead, expected);
        expect(sl<SharedPreferences>().getBool('l2.isRead')!, expected);
      }

      await f2.toggleIsRead();
      checkIsRead(false);
      await f2.toggleIsRead();
      checkIsRead(true);
      checkBookChapterAndStore(b1, 2); // ensure no side effects
    });
  });
}
