import 'package:bible_feed/manager/feed_store_manager.dart';
import 'package:bible_feed/manager/feeds_manager.dart';
import 'package:bible_feed/manager/share_in_manager.dart';
import 'package:bible_feed/manager/share_out_manager.dart';
import 'package:bible_feed/model/reading_lists.dart';
import 'package:bible_feed/service/app_service.dart';
import 'package:bible_feed/service/store_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../test_data.dart';
import 'share_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AppService>(), MockSpec<StoreService>()])
void main() {
  final dateModified = DateTime.now();
  final readingLists = ReadingLists([rl0, rl1]);
  late MockAppService mockAppService;
  late MockStoreService mockInStoreService;
  late MockStoreService mockOutStoreService;
  late FeedsManager inFeedsManager;
  late FeedsManager outFeedsManager;
  late ShareInManager shareInManager;
  late ShareOutManager shareOutManager;

  setUp(() {
    mockAppService = MockAppService();
    mockInStoreService = MockStoreService();
    mockOutStoreService = MockStoreService();
  });

  test('sync-out sync-in interaction: should transfer across', () {
    when(mockOutStoreService.getString('rl1.dateModified')).thenReturn(dateModified.toIso8601String());
    when(mockOutStoreService.getString('rl1.book')).thenReturn('b1');
    when(mockOutStoreService.getInt('rl1.chapter')).thenReturn(3);
    when(mockOutStoreService.getInt('rl1.verse')).thenReturn(5);
    when(mockOutStoreService.getBool('rl1.isRead')).thenReturn(true);
    when(mockAppService.buildNumber).thenReturn('123');
    inFeedsManager = FeedsManager(FeedStoreManager(mockInStoreService), readingLists);
    outFeedsManager = FeedsManager(FeedStoreManager(mockOutStoreService), readingLists);
    shareInManager = ShareInManager(mockAppService, inFeedsManager);
    shareOutManager = ShareOutManager(mockAppService, outFeedsManager);
    shareInManager.sync(shareOutManager.getJson());
    final state0 = outFeedsManager.feeds[0].state;
    final state1 = outFeedsManager.feeds[1].state;
    expect(state0.bookKey, b0.key);
    expect(state0.chapter, 1);
    expect(state0.verse, 1);
    expect(state0.isRead, false);
    expect(state0.dateModified, null);
    expect(state1.bookKey, b1.key);
    expect(state1.chapter, 3);
    expect(state1.verse, 5);
    expect(state1.isRead, true);
    expect(state1.dateModified, dateModified);
  });
}
