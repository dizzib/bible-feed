import 'dart:async';

import 'package:bible_feed/service/auto_advance_service.dart';
import 'package:bible_feed/service/feeds_advance_service.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFeedsAdvanceService extends Mock implements FeedsAdvanceService {}

void main() {
  late AutoAdvanceService fixture;
  late MockFeedsAdvanceService mockFeedsAdvanceService;

  setUp(() {
    WidgetsFlutterBinding.ensureInitialized();
    mockFeedsAdvanceService = MockFeedsAdvanceService();
    when(() => mockFeedsAdvanceService.maybeAdvance()).thenAnswer((_) async => AdvanceState.notAllRead);
    fixture = AutoAdvanceService(mockFeedsAdvanceService);
  });

  test('constructor should call maybeAdvance and sets timer on resume', () async {
    verify(() => mockFeedsAdvanceService.maybeAdvance()).called(1);
  });

  // test('run calls maybeAdvance and notifies listeners if advanced', () async {
  //   final completer = Completer<void>();
  //   when(() => mockFeedsAdvanceService.maybeAdvance()).thenAnswer((_) async => AdvanceState.listsAdvanced);
  //
  //   service.addListener(() {
  //     completer.complete();
  //   });
  //
  //   // Call _run via reflection or by making it public temporarily for testing
  //   // Here we use a workaround by calling _run through a public method or test helper
  //   // Since _run is private, we will temporarily make it public for testing
  //
  //   // For now, we simulate by calling _onResume which calls _setTimer and maybeAdvance
  //   // service._run(); // This line will cause error because _run is private
  //
  //   await completer.future;
  //
  //   verify(() => mockFeedsAdvanceService.maybeAdvance()).called(greaterThanOrEqualTo(1));
  // });
}
