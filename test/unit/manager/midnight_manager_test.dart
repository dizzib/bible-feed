import 'package:bible_feed/manager/midnight_manager.dart';
import 'package:bible_feed/service/date_time_service.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'midnight_manager_test.mocks.dart';

@GenerateNiceMocks([MockSpec<DateTimeService>()])
void main() {
  final mockDateTimeService = MockDateTimeService();

  setUp(() async {
    WidgetsFlutterBinding.ensureInitialized();
    when(mockDateTimeService.now).thenReturn(DateTime(2000, 1, 1, 23, 59));
  });

  test('at mignight, should notify listeners', () async {
    await fakeAsync((fakeAsync) {
      var notified = false;
      MidnightManager(mockDateTimeService).addListener(() => notified = true);
      fakeAsync.elapse(const Duration(minutes: 1, seconds: 5));
      expect(notified, true);
    });
  });
}
