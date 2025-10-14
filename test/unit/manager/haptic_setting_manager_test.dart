import 'package:bible_feed/manager/haptic_setting_manager.dart';
import 'package:bible_feed/service/haptic_availability_service.dart';
import 'package:bible_feed/service/store_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'haptic_setting_manager_test.mocks.dart';

class TestHapticAvailabilityService extends HapticAvailabilityService {
  TestHapticAvailabilityService() : super(isHapticAvailable: true);
}

@GenerateNiceMocks([MockSpec<StoreService>()])
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  late MockStoreService mockStoreService;
  late HapticSettingManager testee;

  setUp(() {
    mockStoreService = MockStoreService();
    testee = HapticSettingManager(mockStoreService, TestHapticAvailabilityService());
  });

  test('default isEnabled is false', () async {
    expect(testee.isEnabled, false);
  });

  test('isEnabled getter returns stored value', () {
    when(mockStoreService.getBool('isEnabled.haptic')).thenReturn(true);
    expect(testee.isEnabled, true);
  });

  test('isEnabled setter stores value and notifies listeners', () {
    var notified = false;
    testee.addListener(() {
      notified = true;
    });
    testee.isEnabled = true;
    expect(notified, true);
    verify(mockStoreService.setBool('isEnabled.haptic', true)).called(1);
  });

  test('isAvailable returns true', () {
    expect(testee.canEnable, true);
  });

  test('title and subtitle getters', () {
    expect(testee.title, 'Haptic Feedback');
    expect(testee.subtitle, 'Vibrate on tap or select.');
  });
}
