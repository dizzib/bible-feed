import 'package:bible_feed/manager/feed_advance_manager.dart';
import 'package:bible_feed/manager/feeds_advance_manager.dart';
import 'package:bible_feed/manager/feeds_manager.dart';
import 'package:bible_feed/model/feed.dart';
import 'package:bible_feed/model/feeds_advance_state.dart';
import 'package:bible_feed/service/date_time_service.dart';
import 'package:dartx/dartx.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:parameterized_test/parameterized_test.dart';

import '../test_data.dart';
import 'feeds_advance_manager_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<DateTimeService>(),
  MockSpec<Feed>(),
  MockSpec<FeedAdvanceManager>(),
  MockSpec<FeedsManager>(),
])
void main() async {
  final mockFeedList = [MockFeed(), MockFeed()];
  late MockDateTimeService mockDateTimeService;
  late MockFeedAdvanceManager mockFeedAdvanceManager;
  late MockFeedsManager mockFeedsManager;
  late FeedsAdvanceManager testee;

  setUp(() {
    mockDateTimeService = MockDateTimeService();
    mockFeedAdvanceManager = MockFeedAdvanceManager();
    mockFeedsManager = MockFeedsManager();
    when(mockFeedsManager.feeds).thenReturn(mockFeedList);
    testee = FeedsAdvanceManager(mockDateTimeService, mockFeedAdvanceManager, mockFeedsManager);
  });

  verifyAllAdvanced() {
    for (var f in mockFeedList) {
      verify(mockFeedAdvanceManager.advance(f)).called(1);
    }
  }

  verifyNoneAdvanced() {
    for (var f in mockFeedList) {
      verifyNever(mockFeedAdvanceManager.advance(f));
    }
  }

  test('advance should advance all feeds', () async {
    final now = DateTime.now();
    when(mockDateTimeService.now).thenReturn(now);
    expect(await testee.advance(), FeedsAdvanceState.listsAdvanced);
    verifyAllAdvanced();
  });

  final midMonth = DateTime(2025, 7, 15, 12);
  final newMonth = DateTime(2025, 10, 1, 12);
  final newYear = DateTime(2025, 1, 1, 12);

  parameterizedTest(
    'maybeAdvance',
    [
      [midMonth, false, const Duration(days: 1), FeedsAdvanceState.notAllRead, verifyNoneAdvanced],
      [midMonth, true, const Duration(days: 0), FeedsAdvanceState.allReadAwaitingTomorrow, verifyNoneAdvanced],
      [midMonth, true, const Duration(days: 1), FeedsAdvanceState.listsAdvanced, verifyAllAdvanced],
      [midMonth, true, const Duration(days: 7), FeedsAdvanceState.listsAdvanced, verifyAllAdvanced],
      [newMonth, false, const Duration(days: 1), FeedsAdvanceState.notAllRead, verifyNoneAdvanced],
      [newMonth, true, const Duration(days: 0), FeedsAdvanceState.allReadAwaitingTomorrow, verifyNoneAdvanced],
      [newMonth, true, const Duration(days: 1), FeedsAdvanceState.listsAdvanced, verifyAllAdvanced],
      [newMonth, true, const Duration(days: 7), FeedsAdvanceState.listsAdvanced, verifyAllAdvanced],
      [newYear, false, const Duration(days: 1), FeedsAdvanceState.notAllRead, verifyNoneAdvanced],
      [newYear, true, const Duration(days: 0), FeedsAdvanceState.allReadAwaitingTomorrow, verifyNoneAdvanced],
      [newYear, true, const Duration(days: 1), FeedsAdvanceState.listsAdvanced, verifyAllAdvanced],
      [newYear, true, const Duration(days: 7), FeedsAdvanceState.listsAdvanced, verifyAllAdvanced],
    ],
    customDescriptionBuilder: (_, _, values) {
      return 'when areChaptersRead=${values[0]} and lastDateModified=(Now - ${values[1]}), expect ${values[2]}';
    },
    (
      DateTime date,
      bool areChaptersRead,
      Duration sinceLastModified,
      FeedsAdvanceState expectedAdvanceState,
      Function verify,
    ) async {
      when(mockDateTimeService.now).thenReturn(date);
      when(mockFeedsManager.areChaptersRead).thenReturn(areChaptersRead);
      when(mockFeedsManager.lastModifiedFeed).thenReturn(mockFeedList[0]);
      when(
        mockFeedList[0].state,
      ).thenReturn(FeedState(bookKey: b0.key, isRead: true, dateModified: date - sinceLastModified));
      expect(await testee.maybeAdvance(), expectedAdvanceState);
      verify();
    },
  );
}
