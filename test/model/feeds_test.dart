import 'package:bible_feed/model/feed.dart';
import 'package:bible_feed/model/feeds.dart';
import 'package:bible_feed/model/reading_lists.dart';
import 'package:bible_feed/service/feed_store_service.dart';
import 'package:bible_feed/service/verse_scope_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:watch_it/watch_it.dart';

import '../injectable.dart';
import '../test_data.dart';

class MockFeedStoreService extends Mock implements FeedStoreService {}

class MockVerseScopeService extends Mock implements VerseScopeService {}

void main() async {
  await configureDependencies();

  late Feeds testee;
  final mockFeedStoreService = MockFeedStoreService();

  setUp(() {
    final state0 = FeedState(book: b0, chapter: 1, isRead: true);
    final state1 = FeedState(book: b1, chapter: 1, isRead: false);
    registerFallbackValue(Feed(rl0, MockVerseScopeService(), state0));
    when(() => mockFeedStoreService.loadState(rl0)).thenReturn(state0);
    when(() => mockFeedStoreService.loadState(rl1)).thenReturn(state1);
    when(() => mockFeedStoreService.saveState(any())).thenAnswer((_) async => true);
    testee = Feeds(
      mockFeedStoreService,
      MockVerseScopeService(),
      di<ReadingLists>(),
    );
  });

  test('[]', () {
    expect(testee[0].readingList, rl0);
    expect(testee[1].readingList, rl1);
  });

  test('areChaptersRead', () {
    expect(testee.areChaptersRead, false);
    testee[1].toggleIsRead();
    expect(testee.areChaptersRead, true);
  });

  test('lastModifiedFeed', () {
    testee[0].toggleIsRead();
    expect(testee.lastModifiedFeed, testee[0]);
    testee[1].toggleIsRead();
    expect(testee.lastModifiedFeed, testee[1]);
    testee[0].toggleIsRead();
    expect(testee.lastModifiedFeed, testee[0]);
  });
}
