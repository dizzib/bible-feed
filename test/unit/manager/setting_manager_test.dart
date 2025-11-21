import 'package:bible_feed/manager/setting_manager.dart';
import 'package:bible_feed/service/store_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:parameterized_test/parameterized_test.dart';

import 'setting_manager_test.mocks.dart';

@GenerateNiceMocks([MockSpec<StoreService>()])
class TestSettingManager extends SettingManager {
  TestSettingManager(super.sharedPreferences);

  @override
  bool get canEnable => true;

  @override
  bool get isEnabledByDefault => false;

  @override
  String get storeKey => 'test.key';

  @override
  String get subtitle => 'Test Subtitle';

  @override
  String get title => 'Test Title';
}

class TestCannotEnableSettingManager extends TestSettingManager {
  TestCannotEnableSettingManager(super.sharedPreferences);

  @override
  bool get canEnable => false;
}

void main() {
  late MockStoreService mockStoreService;
  late TestSettingManager testee;

  setUp(() {
    mockStoreService = MockStoreService();
    testee = TestSettingManager(mockStoreService);
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
    expect((() => TestCannotEnableSettingManager(mockStoreService).isEnabled = true), throwsAssertionError);
  });
}
