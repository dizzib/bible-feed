import 'package:bible_feed/model/feed.dart';
import 'package:bible_feed/model/feeds.dart';
import 'package:bible_feed/model/reading_lists.dart';
import 'package:bible_feed/service/feed_store_service.dart';
import 'package:bible_feed/service/verse_scope_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../injectable.dart';
import '../test_data.dart';

class MockFeedStoreService extends Mock implements FeedStoreService {}

class MockVerseScopeService extends Mock implements VerseScopeService {}

class TestReadingLists extends ReadingLists {
  @override
  get iterator => [rl0, rl1].iterator;
}

void main() async {
  await configureDependencies();

  late Feeds testee;
  late MockFeedStoreService mockFeedStoreService;
  late MockVerseScopeService mockVerseScopeService;
  late FeedState state0;
  late FeedState state1;

  setUp(() {
    mockFeedStoreService = MockFeedStoreService();
    mockVerseScopeService = MockVerseScopeService();
    state0 = FeedState(book: b0, chapter: 1, isRead: true, dateModified: DateTime(2025, 1, 1, 7));
    state1 = FeedState(book: b1, chapter: 1, isRead: false, dateModified: DateTime(2025, 1, 1, 8));
    when(() => mockFeedStoreService.loadState(rl0)).thenReturn(state0);
    when(() => mockFeedStoreService.loadState(rl1)).thenReturn(state1);
    when(() => mockFeedStoreService.saveState(rl0, state0)).thenAnswer((_) async => true);
    when(() => mockFeedStoreService.saveState(rl1, state1)).thenAnswer((_) async => true);
    testee = Feeds(mockFeedStoreService, mockVerseScopeService, TestReadingLists());
  });

  group('property', () {
    test('[]', () {
      expect(testee[0].readingList, rl0);
      expect(testee[1].readingList, rl1);
    });

    test('areChaptersRead', () {
      expect(testee.areChaptersRead, false);
      testee[1].toggleIsRead();
      expect(testee.areChaptersRead, true);
    });

    group('lastModifiedFeed', () {
      test('should initialise from store', () {
        expect(testee.lastModifiedFeed, testee[1]);
      });

      test('should update on toggle', () {
        testee[0].toggleIsRead();
        expect(testee.lastModifiedFeed, testee[0]);
        testee[1].toggleIsRead();
        expect(testee.lastModifiedFeed, testee[1]);
        testee[0].toggleIsRead();
        expect(testee.lastModifiedFeed, testee[0]);
      });
    });
  });

  group('updating a feed', () {
    test('should update lastModifiedFeed', () {
      testee[0].toggleIsRead();
      expect(testee.lastModifiedFeed, testee[0]);
      testee[1].toggleIsRead();
      expect(testee.lastModifiedFeed, testee[1]);
    });

    test('should store the feed', () {
      testee[0].toggleIsRead();
      verify(() => mockFeedStoreService.saveState(rl0, state0)).called(1);
      verifyNever(() => mockFeedStoreService.saveState(rl1, state1));
      testee[1].toggleIsRead();
      verifyNever(() => mockFeedStoreService.saveState(rl0, state0));
      verify(() => mockFeedStoreService.saveState(rl1, state1)).called(1);
    });
  });
}
