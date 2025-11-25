import 'package:bible_feed/manager/catchup_manager.dart';
import 'package:bible_feed/manager/catchup_setting_manager.dart';
import 'package:bible_feed/manager/feeds_advance_manager.dart';
import 'package:bible_feed/manager/feeds_manager.dart';
import 'package:bible_feed/manager/midnight_manager.dart';
import 'package:bible_feed/model/feed.dart';
import 'package:bible_feed/service/date_time_service.dart';
import 'package:bible_feed/service/store_service.dart';
import 'package:dartx/dartx.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:parameterized_test/parameterized_test.dart';

import '../test_data.dart';
import 'catchup_manager_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<CatchupSettingManager>(),
  MockSpec<DateTimeService>(),
  MockSpec<FeedsManager>(),
  MockSpec<FeedsAdvanceManager>(),
  MockSpec<MidnightManager>(),
  MockSpec<StoreService>(),
])
void main() {
  late MockCatchupSettingManager mockCatchupSettingManager;
  late MockDateTimeService mockDateTimeService;
  late MockFeedsManager mockFeedsManager;
  late MockFeedsAdvanceManager mockFeedsAdvanceManager;
  late MockMidnightManager mockMidnightManager;
  late MockStoreService mockStoreService;
  late CatchupManager testee;

  late bool notified;
  final today = DateTime.now().date;

  setUp(() {
    WidgetsFlutterBinding.ensureInitialized(); // testee calls AppLifecycleListener

    mockCatchupSettingManager = MockCatchupSettingManager();
    mockDateTimeService = MockDateTimeService();
    mockFeedsManager = MockFeedsManager();
    mockFeedsAdvanceManager = MockFeedsAdvanceManager();
    mockMidnightManager = MockMidnightManager();
    mockStoreService = MockStoreService();
    notified = false;

    when(mockCatchupSettingManager.isEnabled).thenReturn(true);
    when(mockDateTimeService.now).thenReturn(DateTime.now());
    when(mockFeedsManager.chaptersToRead).thenReturn(7);
    when(mockFeedsManager.feeds).thenReturn(List.filled(10, Feed(rl0, FeedState(bookKey: ''))));

    testee = CatchupManager(
      mockCatchupSettingManager,
      mockDateTimeService,
      mockFeedsManager,
      mockFeedsAdvanceManager,
      mockMidnightManager,
      mockStoreService,
    );

    testee.addListener(() => notified = true);
  });

  test('CatchupSettingManager listener should reset virtualAllDoneDate to default and notifyListeners', () {
    clearInteractions(mockStoreService); // ignore first call by ctor
    when(mockStoreService.getDateTime('virtualAllDoneDate')).thenReturn(today - 3.days);

    // Capture the listener callback passed to addListener
    late VoidCallback capturedListener;
    for (var listener in verify(mockCatchupSettingManager.addListener(captureAny)).captured) {
      capturedListener = listener as VoidCallback;
    }

    capturedListener(); // Trigger the listener manually

    verify(mockStoreService.setDateTime(any, today - 1.days)).called(1);
    expect(notified, isTrue);
  });

  parameterizedTest(
    'daysBehind, isBehind properties',
    [
      [false, null, 0, 7, false, false],
      [false, today, 0, 7, false, false],
      [false, today - 1.days, 0, 7, false, false],
      [false, today - 2.days, 0, 7, false, false],
      [false, today - 3.days, 0, 7, false, false],
      [true, null, 0, 7, false, false],
      [true, today, 0, 7, false, false],
      [true, today - 1.days, 0, 7, false, false],
      [true, today - 2.days, 1, 17, true, false],
      [true, today - 3.days, 2, 27, true, true],
      [true, today - 4.days, 3, 37, true, true],
    ],
    (isSettingEnabled, virtualAllDoneDate, expectDaysBehind, expectChaptersToRead, expectIsBehind, expectIsVeryBehind) {
      when(mockCatchupSettingManager.isEnabled).thenReturn(isSettingEnabled);
      when(mockStoreService.getDateTime('virtualAllDoneDate')).thenReturn(virtualAllDoneDate ?? today - 1.days);
      expect(testee.daysBehind, expectDaysBehind);
      expect(testee.chaptersToRead, expectChaptersToRead);
      expect(testee.isBehind, expectIsBehind);
      expect(testee.isVeryBehind, expectIsVeryBehind);
    },
  );

  parameterizedTest(
    'FeedsAdvanceManager listener should advance virtualAllDoneDate and notifyListeners',
    [
      [0.days, 0.days],
      [1.days, 0.days],
      [2.days, 1.days],
      [3.days, 2.days],
    ],
    (daysBehind, expectNewDaysBehind) {
      clearInteractions(mockStoreService); // ignore first call by ctor
      when(mockStoreService.getDateTime('virtualAllDoneDate')).thenReturn(today - daysBehind);

      // Capture the listener callback passed to addListener
      late VoidCallback capturedListener;
      for (var listener in verify(mockFeedsAdvanceManager.addListener(captureAny)).captured) {
        capturedListener = listener as VoidCallback;
      }

      capturedListener(); // Trigger the listener manually

      verify(mockStoreService.setDateTime(any, today - expectNewDaysBehind)).called(1); // AllDoneManager listener
      expect(notified, isTrue);
    },
  );
}
