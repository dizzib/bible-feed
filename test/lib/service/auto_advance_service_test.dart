import 'dart:async';

import 'package:bible_feed/service/auto_advance_service.dart';
import 'package:bible_feed/service/feed_advance_state.dart';
import 'package:bible_feed/service/feeds_advance_service.dart';
import 'package:clock/clock.dart';
import 'package:dartx/dartx.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auto_advance_service_test.mocks.dart';

@GenerateNiceMocks([MockSpec<FeedsAdvanceService>()])
void main() {
  final mockFeedsAdvanceService = MockFeedsAdvanceService();
  late AutoAdvanceService testee;

  setUp(() async {
    WidgetsFlutterBinding.ensureInitialized();

    final now = DateTime.now();
    final midnightTonight = DateTime(now.year, now.month, now.day + 1);
    final durationToMidnight = midnightTonight.difference(now);
    final mockClock = Clock(() => DateTime.now() - const Duration(milliseconds: 100) + durationToMidnight);

    await withClock(mockClock, () async {
      testee = AutoAdvanceService(mockFeedsAdvanceService);
    });
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
