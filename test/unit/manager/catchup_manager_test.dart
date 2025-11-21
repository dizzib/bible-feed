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
    WidgetsFlutterBinding.ensureInitialized(); // testee calls AppLifecycleListener

    mockAllDoneManager = MockAllDoneManager();
    mockDateTimeService = MockDateTimeService();
    mockMidnightManager = MockMidnightManager();
    mockStoreService = MockStoreService();

    when(mockDateTimeService.now).thenReturn(now);

    testee = CatchupManager(mockAllDoneManager, mockDateTimeService, mockMidnightManager, mockStoreService);
  });

  parameterizedTest(
    'daysBehind, isBehind properties',
    [
      [null, 0, false],
      [now, 0, false],
      [now - 1.days, 0, false],
      [now - 2.days, 1, true],
      [now - 3.days, 2, true],
    ],
    (virtualAllDoneDate, expectDaysBehind, expectIsBehind) {
      when(mockStoreService.getDateTime('virtualAllDoneDate')).thenReturn(virtualAllDoneDate ?? now - 1.days);
      expect(testee.daysBehind, expectDaysBehind);
      expect(testee.isBehind, expectIsBehind);
    },
  );

  parameterizedTest(
    'AllDoneManager listener should advance virtualAllDoneDate and notifyListeners',
    [
      [0.days, 0.days],
      [1.days, 0.days],
      [2.days, 1.days],
      [3.days, 2.days],
    ],
    (daysBehind, expectNewDaysBehind) {
      var notified = false;
      testee.addListener(() => notified = true);

      clearInteractions(mockStoreService); // ignore first call by ctor
      when(mockStoreService.getDateTime('virtualAllDoneDate')).thenReturn(now - daysBehind);
      when(mockAllDoneManager.allDoneDate).thenReturn(now);

      // Capture the listener callback passed to addListener
      late VoidCallback capturedListener;
      for (var listener in verify(mockAllDoneManager.addListener(captureAny)).captured) {
        capturedListener = listener as VoidCallback;
      }

      capturedListener(); // Trigger the listener manually

      verify(mockStoreService.setDateTime(any, now - expectNewDaysBehind)).called(1); // AllDoneManager listener
      expect(notified, isTrue);
    },
  );
}
