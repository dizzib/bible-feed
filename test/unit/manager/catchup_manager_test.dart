import 'package:bible_feed/manager/all_done_manager.dart';
import 'package:bible_feed/manager/catchup_manager.dart';
import 'package:bible_feed/manager/catchup_setting_manager.dart';
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
  MockSpec<CatchupSettingManager>(),
  MockSpec<DateTimeService>(),
  MockSpec<MidnightManager>(),
  MockSpec<StoreService>(),
])
void main() {
  final now = DateTime.now();

  late MockAllDoneManager mockAllDoneManager;
  late MockCatchupSettingManager mockCatchupSettingManager;
  late MockDateTimeService mockDateTimeService;
  late MockMidnightManager mockMidnightManager;
  late MockStoreService mockStoreService;
  late CatchupManager testee;

  setUp(() {
    WidgetsFlutterBinding.ensureInitialized(); // testee calls AppLifecycleListener

    mockAllDoneManager = MockAllDoneManager();
    mockCatchupSettingManager = MockCatchupSettingManager();
    mockDateTimeService = MockDateTimeService();
    mockMidnightManager = MockMidnightManager();
    mockStoreService = MockStoreService();

    when(mockCatchupSettingManager.isEnabled).thenReturn(true);
    when(mockDateTimeService.now).thenReturn(now);

    testee = CatchupManager(
      mockAllDoneManager,
      mockCatchupSettingManager,
      mockDateTimeService,
      mockMidnightManager,
      mockStoreService,
    );
  });

  parameterizedTest(
    'daysBehind, isBehind properties',
    [
      [false, null, 0, false],
      [false, now, 0, false],
      [false, now - 1.days, 0, false],
      [false, now - 2.days, 0, false],
      [false, now - 3.days, 0, false],
      [true, null, 0, false],
      [true, now, 0, false],
      [true, now - 1.days, 0, false],
      [true, now - 2.days, 1, true],
      [true, now - 3.days, 2, true],
    ],
    (isSettingEnabled, virtualAllDoneDate, expectDaysBehind, expectIsBehind) {
      when(mockCatchupSettingManager.isEnabled).thenReturn(isSettingEnabled);
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
