import 'package:bible_feed/manager/app_lifecycle_manager.dart';
import 'package:bible_feed/manager/auto_advance_manager.dart';
import 'package:bible_feed/manager/feeds_advance_manager.dart';
import 'package:bible_feed/manager/midnight_manager.dart';
import 'package:bible_feed/model/feeds_advance_state.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auto_advance_manager_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AppLifecycleManager>(), MockSpec<FeedsAdvanceManager>(), MockSpec<MidnightManager>()])
void main() {
  late MockAppLifecycleManager mockAppLifecycleManager;
  late MockFeedsAdvanceManager mockFeedsAdvanceManager;
  late MockMidnightManager mockMidnightManager;

  setUp(() async {
    WidgetsFlutterBinding.ensureInitialized();
    mockAppLifecycleManager = MockAppLifecycleManager();
    mockFeedsAdvanceManager = MockFeedsAdvanceManager();
    mockMidnightManager = MockMidnightManager();
  });

  test('constructor should call maybeAdvance', () async {
    AutoAdvanceManager(mockAppLifecycleManager, mockFeedsAdvanceManager, mockMidnightManager);
    verify(mockFeedsAdvanceManager.maybeAdvance()).called(1);
  });

  test('at midnight, should call maybeAdvance and notify listeners if advanced', () async {
    late Function() listener;

    when(mockFeedsAdvanceManager.maybeAdvance()).thenReturn(FeedsAdvanceState.listsAdvanced);
    when(mockMidnightManager.addListener(any)).thenAnswer((invocation) {
      listener = invocation.positionalArguments[0] as void Function();
    });

    var notified = false;
    final testee = AutoAdvanceManager(mockAppLifecycleManager, mockFeedsAdvanceManager, mockMidnightManager);
    testee.addListener(() => notified = true);
    listener();

    verify(mockFeedsAdvanceManager.maybeAdvance()).called(2); // initial then timed
    expect(notified, true);
  });
}
