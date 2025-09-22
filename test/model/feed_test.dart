import 'package:bible_feed/model/book.dart';
import 'package:bible_feed/model/feed.dart';
import 'package:bible_feed/service/verse_scope_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'feed_test.mocks.dart';

import '../injectable.dart';
import '../test_data.dart';

@GenerateNiceMocks([MockSpec<VerseScopeService>()])
void main() async {
  configureDependencies();

  late Feed testee;
  late FeedState state;
  final mockVerseScopeService = MockVerseScopeService();

  setUp(() {
    state = FeedState(book: b1);
    when(mockVerseScopeService.getNextVerse(state)).thenReturn(1);
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
    void checkState(Book expectedBook, int expectedChapter, [int expectedVerse = 1]) {
      expect(testee.state.book, expectedBook);
      expect(testee.state.chapter, expectedChapter);
      expect(testee.state.verse, expectedVerse);
    }

    group('advance', () {
      advance() {
        if (!testee.state.isRead) testee.toggleIsRead();
        testee.advance();
      }

      test('should fail assertion if not read', () {
        expect(() => testee.advance(), throwsAssertionError);
      });

      test('should +0 chaptersRead', () async {
        testee.toggleIsRead();
        expect(testee.chaptersRead, 1);
        advance();
        expect(testee.chaptersRead, 1);
      });

      test('should reset isRead', () async {
        testee.toggleIsRead();
        testee.advance();
        expect(testee.state.isRead, false);
      });

      test('full cycle: should advance/reset chapter and book', () async {
        checkState(b1, 1);
        advance();
        checkState(b1, 2);
        advance();
        checkState(b1, 3);
        advance();
        checkState(b0, 1);
        advance();
        checkState(b1, 1);
      });

      test('with verse scope, should advance verse only', () async {
        when(mockVerseScopeService.getNextVerse(state)).thenReturn(3);
        checkState(b1, 1, 1);
        testee.toggleIsRead();
        testee.advance();
        checkState(b1, 1, 3);
      });
    });

    test('setBookAndChapter should set book/chapter, reset isRead, and store', () {
      testee.toggleIsRead();
      testee.setBookAndChapter(1, 2);
      checkState(b1, 2);
      expect(testee.state.isRead, false);
    });

    test('toggleIsRead should toggle', () {
      testee.toggleIsRead();
      expect(testee.state.isRead, true);
      testee.toggleIsRead();
      expect(testee.state.isRead, false);
      checkState(b1, 1); // ensure no side effects
    });
  });
}
