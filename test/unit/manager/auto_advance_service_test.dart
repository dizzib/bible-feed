import 'package:bible_feed/manager/auto_advance_service.dart';
import 'package:bible_feed/manager/feeds_advance_state.dart';
import 'package:bible_feed/manager/feeds_advance_service.dart';
import 'package:bible_feed/service/date_time_service.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auto_advance_service_test.mocks.dart';

@GenerateNiceMocks([MockSpec<DateTimeService>(), MockSpec<FeedsAdvanceService>()])
void main() {
  final mockDateTimeService = MockDateTimeService();
  late MockFeedsAdvanceService mockFeedsAdvanceService;

  setUp(() async {
    WidgetsFlutterBinding.ensureInitialized();
    when(mockDateTimeService.now).thenReturn(DateTime(2000, 1, 1, 23, 59));
    mockFeedsAdvanceService = MockFeedsAdvanceService();
  });

  test('constructor should call maybeAdvance', () async {
    AutoAdvanceService(mockDateTimeService, mockFeedsAdvanceService);
    verify(mockFeedsAdvanceService.maybeAdvance()).called(1);
  });

  test('at mignight, should call maybeAdvance and notify listeners if advanced', () async {
    await fakeAsync((fakeAsync) {
      when(mockFeedsAdvanceService.maybeAdvance()).thenAnswer((_) async => FeedsAdvanceState.listsAdvanced);
      var notified = false;
      AutoAdvanceService(mockDateTimeService, mockFeedsAdvanceService).addListener(() => notified = true);
      fakeAsync.elapse(const Duration(minutes: 1, seconds: 5));
      verify(mockFeedsAdvanceService.maybeAdvance()).called(2); // initial then timed
      expect(notified, true);
    });
  });
}
