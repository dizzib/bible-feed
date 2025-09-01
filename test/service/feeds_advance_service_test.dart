import 'package:bible_feed/model/feed.dart';
import 'package:parameterized_test/parameterized_test.dart';
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

    parameterizedTest(
      'maybeAdvance',
      [
        [false, const Duration(days: -1), AdvanceState.notAllRead, verifyNoneAdvanced],
        [true, const Duration(days: 0), AdvanceState.allReadAwaitingTomorrow, verifyNoneAdvanced],
        [true, const Duration(days: -1), AdvanceState.listsAdvanced, verifyAllAdvanced],
        [true, const Duration(days: -7), AdvanceState.listsAdvanced, verifyAllAdvanced],
      ],
      customDescriptionBuilder: (_, __, values) => 'when lastDateModified is Now + ${values[1]}, expect ${values[2]}',
      (bool areChaptersRead, Duration offset, AdvanceState expectedAdvanceState, Function verify) async {
        when(() => mockFeeds.areChaptersRead).thenReturn(areChaptersRead);
        when(() => mockFeeds.lastModifiedFeed).thenReturn(mockFeed0);
        when(() => mockFeed0.state)
            .thenReturn(FeedState(book: b0, isRead: true, dateModified: DateTime.now() + offset));
        expect(await testee.maybeAdvance(), expectedAdvanceState);
        verify();
      },
    );
  });
}
