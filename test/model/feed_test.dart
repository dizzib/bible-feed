import 'package:bible_feed/model/book.dart';
import 'package:bible_feed/model/feed.dart';
import 'package:bible_feed/service/verse_scope_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../injectable.dart';
import '../test_data.dart';

class MockVerseScopeService extends Mock implements VerseScopeService {}

void main() async {
  await configureDependencies();

  late Feed testee;
  late FeedState state;
  final mockVerseScopeService = MockVerseScopeService();

  setUp(() {
    state = FeedState(book: b1, chapter: 1, isRead: false);
    when(() => mockVerseScopeService.nextVerse(state)).thenReturn(1);
    testee = Feed(rl1, mockVerseScopeService, state);
  });

  group('property', () {
    test('book get', () {
      expect(testee.state.book, b1);
    });

    test('bookIndex get', () {
      expect(testee.bookIndex, 1);
    });

    test('chapter get', () {
      expect(testee.state.chapter, 1);
    });

    test('isChapterRead get/set should affect chaptersRead', () {
      expect(testee.state.isRead, false);
      expect(testee.chaptersRead, 0);
      testee.toggleIsRead();
      expect(testee.state.isRead, true);
      expect(testee.chaptersRead, 1);
    });

    test('progress get', () {
      expect(testee.progress, 0.25);
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
        expect(testee.advance(), throwsAssertionError);
      });

      test('should +0 chaptersRead', () async {
        testee.toggleIsRead();
        expect(testee.chaptersRead, 1);
        await advance();
        expect(testee.chaptersRead, 1);
      });

      test('should reset isRead', () async {
        testee.toggleIsRead();
        await testee.advance();
        expect(testee.state.isRead, false);
      });

      test('full cycle: should advance/reset chapter and book', () async {
        checkState(b1, 1);
        await advance();
        checkState(b1, 2);
        await advance();
        checkState(b1, 3);
        await advance();
        checkState(b0, 1);
        await advance();
        checkState(b1, 1);
      });
    });

    test('setBookAndChapter should set book/chapter, reset isRead, and store', () async {
      await testee.toggleIsRead();
      await testee.setBookAndChapter(1, 2);
      checkState(b1, 2);
      expect(testee.state.isRead, false);
    });

    test('toggleIsRead should toggle', () async {
      await testee.toggleIsRead();
      expect(testee.state.isRead, true);
      await testee.toggleIsRead();
      expect(testee.state.isRead, false);
      checkState(b1, 1); // ensure no side effects
    });
  });
}
