import 'package:bible_feed/manager/all_done_manager.dart';
import 'package:bible_feed/manager/catchup_manager.dart';
import 'package:bible_feed/manager/midnight_manager.dart';
import 'package:bible_feed/service/date_time_service.dart';
import 'package:bible_feed/manager/feeds_advance_manager.dart';
import 'package:bible_feed/service/store_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:parameterized_test/parameterized_test.dart';

import 'catchup_manager_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<AllDoneManager>(),
  MockSpec<DateTimeService>(),
  MockSpec<FeedsAdvanceManager>(),
  MockSpec<MidnightManager>(),
  MockSpec<StoreService>(),
])
void main() {
  late MockAllDoneManager mockAllDoneManager;
  late MockDateTimeService mockDateTimeService;
  late MockFeedsAdvanceManager mockFeedsAdvanceManager;
  late MockMidnightManager mockMidnightManager;
  late MockStoreService mockStoreService;
  late CatchupManager testee;

  setUp(() {
    mockAllDoneManager = MockAllDoneManager();
    mockDateTimeService = MockDateTimeService();
    mockFeedsAdvanceManager = MockFeedsAdvanceManager();
    mockMidnightManager = MockMidnightManager();
    mockStoreService = MockStoreService();
    when(mockDateTimeService.now).thenReturn(DateTime(2025, 1, 5, 12));
    testee = CatchupManager(
      mockAllDoneManager,
      mockDateTimeService,
      mockFeedsAdvanceManager,
      mockMidnightManager,
      mockStoreService,
    );
  });

  parameterizedTest(
    'daysBehind',
    [
      [null, 0],
      [DateTime(2025, 1, 5, 12), 0],
      [DateTime(2025, 1, 4, 12), 0],
      [DateTime(2025, 1, 3, 12), 1],
      [DateTime(2025, 1, 2, 12), 2],
    ],
    (virtualAllDoneDate, expectResult) {
      when(mockStoreService.getDateTime('virtualAllDoneDate')).thenReturn(virtualAllDoneDate);
      expect(testee.daysBehind, expectResult);
    },
  );
}
