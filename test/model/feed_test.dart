import 'package:bible_feed/model/book.dart';
import 'package:bible_feed/model/feed.dart';
import 'package:bible_feed/service/toggler_service.dart';
import 'package:bible_feed/service/verse_scope_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../injectable.dart';
import '../stub/book_stub.dart';
import '../stub/reading_list_stub.dart';

class MockVerseScopeTogglerService extends Mock implements VerseScopeTogglerService {}

void main() async {
  await configureDependencies();

  late Feed testee;
  final mockVerseScopeTogglerService = MockVerseScopeTogglerService();

  setUp(() {
    when(() => mockVerseScopeTogglerService.isEnabled).thenReturn(false);
    testee = Feed(
      rl2,
      VerseScopeService(mockVerseScopeTogglerService),
      FeedState(book: b1, chapter: 2, dateModified: DateTime.now(), isRead: true, verse: 1),
    );
  });

  group('property', () {
    test('book get', () {
      expect(testee.state.book, b1);
    });

    test('bookIndex get', () {
      expect(testee.bookIndex, 1);
    });

    test('chapter get', () {
      expect(testee.state.chapter, 2);
    });

    test('isChapterRead get/set should affect chaptersRead', () {
      expect(testee.state.isRead, true);
      expect(testee.chaptersRead, 2);
      testee.toggleIsRead();
      expect(testee.state.isRead, false);
      expect(testee.chaptersRead, 1);
    });

    test('progress get', () {
      testee.advance();
      expect(testee.progress, 0.7);
    });
  });

  group('method', () {
    void checkState(Book expectedBook, int expectedChapter) {
      expect(testee.state.book, expectedBook);
      expect(testee.state.chapter, expectedChapter);
      expect(testee.state.verse, 1);
    }

    group('advance', () {
      advance() async {
        if (!testee.state.isRead) testee.toggleIsRead();
        await testee.advance();
      }

      test('should fail assertion if not read', () {
        testee.toggleIsRead();
        expect(testee.advance(), throwsAssertionError);
      });

      test('full cycle: should advance/reset chapter and book', () async {
        await advance();
        checkState(b1, 3);
        await advance();
        checkState(b2, 1);
        await advance();
        checkState(b2, 2);
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
        expect(testee.chaptersRead, 2);
        await advance();
        expect(testee.chaptersRead, 2);
      });

      test('should reset isRead', () async {
        await advance();
        expect(testee.state.isRead, false);
      });
    });

    test('setBookAndChapter should set book/chapter, reset isRead, and store', () async {
      await testee.setBookAndChapter(0, 4);
      checkState(b0, 4);
      expect(testee.state.isRead, false);
    });

    test('toggleIsRead should toggle and store', () async {
      void checkIsRead(bool expected) {
        expect(testee.state.isRead, expected);
      }

      await testee.toggleIsRead();
      checkIsRead(false);
      await testee.toggleIsRead();
      checkIsRead(true);
      checkState(b1, 2); // ensure no side effects
    });
  });
}
