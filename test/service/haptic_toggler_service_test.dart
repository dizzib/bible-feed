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
  late HapticTogglerService service;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    mockHapticAvailabilityService = MockHapticAvailabilityService();
    when(() => mockSharedPreferences.getBool(any())).thenReturn(null);
    when(() => mockHapticAvailabilityService.isAvailable).thenReturn(true);
    service = HapticTogglerService(mockSharedPreferences, mockHapticAvailabilityService);
  });

  test('default isEnabled is false', () async {
    expect(service.isEnabled, false);
  });

  test('isEnabled getter returns stored value', () {
    when(() => mockSharedPreferences.getBool('isEnabled.haptic')).thenReturn(true);
    expect(service.isEnabled, true);
  });

  test('isEnabled setter stores value and notifies listeners', () {
    var notified = false;
    service.addListener(() {
      notified = true;
    });

    when(() => mockSharedPreferences.setBool(any(), any())).thenAnswer((_) async => true);
    service.isEnabled = true;

    verify(() => mockSharedPreferences.setBool('isEnabled.haptic', true)).called(1);
    expect(notified, true);
  });

  test('isAvailable returns true', () {
    expect(service.canEnable, true);
  });

  test('title and subtitle getters', () {
    expect(service.title, 'Haptic Feedback');
    expect(service.subtitle, 'Vibrate on tap or select.');
  });
}
