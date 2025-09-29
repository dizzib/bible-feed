import 'package:bible_feed/model/feed.dart';
import 'package:bible_feed/model/feeds.dart';
import 'package:bible_feed/service/feed_advance_state.dart';
import 'package:bible_feed/service/feeds_advance_service.dart';
import 'package:clock/clock.dart';
import 'package:dartx/dartx.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:parameterized_test/parameterized_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../test_data.dart';
import 'feeds_advance_service_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Feed>(), MockSpec<Feeds>(), MockSpec<SharedPreferences>()])
void main() async {
  final mockFeedList = [MockFeed(), MockFeed()];
  late MockFeeds mockFeeds;
  late MockSharedPreferences mockSharedPreferences;
  late FeedsAdvanceService testee;

  setUp(() {
    mockFeeds = MockFeeds();
    mockSharedPreferences = MockSharedPreferences();
    when(mockFeeds.iterator).thenReturn(mockFeedList.iterator);
    testee = FeedsAdvanceService(mockSharedPreferences, mockFeeds);
  });

  verifyAllAdvanced() {
    for (var f in mockFeedList) {
      verify(f.advance()).called(1);
    }
  }

  verifyNoneAdvanced() {
    for (var f in mockFeedList) {
      verifyNever(f.advance());
    }
  }

  test('hasEverAdvanced should default to false', () {
    expect(testee.hasEverAdvanced, false);
  });

  test('forceAdvance should advance all feeds and store hasEverAdvanced as true', () async {
    expect(await testee.forceAdvance(), FeedAdvanceState.listsAdvanced);
    verifyAllAdvanced();
    verify(mockSharedPreferences.setBool('hasEverAdvanced', true)).called(1);
  });

  parameterizedTest(
    'maybeAdvance',
    [
      [false, const Duration(days: 1), FeedAdvanceState.notAllRead, verifyNoneAdvanced],
      [true, const Duration(days: 0), FeedAdvanceState.allReadAwaitingTomorrow, verifyNoneAdvanced],
      [true, const Duration(days: 1), FeedAdvanceState.listsAdvanced, verifyAllAdvanced],
      [true, const Duration(days: 7), FeedAdvanceState.listsAdvanced, verifyAllAdvanced],
    ],
    customDescriptionBuilder: (_, _, values) {
      return 'when areChaptersRead=${values[0]} and lastDateModified=(Now - ${values[1]}), expect ${values[2]}';
    },
    (bool areChaptersRead, Duration sinceLastModified, FeedAdvanceState expectedAdvanceState, Function verify) async {
      final date = DateTime(2030, 1, 1, 1);
      final clock = Clock(() => date);
      when(mockFeeds.areChaptersRead).thenReturn(areChaptersRead);
      when(mockFeeds.lastModifiedFeed).thenReturn(mockFeedList[0]);
      when(mockFeedList[0].state).thenReturn(FeedState(book: b0, isRead: true, dateModified: date - sinceLastModified));
      await withClock(clock, () async => expect(await testee.maybeAdvance(), expectedAdvanceState));
      verify();
    },
  );
}
