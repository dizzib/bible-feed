import 'package:bible_feed/model/book.dart';
import 'package:bible_feed/model/feed.dart';
import 'package:bible_feed/service/verse_scope_service.dart';
import 'package:dartx/dartx.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:watch_it/watch_it.dart';

import '../injectable.dart';
import '../stub/book_stub.dart';
import '../stub/reading_list_stub.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Feed feed;
  final DateTime yesterday = DateTime.now() - const Duration(days: 1);

  setUp(() async {
    await configureDependencies();
    feed = Feed(
      l2,
      sl<VerseScopeService>(),
      FeedState(
        book: l2.getBook('b1'),
        chapter: 2,
        dateModified: yesterday,
        isRead: true,
        verse: 1,
      ),
    );
  });

  group('property', () {
    test('book get', () {
      expect(feed.state.book, b1);
    });

    test('bookIndex get', () {
      expect(feed.bookIndex, 1);
    });

    test('chapter get', () {
      expect(feed.state.chapter, 2);
    });

    test('isChapterRead get/set should affect chaptersRead', () {
      expect(feed.state.isRead, true);
      expect(feed.chaptersRead, 2);
      feed.toggleIsRead();
      expect(feed.state.isRead, false);
      expect(feed.chaptersRead, 1);
    });

    test('progress get', () {
      feed.advance();
      expect(feed.progress, 0.7);
    });
  });

  group('method', () {
    void checkState(Book expectedBook, int expectedChapter,
        [int expectedVerse = 1, String expectedVerseScopeName = '']) {
      expect(feed.state.book, expectedBook);
      expect(feed.state.chapter, expectedChapter);
      expect(feed.verseScopeName, expectedVerseScopeName);
      expect(feed.state.verse, expectedVerse);
    }

    group('advance', () {
      advance() async {
        if (!feed.state.isRead) feed.toggleIsRead();
        await feed.advance();
      }

      test('should fail assertion if not read', () {
        feed.toggleIsRead();
        expect(feed.advance(), throwsAssertionError);
      });

      test('full cycle: should advance/reset chapter and book, and store', () async {
        await advance();
        checkState(b1, 3);
        await advance();
        checkState(b2, 1);
        await advance();
        checkState(b2, 2, 1, 'split 1');
        await advance();
        checkState(b2, 2, 7, 'split 2');
        await advance();
        checkState(b0, 1);
        await advance();
        checkState(b0, 2);
        await advance();
        checkState(b0, 3);
        await advance();
        checkState(b0, 4);
        await advance();
        checkState(b0, 5);
        await advance();
        checkState(b1, 1);
        await advance();
        checkState(b1, 2);
        await advance();
        checkState(b1, 3);
      });

      test('should +0 chaptersRead', () async {
        expect(feed.chaptersRead, 2);
        await advance();
        expect(feed.chaptersRead, 2);
      });

      test('should reset isRead', () async {
        await advance();
        expect(feed.state.isRead, false);
      });
    });

    test('setBookAndChapter should set book/chapter, reset isRead, and store', () async {
      await feed.setBookAndChapter(0, 4);
      checkState(b0, 4);
      expect(feed.state.isRead, false);
    });

    test('toggleIsRead should toggle and store', () async {
      void checkIsRead(bool expected) {
        expect(feed.state.isRead, expected);
      }

      await feed.toggleIsRead();
      checkIsRead(false);
      await feed.toggleIsRead();
      checkIsRead(true);
      checkState(b1, 2); // ensure no side effects
    });
  });
}
