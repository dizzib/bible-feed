import 'package:bible_feed/manager/toggler_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:parameterized_test/parameterized_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'toggler_manager_test.mocks.dart';

@GenerateNiceMocks([MockSpec<SharedPreferences>()])
class TestTogglerManager extends TogglerManager {
  TestTogglerManager(super.sharedPreferences);

  @override
  bool get canEnable => true;

  @override
  String get storeKey => 'test.key';

  @override
  String get subtitle => 'Test Subtitle';

  @override
  String get title => 'Test Title';
}

class TestCannotEnableTogglerManager extends TestTogglerManager {
  TestCannotEnableTogglerManager(super.sharedPreferences);

  @override
  bool get canEnable => false;
}

void main() {
  late MockSharedPreferences mockSharedPreferences;
  late TestTogglerManager testee;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    testee = TestTogglerManager(mockSharedPreferences);
  });

  parameterizedTest(
    'isEnabled getter',
    [
      [null, false],
      [true, true],
    ],
    (storeValue, expectValue) {
      when(mockSharedPreferences.getBool('test.key')).thenReturn(storeValue);
      expect(testee.isEnabled, expectValue);
    },
  );

  test('if can enable, isEnabled setter stores value and notifies listeners', () {
    var notified = false;
    testee.addListener(() {
      notified = true;
    });
    testee.isEnabled = true;
    verify(mockSharedPreferences.setBool('test.key', true)).called(1);
    expect(notified, true);
  });

  test('if cannot enable, isEnabled setter to true fails assertion', () {
    expect((() => TestCannotEnableTogglerManager(mockSharedPreferences).isEnabled = true), throwsAssertionError);
  });
}
