import 'package:bible_feed/model/feed.dart';
import 'package:bible_feed/model/reading_lists.dart';
import 'package:bible_feed/manager/feed_store_manager.dart';
import 'package:bible_feed/manager/feeds_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../test_data.dart';
import 'feeds_manager_test.mocks.dart';

@GenerateNiceMocks([MockSpec<FeedStoreManager>()])
void main() async {
  late FeedsManager testee;
  late MockFeedStoreManager mockFeedStoreManager;
  late FeedState state0;
  late FeedState state1;

  setUp(() {
    mockFeedStoreManager = MockFeedStoreManager();
    state0 = FeedState(bookKey: b0.key, isRead: true, dateModified: DateTime(2025, 1, 1, 1));
    state1 = FeedState(bookKey: b1.key, dateModified: DateTime(2025, 1, 1, 2));
    when(mockFeedStoreManager.loadState(rl0)).thenReturn(state0);
    when(mockFeedStoreManager.loadState(rl1)).thenReturn(state1);
    testee = FeedsManager(mockFeedStoreManager, ReadingLists([rl0, rl1]));
  });

  group('property', () {
    test('[]', () {
      expect(testee.feeds[0].readingList, rl0);
      expect(testee.feeds[1].readingList, rl1);
    });

    test('areChaptersRead', () {
      expect(testee.areChaptersRead, false);
      testee.feeds[1].toggleIsRead();
      expect(testee.areChaptersRead, true);
    });

    group('lastModifiedFeed', () {
      test('should initialise from store', () {
        expect(testee.lastModifiedFeed, testee.feeds[1]);
      });

      test('should update on toggle', () {
        testee.feeds[0].toggleIsRead();
        expect(testee.lastModifiedFeed, testee.feeds[0]);
        testee.feeds[1].toggleIsRead();
        expect(testee.lastModifiedFeed, testee.feeds[1]);
        testee.feeds[0].toggleIsRead();
        expect(testee.lastModifiedFeed, testee.feeds[0]);
      });
    });
  });

  group('updating a feed', () {
    test('should update lastModifiedFeed', () {
      testee.feeds[0].toggleIsRead();
      expect(testee.lastModifiedFeed, testee.feeds[0]);
      testee.feeds[1].toggleIsRead();
      expect(testee.lastModifiedFeed, testee.feeds[1]);
    });

    test('should store the feed', () {
      testee.feeds[0].toggleIsRead();
      verify(mockFeedStoreManager.saveState(rl0, state0)).called(1);
      verifyNever(mockFeedStoreManager.saveState(rl1, state1));
      testee.feeds[1].toggleIsRead();
      verifyNever(mockFeedStoreManager.saveState(rl0, state0));
      verify(mockFeedStoreManager.saveState(rl1, state1)).called(1);
    });
  });
}
