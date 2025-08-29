import 'package:bible_feed/model/feed.dart';
import 'package:bible_feed/model/feeds.dart';
import 'package:bible_feed/service/feeds_advance_service.dart';
import 'package:dartx/dartx.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../injectable.dart';
import '../test_data.dart';

class MockFeed extends Mock implements Feed {}

class MockFeeds extends Mock implements Feeds {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() async {
  await configureDependencies();

  late MockFeed mockFeed0;
  late MockFeed mockFeed1;
  late MockFeeds mockFeeds;
  late MockSharedPreferences mockSharedPreferences;
  late FeedsAdvanceService testee;

  setUp(() {
    mockFeed0 = MockFeed();
    mockFeed1 = MockFeed();
    mockFeeds = MockFeeds();
    mockSharedPreferences = MockSharedPreferences();
    when(() => mockFeeds.iterator).thenReturn([mockFeed0, mockFeed1].iterator);
    when(() => mockSharedPreferences.getBool('hasEverAdvanced')).thenReturn(false);
    when(() => mockSharedPreferences.setBool('hasEverAdvanced', any())).thenAnswer((_) async => true);
    when(() => mockFeed0.advance()).thenAnswer((_) async => null);
    testee = FeedsAdvanceService(mockSharedPreferences, mockFeeds);
  });

  group('hasEverAdvanced', () {
    test('should initialise from store', () {
      expect(testee.hasEverAdvanced, false);
    });

    test('should be stored true after advance', () async {
      await testee.forceAdvance();
      verify(() => mockSharedPreferences.setBool('hasEverAdvanced', true)).called(1);
    });
  });

  group('Advance:', () {
    verifyAllAdvanced() {
      verify(() => mockFeed0.advance()).called(1);
      verify(() => mockFeed1.advance()).called(1);
    }

    verifyNoneAdvanced() {
      verifyNever(() => mockFeed0.advance());
      verifyNever(() => mockFeed1.advance());
    }

    test('forceAdvance should advance all feeds', () async {
      await testee.forceAdvance();
      verifyAllAdvanced();
    });

    group('maybeAdvance', () {
      test('if not all read, should not advance', () async {
        when(() => mockFeeds.areChaptersRead).thenReturn(false);
        expect(await testee.maybeAdvance(), AdvanceState.notAllRead);
        verifyNoneAdvanced();
      });

      group('if all read and last modified is', () {
        setUp(() {
          when(() => mockFeeds.areChaptersRead).thenReturn(true);
          when(() => mockFeeds.lastModifiedFeed).thenReturn(mockFeed0);
        });

        setMockFeedState(Duration offset) => when(() => mockFeed0.state)
            .thenReturn(FeedState(book: b0, chapter: 1, isRead: true, dateModified: DateTime.now() + offset));

        test('today, should not advance', () async {
          setMockFeedState(const Duration());
          expect(await testee.maybeAdvance(), AdvanceState.allReadAwaitingTomorrow);
          verifyNoneAdvanced();
        });

        test('yesterday, should advance', () async {
          setMockFeedState(const Duration(days: -1));
          expect(await testee.maybeAdvance(), AdvanceState.listsAdvanced);
          verifyAllAdvanced();
        });

        test('1 week ago, should advance', () async {
          setMockFeedState(const Duration(days: -7));
          expect(await testee.maybeAdvance(), AdvanceState.listsAdvanced);
          verifyAllAdvanced();
        });
      });
    });
  });
}
