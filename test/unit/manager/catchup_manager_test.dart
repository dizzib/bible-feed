import 'package:bible_feed/manager/catchup_manager.dart';
import 'package:bible_feed/manager/catchup_setting_manager.dart';
import 'package:bible_feed/manager/feeds_advance_manager.dart';
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
  MockSpec<CatchupSettingManager>(),
  MockSpec<DateTimeService>(),
  MockSpec<FeedsAdvanceManager>(),
  MockSpec<MidnightManager>(),
  MockSpec<StoreService>(),
])
void main() {
  late MockCatchupSettingManager mockCatchupSettingManager;
  late MockDateTimeService mockDateTimeService;
  late MockFeedsAdvanceManager mockFeedsAdvanceManager;
  late MockMidnightManager mockMidnightManager;
  late MockStoreService mockStoreService;
  late CatchupManager testee;

  late bool notified;
  final now = DateTime.now();

  setUp(() {
    WidgetsFlutterBinding.ensureInitialized(); // testee calls AppLifecycleListener

    mockCatchupSettingManager = MockCatchupSettingManager();
    mockDateTimeService = MockDateTimeService();
    mockFeedsAdvanceManager = MockFeedsAdvanceManager();
    mockMidnightManager = MockMidnightManager();
    mockStoreService = MockStoreService();
    notified = false;

    when(mockCatchupSettingManager.isEnabled).thenReturn(true);
    when(mockDateTimeService.now).thenReturn(now);

    testee = CatchupManager(
      mockCatchupSettingManager,
      mockDateTimeService,
      mockFeedsAdvanceManager,
      mockMidnightManager,
      mockStoreService,
    );

    testee.addListener(() => notified = true);
  });

  test('CatchupSettingManager listener should reset virtualAllDoneDate and notifyListeners', () {
    clearInteractions(mockStoreService); // ignore first call by ctor
    when(mockStoreService.getDateTime('virtualAllDoneDate')).thenReturn(now - 3.days);

    // Capture the listener callback passed to addListener
    late VoidCallback capturedListener;
    for (var listener in verify(mockCatchupSettingManager.addListener(captureAny)).captured) {
      capturedListener = listener as VoidCallback;
    }

    capturedListener(); // Trigger the listener manually

    verify(mockStoreService.setDateTime(any, now - 1.days)).called(1);
    expect(notified, isTrue);
  });

  parameterizedTest(
    'daysBehind, isBehind properties',
    [
      [false, null, 0, false, false],
      [false, now, 0, false, false],
      [false, now - 1.days, 0, false, false],
      [false, now - 2.days, 0, false, false],
      [false, now - 3.days, 0, false, false],
      [true, null, 0, false, false],
      [true, now, 0, false, false],
      [true, now - 1.days, 0, false, false],
      [true, now - 2.days, 1, true, false],
      [true, now - 3.days, 2, true, true],
      [true, now - 4.days, 3, true, true],
    ],
    (isSettingEnabled, virtualAllDoneDate, expectDaysBehind, expectIsBehind, expectIsVeryBehind) {
      when(mockCatchupSettingManager.isEnabled).thenReturn(isSettingEnabled);
      when(mockStoreService.getDateTime('virtualAllDoneDate')).thenReturn(virtualAllDoneDate ?? now - 1.days);
      expect(testee.daysBehind, expectDaysBehind);
      expect(testee.isBehind, expectIsBehind);
      expect(testee.isVeryBehind, expectIsVeryBehind);
    },
  );

  parameterizedTest(
    'FeedsAdvanceManager listener should advance virtualAllDoneDate and notifyListeners',
    [
      // [0.days, 0.days],
      // [1.days, 0.days],
      [2.days, 1.days],
      [3.days, 2.days],
    ],
    (daysBehind, expectNewDaysBehind) {
      clearInteractions(mockStoreService); // ignore first call by ctor
      when(mockStoreService.getDateTime('virtualAllDoneDate')).thenReturn(now - daysBehind);

      // Capture the listener callback passed to addListener
      late VoidCallback capturedListener;
      for (var listener in verify(mockFeedsAdvanceManager.addListener(captureAny)).captured) {
        capturedListener = listener as VoidCallback;
      }

      capturedListener(); // Trigger the listener manually

      verify(mockStoreService.setDateTime(any, now - expectNewDaysBehind)).called(1); // AllDoneManager listener
      expect(notified, isTrue);
    },
  );
}
