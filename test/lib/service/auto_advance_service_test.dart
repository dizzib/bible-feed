import 'dart:async';

import 'package:bible_feed/service/auto_advance_service.dart';
import 'package:bible_feed/service/date_time_service.dart';
import 'package:bible_feed/service/feed_advance_state.dart';
import 'package:bible_feed/service/feeds_advance_service.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auto_advance_service_test.mocks.dart';

@GenerateNiceMocks([MockSpec<DateTimeService>(), MockSpec<FeedsAdvanceService>()])
void main() {
  final mockDateTimeService = MockDateTimeService();
  final mockFeedsAdvanceService = MockFeedsAdvanceService();
  late AutoAdvanceService testee;

  setUp(() async {
    WidgetsFlutterBinding.ensureInitialized();
    when(mockDateTimeService.now).thenReturn(DateTime(2000, 1, 1, 23, 59, 59, 900));
    testee = AutoAdvanceService(mockDateTimeService, mockFeedsAdvanceService);
  });

  test('constructor should call maybeAdvance', () async {
    verify(mockFeedsAdvanceService.maybeAdvance()).called(1);
  });

  test('_run should call maybeAdvance and notify listeners if advanced', () async {
    when(mockFeedsAdvanceService.maybeAdvance()).thenAnswer((_) async => FeedAdvanceState.listsAdvanced);
    final completer = Completer<void>();
    testee.addListener(completer.complete);
    await completer.future;
    verify(mockFeedsAdvanceService.maybeAdvance()).called(greaterThanOrEqualTo(1));
  });
}
