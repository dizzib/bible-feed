import 'package:bible_feed/model/feed.dart';
import 'package:bible_feed/model/reading_lists.dart';
import 'package:bible_feed/manager/feed_store_service.dart';
import 'package:bible_feed/manager/feeds_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../test_data.dart';
import 'feeds_service_test.mocks.dart';

@GenerateNiceMocks([MockSpec<FeedStoreService>()])
void main() async {
  late FeedsService testee;
  late MockFeedStoreService mockFeedStoreService;
  late FeedState state0;
  late FeedState state1;

  setUp(() {
    mockFeedStoreService = MockFeedStoreService();
    state0 = FeedState(book: b0, isRead: true, dateModified: DateTime(2025, 1, 1, 1));
    state1 = FeedState(book: b1, dateModified: DateTime(2025, 1, 1, 2));
    when(mockFeedStoreService.loadState(rl0)).thenReturn(state0);
    when(mockFeedStoreService.loadState(rl1)).thenReturn(state1);
    testee = FeedsService(mockFeedStoreService, ReadingLists([rl0, rl1]));
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
      verify(mockFeedStoreService.saveState(rl0, state0)).called(1);
      verifyNever(mockFeedStoreService.saveState(rl1, state1));
      testee.feeds[1].toggleIsRead();
      verifyNever(mockFeedStoreService.saveState(rl0, state0));
      verify(mockFeedStoreService.saveState(rl1, state1)).called(1);
    });
  });
}
