import 'package:bible_feed/manager/catchup_manager.dart';
import 'package:bible_feed/manager/feeds_manager.dart';
import 'package:bible_feed/manager/share_in_manager.dart';
import 'package:bible_feed/manager/feed_manager.dart';
import 'package:bible_feed/model/feed.dart';
import 'package:bible_feed/model/share_dto.dart';
import 'package:bible_feed/service/app_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../test_data.dart';
import 'share_in_manager_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<AppService>(),
  MockSpec<CatchupManager>(),
  MockSpec<FeedManager>(),
  MockSpec<FeedsManager>(),
])
void main() {
  late MockAppService mockAppService;
  late MockCatchupManager mockCatchupManager;
  late MockFeedsManager mockFeedsManager;
  late ShareInManager testee;

  final version = '1.2.3';
  final virtualAllDoneDate = DateTime(2025, 12, 30);

  setUpAll(() {
    provideDummy(rl0);
  });

  setUp(() {
    mockAppService = MockAppService();
    mockCatchupManager = MockCatchupManager();
    mockFeedsManager = MockFeedsManager();
    testee = ShareInManager(mockAppService, mockCatchupManager, mockFeedsManager);
  });

  test('sync throws exception on null or empty JSON', () {
    expect(() => testee.sync(null), throwsException);
    expect(() => testee.sync(''), throwsException);
  });

  test('sync throws exception on invalid JSON', () {
    expect(() => testee.sync('invalid json'), throwsException);
  });

  test('sync throws exception on mismatched version', () {
    final feed = Feed(bookKey: b0.key, chapter: 1);
    final shareDto = ShareDto(version: 'wrong_version', feedList: [feed], virtualAllDoneDate: virtualAllDoneDate);
    final json = shareDto.toJson();
    when(mockAppService.version).thenReturn('correct_version');
    expect(() => testee.sync(json), throwsException);
  });

  test('sync updates feed states and CatchupManager.virtualAllDoneDate on valid JSON with matching version', () {
    final feed1 = Feed(bookKey: b0.key, chapter: 1);
    final feed2 = Feed(bookKey: b1.key, chapter: 2);
    final shareDto = ShareDto(feedList: [feed1, feed2], version: version, virtualAllDoneDate: virtualAllDoneDate);
    final json = shareDto.toJson();
    final mockFeed1 = MockFeedManager();
    final mockFeed2 = MockFeedManager();

    when(mockAppService.version).thenReturn(version);
    when(mockCatchupManager.virtualAllDoneDate).thenReturn(virtualAllDoneDate);
    when(mockFeed1.readingList).thenReturn(rl0);
    when(mockFeed2.readingList).thenReturn(rl1);
    when(mockFeed1.book).thenReturn(b0);
    when(mockFeed2.book).thenReturn(b1);
    when(mockFeedsManager.feedManagers).thenReturn([mockFeed1, mockFeed2]);

    // AI fails to improve this code!?
    DateTime? capturedDate;
    when(mockCatchupManager.virtualAllDoneDate = any).thenAnswer((invocation) {
      capturedDate = invocation.positionalArguments[0] as DateTime;
    });

    testee.sync(json);

    verify(mockFeed1.feed = feed1).called(1);
    verify(mockFeed2.feed = feed2).called(1);
    expect(capturedDate?.millisecondsSinceEpoch, virtualAllDoneDate.millisecondsSinceEpoch);
  });

  test('sync rejects unknown book key and does not mutate any feed', () {
    final invalidFeed = Feed(bookKey: 'unknown', chapter: 1);
    final validFeed = Feed(bookKey: b1.key, chapter: 2);
    final shareDto = ShareDto(
      feedList: [invalidFeed, validFeed],
      version: version,
      virtualAllDoneDate: virtualAllDoneDate,
    );
    final json = shareDto.toJson();
    final mockFeed1 = MockFeedManager();
    final mockFeed2 = MockFeedManager();

    when(mockAppService.version).thenReturn(version);
    when(mockFeed1.readingList).thenReturn(rl0);
    when(mockFeed2.readingList).thenReturn(rl1);
    when(mockFeedsManager.feedManagers).thenReturn([mockFeed1, mockFeed2]);

    expect(() => testee.sync(json), throwsException);
    verifyNever(mockFeed1.feed = any);
    verifyNever(mockFeed2.feed = any);
    verifyNever(mockCatchupManager.virtualAllDoneDate = any);
  });

  test('sync validates all feeds before mutating any state', () {
    final validFeed = Feed(bookKey: b0.key, chapter: 1);
    final invalidFeed = Feed(bookKey: b1.key, chapter: 99);
    final shareDto = ShareDto(
      feedList: [validFeed, invalidFeed],
      version: version,
      virtualAllDoneDate: virtualAllDoneDate,
    );
    final json = shareDto.toJson();
    final mockFeed1 = MockFeedManager();
    final mockFeed2 = MockFeedManager();

    when(mockAppService.version).thenReturn(version);
    when(mockFeed1.readingList).thenReturn(rl0);
    when(mockFeed2.readingList).thenReturn(rl1);
    when(mockFeedsManager.feedManagers).thenReturn([mockFeed1, mockFeed2]);

    expect(() => testee.sync(json), throwsException);
    verifyNever(mockFeed1.feed = any);
    verifyNever(mockFeed2.feed = any);
    verifyNever(mockCatchupManager.virtualAllDoneDate = any);
  });
}
