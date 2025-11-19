import 'package:bible_feed/manager/days_behind_manager.dart';
import 'package:bible_feed/service/date_time_service.dart';
import 'package:bible_feed/manager/feeds_advance_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'days_behind_manager_test.mocks.dart';

@GenerateNiceMocks([MockSpec<DateTimeService>(), MockSpec<FeedsAdvanceManager>()])
void main() {
  late MockDateTimeService mockDateTimeService;
  late MockFeedsAdvanceManager mockFeedsAdvanceManager;
  late DaysBehindManager testee;

  setUp(() {
    mockDateTimeService = MockDateTimeService();
    mockFeedsAdvanceManager = MockFeedsAdvanceManager();
    when(mockDateTimeService.now).thenReturn(DateTime(2025, 11, 19));
    testee = DaysBehindManager(mockDateTimeService, mockFeedsAdvanceManager);
  });

  test('daysBehind returns 0 if lastAdvanceDateTime is null', () {
    when(mockFeedsAdvanceManager.lastAdvanceDate).thenReturn(null);
    expect(testee.daysBehind, 0);
  });

  test('daysBehind returns correct difference in days', () {
    when(mockFeedsAdvanceManager.lastAdvanceDate).thenReturn(DateTime(2025, 11, 18));
    expect(testee.daysBehind, 1);
  });
}
