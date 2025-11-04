import 'package:bible_feed/manager/feeds_manager.dart' show FeedsManager;
import 'package:bible_feed/manager/sync_out_manager.dart';
import 'package:bible_feed/model/feed.dart';
import 'package:bible_feed/model/share_dto.dart';
import 'package:bible_feed/service/app_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../test_data.dart';
import 'sync_out_manager_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AppService>(), MockSpec<Feed>(), MockSpec<FeedsManager>()])
void main() {
  late MockAppService mockAppService;
  late MockFeedsManager mockFeedsManager;
  late SyncOutManager testee;

  setUp(() {
    mockAppService = MockAppService();
    mockFeedsManager = MockFeedsManager();
    testee = SyncOutManager(mockAppService, mockFeedsManager);
  });

  test('getJson returns correct JSON string', () {
    final feedState1 = FeedState(bookKey: b0.key, chapter: 1);
    final feedState2 = FeedState(bookKey: b1.key, chapter: 2);
    final mockFeed1 = MockFeed();
    final mockFeed2 = MockFeed();
    when(mockAppService.buildNumber).thenReturn('123');
    when(mockFeed1.state).thenReturn(feedState1);
    when(mockFeed2.state).thenReturn(feedState2);
    when(mockFeedsManager.feeds).thenReturn([mockFeed1, mockFeed2]);

    final expectDto = ShareDto(buildNumber: '123', feedStateList: [feedState1, feedState2]);
    expect(testee.getJson(), expectDto.toJson());
  });
}
