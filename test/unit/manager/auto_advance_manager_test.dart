import 'package:bible_feed/manager/auto_advance_manager.dart';
import 'package:bible_feed/manager/feeds_advance_manager.dart';
import 'package:bible_feed/manager/feeds_advance_state.dart';
import 'package:bible_feed/service/date_time_service.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auto_advance_manager_test.mocks.dart';

@GenerateNiceMocks([MockSpec<DateTimeService>(), MockSpec<FeedsAdvanceManager>()])
void main() {
  final mockDateTimeService = MockDateTimeService();
  late MockFeedsAdvanceManager mockFeedsAdvanceManager;

  setUp(() async {
    WidgetsFlutterBinding.ensureInitialized();
    when(mockDateTimeService.now).thenReturn(DateTime(2000, 1, 1, 23, 59));
    mockFeedsAdvanceManager = MockFeedsAdvanceManager();
  });

  test('constructor should call maybeAdvance', () async {
    AutoAdvanceManager(mockDateTimeService, mockFeedsAdvanceManager);
    verify(mockFeedsAdvanceManager.maybeAdvance()).called(1);
  });

  test('at mignight, should call maybeAdvance and notify listeners if advanced', () async {
    await fakeAsync((fakeAsync) {
      when(mockFeedsAdvanceManager.maybeAdvance()).thenAnswer((_) async => FeedsAdvanceState.listsAdvanced);
      var notified = false;
      AutoAdvanceManager(mockDateTimeService, mockFeedsAdvanceManager).addListener(() => notified = true);
      fakeAsync.elapse(const Duration(minutes: 1, seconds: 5));
      verify(mockFeedsAdvanceManager.maybeAdvance()).called(2); // initial then timed
      expect(notified, true);
    });
  });
}
