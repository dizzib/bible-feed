import 'package:bible_feed/model/book.dart';
import 'package:bible_feed/model/feed.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_data.dart';

void main() async {
  late Feed testee;
  late FeedState state;

  setUp(() {
    state = FeedState(bookKey: b1.key);
    testee = Feed(rl1, state);
  });

  group('property', () {
    test('book get', () {
      expect(testee.book, b1);
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

    test('reading list get', () {
      expect(testee.readingList, rl1);
    });

    test('state get', () {
      expect(testee.state, state);
    });

    test('state set', () {
      final state0 = FeedState(bookKey: b0.key);
      testee.state = state0;
      expect(testee.state, state0);
    });
  });

  group('method', () {
    void checkState(Book expectedBook, int expectedChapter, [int expectedVerse = 1]) {
      expect(testee.book, expectedBook);
      expect(testee.state.chapter, expectedChapter);
      expect(testee.state.verse, expectedVerse);
    }

    test('setBookChapterVerse should set book/chapter/verse and reset isRead', () {
      testee.toggleIsRead();
      testee.setBookChapterVerse(1, 2);
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
