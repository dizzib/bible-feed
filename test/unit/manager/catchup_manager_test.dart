import 'package:bible_feed/manager/all_done_manager.dart';
import 'package:bible_feed/manager/catchup_manager.dart';
import 'package:bible_feed/manager/midnight_manager.dart';
import 'package:bible_feed/service/date_time_service.dart';
import 'package:bible_feed/service/store_service.dart';
import 'package:dartx/dartx.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:parameterized_test/parameterized_test.dart';

import 'catchup_manager_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<AllDoneManager>(),
  MockSpec<DateTimeService>(),
  MockSpec<MidnightManager>(),
  MockSpec<StoreService>(),
])
void main() {
  final now = DateTime.now();

  late MockAllDoneManager mockAllDoneManager;
  late MockDateTimeService mockDateTimeService;
  late MockMidnightManager mockMidnightManager;
  late MockStoreService mockStoreService;
  late CatchupManager testee;

  setUp(() {
    WidgetsFlutterBinding.ensureInitialized();

    mockAllDoneManager = MockAllDoneManager();
    mockDateTimeService = MockDateTimeService();
    mockMidnightManager = MockMidnightManager();
    mockStoreService = MockStoreService();

    when(mockDateTimeService.now).thenReturn(now);

    testee = CatchupManager(mockAllDoneManager, mockDateTimeService, mockMidnightManager, mockStoreService);
  });

  parameterizedTest(
    'daysBehind',
    [
      [null, 0],
      [now, 0],
      [now - 1.days, 0],
      [now - 2.days, 1],
      [now - 3.days, 2],
    ],
    (virtualAllDoneDate, expectResult) {
      when(mockStoreService.getDateTime('virtualAllDoneDate')).thenReturn(virtualAllDoneDate ?? now - 1.days);
      expect(testee.daysBehind, expectResult);
    },
  );
}
