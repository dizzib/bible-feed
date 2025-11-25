import 'package:bible_feed/manager/feeds_manager.dart';
import 'package:bible_feed/manager/share_in_manager.dart';
import 'package:bible_feed/model/feed.dart';
import 'package:bible_feed/model/share_dto.dart';
import 'package:bible_feed/service/app_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../test_data.dart';
import 'share_in_manager_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AppService>(), MockSpec<Feed>(), MockSpec<FeedsManager>()])
void main() {
  late MockAppService mockAppService;
  late MockFeedsManager mockFeedsManager;
  late ShareInManager testee;

  setUp(() {
    mockAppService = MockAppService();
    mockFeedsManager = MockFeedsManager();
    testee = ShareInManager(mockAppService, mockFeedsManager);
  });

  test('sync throws exception on null or empty JSON', () {
    expect(() => testee.sync(null), throwsException);
    expect(() => testee.sync(''), throwsException);
  });

  test('sync throws exception on invalid JSON', () {
    expect(() => testee.sync('invalid json'), throwsException);
  });

  test('sync throws exception on mismatched build number', () {
    final feedState = FeedState(bookKey: b0.key, chapter: 1);
    final syncDto = ShareDto(buildNumber: 'wrong_build', feedStateList: [feedState]);
    final json = syncDto.toJson();
    when(mockAppService.buildNumber).thenReturn('correct_build');
    expect(() => testee.sync(json), throwsException);
  });

  test('sync updates feed states on valid JSON with matching build number', () {
    final feedState1 = FeedState(bookKey: b0.key, chapter: 1);
    final feedState2 = FeedState(bookKey: b1.key, chapter: 2);
    final syncDto = ShareDto(buildNumber: 'correct_build', feedStateList: [feedState1, feedState2]);
    final json = syncDto.toJson();
    final mockFeed1 = MockFeed();
    final mockFeed2 = MockFeed();
    when(mockFeed1.book).thenReturn(b0);
    when(mockFeed2.book).thenReturn(b1);
    when(mockFeedsManager.feeds).thenReturn([mockFeed1, mockFeed2]);
    when(mockAppService.buildNumber).thenReturn('correct_build');

    testee.sync(json);

    verify(mockFeed1.state = feedState1).called(1);
    verify(mockFeed2.state = feedState2).called(1);
  });
}
