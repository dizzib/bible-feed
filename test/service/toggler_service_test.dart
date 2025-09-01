import 'package:bible_feed/service/toggler_service.dart';
import 'package:parameterized_test/parameterized_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

class TestTogglerService extends TogglerService {
  TestTogglerService(super.sharedPreferences);

  @override
  bool get canEnable => true;

  @override
  String get storeKey => 'test.key';

  @override
  String get subtitle => 'Test Subtitle';

  @override
  String get title => 'Test Title';
}

class TestCannotEnableTogglerService extends TestTogglerService {
  TestCannotEnableTogglerService(super.sharedPreferences);

  @override
  bool get canEnable => false;
}

void main() {
  late MockSharedPreferences mockSharedPreferences;
  late TestTogglerService testee;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    testee = TestTogglerService(mockSharedPreferences);
  });

  parameterizedTest('isEnabled getter', [
    [null, false],
    [true, true],
  ], (storeValue, expectValue) {
    when(() => mockSharedPreferences.getBool('test.key')).thenReturn(storeValue);
    expect(testee.isEnabled, expectValue);
  });

  test('if can enable, isEnabled setter stores value and notifies listeners', () {
    var notified = false;
    testee.addListener(() {
      notified = true;
    });
    when(() => mockSharedPreferences.setBool(any(), any())).thenAnswer((_) async => true);
    testee.isEnabled = true;
    verify(() => mockSharedPreferences.setBool('test.key', true)).called(1);
    expect(notified, true);
  });

  test('if cannot enable, isEnabled setter to true fails assertion', () {
    expect(() => TestCannotEnableTogglerService(mockSharedPreferences).isEnabled = true, throwsAssertionError);
  });
}
