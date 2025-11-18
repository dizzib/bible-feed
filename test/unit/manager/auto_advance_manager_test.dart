import 'package:bible_feed/manager/auto_advance_manager.dart';
import 'package:bible_feed/manager/feeds_advance_manager.dart';
import 'package:bible_feed/manager/midnight_manager.dart';
import 'package:bible_feed/model/feeds_advance_state.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auto_advance_manager_test.mocks.dart';

@GenerateNiceMocks([MockSpec<FeedsAdvanceManager>(), MockSpec<MidnightManager>()])
void main() {
  late MockFeedsAdvanceManager mockFeedsAdvanceManager;
  late MockMidnightManager mockMidnightManager;

  setUp(() async {
    WidgetsFlutterBinding.ensureInitialized();
    mockFeedsAdvanceManager = MockFeedsAdvanceManager();
    mockMidnightManager = MockMidnightManager();
  });

  test('constructor should call maybeAdvance', () async {
    AutoAdvanceManager(mockFeedsAdvanceManager, mockMidnightManager);
    verify(mockFeedsAdvanceManager.maybeAdvance()).called(1);
  });

  test('at mignight, should call maybeAdvance and notify listeners if advanced', () async {
    when(mockFeedsAdvanceManager.maybeAdvance()).thenAnswer((_) async => FeedsAdvanceState.listsAdvanced);
    when(mockMidnightManager.addListener(any)).thenAnswer((invocation) {
      final listener = invocation.positionalArguments[0] as void Function();
      listener(); // Simulate listener call immediately for testing
    });

    var notified = false;
    AutoAdvanceManager(mockFeedsAdvanceManager, mockMidnightManager).addListener(() => notified = true);

    verify(mockFeedsAdvanceManager.maybeAdvance()).called(2); // initial then timed
    await Future.delayed(Duration.zero); // Wait for async listener to complete
    expect(notified, true);
  });
}
