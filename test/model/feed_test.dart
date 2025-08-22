import 'package:bible_feed/model/book.dart';
import 'package:bible_feed/model/feed.dart';
import 'package:dartx/dartx.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch_it/watch_it.dart';

import '../injectable.dart';
import '../stub/book_stub.dart';
import '../stub/reading_list_stub.dart';

void main() async {
  late Feed feed;
  final DateTime yesterday = DateTime.now() - const Duration(days: 1);

  initFeed(Map<String, Object> storeValues) async {
    SharedPreferences.setMockInitialValues(storeValues);
    await configureDependencies();
    feed = Feed(l2, sl<SharedPreferences>());
    feed.loadStateOrDefaults();
  }

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
      expect(feed.book, b0);
      expect(feed.chapter, 1);
      expect(feed.dateModified, null);
      expect(feed.isRead, false);
      expect(feed.verse, 1);
    });

    test('should load state from non-empty store', () {
      expect(feed.book, b1);
      expect(feed.chapter, 2);
      expect(feed.dateModified, yesterday);
      expect(feed.isRead, true);
      expect(feed.verse, 1);
    });
  });

  group('property', () {
    test('book get', () {
      expect(feed.book, b1);
    });

    test('bookIndex get', () {
      expect(feed.bookIndex, 1);
    });

    test('chapter get', () {
      expect(feed.chapter, 2);
    });

    test('isChapterRead get/set should affect chaptersRead', () {
      expect(feed.isRead, true);
      expect(feed.chaptersRead, 2);
      feed.isRead = false;
      expect(feed.isRead, false);
      expect(feed.chaptersRead, 1);
    });

    test('progress get', () {
      feed.advance();
      expect(feed.progress, 0.7);
    });
  });

  group('method', () {
    void checkStateAndStore(Book expectedBook, int expectedChapter,
        [int expectedVerse = 1, String expectedVerseScopeName = '']) {
      expect(feed.book, expectedBook);
      expect(feed.chapter, expectedChapter);
      expect(feed.verseScopeName, expectedVerseScopeName);
      expect(feed.verse, expectedVerse);
      expect(sl<SharedPreferences>().getString('l2.book')!, expectedBook.key);
      expect(sl<SharedPreferences>().getInt('l2.chapter')!, expectedChapter);
      expect(DateTime.parse(sl<SharedPreferences>().getString('l2.dateModified')!).date, DateTime.now().date);
    }

    group('advance', () {
      advance() async {
        feed.isRead = true;
        await feed.advance();
      }

      test('should fail assertion if not read', () {
        feed.isRead = false;
        expect(feed.advance(), throwsAssertionError);
      });

      test('full cycle: should advance/reset chapter and book, and store', () async {
        await advance();
        checkStateAndStore(b1, 3);
        await advance();
        checkStateAndStore(b2, 1);
        await advance();
        checkStateAndStore(b2, 2, 1, 'split 1');
        await advance();
        checkStateAndStore(b2, 2, 7, 'split 2');
        await advance();
        checkStateAndStore(b0, 1);
        await advance();
        checkStateAndStore(b0, 2);
        await advance();
        checkStateAndStore(b0, 3);
        await advance();
        checkStateAndStore(b0, 4);
        await advance();
        checkStateAndStore(b0, 5);
        await advance();
        checkStateAndStore(b1, 1);
        await advance();
        checkStateAndStore(b1, 2);
        await advance();
        checkStateAndStore(b1, 3);
      });

      test('should +0 chaptersRead', () async {
        expect(feed.chaptersRead, 2);
        await advance();
        expect(feed.chaptersRead, 2);
      });

      test('should reset isRead', () async {
        await advance();
        expect(feed.isRead, false);
      });
    });

    test('setBookAndChapter should set book/chapter, reset isRead, and store', () async {
      await feed.setBookAndChapter(0, 4);
      checkStateAndStore(b0, 4);
      expect(feed.isRead, false);
    });

    test('toggleIsRead should toggle and store', () async {
      void checkIsRead(bool expected) {
        expect(feed.isRead, expected);
        expect(sl<SharedPreferences>().getBool('l2.isRead')!, expected);
      }

      await feed.toggleIsRead();
      checkIsRead(false);
      await feed.toggleIsRead();
      checkIsRead(true);
      checkStateAndStore(b1, 2); // ensure no side effects
    });
  });
}
