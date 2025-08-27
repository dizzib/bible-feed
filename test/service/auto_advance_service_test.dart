import 'dart:async';

import 'package:bible_feed/service/auto_advance_service.dart';
import 'package:bible_feed/service/feeds_advance_service.dart';
import 'package:clock/clock.dart';
import 'package:dartx/dartx.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFeedsAdvanceService extends Mock implements FeedsAdvanceService {}

void main() {
  late AutoAdvanceService testee;
  late MockFeedsAdvanceService mockFeedsAdvanceService;

  setUp(() async {
    WidgetsFlutterBinding.ensureInitialized();

    mockFeedsAdvanceService = MockFeedsAdvanceService();
    when(() => mockFeedsAdvanceService.maybeAdvance()).thenAnswer((_) async => AdvanceState.notAllRead);

    final now = DateTime.now();
    final midnightTonight = DateTime(now.year, now.month, now.day + 1);
    final durationToMidnight = midnightTonight.difference(now);
    final mockClock = Clock(() => DateTime.now() - const Duration(milliseconds: 10) + durationToMidnight);

    await withClock(mockClock, () async {
      testee = AutoAdvanceService(mockFeedsAdvanceService);
    });
  });

  test('constructor should call maybeAdvance', () async {
    verify(() => mockFeedsAdvanceService.maybeAdvance()).called(1);
  });

  test('_run should call maybeAdvance and notify listeners if advanced', () async {
    when(() => mockFeedsAdvanceService.maybeAdvance()).thenAnswer((_) async => AdvanceState.listsAdvanced);
    final completer = Completer<void>();
    testee.addListener(completer.complete);
    await completer.future;
    verify(() => mockFeedsAdvanceService.maybeAdvance()).called(greaterThanOrEqualTo(1));
  });
}
