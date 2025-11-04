import 'package:bible_feed/model/book.dart';
import 'package:bible_feed/model/feed.dart';
import 'package:bible_feed/manager/chapter_split_manager.dart';
import 'package:bible_feed/manager/feed_advance_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../test_data.dart';
import 'feed_advance_manager_test.mocks.dart';

@GenerateNiceMocks([MockSpec<ChapterSplitManager>()])
void main() async {
  final mockChapterSplitManager = MockChapterSplitManager();
  late Feed feed;
  late FeedState state;
  late FeedAdvanceManager testee;

  setUp(() {
    state = FeedState(bookKey: b1.key);
    feed = Feed(rl1, state);
    when(mockChapterSplitManager.getNextVerse(state)).thenReturn(1);
    testee = FeedAdvanceManager(mockChapterSplitManager);
  });

  test('should fail assertion if not read', () {
    expect(() => testee.advance(feed), throwsAssertionError);
  });

  test('should not change chaptersRead', () {
    feed.toggleIsRead();
    expect(feed.chaptersRead, 1);
    testee.advance(feed);
    expect(feed.chaptersRead, 1);
  });

  test('should reset isRead', () {
    feed.toggleIsRead();
    testee.advance(feed);
    expect(feed.state.isRead, false);
  });

  void advance() {
    if (!state.isRead) feed.toggleIsRead();
    testee.advance(feed);
  }

  void checkState(Book expectBook, int expectChapter, [int expectVerse = 1]) {
    expect(state.bookKey, expectBook.key);
    expect(state.chapter, expectChapter);
    expect(state.verse, expectVerse);
  }

  test('full cycle: should advance/reset chapter and book', () {
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

  test('with chapter split, should advance verse only', () {
    when(mockChapterSplitManager.getNextVerse(state)).thenReturn(3);
    checkState(b1, 1, 1);
    feed.toggleIsRead();
    testee.advance(feed);
    checkState(b1, 1, 3);
  });
}
