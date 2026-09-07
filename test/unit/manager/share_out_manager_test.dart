import 'package:bible_feed/manager/catchup_manager.dart';
import 'package:bible_feed/manager/feed_manager.dart';
import 'package:bible_feed/manager/feeds_manager.dart' show FeedsManager;
import 'package:bible_feed/manager/share_out_manager.dart';
import 'package:bible_feed/model/feed.dart';
import 'package:bible_feed/model/share_dto.dart';
import 'package:bible_feed/service/app_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../test_data.dart';
import 'share_out_manager_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AppService>(), MockSpec<CatchupManager>(), MockSpec<FeedManager>(), MockSpec<FeedsManager>()])
void main() {
  late MockAppService mockAppService;
  late MockCatchupManager mockCatchupManager;
  late MockFeedsManager mockFeedsManager;
  late ShareOutManager testee;

  setUp(() {
    mockAppService = MockAppService();
    mockCatchupManager = MockCatchupManager();
    mockFeedsManager = MockFeedsManager();
    testee = ShareOutManager(mockAppService, mockCatchupManager, mockFeedsManager);
  });

  test('getJson returns correct JSON string', () {
    final feed1 = Feed(bookKey: b0.key, chapter: 1);
    final feed2 = Feed(bookKey: b1.key, chapter: 2);
    final feedManager1 = FeedManager(rl0, feed1);
    final feedManager2 = FeedManager(rl1, feed2);

    final buildNumber = '1.2.3';
    final virtualAllDoneDate = DateTime(2025, 12, 30);

    when(mockAppService.version).thenReturn(buildNumber);
    when(mockCatchupManager.virtualAllDoneDate).thenReturn(virtualAllDoneDate);
    when(mockFeedsManager.feedManagers).thenReturn([feedManager1, feedManager2]);

    final expectDto = ShareDto(
      version: buildNumber,
      feedList: [feed1, feed2],
      virtualAllDoneDate: virtualAllDoneDate,
    );
    expect(testee.getJson(), expectDto.toJson());
  });
}
