part of 'toggler_service.dart';

@lazySingleton
class HapticTogglerService extends TogglerService {
  HapticTogglerService(super.sharedPreferences);

  @override
  get _storeKey => 'isEnabled.haptic';

  @override
  bool get isAvailable => true;

  @override
  String get title => 'Interaction';

  @override
  String get subtitle => isAvailable ? 'Vibrate on tap or scroll.' : 'Vibration is not available on this device.';
}
