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
  late AutoAdvanceService fixture;
  late MockFeedsAdvanceService mockFeedsAdvanceService;

  setUp(() async {
    WidgetsFlutterBinding.ensureInitialized();

    mockFeedsAdvanceService = MockFeedsAdvanceService();
    when(() => mockFeedsAdvanceService.maybeAdvance()).thenAnswer((_) async => AdvanceState.notAllRead);

    final now = DateTime.now();
    final midnightTonight = DateTime(now.year, now.month, now.day + 1);
    final durationToMidnight = midnightTonight.difference(now);
    final mockClock = Clock(() => DateTime.now() - const Duration(seconds: 1) + durationToMidnight);

    await withClock(mockClock, () async {
      fixture = AutoAdvanceService(mockFeedsAdvanceService);
    });
  });

  test('constructor should call maybeAdvance and sets timer on resume', () async {
    verify(() => mockFeedsAdvanceService.maybeAdvance()).called(1);
  });

  test('_run calls maybeAdvance and notifies listeners if advanced', () async {
    final completer = Completer<void>();
    when(() => mockFeedsAdvanceService.maybeAdvance()).thenAnswer((_) async => AdvanceState.listsAdvanced);

    fixture.addListener(() {
      completer.complete();
    });

    await completer.future;
    verify(() => mockFeedsAdvanceService.maybeAdvance()).called(greaterThanOrEqualTo(1));
  });
}
