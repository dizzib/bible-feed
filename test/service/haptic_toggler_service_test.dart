import 'package:bible_feed/service/haptic_availability_service.dart';
import 'package:bible_feed/service/haptic_toggler_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'haptic_toggler_service_test.mocks.dart';

@GenerateNiceMocks([MockSpec<HapticAvailabilityService>(), MockSpec<SharedPreferences>()])
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  late MockSharedPreferences mockSharedPreferences;
  late HapticTogglerService testee;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    final mockHapticAvailabilityService = MockHapticAvailabilityService();
    when(mockHapticAvailabilityService.isAvailable).thenReturn(true);
    testee = HapticTogglerService(mockSharedPreferences, mockHapticAvailabilityService);
  });

  test('default isEnabled is false', () async {
    expect(testee.isEnabled, false);
  });

  test('isEnabled getter returns stored value', () {
    when(mockSharedPreferences.getBool('isEnabled.haptic')).thenReturn(true);
    expect(testee.isEnabled, true);
  });

  test('isEnabled setter stores value and notifies listeners', () {
    var notified = false;
    testee.addListener(() {
      notified = true;
    });
    testee.isEnabled = true;
    expect(notified, true);
    verify(mockSharedPreferences.setBool('isEnabled.haptic', true)).called(1);
  });

  test('isAvailable returns true', () {
    expect(testee.canEnable, true);
  });

  test('title and subtitle getters', () {
    expect(testee.title, 'Haptic Feedback');
    expect(testee.subtitle, 'Vibrate on tap or select.');
  });
}
