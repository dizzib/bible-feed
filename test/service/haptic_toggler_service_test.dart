import 'package:bible_feed/service/haptic_toggler_service.dart';
import 'package:bible_feed/service/haptic_availability_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockHapticAvailabilityService extends Mock implements HapticAvailabilityService {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  late MockSharedPreferences mockSharedPreferences;
  late MockHapticAvailabilityService mockHapticAvailabilityService;
  late HapticTogglerService testee;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    mockHapticAvailabilityService = MockHapticAvailabilityService();
    when(() => mockSharedPreferences.getBool(any())).thenReturn(null);
    when(() => mockHapticAvailabilityService.isAvailable).thenReturn(true);
    testee = HapticTogglerService(mockSharedPreferences, mockHapticAvailabilityService);
  });

  test('default isEnabled is false', () async {
    expect(testee.isEnabled, false);
  });

  test('isEnabled getter returns stored value', () {
    when(() => mockSharedPreferences.getBool('isEnabled.haptic')).thenReturn(true);
    expect(testee.isEnabled, true);
  });

  test('isEnabled setter stores value and notifies listeners', () {
    var notified = false;
    testee.addListener(() {
      notified = true;
    });
    when(() => mockSharedPreferences.setBool(any(), any())).thenAnswer((_) async => true);
    testee.isEnabled = true;
    expect(notified, true);
    verify(() => mockSharedPreferences.setBool('isEnabled.haptic', true)).called(1);
  });

  test('isAvailable returns true', () {
    expect(testee.canEnable, true);
  });

  test('title and subtitle getters', () {
    expect(testee.title, 'Haptic Feedback');
    expect(testee.subtitle, 'Vibrate on tap or select.');
  });
}
