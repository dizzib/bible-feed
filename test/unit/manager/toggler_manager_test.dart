import 'package:bible_feed/manager/toggler_manager.dart';
import 'package:bible_feed/service/store_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:parameterized_test/parameterized_test.dart';

import 'toggler_manager_test.mocks.dart';

@GenerateNiceMocks([MockSpec<StoreService>()])
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
  late MockStoreService mockStoreService;
  late TestTogglerManager testee;

  setUp(() {
    mockStoreService = MockStoreService();
    testee = TestTogglerManager(mockStoreService);
  });

  parameterizedTest(
    'isEnabled getter',
    [
      [null, false],
      [true, true],
    ],
    (storeValue, expectValue) {
      when(mockStoreService.getBool('test.key')).thenReturn(storeValue);
      expect(testee.isEnabled, expectValue);
    },
  );

  test('if can enable, isEnabled setter stores value and notifies listeners', () {
    var notified = false;
    testee.addListener(() {
      notified = true;
    });
    testee.isEnabled = true;
    verify(mockStoreService.setBool('test.key', true)).called(1);
    expect(notified, true);
  });

  test('if cannot enable, isEnabled setter to true fails assertion', () {
    expect((() => TestCannotEnableTogglerManager(mockStoreService).isEnabled = true), throwsAssertionError);
  });
}
