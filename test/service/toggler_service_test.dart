import 'package:bible_feed/service/toggler_service.dart';
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

class TestUnavailableTogglerService extends TestTogglerService {
  TestUnavailableTogglerService(super.sharedPreferences);

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

  test('isEnabled default is false', () {
    when(() => mockSharedPreferences.getBool(any())).thenReturn(null);
    expect(testee.isEnabled, false);
  });

  test('isEnabled getter returns stored value', () {
    when(() => mockSharedPreferences.getBool('test.key')).thenReturn(true);
    expect(testee.isEnabled, true);
  });

  test('isEnabled setter stores value and notifies listeners', () {
    var notified = false;
    testee.addListener(() {
      notified = true;
    });

    when(() => mockSharedPreferences.setBool(any(), any())).thenAnswer((_) async => true);
    testee.isEnabled = true;

    verify(() => mockSharedPreferences.setBool('test.key', true)).called(1);
    expect(notified, true);
  });

  test('isEnabled setter to true throws error if unavailable', () {
    expect(() => TestUnavailableTogglerService(mockSharedPreferences).isEnabled = true, throwsAssertionError);
  });
}
